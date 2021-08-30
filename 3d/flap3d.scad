/*
   Copyright 2020 Scott Bezek and the splitflap contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

use<splitflap.scad>;
use<flap.scad>;
use<font_generator.scad>;

// -----------------------
// Configurable parameters
// -----------------------

num_columns = 8;                // Number of columns for layout; 0 for infinite
start_row = 0;                  // First row to render
row_count = 1000;               // Number of rows to render

only_side = 0;                  // 0=both, 1=front only, 2=back only

// If you want to view the full font with each letter as it appears when at the front of the display,
// it requires rendering twice as many flaps and a special layout with the bottom flaps flipped over.
// You also probably want to set only_side to 1 when using this layout.
layout_double_flaps_for_full_font = true;

flip_over = false;              // Flip the entire layout of flaps over (e.g. when exporting the back sizes)

// Gap between flaps
spacing_x = 5;
spacing_y = 5;

bleed = 0;                      // Amount of bleed (in mm) for text to expand beyond the flap boundary

flap_color = [1,1,1];
letter_color = [0,0,0];

render_alignment_marks = false; // Whether to render markings to help with alignment/registration (e.g. for screen printing)
inset=0.2;
// ---------------------------
// End configurable parameters
// ---------------------------

character_list = get_character_list();

cols = (num_columns == 0) ? len(character_list) : num_columns;
total_rows = floor((len(character_list)-1+cols) / cols);
visible_rows = min(row_count, total_rows - start_row);

kerf_width = 0;
render_fill = false;

flap_gap = get_flap_gap();


module get_flaps(){
    _flip() {
        for(i = [0 : len(character_list) - 1]) {
            flap_pos(i) {
                difference(){
                configured_flap(i, flap=true, front_letter=false, back_letter=false,letter_thickness=-inset);
                configured_flap(i, flap=false, front_letter=true, back_letter=true,letter_thickness=-inset);
                }
            }
        }
    }
}

module get_text(){
    fill_text() {
        _flip() {
            for(i = [0 : len(character_list) - 1]) {
                flap_pos(i) {
                    configured_flap(i, flap=false, front_letter=true, back_letter=true,letter_thickness=-inset);
                }
            }
        }
    }
}

get_text();
get_flaps();
