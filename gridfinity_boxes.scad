include <gridfinity_core.scad>
include <gridfinity_decorations.scad>

edge_rounding = gridfinity_corner_radius;

// Examples

// with_push_fit_magnets([1, 2])
// with_standard_plate([1, 2], 2)
// standard_fins([1, 1], 20, 1);

// Flashlight
// with_push_fit_magnets([1, 3])
// with_standard_plate([1, 3], 2, within_height=100)
// union() {
//     translate([0, -0.75 * gridfinity_scale.y, 0]) standard_fits([1, 1.5], 28, base_thickness=3.5);
//     translate([0, 0.75 * gridfinity_scale.y, 0]) standard_fits([1, 1.5], 35, base_thickness=0);
// }

// with_push_fit_magnets([1, 2])
// with_standard_plate([1, 2], 2, within_height=100)
// standard_fits([1, 1], 11, base_thickness=0, extra_height=30, round_ratio=1);


// Pen Box
// pencil_box([2,4,3], 0.5, 10.25, base_thickness=0.4);

// Pencil Box
// pencil_box([2,5,2], 4, 8, base_thickness=0.4, thickness=1.2, box_bonus=1);

// Box
box([2,4,4]);

// ---Full things

module pencil_box(size, length, spacing, thickness=1.5, base_thickness=0,  bottom_thickness=0.8, lip=1, box_bonus=0) {
    with_push_fit_magnets(size)
    from_standard_block(size)
    render(convexity=3) difference() {
        standard_box(size + [0,0, box_bonus], thickness,  bottom_thickness=bottom_thickness, lip=lip);
        translate([0,0, bottom_thickness]) standard_fits([size.x, length], spacing, base_thickness=base_thickness, min_thickness=thickness);
    }
}

module box(size, thickness=1.5, base_thickness=0,  bottom_thickness=0.8, lip=1, box_bonus=0) {
    with_push_fit_magnets(size)
    from_standard_block(size)
    render(convexity=3) standard_box(size + [0,0, box_bonus], thickness,  bottom_thickness=bottom_thickness, lip=lip);
}

// ---Standard Definitions
// These define standard sized gridfinity modules.


module standard_fits(count, d, min_thickness=1, base_thickness=0, round_ratio=1, round_sides=edge_rounding, extra_height=0) {
    width = count.x * gridfinity_scale.x - min_thickness;
    spaces = floor(width/(d + min_thickness));
    thickness = (count.x * gridfinity_scale.x - (spaces * d)) / (spaces + 1);
    standard_fins(
        count, d/2 + base_thickness + extra_height, spaces,
        thickness=thickness,
        base_thickness=base_thickness,
        round_ratio=round_ratio,
        round_sides=round_sides
    );
}

module standard_fins(count, height, spaces, thickness=1, base_thickness=0, round_ratio=1, rounded=true, round_sides=0) {
    scaleable_fins(
        [count.x * gridfinity_scale.x, count.y * gridfinity_scale.y, height], spaces,
        thickness=thickness,
        base_thickness=base_thickness,
        round_ratio=round_ratio,
        rounded=rounded,
        round_sides=round_sides
    );
}

// standard_box([1,2,2], 1);
module standard_box(count, thickness, top_edge=0.2, bottom_thickness=0.8, lip=1) {
    translate([0,0, bottom_thickness]) scaleable_bin(
        [count.x * gridfinity_scale.x - thickness * 2, count.y * gridfinity_scale.y - thickness * 2, count.z * gridfnity_z_height - gridfinity_pad_height - bottom_thickness - top_edge],
        gridfinity_corner_radius - thickness,
        gridfinity_corner_radius * bottom_corner_radius_ratio,
        lip,
        bottom_radius = gridfinity_corner_radius * mid_corner_radius_ratio
    );
}

// ---Scalable Definition
// These define entirely custom scalable modules that make use of no globals.

// scaleable_bin([40,40,30], 8, 7, 1, 3);
module scaleable_bin(size, side_radius, top_radius, top_height, bottom_radius=0, segments=32) {
    ratio = side_radius/bottom_radius;
    hull() {
        translate([0,0,size.z-top_height])
        cornercopy([size.x, size.y]/2 - [side_radius, side_radius])
        cylinder(r1=side_radius, r2=top_radius, h=top_height, $fn=segments);
        if (bottom_radius == 0) {
            cornercopy([size.x, size.y]/2 - [side_radius, side_radius])
            cylinder(r=side_radius, h=size.z/2, $fn=segments);
        } else {
            translate([0,0,bottom_radius])
            cornercopy([size.x, size.y]/2 - [side_radius, side_radius])
            scale([ratio, ratio, 1])
            sphere(r=bottom_radius, $fn=segments);
        }
    }
}

// Creates a comb like structure
// scaleable_fins([40, 5, 40], 2, round_sides=20);
module scaleable_fins(base, slots, thickness=1, base_thickness=1, round_ratio=1, rounded=true, round_sides=0, epsilon=1) {
    width = (base.x - thickness * (slots + 1)) / slots;
    true_base_thickness = base_thickness + ((width / 2) * round_ratio);
    difference() {
        union() {
            translate([0, 0, (base.z + epsilon) / 2 - epsilon])
            cube(base + [0 , round_sides * 2, 0] + [0, 0, epsilon], center = true);
            if (rounded) {
                repeat_across(slots+1, base.x - thickness)
                translate([0, 0, base.z])
                rotate([90, 0, 0])
                cylinder(d = thickness, h=base.y + round_sides * 2, center = true, $fn=12);
            }
        }

        repeat_across(slots, base.x - thickness * 2  - width)
            translate([0, 0, base.z / 2 + true_base_thickness])
            cube([width, base.y + epsilon + round_sides * 2, base.z], center=true);

        if (rounded) {
            repeat_across(slots, base.x - thickness * 2  - width)
                translate([0, 0, true_base_thickness])
                rotate([90, 0, 0])
                scale([1, round_ratio, 1])
                cylinder(d = width, h=base.y + epsilon + round_sides * 2, center = true, $fn=32);
        }

        if (round_sides > 0) {
            translate([0, 0, round_sides])
            rotate([90, 0, 90])
            repeat_across(2, base.y + round_sides * 2)
            union() {
                cylinder(r = round_sides, h=base.x + epsilon, center = true, $fn=32);
                translate([0, base.z/2, 0]) cube([round_sides * 2, base.z, base.x + epsilon], center = true);
            }
        }
    }
}

// ---Generic Modules
// Generically useful modules
module repeat_across(count, width) {
    if (count == 1) {
        children();
    } else {
        for (i = [0:count-1])
            translate([(i/(count-1)) * width - width / 2, 0, 0]) children();
    }
}