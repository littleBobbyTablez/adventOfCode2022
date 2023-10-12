const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var lines = std.mem.split(u8, trimmed, "\n");

    var cycle: isize = 0;
    var x: isize = 1;
    var strength: [6]isize = undefined;
    for (0..6) |i| {
        strength[i] = 0;
    }

    while (lines.next()) |line| {
        switch (line[0]) {
            'n' => {
                if (@mod(cycle, 40) == 0) {
                    std.debug.print("\n", .{});
                }
                cycle += 1;
                if ((@mod(cycle - x, 40) < 3) and (@mod(cycle - x, 40) >= 0)) {
                    std.debug.print("#", .{});
                } else {
                    std.debug.print(".", .{});
                }
            },
            'a' => {
                const value = try std.fmt.parseInt(isize, line[5..], 10);
                for (1..3) |_| {
                    if (@mod(cycle, 40) == 0) {
                        std.debug.print("\n", .{});
                    }
                    cycle += 1;
                    switch (cycle) {
                        20 => {
                            strength[0] = cycle * x;
                        },
                        60 => {
                            strength[1] = cycle * x;
                        },
                        100 => {
                            strength[2] = cycle * x;
                        },
                        140 => {
                            strength[3] = cycle * x;
                        },
                        180 => {
                            strength[4] = cycle * x;
                        },
                        220 => {
                            strength[5] = cycle * x;
                        },
                        else => {},
                    }
                    if ((@mod(cycle - x, 40) < 3) and (@mod(cycle - x, 40) >= 0)) {
                        std.debug.print("#", .{});
                    } else {
                        std.debug.print(".", .{});
                    }
                }
                x += value;
            },
            else => unreachable,
        }
    }
    var sum: isize = 0;

    for (strength) |value| {
        sum += value;
    }
    std.debug.print("\n", .{});
    std.debug.print("20: {d}, 60: {d}, 100: {d}, 140: {d}, 180: {d}, 220: {d}\n", .{ strength[0], strength[1], strength[2], strength[3], strength[4], strength[5] });

    std.debug.print("sum: {d}\n", .{sum});
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day10_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}
