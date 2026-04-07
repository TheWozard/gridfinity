include <common.scad>
include <BOSL2/std.scad>

pi = [85, 56.2];
pi_holes = [58.1, 49];

buck = [65.5, 39.2];
buck_holes = [58.2, 32];

power_plug_diameter = 10.4;
power_plug_catch_length = 10;
power_plug_thickness = 3;
power_plug_holder = [power_plug_diameter + 2 * power_plug_thickness, 16];

post_height = 3;
post_diameter = 5;
post_inner_diameter = 2;

spacing = 5;

ts = [
    pi.x + buck.x + spacing * 1,
    pi_holes.y,
    2,
];

difference() {
    plug = [-ts.x/2 - power_plug_holder.x, ,0,0];
    union() {
        ax = ts.x/2 - buck_holes.x/2;
        bx = ts.x/2 - pi.x/2;
        band(ts);
        translate([ax,ts.y/2 - buck_holes.y/2,0]) buck_standoffs();
        translate([-bx,0,0]) pi_standoffs();
        translate(plug) plug_holder();
        translate(plug+[2.5,0,0]) band([power_plug_holder.x+5,power_plug_holder.x,2]);
        translate([20,0,ts.z/2])cuboid([spacing * 4,ts.y,ts.z]);
    }
    translate(plug) cuboid([power_plug_diameter,power_plug_diameter,power_plug_diameter]);
}


module plug_holder(s = power_plug_holder) {
    $fn = 16;
    rotate([90,0,0]) translate([0,s.x/2,0]) difference() {
        translate([0,-s.x/4,0]) cuboid([s.x, s.x/2, s.y], rounding = 1, edges=[TOP+RIGHT,TOP+LEFT,BOTTOM+RIGHT,BOTTOM+LEFT]);
        plug();
    }
}

module plug(s = power_plug_holder, p = 0.01) {
    $fn = 64;
    union() {
        cuboid([power_plug_diameter, power_plug_diameter, power_plug_catch_length]);
        translate([0,0,-s.y/2 - p]) cylinder(d = power_plug_diameter, h=s.y+p*2);
    }
}

module pi_standoffs() {
    holes = pi_holes/2;
    translate([-(pi.x-pi_holes.x)/2,0,0]) union() {
        translate([holes.x,holes.y,0]) standoff();
        translate([holes.x,-holes.y,0]) standoff();
        translate([-holes.x,holes.y,0]) standoff();
        translate([-holes.x,-holes.y,0]) standoff();
    }
}

module buck_standoffs() {
    holes = buck_holes/2;
    union() {
        translate([holes.x,holes.y,0]) standoff();
        translate([holes.x,-holes.y,0]) standoff();
        translate([-holes.x,holes.y,0]) standoff();
        translate([-holes.x,-holes.y,0]) standoff();
    }
}

module standoff(od = 5, id = 3, h = 8, p = 0.01) {
    $fn = 32;
    difference() {
        cylinder(d = od, h = h);
        translate([0,0,p]) cylinder(d = id, h = h + p*2);
    }
}


module band(s, w = 10, r = 5) {
    o = [s.x, s.y] + [w, w];
    i = [s.x, s.y] - [w, w];
    linear_extrude(s.z)
    difference() {
        $fn = 32;
        rect(o, rounding = r);
        rect(i, rounding = max(r-w, 1));
    }
}