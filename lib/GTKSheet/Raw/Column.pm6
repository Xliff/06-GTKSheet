use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTKSheet::Raw::Types;

unit package GTKSheet::Raw::Column;

sub gtk_sheet_column_button_add_label (
  GtkSheet $sheet,
  gint $col,
  Str $label
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_button_get_label (GtkSheet $sheet, gint $col)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_button_justify (
  GtkSheet $sheet,
  gint $col,
  uint32 $justification           # GtkJustification $justification
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get (GtkSheet $sheet, gint $col)
  returns GtkSheetColumn
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_datatype (GtkSheet $sheet, gint $col)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_description (GtkSheet $sheet, gint $col)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_entry_type (GtkSheet $sheet, gint $col)
  returns GType
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_format (GtkSheet $sheet, gint $col)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_index (GtkSheetColumn $colobj)
  returns gint
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_iskey (GtkSheet $sheet, gint $col)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_justification (GtkSheet $sheet, gint $col)
  returns uint32 # GtkJustification
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_readonly (GtkSheet $sheet, gint $col)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_tooltip_markup (GtkSheet $sheet, gint $col)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_tooltip_text (GtkSheet $sheet, gint $col)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_type ()
  returns GType
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_get_vjustification (GtkSheet $sheet, gint $col)
  returns uint32 # GtkSheetVerticalJustification
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_sensitive (GtkSheet $sheet, gint $column)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_datatype (
  GtkSheet $sheet,
  gint $col,
  Str $data_type
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_description (
  GtkSheet $sheet,
  gint $col,
  Str $description
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_entry_type (
  GtkSheet $sheet,
  gint $col,
  GType $entry_type
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_format (GtkSheet $sheet, gint $col, Str $format)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_iskey (
  GtkSheet $sheet,
  gint $col,
  gboolean $is_key
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_justification (
  GtkSheet $sheet,
  gint $col,
  uint32 $just                    # GtkJustification $just
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_readonly (
  GtkSheet $sheet,
  gint $col,
  gboolean $is_readonly
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_tooltip_markup (
  GtkSheet $sheet,
  gint $col,
  Str $markup
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_tooltip_text (
  GtkSheet $sheet,
  gint $col,
  Str $text
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_set_vjustification (
  GtkSheet $sheet,
  gint $col,
  uint32 $vjust                   # GtkSheetVerticalJustification $vjust
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_titles_visible (GtkSheet $sheet)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_sheet_column_visible (GtkSheet $sheet, gint $column)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_sheet_columns_labels_set_visibility (
  GtkSheet $sheet,
  gboolean $visible
)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_columns_resizable (GtkSheet $sheet)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_sheet_columns_set_resizable (GtkSheet $sheet, gboolean $resizable)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_columns_set_sensitivity (GtkSheet $sheet, gboolean $sensitive)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_get_column_title (GtkSheet $sheet, gint $column)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_sheet_get_column_width (GtkSheet $sheet, gint $column)
  returns gint
  is native(sheet)
  is export
  { * }

sub gtk_sheet_hide_column_titles (GtkSheet $sheet)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_set_column_title (GtkSheet $sheet, gint $column, Str $title)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_set_column_titles_height (GtkSheet $sheet, guint $height)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_set_column_width (GtkSheet $sheet, gint $column, guint $width)
  is native(sheet)
  is export
  { * }

sub gtk_sheet_show_column_titles (GtkSheet $sheet)
  is native(sheet)
  is export
  { * }
