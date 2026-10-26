
pub const Cursor = struct {

    pub const Move = struct {

        pub const Up = "\x1b[A";
        pub const Down = "\x1b[B";
        pub const Right = "\x1b[C";
        pub const Left = "\x1b[D";

        pub const NextLine = "\x1b[E";
        pub const PreviousLine = "\x1b[F";

        pub const Home = "\r"; // \x1b[G

    };

    pub const Save = "\x1b[7";     // \x1b7 or \x[s
    pub const Restore = "\x1b[8";  // \x1b8 or \x[u

    pub const Hide = "\x1b[?25l";
    pub const Show = "\x1b[?25h";


    pub const Shape = struct {

        pub const Blinking = struct {

            pub const Block = "\x1b[1 q";
            pub const Underline = "\x1b[3 q";
            pub const Bar = "\x1b[5 q";

        };

        pub const Block = "\x1b[2 q";
        pub const Underline = "\x1b[4 q";
        pub const Bar = "\x1b[6 q";

    };
};


pub const Screen = struct {

    pub const Clear = struct {

        pub const FromCursorToRight = "\x1b[0J";
        pub const FromCursorToLeft = "\x1b[1J";

        pub const All = "\x1b[2J";

        pub const ScrollBack = "\x1b[3J";
    };

    pub const Scroll = struct {

        pub const Up = "\x1b[S";
        pub const Down = "\x1b[T";

    };

    pub const Alt = struct {

        pub const Enter = "\x1b[?1049h";
        pub const Exit = "\x1b[?1049l";

    };

};

pub const Line = struct {

    pub const Clear = struct {

        pub const FromCursorToRight = "\x1b[0K";
        pub const FromCursorToLeft = "\x1b[1K";
        pub const All = "\x1b[2K";

    };
};

pub const Reset = struct {

    pub const All = "\x1b[0m";

    pub const Foreground = "\x1b[39m";
    pub const Background = "\x1b[49m";

    pub const Bold = "\x1b[22m";
    pub const Italic = "\x1b[23m";
    pub const Underline = "\x1b[24m";
    pub const Inverse = "\x1b[27m";
    pub const Visible = "\x1b[28m";
    pub const Strikethrough = "\x1b[29m";
    pub const Overline = "\x1b[55m";

};


pub const TextStyle = struct {

    pub const Bold = "\x1b[1m";
    pub const Dim = "\x1b[2m";
    pub const Italic = "\x1b[3m";
    pub const Underline = "\x1b[4m";
    pub const Blinking = "\x1b[5m";
    pub const Inverse = "\x1b[7m";
    pub const Hidden = "\x1b[8m";
    pub const Strikethrough = "\x1b[9m";
    pub const DoubleUnderline = "\x1b[21m";
    pub const Overline = "\x1b[53m";

};

pub const ClearTabs = "\x1b[g";
pub const RequestCursorPosition = "\x1b[6n";

pub const Color = struct {

    pub const Fg = struct {

        pub const Black = "\x1b[30m";
        pub const Red = "\x1b[31m";
        pub const Green = "\x1b[32m";
        pub const Yellow = "\x1b[33m";
        pub const Blue = "\x1b[34m";
        pub const Magenta = "\x1b[35m";
        pub const Cyan = "\x1b[36m";
        pub const White = "\x1b[37m";
        pub const Gray = "\x1b[90m";

        pub const Bright = struct {

            pub const Red = "\x1b[91m";
            pub const Green = "\x1b[92m";
            pub const Yellow = "\x1b[93m";
            pub const Blue = "\x1b[94m";
            pub const Magenta = "\x1b[95m";
            pub const Cyan = "\x1b[96m";
            pub const White = "\x1b[97m";

        };
    };

    pub const Bg = struct {

        pub const Black = "\x1b[40m";
        pub const Red = "\x1b[41m";
        pub const Green = "\x1b[42m";
        pub const Yellow = "\x1b[43m";
        pub const Blue = "\x1b[44m";
        pub const Magenta = "\x1b[45m";
        pub const Cyan = "\x1b[46m";
        pub const White = "\x1b[47m";
        pub const Gray = "\x1b[100m";

        pub const Bright = struct {

            pub const Red = "\x1b[101m";
            pub const Green = "\x1b[102m";
            pub const Yellow = "\x1b[103m";
            pub const Blue = "\x1b[104m";
            pub const Magenta = "\x1b[105m";
            pub const Cyan = "\x1b[106m";
            pub const White = "\x1b[107m";

        };
    };
};

