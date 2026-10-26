pub const CharacterType = u22;

comptime {
    if (@bitSizeOf(CharacterType) < 21) @compileError("@bitSizeOf(CharacterType) must be biger than 21.");
}

pub const @"Ctrl+@":  CharacterType = 0;  // Null
pub const @"Ctrl+A":  CharacterType = 1;  // Start of Heading
pub const @"Ctrl+B":  CharacterType = 2;  // Start of Text
pub const @"Ctrl+C":  CharacterType = 3;  // End of Text
pub const @"Ctrl+D":  CharacterType = 4;  // End of Transmission
pub const @"Ctrl+E":  CharacterType = 5;  // Enquiry
pub const @"Ctrl+F":  CharacterType = 6;  // Acknowledgement
pub const @"Ctrl+G":  CharacterType = 7;  // Bell
pub const @"Ctrl+H":  CharacterType = 8;  // Backspace
pub const @"Ctrl+I":  CharacterType = 9;  // Horizontal Tab
pub const @"Ctrl+J":  CharacterType = 10; // Line Feed
pub const @"Ctrl+K":  CharacterType = 11; // Vertical Tab
pub const @"Ctrl+L":  CharacterType = 12; // Form Feed
pub const @"Ctrl+M":  CharacterType = 13; // Carriage Return
pub const @"Ctrl+N":  CharacterType = 14; // Shift Out
pub const @"Ctrl+O":  CharacterType = 15; // Shift In
pub const @"Ctrl+P":  CharacterType = 16; // Data Link Escape
pub const @"Ctrl+Q":  CharacterType = 17; // Device Control 1
pub const @"Ctrl+R":  CharacterType = 18; // Device Control 2
pub const @"Ctrl+S":  CharacterType = 19; // Device Control 3
pub const @"Ctrl+T":  CharacterType = 20; // Device Control 4
pub const @"Ctrl+U":  CharacterType = 21; // Negative Acknowledgement
pub const @"Ctrl+V":  CharacterType = 22; // Synchronous Idle
pub const @"Ctrl+W":  CharacterType = 23; // End of Transmission Block
pub const @"Ctrl+X":  CharacterType = 24; // Cancel
pub const @"Ctrl+Y":  CharacterType = 25; // End of Medium
pub const @"Ctrl+Z":  CharacterType = 26; // Substitute
pub const @"Ctrl+[":  CharacterType = 27; // Escape
pub const @"Ctrl+\\": CharacterType = 28; // File Separator
pub const @"Ctrl+]":  CharacterType = 29; // Group Separator
pub const @"Ctrl+^":  CharacterType = 30; // Record Separator
pub const @"Ctrl+_":  CharacterType = 31; // Unit Separator



pub const Space: CharacterType = ' '; // 32

pub const num0: CharacterType = '0'; // 48
pub const num1: CharacterType = '1'; // 49
pub const num2: CharacterType = '2'; // 50
pub const num3: CharacterType = '3'; // 51
pub const num4: CharacterType = '4'; // 52
pub const num5: CharacterType = '5'; // 53
pub const num6: CharacterType = '6'; // 54
pub const num7: CharacterType = '7'; // 55
pub const num8: CharacterType = '8'; // 56
pub const num9: CharacterType = '9'; // 57

pub const A: CharacterType = 'A'; // 65
pub const B: CharacterType = 'B'; // 66
pub const C: CharacterType = 'C'; // 67
pub const D: CharacterType = 'D'; // 68
pub const E: CharacterType = 'E'; // 69
pub const F: CharacterType = 'F'; // 70
pub const G: CharacterType = 'G'; // 71
pub const H: CharacterType = 'H'; // 72
pub const I: CharacterType = 'I'; // 73
pub const J: CharacterType = 'J'; // 74
pub const K: CharacterType = 'K'; // 75
pub const L: CharacterType = 'L'; // 76
pub const M: CharacterType = 'M'; // 77
pub const N: CharacterType = 'N'; // 78
pub const O: CharacterType = 'O'; // 79
pub const P: CharacterType = 'P'; // 80
pub const Q: CharacterType = 'Q'; // 81
pub const R: CharacterType = 'R'; // 82
pub const S: CharacterType = 'S'; // 83
pub const T: CharacterType = 'T'; // 84
pub const U: CharacterType = 'U'; // 85
pub const V: CharacterType = 'V'; // 86
pub const W: CharacterType = 'W'; // 87
pub const X: CharacterType = 'X'; // 88
pub const Y: CharacterType = 'Y'; // 89
pub const Z: CharacterType = 'Z'; // 90

pub const a: CharacterType = 'a'; // 97
pub const b: CharacterType = 'b'; // 98
pub const c: CharacterType = 'c'; // 99
pub const d: CharacterType = 'd'; // 100
pub const e: CharacterType = 'e'; // 101
pub const f: CharacterType = 'f'; // 102
pub const g: CharacterType = 'g'; // 103
pub const h: CharacterType = 'h'; // 104
pub const i: CharacterType = 'i'; // 105
pub const j: CharacterType = 'j'; // 106
pub const k: CharacterType = 'k'; // 107
pub const l: CharacterType = 'l'; // 108
pub const m: CharacterType = 'm'; // 109
pub const n: CharacterType = 'n'; // 110
pub const o: CharacterType = 'o'; // 111
pub const p: CharacterType = 'p'; // 112
pub const q: CharacterType = 'q'; // 113
pub const r: CharacterType = 'r'; // 114
pub const s: CharacterType = 's'; // 115
pub const t: CharacterType = 't'; // 116
pub const u: CharacterType = 'u'; // 117
pub const v: CharacterType = 'v'; // 118
pub const w: CharacterType = 'w'; // 119
pub const x: CharacterType = 'x'; // 120
pub const y: CharacterType = 'y'; // 121
pub const z: CharacterType = 'z'; // 122

pub const Exclamation:  CharacterType = '!';
pub const Quote:        CharacterType = '"';
pub const Hash:         CharacterType = '#';
pub const Dollar:       CharacterType = '$';
pub const Percent:      CharacterType = '%';
pub const Ampersand:    CharacterType = '&';
pub const Apostrophe:   CharacterType = '\'';
pub const LeftParen:    CharacterType = '(';
pub const RightParen:   CharacterType = ')';
pub const Asterisk:     CharacterType = '*';
pub const Plus:         CharacterType = '+';
pub const Comma:        CharacterType = ',';
pub const Minus:        CharacterType = '-';
pub const Dash:         CharacterType = '-';
pub const Period:       CharacterType = '.';
pub const Slash:        CharacterType = '/';
pub const Colon:        CharacterType = ':';
pub const Semicolon:    CharacterType = ';';
pub const LessThan:     CharacterType = '<';
pub const Equal:        CharacterType = '=';
pub const GreaterThan:  CharacterType = '>';
pub const Question:     CharacterType = '?';
pub const At:           CharacterType = '@';
pub const LeftBracket:  CharacterType = '[';
pub const Backslash:    CharacterType = '\\';
pub const RightBracket: CharacterType = ']';
pub const Caret:        CharacterType = '^';
pub const Underscore:   CharacterType = '_';
pub const Backtick:     CharacterType = '`';
pub const LeftBrace:    CharacterType = '{';
pub const Pipe:         CharacterType = '|';
pub const RightBrace:   CharacterType = '}';
pub const Tilde:        CharacterType = '~';

pub const UpArrow:    CharacterType = 2097152;
pub const DownArrow:  CharacterType = 2097153;
pub const RightArrow: CharacterType = 2097154;
pub const LeftArrow:  CharacterType = 2097155;

pub const PageDown:    CharacterType = 2097156; // 27 91 54 126
pub const PageUp:      CharacterType = 2097157; // 27 91 53 126
pub const Home:        CharacterType = 2097158; // 27 91 72
pub const End:         CharacterType = 2097159; // 27 91 70
pub const Insert:      CharacterType = 2097160; // 27 91 50 126
pub const Delete:      CharacterType = 2097161; // 27 91 51 126

pub const BackSpace:   CharacterType = 127;
pub const Esc:         CharacterType = 27;

pub const F1:          CharacterType = 2097162; // { 27, 79, 80 }
pub const F2:          CharacterType = 2097163; // { 27, 79, 81 }
pub const F3:          CharacterType = 2097164; // { 27, 79, 82 }
pub const F4:          CharacterType = 2097165; // { 27, 79, 83 }
pub const F5:          CharacterType = 2097166; // { 27, 91, 49, 53, 126 }
pub const F6:          CharacterType = 2097167; // { 27, 91, 49, 55, 126 }
pub const F7:          CharacterType = 2097168; // { 27, 91, 49, 56, 126 }
pub const F8:          CharacterType = 2097169; // { 27, 91, 49, 57, 126 }
pub const F9:          CharacterType = 2097170; // { 27, 91, 50, 48, 126 }
pub const F10:         CharacterType = 2097171; // { 27, 91, 50, 49, 126 }
pub const F11:         CharacterType = 2097172; // { 27, 91, 50, 51, 126 }
pub const F12:         CharacterType = 2097173; // { 27, 91, 50, 52, 126 }