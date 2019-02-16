use v6.c;

use GTK::Compat::Types;
use GTKSheet::Raw::Types;

unit package GTKSheet::Raw::DataTextView;

sub gtk_data_text_view_get_type ()
  returns GType
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_new ()
  returns GtkDataTextView
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_get_description (GtkDataTextView $data_text_view)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_get_max_length (GtkDataTextView $data_text_view)
  returns gint
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_get_max_length_bytes (
  GtkDataTextView $data_text_view
)
  returns gint
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_set_description (
  GtkDataTextView $data_text_view,
  Str $description
)
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_set_max_length (
  GtkDataTextView $data_text_view,
  gint $max_length
)
  is native(sheet)
  is export
  { * }

sub gtk_data_text_view_set_max_length_bytes (
  GtkDataTextView $data_text_view,
  gint $max_length_bytes
)
  is native(sheet)
  is export
  { * }
