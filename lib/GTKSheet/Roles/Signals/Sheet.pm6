use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::ReturnedValue;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;

use GTK::Roles::Signals::Generic;

role GTKSheet::Roles::Signals::Sheet {
  also does GTK::Roles::Signals::Generic;

  has %!signals-es;

  # GtkSheet, gint, gint, gpointer --> gboolean
  method connect-activate (
    $obj,
    $signal = 'activate',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-activate($obj, $signal,
        -> $, $i1, $i2, $ud --> gboolean {
          CATCH {
            default { note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $i1, $i2, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, gint, gint, gpointer
  method connect-intint (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-intint($obj, $signal,
        -> $, $i1, $i2, $ud {
          CATCH {
            default { note($_) }
          }

          $s.emit( [self, $i1, $i2, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, GtkSheetRange, gpointer
  method connect-clip-range (
    $obj,
    $signal = 'clip-range',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-clip-range($obj, $signal,
        -> $, $gsre, $ud {
          CATCH {
            default { note($_) }
          }

          $s.emit( [self, $gsre, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, GdkEvent, gpointer --> gboolean
  method connect-sheet-event (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-sheet-event($obj, $signal,
        -> $, $ge, $ud --> gboolean {
          CATCH {
            default { note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $ge, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, GtkMovementStep, gint, gboolean, gpointer
  method connect-move-cursor (
    $obj,
    $signal = 'move-cursor',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-move-cursor($obj, $signal,
        -> $, $gmsp, $gt, $gn, $ud {
          CATCH {
            default { note($_) }
          }

          $s.emit( [self, $gmsp, $gt, $gn, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, GtkSheetRange, GtkSheetRange, gpointer
  method connect-move-range (
    $obj,
    $signal = 'move-range',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-move-range($obj, $signal,
        -> $, $sr1, $sr2, $ud {
          CATCH {
            default { note($_) }
          }

          $s.emit( [self, $sr1, $sr2, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, GtkSheetRange, gpointer
  method connect-select-range (
    $obj,
    $signal = 'select-range',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-select-range($obj, $signal,
        -> $, $gsre, $ud {
          CATCH {
            default { note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $gsre, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, GtkAdjustment, GtkAdjustment, gpointer
  method connect-set-scroll-adjustments (
    $obj,
    $signal = 'set-scroll-adjustments',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-set-scroll-adjustments($obj, $signal,
        -> $, $a1, $a2, $ud {
          CATCH {
            default { note($_) }
          }

          $s.emit( [self, $a1, $a2, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }

  # GtkSheet, gint, gint, gpointer, gpointer, gpointer --> gboolean
  method connect-traverse (
    $obj,
    $signal = 'traverse',
    &handler?
  ) {
    my $hid;
    %!signals-es{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-traverse($obj, $signal,
        -> $, $i1, $i2, $p1, $p2, $ud --> gboolean {
          CATCH {
            default { note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $i1, $i2, $p1, $p2, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid];
    };
    %!signals-es{$signal}[0].tap(&handler) with &handler;
    %!signals-es{$signal}[0];
  }
}

# GtkSheet, gint, gint, gpointer --> gboolean
sub g-connect-activate(
  Pointer $app,
  Str $name,
  &handler (Pointer, gint, gint, Pointer --> gboolean),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, gint, gint, gpointer
sub g-connect-intint(
  Pointer $app,
  Str $name,
  &handler (Pointer, gint, gint, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }


# GtkSheet, GtkSheetRange, gpointer
sub g-connect-clip-range(
    Pointer $app,
    Str $name,
    &handler (Pointer, GtkSheetRange, Pointer),
    Pointer $data,
    uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, GdkEvent, gpointer --> gboolean
sub g-connect-sheet-event(
  Pointer $app,
  Str $name,
  &handler (Pointer, GdkEvent, Pointer --> gboolean),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, GtkMovementStep, gint, gboolean, gpointer
sub g-connect-move-cursor(
  Pointer $app,
  Str $name,
  &handler (Pointer, GtkMovementStep, gint, gboolean, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, GtkSheetRange, GtkSheetRange, gpointer
sub g-connect-move-range(
  Pointer $app,
  Str $name,
  &handler (Pointer, GtkSheetRange, GtkSheetRange, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, GtkSheetRange, gpointer
sub g-connect-select-range(
  Pointer $app,
  Str $name,
  &handler (Pointer, GtkSheetRange, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, GtkAdjustment, GtkAdjustment, gpointer
sub g-connect-set-scroll-adjustments(
  Pointer $app,
  Str $name,
  &handler (Pointer, GtkAdjustment, GtkAdjustment, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# GtkSheet, gint, gint, gpointer, gpointer, gpointer --> gboolean
sub g-connect-traverse(
  Pointer $app,
  Str $name,
  &handler (Pointer, gint, gint, CArray[gint], CArray[gint], Pointer --> gboolean),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }
