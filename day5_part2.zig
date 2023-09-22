const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var lines = std.mem.split(u8, trimmed, "\n");

    var stacks: [9]ArrayList(u8) = undefined;

    stacks[0] = ArrayList(u8).init(allocator);
    defer stacks[0].deinit();
    stacks[1] = ArrayList(u8).init(allocator);
    defer stacks[1].deinit();
    stacks[2] = ArrayList(u8).init(allocator);
    defer stacks[2].deinit();
    stacks[3] = ArrayList(u8).init(allocator);
    defer stacks[3].deinit();
    stacks[4] = ArrayList(u8).init(allocator);
    defer stacks[4].deinit();
    stacks[5] = ArrayList(u8).init(allocator);
    defer stacks[5].deinit();
    stacks[6] = ArrayList(u8).init(allocator);
    defer stacks[6].deinit();
    stacks[7] = ArrayList(u8).init(allocator);
    defer stacks[7].deinit();
    stacks[8] = ArrayList(u8).init(allocator);
    defer stacks[8].deinit();

    try stacks[0].append('F');
    try stacks[0].append('H');
    try stacks[0].append('B');
    try stacks[0].append('V');
    try stacks[0].append('R');
    try stacks[0].append('Q');
    try stacks[0].append('D');
    try stacks[0].append('P');

    try stacks[1].append('L');
    try stacks[1].append('D');
    try stacks[1].append('Z');
    try stacks[1].append('Q');
    try stacks[1].append('W');
    try stacks[1].append('V');

    try stacks[2].append('H');
    try stacks[2].append('L');
    try stacks[2].append('Z');
    try stacks[2].append('Q');
    try stacks[2].append('G');
    try stacks[2].append('R');
    try stacks[2].append('P');
    try stacks[2].append('C');

    try stacks[3].append('R');
    try stacks[3].append('D');
    try stacks[3].append('H');
    try stacks[3].append('F');
    try stacks[3].append('J');
    try stacks[3].append('V');
    try stacks[3].append('B');

    try stacks[4].append('Z');
    try stacks[4].append('W');
    try stacks[4].append('L');
    try stacks[4].append('C');

    try stacks[5].append('J');
    try stacks[5].append('R');
    try stacks[5].append('P');
    try stacks[5].append('N');
    try stacks[5].append('T');
    try stacks[5].append('G');
    try stacks[5].append('V');
    try stacks[5].append('M');

    try stacks[6].append('J');
    try stacks[6].append('R');
    try stacks[6].append('L');
    try stacks[6].append('V');
    try stacks[6].append('M');
    try stacks[6].append('B');
    try stacks[6].append('S');

    try stacks[7].append('D');
    try stacks[7].append('P');
    try stacks[7].append('J');

    try stacks[8].append('D');
    try stacks[8].append('C');
    try stacks[8].append('N');
    try stacks[8].append('W');
    try stacks[8].append('V');

    while (lines.next()) |line| {

        //parse input
        var sp = std.mem.split(u8, line, " ");
        var cmds: [3]usize = undefined;
        _ = sp.next();
        var index: u8 = 0;
        while (sp.next()) |i| {
            const cmd = std.fmt.parseInt(usize, i, 10);
            cmds[index] = try cmd;
            index += 1;
            _ = sp.next();
        }

        var space = ArrayList(u8).init(allocator);
        defer space.deinit();

        for (0..cmds[0]) |i| {
            _ = i;
            const value = stacks[cmds[1] - 1].pop();
            try space.append(value);
        }

        for (0..cmds[0]) |i| {
            _ = i;
            const value = space.pop();
            try stacks[cmds[2] - 1].append(value);
        }
    }
    std.debug.print("{c} {c} {c} {c} {c} {c} {c} {c} {c}\n", .{ stacks[0].pop(), stacks[1].pop(), stacks[2].pop(), stacks[3].pop(), stacks[4].pop(), stacks[5].pop(), stacks[6].pop(), stacks[7].pop(), stacks[8].pop() });
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day5_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}
