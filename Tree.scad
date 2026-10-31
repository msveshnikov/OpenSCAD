// Parametric evergreen with layered boughs and a star topper.
$fn = 32;

trunk_height = 38;
trunk_diameter = 9;
foliage_tiers = 4;
foliage_height = 27;
foliage_base_radius = 28;
tier_spacing = 15;
branches_per_tier = 8;
needle_sprigs_per_branch = 4;
show_star = true;

function tier_radius(tier) =
    foliage_base_radius * (1 - 0.61 * tier / max(foliage_tiers - 1, 1));
function tier_z(tier) =
    trunk_height - foliage_height * 0.18 + tier * tier_spacing;
function branch_length(tier) = tier_radius(tier) * 0.88;

module tapered_link(start, end, start_radius, end_radius) {
    hull() {
        translate(start) sphere(r = start_radius);
        translate(end) sphere(r = end_radius);
    }
}

module trunk() {
    color([0.36, 0.18, 0.075])
        cylinder(h = trunk_height, d1 = trunk_diameter, d2 = trunk_diameter * 0.64);

    color([0.48, 0.27, 0.12])
        for (angle = [0 : 60 : 300]) {
            rotate([0, 0, angle])
                translate([trunk_diameter * 0.22, 0, trunk_height * 0.28])
                    cylinder(h = trunk_height * 0.57, d1 = 1.1, d2 = 0.5);
        }
}

module roots() {
    color([0.36, 0.18, 0.075])
        for (angle = [0 : 45 : 315]) {
            rotate([0, 0, angle])
                tapered_link(
                    [0, 0, 5],
                    [foliage_base_radius * 0.36, 0, 0.8],
                    2.4,
                    0.8
                );
        }
}

module foliage_tier(tier) {
    radius = tier_radius(tier);
    z = tier_z(tier);
    color(tier % 2 == 0 ? [0.10, 0.34, 0.13] : [0.13, 0.40, 0.16])
        translate([0, 0, z])
            cylinder(h = foliage_height, r1 = radius, r2 = 0);
}

module branch(tier, angle) {
    length = branch_length(tier);
    base_z = tier_z(tier) + foliage_height * 0.24;

    rotate([0, 0, angle]) {
        color([0.31, 0.16, 0.07])
            tapered_link([0, 0, base_z], [length, 0, base_z + length * 0.31], 1.35, 0.55);

        color([0.16, 0.43, 0.18])
            for (sprig = [0 : needle_sprigs_per_branch - 1]) {
                t = (sprig + 1) / (needle_sprigs_per_branch + 1);
                x = length * t;
                z = base_z + length * 0.31 * t;
                spread = length * (0.32 - 0.12 * t);

                tapered_link([x, 0, z], [x + spread, 0, z + spread * 0.43], 1.1, 0.3);
                tapered_link([x, 0, z], [x + spread * 0.82, 0, z - spread * 0.12], 0.9, 0.25);
            }
    }
}

module branches() {
    for (tier = [0 : foliage_tiers - 1])
        for (branch_index = [0 : branches_per_tier - 1])
            branch(tier, branch_index * 360 / branches_per_tier + tier * 13);
}

module star_2d(outer_radius, inner_radius, points = 5) {
    polygon(points = [
        for (i = [0 : points * 2 - 1])
            let(
                angle = 90 + i * 180 / points,
                radius = i % 2 == 0 ? outer_radius : inner_radius
            )
            [radius * cos(angle), radius * sin(angle)]
    ]);
}

module star_topper() {
    top_z = tier_z(foliage_tiers - 1) + foliage_height;
    union() {
        color([0.95, 0.67, 0.12]) {
            translate([0, 0, top_z - 8])
                cylinder(h = 16, d1 = 1.2, d2 = 2.2);

            translate([0, 0, top_z + 8])
                rotate([90, 0, 0])
                    linear_extrude(height = 2.4, center = true, convexity = 5)
                        star_2d(8, 3.6);
        }
    }
}

module tree() {
    union() {
        trunk();
        roots();
        for (tier = [0 : foliage_tiers - 1])
            foliage_tier(tier);
        branches();
        if (show_star)
            star_topper();
    }
}

tree();
