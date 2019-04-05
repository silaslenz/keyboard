# Case

`jsonPositions.py` from https://github.com/Lenbok/scad-redox-case

Case design was done using OnShape: https://cad.onshape.com/documents/dd3a40a5ed605083cfbf3990/w/82b7bddab61a2b6cbcf17e8c/e/b49ff9ea8062e97cecc28f36

Comment out one of the `const key_layout` arrays in the feature studio to switch between left and right parts.

## Stuff to print
* One each of `left-bottom.stl`, `left-top.stl`, `right-bottom.stl`, `right-top.stl`.
* 12 of `tent-nut.stl`, two for each of the bolts.
* 2 of `tent-bolt-short.stl` for the thumb cluster tenting position.
* 4 of `tent-bolt.stl` for the other tenting positions.


# Keycaps
Keycaps where also designed using onshape: https://cad.onshape.com/documents/d67b44172e642988c616e11f/w/3eda0524007876da50b065d1/e/4574dfdf04ae35f8a288d57f

Modify `width` and/or `height` variables for special keys, move down rollback bar and modify `Lettering sketch` to add text or other shapes.

## How to print
* First print the letter parts (one layer). Don't forget to rotate by 180 degrees around the Y axis.
* Print the keycaps on top without removing the letters from the bed. Also print bottom up by rotating 180 degrees around the Y axis and position on top of the letters.