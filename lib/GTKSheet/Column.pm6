use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTK::Raw::Utils;
use GTKSheet::Raw::Types;
use GTKSheet::Raw::Sheet;
use GTKSheet::Raw::Column;

# Wrapper required to set property on $!col.
use GTK::Roles::Properties;

class GTKSheet::Column {
  has GtkSheetColumn $!c;
  has guint $!col;
  has GtkSheet $!sheet;

  also does GTK::Roles::Properties;

  submethod BUILD (:$column, :$sheet, :$col) {
    $!prop = nativecast(GObject, $!c = $column);
    $!sheet = $sheet;
    $!col = $col;
  }

  method GTKSheet::Raw::Types::GtkSheetColumn is also<column> { $!c }

  multi method new (GtkSheetColumn $column, GtkSheet $sheet, Int $num) {
    my $col = self.RESOLVE-INT($num);
    self.bless(:$column, :$sheet, :$col);
  }

  method datatype is rw {
    Proxy.new: {
      FETCH => -> $            { self.get_datatype     },
      STORE => -> $, Str() $d  { self.set_datatype($d) }
    }
  }

  method description is rw {
    Proxy.new: {
      FETCH => -> $            { self.get_description     },
      STORE => -> $, Str() $d  { self.set_description($d) }
    }
  }

  method entry_type is rw {
    Proxy.new:
      FETCH => -> $            { self.get_entry_type      },
      STORE => -> $, Int() $et { self.set_entry_type($et) };
  }

  method format is rw {
    Proxy.new:
      FETCH => -> $            { self.get_format     },
      STORE => -> $, Int() $f  { self.set_format($f) };
  }

  method iskey is rw {
    Proxy.new:
      FETCH => -> $            { self.get_iskey      },
      STORE => -> $, Int() $ik { self.set_iskey($ik) };
  }

  method justification is rw {
    Proxy.new:
      FETCH => -> $            { self.get_justification     },
      STORE => -> $, Int() $j  { self.set_justification($j) };
  }

  method readonly is rw {
    Proxy.new:
      FETCH => -> $            { self.get_readonly      },
      STORE => -> $, Int() $ro { self.set_readonly($ro) };
  }

  method title is rw {
    Proxy.new:
      FETCH => -> $            { self.get_title   },
      STORE => -> $, Str() $t  { self.set_title($t) };
  }

  method tooltip_markup is rw {
    Proxy.new:
      FETCH => -> $            { self.get_tooltip_markup      },
      STORE => -> $, Str() $tt { self.set_tooltip_markup($tt) };
  }

  method tooltip_text is rw {
    Proxy.new:
      FETCH => -> $            { self.get_tooltip_text      },
      STORE => -> $, Str() $tt { self.set_tooltip_text($tt) };
  }

  method vjustification is rw {
    FETCH => -> $,             { self.get_vjustification     },
    STORE => -> $, Int() $v    { self.set_vjustification($v) };
  }

  method width is rw {
    Proxy.new:
      FETCH =>  -> $           { self.get_column_width     },
      STORE =>  -> $, Int() $w { self.set_column_width($w) };
  }

  # So these are scraped and adjusted from GtkSheet and are here for
  # convenience. If there are problems with these routines, then use
  # the GTKSheet.column_... equivalent.
  method get_column_width {
    gtk_sheet_get_column_width($!sheet, $!c);
  }

  method get_datatype {
    gtk_sheet_column_get_datatype($!sheet, $!c);
  }

  method get_description {
    gtk_sheet_column_get_description($!sheet, $!c);
  }

  method get_entry_type {
    gtk_sheet_column_get_entry_type($!sheet, $!c);
  }

  method get_format {
    gtk_sheet_column_get_format($!sheet, $!c);
  }

  method get_index is also<index> {
    gtk_sheet_column_get_index($!c);
  }

  method get_iskey {
    so gtk_sheet_column_get_iskey($!sheet, $!c);
  }

  method get_justification {
    GtkJustification( gtk_sheet_column_get_justification($!sheet, $!c) );
  }

  method get_readonly {
    gtk_sheet_column_get_readonly($!sheet, $!c);
  }

  method get_tooltip_markup {
    gtk_sheet_column_get_tooltip_markup($!sheet, $!c);
  }

  method get_tooltip_text {
    gtk_sheet_column_get_tooltip_text($!sheet, $!c);
  }

  method get_type {
    self.unstable_get_type( gtk_sheet_column_get_type() );
  }

  method get_vjustification {
    GtkSheetVerticalJustification(
      gtk_sheet_column_get_vjustification($!sheet, $!c)
    );
  }

  method get_title {
    gtk_sheet_get_column_title($!sheet, $!c);
  }

  method sensitive {
    gtk_sheet_column_sensitive($!sheet, $!c);
  }

  method set_column_width (Int() $width) {
    my gint $w = resolve-int($width);
    gtk_sheet_set_column_width($!sheet, $!c, $w);
  }

  method set_description (Str() $description) {
    gtk_sheet_column_set_description($!sheet, $!c, $description);
  }

  method set_datatype (Str() $data_type) {
    gtk_sheet_column_set_datatype($!sheet, $!c, $data_type);
  }

  method set_entry_type (Int() $entry_type) {
    my uint64 $et = resolve-ulong($entry_type);
    gtk_sheet_column_set_entry_type($!sheet, $!c, $entry_type);
  }

  method set_format (Str() $format) {
    gtk_sheet_column_set_format($!sheet, $!c, $format);
  }

  method set_iskey (Int() $is_key) {
    my gboolean $ik = resolve-bool($is_key);
    gtk_sheet_column_set_iskey($!sheet, $!c, $ik);
  }

  method set_justification (Int() $just) {
    my guint $j = resolve-uint($just);
    gtk_sheet_column_set_justification($!sheet, $!c, $j);
  }

  method set_readonly (Int() $is_readonly) {
    my gboolean $ir = resolve-bool($is_readonly);
    gtk_sheet_column_set_readonly($!sheet, $!c, $ir);
  }

  method set_title (Str() $title) {
    gtk_sheet_set_column_title($!sheet, $!c, $title);
  }

  method set_tooltip_markup (Str() $markup) {
    gtk_sheet_column_set_tooltip_markup($!sheet, $!c, $markup);
  }

  method set_tooltip_text (Str() $text) {
    gtk_sheet_column_set_tooltip_text($!sheet, $!c, $text);
  }

  method set_vjustification (Int() $vjust) {
    my guint $vj = resolve-uint($vjust);
    gtk_sheet_column_set_vjustification($!sheet, $!c, $vj);
  }

  method visible {
    gtk_sheet_column_visible($!sheet, $!c);
  }
}
