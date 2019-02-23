use v6.c;

use NativeCall;

use Cairo;
use GTK::Compat::Cairo;
use GTK::Compat::Types;
use GTK::Compat::KeySyms;
use GTK::Raw::Types;
use GTKSheet::Raw::Types;
use Pango::FontDescription;
use Pango::Raw::Types;

use GTK::Entry;
use GTK::SpinButton;
use GTK::TextView; 
use GTKSheet::DataEntry;

use GTK::Utils::MenuBuilder;

unit package TestSheet::Common;

our %xpm       is export;
our %pixbuf    is export;
our $sheet_css is export;
our %widgets   is export;
our @col_names is export = ('A'..'Z');

our constant DEFAULT_SPACE     is export = 8;
our constant DEFAULT_PRECISION is export = 3;

sub change_page($, $, $pagenum, $) is export {
  say "Current page: { $pagenum }";
  my $c = %widgets<sheets>[ %widgets<notebook>.current_page ];
  %widgets<entry>.text = $c.entry_text ?? $c.entry_text !! '';
}

sub popup_activated ( $i --> gint ) {
  $i.say;
  my $c = %widgets<sheets>[ %widgets<notebook>.current_page ];
  given $i {
    when 'Add Column'   { $c.add_column(1) }
    when 'Add Row'      { $c.add_row(1)    }
    when 'Clear Cells'  { $c.range_clear   }

    when 'Insert Row'   {
      $c.insert_rows($c.range.row0, $c.range.row1 - $c.range.row0 + 1)
        if $c.state == GTK_SHEET_ROW_SELECTED;
    }
    when 'Insert Column' {
      $c.insert_columns($c.range.col0, $c.range.col1 - $c.range.col0 + 1)
        if $c.state == GTK_SHEET_COLUMN_SELECTED;
    }
    when 'Delete Row'    {
      $c.delete_rows($c.range.row0, $c.range.row1 - $c.range.row0 + 1)
        if $c.state == GTK_SHEET_ROW_SELECTED;
    }
    when 'Delete Column' {
      $c.delete_columns($c.range.col0, $c.range.col1 - $c.range.col0 + 1)
        if $c.state == GTK_SHEET_COLUMN_SELECTED;
    }
  }
  1;
}

sub build_menu($s) is export {
  my $menu = GTK::Utils::MenuBuilder.new(TOP => [
    'Add Column'    => { id => 'item_0' },
    'Add Row'       => { id => 'item_1' },
    'Insert Row'    => {
        id          => 'item_2',
        sensitive   => $s.state == GTK_SHEET_ROW_SELECTED,
        focus       => $s.state == GTK_SHEET_ROW_SELECTED,
    },
    'Insert Column' => {
        id          => 'item_3',
        sensitive   => $s.state == GTK_SHEET_COLUMN_SELECTED,
        focus       => $s.state == GTK_SHEET_COLUMN_SELECTED
    },
    'Delete Row'    => {
        id          => 'item_4',
        sensitive   => $s.state == GTK_SHEET_ROW_SELECTED,
        focus       => $s.state == GTK_SHEET_ROW_SELECTED
    },
    'Delete Column' => {
        id          => 'item_5',
        sensitive   => $s.state == GTK_SHEET_COLUMN_SELECTED,
        focus       => $s.state == GTK_SHEET_COLUMN_SELECTED
    },
    'Clear Cells'   => { id => 'item_6' },
  ] );

  for $menu.items.keys {
    .say;
    my $i = $menu.items{$_};
    $i.clicked.tap( -> *@a { @a[* - 1].r = popup_activated($i.label) });
    $i.show;
  }
  $menu.menu;
}

sub do_popup($s, $ev) is export {
  my $eb = nativecast(GdkEventButton, $ev);
  my ($x, $y, $m) = GTK::Compat::Window.new($eb.window).
    get_device_position($eb.device);

  if $m +& GDK_BUTTON3_MASK {
    if %widgets<popup> {
      #%widgets<popup>.destroy;
      %widgets<popup> = Nil;
    }

    %widgets<popup> = build_menu($s);
    %widgets<popup>.show_all;
    # %widgets<popup>.popup(
    #   GtkWidget, GtkWidget, Pointer, Pointer, $eb.button, $eb.time
    # );
    %widgets<popup>.popup_at_pointer(GdkEvent);
  }
  0;
}

