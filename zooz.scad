include <BOSL2/std.scad>

$fn = 32;

module zooz_mount() {
    difference() {
        linear_extrude(0.5) rect([21, 28], rounding = 1);
        cylinder(d=4, h=10, center=true);
    }
}

//output:zooz_mount:zooz_mount();

//view
zooz_mount();
