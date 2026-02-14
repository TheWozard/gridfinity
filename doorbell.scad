
difference() {
    rounded_box([50,150], 22, [10,10]);
    rounded_box([42,142], 24, [9,9]);
    translate([-30,0,]) scale([1, 1, 15/65]) rotate([0,90,0])
    cylinder(d=140, h=60, $fn=64);
    hull() {
        translate([25,75,-10]) cylinder(d=5, h=10, $fn=4);
        translate([-25,75,-10]) cylinder(d=5, h=10, $fn=4);
        translate([25,-75,-3.6]) cylinder(d=5, h=10, $fn=4);
        translate([-25,-75,-7.6]) cylinder(d=5, h=10, $fn=4);
    }
}

// Creates a single rounded box of exactly the given size.
module rounded_box(size, height, corner_radius, segments=24){
    max_radius = max(corner_radius);
    hull() cornercopy([size.x, size.y]/2 - [max_radius, max_radius]) {
        cylinder(r1=corner_radius[0], r2=corner_radius[1], h=height, $fn=segments);
    }
}

// copies children to all 4 possible corner variations of the offset.
module cornercopy(offset) {
  for (xx=[-offset.x, offset.x]) for (yy=[-offset.y, offset.y])
    translate([xx, yy, 0]) children();
}