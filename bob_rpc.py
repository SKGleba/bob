import sys
import time
import bert

RPC_MAGIC = 0xEB0B
RPC_FLAG_REPLY = 0b10000000 # data is bob reply
RPC_FLAG_EXTRA = 0b01000000 # use extra_data
RPC_READ_DELAY = 0x1000
RPC_WRITE_DELAY = 0x80
RPC_COMMANDS = {
    "ping" : 0x0,
    "read32" : 0x1,
    "write32" : 0x2,
    "memset" : 0x3,
    "memcpy" : 0x4,
    "delay" : 0x5, # arg0 : check delay | arg1 : reply delay
    "stop" : 0x6,
    "push" : 0x7, # dont use this
    "hexdump" : 0x8,
    "memset32" : 0x9,
    "arm_reset" : 0xa,
    "set_xctable" : 0xb,
    "set_ints" : 0xc,
    "alice_rpc" : 0xd,
    "alice_task_status" : 0xe,
    "set_uart_mode" : 0xf,
    "dram_init" : 0x10,
    "copyto" : 0x40,
    "copyfrom" : 0x41,
    "exec" : 0x42, # exec arg0(arg1, arg2, &extra) | ret to arg0
    "execbig" : 0x43, # exec arg0(extra32[X], extra32[X+1], extra32[X+2], extra32[X+3]) | rets to argX
    "alice_schedule_bob_task" : 0x44,
    "alice_load_direct" : 0x45
}


RPC_FAST_DELAY = 0x80
RPC_CMD_SIZE = 0x10
RPC_EXTRA_DATA_SIZE = 0x18
RPC_BUF_SIZE = RPC_CMD_SIZE + RPC_EXTRA_DATA_SIZE
RPC_HASHED_DATA_SIZE = RPC_CMD_SIZE - 3

RPC_REPLY_FETCH_DELAY = 64 / 1000 # TODO: should we?

silent_mode = 1
wait4push = 0

def swapstr32(si):
    return si[6:8] + si[4:6] + si[2:4] + si[0:2]

def print_cmd(pinfo, cmd):
    cmd_arr = [cmd[i:i+8] for i in range(0, len(cmd), 8)]
    xdata = ""
    if int(cmd_arr[0][6:8], 16) & RPC_FLAG_EXTRA:
        xdata = cmd[32:]
    print(pinfo + " 0x" + swapstr32(cmd_arr[1]) + " 0x" + swapstr32(cmd_arr[2]) + " 0x" + swapstr32(cmd_arr[3]) + " [ " + xdata + " ] <0x" + cmd_arr[0][6:8] + ">")

def exec_cmd(cmd_base):
    global wait4push

    base_arr = bytearray.fromhex(cmd_base)
    if len(base_arr) > RPC_HASHED_DATA_SIZE + RPC_EXTRA_DATA_SIZE:
        print("CMD is too long : " + cmd_base)

    csum=0
    for x in base_arr[:RPC_HASHED_DATA_SIZE]:
        csum = (csum + x) & 0xFF
    request = "0BEB" + "{:02X}".format(int(csum)) + cmd_base
    if silent_mode == 0:
        print("RPC: " + request)
    elif silent_mode != 2:
        print_cmd("RPC", request)

    bert.handle_cmd("lock-1", ["","",0])
    bert.handle_cmd("shbuf-write", ["", "", request])
    bert.handle_cmd("unlock-1", ["","",0])

    if wait4push:
        line = bert.client.get_resp()
    else:
        while True:
            time.sleep(RPC_REPLY_FETCH_DELAY)
            bert.client.send_cmd(bytearray.fromhex("0103000000"), 0)
            line = bert.client.get_resp()
            if line[8] & RPC_FLAG_REPLY:
                break

    if bert.silent_mode != 2:
        bert.print_packet("RESP", line.hex().upper(), False)
    if silent_mode == 0:
        print("BOB: " + line.hex()[10:-4].upper())
    elif silent_mode != 2:
        print_cmd("BOB", line.hex()[10:-4].upper())

    return line.hex()[10:-4].upper()


