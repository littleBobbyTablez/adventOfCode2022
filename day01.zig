const std = @import("std");

pub fn main() !void {
    const output = readInput() catch "pech";

    var elves = std.mem.split(u8, output, "\n\n");
    const allocator = std.heap.page_allocator;
    var cumulated = std.ArrayList(usize).init(allocator);
    while (elves.next()) |elv| {
        var trimmed = std.mem.trim(u8, elv, "\n");
        var items = std.mem.split(u8, trimmed, "\n");
        var weight: usize = 0;
        while (items.next()) |item| {
            const item_weight = try std.fmt.parseInt(usize, item, 10);
            weight += item_weight;
        }
        try cumulated.append(weight);
        // std.debug.print("{d}\n----------\n", .{weight});
    }

    var max: usize = 0;
    var top_three: [3]usize = [3]usize{ 0, 0, 0 };
    for (cumulated.items) |elv| {
        max = if (elv > max) elv else max;
        var min: usize = top_three[0];
        var min_index: usize = 0;
        for (top_three[1..3], 1..) |enrty, i| {
            if (enrty < min) {
                min = enrty;
                min_index = i;
            }
        }
        if (elv > min) {
            top_three[min_index] = elv;
        }
    }

    var sum: usize = 0;
    for (top_three) |item| {
        sum += item;
        // std.debug.print("{d}\n----------\n", .{item});
    }

    std.debug.print("Max: {}\n", .{max});
    std.debug.print("Sum: {}\n", .{sum});
}

fn readInput() ![]u8 {
    var output: [20000]u8 = undefined;

    const file = try std.fs.cwd().openFile("input/day1_real.txt", .{});

    defer file.close();
    try file.seekTo(0);
    const n = try file.readAll(&output);

    return output[0..n];
}
