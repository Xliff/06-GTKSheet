use v6.c;

use GTK::Compat::Types;
use GTKSheet::Raw::Types;

unit package GTKSheet::Raw::DataEntry;

sub gtk_data_entry_get_type ()
  returns GType
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_new ()
  returns GtkDataEntry
  # is native(sheet)
  is export
  { * }

sub gtk_data_entry_get_data_format (GtkDataEntry $data_entry)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_get_data_type (GtkDataEntry $data_entry)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_get_description (GtkDataEntry $data_entry)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_get_max_length_bytes (GtkDataEntry $data_entry)
  returns gint
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_get_text (GtkDataEntry $data_entry)
  returns Str
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_set_data_format (
  GtkDataEntry $data_entry,
  Str $data_format
)
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_set_data_type (GtkDataEntry $data_entry, Str $data_type)
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_set_description (
  GtkDataEntry $data_entry,
  Str $description
)
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_set_max_length_bytes (
  GtkDataEntry $data_entry,
  gint $max_length_bytes
)
  is native(sheet)
  is export
  { * }

sub gtk_data_entry_set_text (GtkDataEntry $data_entry, Str $text)
  is native(sheet)
  is export
  { * }
