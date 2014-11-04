// Badge dimensions.
badge_width = 54;  // mm.
badge_height = 85.6;  // mm.
badge_depth = 2.5;  // mm. thickness of badge.

// Shapeways model tolerance.
// Stainless steel edges must be at least 1.5 mm thick.
min_thickness = 1.5; // mm.
border_thickness = 2; // mm.

// Radius of rounded borders
edge_radius = 0.5; // mm.
corner_radius = 3; // mm.
inner_corner_radius = 1.5; // mm.

hole_height = 5; // mm.
bend_height = 5; // mm. Amount the top of the badge can be lowered by bending.

// Slot and outside dimensions (before rounding!)

// Slot is the inner gap where the badge will slide into frame.
// The slot should be *slightly* larger than the badge, with space on the top for it to slide out.
// Add a bit on left & right, and top & bottom.
slot_width = badge_width * 1.1 + 2*edge_radius;
slot_height = badge_height * 1.1 + 2*edge_radius;
slot_depth = badge_depth + 0.5;  // pretty tight. but should be enough.

// Outside is the external dimension of the entire frame.
// Add border_thickness on left & right, top & bottom.
// Add min_thickness on front and back.
outside_width = slot_width + 2*border_thickness - 2*edge_radius;
outside_height = slot_height + 2*border_thickness - 2*edge_radius;
outside_depth = slot_depth + 2*min_thickness;

// Creates a "beveled cube" of dimensions width x height x depth with beveled
// edges of radius depth/2. All dimensions are preserved, but volume is less
// due to beveled edges. The entire shape is centered at the origin: 0, 0, 0.
module beveledcube(width, height, depth) {
  r = depth/2;
  // Set local w and h so that given width and height are preserved.
  w = width - depth;  // radius will be added twice on left and right.
  h = height - depth;  // radius will be added twice on top and bottom.

  // creates a convex hull around these four spheres.
  hull() {
    translate([-w/2, -h/2, 0]) sphere(r, $fs=0.01);
    translate([ w/2, -h/2, 0]) sphere(r, $fs=0.01);
    translate([-w/2,  h/2, 0]) sphere(r, $fs=0.01);
    translate([ w/2,  h/2, 0]) sphere(r, $fs=0.01);
  }
}

// Creates a "cylinder cube" of dimensions width x height x depth with beveled
// edges of radius depth/2 only on the width and height dimensions. All
// dimensions are preserved, but volume is less due to beveled edges. The
// entire shape is centered at the origin: 0, 0, 0.
module cylindercube(width, height, depth, r) {
  // Set local w and h so that given width and height are preserved.
  w = width - 2*r;  // radius will be added twice on left and right.
  h = height - 2*r;  // radius will be added twice on top and bottom.

  // creates a convex hull around these four spheres.
  hull() {
    translate([r,   r,   0]) cylinder(h=depth, r=r, $fs=0.01);
    translate([w+r, r,   0]) cylinder(h=depth, r=r, $fs=0.01);
    translate([r,   h+r, 0]) cylinder(h=depth, r=r, $fs=0.01);
    translate([w+r, h+r, 0]) cylinder(h=depth, r=r, $fs=0.01);
  }
}

