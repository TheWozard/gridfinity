gridfinity_scale = [42, 42];
gridfnity_z_height = 7;
gridfinity_pad_height = 5;
gridfinity_corner_radius = 8;

bottom_corner_radius_ratio = 0.2;
mid_corner_radius_ratio = 0.4;

// Examples
// standard_plate([3, 5], 2);

// ---Standard Definitions
// These define standard sized gridfinity modules.

module standard_block(count) {
    standard_plate([count.x, count.y], count.z * gridfnity_z_height);
}

module standard_plate(count, z_height) {
    with_scaleable_pad(count, gridfinity_scale, gridfinity_pad_height, gridfinity_corner_radius)
    single_box_segment(
        [
            count.x * gridfinity_scale.x/2 - gridfinity_corner_radius/2, 
            count.y * gridfinity_scale.y/2 - gridfinity_corner_radius/2,
        ],
        [0, z_height],
        [gridfinity_corner_radius,gridfinity_corner_radius]
    );
}

module standard_pad() {
    scaleable_pad(gridfinity_scale, gridfnity_z_height, gridfinity_corner_radius);
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
module scaleable_pad(scale, z_height, radius, extra_height=0, extra_radius=0){
    // a list of tuples of (heigh, corner_radius) that defines breakpoints across a gridfinity pad.
    edge_definition = [
        [0, bottom_corner_radius_ratio * radius],
        [0.16 * z_height, mid_corner_radius_ratio * radius],
        [0.52 * z_height, mid_corner_radius_ratio * radius],
        [1 * z_height, radius],
    ];
    
    // Our intended ending xy size is exactly scale so we need to reduce the offset by the max corner_radius in our edge_definition.
    edge_radius_inset = max([ for (edge = edge_definition) edge[1] ])/2;
        
    // Add in extra radius to breakpoints.
    edge_definition_radius = [ for (edge = edge_definition) [edge[0], edge[1] + extra_radius ]];
    
    pad_offset = [scale.x/2 - edge_radius_inset, scale.y/2 - edge_radius_inset];
    if ( extra_height > 0 ) {
        // Add new breakpoints before and after if height is extra.
        start_breakpoint = edge_definition_radius[0];
        end_breakpoint =  edge_definition_radius[len(edge_definition_radius)-1];
        single_pad(
            pad_offset = pad_offset,
            edge_definition = concat(
                [[start_breakpoint[0]-extra_height, start_breakpoint[1]]],
                edge_definition_radius,
                [[end_breakpoint[0]+extra_height, end_breakpoint[1]]]
            )
        );
    } else {
        single_box(
            pad_offset = pad_offset,
            edge_definition = edge_definition_radius
        );
    }
}

// ---Generic Modules
// Generically useful modules

// creates multi layer box segment.
module single_box(pad_offset, edge_definition) {
    // We will tansform these 2d breakpoints to a 3d pad by iterating over them and generating
    // segments that would connect each breakpoint to the next.
    union(){
        if (len(edge_definition) > 1) {
            for (i = [0:len(edge_definition)-2]) {
                single_box_segment(
                    offset=pad_offset,
                    height=[edge_definition[i][0],edge_definition[i+1][0]],
                    corner_radius=[edge_definition[i][1],edge_definition[i+1][1]]
                );
            }
        }
    }
}

// creates a single rounded corner box segment.
module single_box_segment(offset, height, corner_radius, segments=24){
    translate([0,0,height[0]]) hull() 2d_cornercopy(offset) {        
        cylinder(d1=corner_radius[0], d2=corner_radius[1], h=height[1]-height[0], $fn=segments);
    }
}

// copies children to all 4 possible corner variations of the offset.
module 2d_cornercopy(offset) {
  for (xx=[-offset.x, offset.x]) for (yy=[-offset.y, offset.y]) 
    translate([xx, yy, 0]) children();
}

module scaleable_grid_layout(count, scale) {
  translate([-(count.x-1) / 2 * scale.x, -(count.y-1) / 2 * scale.y, 0])
  for (xx=[0:scale.x:(count.x-1) * scale.x]) for (yy=[0:scale.x:(count.y-1) * scale.x]) 
    translate([xx, yy, 0]) children();
}