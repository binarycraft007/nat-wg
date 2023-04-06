const std = @import("std");
const base64 = std.base64;

export fn b64_decode(src: [*:0]const u8, target: [*]u8, size: *usize) c_int {
    const codecs = base64.standard;
    const expected_encoded = std.mem.span(src);
    size.* = codecs.Decoder.calcSizeForSlice(expected_encoded) catch
        return -1;
    codecs.Decoder.decode(target[0..size.*], expected_encoded) catch
        return -1;
    return 0;
}
