use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;

use TestSheet;

use GTK::Compat::Pixbuf;
use GTK::Calendar;

unit package TestSheet::Example1;

sub build_example1($s) is export {
  my $color = GTK::Compat::RGBA.new;

  $s.name = 'example1';

  # selector in CSS:
  #
  # sheet .example1class {
  #   background-color: lightyellow;
  #   color: black;
  # }
  $s.set_css_class('example1class');
  $color.parse('light blue');
  $s.set_grid($color);

  for 0..$s.maxcol {
    $s.column_button_add_label($_, @col_names[$_]);
    $s.set_column_title($_, @col_names[$_]);
  }

  $s.row_button_add_label(0, "This is\na multiline\nlabel");
  $s.row_button_add_label(1, 'This is a long label');
  $s.row_set_tooltip_markupl(1, 'This row has a <b>long label</b>.');
  $s.row_button_justify(0, GTK_JUSTIFY_RIGHT);

  my $range = GtkSheetRange.new(1, 1, 2, 3);
  $s.clip_range($range);

  # selector in CSS:
  #
  # sheet .example1red {
  #   color: red;
  # }
  $s.range_set_css_class($range, 'example1red');

  $s.set_cell(1, 2, GTK_JUSTIFY_CENTER, 'Welcome to');
  $range.row0 = 2;
  # selector in CSS:
  #
  # sheet .example1blue {
  #   color: blue;
  # }
  $s.range_set_css_class($range, 'example1blue');
  $s.set_cell(2, 2, GTK_JUSTIFY_CENTER, 'GtkSheet');

  $range = GtkSheetRange.new(3, 0, 3, 4);

  # selector in CSS:
  #
  # sheet .example1grey {
  #   background-color: darkgrey;
  #   color: green;
  # }
  $s.range_set_css_class($range, 'example1grey');
  $s.set_cell(3, 2, GTK_JUSTIFY_CENTER, 'a Matrix widget for Gtk+');

  my $multiline = q:to/ML/.chomp;
GtkSheet is a matrix where you can allocate cells of text.
Cell contents can be edited interactively with a specially designed entry
You can change colors, borders, and may other attributes
Drag & drop or resize the selection by clicking the corner or border
Store the selection on the clipboard by pressing Ctrl-C
(The selection handler has not been implemented, yet)
You can add buttons, charts, pixmaps and other widgets
ML

  my $rs = 4;
  $s.set_cell($rs++, 1, GTK_JUSTIFY_LEFT, $_) for $multiline.lines;

  $s.button_press_event.tap(-> *@a { @a[*-1].r = clipboard_handler( $s,  @a[1]    ) });
          $s.deactivate.tap(-> *@a { @a[*-1].r =  alarm_deactivate( $s, |@a[1..2] ) });
            $s.activate.tap(-> *@a { @a[*-1].r =    alarm_activate(     |@a[1..2] ) });
            $s.traverse.tap(-> *@a { @a[*-1].r =    alarm_traverse(     |@a[1..4] ) });

               $s.changed.tap(-> *@a {   alarm_change( |@a[1..2] ) });
          $s.resize-range.tap(-> *@a { resize_handler( |@a[1..2] ) });
            $s.move-range.tap(-> *@a {   move_handler( |@a[1..2] ) });

  my $cal = GTK::Calendar.new;
  $cal.show;

  my @bullets;
  for ^5 {
    @bullets.push: GTK::Image.new_from_pixbuf(%pixbuf<bullet>);
    @bullets[$_].show;
    #my $area = $s.get_cell_area(4 + $_, 0);
    $s.attach(@bullets[$_], 4 + $_, 0, GTK_EXPAND, GTK_EXPAND, 0, 0);
  }
  @bullets.push = GTK::Image.new_from_pixbuf(%pixbuf<bullet>);
  @bullets[5].show;
  #my $area = $s.get_cell_area(10, 0);
  $s.attach(@bullets[4], 10, 0, GTK_EXPAND, GTK_EXPAND, 0, 0);

  my $smile = GTK::Image.new_from_pixbuf(%pixbuf<smile>);
  $smile.show;
  $s.sheet_button_attach($smile, -1, 5);
  $s.column_set_tooltip_markup(
    5, 'This column has a <b>Smiley!</b> in the title button'
  );
  $s.cell_set_tooltip_text(
    1, 5, 'This single cell has its own tooltip text'
  );

  my $show_button = GTK::Button.new_with_label('Show me a calendar');
  $show_button.show;
  $show_button.set_size_request(100, 60);
  #my $area = $s.get_cell_area(12, 2);
  $s.attach($show_button, 12, 2, GTK_FILL, GTK_FILL, 5, 5);

  $show_button.clicked.tap({ show_child });
}
