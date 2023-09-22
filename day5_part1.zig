const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var lines = std.mem.split(u8, trimmed, "\n");
    _ = lines;

    var stacks: [3]ArrayList(u8) = undefined;

    stacks[0] = ArrayList(u8).init(allocator);
    stacks[1] = ArrayList(u8).init(allocator);
    stacks[2] = ArrayList(u8).init(allocator);

    try stacks[0].append('Z');

    std.debug.print("{c}\n", .{stacks[0].pop()});
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day4.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}
