
include <BOSL2/std.scad>
include <2020_profile.scad>
include <server.scad>

thickness = 5;
width = 256;

model = "schitt_switch";

if (model == "plate") {
    plate([width,200,18], thickness, 4);
} else if (model == "stopper") {
    stopper(t = thickness);
} else if (model == "focusrite") {
    mount([182, 48, 104]);
} else if (model == "schitt_switch") {
    switch([20,20,40], o = -75, st = 2) mount([127, 36, 90], o = 20);
} else if (model == "schitt") {
    mount([127, 36, 90], o = 20);
} else if (model == "pcpannel") {
    mount([106, 47, 51]);
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

module switch(size, t = thickness, st = thickness, o = 0, eps = 0.01) {
    outer = size + [st * 2,-eps,-eps];
    remainder = size.y - t;
    translate([-o,size.y/2-t,0]) {
         difference() {
            union() {
                translate([0,st/2,0]) cuboid(outer + [0,st,0]);
                translate([o,-size.y/2+t,0]) children();
            }
            cuboid(size);
            translate([0,-(remainder-size.y)/2,size.z/2-t]) prismoid(size1=[outer.x+eps,0], size2=[outer.x+eps,remainder/2], h=t);
            translate([0,-(remainder-size.y)/2,-size.z/2]) prismoid(size1=[outer.x+eps,remainder/2], size2=[outer.x+eps,0], h=t);
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

module cornercopy(offset) {
  for (xx=[-1, 1]) for (yy=[-1, 1])
    translate([offset.x * xx, offset.y * yy, 0]) scale([xx,yy, 1]) children();
}