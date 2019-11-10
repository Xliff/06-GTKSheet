use v6.c;

use NativeCall;

use Pango::Raw::Types;
use GTK::Compat::RGBA;
use GTK::Compat::Types;
use GTK::Raw::Types;

use GTK::Roles::Pointers;

unit package GTKSheet::Raw::Types;

# Forced compile count
constant forced = 2;

constant sheet is export = 'gtksheet-4.0',v1;

class GtkDataEntry     is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkDataTextView  is repr("CPointer") is export does GTK::Roles::Pointers { }
class GtkSheetColumn   is repr("CPointer") is export does GTK::Roles::Pointers { }

class GtkSheetChild is repr('CStruct') is export {
  has GtkWidget $.widget;
  has gint      $.x;
  has gint      $.y;
  has gboolean  $.attached_to_cell;
  has gboolean  $.floating;
  has gint      $.row;
  has gint      $.col;
  has guint16   $.xpadding;
  has guint16   $.ypadding;
  has gboolean  $.xexpand;
  has gboolean  $.yexpand;
  has gboolean  $.xshrink;
  has gboolean  $.yshrink;
  has gboolean  $.xfill;
  has gboolean  $.yfill;
};

class GtkSheetButton is repr('CStruct') is export {
  has uint32           $.state;         # GtkStateFlags state;
  has Str              $.label;
  has gboolean         $.label_visible;
  has GtkSheetChild    $.child;
  has uint32           $.justification; # GtkJustification $.justification;
}

class GtkSheetCellBorder is repr('CStruct') is export  {
  has guint   $.width;      # -> cairo_set_line_width()
  has gint8   $.mask;       # GtkSheetBorderBits mask

  has uint32  $.cap_stype;  # cairo_line_cap_t cap_style;   -> cairo_set_line_cap()
  has uint32  $.join_style; # cairo_line_join_t join_style; -> cairo_set_line_join()

  HAS GdkRGBA $.color;
}

class GtkSheetCellAttr is repr('CStruct') is export {
  has uint32               $.justification;             # GtkJustification justification;
  has PangoFontDescription $.font_desc;
  has gboolean             $.deprecated_font_desc_used; # flag for detection
  has gboolean             $.do_font_desc_free;         # TRUE if font_desc needs free

  HAS GdkRGBA              $.foreground;                # deprecated
  has gboolean             $.deprecated_fg_color_used;  # flag for detection
  HAS GdkRGBA              $.background;                # deprecated
  has gboolean             $.deprecated_bg_color_used;  # flag for detection

  HAS GtkSheetCellBorder   $.border;
  has gboolean             $.is_editable;
  has gboolean             $.is_visible;
  has Str                  $.css_class;
}

class GtkSheetRange is repr('CStruct') is export {
  has gint $.row0 is rw;
  has gint $.col0 is rw;
  has gint $.row1 is rw;
  has gint $.col1 is rw;

  submethod BUILD (:$!row0, :$!col0, :$!row1, :$!col1) {}

  method new($row0, $col0, $row1, $col1) {
    self.bless(:$row0, :$col0, :$row1, :$col1);
  }
}

class GtkSheetCell is repr('CStruct') is export {
  HAS GdkRectangle     $.extent;  # extent of pango layout + cell attributes.
                                  # border (used for column auto-resize)
  has gint             $.row;
  has gint             $.col;
  has GtkSheetCellAttr $.attributes;
  has Str              $.text;
  has gpointer         $.link;
  has Str              $.tooltip_markup; # tooltip, which is marked up with
                                         # the Pango text markup language
  has Str              $.tooltip_text;   # tooltip, without markup
}

class GtkSheetRow is repr('CStruct') is export {
  has Str            $.name;
  has gint           $.height;
  has guint16        $.requisition;
  has gint           $.top_ypixel;
  has gint           $.max_extent_height;  # := max(Cell.extent.height)
  HAS GtkSheetButton $.button;
  has gboolean       $.is_sensitive;
  has gboolean       $.is_visible;
  has Str            $.tooltip_markup;     # tooltip, which is marked up with the Pango text markup language
  has Str            $.tooltip_text;       # tooltip, without markup
};

class GtkSheet is repr('CStruct') is export  {
  has GtkContainer     $.container;
  has guint16          $.flags;
  has uint32           $.selection_mode;
  has uint32           $.autoresize_columns;
  has uint32           $.autoresize_rows;
  has uint32           $.autoscroll;
  has uint32           $.clip_text;
  has uint32           $.justify_entry;
  has uint32           $.locked;
  has uint32           $.freeze_count;
  has GdkRGBA          $.bg_color;                  # cell background color
  has uint32           $.deprecated_bg_color_used;  # flag for detection
  has GdkRGBA          $.grid_color;                # grid color
  has GdkRGBA          $.tm_color;                  # tooltip marker color
  has Str              $.css_class;
  has uint32           $.show_grid;
  has GList            $.children;                  # sheet children

