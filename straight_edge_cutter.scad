
width = 15;
mount = [42.8, width, 7.8];
leg = [130 - 40, width, 1];
cap = [width, width, 15];
chamfer = width / 2;

difference() {
    union() {
        cube(mount);
        translate([0,0,-leg.z]) cube([leg.x+cap.x, leg.y, leg.z]);
        translate([leg.x,0,0]) cube(cap);

        // fillet between cap and leg
        translate([leg.x-mount.z, 0, 0])
        difference() {
            cube([mount.z, width, mount.z]);
            translate([0, -0.1, mount.z])
            rotate([-90, 0, 0])
            cylinder(r=mount.z, h=width+0.2, $fn=64);
        }
    }
    // chamfer far x edge of cap
    translate([leg.x+cap.x+0.1, leg.y+0.1, cap.z+ 0.1])
    rotate([90, 180, 0])
    linear_extrude(height=cap.y+0.2)
    polygon([
        [0, 0],
        [chamfer, 0],
        [0, chamfer]
    ]);
}
