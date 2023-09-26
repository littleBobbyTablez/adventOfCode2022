const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const String = []const u8;
const eql = std.mem.eql;

const item = struct {
    size: u128,
    content: ArrayList(String),
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var lines = std.mem.tokenize(u8, trimmed, "\n");

    var stack = ArrayList(String).init(allocator);
    defer stack.deinit();

    var dirs = std.StringHashMap(usize).init(allocator);
    defer dirs.deinit();

    var count: usize = 0;

    while (lines.next()) |line| {
        var split_line = std.mem.tokenize(u8, line, " ");

        var cmd: [3]String = undefined;
        var i: u8 = 0;
        while (split_line.next()) |l| {
            cmd[i] = l;
            i += 1;
        }

        switch (cmd[0][0]) {
            '$' => {
                if (eql(u8, cmd[1], "cd")) {
                    if (eql(u8, cmd[2], "..")) {
                        _ = stack.pop();
                    } else {
                        try stack.append(cmd[2]);
                        count += 1;
                    }
                }
            },
            'd' => continue,
            else => {
                const file_size = try std.fmt.parseInt(usize, cmd[0], 10);
                var current_dir: []const u8 = "";
                for (stack.items) |dir| {
                    current_dir = try std.fmt.allocPrint(allocator, "{s}{s}", .{ current_dir, dir });
                    const before = dirs.get(current_dir) orelse 0;
                    const after = before + file_size;
                    try dirs.put(current_dir, after);
                    std.debug.print("{s} = {d}\n", .{ current_dir, dirs.get(current_dir).? });
                }
            },
        }
    }

    var dirs_iter = dirs.iterator();

    var sum: usize = 0;

    while (dirs_iter.next()) |entry| {
        var size = entry.value_ptr.*;
        if (size <= 100000) {
            sum += size;
        }
    }

    std.debug.print("count: {d}\n", .{dirs.count()});
    std.debug.print("sum: {d}\n", .{sum});
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day7_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}
