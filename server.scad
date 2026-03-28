include <BOSL2/std.scad>

// 10" Server Rack Face Plate Generator

model="";

/* [Thickness] */
thickness       = 3;
corner_radius   = 5;
shelf_thickness = 4;
stopper_width   = 16;
wall_percent    = 0.5;

/* [Mounting Holes] */
hole_diameter        = 5;
hole_elongation      = 5;
countersink          = false;
countersink_diameter = 8;
countersink_depth    = 1;

/* [Rack] */
rack_width      = 255;
hole_spacing_h  = 237;
inner_width     = 212;
u_height        = 44.45;

/* [Rendering] */
p = 0.01;

if (model == "stopper") {
    stopper();
} else if (model == "ha_green") {
    shelf([112, 112, 34]) face_plate(1, [5.725, 38.725]);
} else if (model == "netgear_gs308") {
    shelf([159, 102, 28]) face_plate(1, [5.725, 38.725]);
} else if (model == "half_u_cover") {
    face_plate(0.5, [5.725]);
}


// Defines the front panel of the rack that can be attached.
module face_plate(u, holes) {
    panel_h = u * u_height;
    difference() {
        linear_extrude(thickness)
            rect([rack_width, panel_h], rounding = corner_radius, $fn = 32);
        mounting_holes(u, panel_h, holes);
    }
}

// Defines the layout of how holes align to the plate.
module mounting_holes(u, panel_h, holes) {
    xflip_copy()
        for (ui = [0 : ceil(u) - 1])
            for (h = holes) {
                y_from_top = ui * u_height + h;
                if (y_from_top < panel_h)
                    translate([
                        hole_spacing_h / 2,
                        panel_h / 2 - y_from_top,
                        -0.1
                    ]) mounting_hole();
            }
}

// Defines the mounting holes. Enables elongation and counter sinking.
module mounting_hole() {
    linear_extrude(thickness + 0.2)
        rect([hole_elongation + hole_diameter, hole_diameter], rounding = hole_diameter / 2, $fn = 16);
    if (countersink)
        hull()
            for (x = [-1, 1] * hole_elongation / 2)
                translate([x, 0, thickness - countersink_depth + 0.1])
                    cylinder(d1 = hole_diameter, d2 = countersink_diameter,
                             h = countersink_depth + 0.1);
}

module shelf(size, t = thickness, st = shelf_thickness, cr = corner_radius, wp = wall_percent, sw = stopper_width, eps = p) {
    shelf_size=[size.x+st*2,size.y-t+st,st];
    difference() {
        translate([0,t/2+st/2+eps,-eps])
        difference() {
            union() {
                translate([0,0,-size.z/2]) {
                    translate([0,0,-st/2])
                        cuboid(shelf_size, rounding = cr, edges=[BACK+RIGHT,BACK+LEFT], $fn = 32);
                    translate([0,-shelf_size.y/2+(size.y/4*wp),size.z/2])
                        right_prism([shelf_size.x,size.y*wp,size.z]);
                }
                translate([0,-shelf_size.y/2,0]) rotate([90,0,0]) children();
            }
            translate([0,shelf_size.y/2-st/2+eps,-size.z/2-eps]) stopper(w = sw, t = st);
        }
        cube(size, center=true);
    }
}

module stopper(w = stopper_width, t = shelf_thickness) {
    difference() {
        cuboid([w,t,t*2], rounding = t, edges=[TOP+RIGHT,TOP+LEFT]);
        translate([-w/2-p,0,-t/2]) rotate([0,90,0]) prismoid(size1=[t+p,t+p], size2=[0,t+p], h=t/2);
        translate([w/2+p,0,-t/2]) rotate([0,-90,0]) prismoid(size1=[t+p,t+p], size2=[0,t+p], h=t/2);
    }
}

module right_prism(size) {
    prismoid(
        size1 = [size.x, size.y],
        size2 = [size.x, 0],
        shift = [0, -size.y/2],
        h = size.z,
        anchor = CENTER
    );
}
