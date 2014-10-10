// Badge dimensions.
badge_width = 55;  // mm.
badge_height = 86;  // mm.
badge_depth = 2.5;  // mm. thickness of badge.

// Shapeways model tolerance.
// Stainless steel edges must be at least 1.5 mm thick.
tolerance = 1.5; // mm.

margin = 2; // mm
slide_length = 5; // mm

// Window is the empty area that makes the badge visible. To hold badge in
// place the window should be *smaller* than the actual badge dimensions.
// Cover left & right, and top & bottom by 'tolerance' mm.
window_width = badge_width - 2*margin;
window_height = badge_height - margin - slide_length;
// window_depth is assigned below.

// Slot is the inner gap where the badge will slide into frame.
// The slot should be *slightly* larger than the badge, with space on the top for it to slide out.
// Add 1mm on left & right, and top & bottom.
slot_width = badge_width + 2;
slot_height = badge_height + slide_length + 2;
slot_depth = badge_depth + 0.5;  // pretty tight. but should be enough.

// Size of the two openings for inserting the badge
opening_width = slot_width;
opening_height = (slot_height - slide_length) / 2;
opening_depth = tolerance + 0.2;

// Outside is the external dimension of the entire frame.
// The additional padding (.75) is for volume lost by the beveled edges.
// Add tolerance on left & right, top & bottom.
outside_width = slot_width + 2*tolerance + 0.75;
outside_height = slot_height + 2*tolerance + 0.75;
outside_depth = slot_depth + 2*tolerance;  // the bare minimum wall size.

// Now that we have defined outside_depth, we can assign window_depth.
// Make window_depth a little larger to guarantee a complete removal of frame
// without aliasing due to floating point precision.
window_depth = outside_depth + 0.1;

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
module cylindercube(width, height, depth) {
  r = depth/2;
  // Set local w and h so that given width and height are preserved.
  w = width - depth;  // radius will be added twice on left and right.
  h = height - depth;  // radius will be added twice on top and bottom.

  // creates a convex hull around these four spheres.
  hull() {
    translate([-w/2, -h/2, 0]) cylinder(h=depth, r=r, center=true, $fs=0.01);
    translate([ w/2, -h/2, 0]) cylinder(h=depth, r=r, center=true, $fs=0.01);
    translate([-w/2,  h/2, 0]) cylinder(h=depth, r=r, center=true, $fs=0.01);
    translate([ w/2,  h/2, 0]) cylinder(h=depth, r=r, center=true, $fs=0.01);
  }
}

module ring_holes(ring_radius, wire_radius, depth) {
  offset = ring_radius * 0.6;
  hole_radius = wire_radius * 1.1;
  translate([-offset, hole_radius, 0]) cylinder(h=depth, r=hole_radius, center=true, $fs=0.01);
  translate([offset, hole_radius, 0]) cylinder(h=depth, r=hole_radius, center=true, $fs=0.01);
}

// Logically, the badge holder consists of three intersecting shapes.
// 1) The 'badgeframe' defines the volume of the entire frame.
// 2) The window cylindercube is subtracted from the badgeframe shape
//    to create a portal to view the badge.
// 3) The slot cube is subtracted from within the badgeframe to
//    create a space for the badge to fit.

scale=1.25;
difference() {
  // outside shape.
  beveledcube(outside_width, outside_height, outside_depth);

  // cut out the viewing window from the center.
  cube([window_width, window_height, window_depth], center=true);

  // cut out the slot within the frame.
  cube(size = [slot_width,slot_height,slot_depth], center=true);

  // cut out the lower opening for insertion
  translate([0,-opening_height/2+slide_length/2,-(slot_depth/2+opening_depth/2-0.1)]) {
    cube(size = [opening_width, opening_height, opening_depth], center=true);
  }

  // cut out the upper opening for insertion
  translate([0,opening_height/2+slide_length/2,slot_depth/2+opening_depth/2-0.1]) {
    cube(size = [opening_width, opening_height, opening_depth], center=true);
  }
  
  translate([0,window_height/2+margin,-(slot_depth/2+opening_depth/2-0.1)]) {
    ring_holes(8.5,1.5,opening_depth);
  }
}
