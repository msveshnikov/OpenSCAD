// A decorative, parametric pumpkin. Press F5 to preview or F6 to render.

$fn = 48;

body_width = 82;
body_height = 62;
rib_count = 10;
rib_depth = 0.055;
ring_count = 38;
segments = 160;

function pumpkin_radius(z, angle) =
    body_width / 2
    * pow(max(0, 1 - pow(abs(z), 2.4)), 0.44)
    * (1 + rib_depth * cos(rib_count * angle)
        * (0.38 + 0.62 * sqrt(max(0, 1 - z * z))));

function pumpkin_vertices() = concat(
    [
        for (ring = [0 : ring_count - 1])
            let(z = -1 + 2 * (ring + 1) / (ring_count + 1))
            for (segment = [0 : segments - 1])
                let(angle = 360 * segment / segments)
                [
                    pumpkin_radius(z, angle) * cos(angle),
                    pumpkin_radius(z, angle) * sin(angle),
                    z * body_height / 2
                        - (z > 0 ? 1 : -1)
                        * 1.8 * exp(-pow((1 - abs(z)) / 0.14, 2))
                ]
    ],
    [[0, 0, -body_height / 2], [0, 0, body_height / 2]]
);

function pumpkin_faces() = concat(
    [
        for (ring = [0 : ring_count - 2])
            for (segment = [0 : segments - 1])
                let(
                    a = ring * segments + segment,
                    b = ring * segments + (segment + 1) % segments,
                    c = (ring + 1) * segments + (segment + 1) % segments,
                    d = (ring + 1) * segments + segment
                )
                each [[c, b, a], [d, c, a]]
    ],
    [
        for (segment = [0 : segments - 1])
            each [
                [ring_count * segments, segment, (segment + 1) % segments],
                [
                    ring_count * segments + 1,
                    (ring_count - 1) * segments + (segment + 1) % segments,
                    (ring_count - 1) * segments + segment
                ]
            ]
    ]
);

module pumpkin_body() {
    color([0.96, 0.30, 0.035])
        difference() {
            polyhedron(
                points = pumpkin_vertices(),
                faces = pumpkin_faces(),
                convexity = 10
            );
            scale([body_width * 0.42, body_width * 0.42, body_height * 0.42])
                sphere(r = 1, $fn = 64);
            face_cutouts();
        }
}

module face_cutouts() {
    translate([0, -55, 0])
        rotate([-90, 0, 0])
            linear_extrude(height = 50)
                mirror([0, 1, 0])
                    union() {
                        polygon(points = [[-25, 16], [-7, 12], [-15, 1]]);
                        polygon(points = [[25, 16], [7, 12], [15, 1]]);
                        polygon(points = [[-5, 2], [5, 2], [0, -7]]);
                        polygon(points = [
                            [-24, -10], [-18, -14], [-13, -10], [-8, -16],
                            [-3, -12], [2, -17], [7, -12], [12, -16],
                            [17, -11], [23, -12], [21, -21], [15, -25],
                            [9, -22], [4, -26], [-2, -22], [-8, -25],
                            [-15, -21], [-21, -22]
                        ]);
                    }
}

module pumpkin_stem() {
    color([0.28, 0.16, 0.07])
        hull() {
            translate([0, 0, body_height / 2 - 2])
                cylinder(h = 8, d1 = 11, d2 = 8);
            translate([2.5, 0, body_height / 2 + 9])
                cylinder(h = 7, d1 = 8, d2 = 4);
        }
}

module pumpkin_leaf() {
    color([0.20, 0.42, 0.07])
        translate([4, -2, body_height / 2 + 10])
            rotate([0, 0, 18])
                linear_extrude(height = 1.4, center = true)
                    polygon(points = concat(
                        [
                            for (i = [0 : 24])
                                [20 * i / 24, 6 * sin(180 * i / 24)]
                        ],
                        [
                            for (i = [24 : -1 : 0])
                                [20 * i / 24, -6 * sin(180 * i / 24)]
                        ]
                    ));
}

function flame_radius(t, width) =
    width * (0.34 + 0.66 * sin(180 * t))
    * pow(1 - t, 0.65) + 0.12;

module flame_tongue(x, y, z, height, width, lean) {
    steps = 8;

    for (i = [0 : steps - 1]) {
        t0 = i / steps;
        t1 = (i + 1) / steps;
        hull() {
            translate([x + lean * sin(90 * t0), y, z + height * t0])
                sphere(r = flame_radius(t0, width), $fn = 20);
            translate([x + lean * sin(90 * t1), y, z + height * t1])
                sphere(r = flame_radius(t1, width), $fn = 20);
        }
    }
}

module fire_visualization() {
    color([0.78, 0.08, 0.015]) {
        flame_tongue(-11, -22, -20, 17, 5.5, -3);
        flame_tongue(0, -22, -20, 19, 6.0, 2);
        flame_tongue(11, -22, -20, 17, 5.5, 3);
        flame_tongue(-9, -22, -17, 27, 6.8, -5);
        flame_tongue(0, -22, -17, 33, 7.5, 3);
        flame_tongue(9, -22, -17, 28, 6.5, 5);
    }

    color([1.0, 0.25, 0.015]) {
        flame_tongue(-8, -25, -19, 16, 4.8, 2);
        flame_tongue(2, -25, -19, 18, 5.0, -2);
        flame_tongue(12, -25, -19, 15, 4.4, -2);
        flame_tongue(-6, -25, -17, 26, 5.5, 3);
        flame_tongue(4, -25, -17, 29, 5.8, -3);
        flame_tongue(11, -25, -17, 20, 4.2, -2);
    }

    color([1.0, 0.72, 0.04]) {
        flame_tongue(-7, -27, -19, 13, 3.2, 1);
        flame_tongue(2, -27, -19, 15, 3.6, -1);
        flame_tongue(10, -27, -19, 12, 3.0, -1);
        flame_tongue(-4, -26, -17, 23, 5.2, -2);
        flame_tongue(4, -26, -17, 24, 5.4, 2);
    }

    color([1.0, 0.94, 0.42])
        flame_tongue(1, -28, -17, 20, 3.8, -1.5);
}

union() {
    pumpkin_body();
    pumpkin_stem();
    pumpkin_leaf();
    fire_visualization();
}
