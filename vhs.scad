include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <common.scad>

module turner_vhs_spindle(h = 13, outer_d = 19, inner_d = 12, teeth = 9) {
    linear_extrude(h)
        star(n = teeth, r = outer_d / 2, ir = inner_d / 2);
}

module turner_vhs(l = 50, h = 13, d = 8) {
    union() {
        turner_vhs_spindle(h = h);
        $fn = 32;
        cylinder(h = l, d = d);
    }
}

module cross(id = 23, s = 95, t = 5, h = 7) {
    difference() {
        o = s / 2;
        hull() {
            $fn = 64;
            d = id + 2 * t;
            right(o) cylinder(d = d, h = h);
            left(o) cylinder(d = d, h = h);
        }
        right(o) down(0.01) cylinder(d = id, h = h + 0.02);
        left(o) down(0.01) cylinder(d = id, h = h + 0.02);
    }
}

module stand(s = [20, 48, 7], b=[180,60,7], ph = 25, pd = 5, pl = 8) {
    translate([0,s.y/2,s.z/2]) cuboid(s);
    $fn = 32;
    back(ph) cylinder(d = pd, h = pl + s.z);
    translate([0,s.y + b.z/2,s.z + b.y/2]) rotate([90,0,0]) cuboid(b + [0,2 * s.z, 0]);
}

module top(s = [20, 55, 7]) {
    translate([0,-s.y/2,s.z/2]) cuboid(s);
}

module holder() {
    union() {
        cross();
        stand();
        // top();
    }
}

//output:turner_test:turner_vhs(h = 2, l = 20);
//output:turner:turner_vhs();
//output:holder:holder();

//view
holder();
