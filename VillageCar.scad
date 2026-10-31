// Compact parametric village car, dimensions in millimetres.
$fn = 32;

body_width = 22;
wheelbase = 25;
wheel_radius = 5.2;

module lower_body() {
    difference() {
        hull() {
            translate([0, -12, 4])
                cube([body_width, 14, 8], center = true);
            translate([0, 14, 4])
                cube([body_width - 2, 12, 8], center = true);
        }

        for (y = [-wheelbase / 2, wheelbase / 2])
            translate([0, y, 4.2])
                rotate([0, 90, 0])
                    cylinder(h = body_width + 4, r = wheel_radius, center = true);
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