sub format_text($s, $t, $j is rw, $l is rw) {
  my $sc = $s.style_context;
  my $fd = $sc.get_font(GTK_STATE_FLAG_NORMAL);
  my $pc = $s.get_pango_context;
  my $chrw = $pc.get_metrics.get_approximate_char_width;
  my $colw = $s.get_column_width;
  my $space = $chrw / $chrw;
  my $is = ($space, DEFAULT_SPACE).min;

  my enum Format <EMPTY TEXT NUMERIC>;
  my $format = EMPTY;
  $format = $t.trim.elems > 0 && $t.Numeric != Failure ?? NUMERIC !! TEXT;
  given $format {
    when TEXT | EMPTY { $l = $t;  return $l; }
    when NUMERIC      { $j = GTK_JUSTIFY_RIGHT; }
  }

  my $ds = $t.trim.Numeric.log10.floor.abs;
  if $ds + DEFAULT_PRECISION + 1 > $is || $ds > DEFAULT_PRECISION {
    $l = $t.trim.Numeric.fmt('%E');
  } else {
    $l = $t.trim.Numeric.fmt("%{ DEFAULT_PRECISION }f");
    $l .= fmt('%E') if $l.elems > $space;
  }
}

sub parse_numbers($s) is export {
  CATCH { default { .message.say; .rethrow } }
  
  say 'PARSE_NUMBERS';
  my ($j, $label) = ( $s.get_attributes.justification );
  my $t = $s.entry_text;
  # Need $j set to new value before its use in the next statement.
  $s.format_text($t, $j, $label);
  $s.set_cell( $, $, $j, $label);
}

sub clipboard_handler($s, $ek is copy) is export {
  $ek = nativecast(GdkEventKey, $ek);
  if [||](
    $ek.state  +& GDK_CONTROL_MASK,
    $ek.keyval == GDK_KEY_Control_L,
    $ek.keyval == GDK_KEY_Control_R,
  ) {
    if $ek.keyval eq <c C>.any && $s.state == GTK_STATE_NORMAL {
      $s.unclip_range if $s.in_clip;
      $s.clip_range($s.range);
    }
    $s.unclip_range if $ek.keyval eq <x X>.any;
  }
  0;
}

sub sheet_entry_changed_handler is export {
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  return unless $current.has_focus;

  my $t = $current.get_entry;
  %widgets<entry>.text = $t if $t;
}

sub resize_handler($or, $nr) is export {
  printf "OLD SIZE: %d %d %d %d\n",
    $or.row0, $or.col0, $or.row1, $or.col1;
  printf "NEW SIZE: %d %d %d %d\n",
    $nr.row0, $nr.col0, $nr.row1, $nr.col1;
}

sub move_handler($or, $nr) is export {
  printf "OLD SELECTION: %d %d %d %d\n",
    $or.row0, $or.col0, $or.row1, $or.col1;
  printf "NEW SELECTION: %d %d %d %d\n",
    $nr.row0, $nr.col0, $nr.row1, $nr.col1;
}

sub change_entry($s, $r, $c, $nr, $nc, $ud, $rt) is export {
  CATCH { default { .message.say; .rethrow } }
  
  my $changed = False;

  printf "change_entry: %d %d -> %d %d\n", $r, $c, $nr[0], $nc[0];
  if $nc[0] == 1 && ($c != 1 || $s.state != GTK_STATE_NORMAL) {
    say "change_entry: GtkEntry\n";
    $s.change_entry( GTK::Entry.get_type );
    $changed = True;
  }

  if $nc[0] == 2 && ($c != 2 || $s.state != GTK_STATE_NORMAL) {
    say "change_entry: GtkSpinButton";
    #$s.change_entry( GTK::SpinButton.get_type );
    my $t = $s.cell_get_text($nr[0], $nc[0]);
    $t = $t.defined && $t.Int !~~ Failure ?? $t.Int !! 0;
    say "Adj ({ $t })";
    my $a = GTK::Adjustment.new($t, 0, 100, 1, 10, 0);
    say 'SB';
    my $sp = GTK::SpinButton.new($s.get_entry);
    say "Conf ({ $sp })";
    $sp.configure($a, 0, 3);
    say 'postconf';
    $changed = True;
  }

  if $nc[0] == 3 && ($c != 3 || $s.state != GTK_STATE_NORMAL) {
    say "change_entry: GtkTextView";
    $s.change_entry( GTK::TextView.get_type );
    $changed = True;
  }

  if $nc[0] == 5 && ($c != 4 || $s.state != GTK_STATE_NORMAL) {
    say "change_entry: GtkDataEntry";
    $s.change_entry( GTKSheet::DataEntry.get_type );
    $changed = True;
  }

  if $changed {
    # Beware: You neet to reconnect the "changed" signal after every call to
    # this routine.
    $s.entry_signal_connect_changed({ sheet_entry_changed_handler });
  }
  $rt.r = 1;
}

