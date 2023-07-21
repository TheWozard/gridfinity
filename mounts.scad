
desk_thickness = 10;
desk_bump_depth = 3;
desk_bump_width = 10;
desk_bump_distance_to_edge = 14;

desk_mount(30, 1, 1);

// models a clip for the edge of my standing desk
module desk_mount(l, d, t) {
    difference() {
        extended_cap(desk_bump_depth+t, desk_thickness+t*2, d,l );
        translate([-0.5,0,0])desk_edge(l+1, d+1);
    }
}

// models the edge of my standing desk
module desk_edge(l, t) {
    difference() {
        extended_cap(desk_bump_depth, desk_thickness, t, l);
        translate([l/2-desk_bump_width/2-desk_bump_distance_to_edge,desk_thickness/2,0]) rotate([0,0,-90]) rounded_cap(desk_bump_depth, desk_bump_width, t+1);
    }
}

// extends rounded_cap with an unlimeted extension value.
module extended_cap(h, w, t, e) {
    union() {
        cube([e, w, t], center=true);
        translate([e/2,0,0]) rounded_cap(h, w, t, e=min([e, 1]));
    }
}

// A function to generate a cylinder with two of its sides clipped.
// w = max width of the cylinder.
// o = the center offset. 0 is centered. 1 or -1 is at the edge of the clipped section
module rounded_cap(h, w, t, e=1) {
    r = (h/2) + ((w*w)/(8*h));
    c = h-r;
    translate([c,0,0]) intersection() {
        cylinder(h=t, r=r, center=true, $fn=32);
        translate([-c-e,-w/2,-t/2]) cube([h+e, w, t]);
    }
}