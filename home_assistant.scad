include <BOSL2/std.scad>

dimensions = [54.1, 85.7, 1];
thickness = [10, 10, 1];
interior = [51,51];
thumb = 20;

$fn = 32;

difference() {
    cuboid(dimensions + thickness, rounding=thickness.x/2, except=[TOP, BOT]);
    translate([0,0,-thickness.z/2 - 0.01]) {
        cube(dimensions, center = true);
        cube([thumb, dimensions.y + thickness.y + 0.01, dimensions.z], center = true);
    }
    cube([interior.x, interior.y, dimensions.z + thickness.z + 0.02], center = true);
}