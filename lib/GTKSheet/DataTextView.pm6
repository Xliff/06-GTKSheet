use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;
use GTKSheet::Raw::DataTextView;

use GTK::TextView;

our subset DataTextViewAncestry is export of Mu
  where GtkDataTextView | TextViewAncestry;

class GTKSheet::DataTextView is GTK::TextView {
  has GtkDataTextView $!dtv;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTKSheet::DataTextView');
    $o;
  }

  submethod BUILD (:$textview) {
    given ($textview) {
      when DataTextViewAncestry {
        my $to-parent;

        $!dtv = do {
          when GtkDataTextView {
            $to-parent = cast(GtkTextView, $_);
            $!dtv = $textview;
          }

          default {
            $to-parent = $_;
            cast(GtkDataTextView, $_);
          }
        }
        self.setTextView($to-parent);
      }

      when GTKSheet::DataTextView {
      }

      default {
      }

    }
  }

  method new {
    my $dtv = gtk_data_text_view_new();

    $dtv ?? self.bless( textview => $dtv) !! Nil;
  }

  method description is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_text_view_get_description($!dtv);
      },
      STORE => sub ($, Str() $description is copy) {
        gtk_data_text_view_set_description($!dtv, $description);
      }
    );
  }

  method max_length is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_text_view_get_max_length($!dtv);
      },
      STORE => sub ($, Int() $max_length is copy) {
        my gint $m = $max_length;

        gtk_data_text_view_set_max_length($!dtv, $m);
      }
    );
  }

  method max_length_bytes is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_text_view_get_max_length_bytes($!dtv);
      },
      STORE => sub ($, Int() $max_length_bytes is copy) {
        my gint $m = $max_length_bytes;

        gtk_data_text_view_set_max_length_bytes($!dtv, $m);
      }
    );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gtk_data_text_view_get_type, $n, $t );
  }

}
