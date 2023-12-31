const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

const Point = struct {
    x: isize,
    y: isize,
};

const Rope = struct {
    head: Point,
    tail: Point,
};
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const input = try readInput(allocator);
    var trimmed = std.mem.trim(u8, input, "\n");
    var lines = std.mem.split(u8, trimmed, "\n");

    var visited = std.StringHashMap(void).init(allocator);
    defer visited.deinit();

    var rope = createRope(0, 0, 0, 0);

    while (lines.next()) |line| {
        rope = try move(rope, line, &visited);
    }

    std.debug.print("{d} {d} {d} {d}\n", .{ rope.head.x, rope.head.y, rope.tail.x, rope.tail.y });

    var iter = visited.keyIterator();
    var counter: usize = 0;
    while (iter.next()) |_| {
        counter += 1;
        // std.debug.print("{s}\n", .{key});
    }
    std.debug.print("visited: {d}", .{counter});
}

fn readInput(alloc: Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile("input/day9_real.txt", .{});
    defer file.close();
    try file.seekTo(0);
    const output = try file.readToEndAlloc(alloc, std.math.maxInt(usize));

    return output;
}

fn move(rope: Rope, cmd: []const u8, visited: *std.StringHashMap(void)) !Rope {
    const steps = try std.fmt.parseInt(usize, cmd[2..], 10);
    // std.debug.print("steps: {d}\n", .{steps});
    const direction = cmd[0];
    var position = createRope(rope.head.x, rope.head.y, rope.tail.x, rope.tail.y);

    for (0..steps) |_| {
        position = try step(position, direction);
        const mapitem = try std.fmt.allocPrint(allocator, "({d},{d})", .{ position.tail.x, position.tail.y });
        // const headitem = try std.fmt.allocPrint(allocator, "({d},{d})", .{ position.head.x, position.head.y });
        try visited.put(mapitem, {});

        // std.debug.print("cmd: {s}, head: {s}, tail: {s}\n", .{ cmd, headitem, mapitem });
    }
    return position;
}

fn step(rope: Rope, dir: u8) !Rope {
    var hx = rope.head.x;
    var hy = rope.head.y;
    var tx = rope.tail.x;
    var ty = rope.tail.y;

    switch (dir) {
        'R' => hx = hx + 1,
        'L' => hx = hx - 1,
        'U' => hy = hy + 1,
        'D' => hy = hy - 1,
        else => unreachable,
    }

    const head = createPoint(hx, hy);
    var tail = followHead(head, createPoint(tx, ty));

    return createRopeFromPoints(head, tail);
}

fn followHead(head: Point, tail: Point) Point {
    if (isWithinOne(head, tail)) {
        return tail;
    }

    var tx = tail.x;
    var ty = tail.y;

    if (head.x > tail.x) {
        tx += 1;
    }

    if (head.y > tail.y) {
        ty += 1;
    }

    if (head.x < tail.x) {
        tx -= 1;
    }

    if (head.y < tail.y) {
        ty -= 1;
    }

    return Point{
        .x = tx,
        .y = ty,
    };
}

fn isWithinOne(head: Point, tail: Point) bool {
    return (amount(head.x - tail.x) < 2) and (amount(head.y - tail.y) < 2);
}

fn createRope(hx: isize, hy: isize, tx: isize, ty: isize) Rope {
    return Rope{
        .head = Point{
            .x = hx,
            .y = hy,
        },
        .tail = Point{
            .x = tx,
            .y = ty,
        },
    };
}

fn amount(x: isize) isize {
    if (x < 0) {
        return x * (-1);
    }

    return x;
}

fn createRopeFromPoints(h: Point, t: Point) Rope {
    return Rope{
        .head = h,
        .tail = t,
    };
}

fn createPoint(x: isize, y: isize) Point {
    return Point{
        .x = x,
        .y = y,
    };
}

fn equals(r1: Rope, r2: Rope) bool {
    return r1.head.x == r2.head.x and r1.head.y == r2.head.y and r1.tail.x == r2.tail.x and r1.tail.y == r2.tail.y;
}

test "move one step right" {
    const rope = createRope(0, 0, 0, 0);
    const expected = createRope(1, 0, 0, 0);
    var visited = std.StringHashMap(void).init(allocator);
    defer visited.deinit();

    const result = try move(rope, "R 1", &visited);

    try expect(equals(result, expected));
}

test "move one step left" {
    const rope = createRope(0, 0, 0, 0);
    const expected = createRope(-1, 0, 0, 0);
    var visited = std.StringHashMap(void).init(allocator);
    defer visited.deinit();

    const result = try move(rope, "L 1", &visited);

    try expect(equals(result, expected));
}

test "move one step up" {
    const rope = createRope(0, 0, 0, 0);
    const expected = createRope(0, 1, 0, 0);
    var visited = std.StringHashMap(void).init(allocator);
    defer visited.deinit();

    const result = try move(rope, "U 1", &visited);

    try expect(equals(result, expected));
}

test "move one step down" {
    const rope = createRope(0, 0, 0, 0);
    const expected = createRope(0, -1, 0, 0);
    var visited = std.StringHashMap(void).init(allocator);
    defer visited.deinit();

    const result = try move(rope, "D 1", &visited);

    try expect(equals(result, expected));
}

// test "move two steps right" {
//     const rope = createRope(0, 0, 0, 0);
//     const expected = createRope(2, 0, 1, 0);
//
//     const result = try move(rope, "R 2");
//
//     std.debug.print("{d} {d} {d} {d}\n", .{ result.head.x, result.head.y, result.tail.x, result.tail.y });
//
//     try expect(equals(result, expected));
// }

test "is within one" {
    const head = Point{
        .x = 0,
        .y = 0,
    };

    const tail = Point{
        .x = 1,
        .y = 1,
    };

    try expect(isWithinOne(head, tail));
}

test "is not within one" {
    const head = Point{
        .x = 2,
        .y = 0,
    };

    const tail = Point{
        .x = 0,
        .y = 0,
    };

    try expect(!isWithinOne(head, tail));
}

test "tail follows" {
    const head = createPoint(2, 0);
    const tail = createPoint(0, 0);

    const result = followHead(head, tail);

    std.debug.print("\nresult: {d} {d}\n\n", .{ result.x, result.y });

    try expect(result.x == 1);
}

test "tail follows diagonally" {
    const head = createPoint(2, 1);
    const tail = createPoint(0, 0);

    const result = followHead(head, tail);

    std.debug.print("\nresult: {d} {d}\n\n", .{ result.x, result.y });

    try expect(result.x == 1);
    try expect(result.y == 1);
}

test "tail follows diagonally2 " {
    const head = createPoint(-1, 0);
    const tail = createPoint(1, 1);

    const result = followHead(head, tail);

    std.debug.print("\nresult: {d} {d}\n\n", .{ result.x, result.y });

    try expect(result.x == 0);
    try expect(result.y == 0);
}
