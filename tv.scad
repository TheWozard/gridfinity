include <BOSL2/std.scad>
include <common.scad>

insert_camera = 7.3;
outer_d = 98.3;
inner_d = 54.0;
thickness = 8.0;

$fn = 128;

difference() {
    cylinder(h = thickness, d1 = outer_d, d2 = outer_d - thickness * 2);
    translate([0,0,-0.01]) cylinder(h = thickness + 0.02, d = insert_camera);
}
