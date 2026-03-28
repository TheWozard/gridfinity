include <BOSL2/std.scad>

spacing = 4;
size = 20.5;
length = 50;
indent = 5.6;
screw=5;
screw_indent=10;
$fn = 128;

// t_joint(size, length, spacing, indent);
// l_joint(size, length, spacing, indent);
// l_top_joint(size, length, spacing, 20/6);
// translate([0, -length-size, length*2+size]) rotate([90, 0, 180]) scale([-1,1,1]) l_top_joint(size, length, spacing, 4);
// l_slot_joint(size, length, spacing);
// translate([+length+size*2, -length-size/2, 0]) rotate([0, 0, -90]) scale([-1,1,1]) l_slot_joint(size, length, spacing);

module l_slot_joint(x, y, s, i) {
    difference() {
        l_cap_exterior(x+s*2, y+s*2, s);
        l_cap_interior(x, y, s, screw_indent);
    }
}

module l_top_joint(x, y, s, i) {
    difference() {
        l_exterior(x+s*2, y+s*2);
        l_interior_one_sided(x, y, s, screw_indent);
        translate([-x+i,-y*2,0]) cube([x, y*2, y*2]);
    }
}

module t_joint(x, y, s, i, extra=.1) {
    difference() {
        t_exterior(x+s*2, y+s*2, extra);
        t_interior(x, y+s*3+extra, s, i, screw_indent, extra);
    }
}

module t_interior(x, y, s, i, indent, extra=.1) {
    union() {
        translate([s/2,0,y/2+x/2+s]) cube([x+s+extra,x,y], center=true);
    }
}

module t_exterior(x, y, extra=.1) {
    union() {
        l_exterior(x, y, extra);
        rotate([0, 0, 180]) l_exterior(x, y, extra);
    }
}

module l_joint(x, y, s, i, extra=.1) {
    difference() {
        l_exterior(x+s*2, y+s*2, extra);
        l_interior(x, y+s*3+extra, s, i, screw_indent, extra);
    }
}

module l_exterior(x, y, extra=.1) {
    union() {
        translate([0,0,x/2-extra]) cube([x,x,y+extra], anchor=BOT);
        translate([0,x/2,0]) rotate([90, 0, 0]) cube([x,x,x+y], anchor=BOT);
        translate([0,-x/2,x/2]) rotate([90, 0, -90]) hi_res_fillet(y,x);
    }
}

module l_cap_exterior(x, y, s, extra=.1) {
    union() {
        translate([0,0,x/2-extra]) cube([x,x,y+extra], anchor=BOT);
        translate([0,-x/2+s,x/2-s/2]) rotate([90, 0, 0]) cube([x-s*2,s,y+s], anchor=BOT);
        translate([-s/2,-x/2,x/2]) rotate([90, 0, -90]) hi_res_fillet(y,x-s);
        translate([x/2,0,x/2-s/2]) rotate([90, 0, 90]) cube([x-s*2,s,y], anchor=BOT);
        translate([x/2,s/2,x/2]) rotate([90, 0, 0]) hi_res_fillet(y,x-s);
    }
}

module l_interior(x, y, s, i, indent, extra=.1) {
    union() {
        translate([0,0,x/2+s]) cube(x,y,i);
        for (r = [[0,0,90],[0,0,-90]]) {
            rotate(r) translate([0,x/2+s,y+x/2+s-indent]) rotate([90,0,0]) screw_hole(s*2+extra);
        }
        translate([0,x/2,0]) rotate([90, 0, 0]) extruded_bar(x,x+y,i);
        for (r = [[0,0,0],[0,180,0]]) {
            rotate(r) translate([-x/2-s,-(y+x/2-indent),0]) rotate([90,0,90]) screw_hole(s*2+extra);
        }
    }
}

module l_interior_one_sided(x,y,s,si, extra=.1) {
    union() {
        translate([-x,0,x/2+s]) cube([x*3,x,y+x+extra], anchor=BOT);
        for (r = [[0,0,0],[0,0,-90]]) {
            rotate(r) translate([0,x/2+s,y+x+s/2-si]) rotate([90,0,0]) screw_hole(s*2);
        }
        translate([-x,x/2,0]) rotate([90, 0, 0]) cube([x*3,x,y+(2*x)+extra], anchor=BOT);
        for (r = [[0,-90,0],[0,180,0]]) {
            rotate(r) translate([-x/2-s,-(y+x+s/2-si),0]) rotate([90,0,90]) screw_hole(s*2);
        }
    }
}

module l_cap_interior(x,y,s,si, extra=.1) {
    union() {
        translate([0,0,-y-x]) cube([x,x,(y+x)*3], anchor=BOT);
        for (r = [[0,90,0], [0,90,90], [-90,0,0], [-90,0,-90]]) {
            rotate(r) translate([-x/2-s,-(y+x+s/2-si),0]) rotate([90,0,90]) screw_hole(s*2);
        }
    }
}

// Defines a fillet using a cube allowing for increased resolution.
module hi_res_fillet(x, y, extra=.1) {
    translate([x/2,x/2,0])
    difference() {
        cube([x+extra,x+extra,y], center=true);
        translate([x/2,x/2,0]) cylinder(r=x, h=y+extra, center=true);
    }
}

// Screw hole with a larger diameter for the head.
module screw_hole(h, iD=screw,xD=screw*2,, extra=.1) {
    union() {
        cylinder(d=iD, h=h/2);
        translate([0,0,-h/2]) cylinder(d=xD, h=h/2+extra);
    }
}

// Defines an approximation of the extruded aluminum.
module extruded_bar(size, length, inset) {
    insetRotated = cos(45) * inset;
    difference() {
        cube([size, size, length], anchor=BOT);
        for (i = [2,-2]) {
            translate([0,size/i,-1]) rotate([0,0,45]) cube([inset, inset, length+2], anchor=BOT);
        }
    }
}

