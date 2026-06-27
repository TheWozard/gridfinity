include <BOSL2/std.scad>

height = 3;
diameter = 22;
thickness = 1;
bottom_d = 34; // inner diameter at the base (Z=0)
top_d = 23;    // inner diameter at the top (Z=height); 0 = closed apex

vent_count = 8;
vent_r = 2.5;       // radius of each vent hole
vent_place_r = 8;   // radial distance from center to place vent holes

$fn = 64;

module dome_cover() {
    r_bot = bottom_d / 2;
    r_top = top_d / 2;
    z_c   = (height * height - r_bot * r_bot + r_top * r_top) / (2 * height);
    dome_r = sqrt(z_c * z_c + r_bot * r_bot);
    dome_h = height + thickness;
    cap_d  = 2 * sqrt((dome_r + thickness) * (dome_r + thickness) - (dome_h - z_c) * (dome_h - z_c));

    difference() {
        union() {
            intersection() {
                difference() {
                    translate([0, 0, z_c]) sphere(r = dome_r + thickness);
                    translate([0, 0, z_c]) sphere(r = dome_r);
                }
                // clip to Z=[0, dome_h]
                translate([0, 0, dome_h / 2])
                    cube([dome_r * 4, dome_r * 4, dome_h], center = true);
            }
            translate([0, 0, height])
                cyl(d1 = top_d, d2 = cap_d - thickness, h = thickness, anchor = BOTTOM);
        }
        // radial vent holes
        for (i = [0 : vent_count - 1])
            rotate([0, 0, i * 360 / vent_count])
                translate([vent_place_r, 0, -0.01])
                    cyl(r = vent_r, h = dome_h + 0.02, anchor = BOTTOM);
    }
}

//output:dome_cover:dome_cover();

//view
dome_cover();
%cyl(d = diameter, h = height, anchor = BOTTOM);