def handle_cmd(user_cmd, argv):
    global wait4push
    match user_cmd:
        case "file_send": # arg0 = dst, arg1 = src, arg2 = skip_to (opt)
            prev_delay = "0x" + swapstr32(str(handle_cmd("delay", ["0x{:08X}".format(RPC_FAST_DELAY), "0x{:08X}".format(RPC_WRITE_DELAY)]))[8:16])
            offset = int(argv[0][2:], 16)
            copied = 0 
            if len(argv) > 2:
                copied = int(argv[2][2:], 16)
            with open(argv[1], 'rb') as fp:
                if copied > 0:
                    fp.seek(copied)
                while True:
                    xdata = fp.read(RPC_EXTRA_DATA_SIZE)
                    if xdata == b'':
                        break
                    handle_cmd("copyto", ["0x{:08X}".format(offset + copied), "0x{:08X}".format(len(xdata)), bytearray(xdata).hex().upper()])
                    copied += len(xdata)
            return handle_cmd("delay", [prev_delay, "0x{:08X}".format(RPC_WRITE_DELAY)])
        case "file_append": # arg0 = dst, arg1 = src, arg2 = size
            prev_delay = "0x" + swapstr32(str(handle_cmd("delay", ["0x{:08X}".format(RPC_FAST_DELAY), "0x{:08X}".format(RPC_WRITE_DELAY)]))[8:16])
            offset = int(argv[1][2:], 16)
            full_size = int(argv[2][2:], 16)
            with open(argv[0], 'ab') as fp:
                for x in range(0, full_size, RPC_EXTRA_DATA_SIZE):
                    size = RPC_EXTRA_DATA_SIZE
                    if x + RPC_EXTRA_DATA_SIZE > full_size:
                        size = full_size - x
                    fp.write(bytearray.fromhex(handle_cmd("copyfrom", ["0x{:08X}".format(offset + x), "0x{:08X}".format(int(size))]))[RPC_CMD_SIZE:])
            return handle_cmd("delay", [prev_delay, "0x{:08X}".format(RPC_WRITE_DELAY)])
        case "file_dump": # arg0 = dst, arg1 = src, arg2 = size
            fp = open(argv[0], 'wb')
            fp.close
            return handle_cmd("file_append", argv)
        case "push_reply":
            wait4push = int(argv[0][2:], 16)
            return handle_cmd("push", argv)
        case "exece":
            cv_argv = ["0x0", "0x0", "0x0", ""]
            for x,arg in enumerate(argv):
                if x < 3:
                    cv_argv[x] = argv[x]
                else:
                    cv_argv[3] += swapstr32("{:08X}".format(int(argv[x][2:], 16)))
            cv_argv[3] = cv_argv[3].ljust(48, "0")
            return handle_cmd("execbig", cv_argv)
        case "alice_schedule_task":
            cv_argv = ["0x0", "0x0", "0x0", ""]
            for x,arg in enumerate(argv):
                if x < 3:
                    cv_argv[x] = argv[x]
                else:
                    cv_argv[3] += swapstr32("{:08X}".format(int(argv[x][2:], 16)))
            cv_argv[3] = cv_argv[3].ljust(40, "0")
            return handle_cmd("alice_schedule_bob_task", cv_argv)
        case "alice_load":
            cv_argv = ["0x0", "0x0", "0x0", ""]
            for x,arg in enumerate(argv):
                if x < 3:
                    cv_argv[x] = argv[x]
                else:
                    cv_argv[3] += swapstr32("{:08X}".format(int(argv[x][2:], 16)))
            cv_argv[3] = cv_argv[3].ljust(32, "0")
            return handle_cmd("alice_load_direct", cv_argv)
        case _:
            if user_cmd in RPC_COMMANDS:
                cv_argv = ["0x0", "0x0", "0x0", ""]
                for x, arg in enumerate(argv):
                    if arg[0:2] == "0x":
                        cv_argv[x] = arg
                    else:
                        cv_argv[3] = arg
                        break
                return exec_cmd("{:02X}".format(RPC_COMMANDS[user_cmd]) + swapstr32("{:08X}".format(int(cv_argv[0][2:], 16))) + swapstr32("{:08X}".format(int(cv_argv[1][2:], 16))) + swapstr32("{:08X}".format(int(cv_argv[2][2:], 16))) + cv_argv[3])
            else:
                print("command not found and/or malformed input")
    return ""


