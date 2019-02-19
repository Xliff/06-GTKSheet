use v6.c;

use GTKSheet::Raw::Types;
use GTKSheet::Raw::DataTevtView;

use GTK::TextView;

our subset DataTextViewAncestry
  where GtkDataTextView | TextViewAncesty;

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
          when DataTextView {
            $to-parent = nativecast(GtkTextView);
            $!dtv = $textview;
          }
          default {
            $to-parent = $_;
            nativecast(GtkDataTextView, $_);
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
    self.bless( textview => gtk_data_text_view_new() );
  }

  method description is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_text_view_get_description($!dtv);
      },
      STORE => sub ($, $description is copy) {
        gtk_data_text_view_set_description($!dtv, $description);
      }
    );
  }

  method max_length is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_text_view_get_max_length($!dtv);
      },
      STORE => sub ($, $max_length is copy) {
        gtk_data_text_view_set_max_length($!dtv, $max_length);
      }
    );
  }

  method max_length_bytes is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_data_text_view_get_max_length_bytes($!dtv);
      },
      STORE => sub ($, $max_length_bytes is copy) {
        gtk_data_text_view_set_max_length_bytes($!dtv, $max_length_bytes);
      }
    );
  }

  method get_type {
    gtk_data_text_view_get_type();
  }

}
