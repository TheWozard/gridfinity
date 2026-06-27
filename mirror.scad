include <BOSL2/std.scad>
include <common.scad>

mirror = [267.5,433.5,14];
screen_top = [273.5,439.5, 3.5];
screen_prism = [258,380, 11 - screen_top.z];
electronics = [250, 362, 32];
electronics_left_offset = 3;

border = 10;
extend = 10;
total_thickness = mirror.z + screen_top.z + screen_prism.z + extend;
bounding = [screen_top.x + border * 2, screen_top.y + border * 2];

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
                            dif = max([screen_top.x - mirror.x, screen_top.y - mirror.y]);
                            start = [screen_top.x, screen_top.y];
                            end = [mirror.x, mirror.y];
                            prismoid(start, end, h=dif)
                                attach(TOP, BOTTOM, overlap=0.01)
                                    cuboid(mirror - [0,0,dif] + [0,0,1]);
                        }
}

module mirror_section() {
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
}

module mirror_corners() {
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
}

module mirror_outline() {
    difference() {
        linear_extrude(screen_top.z) difference() {
            rect([screen_top.x, screen_top.y]);
            rect([mirror.x, mirror.y]);
        }
        centercopy(mirror) cuboid([20,0.01,screen_top.z * 2]);
    }
}

//output:frame:frame();
//output:body:body();
//output:mirror_section:mirror_section();
//output:mirror_corners:mirror_corners();
//output:mirror_outline:mirror_outline();

//view
frame();
