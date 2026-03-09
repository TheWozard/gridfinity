include <BOSL2/std.scad>

$fn = 32;

difference() {
    linear_extrude(0.5) rect([21, 28], rounding = 1);
    cylinder(d=4, h=10, center=true);
}