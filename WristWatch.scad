// Parametric analog wristwatch, dimensions in millimetres.
$fn = 72;

case_diameter = 42;
case_height = 7;
bezel_outer_diameter = 45;
bezel_inner_diameter = 37;
dial_diameter = 36.5;
strap_width = 20;
strap_thickness = 3;

module rounded_rect_2d(width, height, radius) {
    offset(r = radius)
        square([width - 2 * radius, height - 2 * radius], center = true);
}

module strap_half(center_y, length, hole_positions = []) {
    difference() {
        translate([0, center_y, 0.8])
            linear_extrude(height = strap_thickness)
                rounded_rect_2d(strap_width, length, 2.5);

        for (hole_y = hole_positions)
            translate([0, hole_y, 0])
                cylinder(h = 6, d = 4.2);
    }
}

module watch_case() {
    color([0.13, 0.16, 0.20])
        cylinder(h = case_height, d = case_diameter);

    color([0.73, 0.75, 0.76])
        difference() {
            translate([0, 0, case_height])
                cylinder(h = 2.2, d = bezel_outer_diameter);
            translate([0, 0, case_height - 0.1])
                cylinder(h = 2.5, d = bezel_inner_diameter);
        }

    color([0.04, 0.10, 0.17])
        translate([0, 0, case_height - 0.05])
            cylinder(h = 1.15, d = dial_diameter);

    color([0.72, 0.57, 0.27])
        for (i = [0 : 11])
            rotate([0, 0, i * 30])
                translate([0, 14.6, case_height + 1.12])
                    cube([1.2, 2.5, 0.5], center = true);

    color([0.96, 0.91, 0.75])
        for (i = [0 : 59])
            if (i % 5 != 0)
                rotate([0, 0, i * 6])
                    translate([0, 16.4, case_height + 1.10])
                        cube([0.45, 1.1, 0.28], center = true);

    color([0.90, 0.91, 0.86])
        translate([0, 0, case_height + 1.22])
            linear_extrude(height = 0.45)
                polygon(points = [
                    [-0.65, -1], [0.65, -1], [0.45, 11],
                    [0, 14], [-0.45, 11]
                ]);

    color([0.77, 0.58, 0.25])
        translate([0, 0, case_height + 1.55])
            linear_extrude(height = 0.5)
                polygon(points = [
                    [-1.1, -0.5], [1.1, -0.5], [1.7, 7],
                    [0, 10], [-1.7, 7]
                ]);

    color([0.83, 0.70, 0.38])
        translate([0, 0, case_height + 1.3])
            cylinder(h = 0.8, d = 3.2);

    color([0.81, 0.83, 0.82])
        translate([case_diameter / 2 - 0.5, 0, 3.7])
            rotate([0, 90, 0])
                cylinder(h = 5, d = 7.5);
}

module watch_strap() {
    color([0.10, 0.12, 0.14]) {
        strap_half(41.5, 48, [43, 48, 53, 58, 63]);
        strap_half(-38.5, 42);
    }

    color([0.72, 0.74, 0.75]) {
        translate([0, -60, 2.2]) {
            cube([20, 2, 2.2], center = true);
            translate([0, -4, 0])
                cube([20, 2, 2.2], center = true);
            translate([-9, -2, 0])
                cube([2, 6, 2.2], center = true);
            translate([9, -2, 0])
                cube([2, 6, 2.2], center = true);
            translate([0, -1, 0.4])
                cube([1.2, 6, 1], center = true);
        }
    }
}

watch_strap();
watch_case();
