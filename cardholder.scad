/* Settlers or Rivals of Catan game card holder
 *
 * Wherever 0.01 appears below, it's a small adjustment amount to make sure unioned components
 * overlap.
 */

// Card size measured in mm
card_width = 69; // Use 69 for Rivals of Catan, 54 for Settlers
card_height = 69; // Use 69 for Rivals of Catan, 80 for Settlers
card_space = 2;

// Parameters for walls that hold the cards, in mm
wall_thickness = 3;
wall_height = 6;
wall_length = 12;

// Parameters for the base plate
plate_depth = 3;
plate_width = card_width + card_space + wall_thickness * 2;
plate_height = card_height + card_space + wall_thickness * 2;

// Connecting piece parameters.
conn_width = 10;
conn_height_small = 11.5;
conn_height_large = 20;
nub_width = wall_thickness + 0.5;

// Object that represents the puzzle piece connector.
// The female connector is made 0.5mm taller, but you may need to adjust this value
// slightly if the parts don't fit together.
module Connector(male) {
  height_small = conn_height_small + (male ? 0 : 0.5);
  height_large = conn_height_large + (male ? 0 : 0.5);
  linear_extrude(height=plate_depth + 0.02, center=true, convexity=10, twist=0) {
    translate([0, 0, -plate_depth / 2 - 0.01])
      polygon([[0, height_small / 2],
               [-conn_width, height_large / 2],
               [-conn_width, -height_large / 2],
               [0, -height_small / 2]]);
  }
}

union() {
  difference() {

    union() {
      // Base plate
      cube([plate_width, plate_height, plate_depth], center = true);

      // Extra nub
      for (x = [0:1])
        mirror([x, 0, 0])
          translate([(plate_width + nub_width) / 2 - 0.01, 0, 0])
            cube([nub_width, conn_height_large * 1.5, plate_depth], center=true);
    }

    // Round cuts to make grabbing cards easier
    for (dir = [1, -1]) {
      translate([0, dir * (card_height / 2 + 25), 0])
        cylinder(h=10, r=27, center=true, $fa=2);
    }

    // Logo
    union() {
      translate([0, -4.5, 0])
        cube(size = [19, 9, 10], center = true);
      difference() {
        translate([-4.5, 0.5 ,0])
          cube(size = [10, 19, 10], center = true);
        translate([0.5, 12 ,0])
          rotate([0, 0, 45])
          cube(size = [10, 12, 11], center = true);
        translate([-9.5, 12, 0])
          rotate([0, 0, 45])
          cube(size = [12, 10, 11], center = true);
      }
    }

    // Female connector
    translate([plate_width / 2 + nub_width + 0.01, 0, 0])
      Connector(false);
  }

  // Male connector
  translate([-plate_width / 2 - nub_width + 0.01, 0, 0])
    Connector(true);

  // Transparent reference cards (not part of the model)
  card_depth = 9;
  translate([0, 0, (plate_depth + card_depth) / 2])
    %cube(size = [card_width, card_height, card_depth], center=true);

  // Build the corner walls
  wall_offset = wall_thickness - wall_length;
  half_card_offset_x = (card_width + card_space) / 2;
  half_card_offset_y = (card_height + card_space) / 2;

  // Build one corner and then repeat it in x and y directions
  for (x = [0:1], y = [0:1]) {
    mirror([x, 0, 0]) {
      mirror([0, y, 0]) {

        // Build one side of the corner and then flip it
        for (flip = [0:1]) {
          extra_x = flip ? (card_height - card_width) / 2 : 0;
          extra_y = flip ? (card_width - card_height) / 2 : 0;
          translate([extra_x, extra_y, 0])
            mirror([flip, flip, 0]) {

              // Card wall
              translate([half_card_offset_x,
                         half_card_offset_y + wall_offset,
                         plate_depth / 2 - 0.01])
                cube([wall_thickness, wall_length, wall_height], center=false);

              // Interlocking wall
              translate([half_card_offset_x + wall_thickness + 0.5,
                         half_card_offset_y + wall_offset,
                         plate_depth / 2 + wall_height])
                cube([wall_thickness, wall_length + wall_thickness + 0.5, plate_depth], center=false);

              // Diagnonal support for interlocking wall
              difference() {
                translate([half_card_offset_x + wall_thickness - 0.01,
                           half_card_offset_y + wall_offset + (wall_length + wall_thickness + 0.5) / 2,
                           plate_depth / 2 + 0.01])
                  rotate([-90, 0, 0])
                    linear_extrude(height=wall_length + wall_thickness + 0.5 - 0.01,
                                   center=true, convexity=10, twist=0)
                      polygon([[0, 0], [wall_thickness + 0.5, -wall_height], [0, -wall_height]]);
                translate([half_card_offset_x + wall_offset + (wall_length + wall_thickness) / 2 + 1.0,
                           half_card_offset_y + wall_thickness * 2 + 0.5,
                           plate_depth / 2 + 0.01])
                  rotate([-90, 0, -90])
                    linear_extrude(height=wall_length + wall_thickness - 0.01,
                                   center=true, convexity=10, twist=0)
                      polygon([[0, 0], [wall_thickness + 0.5, 0], [0, -wall_height]]);
              }
            }
        }
      }
    }
  }
}
