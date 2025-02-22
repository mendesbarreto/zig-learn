const std = @import("std");

pub fn main() !void {
    _ = try get("https://www.google.com/");
    std.debug.print("===============\n", .{});
    _ = try get("https://eotoaq34amuta9f.m.pipedream.net");
    std.debug.print("===============\n", .{});
    _ = try post("https://eotoaq34amuta9f.m.pipedream.net");
}

pub fn post(url: []const u8) !void {
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
            .url = url,
        },
        .extra_headers = headers,
        .headers = .{ .user_agent = .{ .override = "Mozilla/5.0" } },
        .payload = payload,
        .response_storage = .{ .dynamic = &response_body },
    });

    std.debug.print("Response: {s}\n", .{response_body.items});
}

pub fn get(url: []const u8) !void {
    std.debug.print("Let's try to make a GET request!\n", .{});

    const alloc = std.heap.page_allocator;
    var arena = std.heap.ArenaAllocator.init(alloc);
    const allocator = arena.allocator();

    defer arena.deinit();

    var client = std.http.Client{
        .allocator = allocator,
    };

    const headers = &[_]std.http.Header{
        .{ .name = "Content-Type", .value = "application/json" },
        .{ .name = "User-Agent", .value = "Mozilla/5.0" },
    };

    var response_body = std.ArrayList(u8).init(allocator);

    _ = try client.fetch(.{
        .method = .GET,
        .location = .{
            .url = url,
        },
        .headers = .{ .user_agent = .{ .override = "Mozilla/5.0" } },
        .extra_headers = headers,
        .response_storage = .{ .dynamic = &response_body },
    });

    std.debug.print("Response: {s}\n", .{response_body.items});
}
