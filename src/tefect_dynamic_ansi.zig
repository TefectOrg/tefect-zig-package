// This file will be completely restructured.

const std = @import("std");
const tefect_buffer = @import("tefect_buffer.zig");
const BufferHeader = tefect_buffer.BufferHeader;

inline fn IntLen(n: u16) u8 {
    if (n >= 10000) return 5;
    if (n >= 1000) return 4;
    if (n >= 100) return 3;
    if (n >= 10) return 2;
    return 1;
}

// IMPORTANT: Before calling 'PushCSI' or 'WriteNumber', ensure that
// BufferHeader.Buffer has enough capacity. Call the BufferHeader.Grow function
// to expand the buffer if necessary.

inline fn WriteNumber(bufferheader: *BufferHeader, Number: u16, NumberLen: u8) void {
    var bufferSlice = bufferheader.Buffer[bufferheader.NowSize..bufferheader.NowSize + NumberLen];
    var number = Number;

    for (1..NumberLen + 1) |index| {
        bufferSlice[NumberLen - index] = @intCast((number % 10) + 0x30);
        number /= 10;
    }

    bufferheader.NowSize += NumberLen;
}

inline fn PushCSI(bufferheader: *BufferHeader) void {
    bufferheader.Buffer[bufferheader.NowSize] = 0x1b;
    bufferheader.Buffer[bufferheader.NowSize + 1] = 0x5B; // [
    bufferheader.NowSize += 2;
}


