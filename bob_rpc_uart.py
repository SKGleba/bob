# stolen from teensy4vfi

import sys, struct
import serial

DEFAULT_PORT = 'COM6'                   # bob
DEFAULT_BAUD = 115200                   # default bob debug uart baud

RPC_MAGIC = b'&'                        # byte indicating we are talking to bob
RPC_WATERMARK = b'?PC_'                 # prefix indicating bob is replying to us
RPC_COMMANDS = {                        # supported RPC commands & short descriptions
    "ping" : [0x0, "get rpc server firmware build timestamp", ""],
    "read32" : [0x1, "read 32bits from a memory address", "[address]"],
    "write32" : [0x2, "write 32bits to a memory address", "[address] [data]"],
    "memset" : [0x3, "fill a memory range (8bit)", "[start] [fill] [size]"],
    "memcpy" : [0x4, "copy a memory range to another address", "[dst] [src] [size]"],
    "delay" : [0x5, "set rpc server reply delay", "[delay]"],
    "stop" : [0x6, "stop the rpc server", ""],
    "hexdump" : [0x8, "print a memory range (hex)", "[address] [size] <print line addr?>"],
    "memset32" : [0x9, "fill a memory range (32bit)", "[start] [fill] [size]"],
    "set_uart_mode" : [0xf, "enable/disable RPC uart mode", "[enable] <scan timeout>"],
}

uart = serial.Serial(DEFAULT_PORT, baudrate=DEFAULT_BAUD, timeout=1)

def send_rpc_cmd(id, argv):
    data = bytearray()
    for arg in argv:
        data.extend(struct.pack('<I', arg))
    headr = bytearray([int.from_bytes(RPC_MAGIC, "little"), RPC_COMMANDS[id][0], len(data), (RPC_COMMANDS[id][0] + len(data))])
    print(headr.hex().upper())
    print(data.hex().upper())
    uart.reset_output_buffer()
    uart.reset_input_buffer()
    uart.write(headr)
    cont = uart.readline()
    while not RPC_WATERMARK in cont:
        cont = uart.readline()
    if cont == RPC_WATERMARK + b'G1\r\n':
        uart.write(data)
        cont = uart.readline()
        while not RPC_WATERMARK in cont:
            cont = uart.readline()
    cont = cont.decode('utf-8').strip("?PC_")
    print(cont)

# "ui design is my passion" xD
def helper(focus):
    match focus:
        case "none":
            print(f"{'CMD':>24}" + " : " + "DESCRIPTION")
            print(f"{'---':>24}" + " : " + "-----------")
            for cmd in RPC_COMMANDS:
                print(f"{cmd:>24}" + " : " + RPC_COMMANDS[cmd][1])
            print(f"{' ':>24}" + " ! " + " ")
            print(f"{'help <CMD>':>24}" + " : " + "show me or CMD's expected args")
        case _:
            if focus in RPC_COMMANDS:
                print("\nUsage: " + focus + " " + RPC_COMMANDS[focus][2] + "\n")
                print("Descr: " + RPC_COMMANDS[focus][1] + "\n")
            else:
                print("command not found and/or malformed input")
    return ""


def handle_cmd(cmd, argv):
    match cmd:
        case "help":
            if len(argv) > 0:
                return helper(argv[0])
            return helper("none")
        case _:
            if cmd in RPC_COMMANDS:
                rargv = []
                for arg in argv:
                    if arg.startswith('0x'):
                        rargv.append(int(arg, 16))
                    else:
                        rargv.append(int(arg))
                return send_rpc_cmd(cmd, rargv)
            else:
                print("command not found and/or malformed input")
    return ""

if __name__ == "__main__":
    if len(sys.argv) > 1:
        handle_cmd(sys.argv[1], sys.argv[2:])
    else:
        helper("none")
    uart.close()