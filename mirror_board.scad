include <gridfinity_core.scad>
include <BOSL2/std.scad>

pi = [85, 56.2];
pi_holes = [55.5, 46.5];

buck = [65.5, 39.2];
buck_holes = [55, 28.5];

power_plug_diameter = 10.4;
power_plug_catch_length = 10;
power_plug_length = 16;
power_plug_thickness = 3;

post_height = 3;
post_diameter = 5;
post_inner_diameter = 2;

plug_holder();

module plug_holder() {
    outer_diameter = power_plug_diameter + 2 * power_plug_thickness;
    rotate([90,0,0]) translate([0,outer_diameter/2,0]) difference() {
        translate([0,-outer_diameter/4,0]) cuboid([outer_diameter, outer_diameter/2, power_plug_length]);
        plug();
    }
}

module plug() {
    $fn = 32;
    union() {
        cuboid([power_plug_diameter, power_plug_diameter, power_plug_catch_length]);
        translate([0,0,-power_plug_length/2 - 0.01]) cylinder(d = power_plug_diameter, h=power_plug_length+0.02);
    }
}

module pi_board_posts() {
    holes = pi_holes/2;
    union() {
        translate([holes.x,holes.y,0]) board_post();
        translate([holes.x,-holes.y,0]) board_post();
        // translate([-holes.x,holes.y,0]) board_post();
        translate([-holes.x,-holes.y,0]) board_post();
    }
}

module buck_board_posts() {
    holes = buck_holes/2;
    union() {
        translate([holes.x,holes.y,0]) board_post();
        translate([holes.x,-holes.y,0]) board_post();
        translate([-holes.x,holes.y,0]) board_post();
        translate([-holes.x,-holes.y,0]) board_post();
    }
}

module board_post() {
    $fn = 16;
    difference() {
        cylinder(d = post_diameter, h = post_height);
        translate([0,0,-0.01]) cylinder(d = post_inner_diameter, h = post_height + 0.02);
    }
}