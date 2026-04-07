include <BOSL2/std.scad>
include <common.scad>

model = "outline";

mirror = [263,430,14];
screen_top = [269,436, 3.5];
screen_prism = [258,380, 11 - screen_top.z];
electronics = [250, 362, 32];
electronics_left_offset = 3;

border = 10;
extend = 10;
total_thickness = mirror.z + screen_top.z + screen_prism.z + extend;
bounding = [screen_top.x + border * 2, screen_top.y + border * 2];

if (model == "frame") {
    frame();
} else if (model == "body") {
    body();
} else if (model == "intersection") {
    thickness = 0.2;
    intersection() {
        frame();
        translate([0,0,-extend])
            cuboid([bounding.x, thickness, total_thickness], anchor=BOTTOM);
    }
    intersection() {
        frame();
        translate([0,bounding.y/2,-extend])
            cuboid([thickness, bounding.y/2, total_thickness], anchor=BOTTOM);
    }
}  else if (model == "corners") {
    thickness = [30,50];
    intersection() {
        frame();
        translate([bounding.x/2,bounding.y/2,-extend])
            cuboid([thickness.x*2, thickness.y*2, total_thickness], anchor=BOTTOM);
    }
    intersection() {
        frame();
        translate([-bounding.x/2,-bounding.y/2,-extend])
            cuboid([thickness.x*2, thickness.y*2, total_thickness], anchor=BOTTOM);
    }
}  else if (model == "outline") {
    difference() {
        linear_extrude(0.2) difference() {
            rect([screen_top.x, screen_top.y]);
            rect([mirror.x, mirror.y]);
        }
        centercopy(mirror) cuboid([20,0.01,0.4]);
    }
}

module frame() {
    difference() {
        translate([0,0,-extend]) linear_extrude(total_thickness) rect(bounding, rounding = 1);
        body();
    }
}

module body() {
    shift = (screen_top.x - screen_prism.x) / 2;
    center = (screen_prism.x - electronics.x) / 2 - electronics_left_offset;
    translate([-shift-center,0,0]) cuboid(electronics, anchor=TOP)
        attach(TOP, BOTTOM, overlap=0.01)
            translate([center,0,0]) prismoid([screen_prism.x, screen_prism.y], [screen_top.x, screen_top.y], , h=screen_prism.z, shift=[shift,0])
                attach(TOP, BOTTOM, overlap=0.01)
                    cuboid(screen_top)
                        attach(TOP, BOTTOM, overlap=0.01) {
                            // With the mirror being an overhang we have to ease into it.
                            dif = max([screen_top.x - mirror.x, screen_top.y - mirror.y]);
                            start = [screen_top.x, screen_top.y];
                            end = [mirror.x, mirror.y];
                            prismoid(start, end, h=dif)
                                attach(TOP, BOTTOM, overlap=0.01)
                                    cuboid(mirror - [0,0,dif] + [0,0,1]);
                        }
}
