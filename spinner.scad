include <BOSL2/std.scad>

bearing = 22.1;
width = 30;
thickness = 7;
arm = 40;
rounding = 15;

inset = arm - (width - bearing)/2;

$fn = 64;

module spinner() {
    difference() {
        cuboid([bearing + arm * 2, width, thickness], rounding=rounding, except=[TOP, BOT]);
        cyl(d = bearing, h = thickness + 0.02);
        left(inset) cyl(d = bearing, h = thickness + 0.02);
        right(inset) cyl(d = bearing, h = thickness + 0.02);
    }
}

//output:spinner:spinner();

//view
spinner();
