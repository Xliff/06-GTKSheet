use v6.c;

use Cairo;

use GTK::Compat::RGBA;

use GTKSheet::Raw::Types;

use TestSheet::Common;

unit package TestSheet::Example3;

sub build_example3 ($s) is export {
  my $color = GTK::Compat::RGBA.new;
  my $range = GtkSheetRange.new(0, 0, 10, 6);
  
  $s.name = 'example3';
  # selector in CSS:
  #
  # sheet#example3 .orange {
  #   background-color: orange;
  #   color: brown;
  # }
  $s.range_set_css_class($range, 'orange');

  # selector in CSS:
  #
  # sheet#example3 .lblue {
  #   background-color: lightblue;
  #   color: brown;
  # }
  $range.row0 = 1;
  $s.range_set_css_class($range, 'lblue');

  # selector in CSS:
  #
  # sheet#example3 .lgreen {
  #   background-color: lightgreen;
  #   color: brown;
  # }
  $range.col1 = 0;
  $s.range_set_css_class($range, 'lgreen');

  $range.row0 = 0;
  $color.parse('dark blue');
  $s.range_set_border_color($range, $color);
  $s.range_set_border(
    $range, GTK_SHEET_RIGHT_BORDER, 4,
    CAIRO_LINE_CAP_BUTT, CAIRO_LINE_JOIN_MITER
  );

  $range = GtkSheetRange.new(0, 0, 0, 0);
  $s.range_set_border(
    $range, GTK_SHEET_RIGHT_BORDER |+ GTK_SHEET_BOTTOM_BORDER, 4,
    CAIRO_LINE_CAP_BUTT, CAIRO_LINE_JOIN_MITER
  );

  $range = GtkSheetRange.new(0, 1, 0, 6);
  $color.parse('dark blue');
  $s.range_set_border_color($range, $color);
  $s.range_set_border(
    $range, GTK_SHEET_BOTTOM_BORDER, 4,
    CAIRO_LINE_CAP_BUTT, CAIRO_LINE_JOIN_MITER
  );

  $s.autoresize = True; 
  for <GtkDataEntry GtkEntry GtkSpinButton GtkTextView>.kv -> $k, $v {
    $s.column_button_add_label($k, $v);
  }

  $s.column_button_add_label(4, "GtkDataEntry\nmax 10 chars");
  $s.column_get(4).prop_set_int('max-length', 10);
  $s.column_button_add_label(5, "GtkDataTextView\nmax 20 chars");
  $s.column_get(5).prop_set_int('max-length', 20);
  $s.column_button_add_label(6, "GtkDataTextView\nno limit");

  $s.entry_signal_connect_changed(-> $, $ { sheet_entry_changed_handler() });

  $s.traverse.tap(-> *@a { change_entry($s, |@a[1..*]) });
}
