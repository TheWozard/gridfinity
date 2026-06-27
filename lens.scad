include <BOSL2/std.scad>
include <common.scad>

model = "lens_top";

lens_diameter = 35.2;
lens_depth = 7;
filter_diameter = 40.5;
filter_depth = 2;
thickness = 2;
p=0.01;
p2 = p * 2;

cap_diameter = 44;
cap_depth = 14;

screen_thickness = 5;
bezel_thickness = 10;

if (model == "lens_filter") {
    difference() {
        $fn=128;
        cylinder(d = filter_diameter + thickness, h = lens_depth + filter_depth);
        translate([0,0,-p])cylinder(d = lens_diameter, h = lens_depth + p2)
            attach(TOP, BOTTOM, overlap = p)
                cylinder(d = filter_diameter, h = filter_depth + p2);

    }
} else if (model == "lens_cap") {
    difference() {
        $fn=128;
        cylinder(d = cap_diameter + thickness, h = cap_depth+ thickness);
        translate([0,0,thickness])cylinder(d = cap_diameter, h = cap_depth + p);
    }
} else if (model == "lens_top") {
    difference() {
        $fn=128;
        cuboid([screen_thickness + thickness*2, bezel_thickness*2, bezel_thickness + thickness], rounding=thickness, edges=[TOP+FRONT, TOP+BACK, BOTTOM+LEFT, BOTTOM+RIGHT]);
        translate([0,0,thickness]) cuboid([screen_thickness , bezel_thickness*2+p, bezel_thickness + thickness], rounding=1, edges=[BOTTOM+LEFT, BOTTOM+RIGHT]);
    }
}