include <gridfinity_core.scad>

gridfinity_indent = [gridfinity_corner_radius, gridfinity_corner_radius] * 2;
magnet_color = "#023047";
snap_color = "#219ebc";

// Examples
// with_standard_magnets([1, 2]) standard_plate([1, 2], 2);
// with_standard_snap_fit([1, 2]) standard_plate([1, 2], 2);

// ---Standard Definitions
// These define standard sized gridfinity modules.

module with_push_fit_magnets(count) {
    with_scaleable_magnets(
        count, gridfinity_scale, gridfinity_indent,
        magnet_diameter=6.2, magnet_depth=2.2
    ) children();
}

module with_standard_magnets(count) {
    with_scaleable_magnets(
        count, gridfinity_scale, gridfinity_indent,
        magnet_diameter=6.5, magnet_depth=2.4
    ) children();
}

module with_standard_snap_fit(count) {
    with_scaleable_snap_fit(
        count, gridfinity_scale, gridfinity_indent,
        [
            gridfinity_corner_radius * bottom_corner_radius_ratio,
            gridfinity_corner_radius * mid_corner_radius_ratio
        ], 1.4, 10, 3
    ) children();
}

// ---Scalable Definition
// These define entirely custom scalable modules that make use of no globals.

module with_scaleable_snap_fit(
    count, scale, indent, radius, depth, size, width
) {
    true_scale = ([scale.x * count.x, scale.y * count.y] - indent);
    max_radius = max(radius);
    union() {
        children();

        color(snap_color)
        render() union() {
            difference() {
                single_box(
                    true_scale/2,
                    [
                        [-depth, radius[1]],
                        [-1, radius[1]],
                        [0,  radius[0]]
                    ]
                );
                single_box(
                    true_scale/2 - [width, width],
                    [
                        [-depth-1, radius[1]],
                        [-1, radius[1]],
                        [0,  radius[0]]
                    ]
                );
                translate([0,0,-depth]) cube([true_scale.x+max_radius+1, true_scale.y-size*2, depth*2], center = true);
                translate([0,0,-depth]) cube([true_scale.x-size*2, true_scale.y+max_radius+1, depth*2], center = true);
            }
        }
    }
}

module with_scaleable_magnets(
    count, scale, min_indent,
    magnet_diameter, magnet_depth, extra_depth=0.1,
    segments=24
) {
    true_indent = [
        min((scale.x/2)-min_indent.x, scale.x/2 - 4 - magnet_diameter/2),
        min((scale.y/2)-min_indent.y, scale.y/2 - 4 - magnet_diameter/2)
    ];

    difference() {
        children();

        color(magnet_color) scaleable_grid_layout(count, scale)
        cornercopy([true_indent.x, true_indent.y])
        translate([0,0,-extra_depth])
        cylinder(h=magnet_depth+extra_depth, d=magnet_diameter, $fn=segments);
    }
}
