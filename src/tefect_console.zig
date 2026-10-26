const std = @import("std");
const builtin = @import("builtin");
const TefectError = @import("tefect_buffer.zig").TefectError;
const WriteToStdout = @import("tefect_buffer.zig").WriteToStdout;
const MouseTrackingProtocols = @import("tefect_mouse.zig").MouseTrackingProtocols;
const WindowSize = @import("tefect_window.zig").WindowSize;

const SetConsoleOutputCP = std.os.windows.kernel32.SetConsoleOutputCP;
const GetConsoleScreenBufferInfo = std.os.windows.kernel32.GetConsoleScreenBufferInfo;
const GetConsoleMode = std.os.windows.kernel32.GetConsoleMode;
const SetConsoleMode = std.os.windows.kernel32.SetConsoleMode;

const ioctl = std.posix.system.ioctl;
const errno = std.posix.errno;
const tcgetattr = std.posix.tcgetattr;
const tcsetattr = std.posix.tcsetattr;

const Windows = builtin.os.tag == .windows;
const ModeType = if (Windows) u32 else std.posix.termios;
const WindowSizeType = if (Windows) std.os.windows.CONSOLE_SCREEN_BUFFER_INFO else std.posix.winsize;

const FailedToGetWindowMode = TefectError.FailedToGetWindowMode;
const FailedToSetWindowMode = TefectError.FailedToSetWindowMode;
const WriteError = std.posix.WriteError;

// https://learn.microsoft.com/en-us/windows/console/setconsolemode
const ENABLE_ECHO_INPUT: u32 = 0x0004;
const ENABLE_LINE_INPUT: u32 = 0x0002;
const ENABLE_PROCESSED_INPUT: u32 = 0x0001;
const ENABLE_VIRTUAL_TERMINAL_INPUT: u32 = 0x0200;
const ENABLE_WINDOW_INPUT: u32 = 0x0008;


fn GetWindowMode() TefectError!ModeType {
    if (Windows) {
        var Mode: ModeType = undefined;
        return if (GetConsoleMode(std.fs.File.stdin().handle, &Mode) != 0) Mode else FailedToGetWindowMode;
    }

    return tcgetattr(std.fs.File.stdin().handle) catch FailedToGetWindowMode;
}



fn SetWindowMode(Mode: ModeType) TefectError!void {
    if (Windows) {
        return if (SetConsoleMode(std.fs.File.stdin().handle, Mode) != 0) {} else FailedToSetWindowMode;
    }

    return tcsetattr(std.fs.File.stdin().handle, .NOW, Mode) catch FailedToSetWindowMode;
}


/// Enables input echo.
///
/// On Windows, `ENABLE_ECHO_INPUT` is only valid when
/// `ENABLE_LINE_INPUT` is also enabled. Therefore, if line input
/// has been disabled, `EnableLineInput()` must be called before
/// `EnableEcho()`.
///
/// Example:
/// ```zig
/// try EnableLineInput();
/// try EnableEcho();
/// ```
///
/// Calling `EnableEcho()` while `ENABLE_LINE_INPUT` is disabled
/// causes Windows `SetConsoleMode()` to fail with
/// `ERROR_INVALID_PARAMETER`.
pub fn EnableEcho() TefectError!void {
    var Mode = try GetWindowMode();

    if (Windows) {
        Mode |= ENABLE_ECHO_INPUT;
    } else {
        Mode.lflag.ECHO = true;
    }

    try SetWindowMode(Mode);
}

pub fn DisbleEcho() TefectError!void {
    var Mode = try GetWindowMode();

    if (Windows) {
        Mode &= ~ENABLE_ECHO_INPUT;
    } else {
        Mode.lflag.ECHO = false;
    }

    try SetWindowMode(Mode);
}


pub fn EnableLineInput() TefectError!void {
    var Mode = try GetWindowMode();

    if (Windows) {
        Mode |= ENABLE_LINE_INPUT;
    } else {
        Mode.lflag.ICANON = true;
    }

    try SetWindowMode(Mode);
}

pub fn DisbleLineInput() TefectError!void {
    var Mode = try GetWindowMode();

    if (Windows) {
        Mode &= ~ENABLE_LINE_INPUT;
    } else {
        Mode.lflag.ICANON = false;
    }

    try SetWindowMode(Mode);
}

