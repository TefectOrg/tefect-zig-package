const std = @import("std");
const builtin = @import("builtin");

const tefect_buffer = @import("tefect_buffer.zig");
const TefectError = tefect_buffer.TefectError;
const BufferHeader = tefect_buffer.BufferHeader;
const PasteType = tefect_buffer.PasteType;

const Keys = @import("tefect_keys.zig");
const CharacterType = Keys.CharacterType;

const tefect_console = @import("tefect_console.zig");
const FoucsEvent = tefect_console.FocusEvent;

const tefect_mouse = @import("tefect_mouse.zig");
const MouseEvent = @import("tefect_mouse.zig").MouseEvent;

const tefect_utf = @import("tefect_utf.zig");

const ReadError = std.posix.ReadError;
const Windows = builtin.os.tag == .windows;

//const winapi = if (Windows) @cImport({@cInclude("windows.h");}) else struct {};
//const MacOsIoctl = if (builtin.os.tag == .macos) @cImport({@cInclude("sys/ioctl.h");}) else struct {};


// use C:\mingw64\x86_64-w64-mingw32\include\consoleapi.h and C:\mingw64\x86_64-w64-mingw32\include\wincontypes.h
// to build the parsers.
// build the all structure Tree of the Input_Record
// than read using ReadInputConsoleW and input it into the tefect linking function


//pub fn HasRemainingData() TefectError!bool {
//
//    if (Windows) {
//        var NumberOfEvents: u32 = 0;
//        return if (
//            winapi.GetNumberOfConsoleInputEvents(
//                std.fs.File.stdin().handle,
//                &NumberOfEvents
//            ) != 0
//        ) NumberOfEvents > 0 else TefectError.FailedToQueryInput;
//    } else 
//
//    if (builtin.os.tag == .linux) {
//        var NumberOfBytes: i32 = 0;
//        return if (
//            @as(
//                isize, 
//                @bitCast(
//                    std.os.linux.ioctl(
//                        std.fs.File.stdin().handle,
//                        0x541B,
//                        @intFromPtr(&NumberOfBytes)
//                    )
//                )
//            ) < 0
//        ) TefectError.FailedToQueryInput else NumberOfBytes > 0;
//    } else
//
//    if (builtin.os.tag == .macos) {
//        // https://github.com/st3fan/osx-10.9/blob/master/emacs-92/emacs/mac/inc/sys/ioctl.h
//        var NumberOfBytes: c_int = 0;
//        return if (
//            MacOsIoctl.ioctl(std.fs.File.stdin().handle, 1, &NumberOfBytes) != -1
//        ) NumberOfBytes > 0 else TefectError.FailedToQueryInput;
//
//    } else @compileError("Unsupported Platform");
//}


