const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var lines = std.mem.split(u8, trimmed, "\n");
    var wood_rows: [99][]const u8 = undefined;
    var index: usize = 0;
    var counter: usize = 0;

    while (lines.next()) |line| {
        wood_rows[index] = line;
        index += 1;
    }

    var wood_cols = try rotate(&wood_rows);
    for (wood_rows, 0..) |tree_line, i| {
        for (tree_line, 0..) |_, j| {
            if (try isVisibleHorizontally(tree_line, j) or try isVisibleHorizontally(wood_cols[j], i)) {
                counter += 1;
            }
        }
    }
    std.debug.print("Count: {d}\n", .{counter});
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day8_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}

fn isVisibleHorizontally(row: []const u8, index: usize) !bool {
    const subject = row[index];
    const left = row[0..index];
    const right = row[index + 1 .. row.len];

    return try isVisibleFromDirection(left, subject) or try isVisibleFromDirection(right, subject);
}

fn isVisibleFromDirection(row: []const u8, subject: usize) !bool {
    for (row) |tree| {
        const height: usize = tree - 48;
        if (height >= subject - 48) {
            return false;
        }
        // std.debug.print("height: {d}, subject: {d}\n", .{ height, subject - 48 });
    }
    return true;
    // std.debug.print("left: {s}\n", .{left});
    // std.debug.print("right: {s}\n", .{right});
}

fn rotate(array: [][]const u8) ![][]const u8 {
    var output: [][]const u8 = try allocator.alloc([]const u8, array.len);

    for (0..output.len) |i| {
        output[i] = "";
    }

    for (0..array.len) |i| {
        for (0..array[0].len) |j| {
            output[j] = try std.fmt.allocPrint(allocator, "{s}{c}", .{ output[j], array[i][j] });
        }
    }

    return output;
}

test "isVisibleHorizontally" {
    var input = "32144";

    const result = try isVisibleHorizontally(input, 3);
    try expect(result);
}

test "rotate" {
    var input: [5][]const u8 = undefined;

    input[0] = "01234";
    input[1] = "01234";
    input[2] = "01234";
    input[3] = "01234";
    input[4] = "01234";

    var expected: [5][]const u8 = undefined;

    expected[0] = "00000";
    expected[1] = "11111";
    expected[2] = "22222";
    expected[3] = "33333";
    expected[4] = "44444";

    var output = try rotate(&input);

    for (output, 0..) |value, i| {
        // std.debug.print("v: {s}, e: {s}\n", .{ value, expected[i] });
        try expect(std.mem.eql(u8, value, expected[i]));
    }
}
