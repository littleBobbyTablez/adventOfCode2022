const std = @import("std");
const Allocator = std.mem.Allocator;
const split = std.mem.split;
const parseInt = std.fmt.parseInt;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var pairs = std.mem.split(u8, trimmed, "\n");

    var counter_fully: usize = 0;
    var counter_overlap: usize = 0;

    while (pairs.next()) |pair| {
        var split_pair = split(u8, pair, ",");
        var first = split(u8, split_pair.next().?, "-");
        var second = split(u8, split_pair.next().?, "-");

        const first_borders = [2]usize{ try parseInt(usize, first.first(), 10), try parseInt(usize, first.peek().?, 10) };
        const second_borders = [2]usize{ try parseInt(usize, second.first(), 10), try parseInt(usize, second.peek().?, 10) };

        if (fullyContains(first_borders, second_borders)) {
            counter_fully += 1;
        }
        if (overlap(first_borders, second_borders)) {
            counter_overlap += 1;
        }
    }

    std.debug.print("Fully: {d}\n", .{counter_fully});
    std.debug.print("Overlap: {d}\n", .{counter_overlap});
}

fn overlap(a: [2]usize, b: [2]usize) bool {
    if (a[0] < b[0]) {
        if (a[1] < b[0]) {
            return false;
        }
    }
    if (a[1] > b[1]) {
        if (a[0] > b[1]) {
            return false;
        }
    }
    return true;
}

fn fullyContains(a: [2]usize, b: [2]usize) bool {
    if (a[0] <= b[0]) {
        if (a[1] >= b[1]) {
            return true;
        }
    }
    if (a[0] >= b[0]) {
        if (a[1] <= b[1]) {
            return true;
        }
    }

    return false;
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day4_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}
