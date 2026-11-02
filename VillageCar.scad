// Modern compact city car, dimensions in millimetres.
$fn = 32;

body_width = 24;
wheelbase = 28;
wheel_radius = 5.2;
wheel_arch_depth = 4.8;

airflow_height = 5.4;

module rounded_box(size, radius = 1.2) {
    minkowski() {
        cube([size[0] - 2 * radius, size[1] - 2 * radius, size[2] - 2 * radius], center = true);
        cylinder(r = radius, h = 0.01);
    }
}

module lower_body() {
    difference() {
        hull() {
            translate([0, -12, 4.8])
                rounded_box([body_width + 2, 18, 7.5]);
            translate([0, 10, 4.8])
                rounded_box([body_width - 1, 12, 7.5]);
            translate([0, 0, 5.9])
                rounded_box([body_width * 0.9, 24, 6.2]);
        }

        for (side = [-1, 1])
            for (y = [-wheelbase / 2, wheelbase / 2])
                translate([side * (body_width / 2 - wheel_arch_depth / 2), y, 4.3])
                    rotate([0, 90, 0])
                        cylinder(h = wheel_arch_depth, r = wheel_radius, center = true);
    }
}

module cabin() {
    hull() {
        translate([0, -5, 10.5])
            rounded_box([15, 9, 3]);
        translate([0, 6, 10.8])
            rounded_box([15.5, 8.5, 3]);
        translate([0, 0.5, 15.3])
            rounded_box([12.5, 15, 2.8]);
    }
}

module window_band() {
    hull() {
        translate([0, -3.5, 14.4])
            cube([10.5, 7, 1.3], center = true);
        translate([0, 6.2, 14.6])
            cube([11, 7.5, 1.3], center = true);
    }
}

module hood() {
    hull() {
        translate([0, -13, 6.7])
            cube([body_width * 0.8, 7, 3.5], center = true);
        translate([0, -18, 6.2])
            cube([body_width * 0.56, 5.5, 3.2], center = true);
    }
}

module tail() {
    hull() {
        translate([0, 13, 6.4])
            cube([body_width * 0.75, 6, 3.2], center = true);
        translate([0, 17.7, 6.2])
            cube([body_width * 0.5, 4.8, 2.8], center = true);
    }
}

module front_grille() {
    difference() {
        translate([0, -18.4, 6.3])
            cube([4.8, 1.7, 2.7], center = true);
        translate([0, -18.5, 6.3])
            cube([3.2, 1.1, 1.8], center = true);
    }
}

module lights() {
    for (sign = [-1, 1])
        translate([sign * (body_width / 2 + 0.2), -17.8, 6.4])
            cube([0.8, 2.3, 1.3], center = true);

    for (sign = [-1, 1])
        translate([sign * (body_width / 2 + 0.2), 17.8, 6.1])
            cube([0.8, 2.2, 1.2], center = true);
}

union() {
    lower_body();
    hood();
    cabin();
    window_band();
    tail();
    front_grille();
    lights();
}
