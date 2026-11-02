// Compact parametric village car, dimensions in millimetres.
$fn = 32;

body_width = 22;
wheelbase = 25;
wheel_radius = 5.2;
wheel_arch_depth = 4.4;

module lower_body() {
    difference() {
        hull() {
            translate([0, -12, 4])
                cube([body_width, 14, 8], center = true);
            translate([0, 14, 4])
                cube([body_width - 2, 12, 8], center = true);
        }

        for (side = [-1, 1])
            for (y = [-wheelbase / 2, wheelbase / 2])
                translate([side * (body_width / 2 - wheel_arch_depth / 2), y, 4.2])
                    rotate([0, 90, 0])
                        cylinder(h = wheel_arch_depth, r = wheel_radius, center = true);
    }
}

module cabin() {
    hull() {
        translate([0, -6, 9])
            cube([16, 8, 2], center = true);
        translate([0, 6, 9])
            cube([16, 8, 2], center = true);
        translate([0, 0, 14])
            cube([13, 17, 2], center = true);
    }
}

union() {
    lower_body();
    cabin();
}
