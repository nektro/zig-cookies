const std = @import("std");
const cookies = @import("cookies");

test {
    std.testing.refAllDecls(cookies);
}
