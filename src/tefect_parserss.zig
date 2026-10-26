const std = @import("std");

const tefect_input = @import("tefect_input.zig");
const tefect_mouse = @import("tefect_mouse.zig");
const tefect_console = @import("tefect_console.zig");

const TefectError = @import("tefect_buffer.zig").TefectError;
const ConsoleEvent = @import("tefect_input.zig").ConsoleEvent;
const BufferHeader = @import("tefect_buffer.zig").BufferHeader;
const Keys = @import("tefect_keys.zig");


const Windows = @import("builtin").os.tag == .windows;


// change the panic error to 


fn UnknownValuePanic(src: std.builtin.SourceLocation, Value: u8, Index: u8) noreturn {
    std.debug.panic(
        "Tefect: (PANIC) Zig:{s}.{s} -> Unknown Value: {d}, Index: {d}.",
        .{std.fs.path.stem(src.file), src.fn_name, Value, Index}
    );
}



// old parser desin is right
inline fn TrueSectionInBuffer2Byte(bufferheader: *BufferHeader) ConsoleEvent {

    if (Windows) {
        if (bufferheader.ReadingBuffer[2] == 77) {
            const len = try tefect_input.Read(bufferheader.ReadingBuffer[3..]);
            if (len == 3) {

                return ConsoleEvent {
                    .Type = .MouseEvent,
                    .Event = .{
                        .Mouse = tefect_mouse.WindowsNoCheck3ByteMouseEventParser(bufferheader[3..6])
                    }
                };

            } else {
                bufferheader.Free();
                UnknownValuePanic(@src(), @intCast(len), 1);
            }
        }
    }

    return ConsoleEvent {
        .Type = .FoucsEvent,
        .Event = .{
            .Foucs = switch (bufferheader.ReadingBuffer[2]) {
                79 => tefect_console.FocusEvent.FocusOut,
                73 => tefect_console.FocusEvent.FocusIn,
                else => {
                    bufferheader.Free();
                    UnknownValuePanic(@src(), bufferheader.ReadingBuffer[2], 2);
                }
            }
        }
    };
}

inline fn FalseSectionInBuffer2Byte(byte: u8) ConsoleEvent {
        return ConsoleEvent {
        .Type = .CharacterEvent,
        .Event = .{
             .Character = switch (byte) {
                66 => Keys.DownArrow,
                67 => Keys.RightArrow,
                65 => Keys.UpArrow,
                68 => Keys.LeftArrow,
                70 => Keys.End,
                72 => Keys.Home,
                else => UnknownValuePanic(@src(), byte, 0)
            }  
        }
    }; 

}


inline fn F1_4CharacterSwitch(byte: u8) ConsoleEvent {
    return ConsoleEvent {
        .Type = .CharacterEvent,
        .Event = .{
            .Character = switch (byte) {
                81 => Keys.F2,
                82 => Keys.F3,
                83 => Keys.F4,
                80 => Keys.F1,
                else => UnknownValuePanic(@src(), byte, 0)
            }
        }
    };
}



pub fn NormalThreeByteParser(bufferheader: *BufferHeader) TefectError!ConsoleEvent {
    if (bufferheader.ReadingBuffer[0] == 27) {
        
        switch (bufferheader.ReadingBuffer[1]) {

            91 => return if (bufferheader.ReadingBuffer[2] >= 73) TrueSectionInBuffer2Byte(bufferheader)
            else FalseSectionInBuffer2Byte(bufferheader.ReadingBuffer[2]),

            79 => F1_4CharacterSwitch(bufferheader.ReadingBuffer[2]),

            else => UnknownValuePanic(@src(), bufferheader.ReadingBuffer[1], 0)
        }

    } else {

        
        
        


    }
}