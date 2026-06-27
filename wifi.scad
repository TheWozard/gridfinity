include <BOSL2/std.scad>
include <common.scad>

coaster_size  = 90;
coaster_thick = 3;
border        = 5;
qr_thick      = 1;
corner_r      = 4;
$fn           = 64;

qr_size = coaster_size - border * 2;

module wifi_coaster() {
    union() {
        cuboid([coaster_size, coaster_size, coaster_thick],
               rounding = corner_r,
               edges = [FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT],
               anchor = BOT);

        up(coaster_thick - 0.01)
            linear_extrude(height = qr_thick + 0.01)
                offset(r=0.001) offset(r=-0.001)
                    resize([qr_size, qr_size])
                        import("wifi.svg", center = true);
    }
}

//output:wifi_coaster:wifi_coaster();

//view
wifi_coaster();
