const std = @import("std");


pub fn build(b: *std.Build) void {


    const Module = b.addModule("tefect", .{

        .root_source_file = b.path("src/root.zig"),
        
        //.link_libc = true,

        .target = b.standardTargetOptions(.{}),

        .optimize = b.standardOptimizeOption(.{
            .preferred_optimize_mode = .ReleaseFast
        })

    });

    _ = Module;

}
