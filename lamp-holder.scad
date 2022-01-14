extrusion_height=7;
thickness=3;
threading_height=10;
threading_radius=3.5;

conductor_radius=3;
conductor_gap=30;
conductor_distance=90;

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, thickness = thickness, fn = 24) {
    difference() {
        sector(radius + thickness, angles, fn);
        sector(radius, angles, fn);
    }
} 

clamp_radius=conductor_gap / 2  + conductor_radius;
linear_extrude(extrusion_height, center=true)
arc(clamp_radius, [0, 180], fn = 96);

translate([-conductor_gap / 2, 0, 0])
linear_extrude(extrusion_height, center=true)
rotate(70)
arc(conductor_radius, [0, 220], fn = 48);
translate([conductor_gap / 2, 0, 0])
rotate(-110)
linear_extrude(extrusion_height, center=true)
arc(conductor_radius, [0, 220], fn = 48);

translate([0, conductor_distance, 0])
rotate([90, 90, 0])
cylinder(r=threading_radius, h=threading_height);

linear_extrude(extrusion_height, center=true)
difference() {
    polygon(
        points = [
            [clamp_radius, 0],
            [-clamp_radius, 0],
            [threading_radius, conductor_distance - threading_height],
            [-threading_radius, conductor_distance - threading_height],
            [clamp_radius-thickness, 0],
            [-clamp_radius+thickness, 0],
            [0, conductor_distance - threading_height - thickness],
        ],
        paths = [[0,1,3,2], [4,5,6]]
    );
    sector(clamp_radius, [0, 180], fn=96);
}
