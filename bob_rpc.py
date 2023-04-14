import bert

RPC_MAGIC = 0xEB0B
RPC_FLAG_REPLY = 0b10000000 # data is bob reply
RPC_FLAG_EXTRA = 0b01000000 # use extra_data
RPC_COMMANDS = {
    "nop" : 0x0,
    "read32" : 0x1,
    "write32" : 0x2,
    "memset" : 0x3,
    "memcpy" : 0x4,
    "delay" : 0x5,
    "stop" : 0x6,
    "replypush" : 0x7,
    "copyto" : 0x40,
    "copyfrom" : 0x41,
    "exec" : 0x42, # exec arg0(arg1, arg2, &extra) | ret to arg0
    "execbig" : 0x43 # exec arg0(extra32[X], extra32[X+1], extra32[X+2], extra32[X+3]) | rets to argX
}

silent_mode = 1

def swapstr32(si):
    return si[6:8] + si[4:6] + si[2:4] + si[0:2]

def print_cmd(pinfo, cmd):
    cmd_arr = [cmd[i:i+8] for i in range(0, len(cmd), 8)]
    print(pinfo + " 0x" + swapstr32(cmd_arr[1]) + " 0x" + swapstr32(cmd_arr[2]) + " 0x" + swapstr32(cmd_arr[3]) + " [ " + cmd[32:] + " ] <0x" + cmd_arr[0][6:8] + ">")

def exec_cmd(cmd_base):
    base_arr = bytearray.fromhex(cmd_base)
    csum=0
    for x in base_arr:
        csum = (csum + x) & 0xFF
    cmd_la = [0, 0, 0]
    bert.handle_cmd("lock-1", cmd_la)
    request = "0BEB" + "{:02X}".format(int(csum)) + cmd_base
    if silent_mode == 0:
        print("RPC: " + request)
    elif silent_mode != 2:
        print_cmd("RPC", request)

    cmd_ba = ["> ", "shbuf-write", request]
    bert.handle_cmd("shbuf-write", cmd_ba)

    bert.handle_cmd("unlock-1", cmd_la)
    line = bert.client.get_resp()
    if bert.silent_mode != 2:
        bert.print_packet("RESP", line.hex().upper(), False)
    if silent_mode == 0:
        print("BOB: " + line.hex()[10:-4].upper())
    elif silent_mode != 2:
        print_cmd("BOB", line.hex()[10:-4].upper())
    

def handle_cmd(user_cmd, argv):
    cv_argv = ["BAD", "BAD", "0x0", "0x0", "0x0", ""]
    for x, arg in enumerate(argv):
        cv_argv[x] = arg
    match user_cmd:
        case "mynop":
            exec_cmd("{:02X}".format(0) + swapstr32("{:08X}".format(0)) + swapstr32("{:08X}".format(0)) + swapstr32("{:08X}".format(0)))
        case _:
            exec_cmd("{:02X}".format(RPC_COMMANDS[user_cmd]) + swapstr32("{:08X}".format(int(cv_argv[2][2:], 16))) + swapstr32("{:08X}".format(int(cv_argv[3][2:], 16))) + swapstr32("{:08X}".format(int(cv_argv[4][2:], 16))) + cv_argv[5])


def helper(caller): # todo
    print("bob commands:")
    print(caller + " raw [CMD_ID] <ARGS>                         : send a raw bob rpc command, only adds checksum")
    print(caller + " nop                                         : ping bob")

def interactive():
    global silent_mode
    print("\nWelcome to interactive mode")
    print("use !help to display usage info")
    bert.silent_mode = 2
    while 1:
        print("")
        uinput = input('> ')
        uinput_argv = uinput.split()
        uinput_argv.insert(0, "interactive")
        cmd = uinput_argv[1]
        match cmd:
            case "!help":
                helper(">")
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
                    handle_cmd(cmd, uinput_argv)
                except KeyboardInterrupt:
                    pass
                except Exception as e:
                    print(e)

if __name__ == "__main__":
    interactive()
    bert.client.close()