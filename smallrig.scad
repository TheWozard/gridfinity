include <BOSL2/std.scad>
include <common.scad>

insert_camera = 6.5;
outer_d = 50;
inner_d = 9;
thickness = 6;
corner_r = 2;

$fn = 128;

difference() {
    linear_extrude(height = thickness)
        offset(r = corner_r, $fn = 64)
        offset(r = -corner_r)
        polygon([
            [0,          outer_d/2],
            [inner_d/2,  0        ],
            [0,         -outer_d/2],
            [-inner_d/2, 0        ],
        ]);
    translate([0,0,-0.01]) cylinder(h = thickness + 0.02, d = insert_camera);
}
