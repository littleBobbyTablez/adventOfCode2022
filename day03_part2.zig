const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const intput = try readInput(allocator);
    defer allocator.free(intput);
    const trimmed = std.mem.trim(u8, intput, "\n");
    var rucksacks = std.mem.split(u8, trimmed, "\n");
    var badges = std.ArrayList(u8).init(allocator);
    defer badges.deinit();
    var sum: usize = 0;

    var group: [3][]const u8 = undefined;
    var i: u8 = 0;
    while (rucksacks.next()) |sack| {
        group[i] = sack;
        i += 1;
        if (i < 3) continue;

        i = 0;

        var first = std.AutoHashMap(u8, void).init(allocator);
        defer first.deinit();

        for (group[0]) |letter| {
            try first.put(letter, {});
        }

        var second = std.AutoHashMap(u8, void).init(allocator);
        defer second.deinit();

        for (group[1]) |letter| {
            if (first.contains(letter)) {
                try second.put(letter, {});
            }
        }

        var final = std.AutoHashMap(u8, void).init(allocator);
        defer final.deinit();

        for (group[2]) |letter| {
            if (second.contains(letter)) {
                try final.put(letter, {});
            }
        }

        var iter = final.keyIterator();
        while (iter.next()) |badge| {
            try badges.append(badge.*);
        }
    }

    for (try badges.toOwnedSlice()) |char| {
        sum += if (isLowercase(char)) char - 96 else char - 38;
    }
    std.debug.print("Sum; {d}\n", .{sum});
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
