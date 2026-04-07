module cornercopy(offset) {
  for (xx=[-1, 1]) for (yy=[-1, 1])
    translate([offset.x * xx, offset.y * yy, 0]) scale([xx,yy, 1]) children();
}

module centercopy(offset) {
    translate([offset.x/2,0,0]) rotate([0,0,0]) children();
    translate([0,offset.y/2,0]) rotate([0,0,90]) children();
    translate([-offset.x/2,0,0]) rotate([0,0,180]) children();
    translate([0,-offset.y/2,0]) rotate([0,0,270]) children();
}