sub alarm_change($r, $c) is export {
  printf "CHANGE CELL: %d, %d\n", $r, $c;
}

sub alarm_activate($r, $c) is export {
  printf "ACTIVATE CELL: %d %d\n", $r, $c;
  #my $r = GtkSheetRange.new($r, $c, $r, $c);
  1
}

sub alarm_deactivate($s, $r, $c) is export {
  # NOP?
  #my $range = GtkSheetRange.new($r, $c, $r, $c);
  my $t = $s.cell_get_text($r, $c);
  printf "DEACTIVATE CELL: %d, %d\n", $r, $c;
  $s.set_cell_text($r, $c, $t) if $t;
  1;
}

sub alarm_traverse($r, $c, $nr, $nc) is export {
  printf "TRAVERSE: %d %d %d %d\n", $r, $c, $nr[0], $nc[0];
  1
}

sub show_child is export {
  unless %widgets<calendar>.mapped {
    %widgets<sheets>[0].attach_floating(%widgets<calendar>, 2, 7);
  }
}

sub set_cell($w) is export {
  my $sheet = GTKSheet.new($w);
  %widgets<entry>.text = $sheet.entry_text if $sheet.entry_text;
}

sub entry_changed is export {
  return unless %widgets<entry>.has_focus;
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  $current.entry_text = %widgets<entry>.text if %widgets<entry>.text;
}

sub activate_sheet_entry is export {
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  my ($r, $c) = ($current.active_cell.row, $current.active_cell.col);
  $current.set_cell_text($r, $c, $current.entry_text);
}

sub justify($j) is export {
  .active = False for %widgets<justify_buttons>.values;
  my $jv  = do given $j {
    when 'left'   { GTK_JUSTIFY_LEFT   }
    when 'right'  { GTK_JUSTIFY_RIGHT  }
    when 'center' { GTK_JUSTIFY_CENTER }
  }
  %widgets<justify_buttons>{$j}.active = True;
  # Appears to be Any when setting up Example2. Why?
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  $current.range_set_justification($jv) with $current;
}

sub activate_sheet_cell ($sheet, $r, $c --> gint) is export {
  my $sheet_entry = GTK::Widget.new($sheet.get_entry);
  my $cell;
  
  given $sheet_entry.get_gobject_type {
    when GTK::Entry.get_type { 
      $sheet_entry = GTK::Entry.new($sheet.get_entry)
    }
    when GTKSheet::DataEntry.get_type {
      $sheet_entry = GTKSheet::DataEntry.new($sheet.get_entry);
    }
  }
  
  %widgets<location>.text = do {
    my $col_title = $sheet.get_column_title($c);
    $col_title ??
      "{ $col_title }:{ $r }" !! "ROW: { $r } COLUMN: { $c }";
  }
  say "LOCATION: { %widgets<location>.text }";
  
  %widgets<entry>.max_length = $sheet_entry.max_length
    if $sheet_entry ~~ <GTK::Entry GTKSheet::DataEntry>.any;

  %widgets<entry>.text = $sheet.entry_text ?? $sheet.entry_text !! '';

  my $attr = $sheet.get_attributes($r, $c);
  %widgets<entry>.editable = $attr.is_editable;

  given $attr.justification {
    when GTK_JUSTIFY_LEFT   { justify(  'left') }
    when GTK_JUSTIFY_RIGHT  { justify( 'right') }
    when GTK_JUSTIFY_CENTER { justify('center') }
    default                 { justify(  'left') }
  }
  
  # Note: Font button does not reflect font of current cell. Should fix!

  1;
}

