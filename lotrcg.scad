include <BOSL2/std.scad>

$fn = 32;

module box(size=[30,30], height=10, rounding=1, chamfer=1, cut=5, cut_depth=3) {
    diff() prismoid(size1=size, size2=size, rounding=rounding, h=height-chamfer, anchor=TOP) {
        attach(BOT,TOP)
            prismoid(size1=size - ([chamfer, chamfer] * 2), size2=size, rounding1=rounding - chamfer, rounding2=rounding, h=chamfer);
        // attach([FRONT,BACK],TOP, inside=true)
        //     prismoid([cut,height+(chamfer * 2)], [cut+(cut_depth*2),height+(chamfer * 2)], h=cut_depth, anchor=BOT);
        // attach([BOT], TOP, inside=true, overlap=chamfer)
        //     prismoid([cut,size.y], [cut+(cut_depth*2),size.y], h=cut_depth);
    }
}

module band(size=[30,30], height=2, rounding=2, thickness=1){
    inset = [thickness, thickness] * 2;
    diff() prismoid(size1=size, size2=size, rounding=rounding, h=height, anchor=TOP)
        attach(TOP,TOP, inside=true, shiftout=0.1)
            prismoid(size1=size-inset, size2=size-inset, rounding1=rounding - thickness, rounding2=rounding-thickness, h=height+0.2, anchor=TOP);
}

module inset() {
    union() {
        translate([14,30,0]) rotate([90, 0,0]) cylinder(d=26, h=20);
        translate([12.5, 8,0]) rotate([90, 0,0]) cylinder(d=23, h=38);
        translate([-10.5,30,0]) rotate([90, 0,0]) cylinder(d=19, h=60);
        translate([-31,30,0]) rotate([90, 0,0]) cylinder(d=19, h=60);
    }
}

module intersect() {
    s = [band_size,band_size]*2;
    t = [0.2, 0.2];
    left(50) difference() {
        children();
        prismoid(size1=size-s+t, size2=size-s+t, rounding=3, h=band_size+1, anchor=BOT);
    }
    right(50) difference() {
        scale([-1,1,1]) children();
        cube([100,100,100], anchor=BOT);
        difference() {
            up(1) cube([100,100,band_size+1], anchor=TOP);
            prismoid(size1=size-s, size2=size-s, rounding=3, h=band_size, anchor=TOP);
        }
    }
}

band_size = 3;
chamfer = 2;
size = [80,73];

intersect() {
    difference() {
        up(band_size) box(size, height=15+chamfer+band_size, rounding=5, chamfer=2, cut=22, cut_depth=0);
        right(7) inset();
    }
}