# Stacking Game Card Holder

This is an OpenSCAD model of a game card holder. The original design was done by
[condac](https://github.com/condac/gamecardholder), so kudos to that person.

I made a few improvements:
* The model is now more tolerate of changing sizes. I wanted a holder for The Rivals For Catan
  cards (great 2-player game, by the way), which has 69mm square cards.
* The card holders now nest on top of each other so they can be used to store the cards.
* I simplified the code a bit by way of learning some of the OpenSCAD commands (e.g. module,
  linear_extrude, for).
* Lastly, I made the connectors fit a bit tighter so that a row of holders is more stable. That
  might be dependent on the accuracy of the printer, so you can adjust the 1/2 mm space between
  connectors in the code if needed.
