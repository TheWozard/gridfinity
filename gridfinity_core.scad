gridfinity_scale = [42, 42];
gridfnity_z_height = 7;
gridfinity_pad_height = 5;
gridfinity_corner_radius = 4;

bottom_corner_radius_ratio = 0.2;
mid_corner_radius_ratio = 0.4;

// Examples
// standard_plate([5, 4], 2);
// standard_block([2, 2, 2]);
// standard_pad();

// ---Standard Definitions
// These define standard sized gridfinity modules.

module standard_block(count) {
    with_scaleable_pad(count, gridfinity_scale, gridfinity_pad_height, gridfinity_corner_radius)
    difference() {
        rounded_box(
            [count.x * gridfinity_scale.x, count.y * gridfinity_scale.y],
            count.z * gridfnity_z_height,
            [gridfinity_corner_radius, gridfinity_corner_radius]
        );
        translate([0,0, count.z * gridfnity_z_height - gridfinity_pad_height]) scaleable_pad(
            [count.x * gridfinity_scale.x, count.y * gridfinity_scale.y],
            gridfinity_pad_height, gridfinity_corner_radius, extra_height = 1
        );
    }
}

module standard_plate(count, height) {
    with_scaleable_pad(count, gridfinity_scale, gridfinity_pad_height, gridfinity_corner_radius)
    rounded_box(
        [count.x * gridfinity_scale.x, count.y * gridfinity_scale.y],
        height,
        [gridfinity_corner_radius, gridfinity_corner_radius]
    );
}

module standard_pad() {
    scaleable_pad(gridfinity_scale, gridfinity_pad_height, gridfinity_corner_radius);
}

module standard_grid_layout(count) {
    scaleable_grid_layout(count, gridfinity_scale) children();
}

// ---Scalable Definition
// These define entirely custom scalable modules that make use of no globals.

module with_scaleable_pad(count, scale, pad_height, radius) {
    union() {
        translate([0,0, pad_height]) children();

        scaleable_grid_layout(count, scale)
        scaleable_pad(scale, pad_height, radius);
    };
}

// creates a scalable gridfinity pad
// scaleable_pad([20,20], 4, 4);
module scaleable_pad(size, height, radius, extra_height=0, extra_radius=0){
    // a list of tuples of (heigh, corner_radius) that defines breakpoints across a gridfinity pad.
    edge_definition = [
        [0, bottom_corner_radius_ratio * radius],
        [0.16 * height, mid_corner_radius_ratio * radius],
        [0.52 * height, mid_corner_radius_ratio * radius],
        [1 * height, radius],
    ];

    // Add in extra radius to breakpoints.
    edge_definition_with_extra_radius = [ for (edge = edge_definition) [edge[0], edge[1] + extra_radius ]];
    size_with_extra_radius = size + [extra_radius, extra_radius] * 2;

    if ( extra_height > 0 ) {
        // Add new breakpoints before and after if height is extra.
        start_breakpoint = edge_definition_with_extra_radius[0];
        end_breakpoint =  edge_definition_with_extra_radius[len(edge_definition_with_extra_radius)-1];
        fill() segmented_rounded_box(
            size_with_extra_radius,
            concat(
                [[start_breakpoint[0]-extra_height, start_breakpoint[1]]],
                edge_definition_with_extra_radius,
                [[end_breakpoint[0]+extra_height, end_breakpoint[1]]]
            )
        );
    } else {
        fill() segmented_rounded_box(size_with_extra_radius, edge_definition_with_extra_radius);
    }
}

// ---Generic Modules
// Generically useful modules

// Creates multi layer box segment by defining a size and an edge defintion.
// This will iterate over the edge_definition creating a continous rounded box with
// smoothly changing radious.
// edge_definition list of tuples of (height, radius)
// segmented_rounded_box([20,20], [[0,3],[1,5],[2,3],[5,4]]);
module segmented_rounded_box(size, edge_definition, eps=0.001) {
    // We will tansform these 2d breakpoints to a 3d pad by iterating over them and generating
    // segments that would connect each breakpoint to the next.
    union(){
        if (len(edge_definition) > 1) {
            max_radius = max([for (edge = edge_definition) edge[1]]);
            offset = [for (edge = edge_definition) max_radius - edge[1]];
            for (i = [0:len(edge_definition)-2]) {
                segment_offset = min([offset[i], offset[i+1]]);
                translate([0,0,edge_definition[i][0] - eps/2])
                rounded_box(
                    size=size- [segment_offset,segment_offset] * 2,
                    height=abs(edge_definition[i][0]-edge_definition[i+1][0])+eps,
                    corner_radius=[edge_definition[i][1],edge_definition[i+1][1]]
                );
            }
        }
    }
}

// Creates a single rounded box of exactly the given size.
// rounded_box([20,20], 2, [3,2]);
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

module scaleable_grid_layout(count, scale) {
  translate([-(count.x-1) / 2 * scale.x, -(count.y-1) / 2 * scale.y, 0])
  for (xx=[0:scale.x:(count.x-1) * scale.x]) for (yy=[0:scale.x:(count.y-1) * scale.x])
    translate([xx, yy, 0]) children();
}

module sequentialHull(){
    for (i = [0: $children-2])
        hull(){
            children(i);
            children(i+1);
        }
}
