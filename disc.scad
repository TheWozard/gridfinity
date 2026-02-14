include <BOSL2/std.scad>

diameter = 120;
case = 130;
inset = 3;
edge = 10;
thickness = 1.2;
extra = 0.1;
$fn = 128;

difference() {
    translate([-edge/2,0,thickness]) cuboid([case+edge, case+(edge*2), thickness*2], rounding=8, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
    union() {
        cube([case+extra, case+extra, thickness*2], center=true);
        translate([(diameter-case+inset)/2,0,0])cylinder(d=diameter, h=thickness*5);
    }
}