function gaussian(x, a, b, c, d) = a * exp(-(x-b)*(x-b)/(2*c*c)) + d;
gaussian_points = [[-3.0, 0],
 [-2.9, 0.014920786069067842],
 [-2.8, 0.019841094744370288],
 [-2.7, 0.026121409853918233],
 [-2.6, 0.034047454734599344],
 [-2.5, 0.04393693362340742],
 [-2.4, 0.056134762834133725],
 [-2.3, 0.07100535373963698],
 [-2.2, 0.08892161745938634],
 [-2.1, 0.11025052530448522],
 [-2.0, 0.1353352832366127],
 [-1.9, 0.1644744565771549],
 [-1.8, 0.19789869908361465],
 [-1.7, 0.23574607655586352],
 [-1.6, 0.27803730045319414],
 [-1.5, 0.32465246735834974],
 [-1.4, 0.37531109885139957],
 [-1.3, 0.42955735821073915],
 [-1.2, 0.4867522559599717],
 [-1.1, 0.5460744266397094],
 [-1.0, 0.6065306597126334],
 [-0.9, 0.6669768108584744],
 [-0.8, 0.7261490370736909],
 [-0.7, 0.7827045382418681],
 [-0.6, 0.835270211411272],
 [-0.5, 0.8824969025845955],
 [-0.4, 0.9231163463866358],
 [-0.3, 0.9559974818331],
 [-0.2, 0.9801986733067553],
 [-0.1, 0.9950124791926823],
 [0.0, 1.0],
 [0.1, 0.9950124791926823],
 [0.2, 0.9801986733067553],
 [0.3, 0.9559974818331],
 [0.4, 0.9231163463866358],
 [0.5, 0.8824969025845955],
 [0.6, 0.835270211411272],
 [0.7, 0.7827045382418681],
 [0.8, 0.7261490370736909],
 [0.9, 0.6669768108584744],
 [1.0, 0.6065306597126334],
 [1.1, 0.5460744266397094],
 [1.2, 0.4867522559599717],
 [1.3, 0.42955735821073915],
 [1.4, 0.37531109885139957],
 [1.5, 0.32465246735834974],
 [1.6, 0.27803730045319414],
 [1.7, 0.23574607655586352],
 [1.8, 0.19789869908361465],
 [1.9, 0.1644744565771549],
 [2.0, 0.1353352832366127],
 [2.1, 0.11025052530448522],
 [2.2, 0.08892161745938634],
 [2.3, 0.07100535373963698],
 [2.4, 0.056134762834133725],
 [2.5, 0.04393693362340742],
 [2.6, 0.034047454734599344],
 [2.7, 0.026121409853918233],
 [2.8, 0.019841094744370288],
 [2.9, 0.014920786069067842],
 [3.0, 0]];

module gaussian_prism(width, height, depth) {
  scale([width/6, height, 1]) {
    linear_extrude(height=depth) {
      polygon(gaussian_points);
    }
  }
}

module triangular_prism(width, height, depth) {
  linear_extrude(height=depth) {
    polygon([[0,0], [width, 0], [0, height]]);
  }
}

minkowski() {
  union() {
	difference() {
	  translate([outside_width/2, 0, 0]) rotate([0, 0, 180]) gaussian_prism(outside_width-2*corner_radius, hole_height+border_thickness, outside_depth);
      translate([outside_width/2, border_thickness, -.1]) rotate([0, 0, 180]) gaussian_prism(outside_width, hole_height+border_thickness, outside_depth+.2);
    }
    difference() {
  	  cylindercube(outside_width, outside_height, outside_depth, corner_radius);
      translate([border_thickness-edge_radius, border_thickness-edge_radius, -.1]) cylindercube(slot_width, slot_height, outside_depth+.2, inner_corner_radius);
    }
    translate([border_thickness-edge_radius, border_thickness-edge_radius, 0])
      triangular_prism(bend_height, bend_height, min_thickness);
    translate([outside_width-border_thickness+edge_radius, outside_height-border_thickness+edge_radius, 0])
      rotate([0, 0, 180]) triangular_prism(bend_height, bend_height, min_thickness);
    translate([border_thickness-edge_radius, outside_height-border_thickness+edge_radius, outside_depth-min_thickness])
      rotate([0, 0, -90]) triangular_prism(bend_height, bend_height, min_thickness);
    translate([outside_width-border_thickness+edge_radius, border_thickness-edge_radius, outside_depth-min_thickness])
      rotate([0, 0, 90]) triangular_prism(bend_height, bend_height, min_thickness);
  }
  sphere(edge_radius, $fs=0.5);
}