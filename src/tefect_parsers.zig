const std = @import("std");

const ConsoleEvent = @import("tefect_input.zig").ConsoleEvent;
const TefectError = @import("tefect_buffer.zig").TefectError;
const Keys = @import("tefect_keys.zig");
const tefect_utf = @import("tefect_utf.zig");

const Windows = @import("builtin").os.tag == .windows;


inline fn UnknownValuePanic(src: std.builtin.SourceLocation, Value: u8) noreturn {
    std.debug.panic(
        "Tefect: (PANIC) Zig:{s}.{s} -> Unknown Value: {d}.",
        .{std.fs.path.stem(src.file), src.fn_name, Value}
    );
}
 
inline fn TrueSectionInBuffer2Byte(byte: u8) ConsoleEvent {
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
                else => UnknownValuePanic(@src(), byte)
            }  
        }
    }; 
}

inline fn FalseSectionInBuffer2Byte(byte: u8) ConsoleEvent {
    if (Windows) {
        if (byte == 77) {
            // mouse section
        }
    }

    return ConsoleEvent {
        .Type = .FoucsEvent,
        .Event = .{ 
            .Foucs = switch (byte) {
                79 => FoucsEvent.FocusOut,
                73 => FoucsEvent.FocusIn,
                else => UnknownValuePanic(@src(), byte)
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
                else => UnknownValuePanic(@src(), byte)
            }
        }
    };
}


pub fn ThreeByteParser(buffer: [3]u8) TefectError!ConsoleEvent {
    if (buffer[0] == 27) {
        if (buffer[1] == 91) {
            return if (!buffer[2] >= 73) TrueSectionInBuffer2Byte(buffer[2]) else FalseSectionInBuffer2Byte(buffer[2]);
        }
        else if (buffer[1] == 79) {
            return F1_4CharacterSwitch(buffer[2]);
        }
    } else if (tefect_utf.Is3ByteLead(buffer[0])) {
        return ConsoleEvent {
            .Type = .CharacterEvent,
            .Event = .{
                .Character = try tefect_utf.TreeByteUtf8Decoder(buffer)
            }
        };
    } else return TefectError.UnexpectedError;
}