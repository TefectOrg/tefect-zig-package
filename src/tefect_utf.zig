const std = @import("std");
const CharacterType = @import("tefect_keys.zig").CharacterType;
const TefectError = @import("tefect_buffer.zig").TefectError;


pub inline fn IsContinuationByte(byte: u8) bool {
    return byte & 0b1100_0000 == 0b1000_0000;
}

pub inline fn Is2ByteLead(byte: u8) bool {
    return byte & 0b1110_0000 == 0b1100_0000;
}

pub inline fn Is3ByteLead(byte: u8) bool {
    return byte & 0b1111_0000 == 0b1110_0000;
}

pub inline fn Is4ByteLead(byte: u8) bool {
    return byte & 0b1111_1000 == 0b1111_0000;
}

inline fn IsInSurrogateBlock(value: CharacterType) TefectError!void {
    if (value >= 55296 and value <= 57343) return TefectError.InvalidUtf8;
}

pub fn TowByteUtf8Decoder(bytes: [2]u8) TefectError!CharacterType {
    if (
        Is2ByteLead(bytes[0])
        and IsContinuationByte(bytes[1])
    ) {
        return ((bytes[0] & 0b0001_1111) << 6) | (bytes[1] & 0b0011_1111);
    } else return TefectError.InvalidUtf8;
}



pub fn TreeByteUtf8Decoder(bytes: [3]u8) TefectError!CharacterType {
    if (
        Is3ByteLead(bytes[0])
        and IsContinuationByte(bytes[1])
        and IsContinuationByte(bytes[2])
    ) {

        var value: CharacterType = bytes[0] & 0b0000_1111;

        value = (value << 6) | (bytes[1] & 0b0011_1111);
        value = (value << 6) | (bytes[2] & 0b0011_1111);

        try IsInSurrogateBlock(value);

        return value;
           
    } else return TefectError.InvalidUtf8;
}



pub fn FourByteUtf8Decoder(bytes: [4]u8) TefectError!CharacterType {
    if (
        Is4ByteLead(bytes[0])
        and IsContinuationByte(bytes[1])
        and IsContinuationByte(bytes[2])
        and IsContinuationByte(bytes[3])
    ) {

        var value: CharacterType = bytes[0] & 0b0000_0111;

        value = (value << 6) | (bytes[1] & 0b0011_1111);
        value = (value << 6) | (bytes[2] & 0b0011_1111);
        value = (value << 6) | (bytes[3] & 0b0011_1111);

        try IsInSurrogateBlock(value);

        return value;

    } else TefectError.InvalidUtf8;
}
