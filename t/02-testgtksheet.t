use v6.c;

use GTK::Raw::Types;

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::Compat::Pixbuf;
use GTK::CSSProvider;
use GTK::Entry;
use GTK::FontButton;
use GTK::Image;
use GTK::Label;
use GTK::Notebook;
use GTK::ScrolledWindow;
use GTK::SeparatorToolItem;
use GTK::ToggleButton;
use GTK::Toolbar;
use GTK::ToolItem;

use GTKSheet;

use lib 't';
use TestSheet;
use TestSheet::Example1;
use TestSheet::Example2;
# use TestSheet::Example3;

constant NUM_SHEETS = 4;

sub build_example4 ($s) {
  $s.button_press_event.tap({ do_popup($s) });
}

sub build_example ($s) {

  # build_example3($s) if $s =:= %widgets<sheets>[2];
  # build_example4($s) if $s =:= %widgets<sheets>[3];
}

sub MAIN is export {
  my $a = GTK::Application.new( title => 'org.genex.testgtksheet' );
  my $c = GTK::CSSProvider.new( style => $sheet_css );

  $a.activate.tap({
    # All widgets go into %widgets!!!
    my @titles = 'Example ' X~ (1..4);
    my @folders = 'Folder ' X~ (1..4);

    (%widgets<window> = $a.window).title = 'GtkSheet Demo';
    $a.window.set_size_request(900, 600);

    %widgets<main_vbox> = GTK::Box.new-vbox(1);
    %widgets<main_vbox>.border_width = 0;
    $a.window.add(%widgets<main_vbox>);

    %widgets<notebook> = GTK::Notebook.new;
    %widgets<show_hide_box> = GTK::Box.new-hbox(1);
    for (
      'Hide Row Titles', 'Hide Column Titles',
      'Show Row Titles', 'Show Column Titles'
    ) {
      my $bn = $_;
      %widgets<button_titles>.push: GTK::Button.new_with_label($bn);
      %widgets<show_hide_box>.pack_start(
        %widgets<button_titles>[* - 1], True, True
      );
      %widgets<button_titles>[* - 1].clicked.tap({
        ::( '&' ~ $bn.lc.subst(' ', '_', :g) )()
      });
    }
    %widgets<main_vbox>.pack_start(%widgets<show_hide_box>, False, True);

    %widgets<toolbar> = GTK::Toolbar.new;
    my ($sep1, $sep2) = GTK::SeparatorToolItem.new xx 2;
    %widgets<toolbar>.insert($sep1);
    %widgets<fontitem> = GTK::ToolItem.new;
    %widgets<fontbutton> = GTK::FontButton.new;
    %widgets<fontbutton>.font-set.tap({ new_font() });
    %widgets<fontitem>.add( %widgets<fontbutton> );
    %widgets<toolbar>.insert(%widgets<fontitem>);

    for <left center right> {
      # Never use loop var in a closure.
      my $just = $_;
      %widgets<justify_buttons>{$_} = GTK::ToggleButton.new;
      %widgets<toolitems>.push: GTK::ToolItem.new;
      %widgets<toolitems>[*-1].add( %widgets<justify_buttons>{$just} );
      %widgets<toolbar>.insert( %widgets<toolitems>[*-1] );
      %widgets<justify_buttons>{$_}.released.tap({ justify($just) });
      my $image = GTK::Image.new_from_pixbuf(%pixbuf{$just});
      %widgets<justify_buttons>{$just}.add($image);
    }
    %widgets<toolbar>.insert($sep2);
    %widgets<main_vbox>.pack_start(%widgets<toolbar>, False, True);

    %widgets<status_box> = GTK::Box.new-hbox(1);
    %widgets<status_box>.border_width = 0;
    %widgets<main_vbox>.pack_start(%widgets<status_box>, False, True);

    %widgets<location> = GTK::Label.new;
    my ($, $ns) = %widgets<location>.get_preferred_size;
    %widgets<location>.set_size_request(160, $ns.height);
    %widgets<status_box>.pack_start(%widgets<location>, False, True);

    %widgets<entry> = GTK::Entry.new;
    %widgets<status_box>.pack_start(%widgets<entry>, True, True);

    %widgets<notebook>.tab_pos = GTK_POS_BOTTOM;
    %widgets<main_vbox>.pack_start(%widgets<notebook>, True, True);

    for ^NUM_SHEETS {
      %widgets<sheets>[$_] = GTKSheet.new( 1000, 26, @titles[$_] );
      %widgets<scrolled_windows>[$_] = GTK::ScrolledWindow.new;
      %widgets<scrolled_windows>[$_].add( %widgets<sheets>[$_] );
      %widgets<folder_label>[$_] = GTK::Label.new( @folders[$_] );
      %widgets<notebook>.append_page(
        %widgets<scrolled_windows>[$_], %widgets<folder_label>[$_]
      );

      # Already done in TestSheet::Example3.build_example3()
      %widgets<sheets>[$_].entry_signal_connect_changed(
        -> $, $ { sheet_entry_changed_handler() }
      ) unless $_ == 3;

      %widgets<sheets>[$_].activate.tap( -> *@a {
        @a[*-1].r = activate_sheet_cell( %widgets<sheets>[$_], |@a[1..2] )
      });
   }
   
   # This is the better signal than change-current-page. Wouldn't know that
   # from the GTK docs, though.
   %widgets<notebook>.switch-page.tap(-> *@a { change_page(|@a) });
   %widgets<notebook>.change-current-page.tap(-> *@a {
     say "Changed current page: { @a[1] }";
     @a[*-1].r = 0;
   });
   %widgets<notebook>.select-page.tap(-> *@a {
     say 'Changed page';
     @a[*-1].r = 1;
   });

   %widgets<entry>.changed.tap( { entry_changed        });
   %widgets<entry>.activate.tap({ activate_sheet_entry });
   
   build_example1( %widgets<sheets>[0] );
   build_example2( %widgets<sheets>[1] );

   # ???
   # %widgets<bg_pixmap> = GTK::Image.new_from_pixbuf(%pixbuf<paint>);
   # %widgets<bg_pixmap>.show;

   # for <font> {
   #   my $pixmap = GTK::Compat::Pixbuf.nbew_from_xpm_data( %xmp<$_ );
   #   my $image = GTK::Image.new_from_pixbuf($pixmap);
   #   # ... and then what?
   # }

    $a.window.show_all;
  });

  $a.run;
}