sub change_border($b) is export {
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  my $range = $current.range;
  my ($border_width, $border_mask, $auxval) = (3);

  sub set_current_border($r = $range, $m = $border_mask, $w = $border_width) {
    $current.range_set_border(
      $range, $m, $w, CAIRO_LINE_CAP_BUTT, CAIRO_LINE_JOIN_MITER
    );
  }

  set_current_border(0, 0);

  given $b {
    when 1  {
      $border_mask = GTK_SHEET_TOP_BORDER;
      $range.row1 = $range.row0;
      proceed;
    }
    when 2  {
      $border_mask = GTK_SHEET_BOTTOM_BORDER;
      $range.row0 = $range.row1;
      proceed;
    }
    when 3  {
      $border_mask = GTK_SHEET_RIGHT_BORDER;
      $range.col0 = $range.col1;
      proceed;
    }
    when 4  {
      $border_mask = GTK_SHEET_LEFT_BORDER;
      $range.col1 = $range.col0;
      proceed;
    }
    when 1..4 {
      set_current_border();
    }
    when 5  {
      if $range.col0 == $range.col1 {
        set_current_border(GTK_SHEET_LEFT_BORDER +| GTK_SHEET_RIGHT_BORDER);
        succeed;
      }
      $auxval = $range.col1;
      set_current_border($, GTK_SHEET_LEFT_BORDER);
      $range.col0 = $range.col1 = $auxval;
      set_current_border($, GTK_SHEET_RIGHT_BORDER);
    }
    when 6  {
      if $range.row0 == $range.row1 {
        set_current_border($, GTK_SHEET_TOP_BORDER +| GTK_SHEET_BOTTOM_BORDER);
        succeed;
      }
      $auxval = $range.row1;
      set_current_border($, GTK_SHEET_TOP_BORDER);
      $range.row0 = $range.row1 = $auxval;
      set_current_border($, GTK_SHEET_RIGHT_BORDER);
    }
    when 7  {
      set_current_border($, GTK_SHEET_RIGHT_BORDER +| GTK_SHEET_LEFT_BORDER);
    }
    when 8  {
      set_current_border($, GTK_SHEET_BOTTOM_BORDER +| GTK_SHEET_TOP_BORDER;);
    }
    when 9 | 10  {
      my $border_val = $_ == 9 ?? 15 !! 0;
      set_current_border($, $border_val) if $_ == 9;
      for ($range.row0..$range.row1) X ($range.col0..$range.col1) -> ($r, $c) {
        $auxval = GtkSheetRange.new($r, $c, $r, $c);
        $border_mask = $border_val;
        $border_mask +^= GTK_SHEET_BOTTOM_BORDER if $r == $range.row1;
        $border_mask +^= GTK_SHEET_TOP_BORDER    if $r == $range.row0;
        $border_mask +^= GTK_SHEET_RIGHT_BORDER  if $c == $range.col1;
        $border_mask +^= GTK_SHEET_LEFT_BORDER   if $c == $range.col0;
        set_current_border($auxval) if $border_mask != $border_val;
      }
    }
    when 11 {
      $border_mask = 15;
      set_current_border();
    }
  }
}

sub change_color($c, $is-fg) is export {
  my $w := $is-fg ?? %widgets<fg_pixmap> !! %widgets<bg_pixmap>;
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  $current.set_background($current.range, $c);
  my $ct = Cairo::Context.new( GTK::Compat::Cairo.create(%widgets<window>) );
  $ct.rgba($c);
  my @rect = do given $is-fg {
    when False.so { (4, 20, 18, 4) }
    when  True.so { (5, 20, 16, 4) }
  }
  $ct.rectangle(|@rect);
  $ct.fill;
  $w.draw($ct);
}

sub hide_row_titles is export {
  %widgets<sheets>[ %widgets<notebook>.current_page ].hide_row_titles;
}

sub hide_column_titles is export {
  %widgets<sheets>[ %widgets<notebook>.current_page ].hide_column_titles;
}

sub show_row_titles is export {
  %widgets<sheets>[ %widgets<notebook>.current_page ].show_row_titles;
}

sub show_column_titles is export {
  %widgets<sheets>[ %widgets<notebook>.current_page ].show_column_titles;
}

