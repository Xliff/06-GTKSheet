use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;
use GTKSheet::Raw::DataEntry;

use GTK::Entry;

our subset DataEntryAncestry is export where GtkDataEntry | EntryAncestry;

class GTKSheet::DataEntry is GTK::Entry {
  has GtkDataEntry $!de;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTKSheet::DataEntry');
    $o;
  }

  submethod BUILD (:$entry) {
    given $entry {
      when DataEntryAncestry {
        my $to-parent;
        $!de = do {
          when GtkDataTextView {
            $to-parent = nativecast(GtkEntry, $_);
            $entry;
          }
          when EntryAncestry {
            $to-parent = $_;
            nativecast(GtkDataEntry, $_);
          }
        }
        self.setEntry($to-parent);
      }
      when GTK::Entry {
      }
      default {
      }
    }
  }
  
  multi method new (DataEntryAncestry $entry) {
    my $o = self.bless(:$entry);
    $o.upref;
  }
  multi method new {
    self.bless( entry => gtk_data_entry_new() );
  }

  method get_type {
    state ($n, $t);
    GTK::Widget.unstable_get_type( &gtk_data_entry_get_type, $n, $t );
  }

  method data_format is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_entry_get_data_format($!de);
      },
      STORE => sub ($, Str() $data_format is copy) {
        gtk_data_entry_set_data_format($!de, $data_format);
      }
    );
  }

  method data_type is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_entry_get_data_type($!de);
      },
      STORE => sub ($, Str() $data_type is copy) {
        gtk_data_entry_set_data_type($!de, $data_type);
      }
    );
  }

  method description is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_entry_get_description($!de);
      },
      STORE => sub ($, Str() $description is copy) {
        gtk_data_entry_set_description($!de, $description);
      }
    );
  }

  method max_length_bytes is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_entry_get_max_length_bytes($!de);
      },
      STORE => sub ($, $max_length_bytes is copy) {
        my gint $mlb = self.RESOLVE-INT($max_length_bytes);
        gtk_data_entry_set_max_length_bytes($!de, $mlb);
      }
    );
  }

  method text is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_entry_get_text($!de);
      },
      STORE => sub ($, Str() $text is copy) {
        gtk_data_entry_set_text($!de, $text);
      }
    );
  }

  # Note: GTKSheet::DataEntry provides it's own INTERNAL signal handler
  # for GTK::Entry.insert-text. If instability problems occur due to
  # user-code using GTK::DataEntry.insert-text, then it should be stubbed out!


}
