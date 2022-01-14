// --- params ---

extrusion_height=7;
thickness=3;
peg_height=10;
peg_radius=3.5;
conductor_radius=3;
conductor_gap=30;
conductor_distance=90;
clip_angle=220;
struts_distance=30;

// --- model ---

clamp();
clips();
peg();
struts();

// --- modules ---

module clamp() {
    clamp_radius=conductor_gap / 2  + conductor_radius;
    linear_extrude(extrusion_height, center=true)
    arc(clamp_radius, [0, 180], fn=96);
}

module clips() {
    translate([-conductor_gap / 2, 0, 0])
    rotate(90)
    clip();

    translate([conductor_gap / 2, 0, 0])
    rotate(-90)
    clip();
}

module clip() {
    linear_extrude(extrusion_height, center=true)
    rotate((180 - clip_angle) / 2)
    union() {
        arc(conductor_radius, [0, clip_angle], fn=48);
        translate([conductor_radius + thickness / 2, 0, 0])
        circle(thickness / 2, $fn=48);
        rotate(clip_angle - 180)
        translate([-conductor_radius - thickness / 2, 0, 0])
        circle(thickness / 2, $fn=48);
    }
}

module peg() {
    translate([0, conductor_distance, 0])
    rotate([90, 90, 0])
    cylinder(r=peg_radius, h=peg_height);
}

module struts() {
    clamp_radius=conductor_gap / 2  + conductor_radius;
    linear_extrude(extrusion_height, center=true)
    difference() {
        polygon(
            points = [
                [struts_distance / 2, 0],
                [-struts_distance / 2, 0],
                [peg_radius, conductor_distance - peg_height],
                [-peg_radius, conductor_distance - peg_height],
                [struts_distance / 2 - thickness, 0],
                [-struts_distance / 2 + thickness, 0],
                [0, conductor_distance - peg_height - thickness],
            ],
            paths = [[0,1,3,2], [4,5,6]]
        );
        sector(clamp_radius, [0, 180], fn=96);
    }
}

module sector(radius, angles, fn=24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn=fn);
        polygon(points);
    }
}

module arc(radius, angles, thickness = thickness, fn=24) {
    difference() {
        sector(radius + thickness, angles, fn);
        sector(radius, angles, fn);
    }
} 
