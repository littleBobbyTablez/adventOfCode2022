const std = @import("std");
const Allocator = std.mem.Allocator;
const eql = std.mem.eql;
const print = std.debug.print;

const Result = enum(usize) {
    Win = 6,
    Draw = 3,
    Loss = 0,
};

const Values = enum(usize) {
    A = 1,
    B = 2,
    C = 3,
};

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try readInput(alloc);
    const trimmed = std.mem.trim(u8, input, "\n");

    var rounds = std.mem.split(u8, trimmed, "\n");
    var score: usize = 0;
    while (rounds.next()) |round| {
        const desired = switch (round[2]) {
            'X' => Result.Loss,
            'Y' => Result.Draw,
            'Z' => Result.Win,
            else => unreachable,
        };

        score += @intFromEnum(desired);

        const opponent = switch (round[0]) {
            'A' => Values.A,
            'B' => Values.B,
            'C' => Values.C,
            else => unreachable,
        };

        switch (desired) {
            .Win => score += (@intFromEnum(opponent) % 3) + 1,
            .Draw => score += @intFromEnum(opponent),
            .Loss => score += ((@intFromEnum(opponent) + 1) % 3) + 1,
        }
        // print("{d}\n", .{score});
    }
    print("score: {d}\n", .{score});
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day2_real.txt", .{});
    const size = try file.getEndPos();
    const max_bytes: usize = @intCast(size);
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, max_bytes);

    return output;
}
