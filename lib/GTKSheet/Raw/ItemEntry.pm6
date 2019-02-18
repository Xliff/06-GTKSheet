use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTKSheet::Raw::Types;

unit package GTKSheet::Raw::ItemEntry;

sub gtk_item_entry_get_type ()
  returns GType
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_new ()
  returns GtkWidget
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_new_with_max_length (gint $max)
  returns GtkWidget
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_set_justification (
  GtkItemEntry $entry,
  uint32 $just                    # GtkJustification $just
)
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_set_text (
  GtkItemEntry $entry,
  Str $text,
  uint32 $just                    # GtkJustification $just
)
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_get_cursor_visible (GtkItemEntry $entry)
  returns uint32
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_get_max_length_bytes (GtkItemEntry $item_entry)
  returns gint
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_set_cursor_visible (
  GtkItemEntry $entry,
  gboolean $visible
)
  is native(sheet)
  is export
  { * }

sub gtk_item_entry_set_max_length_bytes (
  GtkItemEntry $item_entry,
  gint $max_length_bytes
)
  is native(sheet)
  is export
  { * }
