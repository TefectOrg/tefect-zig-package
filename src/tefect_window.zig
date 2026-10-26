const std = @import("std");
const BufferHeader = @import("tefect_buffer.zig").BufferHeader;
const MouseTrackingProtocols = @import("tefect_console.zig").MouseTrackingProtocols;

pub const CursorShape = enum(u2) {
    Block,
    Underline,
    Bar
};

pub const WindowSize = packed struct {
    Height: u16,
    Width: u16
};


const WindowInfo = packed struct(u16) {

    MouseTrackingProtocol: MouseTrackingProtocols, // 3 bit
    CursorShape: CursorShape, // 2 bit

    // modes
    IsEchoEnable: bool,
    IsLineBufferingEnable: bool,
    IsProcessedInputEnable: bool,
    IsVirtualTerminalInputEnable: bool, // Windows only
    IsConsoleOutputCpSet: bool, // Windows only
    IsRaw: bool,
    IsCursorBlinking: bool,

    // ANSI 
    IsCursorShow: bool,
    IsAltScreen: bool,
    IsCursorPositionSaved: bool,

    IsMouseTrackingEnable: bool,

};

pub const Window = struct {

    bufferheader: *BufferHeader,

    WindowInfo: WindowInfo
    
};
