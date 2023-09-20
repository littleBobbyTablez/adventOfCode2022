const std = @import("std");
const Allocator = std.mem.Allocator;
const eql = std.mem.eql;
const print = std.debug.print;

const Result = enum {
    Win,
    Draw,
    Loss,
};

const wins = [3][]const u8{ "A Y", "B Z", "C X" };
const draws = [3][]const u8{ "A X", "B Y", "C Z" };

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try readInput(alloc);
    const trimmed = std.mem.trim(u8, input, "\n");

    var rounds = std.mem.split(u8, trimmed, "\n");
    var score: usize = 0;
    while (rounds.next()) |round| {
        switch (round[2]) {
            'X' => score += 1,
            'Y' => score += 2,
            'Z' => score += 3,
            else => unreachable,
        }

        var result = Result.Loss;

        resultCalculation: {
            for (wins) |entry| {
                // print("round: {s}, entry: {s}\n", .{ round, entry });
                if (eql(u8, round, entry)) {
                    result = Result.Win;
                    // print("Win!, {d}\n", .{score});
                    break :resultCalculation;
                }
            }

            for (draws) |entry| {
                // print("round: {s}, entry: {s}\n", .{ round, entry });
                if (eql(u8, round, entry)) {
                    result = Result.Draw;
                    // print("Draw!, {d}\n", .{score});
                    break :resultCalculation;
                }
            }

            // print("Loss!, {d}\n", .{score});
        }

        switch (result) {
            .Win => score += 6,
            .Draw => score += 3,
            .Loss => score += 0,
        }
        // print("{c}\n", .{round[2]});
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
