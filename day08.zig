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
    var maxViewScore: usize = 0;

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

            const viewScore = calculateView(tree_line, wood_cols[j], j, i);
            if (maxViewScore < viewScore) {
                maxViewScore = viewScore;
            }
        }
    }
    std.debug.print("Count: {d}\n", .{counter});
    std.debug.print("View Score: {d}\n", .{maxViewScore});
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

fn calculateViewScoreOneDirection(row: []const u8, subject: usize) !usize {
    var viewScore = row.len;

    if (viewScore == 0) {
        return 1;
    }

    for (row, 0..) |tree, i| {
        const height: usize = tree - 48;
        if (height >= subject) {
            viewScore = row.len - i;
        }
    }
    return viewScore;
}

fn calculateViewScoreOneDirectionReverse(row: []const u8, subject: usize) !usize {
    if (row.len == 0) {
        return 1;
    }

    for (row, 0..) |tree, i| {
        const height: usize = tree - 48;
        if (height >= subject) {
            return i + 1;
        }
    }
    return row.len;
}

fn calculateView(row: []const u8, col: []const u8, row_index: usize, col_index: usize) usize {
    const subject = row[row_index] - 48;
    const left = row[0..row_index];
    const right = row[row_index + 1 .. row.len];

    const up = col[0..col_index];
    const down = col[col_index + 1 .. row.len];

    const l = try calculateViewScoreOneDirection(left, subject);
    const r = try calculateViewScoreOneDirectionReverse(right, subject);
    const u = try calculateViewScoreOneDirection(up, subject);
    const d = try calculateViewScoreOneDirectionReverse(down, subject);

    return l * r * u * d;
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

test "calculate view score" {
    const row = "33549";
    const col = "35353";

    const result = calculateView(row, col, 2, 3);
    std.debug.print("{d}\n", .{result});
    try expect(result == 8);
}

test "calculate view score one direction" {
    const row_1 = "33";

    const result = try calculateViewScoreOneDirection(row_1, 5);
    try expect(result == 2);

    const row_2 = "";

    const result_2 = try calculateViewScoreOneDirection(row_2, 5);
    try expect(result_2 == 1);

    const row_3 = "25";

    const result_3 = try calculateViewScoreOneDirection(row_3, 5);
    try expect(result_3 == 1);

    const row_4 = "52";

    const result_4 = try calculateViewScoreOneDirection(row_4, 5);
    try expect(result_4 == 2);

    const row_5 = "353";

    const result_5 = try calculateViewScoreOneDirection(row_5, 5);
    try expect(result_5 == 2);
}

test "calculate view score one direction reverse" {
    const row_1 = "33";

    const result = try calculateViewScoreOneDirectionReverse(row_1, 5);
    try expect(result == 2);

    const row_2 = "";

    const result_2 = try calculateViewScoreOneDirectionReverse(row_2, 5);
    try expect(result_2 == 1);

    const row_3 = "25";

    const result_3 = try calculateViewScoreOneDirectionReverse(row_3, 5);
    try expect(result_3 == 2);

    const row_4 = "52";

    const result_4 = try calculateViewScoreOneDirectionReverse(row_4, 5);
    try expect(result_4 == 1);
}
