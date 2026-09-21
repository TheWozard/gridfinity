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

module ring(d = bearing) {
    difference() {
        hull() {
            cyl(d = d + 1, h = thickness);
            cyl(d = d + 3, h = thickness/2);
        }
        cyl(d = d, h = thickness + 0.02);
    }
}

//output:spinner:spinner();
//output:ring_23:ring(23);
//output:ring_22:ring(22);
//output:ring_21:ring(21);
//output:ring_20:ring(20);
//output:ring_19:ring(19);
//output:ring_18:ring(18);
//output:ring_17:ring(17);
//output:ring_16:ring(16);
//output:ring_15:ring(15);
//output:ring_14:ring(14);

//view
ring(19);
