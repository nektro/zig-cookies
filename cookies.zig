const std = @import("std");
const string = []const u8;

pub const Jar = std.StringHashMap(string);

pub fn parse(alloc: std.mem.Allocator, headers: std.http.Headers) !Jar {
    var map = Jar.init(alloc);
    const h = headers.getFirstValue("cookie") orelse return map;
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

pub fn delete(response: *std.http.Server.Response, comptime name: string) !void {
    try response.headers.append("Set-Cookie", name ++ "=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT");
}
