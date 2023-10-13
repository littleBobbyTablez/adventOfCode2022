const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var monkeys = [8]usize{ 0, 0, 0, 0, 0, 0, 0, 0 };
    var items: [8]ArrayList(usize) = undefined;

    items[0] = ArrayList(usize).init(allocator);
    defer items[0].deinit();
    try items[0].append(65);
    try items[0].append(58);
    try items[0].append(93);
    try items[0].append(57);
    try items[0].append(66);

    items[1] = ArrayList(usize).init(allocator);
    defer items[1].deinit();
    try items[1].append(76);
    try items[1].append(97);
    try items[1].append(58);
    try items[1].append(72);
    try items[1].append(57);
    try items[1].append(92);
    try items[1].append(82);

    items[2] = ArrayList(usize).init(allocator);
    defer items[2].deinit();
    try items[2].append(90);
    try items[2].append(89);
    try items[2].append(96);

    items[3] = ArrayList(usize).init(allocator);
    defer items[3].deinit();
    try items[3].append(72);
    try items[3].append(63);
    try items[3].append(72);
    try items[3].append(99);

    items[4] = ArrayList(usize).init(allocator);
    defer items[4].deinit();
    try items[4].append(65);

    items[5] = ArrayList(usize).init(allocator);
    defer items[5].deinit();
    try items[5].append(97);
    try items[5].append(71);

    items[6] = ArrayList(usize).init(allocator);
    defer items[6].deinit();
    try items[6].append(83);
    try items[6].append(68);
    try items[6].append(88);
    try items[6].append(55);
    try items[6].append(87);
    try items[6].append(67);

    items[7] = ArrayList(usize).init(allocator);
    defer items[7].deinit();
    try items[7].append(64);
    try items[7].append(81);
    try items[7].append(50);
    try items[7].append(96);
    try items[7].append(82);
    try items[7].append(53);
    try items[7].append(62);
    try items[7].append(92);

    for (0..10000) |_| {
        for (0..8) |i| {
            for (try items[i].toOwnedSlice()) |item| {
                const old = operation(i, item);
                const new = old % (19 * 17 * 3 * 13 * 2 * 11 * 5 * 7);
                const throwTo = runTest(i, new);
                try items[throwTo].append(new);
                monkeys[i] += 1;
            }
        }
    }

    var max_1: usize = 0;
    var max_2: usize = 0;

    for (monkeys) |monkey| {
        if (monkey > max_1) {
            max_2 = max_1;
            max_1 = monkey;
        } else if (monkey > max_2) {
            max_2 = monkey;
        }
    }

    std.debug.print("sum: {d}\n", .{max_1 * max_2});
}

fn operation(monkey: usize, old: usize) usize {
    return switch (monkey) {
        0 => old * 7,
        1 => old + 4,
        2 => old * 5,
        3 => old * old,
        4 => old + 1,
        5 => old + 8,
        6 => old + 2,
        7 => old + 5,
        else => unreachable,
    };
}

fn runTest(monkey: usize, sut: usize) usize {
    return switch (monkey) {
        0 => if (sut % 19 == 0) {
            return 6;
        } else {
            return 4;
        },
        1 => if (sut % 3 == 0) {
            return 7;
        } else {
            return 5;
        },
        2 => if (sut % 13 == 0) {
            return 5;
        } else {
            return 1;
        },
        3 => if (sut % 17 == 0) {
            return 0;
        } else {
            return 4;
        },
        4 => if (sut % 2 == 0) {
            return 6;
        } else {
            return 2;
        },
        5 => if (sut % 11 == 0) {
            return 7;
        } else {
            return 3;
        },
        6 => if (sut % 5 == 0) {
            return 2;
        } else {
            return 1;
        },
        7 => if (sut % 7 == 0) {
            return 3;
        } else {
            return 0;
        },
        else => unreachable,
    };
}
