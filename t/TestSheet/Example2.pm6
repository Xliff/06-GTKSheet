use v6.c;

use Cairo;
use GTK::Compat::RGBA;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;
use GTKSheet;

use TestSheet;

use GTK::Button;

unit package TestSheet::Example2;

sub build_example2($s) is export {
  # Naked max column value used as fallback
  my $range = GtkSheetRange.new(0, 0, 2, $s.maxcol // 26);
  my $color = GTK::Compat::RGBA.new(0, 0, 0);

  $s.name = 'example2';
  $s.set_autoscroll(True);
  $s.set_selection_mode(GTK_SELECTION_SINGLE);
  $s.range_set_editable($range, False);

  # selector in CSS:
  #
  # sheet#example2 .blue {
  #   background-color: lightgray;
  #   color: blue;
  # }
  $s.range_set_css_class($range, 'blue');

  # selector in CSS:
  #
  # sheet#example2 .red {
  #   background-color: lightgray;
  #   color: red;
  # }
  $range.row0 = 1;
  $s.range_set_css_class($range, 'red');

  # selector in CSS:
  #
  # sheet#example2 .black {
  #   background-color: lightgray;
  #   color: black;
  # }
  $range.row0 = 2;
  $s.range_set_css_class($range, 'black');

  $s.set_cell(
    0, 2, GTK_JUSTIFY_CENTER,
    'Click the right mouse button to display a popup'
  );
  $s.set_cell(
    1, 2, GTK_JUSTIFY_CENTER,
    "you can connect a parser to the 'set-cell' signal"
  );
  $s.set_cell(
    2, 2, GTK_JUSTIFY_CENTER,
    '(Try typing numbers)'
  );
  $s.set_active_cell(3, 0);

  # Signal handlers reordered for readability.
  $s.button_press_event.tap(-> *@a { @a[*-1].r =         do_popup( $s, @a[1]     ) });
          $s.deactivate.tap(-> *@a { @a[*-1].r = alarm_deactivate( $s, |@a[1..2] ) });
            $s.activate.tap(-> *@a { @a[*-1].r =   alarm_activate(     |@a[1..2] ) });
            $s.traverse.tap(-> *@a { @a[*-1].r =   alarm_traverse(     |@a[1..4] ) });
  
  $s.set-cell.tap({ parse_numbers( $s ) });

  $s.set_row_height(12, 60);
  my $b1 = GTK::Button.new_with_label('GTK_FILL');
  $s.attach($b1, 12, 2, GTK_FILL, GTK_FILL, 5, 5);
  my $b2 = GTK::Button.new_with_label('GTK_EXPAND');
  $s.attach($b2, 12, 3, GTK_EXPAND, GTK_EXPAND, 5, 5);
  my $b3 = GTK::Button.new_with_label('GTK_SHRINK');
  $s.attach($b3, 12, 4, GTK_SHRINK, GTK_SHRINK, 5, 5);
  .show for $b1, $b2, $b3;
  
  my $b = [+|](
    GTK_SHEET_LEFT_BORDER, GTK_SHEET_RIGHT_BORDER, GTK_SHEET_TOP_BORDER,
    GTK_SHEET_BOTTOM_BORDER
  );
  for 4..8 {
    $range.row0 = $range.col0 = $range.row1 = $range.col1 = $_;
    $color.parse('dark blue');
    $s.range_set_border_color($range, $color);
    $s.range_set_border(
      $range, $b, $_ - 3, CAIRO_LINE_CAP_BUTT, CAIRO_LINE_JOIN_MITER
    );
  }
}