const wincontypes = struct {

    // https://github.com/mingw-w64/mingw-w64/blob/master/mingw-w64-headers/include/wincontypes.h
    // https://learn.microsoft.com/en-us/windows/console/input-record-str

    const COORD = extern struct {
        X: i16, // SHORT
        Y: i16  // SHORT
    };


    const KEY_EVENT_RECORD = extern struct {
        bKeyDown: c_int,        // WINBOOL
        wRepeatCount: u16,      // WORD
        wVirtualKeyCode: u16,   // WORD
        wVirtualScanCode: u16,  // WORD
        uChar: extern union {
            UnicodeChar: u16,   // WCHAR
            AsciiChar: c_char   // CHAR
        },
        dwControlKeyState: u32  // DWORD
    };


    const RIGHT_ALT_PRESSED = 0x0001;
    const LEFT_ALT_PRESSED = 0x0002;
    const RIGHT_CTRL_PRESSED = 0x0004;
    const LEFT_CTRL_PRESSED = 0x0008;
    const SHIFT_PRESSED = 0x0010;
    const NUMLOCK_ON = 0x0020;
    const SCROLLLOCK_ON = 0x0040;
    const CAPSLOCK_ON = 0x0080;
    const ENHANCED_KEY = 0x0100;
    const NLS_DBCSCHAR = 0x00010000;
    const NLS_ALPHANUMERIC = 0x00000000;
    const NLS_KATAKANA = 0x00020000;
    const NLS_HIRAGANA = 0x00040000;
    const NLS_ROMAN = 0x00400000;
    const NLS_IME_CONVERSION = 0x00800000;
    const ALTNUMPAD_BIT = 0x04000000;
    const NLS_IME_DISABLE = 0x20000000;


    const MOUSE_EVENT_RECORD = extern struct {
        dwMousePosition: COORD,
        dwButtonState: u32,     // DWORD
        dwControlKeyState: u32, // DWORD
        dwEventFlags: u32       // DWORD
    };


    const FROM_LEFT_1ST_BUTTON_PRESSED = 0x0001;
    const RIGHTMOST_BUTTON_PRESSED = 0x0002;
    const FROM_LEFT_2ND_BUTTON_PRESSED = 0x0004;
    const FROM_LEFT_3RD_BUTTON_PRESSED = 0x0008;
    const FROM_LEFT_4TH_BUTTON_PRESSED = 0x0010;
    
    
    const MOUSE_MOVED = 0x0001;
    const DOUBLE_CLICK = 0x0002;
    const MOUSE_WHEELED = 0x0004;
    const MOUSE_HWHEELED = 0x0008;


    const WINDOW_BUFFER_SIZE_RECORD = extern struct {
        dwSize: COORD
    };

    const MENU_EVENT_RECORD = extern struct {
        dwCommandId: c_uint // UINT
    };

    const FOCUS_EVENT_RECORD = extern struct {
        bSetFocus: c_int // WINBOOL
    };


    const INPUT_RECORD = extern struct {
        EventType: u16, // WORD
        Event: extern union {
            KeyEvent: KEY_EVENT_RECORD,
            MouseEvent: MOUSE_EVENT_RECORD,
            WindowBufferSizeEvent: WINDOW_BUFFER_SIZE_RECORD,
            MenuEvent: MENU_EVENT_RECORD,
            FocusEvent: FOCUS_EVENT_RECORD
        }
    };

    const KEY_EVENT = 0x0001;
    const MOUSE_EVENT = 0x0002;
    const WINDOW_BUFFER_SIZE_EVENT = 0x0004;
    const MENU_EVENT = 0x0008;
    const FOCUS_EVENT = 0x0010;

};



pub fn Read(buffer: []u8) TefectError!usize {
    return std.fs.File.stdin().read(buffer) catch |er| switch (er) {
        ReadError.WouldBlock       => TefectError.NoDataForNow,
        ReadError.BrokenPipe       => TefectError.BrokenPipeError,
        ReadError.AccessDenied     => TefectError.AccessDeniedError,
        ReadError.SystemResources  => TefectError.SystemResourcesError,
        ReadError.OperationAborted => TefectError.OperationAbortedError,
        ReadError.Canceled         => TefectError.CanceledError,
        else                       => TefectError.UnexpectedError
    };
}

const ConsoleEventType = enum(u2) {
    CharacterEvent,
    FoucsEvent,
    MouseEvent,
    PasteEvent
};

pub const ConsoleEvent = packed struct {
    Type: ConsoleEventType,
    Event: packed union {
        Character:  CharacterType,
        Foucs: FoucsEvent,
        Mouse: MouseEvent,
        Paste: PasteType
    }
};


//pub fn ReadAnyEvent() TefectError!void {}


// Remove | move to hole parser
//pub fn ReadFocusEvent(buffer: [3]u8) TefectError!FoucsEvent {

//    const len = try Read(buffer);

//    if (len == 3 and buffer[0] == 27 and buffer[1] == 91) {

//        if (buffer[2] == 'I') return FoucsEvent.FocusIn;
//        if (buffer[2] == 'O') return FoucsEvent.FocusOut
//        else return TefectError.NotTheWantedEvent;
//                
//    } else return TefectError.NotTheWantedEvent;
//}


// Remove | move to hole parser
//pub fn ReadMouseEvent(bufferheader: *BufferHeader) TefectError!MouseEvent {
//    
//    var len = try Read(&bufferheader.ReadingBuffer);
//    
//    if (Windows) {
//        // in hole parser do this if windows
//        if (len == 3) len += try Read(bufferheader.ReadingBuffer[len..]);
//    }
//
//    if (len != 6) return TefectError.NotAMouseEvent;
//
//    return try tefect_mouse.MouseEventParser(bufferheader.ReadingBuffer[0..6]);
//}