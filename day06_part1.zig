const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const assert = std.debug.assert;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");

    var queue = ArrayList(u8).init(allocator);
    defer queue.deinit();

    var result: usize = 0;

    for (trimmed, 0..) |letter, i| {
        if (queue.items.len == 4) {
            if (try entriesAreUnique(&queue)) {
                result = i;
                break;
            } else {
                _ = queue.orderedRemove(0);
            }
        }
        try queue.append(letter);
    }

    std.debug.print("Result = {d}\n", .{result});
}

fn entriesAreUnique(queue: *ArrayList(u8)) !bool {
    var clone = try queue.clone();
    var q = try clone.toOwnedSlice();

    for (q, 0..) |x, i| {
        for (q, 0..) |y, j| {
            if (i != j) {
                if (x == y) {
                    return false;
                }
            }
        }
    }

    return true;
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day6_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}

test "contains duplicate" {
    const test_allocator = std.heap.page_allocator;

    var q = ArrayList(u8).init(test_allocator);
    defer q.deinit();

    try q.append('i');
    try q.append('l');
    try q.append('l');
    try q.append('d');

    assert(!(try entriesAreUnique(&q)));
}

test "contains no duplicates" {
    const test_allocator = std.heap.page_allocator;

    var q = ArrayList(u8).init(test_allocator);
    defer q.deinit();

    try q.append('i');
    try q.append('l');
    try q.append('h');
    try q.append('d');

    assert(try entriesAreUnique(&q));
}
