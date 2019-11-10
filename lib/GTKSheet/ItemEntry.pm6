use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;

use GTKSheet::Raw::ItemEntry;

use GTK::Entry;

our subset ItemEntryAncestry where GtkItemEntry | EntryAncestry;

class GTKSheet::ItemEntry is GTK::Entry {
  has GtkItemEntry $!ie;
  has gint $!j;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTKSheet::ItemEntry');
    $o;
  }

  submethod BUILD (:$entry) {
    given $entry {
      when ItemEntryAncestry {
        my $to-parent;
        $!ie = do {
          when GtkItemEntry {
            $to-parent = cast(GtkEntry, $_);
            $_;
          }

          when EntryAncestry {
            $to-parent = $_;
            cast(GtkItemEntry, $_);
          }

        }
        self.setEntry($to-parent);
      }

      when GTKSheet::ItemEntry {
      }

      default {
      }
    }
  }

  method new {
    my $e = gtk_item_entry_new();
    $e ?? self.bless( entry => $e ) !! Nil;
  }

  method new_with_max_length(Int() $max) {
    my gint $m = $max;
    my $e = gtk_item_entry_new_with_max_length($m);

    $e ?? self.bless( entry => $e ) !! Nil;
  }

  method cursor_visible is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_item_entry_get_cursor_visible($!ie);
      },
      STORE => sub ($, Int() $visible is copy) {
        my gboolean $v = $visible;

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
        my gint $mlb = $max_length_bytes;

        gtk_item_entry_set_max_length_bytes($!ie, $mlb);
      }
    );
  }

  method justification is rw {
    Proxy.new(
      FETCH => sub ($) {
        GtkJustification( $!j );
      },
      STORE => sub ($, Int() $justification is copy) {
        $!j = (my uint32 $j = $justification);

        self.set_justification($j);
      }
    );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gtk_item_entry_get_type, $n, $t );
  }

  method set_justification (Int() $just) {
    my uint32 $j = $just;

    gtk_item_entry_set_justification($!ie, $j);
  }

  method set_text (Str() $text, Int() $just) {
    my uint32 $j = $just;

    gtk_item_entry_set_text($!ie, $text, $just);
  }

}
