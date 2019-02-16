use v6.c;

use GTK::Compat::Types;

use GTK::Roles::Pointers;

unit package GTKSheet::Raw::Types;

constant sheet is export = 'gtksheet-4.0',v1;

class GtkSheet         is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkSheetCellAttr is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkSheetChild    is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkDataEntry     is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkDataTextView  is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkSheetColumn   is repr("CPointer") is export does GTK::Roles::Pointers { }

class GtkSheetRange is repr('CStruct') is export {
    has gint $.row0 is rw;
    has gint $.col0 is rw;
    has gint $.row1 is rw;
    has gint $.col1 is rw;
}

our enum GtkSheetState is export <
  GTK_SHEET_NORMAL
  GTK_SHEET_ROW_SELECTED
  GTK_SHEET_COLUMN_SELECTED
  GTK_SHEET_RANGE_SELECTED
>;

our enum GtkSheetBorderBits is export (
  GTK_SHEET_LEFT_BORDER     => 1,
  GTK_SHEET_RIGHT_BORDER    => 1 +< 1,
  GTK_SHEET_TOP_BORDER      => 1 +< 2,
  GTK_SHEET_BOTTOM_BORDER   => 1 +< 3,
);

our enum GtkSheetEntryType is export <
  GTK_SHEET_ENTRY_TYPE_DEFAULT
  GTK_SHEET_ENTRY_TYPE_GTK_ENTRY
  GTK_SHEET_ENTRY_TYPE_GTK_TEXT_VIEW
  GTK_SHEET_ENTRY_TYPE_GTK_DATA_ENTRY
  GTK_SHEET_ENTRY_TYPE_GTK_DATA_TEXT_VIEW
  GTK_SHEET_ENTRY_TYPE_GTK_SPIN_BUTTON
  GTK_SHEET_ENTRY_TYPE_GTK_COMBO_BOX
  GTK_SHEET_ENTRY_TYPE_GTK_COMBO_BOX_ENTRY
  GTK_SHEET_ENTRY_TYPE_GTK_COMBO
>;

our enum GtkSheetVerticalJustification is export <
  GTK_SHEET_VERTICAL_JUSTIFICATION_DEFAULT
  GTK_SHEET_VERTICAL_JUSTIFICATION_TOP
  GTK_SHEET_VERTICAL_JUSTIFICATION_MIDDLE
  GTK_SHEET_VERTICAL_JUSTIFICATION_BOTTOM
>;
