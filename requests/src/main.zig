const std = @import("std");

pub fn main() !void {
    std.debug.print("Let's try to make a post request!\n", .{});

    const alloc = std.heap.page_allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    const allocator = arena.allocator();

    defer arena.deinit();

    var client = std.http.Client{
        .allocator = allocator,
    };

    const headers = &[_]std.http.Header{
        .{ .name = "Content-Type", .value = "application/json" },
    };

    const payload = try std.fmt.allocPrint(
        allocator,
        "{{ \"foo\": 1 }}",
        .{},
    );

    var response_body = std.ArrayList(u8).init(allocator);

    _ = try client.fetch(.{
        .method = .POST,
        .location = .{
            .url = "https://eotoaq34amuta9f.m.pipedream.net",
        },
        .extra_headers = headers,
        .payload = payload,
        .response_storage = .{ .dynamic = &response_body },
    });

    std.debug.print("Response: {s}\n", .{response_body.items});
}
