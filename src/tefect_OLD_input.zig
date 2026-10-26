// This file will be deleted after several things are verified.


comptime {
    if (@import("builtin").os.tag == .windows) @compileError("Not for Windows");
}

const std = @import("std");
const builtin = @import("builtin");
const tefect_buffer = @import("tefect_buffer.zig");

const err = std.log.err;
const exit = std.process.exit;
const SourceLocation = std.builtin.SourceLocation;
const stdin = std.fs.File.stdin();
const utf8Decode2 = std.unicode.utf8Decode2;
const utf8Decode3 = std.unicode.utf8Decode3;
const utf8Decode4 = std.unicode.utf8Decode4;

const KEY_UP_ARROW: u32 = 0x1B5B41;
const KEY_DOWN_ARROW: u32 = 0x1B5B42;
const KEY_RIGHT_ARROW: u32 = 0x1B5B43;
const KEY_LEFT_ARROW: u32 = 0x1B5B44;

const KEY_Home: u32 = 0x1b5b72;
const KEY_End: u32 = 0x1b5b70;

const KEY_F1: u32 = 0x1b4f50;
const KEY_F2: u32 = 0x1b4f51;
const KEY_F3: u32 = 0x1b4f52;
const KEY_F4: u32 = 0x1b4f53;

const KEY_Insert: u32 = 0x1b5b27e;  
const KEY_Delete: u32 = 0x1b5b37e;  
const KEY_PageUp: u32 = 0x1b5b57e;  
const KEY_PageDown: u32 = 0x1b5b67e;

const KEY_F5: u32 = 0x1b5b157f;
const KEY_F6: u32 = 0x1b5b177f;
const KEY_F7: u32 = 0x1b5b187f;
const KEY_F8: u32 = 0x1b5b197f;

const KEY_F9: u32 = 0x1b5b207f;
const KEY_F10: u32 = 0x1b5b217f;
const KEY_F11: u32 = 0x1b5b237f;
const KEY_F12: u32 = 0x1b5b247f;

const UnknownSequence: u32 = 0x1b1b1b;


fn ThreeByteParser(bytes: [3]u8) u32 {
    if (bytes[0] == 0x1b) {
        if (bytes[1] == 0x5b) {
            switch (bytes[2]) {
                0x42 => return KEY_DOWN_ARROW, 
                0x43 => return KEY_RIGHT_ARROW,
                0x41 => return KEY_UP_ARROW,   
                0x44 => return KEY_LEFT_ARROW, 
                0x46 => return KEY_End,
                0x48 => return KEY_Home,
                else => return UnknownSequence
            }
        }         
        else if (bytes[1] == 0x4f) {
            switch (bytes[2]) {
                0x50 => return KEY_F1,
                0x51 => return KEY_F2,
                0x52 => return KEY_F3,
                0x53 => return KEY_F4,
                else => return UnknownSequence
            }            
        } else return @as(u32, utf8Decode3(bytes)) catch UnknownSequence;
    } else return @as(u32, utf8Decode3(bytes)) catch UnknownSequence;
}


fn FourByteParser(bytes: [4]u8) u32 {
    if (bytes[0] == 0x1b and bytes[1] == 0x5b and bytes[3] == 0x7e) {
        switch (bytes[2]) {
            0x33 => return KEY_Delete, 
            0x36 => return KEY_PageDown,
            0x35 => return KEY_PageUp, 
            0x32 => return KEY_Insert,     
            else => return UnknownSequence     
        }
    } else return @as(u32, utf8Decode4(bytes)) catch UnknownSequence;
}

fn FiveByteParser(bytes: [5]u8) u32 {
    if (bytes[0] == 0x1b and bytes[1] == 0x5b and bytes[4] == 0x7e) {
        if (bytes[2] == 0x31) {
            switch (bytes[3]) {
                0x35 => return KEY_F5,
                0x37 => return KEY_F6,
                0x38 => return KEY_F7,
                0x39 => return KEY_F8,
                else => return UnknownSequence
            }
        }
        else if (bytes[2] == 0x32) {
            switch (bytes[3]) {
                0x30 => return KEY_F9, 
                0x31 => return KEY_F10,
                0x33 => return KEY_F11,
                0x34 => return KEY_F12,
                else => return UnknownSequence
            }
        } else return UnknownSequence;
    } else return UnknownSequence;
}


//                                    
//                          #--[1 byte]--> [ cast & direct return ]
//                          |         
//                          |
//                          |              
//                          #--[2 byte]--> [ cast ( directly passed to utf8decoder ) ]
//                          |              
//                          |
//  #-----------------#     |              #-------------------#
//  | ReadInputByte() | ----#--[3 byte]--> | ThreeByteParser() |
//  #-----------------#     |              #-------------------#
//                          |        
//                          |              #------------------#
//                          #--[4 byte]--> | FourByteParser() |
//                          |              #------------------#
//                          |
//                          |              #------------------#
//                          #--[5 byte]--> | FiveByteParser() |
//                                         #------------------#

pub fn ReadInputBytes(bufferhandle: *BufferHandle) u32 {

    const Static = struct {
        var Len: usize = undefined;
    };

    const bufferheader = Handle2Header(bufferhandle);

    Static.Len = stdin.read(bufferheader.TempBuffer) catch |er| {
        Terminate(bufferhandle, @src(), "Failed to read from stdin", er, false);
    };

    return switch (Static.Len) {
        1 => bufferheader.TempBuffer[0],
        2 => @as(u8, utf8Decode2(bufferheader.TempBuffer[0..2])) catch UnknownSequence,
        3 => ThreeByteParser(bufferheader.TempBuffer[0..3]),
        4 => FourByteParser(bufferheader.TempBuffer[0..4]),
        5 => FiveByteParser(bufferheader.TempBuffer[0..5]),
        else => UnknownSequence
    };
}





//pub export fn ReadInputByte(bufferhandle: *BufferHandle) u32 {
//
//    const Static = struct {
//        var Len: usize = undefined;
//    };
//
//    const bufferheader = Handle2Header(bufferhandle);
//
//    Static.Len = read(&bufferheader.TempBuffer) catch |er| {
//        Terminate(bufferhandle, @src(), "Failed to read from stdin", er, false);
//    };
//
//    return switch (Static.Len) {
//        1 => bufferheader.TempBuffer[0],
//        3 => block: {
//            if (bufferheader.TempBuffer[0] == 0x1b and bufferheader.TempBuffer[1] == 0x5b) {
//                break :block ConvertToArrowByte(bufferhandle, bufferheader.TempBuffer[2]);
//            } else {
//                Terminate(bufferhandle, @src(), "Unspported", null, false);
//            }
//        },
//        else => {//
//            Terminate(bufferhandle, @src(), "Unspported", null, false);
//        },
//    };
//}