pub fn EnableProcessedInput() TefectError!void {
    var Mode = try GetWindowMode();

    if (Windows) {
        Mode |= ENABLE_PROCESSED_INPUT;
    } else {
        Mode.lflag.ISIG = true;
    }

    try SetWindowMode(Mode);
}

pub fn DisbleProcessedInput() TefectError!void {
    var Mode = try GetWindowMode();

    if (Windows) {
        Mode &= ~ENABLE_PROCESSED_INPUT;
    } else {
        Mode.lflag.ISIG = false;
    }

    try SetWindowMode(Mode);
}


pub fn EnableVirtualTerminalInput() TefectError!void {
    if (!Windows) return TefectError.UnsupportedPlatform;

    var Mode = try GetWindowMode();

    Mode |= ENABLE_VIRTUAL_TERMINAL_INPUT;

    try SetWindowMode(Mode);
}

pub fn DisbleVirtualTerminalInput() TefectError!void {
    if (!Windows) return TefectError.UnsupportedPlatform;

    var Mode = try GetWindowMode();

    Mode &= ~ENABLE_VIRTUAL_TERMINAL_INPUT;

    try SetWindowMode(Mode);
}

pub fn EnableUTF8() TefectError!void {
    if (!Windows) return TefectError.UnsupportedPlatform;

    return if (SetConsoleOutputCP(65001) != 0) {} else TefectError.FailedToEnableUTF8;
}

pub fn EnableWindowInput() TefectError!void {
    if (!Windows) return TefectError.UnsupportedPlatform;

    var Mode = try GetWindowMode();
    Mode |= ENABLE_WINDOW_INPUT;
    try SetWindowMode(Mode);
}

pub fn DisbleWindowInput() TefectError!void {
    if (!Windows) return TefectError.UnsupportedPlatform;

    var Mode = try GetWindowMode();
    Mode &= ~ENABLE_WINDOW_INPUT;
    try SetWindowMode(Mode);
}

pub fn EnableMouseInput(Protocol: MouseTrackingProtocols) TefectError!void {
    try WriteToStdout(Protocol.toAnsi(.Enable));
}

pub fn DisbleMouseInput(Protocol: MouseTrackingProtocols) TefectError!void {
    try WriteToStdout(Protocol.toAnsi(.Disble));
}

pub fn EnableMouseInputComptime(comptime Protocol: MouseTrackingProtocols) TefectError!void {
    try WriteToStdout(comptime Protocol.toAnsi(.Enable));
}

pub fn DisbleMouseInputComptime(comptime Protocol: MouseTrackingProtocols) TefectError!void {
    try WriteToStdout(comptime Protocol.toAnsi(.Disble));
}



pub fn EnableRawMode() TefectError!void {
    try DisbleEcho();
    try DisbleLineInput();
}


pub const FocusEvent = enum(u1) {
    FocusIn,
    FocusOut
};

// ESC[O ESC[I
pub fn EnableFocusEvents() !void {
    try WriteToStdout("\x1b[?1004h");
}

pub fn DisbleFocusEvents() !void {
    try WriteToStdout("\x1b[?1004l");
}



// ESC[200~ ESC[201~
pub fn EnableBracketedPaste() !void {
    try WriteToStdout("\x1b[?2004h");
}

pub fn DisbleBracketedPaste() !void {
    try WriteToStdout("\x1b[?2004l");
}


//pub fn GetWindowSize() TefectError!WindowSize {
//    if (Windows) {
//        var WS: WindowSizeType = undefined; 
//        return if (GetConsoleScreenBufferInfo(std.fs.File.stdout().handle, &WS) != 0) .{
//            .Height = WS.srWindow.Bottom - WS.srWindow.Top + 1,
//            .Width = WS.srWindow.Right - WS.srWindow.Left + 1
//        } else TefectError.FailedToGetWindowSize;
//    }
//    var WS: WindowSizeType = undefined;
//    return if (errno(ioctl(std.fs.File.stdout().handle, std.posix.T.IOCGWINSZ, @intFromPtr(&WS))) == std.c.E.SUCCESS) .{
//        .Height = WS.row,
//        .Width = WS.col
//    } else TefectError.FailedToGetWindowSize;
//}