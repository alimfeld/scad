// --- params ---

extrusion_height=7;
thickness=2.5;
peg_height=10;
peg_radius=3.5;
conductor_radius=3;
conductor_gap=30;
conductor_distance=90; // large holder
//conductor_distance=72; // small holder
clip_angle=220;
struts_distance=26;
$fn=96;

// --- model ---

clamp();
clips();
peg();
struts();

// --- modules ---

module clamp() {
    clamp_radius=conductor_gap / 2  + conductor_radius;
    linear_extrude(extrusion_height, center=true)
    arc(clamp_radius, 180, thickness);
}

module clips() {
    translate([-conductor_gap / 2, 0])
    rotate(90)
    clip();

    translate([conductor_gap / 2, 0])
    rotate(-90)
    clip();
}

module clip() {
    linear_extrude(extrusion_height, center=true)
    rotate(-(clip_angle - 180) / 2)
    union() {
        arc(conductor_radius, clip_angle, thickness);
        translate([conductor_radius + thickness / 2, 0])
        circle(thickness / 2);
        rotate(clip_angle)
        translate([conductor_radius + thickness / 2, 0])
        circle(thickness / 2);
    }
}

module peg() {
    translate([0, conductor_distance])
    rotate([90, 90])
    cylinder(r=peg_radius, h=peg_height);
}

module struts() {
    linear_extrude(extrusion_height, center=true)
    difference() {
        union() {
            polygon(
                points = [
                    [struts_distance / 2 - thickness, 0],
                    [struts_distance / 2, 0],
                    [peg_radius, conductor_distance - peg_height],
                    [peg_radius - thickness, conductor_distance - peg_height],
                ],
                paths = [[0,1,2,3]]
            );
            polygon(
                points = [
                    [-struts_distance / 2, 0],
                    [-struts_distance / 2 + thickness, 0],
                    [-peg_radius + thickness, conductor_distance - peg_height],
                    [-peg_radius, conductor_distance - peg_height],
                ],
                paths = [[0,1,2,3]]
            );
            translate([-peg_radius, conductor_distance - peg_height - thickness])
            square([peg_radius * 2, thickness]);
        }
        circle(conductor_gap / 2 + conductor_radius);
    }
}

module sector(radius, angle) {
    union() {
        difference() {
            circle(radius);
            translate([-radius, -2*radius])
            square(2*radius);
            rotate(angle/2)
            translate([-radius, 0])
            square(2*radius);
        }
        difference() {
            circle(radius);
            rotate(angle/2)
            translate([-radius, -2*radius])
            square(2*radius);
            rotate(angle)
            translate([-radius, 0])
            square(2*radius);
        }
    }
}

module arc(radius, angle, thickness) {
    difference() {
        sector(radius + thickness, angle);
        sector(radius, angle);
    }
} 
