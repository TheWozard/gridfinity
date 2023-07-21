diameter = 29.4;
indent_diameter = 3.6;
thickness = 4;
height = 25; // 25
indent = 15;
outer_diameter = diameter + thickness;
outer_thicknes = thickness;

union() {
    difference() {
        scale([1, 2, 1]) cylinder(h=height, d=outer_diameter, $fn=64);
        translate([0,0, -1])scale([1, outer_diameter*2/(outer_diameter-outer_thicknes/2), 1]) cylinder(h=height+2, d=outer_diameter-outer_thicknes, $fn=64);
    }
    difference() {
        cylinder(h=height, d=outer_diameter, $fn=64);
        difference() {
            translate([0,0, -1]) cylinder(h=height+2, d=diameter, $fn=32);
            rotate([0,0,80]) for (xx=[-1, 1]) translate([diameter/2 * xx, 0 , -1]) cylinder(h=indent+1, d=indent_diameter, $fn=16);
        }
    }
}