def helper(in_interactive, caller):
    print("bob commands:")
    print(caller + " raw [CMD_ID] <ARGS>                         : send a raw bob rpc command, adds checksum & magic")
    print(caller + " ping                                        : ping bob")
    print(caller + " read32 [OFF]                                : read u32 from given offset")
    print(caller + " write32 [OFF] [DATA]                        : write u32 to given offset")
    print(caller + " memset [OFF] [FILLu8] [SIZE]                : memset")
    print(caller + " memset32 [OFF] [FILLu32] [SIZE]             : memset (32-bit)")
    print(caller + " memcpy [DST] [SRC] [SIZE]                   : memcpy")
    print(caller + " delay [READ] [WRITE]                        : set RPC server check and reply delays")
    print(caller + " stop                                        : stop the RPC server")
    print(caller + " hexdump [OFF] [SIZE] [SHOW_ADDR?]           : hexdump to bob stdout, show_addr should be 0x0/0x1")
    print(caller + " copyto [OFF] [SIZE] [DATA]                  : write data to offset, max size 0x18 (=0x30 ascii)")
    print(caller + " copyfrom [OFF] [SIZE]                       : read data from offset, max size 0x18")
    print(caller + " exec [OFF] <ARG0> <ARG1> <EXTRA_DATA>       : run off(arg0, arg1, &extra_data)")
    print("extended commands:")
    print(caller + " file_send [OFF] [FILE]                      : write file data to offset")
    print(caller + " file_dump [FILE] [OFF] [SIZE]               : dump data to file (replace)")
    print(caller + " file_append [FILE] [OFF] [SIZE]             : dump data to file (append)")
    print("")
    if in_interactive:
        print("client commands:")
        print(caller + " !exit                                       : exit the client")
        print(caller + " !open [PORT] [BAUDRATE]                     : open & use PORT")
        print(caller + " !close                                      : close currently used port")
        print(caller + " !wait                                       : wait for bob to send something")
        print(caller + " !bert-silent                                : toggle bert verbose level, argument '2' sets 'none'")
        print(caller + " !silent                                     : toggle verbose level, argument '2' sets 'none'")
    else:
        print("client commands:")
        print(caller + " !i                                          : enter an interactive session")

def interactive():
    global silent_mode
    print("\nWelcome to interactive mode")
    print("use !help to display usage info")
    while 1:
        print("")
        uinput = input('> ')
        uinput_argv = uinput.split()
        uinput_argv.insert(0, "interactive")
        cmd = uinput_argv[1]
        match cmd:
            case "!help":
                helper(True, ">")
            case "!exit":
                break
            case "!open":
                try:
                    bert.client.open(uinput_argv[2], int(uinput_argv[3]))
                except Exception as e:
                    print(e)
            case "!close":
                bert.client.close()
            case "!wait":
                if bert.client.is_open == True:
                    try:
                        line = bert.client.get_resp()
                        if silent_mode != 2:
                            print("BOB: " + line.hex()[10:-4].upper())
                    except Exception as e:
                        print(e)
                    except KeyboardInterrupt:
                        pass
                else:
                    print("port not open!")
            case "!bert-silent":
                if len(uinput_argv) == 2:
                    bert.silent_mode = not bert.silent_mode
                else:
                    bert.silent_mode = int(uinput_argv[2])
            case "!silent":
                if len(uinput_argv) == 2:
                    silent_mode = not silent_mode
                else:
                    silent_mode = int(uinput_argv[2])
            case _:
                try:
                    handle_cmd(cmd, uinput_argv[2:])
                except KeyboardInterrupt:
                    pass
                except Exception as e:
                    print(e)

if __name__ == "__main__":
    uinput_argv = sys.argv

    if len(uinput_argv) == 1:
        helper(False, uinput_argv[0])
        exit(0)
       
    cmd = uinput_argv[1]

    bert.silent_mode = 2

    if cmd[:1] == "!":
        interactive()
    else:
        try:
            handle_cmd(cmd, uinput_argv[2:])
        except KeyboardInterrupt:
            pass
        except Exception as e:
            print(e)
    
    bert.client.close()