// Rivals of Catan game card holder

//Constants
card_x = 54; // Use 69 for Rivals of Catan, 54 for Settlers
card_y = 80; // Use 69 for Rivals of Catan, 80 for Settlers
card_space = 2;
wall_thickness = 3;
plate_height = 3;
wall_height = 12;
wall_length = 12;
wall_offset = wall_thickness - wall_length;

// Connecting piece
// the "female" part is 21mm at the biggest point and 12.5mm at the smallest and 10mm deep
// the "male" part is  19.8mm at the biggest point and 10.46mm at smallest and 11.4mm long
// the odd numbers are because I used a manualy freehand modifed box with no real grid snapping,
// and some random scaling
female_con_x = 10;
female_con_y1 = 21;
female_con_y2 = 12.5;
male_con_x = 11.4;
male_con_y1 = 19.8;
male_con_y2 = 10.46;

// Same angle works for both male and female connector
angle = atan(((female_con_y1 - female_con_y2) / 2) / female_con_x);

union() {

  difference() {
    // Base plate
    cube(size = [card_x+card_space+wall_thickness*2, card_y+card_space+wall_thickness*2,plate_height], center = true);

    // Round cuts to make grabbing cards easier
    for (dir = [1, -1]) {
        translate([0, dir * (card_y / 2 + 23), 0])
        cylinder(h=10, r=27, center=true, $fa=2);
    }

    //Logo
    union() {
      translate([0, -4.5, 0])
      cube(size = [19,9,10], center = true);
      difference() {
        translate([-4.5, 0.5 ,0])
        cube(size = [10,19,10], center = true);
        translate([0.5, 12 ,0])
        rotate([0, 0, 45])
        cube(size = [10,12,11], center = true);
        translate([-9.5, 12 ,0])
        rotate([0, 0, 45])
        cube(size = [12,10,11], center = true);
      }
    }

    //female con
    translate( [ (card_x/2) - female_con_x + card_space/2 + wall_thickness +0.01 , -female_con_y1/2, -plate_height ] ) //0.01 is for overlapping
    difference() {
      cube(size = [female_con_x, female_con_y1, plate_height*2], center = false);
      translate( [ 0,female_con_y1,-1 ] )
      rotate([0, 0, -angle])
      cube(female_con_x*2);
      translate( [ 0,0,-1 ] )
      rotate([0, 0, angle-90])
      cube(female_con_x*2);
    }

  }

  //male con
  translate( [ -(card_x/2) - card_space/2 - wall_thickness - male_con_x, -male_con_y1/2, -plate_height/2 ] )
  difference() {
    cube(size = [male_con_x, male_con_y1, plate_height], center = false);
    translate( [ 0,male_con_y1,-1 ] )
    rotate([0, 0, -angle])
    cube(male_con_x*2);
    translate( [ 0,0,-1 ] )
    rotate([0, 0, angle-90])
    cube(male_con_x*2);
  }

  //Cards for reference
  //%cube(size = [card_x,card_y,9], center = true);
  //%cube(size = [card_y,card_x,9], center = true);

  // Four pairs of corner walls
  for (x = [0:1]) {
    for (y = [0:1]) {
      mirror([x, 0, 0]) {
        mirror([0, y, 0]) {
          translate([(card_x + card_space) / 2,
                     (card_y + card_space) / 2 + wall_offset,
                     plate_height / 2])
          cube([wall_thickness, wall_length, wall_height], center=false);

          translate([(card_x + card_space ) / 2 + wall_offset,
                     (card_y + card_space) / 2,
                     plate_height / 2])
          cube([wall_length, wall_thickness, wall_height], center=false);
        }
      }
    }
  }
}
