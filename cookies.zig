const std = @import("std");
const string = []const u8;

pub const Jar = std.StringHashMap(string);

pub fn parse(alloc: std.mem.Allocator, cookie_str: ?string) !Jar {
    var map = Jar.init(alloc);
    const h = cookie_str orelse return map;
    var iter = std.mem.split(u8, h, "; ");
    while (iter.next()) |item| {
        const i = std.mem.indexOfScalar(u8, item, '=');
        if (i == null) continue;
        const k = item[0..i.?];
        const v = item[i.? + 1 ..];

        if (map.contains(k)) continue;
        try map.put(k, v);
    }
    return map;
}

pub fn delete_string(comptime name: string) string {
    return name ++ "=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
}