sub new_font is export {
  my $current = %widgets<sheets>[ %widgets<notebook>.current_page ];
  my $fd = Pango::FontDescription.new_from_string(
    %widgets<fontbutton>.font_name
  );
  $current.range_set_font($current.range, $fd);
}

#BEGIN {
  $sheet_css = q:to/CSS/.chomp;
/* stylesheet for testgtksheet application */

@define-color sheet_default_bg_color lightgray;
@define-color sheet_default_fg_color black;

sheet {
    background-color: @sheet_default_bg_color;
    color: @sheet_default_fg_color;
}

sheet .cell:selected {
    background-color: @theme_selected_bg_color;
    color: @theme_selected_fg_color;
}

/* sheet entry selection style */

sheet entry selection {
    background-color: @theme_selected_bg_color;
    color: @theme_selected_fg_color;
}

/* Note: "entry" selector is needed for entry types:
   GtkEntry, GtkDataEntry, GtkSpinButton
   */

sheet entry {
    background-color: @sheet_default_bg_color;
}

/* Note: "text" selector is needed for entry types:
   GtkTextView, GtkDataTextView
   */

sheet.view text {
    background-color: @sheet_default_bg_color;
}

sheet.view text:backdrop {
    background-color: @sheet_default_bg_color;
}

/* testgtksheet example1 - access via class */

@define-color testgtksheet_example1_default_bg lightyellow;

/* Note: :not(.left) excludes row title area */
sheet .example1class:not(.left) {
    background-color: @testgtksheet_example1_default_bg;
    color: black;
}
sheet .example1class:not(.left):selected {
    background-color: @theme_selected_bg_color;
    color: @theme_selected_fg_color;
}
sheet .example1red:not(.left) {
    background-color: @testgtksheet_example1_default_bg;
    color: red;
    font: 28px Arial;
}
sheet .example1blue:not(.left) {
    background-color: @testgtksheet_example1_default_bg;
    color: blue;
    font: 36px Arial;
}
sheet .example1grey:not(.left) {
    background-color: darkgrey;
    color: green;
}

/* testgtksheet example2 - access via widget name */

@define-color testgtksheet_example2_bgcolor lightgray;

sheet#example2 .blue {
    background-color: @testgtksheet_example2_bgcolor;
    color: blue;
}
sheet#example2 .red {
    background-color: @testgtksheet_example2_bgcolor;
    color: red;
}
sheet#example2 .black {
    background-color: @testgtksheet_example2_bgcolor;
    color: black;
}

/* testgtksheet example3 - access via widget name */

@define-color testgtksheet_example3_default_fg brown;

@define-color testgtksheet_example3_orange_bg orange;
@define-color testgtksheet_example3_orange_fg white;
@define-color testgtksheet_example3_lblue_bg lightblue;
@define-color testgtksheet_example3_lgreen_bg lightgreen;
@define-color testgtksheet_example3_red_bg red;
@define-color testgtksheet_example3_red_fg white;

sheet#example3 .orange {
    background-color: @testgtksheet_example3_orange_bg;
    color: @testgtksheet_example3_orange_fg;
}
sheet#example3 .orange text {
    background-color: @testgtksheet_example3_orange_bg;
    color: @testgtksheet_example3_orange_fg;
}
sheet#example3 .orange entry {
    background-color: @testgtksheet_example3_orange_bg;
    color: @testgtksheet_example3_orange_fg;
}
sheet#example3 .lblue {
    background-color: @testgtksheet_example3_lblue_bg;
    color: @testgtksheet_example3_default_fg;
}
sheet#example3 .lblue text {
    background-color: @testgtksheet_example3_lblue_bg;
    color: @testgtksheet_example3_default_fg;
}
sheet#example3 .lblue entry {
    background-color: @testgtksheet_example3_lblue_bg;
    color: @testgtksheet_example3_default_fg;
}
sheet#example3 .lgreen {
    background-color: @testgtksheet_example3_lgreen_bg;
    color: @testgtksheet_example3_default_fg;
}
sheet#example3 .red {
    background-color: @testgtksheet_example3_red_bg;
    color: @testgtksheet_example3_red_fg;
}
CSS

# »»»»»»»»»»»»»»»» WARNING ««««««««««««««««
# Whitespace is CRITICAL here! Do NOT let your editor strip trailing 
# whitespace. If you are getting SEGVs in odd places, look here, FIRST!
#
# Consider adding a mark at end of string for clarification?

