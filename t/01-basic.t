use v6.c;

use GTK::Raw::Types;

use GTK::Application;
use GTK::ScrolledWindow;
use GTKSheet;

my $a = GTK::Application.new( title => 'org.genex.basic_sheet' );
$a.activate.tap({
  my $sw = GTK::ScrolledWindow.new_with_policy(
    GTK_POLICY_ALWAYS, GTK_POLICY_AUTOMATIC
  );
  my $s = GTKSheet.new(10, 10, 'Sample');

  $sw.add($s);
  $a.window.destroy-signal.tap({ $a.exit });
  $a.window.add($sw);
  $a.window.show_all;
});

$a.run;
