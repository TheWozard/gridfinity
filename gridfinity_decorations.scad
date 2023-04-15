include <gridfinity_core.scad>

gridfinity_indent = [grifinity_corner_radius, grifinity_corner_radius];
magnet_color = "#023047";

// Examples
// with_standard_magnets([1, 2]) standard_plate([1, 2], 2);

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

// ---Scalable Definition
// These define entirely custom scalable modules that make use of no globals.

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
        2d_cornercopy([true_indent.x, true_indent.y])
        translate([0,0,-extra_depth]) 
        cylinder(h=magnet_depth+extra_depth, d=magnet_diameter, $fn=segments);
    }
}