# Take all of these and TEST IN ISOLATION!!
  %xpm<bullet> = q:to/XPM/.chomp;
16 16 26 1
 	c #None
.	c #000000000000
X	c #0000E38D0000
o	c #0000EBAD0000
O	c #0000F7DE0000
+	c #0000FFFF0000
@	c #0000CF3C0000
#	c #0000D75C0000
$	c #0000B6DA0000
%	c #0000C30B0000
&	c #0000A2890000
*	c #00009A690000
=	c #0000AEBA0000
-	c #00008E380000
;	c #000086170000
:	c #000079E70000
>	c #000071C60000
,	c #000065950000
<	c #000059650000
1	c #000051440000
2	c #000045140000
3	c #00003CF30000
4	c #000030C20000
5	c #000028A20000
6	c #00001C710000
7	c #000014510000
     ......     
    .XooO++.    
  ..@@@#XoO+..  
 .$$$$$%@#XO++. 
 .&&*&&=$%@XO+. 
.*-;;;-*&=%@XO+.
.;:>>>:;-&=%#o+.
.>,<<<,>:-&$@XO.
.<12321<>;*=%#o.
.1345431,:-&$@o.
.2467642<>;&$@X.
 .57.753<>;*$@. 
 .467642<>;&$@. 
  ..5431,:-&..  
    .21<>;*.    
     ......     
XPM

  %xpm<center> = q:to/XPM/.chomp;
28 26 2 1
.      c #None
X      c #000000000000
                            
                            
                            
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
        XXXXXXXXXXXX        
        XXXXXXXXXXXX        
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
        XXXXXXXXXXXX        
        XXXXXXXXXXXX        
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
        XXXXXXXXXXXX        
        XXXXXXXXXXXX        
                            
                            
                            
                            
                            
XPM

  %xpm<font> = q:to/XPM/.chomp;
26 26 3 1
 	c #None
.	c #000000000000
X	c #000000000000
                          
                          
                          
            .             
           ...            
           ...            
          .....           
          .....           
         .. ....          
         .. ....          
        ..   ....         
        .........         
       ...........        
       ..     ....        
      ..       ....       
      ..       ....       
    .....     .......     
                          
                          
                          
     XXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXX     
                          
                          
                          
XPM

  %xpm<left> = q:to/XPM/.chomp;
28 26 2 1
.      c #None
X      c #000000000000
                            
                            
                            
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
     XXXXXXXXXXXXX          
     XXXXXXXXXXXXX          
                            
     XXXXXXXXXXXXXXXXXX      
     XXXXXXXXXXXXXXXXXX     
                            
     XXXXXXXXXXXXX          
     XXXXXXXXXXXXX          
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
     XXXXXXXXXXXXX          
     XXXXXXXXXXXXX          
                            
                            
                            
                            
                            
XPM

  %xpm<right> = q:to/XPM/.chomp;
28 26 2 1
.      c #None
X      c #000000000000
                            
                            
                            
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
          XXXXXXXXXXXXX     
          XXXXXXXXXXXXX     
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
          XXXXXXXXXXXXX     
          XXXXXXXXXXXXX     
                            
     XXXXXXXXXXXXXXXXXX     
     XXXXXXXXXXXXXXXXXX     
                            
          XXXXXXXXXXXXX     
          XXXXXXXXXXXXX     
                            
                            
                            
                            
                            
XPM

  %xpm<smile> = q:to/XPM/.chomp;
16 16 3 1
 	c #None
.	c #000000000000
X	c #FFFFFFFF0000
     ......     
    .XXXXXX.    
  ..XXXXXXXX..  
 .XXXXXXXXXXXX. 
 .XXX..XX..XXX. 
.XXXX..XX..XXXX.
.XXXX..XX..XXXX.
.XXXXXXXXXXXXXX.
.XX..XXXXXX..XX.
.XX..XXXXXX..XX.
.XXX.XXXXXX.XXX.
 .XXX.XXXX.XXX. 
 .XXXX....XXXX. 
  ..XXXXXXXX..  
    .XXXXXX.    
     ......     
XPM

  # Precompile images from pixbuf data.
  %pixbuf{$_} = GTK::Compat::Pixbuf.new_from_xpm_data( %xpm{$_} )
    for %xpm.keys;
#}
