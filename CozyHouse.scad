// Parametric gable-roof house, dimensions in millimetres.
$fn = 32;

house_width = 80;
house_depth = 60;
wall_height = 40;
wall_thickness = 2;
roof_overhang = 7;
roof_rise = 24;
base_thickness = 3;

front_y = -house_depth / 2;
door_width = 16;
door_height = 27;
window_width = 16;
window_height = 15;
window_sill = 15;
window_centers = [-24, 24];

module gable_volume() {
    translate([0, house_depth, 0])
        rotate([90, 0, 0])
            linear_extrude(height = house_depth)
                polygon(points = [
                    [-house_width / 2, wall_height],
                    [ house_width / 2, wall_height],
                    [0, wall_height + roof_rise]
                ]);
}

module house_shell() {
    difference() {
        union() {
            translate([-house_width / 2, front_y, base_thickness])
                cube([house_width, house_depth, wall_height]);
            translate([0, front_y, base_thickness])
                gable_volume();
        }

        // Front entrance and two front windows.
        translate([-door_width / 2, front_y - 1, base_thickness - 0.1])
            cube([door_width, wall_thickness + 2, door_height]);
        for (x = window_centers)
            translate([x - window_width / 2, front_y - 1,
                base_thickness + window_sill])
                cube([window_width, wall_thickness + 2, window_height]);

        // Matching windows on the back wall.
        for (x = window_centers)
            translate([x - window_width / 2, house_depth / 2 - wall_thickness - 1,
                base_thickness + window_sill])
                cube([window_width, wall_thickness + 2, window_height]);
    }
}

module roof() {
    color([0.48, 0.12, 0.09])
        translate([0, house_depth / 2 + roof_overhang, base_thickness])
            rotate([90, 0, 0])
                linear_extrude(height = house_depth + 2 * roof_overhang)
                    polygon(points = [
                        [-house_width / 2 - roof_overhang, wall_height],
                        [ house_width / 2 + roof_overhang, wall_height],
                        [0, wall_height + roof_rise + 2]
                    ]);
}

module front_door() {
    color([0.40, 0.20, 0.09])
        translate([-door_width / 2 + 0.6, front_y - 0.25, base_thickness])
            cube([door_width - 1.2, 1, door_height - 0.3]);
    color([0.86, 0.66, 0.22])
        translate([door_width / 2 - 3, front_y - 1.4, base_thickness + 13])
            sphere(r = 1.2);
}

module front_window(x) {
    color([0.22, 0.62, 0.82])
        translate([x - window_width / 2 + 1, front_y + 0.6,
            base_thickness + window_sill + 1])
            cube([window_width - 2, 0.7, window_height - 2]);

    color([0.93, 0.78, 0.52]) {
        translate([x - window_width / 2 - 1, front_y - 0.8,
            base_thickness + window_sill - 1])
            cube([2, 1.6, window_height + 2]);
        translate([x + window_width / 2 - 1, front_y - 0.8,
            base_thickness + window_sill - 1])
            cube([2, 1.6, window_height + 2]);
        translate([x - window_width / 2 - 1, front_y - 0.8,
            base_thickness + window_sill - 1])
            cube([window_width + 2, 1.6, 2]);
        translate([x - window_width / 2 - 1, front_y - 0.8,
            base_thickness + window_sill + window_height - 1])
            cube([window_width + 2, 1.6, 2]);
        translate([x - 1, front_y - 0.9,
            base_thickness + window_sill])
            cube([2, 1.8, window_height]);
        translate([x - window_width / 2, front_y - 0.9,
            base_thickness + window_sill + window_height / 2 - 1])
            cube([window_width, 1.8, 2]);
    }
}

module chimney() {
    color([0.62, 0.24, 0.17])
        translate([20, 9, base_thickness + wall_height + roof_rise * 0.35])
            cube([9, 10, 25]);
    color([0.35, 0.15, 0.12])
        translate([19, 8.5, base_thickness + wall_height + roof_rise * 0.35 + 24])
            cube([11, 11, 2]);
}

module entry_steps() {
    color([0.58, 0.57, 0.52]) {
        translate([-11, front_y - 5, base_thickness - 0.4])
            cube([22, 5, 2.8]);
        translate([-9, front_y - 9, 0])
            cube([18, 4.5, 2.8]);
    }
}

module house() {
    color([0.91, 0.80, 0.62])
        translate([-house_width / 2 - 2, -house_depth / 2 - 2, 0])
            cube([house_width + 4, house_depth + 4, base_thickness]);

    color([0.88, 0.72, 0.52])
        house_shell();

    roof();
    front_door();
    for (x = window_centers)
        front_window(x);
    chimney();
    entry_steps();
}

house();
