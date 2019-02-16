use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTKExtra::Types;

unit package GTKExtra::Raw::Sheet;

sub gtk_sheet_add_column (GtkSheet $sheet, guint $ncols)
  is native(extra)
  is export
  { * }

sub gtk_sheet_add_row (GtkSheet $sheet, guint $nrows)
  is native(extra)
  is export
  { * }

sub gtk_sheet_attach (
  GtkSheet $sheet,
  GtkWidget $widget,
  gint $row,
  gint $col,
  gint $xoptions,
  gint $yoptions,
  gint $xpadding,
  gint $ypadding
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_attach_default (
  GtkSheet $sheet,
  GtkWidget $widget,
  gint $row,
  gint $col
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_attach_floating (
  GtkSheet $sheet,
  GtkWidget $widget,
  gint $row,
  gint $col
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_autoresize (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_autoresize_columns (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_autoresize_rows (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_autoscroll (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_button_attach (
  GtkSheet $sheet,
  GtkWidget $widget,
  gint $row,
  gint $col
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_clear (GtkSheet $sheet, gint $row, gint $column)
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_delete (GtkSheet $sheet, gint $row, gint $column)
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_get_state (GtkSheet $sheet, gint $row, gint $col)
  returns GtkStateType
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_get_text (GtkSheet $sheet, gint $row, gint $col)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_get_tooltip_markup (
  GtkSheet $sheet,
  gint $row,
  gint $col
)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_get_tooltip_text (GtkSheet $sheet, gint $row, gint $col)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_set_tooltip_markup (
  GtkSheet $sheet,
  gint $row,
  gint $col,
  Str $markup
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_cell_set_tooltip_text (
  GtkSheet $sheet,
  gint $row,
  gint $col,
  Str $text
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_change_entry (GtkSheet $sheet, GType $entry_type)
  is native(extra)
  is export
  { * }

sub gtk_sheet_clip_range (GtkSheet $sheet, GtkSheetRange $clip_range)
  is native(extra)
  is export
  { * }

sub gtk_sheet_clip_text (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_construct (
  GtkSheet $sheet,
  guint $rows,
  guint $columns,
  Str $title
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_construct_browser (
  GtkSheet $sheet,
  guint $rows,
  guint $columns,
  Str $title
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_construct_with_custom_entry (
  GtkSheet $sheet,
  guint $rows,
  guint $columns,
  Str $title,
  GType $entry_type
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_delete_columns (
  GtkSheet $sheet,
  guint $col,
  guint $ncols
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_delete_rows (
  GtkSheet $sheet,
  guint $row,
  guint $nrows
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_entry_select_region (
  GtkSheet $sheet,
  gint $start_pos,
  gint $end_pos
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_entry_signal_connect_changed (
  GtkSheet $sheet,
  GCallback $handler
)
  returns gulong
  is native(extra)
  is export
  { * }

sub gtk_sheet_entry_signal_disconnect_by_func (
  GtkSheet $sheet,
  GCallback $handler
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_freeze (GtkSheet $sheet)
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_active_cell (GtkSheet $sheet, gint $row, gint $column)
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_attributes (
  GtkSheet $sheet,
  gint $row,
  gint $col,
  GtkSheetCellAttr $attributes
)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_cell_area (
  GtkSheet $sheet,
  gint $row,
  gint $column,
  GdkRectangle $area
)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_child_at (GtkSheet $sheet, gint $row, gint $col)
  returns GtkSheetChild
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_columns_count (GtkSheet $sheet)
  returns guint
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_description (GtkSheet $sheet, Str $description)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_entry (GtkSheet $sheet)
  returns GtkWidget
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_entry_type (GtkSheet $sheet)
  returns GType
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_entry_widget (GtkSheet $sheet)
  returns GtkWidget
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_link (GtkSheet $sheet, gint $row, gint $col)
  returns Pointer
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_pixel_info (
  GtkSheet $sheet,
  GdkWindow $window,
  gint $x,
  gint $y,
  gint $row,
  gint $column
)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_row_title (GtkSheet $sheet, gint $row)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_rows_count (GtkSheet $sheet)
  returns guint
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_selection (
  GtkSheet $sheet,
  GtkSheetState $state,
  GtkSheetRange $range
)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_visible_range (GtkSheet $sheet, GtkSheetRange $range)
  is native(extra)
  is export
  { * }

sub gtk_sheet_grid_visible (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_hide_row_titles (GtkSheet $sheet)
  is native(extra)
  is export
  { * }

sub gtk_sheet_in_clip (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_insert_columns (GtkSheet $sheet, guint $col, guint $ncols)
  is native(extra)
  is export
  { * }

sub gtk_sheet_insert_rows (GtkSheet $sheet, guint $row, guint $nrows)
  is native(extra)
  is export
  { * }

sub gtk_sheet_is_frozen (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_justify_entry (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_link_cell (
  GtkSheet $sheet,
  gint $row,
  gint $col,
  gpointer $link
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_locked (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_move_child (
  GtkSheet $sheet,
  GtkWidget $widget,
  gint $x,
  gint $y
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_moveto (
  GtkSheet $sheet,
  gint $row,
  gint $column,
  gint $row_align,
  gint $col_align
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_new (guint $rows, guint $columns, Str $title)
  returns GtkWidget
  is native(extra)
  is export
  { * }

sub gtk_sheet_new_browser (guint $rows, guint $columns, Str $title)
  returns GtkWidget
  is native(extra)
  is export
  { * }

sub gtk_sheet_new_with_custom_entry (
  guint $rows,
  guint $columns,
  Str $title,
  GType $entry_type
)
  returns GtkWidget
  is native(extra)
  is export
  { * }

sub gtk_sheet_put (GtkSheet $sheet, GtkWidget $child, gint $x, gint $y)
  returns GtkSheetChild
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_clear (GtkSheet $sheet, GtkSheetRange $range)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_delete (GtkSheet $sheet, GtkSheetRange $range)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_get_type ()
  returns GType
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_background (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  GdkRGBA $color
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_border (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  gint $mask,
  guint $width,
  cairo_line_cap_t $cap_style,
  cairo_line_join_t $join_style
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_border_color (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  GdkRGBA $color
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_css_class (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  Str $css_class
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_editable (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  gint $editable
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_font (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  PangoFontDescription $font_desc
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_foreground (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  GdkRGBA $color
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_justification (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  GtkJustification $just
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_range_set_visible (
  GtkSheet $sheet,
  GtkSheetRange $urange,
  gboolean $visible
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_remove_link (GtkSheet $sheet, gint $row, gint $col)
  is native(extra)
  is export
  { * }

sub gtk_sheet_row_button_add_label (GtkSheet $sheet, gint $row, Str $label)
  is native(extra)
  is export
  { * }

sub gtk_sheet_row_button_get_label (GtkSheet $sheet, gint $row)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_row_button_justify (
  GtkSheet $sheet,
  gint $row,
  uint32 $justification           # GtkJustification $justification
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_row_sensitive (GtkSheet $sheet, gint $row)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_row_titles_visible (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_row_visible (GtkSheet $sheet, gint $row)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_rows_labels_set_visibility (
  GtkSheet $sheet,
  gboolean $visible
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_rows_resizable (GtkSheet $sheet)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_rows_set_resizable (GtkSheet $sheet, gboolean $resizable)
  is native(extra)
  is export
  { * }

sub gtk_sheet_rows_set_sensitivity (GtkSheet $sheet, gboolean $sensitive)
  is native(extra)
  is export
  { * }

sub gtk_sheet_select_column (GtkSheet $sheet, gint $column)
  is native(extra)
  is export
  { * }

sub gtk_sheet_select_range (GtkSheet $sheet, GtkSheetRange $range)
  is native(extra)
  is export
  { * }

sub gtk_sheet_select_row (GtkSheet $sheet, gint $row)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_active_cell (GtkSheet $sheet, gint $row, gint $column)
  returns uint32
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_autoresize (GtkSheet $sheet, gboolean $autoresize)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_autoresize_columns (GtkSheet $sheet, gboolean $autoresize)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_autoresize_rows (GtkSheet $sheet, gboolean $autoresize)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_autoscroll (GtkSheet $sheet, gboolean $autoscroll)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_cell (
  GtkSheet $sheet,
  gint $row,
  gint $col,
  uint32 $justification,          # GtkJustification $justification,
  Str $text
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_cell_text (
  GtkSheet $sheet,
  gint $row,
  gint $col,
  Str $text
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_clip_text (GtkSheet $sheet, gboolean $clip_text)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_description (GtkSheet $sheet, Str $description)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_entry_editable (GtkSheet $sheet, gboolean $editable)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_grid (GtkSheet $sheet, GdkRGBA $color)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_justify_entry (GtkSheet $sheet, gboolean $justify)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_locked (GtkSheet $sheet, gboolean $locked)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_row_height (GtkSheet $sheet, gint $row, guint $height)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_row_title (GtkSheet $sheet, gint $row, Str $title)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_row_titles_width (GtkSheet $sheet, guint $width)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_selection_mode (
  GtkSheet $sheet,
  uint32 $mode                    # GtkSelectionMode $mode
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_tab_direction (
  GtkSheet $sheet,
  uint32 $dir                     # GtkDirectionType $dir
)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_title (GtkSheet $sheet, Str $title)
  is native(extra)
  is export
  { * }

sub gtk_sheet_show_grid (GtkSheet $sheet, gboolean $show)
  is native(extra)
  is export
  { * }

sub gtk_sheet_show_row_titles (GtkSheet $sheet)
  is native(extra)
  is export
  { * }

sub gtk_sheet_thaw (GtkSheet $sheet)
  is native(extra)
  is export
  { * }

sub gtk_sheet_unclip_range (GtkSheet $sheet)
  is native(extra)
  is export
  { * }

sub gtk_sheet_unselect_range (GtkSheet $sheet)
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_entry_text (GtkSheet $sheet)
  returns Str
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_hadjustment (GtkSheet $sheet)
  returns GtkAdjustment
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_vadjustment (GtkSheet $sheet)
  returns GtkAdjustment
  is native(extra)
  is export
  { * }

sub gtk_sheet_get_vjustification (GtkSheet $sheet)
  returns uint32 # GtkSheetVerticalJustification
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_entry_text (GtkSheet $sheet, Str $text)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_hadjustment (GtkSheet $sheet, GtkAdjustment $adjustment)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_vadjustment (GtkSheet $sheet, GtkAdjustment $adjustment)
  is native(extra)
  is export
  { * }

sub gtk_sheet_set_vjustification (
  GtkSheet $sheet,
  uint32 $vjust                   # GtkSheetVerticalJustification $vjust
)
  is native(extra)
  is export
  { * }
