include <BOSL2/std.scad>
include <common.scad>


model = "wrap_large";

if (model == "wrap_med") {
    cable_winder([30, 100], 60);
} else if (model == "wrap_large") {
    cable_winder([35, 125], 60);
} else if (model == "wrap_xlarge") {
    cable_winder([40, 150], 60);
}

module chamfer_extrude(s, h, c, r, p = 0.01, flip = false) {
    if (flip) {
        linear_extrude(h - c) rect(s, rounding = r);
        up(h - c) hull() {
            linear_extrude(p) rect(s, rounding = r);
            up(c) linear_extrude(p) rect(s - [c,c]*2, rounding = max(r - c, 0));
        }
    } else {
        hull() {
            linear_extrude(p) rect(s - [c,c]*2, rounding = max(r - c, 0));
            up(c) linear_extrude(p) rect(s, rounding = r);
        }
        up(c) linear_extrude(h - c) rect(s, rounding = r);
    }
}

module cable_winder(s, l, bt = 4, g = 30, ct = 30, p = 0.01, ch = 2) {
    difference() {
        union() {
            $fn = 64;
            r = s.x/2;
            chamfer_extrude(s, g, ch, r);
            up(g) hull() {
                linear_extrude(p) rect(s, rounding = r);
                up(bt) linear_extrude(p) rect(s + [bt,bt], rounding = r + (bt/2));
            }
            up(bt + g) chamfer_extrude(s, l, ch, r, flip = true);
        }
        up(g) linear_extrude(l+bt+p*2) rect([s.x, ct] + [bt, 0] + [p,0]);
    }
}