// dynamic_ansi Function ↓
pub export fn CursorMoveUp(bufferhandle: *BufferHandle, Rows: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const RowsNumberLen: u8 = IntLen(Rows);

    bufferheader.Grow((RowsNumberLen + 3), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, Rows, RowsNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x41; // A
    bufferheader.NowSize += 1;
}

pub export fn CursorMoveDown(bufferhandle: *BufferHandle, Rows: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const RowsNumberLen: u8 = IntLen(Rows);

    bufferheader.Grow((RowsNumberLen + 3), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, Rows, RowsNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x42; // B
    bufferheader.NowSize += 1;
}

pub export fn CursorMoveRight(bufferhandle: *BufferHandle, Columns: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const ColumnsNumberLen: u8 = IntLen(Columns);

    bufferheader.Grow((ColumnsNumberLen + 3), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, Columns, ColumnsNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x43; // C
    bufferheader.NowSize += 1;
}

pub export fn CursorMoveLeft(bufferhandle: *BufferHandle, Columns: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const ColumnsNumberLen: u8 = IntLen(Columns);

    bufferheader.Grow((ColumnsNumberLen + 3), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, Columns, ColumnsNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x43; // D
    bufferheader.NowSize += 1;
}

pub export fn CursorMoveTo(bufferhandle: *BufferHandle, Row: u16, Column: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const RowNumberLen: u8 = IntLen(Row);
    const ColumnNumberLen: u8 = IntLen(Column);

    bufferheader.Grow((RowNumberLen + ColumnNumberLen + 4), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, Row, RowNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x3b; // ;
    bufferheader.NowSize += 1;

    WriteNumber(bufferheader, Column, ColumnNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x48; // H
    bufferheader.NowSize += 1;
}

pub export fn ForegroundColor256(bufferhandle: *BufferHandle, ColorNumber: u8) void {
    const bufferheader = Handle2Header(bufferhandle);
    const ColorNumberLen = IntLen(ColorNumber);

    bufferheader.Grow((8 + ColorNumberLen), false);

    PushCSI(bufferheader);

    bufferheader.Buffer[bufferheader.NowSize] = 0x33; // 3
    bufferheader.Buffer[bufferheader.NowSize + 1] = 0x38; // 8
    bufferheader.Buffer[bufferheader.NowSize + 2] = 0x3b; // ;
    bufferheader.Buffer[bufferheader.NowSize + 3] = 0x35; // 5
    bufferheader.Buffer[bufferheader.NowSize + 4] = 0x3b; // ;
    bufferheader.NowSize += 5;

    WriteNumber(bufferheader, ColorNumber, ColorNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x6D; // m
    bufferheader.NowSize += 1;
}

pub export fn BackgroundColor256(bufferhandle: *BufferHandle, ColorNumber: u8) void {
    const bufferheader = Handle2Header(bufferhandle);
    const ColorNumberLen = IntLen(ColorNumber);

    bufferheader.Grow((8 + ColorNumberLen), false);

    PushCSI(bufferheader);

    bufferheader.Buffer[bufferheader.NowSize] = 0x34; // 4
    bufferheader.Buffer[bufferheader.NowSize + 1] = 0x38; // 8
    bufferheader.Buffer[bufferheader.NowSize + 2] = 0x3b; // ;
    bufferheader.Buffer[bufferheader.NowSize + 3] = 0x35; // 5
    bufferheader.Buffer[bufferheader.NowSize + 4] = 0x3b; // ;
    bufferheader.NowSize += 5;

    WriteNumber(bufferheader, ColorNumber, ColorNumberLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x6D; // m
    bufferheader.NowSize += 1;
}

pub export fn ForegroundColorRGB(bufferhandle: *BufferHandle, Red: u8, Green: u8, Blue: u8) void {
    const bufferheader = Handle2Header(bufferhandle);
    const RedLen = IntLen(Red);
    const GreenLen = IntLen(Green);
    const BlueLen = IntLen(Blue);

    bufferheader.Grow((10 + RedLen + GreenLen + BlueLen), false);

    PushCSI(bufferheader);

    bufferheader.Buffer[bufferheader.NowSize] = 0x33; // 3
    bufferheader.Buffer[bufferheader.NowSize + 1] = 0x38; // 8
    bufferheader.Buffer[bufferheader.NowSize + 2] = 0x3b; // ;
    bufferheader.Buffer[bufferheader.NowSize + 3] = 0x32; // 2
    bufferheader.Buffer[bufferheader.NowSize + 4] = 0x3b; // ;
    bufferheader.NowSize += 5;

    WriteNumber(bufferheader, Red, RedLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x3b; // ;
    bufferheader.NowSize += 1;

    WriteNumber(bufferheader, Green, GreenLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x3b; // ;
    bufferheader.NowSize += 1;

    WriteNumber(bufferheader, Blue, BlueLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x6D; // m
    bufferheader.NowSize += 1;
}

pub export fn BackgroundColorRGB(bufferhandle: *BufferHandle, Red: u8, Green: u8, Blue: u8) void {
    const bufferheader = Handle2Header(bufferhandle);
    const RedLen = IntLen(Red);
    const GreenLen = IntLen(Green);
    const BlueLen = IntLen(Blue);

    bufferheader.Grow((10 + RedLen + GreenLen + BlueLen), false);

    PushCSI(bufferheader);

    bufferheader.Buffer[bufferheader.NowSize] = 0x34; // 4
    bufferheader.Buffer[bufferheader.NowSize + 1] = 0x38; // 8
    bufferheader.Buffer[bufferheader.NowSize + 2] = 0x3b; // ;
    bufferheader.Buffer[bufferheader.NowSize + 3] = 0x32; // 2
    bufferheader.Buffer[bufferheader.NowSize + 4] = 0x3b; // ;
    bufferheader.NowSize += 5;

    WriteNumber(bufferheader, Red, RedLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x3b; // ;
    bufferheader.NowSize += 1;

    WriteNumber(bufferheader, Green, GreenLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x3b; // ;
    bufferheader.NowSize += 1;

    WriteNumber(bufferheader, Blue, BlueLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x6D; // m
    bufferheader.NowSize += 1;
}

pub export fn InsertRows(bufferhandle: *BufferHandle, NumberOfRows: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const NumberOfRowsLen = IntLen(NumberOfRows);

    bufferheader.Grow((3 + NumberOfRowsLen), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, NumberOfRows, NumberOfRowsLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x4C; // L
    bufferheader.NowSize += 1;
}

pub export fn DeleteRows(bufferhandle: *BufferHandle, NumberOfRows: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const NumberOfRowsLen = IntLen(NumberOfRows);

    bufferheader.Grow((3 + NumberOfRowsLen), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, NumberOfRows, NumberOfRowsLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x4D; // M
    bufferheader.NowSize += 1;
}

pub export fn DeleteChars(bufferhandle: *BufferHandle, NumberOfChars: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const NumberOfCharsLen = IntLen(NumberOfChars);

    bufferheader.Grow((3 + NumberOfCharsLen), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, NumberOfChars, NumberOfCharsLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x50; // P
    bufferheader.NowSize += 1;
}

pub export fn EraseChars(bufferhandle: *BufferHandle, NumberOfChars: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const NumberOfCharsLen = IntLen(NumberOfChars);

    bufferheader.Grow((3 + NumberOfCharsLen), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, NumberOfChars, NumberOfCharsLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x58; // X
    bufferheader.NowSize += 1;
}

pub export fn ForwardTab(bufferhandle: *BufferHandle, NumberOfTabs: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const NumberOfTabsLen = IntLen(NumberOfTabs);

    bufferheader.Grow((3 + NumberOfTabsLen), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, NumberOfTabs, NumberOfTabsLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x49; // I
    bufferheader.NowSize += 1;
}

pub export fn BackwardTab(bufferhandle: *BufferHandle, NumberOfTabs: u16) void {
    const bufferheader = Handle2Header(bufferhandle);
    const NumberOfTabsLen = IntLen(NumberOfTabs);

    bufferheader.Grow((3 + NumberOfTabsLen), false);

    PushCSI(bufferheader);

    WriteNumber(bufferheader, NumberOfTabs, NumberOfTabsLen);

    bufferheader.Buffer[bufferheader.NowSize] = 0x5A; // Z
    bufferheader.NowSize += 1;
}
