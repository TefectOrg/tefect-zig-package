pub const Buffer = @import("tefect_buffer.zig");
pub const Console = @import("tefect_console.zig");
//pub const DynamicAnsi = @import("tefect_dynamic_ansi.zig");
//pub const Input = if (@import("builtin").os.tag == .windows) @import("tefect_input_windows.zig") else @import("tefect_input_unix.zig");
pub const Keys = @import("tefect_keys.zig");
pub const Mouse = @import("tefect_mouse.zig");
pub const Window = @import("tefect_window.zig");
pub const StaticAnsi = @import("tefect_static_ansi.zig");