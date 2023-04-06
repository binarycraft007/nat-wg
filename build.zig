const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const server = b.addExecutable(.{
        .name = "server",
        .target = target,
        .optimize = optimize,
    });
    server.addCSourceFiles(
        &.{"src/nat-punch-server.c"},
        &.{
            "-Wextra",
            "-Wno-unused-parameter",
        },
    );
    server.linkLibC();
    server.install();

    const base64 = b.addStaticLibrary(.{
        .name = "base64",
        .root_source_file = .{ .path = "src/base64.zig" },
        .target = target,
        .optimize = optimize,
    });

    const client = b.addExecutable(.{
        .name = "client",
        .target = target,
        .optimize = optimize,
    });
    client.addCSourceFiles(
        &.{"src/nat-punch-client.c"},
        &.{
            "-Wextra",
            "-Wno-unused-parameter",
        },
    );
    client.linkLibrary(base64);
    client.linkLibC();
    client.install();

    const run_cmd = server.run();

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