  # innter allocation rectangle
  #   without widget container border_width and shadow border width
  HAS GdkRectangle     $.internal_allocation;

  has Str              $.title;
  has Str              $.description;            # sheet description and
                                                 # further information for
                                                 # application use

  has GtkSheetRow       $.row;

  # flexible array of column pointers
  has CArray[Pointer[GtkSheetColumn]]  $.column;

  has guint32          $.rows_resizable;
  has guint32          $.columns_resizable;

  # max number of diplayed cells
  has gint             $.maxrow;
  has gint             $.maxcol;

  # Displayed range
  HAS GtkSheetRange    $.view;

  # sheet data: dynamically allocated array of cell pointers
  has CArray[Pointer[Pointer[GtkSheetCell]]] $.data;

  # max number of allocated cells in **data
  has gint             $.maxallocrow;
  has gint             $.maxalloccol;

  # active cell
  HAS GtkSheetCell     $.active_cell;
  has GtkWidget        $.sheet_entry;

  has GType            $.entry_type;             # wanted entry type
  has GType            $.installed_entry_type;   # installed entry type

  HAS GtkSheetCell     $.selection_pin;          # pin for extend_selection
  HAS GtkSheetCell     $.selection_cursor;       # cursor for extend_selection

  # timer for automatic scroll during selection
  has gint32           $.timer;
  # timer for flashing clipped range
  has gint32           $.clip_timer;
  has gint             $.interval;

  # global selection button
  has GtkWidget        $.button;

  # sheet state
  has uint32           $.state;

  # selected range
  HAS GtkSheetRange    $.range;

  # the sheet window the cells, the sheet entry and
  #  the global sheet button. It is a sub-window of the sheet
  #  widget's main window.
  has GdkWindow        $.sheet_window;
  has guint            $.sheet_window_width;
  has guint            $.sheet_window_height;

  has cairo_surface_t  $.bsurf;      # sheet backing surface
  has guint            $.bsurf_width;
  has guint            $.bsurf_height;
  has cairo_t          $.bsurf_cr;

  # offsets for scrolling
  has gint             $.hoffset;
  has gint             $.voffset;
  has gfloat           $.old_hadjustment;
  has gfloat           $.old_vadjustment;

  # border shadow style
  has uint32           $.shadow_type; # GtkShadowType shadow_type;

  has uint32           $.vjust;       # GtkSheetVerticalJustification vjust;
                                      # default vertical text justification

  # Column Titles
  HAS GdkRectangle     $.column_title_area;
  # the column_title_window contains the column titles.
  # It is a sub-window of the sheet widget's main window.
  has GdkWindow        $.column_title_window;
  has uint32           $.column_titles_visible;

  # Row Titles
  HAS GdkRectangle     $.row_title_area;
  # the row_title_window contains the row titles.
  # It is a sub-window of the sheet widget's main window.  */
  has GdkWindow        $.row_title_window;
  has uint32           $.row_titles_visible;

  # scrollbars
  has GtkAdjustment    $.hadjustment;
  has GtkAdjustment    $.vadjustment;

  # GtkScrollablePolicy needs to be checked when
  #driving the scrollable adjustment values
  has guint            $.hscroll_policy;  # : 1;
  has guint            $.vscroll_policy;  # : 1;

  # cursor used to indicate dragging
  has GdkCursor        $.cursor_drag;

  # the current x-pixel location of the xor-drag vline
  has gint             $.x_drag;

  # the current y-pixel location of the xor-drag hline
  has gint             $.y_drag;

  # current cell being dragged
  HAS GtkSheetCell     $.drag_cell;
  # current range being dragged
  HAS GtkSheetRange    $.drag_range;

  # clipped range
  HAS GtkSheetRange    $.clip_range;
};

class GtkItemEntry is repr('CStruct') is export  {
  # PRIVATE!
  # GtkEntry parent;  -- 40 bytes with current GTK .. DO NOT depend on anything
  # in this section.
  has uint64 $.dummy1;
  has uint64 $.dummy2;
  has uint64 $.dummy3;
  has uint64 $.dummy4;
  has uint64 $.dummy5;
  has gint   $.text_max_size;    # upper limit for geometric size allocation or 0
  has gint16 $.item_text_size;   # length of allocated entry->text memory buffer block
  has gint16 $.item_n_bytes;     # string length of entry->text, used part of memory buffer

  # pseudo-properties - These may be safe for access.
  has gint   $.max_length_bytes;  # maximum length in bytes
  has uint32 $.justification;     # GtkJustification justification;  -- justification of the entry
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