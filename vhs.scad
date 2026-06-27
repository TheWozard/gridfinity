include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <common.scad>

module turner_vhs_spindle(h = 20, outer_d = 17, inner_d = 13, teeth = 5) {
    linear_extrude(h)
        star(n = teeth, r = outer_d / 2, ir = inner_d / 2);
}

module turner_vhs(l = 50, h = 20) {
    union() {
        turner_vhs_spindle(h = h);
        $fn = 32;
        cylinder(h = l, d = 7.9);
    }
}

//output:turner_test:turner_vhs(h = 2, l = 20);
//output:turner_actual:turner_vhs();

//view
turner_vhs(h = 2, l = 20);
