const std: type = @import("std");
const WriteError = std.posix.WriteError;

const MaxBufferSizeType = u32;
pub const ReadingBufferSize = 18;
pub const allocator = std.heap.smp_allocator;

/// NOTE: LenType must be smaller than MaxBufferSizeType.
const LenType = u16;

const lim: MaxBufferSizeType = @intFromFloat(std.math.maxInt(MaxBufferSizeType) * 0.65);


pub const TefectError = error {

    /// Only returned by 'BufferHeader.Create().'
    UnableToCreateBufferHeader,
    UnableToAllocateBuffer,

    UnableToCreateHeapPasteType,
    UnableToAllocatePasteBuffer, // PasteType.data

    /// Returned when a buffer growth allocation fails.
    /// May be returned by BufferHeader.Grow(),
    /// BufferHeader.PushString() or BufferHeader.PushChar().
    OutOfMemory,

    /// Only returned by BufferHeader.WriteBuffer().
    BrokenPipeError,
    AccessDeniedError,
    PermissionDeniedError,
    SystemResourcesError,
    OperationAbortedError,

    CanceledError,
    NoDataForNow,


    ///
    FailedToGetWindowMode,
    
    ///
    FailedToSetWindowMode,

    FailedToGetWindowSize,
    
    ///
    UnsupportedPlatform,

    ///
    FailedToEnableUTF8, // Windows only

    InvalidUtf8,

    NotTheWantedEvent,

    NotAMouseEvent,
    
    FailedToQueryInput,


    UnexpectedError
};


inline fn _mul(bufferheader: *BufferHeader, a: MaxBufferSizeType, b: MaxBufferSizeType) MaxBufferSizeType {
    return std.math.mul(MaxBufferSizeType, a, b) catch {
        bufferheader.Free();
        std.debug.panic(
            "Tefect: (PANIC) Zig:{s}.{s} -> Integer overflow while multiplying {d} by {d}.",
            .{std.fs.path.stem(@src().file), @src().fn_name, a, b}
        );
    };
}

inline fn _add(bufferheader: *BufferHeader, a: MaxBufferSizeType, b: MaxBufferSizeType) MaxBufferSizeType {
    return std.math.add(MaxBufferSizeType, a, b) catch {
        bufferheader.Free();
        std.debug.panic(
            "Tefect: (PANIC) Zig:{s}.{s} -> Integer overflow while adding {d} and {d}.", 
            .{std.fs.path.stem(@src().file), @src().fn_name, a, b}
        );
    };
}

pub inline fn WriteToStdout(bytes: []const u8) TefectError!void {
    std.fs.File.stdout().writeAll(bytes) catch |er| return switch (er) {
        WriteError.BrokenPipe => TefectError.BrokenPipeError,
        WriteError.AccessDenied => TefectError.AccessDeniedError,
        WriteError.PermissionDenied => TefectError.AccessDeniedError,
        WriteError.SystemResources => TefectError.SystemResourcesError,
        WriteError.OperationAborted => TefectError.OperationAbortedError,
        else => TefectError.UnexpectedError
    };
}

pub const BufferHeader: type = struct { 

    Buffer: []u8,
    ReadingBuffer: [ReadingBufferSize]u8,   
    TotalSize: MaxBufferSizeType,
    NowSize: MaxBufferSizeType,
    GrowRate: u8,
      
    pub fn Create(BufferInitSize: MaxBufferSizeType, GrowRate: u8) TefectError!*BufferHeader {
        const bufferheader = allocator.create(BufferHeader) catch return TefectError.UnableToCreateBufferHeader;
        bufferheader.Buffer = allocator.alloc(u8, BufferInitSize) catch {
            allocator.destroy(bufferheader);
            return TefectError.UnableToAllocateBuffer;
        };
        bufferheader.TotalSize = BufferInitSize;
        bufferheader.NowSize = 0;
        bufferheader.GrowRate = GrowRate;
        @memset(&bufferheader.ReadingBuffer, 0);
        return bufferheader;
    }

    pub fn Free(bufferheader: *BufferHeader) void {
        allocator.free(bufferheader.Buffer);
        allocator.destroy(bufferheader);
    }

    pub fn Grow(bufferheader: *BufferHeader, Len: LenType) TefectError!void {
        if ((bufferheader.NowSize+Len) >= bufferheader.TotalSize) {
            var NewSize: MaxBufferSizeType = undefined;

            if (bufferheader.TotalSize < lim) NewSize = (bufferheader.GrowRate * bufferheader.TotalSize / 100) + Len + bufferheader.NowSize
            else NewSize = _add(
                bufferheader,
                _add(bufferheader, _mul(bufferheader, (bufferheader.TotalSize / 100), bufferheader.GrowRate), Len),
                bufferheader.NowSize
            );

            bufferheader.Buffer = try allocator.realloc(bufferheader.Buffer, NewSize);
            bufferheader.TotalSize = NewSize;    
        } else return;
    }


    pub fn PushString(bufferheader: *BufferHeader, Data: []const u8) TefectError!void {
        try bufferheader.Grow(@intCast(Data.len));
        @memcpy(bufferheader.Buffer[bufferheader.NowSize..bufferheader.NowSize+Data.len], Data[0..Data.len]);
        bufferheader.NowSize += @intCast(Data.len);
    }


    pub fn PushChar(bufferheader: *BufferHeader, char: u8) TefectError!void {
        try bufferheader.Grow(1);
        bufferheader.Buffer[bufferheader.NowSize] = char;
        bufferheader.NowSize += 1;
    }

    pub fn WriteBuffer(bufferheader: *BufferHeader) TefectError!void {
        if (bufferheader.NowSize == 0) return;
        WriteToStdout(bufferheader.Buffer[0..bufferheader.NowSize]) 
        catch |er| {
            if (er == TefectError.UnexpectedError) {
                bufferheader.Free();
                std.debug.panic(
                    "Tefect: (PANIC) Zig:{s}.{s} -> Unexpected stdout write error.",
                    .{std.fs.path.stem(@src().file), @src().fn_name}
                ); 
            } else return er;
        };
    }
};



pub const PasteType = packed struct {
    data: []const u8
};


pub const HeapPasteType = packed struct {

    data: []const u8,

    pub fn CreatePasteType() TefectError!*HeapPasteType {
        return allocator.create(HeapPasteType) catch TefectError.UnableToCreateHeapPasteType;
    }

    pub fn Release(heapPasteType: *HeapPasteType) void {
        allocator.free(heapPasteType.data);
        allocator.destroy(heapPasteType);
    }

};