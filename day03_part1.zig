const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const intput = try readInput(allocator);
    defer allocator.free(intput);
    var rucksacks = std.mem.split(u8, intput, "\n");

    var sum: usize = 0;
    while (rucksacks.next()) |sack| {
        const l = sack.len;
        var doubles = std.AutoHashMap(u8, void).init(allocator);
        defer doubles.deinit();

        for (sack[0 .. l / 2]) |item| {
            for (sack[l / 2 .. l]) |second_item| {
                if (item == second_item) {
                    // std.debug.print("1: {}, 2: {}\n", .{ item, second_item });
                    try doubles.put(item, {});
                }
            }
        }
        // std.debug.print("-------------------------------------\n", .{});
        var iter = doubles.keyIterator();

        while (iter.next()) |char| {
            sum += if (isLowercase(char.*)) char.* - 96 else char.* - 38;
        }
    }

    std.debug.print("Result: {d}\n", .{sum});
}

fn isLowercase(letter: u8) bool {
    return letter > 96;
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day3_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}

test "isLowercase" {
    try expect(isLowercase('u'));
}

test "isNotLowercase" {
    try expect(!isLowercase('U'));
}
