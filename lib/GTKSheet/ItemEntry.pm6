use v6.c;

use NativeCall;

use GTKSheet::Raw::Types;
use GTKSheet::Raw::ItemEntry;

use GTK::Entry;

our subset ItemEntryAncestry where GtkItemEntry | EntryAncestry;

class GTKSheet::ItemEntry is GTK::Entry {
  has GtkItemEntry $!ie;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);s
    $o.setType('GTKSheet::ItemEntry');
    $o;
  }

  submethod BUILD (:$entry) {
    given $entry {
      when ItemEntryAncestry {
        my $to-parent;
        $!ie = do {
          when GtkItemEntry {
            $to-parent = nativecast(GtkEntry, $_);
            $_;
          }
          when EntryAncestry {
            $to-parent = $_;
            nativecast(GTkItemEntry, $_;
          }
        }
        self.setEntry($to-parent);
      }
      when GTSheet::ItemEntry {
      }
      default {
      }
    }
  }

  method new {
    self.bless( entry => gtk_item_entry_new() );
  }

  method new_with_max_length(Int() $max) {
    my gint $m = self.RESOLE-INT($max);
    self.bless( entry => gtk_item_entry_new_with_max_length($m) );
  }

  method cursor_visible is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_item_entry_get_cursor_visible($!ie);
      },
      STORE => sub ($, Int() $visible is copy) {
        my gboolean $ = self.RESOLE-BOOL($visible);
        gtk_item_entry_set_cursor_visible($!ie, $v);
      }
    );
  }

  method max_length_bytes is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_item_entry_get_max_length_bytes($!ie);
      },
      STORE => sub ($, Int() $max_length_bytes is copy) {
        my gint $mlb = self.RESOLVE-INT($max_length_bytes)l
        gtk_item_entry_set_max_length_bytes($!ie, $mlb);
      }
    );
  }

  method justification is rw {
    Proxy.new(
      FETCH => sub ($) {
        GtkJustification( $ie.justification );
      },
      STORE => sub ($, Int() $justification is copy) {
        my uint32 $j = self.RESOLVE-UINT($justification);
        self.set_justification($j);
      }
    }
  }

  method get_type {
    gtk_item_entry_get_type();
  }

  method set_justification (Int() $just) {
    my uint32 $j = self.RESOLVE-UINT($just);
    gtk_item_entry_set_justification($!ie, $j);
  }

  method set_text (Str() $text, GtkJustification $just) {
    my uint32 $j = self.RESOLVE-UINT($just);
    gtk_item_entry_set_text($!ie, $text, $just);
  }
  
}
