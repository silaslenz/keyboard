include <my_keyboard.scad>
include <keyboard-case.scad>

$fa = 30;
$fs = $preview ? 5 : 2;
bezier_precision = $preview ? 0.05 : 0.5;

// Hacky way to select just the left hand keys from split iris/redox layout
left_keys = [ for (i = key_layout) if (key_pos(i).x < 10) i ];

rev0_tent_positions = [
    // [X, Y, Angle]
    [3.3, -89.0, 180],
    [3.3, -13, 180],
    [145.1, -13, 25],
    [155.7, -108, -30],
    ];
module rev0_outer_profile() {
    fillet(r = 5, $fn = 20)
        offset(r = 5, chamfer = false)
        polygon(points = rev0_reference_points, convexity = 3);
}
module rev0_top_case() {
    top_case(left_keys, rev0_screw_holes, raised = false) rev0_outer_profile();
}
module rev0_bottom_case() {
    bottom_case(rev0_screw_holes, rev0_tent_positions) rev0_outer_profile();
}

/////////////////////////////////////////////////
// Revised case with bezier based curved outlines
/////////////////////////////////////////////////
r0b_x0 = 110.2;
r0b_y0 = -125;
r0b_x1 = -10;
r0b_y1 = 10;
r0b_y1b = 10;
r0b_x2 = 130.7;
r0b_x3 = 190.2;
r0b_y3 = -95.5;
r0b_x6 = 135.32;
r0b_y6 = -158.26;
r0b_x4 = 155.0;
r0b_y4 = -175.6;
r0b_x5 = 118.65;
rev0b_screw_holes = [
    [r0b_x1+15.5, r0b_y0+30.65],           // Bottom left, under caps
    [r0b_x1+37, r0b_y1-60],       // Top left
    [r0b_x2-6.5,  r0b_y3+40],   // Top right, under caps
    [r0b_x6-1.5, r0b_y6+0.9],      // Right, under caps
    ];
rev0b_tent_positions = [
    // [X, Y, Angle]
    [-10, -10, 180], // Top left
    [-10, -110, 180], // Bottom left
    [145.8, -25, 20],
    [151.2, -117.3, -30],
    ];

      /* CONTROL              POINT                       CONTROL      */
bzVec = [                     [r0b_x1,r0b_y1],            SHARP(), // Top left
         SHARP(),             [r0b_x2,r0b_y1b],           SHARP(), // Top right
         POLAR(32, 153),      [r0b_x3+2,r0b_y3-6.5],      SHARP(), // Right
         SHARP(),             [r0b_x4-1.5, r0b_y4-12.5],  POLAR(82, 149), // Bottom right
         POLAR(18, 0),        [r0b_x0-41, r0b_y0-5],      POLAR(5, 180), // Bottom mid
         SHARP(),             [r0b_x1, r0b_y0-5],         SHARP(),
         SHARP(),             [r0b_x1, r0b_y1],
    ];
b1 = Bezier(bzVec, precision = bezier_precision);
module rev0b_outer_profile() {
    offset(r = 5, chamfer = false, $fn = 20) // Purposely slightly larger than the negative offset below
    offset(r = -4.5, chamfer = false, $fn = 20)
        polygon(b1);
}
module rev0b_top_case(raised = true) {
    top_case(left_keys, rev0b_screw_holes, chamfer_height = raised ? 5 : 2.5, chamfer_width = 2.5, raised = raised) rev0b_outer_profile();
}

module rev0b_bottom_case() {
    difference() {
        bottom_case(rev0b_screw_holes, rev0b_tent_positions) rev0b_outer_profile();

        // Case holes for connectors etc. The second version of each is just
        // For preview view
        translate([34, -8.45, 0.05]) rotate([0, 0, 8.8]) {
            reset_microswitch();
            %reset_microswitch(hole = false);
        }
        /*translate([13, -5.5, 0]) rotate([0, 0, 4]) {
            micro_usb_hole();
            %micro_usb_hole(hole = false);
        }*/
        /*
        translate([130.5, -7.5, 0]) rotate([0, 0, -24]) {
            mini_usb_hole();
            %mini_usb_hole(hole = false);
        }*/
    }
}

part = "assembly";
explode = 1;
if (part == "outer") {
    //BezierVisualize(bzVec);
    offset(r = -2.5) // Where top of camber would come to
        rev0b_outer_profile();
    for (pos = rev0b_screw_holes) {
        translate(pos) {
            polyhole2d(r = 3.2 / 2);
        }
    }
    #key_holes(left_keys);
    
} else if (part == "top0") {
    rev0_top_case();

} else if (part == "bottom0") {
    rev0_bottom_case();

} else if (part == "top0b-raised") {
    rev0b_top_case(true);
    
} else if (part == "top0b") {
    rev0b_top_case(false);

} else if (part == "bottom0b") {
    rev0b_bottom_case();

} else if (part == "assembly") {
    //%translate([0, 0, plate_thickness + 30 * explode]) key_holes(left_keys, "keycap");
    //%translate([0, 0, plate_thickness + 20 * explode]) key_holes(left_keys, "switch");
    rev0b_top_case();
    translate([0, 0, -bottom_case_height -20 * explode]) rev0b_bottom_case();

} else if (part == "holetest") {
    * translate([-66.5, 20.25]) top_case([left_holes[0], left_holes[1], left_holes[7], left_holes[8]], [], raised = true)
        translate([66.5, -20.25]) square([46, 49], center = true);
    translate([-66.5, 20.25]) difference() {
        chamfer_extrude(height = plate_thickness + top_case_raised_height, chamfer = 5, width = 2.5, faces = [false, true]) translate([66.5, -20.25]) square([46, 49], center = true);
        translate([0, 0, 4])
        key_holes([left_holes[0], left_holes[1], left_holes[7], left_holes[8]]);
    }
}


// Requires my utility functions in your OpenSCAD lib or as local submodule
// https://github.com/Lenbok/scad-lenbok-utils.git
use<Lenbok_Utils/utils.scad>
// Requires bezier library from https://www.thingiverse.com/thing:2207518
use<Lenbok_Utils/bezier.scad>