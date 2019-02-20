use v6.c;

use NativeCall;

use GTK::Compat::RGBA;
use GTK::Compat::Types;
use GTK::Raw::Types;
use GTK::Raw::Utils;
use GTKSheet::Raw::Column;
use GTKSheet::Raw::Types;
use GTKSheet::Raw::Sheet;
use Pango::Raw::Types;

use GTK::Adjustment;
use GTK::Container;
use GTKSheet::Column;

use GTKSheet::Roles::Signals::Sheet;

our subset SheetAncestry is export where GtkSheet | ContainerAncestry;

class GTKSheet is GTK::Container {
  also does GTKSheet::Roles::Signals::Sheet;

  has GtkSheet $!es handles <
    active_cell     button children
                    description       drag_cell
    drag_range      entry             flags
                    range             selection_mode
    sheet_entry     state             title
                    x_drag            y_drag
  >;
  has $!esp;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTKSheet');
    $o;
  }

  submethod BUILD(:$sheet) {
    my $to-parent;
    given $sheet {
      when SheetAncestry {
        $!es = do {
          when GtkSheet {
            $to-parent = nativecast(GtkContainer, $_);
            $_;
          }
          when ContainerAncestry {
            $to-parent = $_;
            nativecast(GtkSheet, $_);
          }
        }
        self.setContainer($to-parent);
      }
      default {
      }
    }
    self.ADD-PREFIX('GTKSheet');
    $!esp = nativecast(Pointer, $!es)       # GTK::Roles::Signals::Sheet
  }

  submethod DESTROY {
    self.downref;
  }

  multi method new (SheetAncestry $sheet) {
    my $o = self.bless(:$sheet);
    $o.upref;
    $o;
  }
  multi method new (Int() $rows, Int() $columns, Str() $title) {
    my guint ($r, $c) = resolve-uint($rows, $columns);
    self.bless( sheet => gtk_sheet_new($r, $c, $title) );
  }

  method new_browser (Int() $rows, Int() $columns, Str() $title) {
    my guint ($r, $c) = resolve-uint($rows, $columns);
    gtk_sheet_new_browser($r, $c, $title);
  }

  method new_with_custom_entry (
    Int() $rows,
    Int() $columns,
    Str() $title,
    Int() $entry_type
  ) {
    my guint ($r, $c) = resolve-uint($rows, $columns);
    my uint64 $et = resolve-ulong($entry_type);
    gtk_sheet_new_with_custom_entry($r, $c, $title, $et);
  }

  method clip_range is rw {
    Proxy.new:
      FETCH => -> $                   { $!es.clip_range          },
      STORE => -> $, GdkRectangle $cr { self.set_clip_range($cr) }
  }

  method entry_text is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_sheet_get_entry_text($!es);
      },
      STORE => sub ($, Str() $text is copy) {
        gtk_sheet_set_entry_text($!es, $text);
      }
    );
  }

  method hadjustment is rw {
    Proxy.new(
      FETCH => sub ($) {
        GTK::Adjustment.new( gtk_sheet_get_hadjustment($!es) );
      },
      STORE => sub ($, GtkAdjustment() $adjustment is copy) {
        gtk_sheet_set_hadjustment($!es, $adjustment);
      }
    );
  }

  method vadjustment is rw {
    Proxy.new(
      FETCH => sub ($) {
        GTK::Adjustment.new( gtk_sheet_get_vadjustment($!es) );
      },
      STORE => sub ($, GtkAdjustment() $adjustment is copy) {
        gtk_sheet_set_vadjustment($!es, $adjustment);
      }
    );
  }

  method vjustification is rw {
    Proxy.new(
      FETCH => sub ($) {
        GtkSheetVerticalJustification( gtk_sheet_get_vjustification($!es) );
      },
      STORE => sub ($, Int() $vjust is copy) {
        my guint $vj = resolve-uint($vjust);
        gtk_sheet_set_vjustification($!es, $vj);
      }
    );
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> gboolean
  method activate {
    self.connect-activate($!esp);
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> void
  method changed {
    self.connect-intint($!esp, 'changed');
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> void
  method clear-cell {
    self.connect-intint($!esp, 'clear-cell');
  }

  # Is originally:
  # GtkSheet, GtkSheetRange, gpointer --> void
  method clip-range {
    self.connect-clip-range($!esp);
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> gboolean
  method deactivate {
    self.connect-activate($!esp, 'deactivate');
  }

  # Is originally:
  # GtkSheet, GdkEvent, gpointer --> gboolean
  method enter-pressed {
    self.connect-sheet-event($!esp, 'enter-pressed');
  }

  # Is originally:
  # GtkSheet, GdkEvent, gpointer --> gboolean
  method entry-focus-in {
    self.connect-sheet-event($!esp, 'entry-focus-in');
  }

  # Is originally:
  # GtkSheet, GdkEvent, gpointer --> gboolean
  method entry-focus-out {
    self.connect-sheet-event($!esp, 'entry-focus-out');
  }

  # Is originally:
  # GtkSheet, GtkMovementStep, gint, gboolean, gpointer --> void
  method move-cursor {
    self.connect-move-cursor($!esp);
  }

  # Is originally:
  # GtkSheet, GtkSheetRange, GtkSheetRange, gpointer --> void
  method move-range {
    self.connect-move-range($!esp);
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> void
  method new-column-width {
    self.connect-intint($!esp, 'new-column-width');
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> void
  method new-row-height {
    self.connect-intint($!esp, 'new-row-height');
  }

  # Is originally:
  # GtkSheet, GtkMenu, gpointer --> void
  method populate-popup {
    self.connect-menu($!esp, 'populate-popup');
  }

  # Is originally:
  # GtkSheet, GtkSheetRange, GtkSheetRange, gpointer --> void
  method resize-range {
    self.connect-move-range($!esp, 'resize-range');
  }

  # Is originally:
  # GtkSheet, gint, gpointer --> void
  method select-column {
    self.connect-int($!esp, 'select-column');
  }

  # Is originally:
  # GtkSheet, GtkSheetRange, gpointer --> void
  method select-range {
    self.connect-select-range($!esp);
  }

  # Is originally:
  # GtkSheet, gint, gpointer --> void
  method select-row {
    self.connect-int($!esp, 'select-row');
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer --> void
  method set-cell {
    self.connect-intint($!esp, 'set-cell');
  }

  # Is originally:
  # GtkSheet, GtkAdjustment, GtkAdjustment, gpointer --> void
  method set-scroll-adjustments {
    self.connect-set-scroll-adjustments($!esp);
  }

  # Is originally:
  # GtkSheet, gint, gint, gpointer, gpointer, gpointer --> gboolean
  method traverse {
    self.connect-traverse($!esp);
  }


  method add_column (Int() $ncols) {
    my $nc = resolve-uint($ncols);
    gtk_sheet_add_column($!es, $nc);
  }

  method add_row (Int() $nrows) {
    my $nr = resolve-uint($nrows);
    gtk_sheet_add_row($!es, $nr);
  }

  method attach (
    GtkWidget() $widget,
    Int() $row,
    Int() $col,
    Int() $xoptions,
    Int() $yoptions,
    Int() $xpadding,
    Int() $ypadding
  ) {
    my @i = ($row, $col, $xoptions, $yoptions, $xpadding, $ypadding);
    my gint ($r, $c, $xo, $yo, $xp, $yp) = resolve-int(@i);
    gtk_sheet_attach($!es, $widget, $r, $c, $xo, $yo, $xp, $yp);
  }

  method attach_default (GtkWidget() $widget, Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_attach_default($!es, $widget, $r, $c);
  }

  method attach_floating (GtkWidget() $widget, Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_attach_floating($!es, $widget, $r, $c);
  }

  method autoresize {
    gtk_sheet_autoresize($!es);
  }

  method autoresize_columns {
    gtk_sheet_autoresize_columns($!es);
  }

  method autoresize_rows {
    gtk_sheet_autoresize_rows($!es);
  }

  method autoscroll {
    gtk_sheet_autoscroll($!es);
  }

  method button_attach (GtkWidget() $widget, Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_button_attach($!es, $widget, $r, $c);
  }

  method cell_clear (Int() $row, Int() $column) {
    my gint ($r, $c) = resolve-int($row, $column);
    gtk_sheet_cell_clear($!es, $r, $c);
  }

  method cell_delete (Int() $row, Int() $column) {
    my gint ($r, $c) = resolve-int($row, $column);
    gtk_sheet_cell_delete($!es, $r, $c);
  }

  method cell_get_state (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_cell_get_state($!es, $r, $c);
  }

  method cell_get_text (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_cell_get_text($!es, $r, $c);
  }

  method cell_get_tooltip_markup (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_cell_get_tooltip_markup($!es, $r, $c);
  }

  method cell_get_tooltip_text (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_cell_get_tooltip_text($!es, $r, $c);
  }

  method cell_set_tooltip_markup (Int() $row, Int() $col, Str() $markup) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_cell_set_tooltip_markup($!es, $r, $c, $markup);
  }

  method cell_set_tooltip_text (Int() $row, Int() $col, Str() $text) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_cell_set_tooltip_text($!es, $r, $c, $text);
  }

  method change_entry (Int() $entry_type) {
    my uint64 $et = resolve-ulong($entry_type);
    gtk_sheet_change_entry($!es, $et);
  }

  method set_clip_range (GtkSheetRange() $clip_range) {
    gtk_sheet_clip_range($!es, $clip_range);
  }

  method clip_text {
    gtk_sheet_clip_text($!es);
  }

  method construct (Int() $rows, Int() $columns, Str() $title) {
    my gint ($r, $c) = resolve-int($rows, $columns);
    gtk_sheet_construct($!es, $r, $c, $title);
  }

  method construct_browser (Int() $rows, Int() $columns, Str() $title) {
    my gint ($r, $c) = resolve-int($rows, $columns);
    gtk_sheet_construct_browser($!es, $r, $c, $title);
  }

  method construct_with_custom_entry (
    Int() $rows,
    Int() $columns,
    Str() $title,
    Int() $entry_type
  ) {
    my guint ($r, $c) = resolve-uint($rows, $columns);
    my uint64 $et = resolve-ulong($entry_type);
    gtk_sheet_construct_with_custom_entry($!es, $r, $c, $title, $et);
  }

  method delete_columns (Int() $col, Int() $ncols) {
    my gint ($c, $nc) = resolve-int($col, $ncols);
    gtk_sheet_delete_columns($!es, $c, $nc);
  }

  method delete_rows (Int() $row, Int() $nrows) {
    my gint ($r, $nr) = resolve-int($row, $nrows);
    gtk_sheet_delete_rows($!es, $r, $nr);
  }

  method entry_select_region (Int() $start_pos, Int() $end_pos) {
    my gint ($sp, $ep) = resolve-int($start_pos, $end_pos);
    gtk_sheet_entry_select_region($!es, $sp, $ep);
  }

  method entry_signal_connect_changed (&handler) {
    gtk_sheet_entry_signal_connect_changed($!es, &handler);
  }

  method entry_signal_disconnect_by_func (GCallback $handler) {
    gtk_sheet_entry_signal_disconnect_by_func($!es, $handler);
  }

  method freeze {
    gtk_sheet_freeze($!es);
  }

  method get_active_cell (Int() $row, Int() $column) {
    my gint ($r, $c) = resolve-int($row, $column);
    gtk_sheet_get_active_cell($!es, $r, $c);
  }

  multi method get_attributes {
    samewith(self.active_cell.row, self.active_cell.col);
  }
  multi method get_attributes (
    Int() $row,
    Int() $col
  ) {
    my GtkSheetCellAttr $attr .= new;
    samewith($row, $col, $attr);
    $attr;
  }
  multi method get_attributes (
    Int() $row,
    Int() $col,
    GtkSheetCellAttr $attributes
  ) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_get_attributes($!es, $r, $c, $attributes);
  }

  multi method get_cell_area (Int() $row, Int() $column) {
    my GdkRectangle $r .= new;
    samewith($row, $column, $r);
    $r;
  }
  multi method get_cell_area (Int() $row, Int() $column, GdkRectangle $area) {
    my gint ($r, $c) = resolve-int($row, $column);
    gtk_sheet_get_cell_area($!es, $r, $c, $area);
  }

  method get_child_at (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_get_child_at($!es, $r, $c);
  }

  method get_columns_count {
    gtk_sheet_get_columns_count($!es);
  }

  method get_description (Str() $description) {
    gtk_sheet_get_description($!es, $description);
  }

  method get_entry {
    gtk_sheet_get_entry($!es);
  }

  method get_entry_type {
    gtk_sheet_get_entry_type($!es);
  }

  method get_entry_widget {
    gtk_sheet_get_entry_widget($!es);
  }

  method get_link (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_get_link($!es, $r, $c);
  }

  method get_pixel_info (
    GdkWindow() $window,
    Int() $x,
    Int() $y,
    Int() $row,
    Int() $column
  ) {
    my gint ($xx, $yy, $r, $c) = resolve-int($x, $y, $row, $column);
    gtk_sheet_get_pixel_info($!es, $window, $xx, $yy, $r, $c);
  }

  method get_row_title (Int() $row) {
    my gint ($r) = resolve-int($row);
    gtk_sheet_get_row_title($!es, $r);
  }

  method get_rows_count {
    gtk_sheet_get_rows_count($!es);
  }

  method get_selection (GtkSheetState $state, GtkSheetRange $range) {
    gtk_sheet_get_selection($!es, $state, $range);
  }

  method get_type {
    self.unstable_get_type( gtk_sheet_get_type );
  }

  method get_visible_range (GtkSheetRange() $range) {
    gtk_sheet_get_visible_range($!es, $range);
  }

  method grid_visible {
    gtk_sheet_grid_visible($!es);
  }

  method hide_row_titles {
    gtk_sheet_hide_row_titles($!es);
  }

  method in_clip {
    gtk_sheet_in_clip($!es);
  }

  method insert_columns (Int() $col, Int() $ncols) {
    my ($c, $nc) = resolve-uint($col, $ncols);
    gtk_sheet_insert_columns($!es, $c, $nc);
  }

  method insert_rows (Int() $row, Int() $nrows) {
    my ($r, $nr) = resolve-uint($row, $nrows);
    gtk_sheet_insert_rows($!es, $r, $nr);
  }

  method is_frozen {
    gtk_sheet_is_frozen($!es);
  }

  method justify_entry {
    gtk_sheet_justify_entry($!es);
  }

  method link_cell (Int() $row, Int() $col, gpointer $link) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_link_cell($!es, $r, $c, $link);
  }

  method locked {
    gtk_sheet_locked($!es);
  }

  method move_child (GtkWidget() $widget, Int() $x, Int() $y) {
    my gint ($xx, $yy) = resolve-int($x, $y);
    gtk_sheet_move_child($!es, $widget, $xx, $yy);
  }

  method moveto (
    Int() $row,
    Int() $column,
    Int() $row_align,
    Int() $col_align
  ) {
    my gint ($r, $c, $ra, $ca) = resolve-int(
      $row, $column, $row_align, $col_align
    );
    gtk_sheet_moveto($!es, $r, $c, $ra, $ca);
  }

  method put (GtkWidget() $child, Int() $x, Int() $y) {
    my gint ($xx, $yy) = resolve-int($x, $y);
    gtk_sheet_put($!es, $child, $x, $y);
  }

  method range_clear (GtkSheetRange $range = self.range) {
    gtk_sheet_range_clear($!es, $range);
  }

  method range_delete (GtkSheetRange $range = self.range) {
    gtk_sheet_range_delete($!es, $range);
  }

  method range_get_type {
    self.unstable_get_type( gtk_sheet_range_get_type() );
  }

  multi method range_set_background(GdkRGBA $color) {
    samewith(self.range, $color);
  }
  multi method range_set_background (
    GtkSheetRange $urange,
    GdkRGBA $color
  ) {
    gtk_sheet_range_set_background($!es, $urange, $color);
  }

  multi method range_set_border(
    Int() $mask,
    Int() $width,
    Int() $cap_style,
    Int() $join_style
  ) {
    samewith(self.range, $mask, $width, $cap_style, $join_style)
  }
  multi method range_set_border (
    GtkSheetRange $urange,
    Int() $mask,
    Int() $width,
    Int() $cap_style,
    Int() $join_style
  ) {
    my @u = ($width, $cap_style, $join_style);
    my gint $m = resolve-int($mask);
    my guint ($w, $cs, $js) = resolve-uint(@u);
    gtk_sheet_range_set_border($!es, $urange, $m, $w, $cs, $js);
  }

  multi method range_set_border_color (GdkRGBA $color) {
    samewith(self.range, $color);
  }
  multi method range_set_border_color (
    GtkSheetRange $urange,
    GdkRGBA $color
  ) {
    gtk_sheet_range_set_border_color($!es, $urange, $color);
  }

  multi method range_set_css_class (Str() $class) {
    samewith(self.range, $class);
  }
  multi method range_set_css_class(
    GtkSheetRange $urange,
    Str() $class
  ) {
    gtk_sheet_range_set_css_class($!es, $urange, $class);
  }

  multi method range_set_editable (Int() $editable) {
    samewith(self.range, $editable);
  }
  multi method range_set_editable (
    GtkSheetRange $urange,
    Int() $editable
  ) {
    my gint $e = resolve-int($editable);
    gtk_sheet_range_set_editable($!es, $urange, $e);
  }

  multi method range_set_font (PangoFontDescription() $font_desc) {
    samewith(self.range, $font_desc);
  }
  multi method range_set_font (
    GtkSheetRange $urange,
    PangoFontDescription() $font_desc
  ) {
    gtk_sheet_range_set_font($!es, $urange, $font_desc);
  }

  multi method range_set_foreground(GdkRGBA $color) {
    samewith(self.range, $color);
  }
  multi method range_set_foreground (
    GtkSheetRange $urange,
    GdkRGBA $color
  ) {
    gtk_sheet_range_set_foreground($!es, $urange, $color);
  }

  multi method range_set_justification (Int() $just) {
    samewith(self.range, $just);
  }
  multi method range_set_justification (
    GtkSheetRange $urange,
    Int() $just                  # GtkJustification $just
  ) {
    my uint32 $j = resolve-uint($just);
    gtk_sheet_range_set_justification($!es, $urange, $j);
  }

  multi method range_set_visible (Int() $visible) {
    samewith(self.range, $visible);
  }
  multi method range_set_visible (
    GtkSheetRange $urange,
    Int() $visible)
  {
    my guint $v = resolve-bool($visible);
    gtk_sheet_range_set_visible($!es, $urange, $v);
  }

  method remove_link (Int() $row, Int() $col) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_remove_link($!es, $r, $c);
  }

  method row_button_add_label (Int() $row, Str() $label) {
    my gint $r = resolve-int($row);
    gtk_sheet_row_button_add_label($!es, $row, $label);
  }

  method row_button_get_label (Int() $row) {
    my gint $r = resolve-int($row);
    gtk_sheet_row_button_get_label($!es, $row);
  }

  method row_button_justify (
    Int() $row,
    Int() $justification          # GtkJustification $justification
  ) {
    my gint $r = resolve-int($row);
    my guint $j = resolve-uint($justification);
    gtk_sheet_row_button_justify($!es, $r, $j);
  }

  method row_sensitive (Int() $row) {
    my gint $r = resolve-int($row);
    gtk_sheet_row_sensitive($!es, $r);
  }

  method row_titles_visible {
    gtk_sheet_row_titles_visible($!es);
  }

  method row_visible (Int() $row) {
    my gint $r = resolve-int($row);
    gtk_sheet_row_visible($!es, $r);
  }

  method rows_labels_set_visibility (Int() $visible) {
    my uint32 $v = resolve-bool($visible);
    gtk_sheet_rows_labels_set_visibility($!es, $v);
  }

  method rows_resizable {
    gtk_sheet_rows_resizable($!es);
  }

  method rows_set_resizable (Int() $resizable) {
    my uint32 $r = resolve-bool($resizable);
    gtk_sheet_rows_set_resizable($!es, $r);
  }

  method rows_set_sensitivity (Int() $sensitive) {
    my uint32 $s = resolve-bool($sensitive);
    gtk_sheet_rows_set_sensitivity($!es, $s);
  }

  method select_column (Int() $column) {
    my gint $c = resolve-int($column);
    gtk_sheet_select_column($!es, $c);
  }

  method select_range (GtkSheetRange() $range) {
    gtk_sheet_select_range($!es, $range);
  }

  method select_row (Int() $row) {
    my gint $r = resolve-int($row);
    gtk_sheet_select_row($!es, $r);
  }

  method set_active_cell (Int() $row, Int() $column) {
    my gint ($r, $c) = resolve-int($row, $column);
    gtk_sheet_set_active_cell($!es, $r, $c);
  }

  method set_autoresize (Int() $autoresize) {
    my guint $a = resolve-bool($autoresize);
    gtk_sheet_set_autoresize($!es, $a);
  }

  method set_autoresize_columns (Int() $autoresize) {
    my guint $a = resolve-bool($autoresize);
    gtk_sheet_set_autoresize_columns($!es, $a);
  }

  method set_autoresize_rows (Int() $autoresize) {
    my guint $a = resolve-bool($autoresize);
    gtk_sheet_set_autoresize_rows($!es, $a);
  }

  method set_autoscroll (Int() $autoscroll) {
    my guint $a = resolve-bool($autoscroll);
    gtk_sheet_set_autoscroll($!es, $a);
  }

  multi method set_cell (
    Int() $justification,         # GtkJustification $justification,
    Str() $text
  ) {
    samewith(
      self.active_cell.row, self.active_cell.col, $justification, $text
    );
  }
  multi method set_cell (
    Int() $row,
    Int() $col,
    Int() $justification,         # GtkJustification $justification,
    Str() $text
  ) {
    my gint ($r, $c) = resolve-int($row, $col);
    my guint $j = resolve-uint($justification);
    gtk_sheet_set_cell($!es, $r, $c, $j, $text);
  }

  method set_cell_text (Int() $row, Int() $col, Str() $text) {
    my gint ($r, $c) = resolve-int($row, $col);
    gtk_sheet_set_cell_text($!es, $r, $c, $text);
  }

  method set_clip_text (Int() $clip_text) {
    my guint $ct = resolve-bool($clip_text);
    gtk_sheet_set_clip_text($!es, $ct);
  }

  method set_description (Str() $description) {
    gtk_sheet_set_description($!es, $description);
  }

  method set_entry_editable (Int() $editable) {
    my uint32 $e = resolve-bool($editable);
    gtk_sheet_set_entry_editable($!es, $editable);
  }

  method set_grid (GdkRGBA $color) {
    gtk_sheet_set_grid($!es, $color);
  }

  method set_justify_entry (Int() $justify) {
    my uint32 $j = resolve-bool($justify);
    gtk_sheet_set_justify_entry($!es, $j);
  }

  method set_locked (Int() $locked) {
    my uint32 $l = resolve-bool($locked);
    gtk_sheet_set_locked($!es, $l);
  }

  method set_row_height (Int() $row, Int() $height) {
    my guint ($r, $h) = resolve-int($row, $height);
    gtk_sheet_set_row_height($!es, $r, $h);
  }

  method set_row_title (Int() $row, Str() $title) {
    my guint $r = resolve-int($row);
    gtk_sheet_set_row_title($!es, $r, $title);
  }

  method set_row_titles_width (Int() $width) {
    my guint $w = resolve-uint($width);
    gtk_sheet_set_row_titles_width($!es, $w);
  }

  method set_selection_mode (
    Int() $mode                   # GtkSelectionMode $mode
  ) {
    my guint $m = resolve-uint($mode);
    gtk_sheet_set_selection_mode($!es, $m);
  }

  method set_tab_direction (
    Int() $dir                    # GtkDirectionType $dir
  ) {
    my guint $d = resolve-uint($dir);
    gtk_sheet_set_tab_direction($!es, $d);
  }

  method set_title (Str() $title) {
    gtk_sheet_set_title($!es, $title);
  }

  method show_grid (Int() $show) {
    my uint32 $s = resolve-bool($show);
    gtk_sheet_show_grid($!es, $s);
  }

  method show_row_titles {
    gtk_sheet_show_row_titles($!es);
  }

  method thaw {
    gtk_sheet_thaw($!es);
  }

  method unclip_range {
    gtk_sheet_unclip_range($!es);
  }

  method unselect_range {
    gtk_sheet_unselect_range($!es);
  }

  # »»»»»»»»»»»»»»» COLUMN METHODS ««««««««««««««««««

  multi method column_button_add_label (Str() $label) {
    samewith(self.active_cell.col, $label);
  }
  multi method column_button_add_label (
    Int() $col,
    Str() $label
  ) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_button_add_label($!es, $c, $label);
  }

  method column_button_get_label (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_button_get_label($!es, $c);
  }

  multi method column_button_justify (Int() $justification) {
    samewith(self.active_cell.col, $justification);
  }
  multi method column_button_justify (
    Int() $col,
    Int() $justification
  ) {
    my gint $c = resolve-int($col);
    my guint $j = resolve-uint($justification);
    gtk_sheet_column_button_justify($!es, $c, $j);
  }

  method column_get (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    GtkSheet::Column.new( gtk_sheet_column_get($!es, $c), $!es, $c );
  }

  method column_get_datatype (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_datatype($!es, $c);
  }

  method column_get_description (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_description($!es, $c);
  }

  method column_get_entry_type (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_entry_type($!es, $c);
  }

  method column_get_format (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_format($!es, $c);
  }

  # Not used here, see GTKSheet::Column
  # method column_get_index {
  #   gtk_sheet_column_get_index($!es);
  # }

  method column_get_iskey (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_iskey($!es, $c);
  }

  method column_get_justification (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_justification($!es, $c);
  }

  method column_get_readonly (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_readonly($!es, $c);
  }

  method column_get_tooltip_markup (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_tooltip_markup($!es, $c);
  }

  method column_get_tooltip_text (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_tooltip_text($!es, $c);
  }

  method column_get_type {
    self.unstable_get_type( gtk_sheet_column_get_type() );
  }

  method column_get_vjustification (Int() $col = self.active_cell.col) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_get_vjustification($!es, $c);
  }

  method column_sensitive (Int() $column = self.active_cell.col) {
    my gint $c = resolve-int($column);
    gtk_sheet_column_sensitive($!es, $c);
  }

  multi method column_set_datatype (Str $data_type) {
    samewith(self.active_cell.col, $data_type);
  }
  multi method column_set_datatype (Int() $col, Str() $data_type) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_set_datatype($!es, $c, $data_type);
  }

  multi method column_set_description (Str() $description) {
    samewith(self.active_cell.col, $description);
  }
  multi method column_set_description (
    Int() $col,
    Str() $description
  ) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_set_description($!es, $c, $description);
  }

  multi method column_set_entry_type (Int() $entry_type) {
    samewith(self.active_cell.col, $entry_type);
  }
  multi method column_set_entry_type (
    Int() $col,
    Int() $entry_type             # GTypeEnum
  ) {
    my gint $c = resolve-int($col);
    my uint64 $et = resolve-ulong($entry_type);
    gtk_sheet_column_set_entry_type($!es, $c, $entry_type);
  }

  multi method column_set_format (Str() $format) {
    samewith(self.active_cell.col, $format);
  }
  multi method column_set_format (
    Int() $col,
    Str() $format
  ) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_set_format($!es, $c, $format);
  }

  multi method column_set_iskey (Int() $is_key) {
    samewith(self.active_cell.col, $is_key);
  }
  multi method column_set_iskey (
    Int() $col,
    Int() $is_key
  ) {
    my gint $c = resolve-int($col);
    my gboolean $ik = resolve-bool($is_key);
    gtk_sheet_column_set_iskey($!es, $c, $ik);
  }

  multi method column_set_justification (Int() $just) {
    samewith(self.active_cell.col, $just);
  }
  multi method column_set_justification (
    Int() $col,
    Int() $just                   # GtkJustification $just
  ) {
    my gint $c = resolve-int($col);
    my guint $j = resolve-uint($just);
    gtk_sheet_column_set_justification($!es, $c, $j);
  }

  multi method column_set_readonly (Int() $is_readonly) {
    samewith(self.active_cell.col, $is_readonly);
  }
  multi method column_set_readonly (
    Int() $col,
    Int() $is_readonly
  ) {
    my gint $c = resolve-int($col);
    my gboolean $ir = resolve-bool($is_readonly);
    gtk_sheet_column_set_readonly($!es, $c, $ir);
  }

  multi method column_set_tooltip_markup (Str() $markup) {
    samewith(self.active_cell.col, $markup);
  }
  multi method column_set_tooltip_markup (
    Int() $col,
    Str() $markup
  ) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_set_tooltip_markup($!es, $c, $markup);
  }

  multi method column_set_tooltip_text (Str() $text) {
    samewith(self.active_cell.col, $text);
  }
  multi method column_set_tooltip_text (
    Int() $col,
    Str() $text
  ) {
    my gint $c = resolve-int($col);
    gtk_sheet_column_set_tooltip_text($!es, $c, $text);
  }

  multi method column_set_vjustification(Int() $vjust) {
    samewith(self.active_cell.col, $vjust);
  }
  multi method column_set_vjustification (
    Int() $col,
    Int() $vjust
  ) {
    my gint $c = resolve-int($col);
    my guint $vj = resolve-uint($vjust);
    gtk_sheet_column_set_vjustification($!es, $c, $vj);
  }

  method column_titles_visible {
    gtk_sheet_column_titles_visible($!es);
  }

  method column_visible (Int() $column = self.active_cell.col) {
    my gint $c = resolve-int($column);
    gtk_sheet_column_visible($!es, $c);
  }

  method columns_labels_set_visibility (Int() $visible) {
    my gboolean $v = resolve-bool($visible);
    gtk_sheet_columns_labels_set_visibility($!es, $v);
  }

  method columns_resizable {
    gtk_sheet_columns_resizable($!es);
  }

  method columns_set_resizable (Int() $resizable) {
    my gboolean $r = resolve-bool($resizable);
    gtk_sheet_columns_set_resizable($!es, $r);
  }

  method columns_set_sensitivity (Int() $sensitive) {
    my gboolean $s = resolve-bool($sensitive);
    gtk_sheet_columns_set_sensitivity($!es, $s);
  }

  method get_column_title (Int() $column = self.active_cel.col) {
    my gint $c = resolve-int($column);
    gtk_sheet_get_column_title($!es, $c);
  }

  method get_column_width (Int() $column = self.active_cell.col) {
    my gint $c = resolve-int($column);
    gtk_sheet_get_column_width($!es, $c);
  }

  method hide_column_titles {
    gtk_sheet_hide_column_titles($!es);
  }

  multi method set_column_title (Str() $title) {
    samewith(self.active_cell.col, $title);
  }
  multi method set_column_title (
    Int() $column,
    Str() $title
  ) {
    my gint $c = resolve-int($column);
    gtk_sheet_set_column_title($!es, $c, $title);
  }

  method set_column_titles_height (Int() $height) {
    my gint $h = resolve-uint($height);
    gtk_sheet_set_column_titles_height($!es, $h);
  }

  multi method set_column_width (Int() $width) {
    samewith(self.active_cell.col, $width);
  }
  multi method set_column_width (
    Int() $column,
    Int() $width
  ) {
    my gint ($c, $w) = resolve-int($column, $width);
    gtk_sheet_set_column_width($!es, $c, $w);
  }

  method show_column_titles {
    gtk_sheet_show_column_titles($!es);
  }

}
