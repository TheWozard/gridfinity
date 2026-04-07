
include <BOSL2/std.scad>
include <common.scad>
include <server.scad>

thickness = 5;
width = 256;

model = "mini_stopper_tall";
switch_size = [19,16,61];
schitt_size = [127, 36, 90];
schitt_size_top = [128.5, 36, 90];

if (model == "plate") {
    plate([width,200,18], thickness, 4);
} else if (model == "mini_stopper") {
    stopper(t = thickness, w = stopper_width - 0.2);
} else if (model == "mini_stopper_tall") {
    stopper(t = thickness, w = stopper_width - 0.2, h = thickness);
    translate([0,0,thickness]) cuboid([schitt_size.x,thickness,thickness*2], rounding = thickness, edges=[TOP+RIGHT,TOP+LEFT]);
    translate([0,thickness/2,thickness/2]) cuboid([schitt_size.x,1,thickness*3], rounding = thickness, edges=[TOP+RIGHT,TOP+LEFT]);
} else if (model == "switch") {
    difference() {
        switch(switch_size, st = 2);
        cuboid([100, 100, 0.01]);
    }
} else if (model == "plug") {
    plug(15, 13, 35);
} else if (model == "focusrite") {
    mount([182, 48, 104]);
} else if (model == "schitt_top") {
    within(schitt_size_top)
    switch(switch_size, o = [-75,0,schitt_size_top.y/2 + thickness], st = 2) mount(schitt_size_top, o = 20);
} else if (model == "schitt_bottom") {
    within(schitt_size)
    switch(switch_size, o = [-75,0,-schitt_size.y/2 - thickness], st = 2) mount(schitt_size, o = 20);
} else if (model == "pcpannel") {
    plug(15, 13, 35, o=[70,0,0]) mount([106, 47, 51], o = -30);
}

module mount(size, o = 0) {
    shelf([size.x, size.z, size.y], t = thickness, st = thickness, cr = thickness, wp = 0.75, o = o) face_plate([size.x, size.y]);
}

module face_plate(size) {
    front = width - thickness * 2;
    hole_thickness = thickness + 0.02;
    rotate([90,0,0]) difference() {
        linear_extrude(thickness)
        difference() {
            rect([front, size.y + thickness * 2], rounding = thickness, $fn = 32);
        }
        translate([front/2 - 10, 0,  - 0.01]) cylinder(d = 5, h = hole_thickness, $fn = 32);
        translate([-front/2 + 10, 0, - 0.01]) cylinder(d = 5, h = hole_thickness, $fn = 32);
    }
}

module within(size) {
    intersection() {
        cuboid([width, size.z, size.y] + [thickness, thickness, thickness] * 2 + [0, 1000, 0]);
        children();
    }
}

module switch(size, t = thickness, st = thickness, o = [0,0,0], eps = 0.01) {
    outer = size + [st * 2,-eps,-eps+st*2];
    remainder = size.y - t;
    translate(-o + [0,size.y/2-t,0]) {
         difference() {
            union() {
                translate([0,st/2,0]) cuboid(outer + [0,st,0]);
                translate(o + [0,-size.y/2+t,0]) children();
            }
            cuboid(size);
            translate([0,-(remainder-size.y-st)/2,outer.z/2-st/2]) cuboid([size.x-t + eps * 2,remainder+st,st + eps * 2]);
            translate([0,-(remainder-size.y-st)/2,-outer.z/2+st/2]) cuboid([size.x-t + eps * 2,remainder+st,st + eps * 2]);
        }
    }
}


module plate(size, inset, thickness) {
    corners = [size.x/2 - inset - 10, size.y/2 - inset - 10];
    internal = inset * 4 + 40;
    difference() {
        cuboid(size, rounding=inset, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
        cornercopy(corners) translate([0,0, thickness/2]) bar_with_screw_hole(size.z - thickness + 0.02, inset+0.01, thickness/2);
        cuboid(size-[internal,internal, -0.02], rounding=inset, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
    }
}

module sleave(size) {
    difference() {
        cuboid(size, rounding=5, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
        bar_with_screw_hole(size.z + 0.02, (size.x-20)/2);
    }
}

module bar_with_screw_hole(height, depth, offset = 0) {
    size = 20.5;
    cuboid([size,size,height], rounding=1, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT])
    translate([0, size/2 + depth/2 - 0.01, -offset]) teardrop_screw_hole(5, depth + 0.02);
    translate([size/2 + depth/2 - 0.01, 0, -offset]) rotate([0, 0, 90]) teardrop_screw_hole(5, depth + 0.02);
}

module teardrop_screw_hole(diameter, depth) {
    rotate([90, 0, 0]) linear_extrude(depth, center=true)
        teardrop2d(d=diameter, ang=45, $fn=32);
}

module plug(od, id, h, o = [0,0,0], t = 2, i = 5, p = 0.01) {
    tp = od - id;
    translate(-o + [0,-i,0]) rotate([-90,0,0]) {
        union() {
            difference() {
                union() {
                    cylinder(d = od + t * 2, h = h + t, $fn = 32);
                    rotate([90,0,0]) translate(o + [0,i,0]) children();
                }
                translate([0,0,-p]) cylinder(d = od, h = h - tp + p, $fn = 32)
                    attach(TOP, BOTTOM, overlap = p) cylinder(d1 = od, d2 = id, h = tp + p * 2, $fn = 32)
                        attach(TOP, BOTTOM, overlap = p) cylinder(d = id, h = t + p * 2, $fn = 32);
            }
            translate([0,0,h + t]) torus(id = id, od = od + t * 2, $fn = 32);
        }
    }
}
