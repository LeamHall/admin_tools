# name:       copytools.pm
# version:    0.0.1
# date:       20210305
# desc:       Methods for building data structures from files.

## TODO

use strict;;
use warnings;

package CopyTools;


# Pretty sure these could be made into one method.
sub build_exclude_dir {
  my ($exclude_dir_file, $exclude_dir_ref)  = @_;
  return unless defined $exclude_dir_file;
  return unless defined $exclude_dir_ref;
  my %exclude_dir = %{$exclude_dir_ref};

  open my $exclude_dirs, '<', $exclude_dir_file or die "Can't open $exclude_dir_file: $!";
  for my $dir ( <$exclude_dirs> ) { 
    chomp $dir;
    if ( -d $dir ) {
      $exclude_dir{$dir} = 1;
    }
  }
  close $exclude_dirs;
  return ~\%exclude_dir;
}

sub build_exclude_list {
  my ( $exclude_list_file, $exclude_list_ref) = @_;
  return unless defined $exclude_list_file;
  return unless defined $exclude_list_ref;
  my %exclude_list = %{$exclude_list_ref};

  open my $exclude_files, '<', $exclude_list_file or die "Can't open $exclude_list_file: $!";
  for my $file ( <$exclude_files> ) {
    chomp $file;
    $exclude_list{$file} = 1;
  }
  close $exclude_files;
  return \%exclude_list;
}

sub build_hash_true {
  my $file = shift;
  return unless defined $file;
  my %return_hash;
  open my $build_file, '<', $file or die "Can't open $file: $!";
  foreach my $f ( <$build_file> ){
    chomp $f;
    $return_hash{$f} = 1;
  }
  close $build_file;
  return \%return_hash;
}

sub build_hash_list {
  my $file = shift;
  return unless defined $file;
  my %return_hash;
  open my $build_file, '<', $file or die "Can't open $file: $!";
  foreach my $f ( <$build_file> ){
    chomp $f;
    $return_hash{$f} = ();
  }
  close $build_file;
  return \%return_hash;
}

sub build_list_from_file {
  my $file = shift;
  return unless defined $file;
  my @return_array;
  open my $build_file, '<', $file or die "Can't open $file: $!";
  foreach my $f ( <$build_file> ){
    chomp $f;
    push( @return_array, $f );
  }
  close $build_file;
  return \@return_array;
}

sub build_file_list {
  my ( %config ) = @_;
  return unless defined $config{dir_queue};
  return unless defined $config{known_files};
  return unless defined $config{known_dirs};
  my @dir_queue     = @{$config{dir_queue}};
  my %purge_list    = %{$config{purge_l}} if defined $config{purge_l};
  my %exclude_dir   = %{$config{exclude_dir}} if defined $config{exclude_dir};
  my %exclude_list  = %{$config{exclude_list}} if defined $config{exclude_list};
  my %known_files   = %{$config{known_files}} if defined $config{known_files};
  my %known_dirs    = %{$config{known_dirs}} if defined $config{known_dirs};
  foreach my $search_dir ( @dir_queue ) {
    opendir( my $dir, $search_dir ) or die "Can't open $search_dir: $!";
    foreach my $file ( readdir($dir)) {
      next if $file =~ m/^\.\.?\.?$/;
      next if $file =~ m/^\.git$/;
      if ( -d "$search_dir/$file" ) {
        next if ( defined ($exclude_dir{"$search_dir/$file"}) );
        $known_dirs{"$search_dir/$file"} = 1;
        push ( @dir_queue, "$search_dir/$file");
      } else {
        if ( defined( $purge_list{$file} )){
          purge_file("$search_dir/$file");
          #$purged_file_count++;
          next;
        }
        next if ( defined( $exclude_list{$file} ));
        #$total_file_count++;
        my $size = -s "$search_dir/$file";
        $known_files{$file}{$size}{$search_dir} = 1;
      }
    }
    closedir($dir);
  }
  return \%known_files;
}

sub purge_file {
  my $file = shift;
  return unless defined($file);
  unlink($file) or die "Can't unlink $file: $!";
}

sub write_dirs_for_files {
  my ( $files, $logfile )  = @_;
  return unless defined( $files);
  return unless defined( $logfile);
  my %known_files = %{$files};
 
  open my $log, '>', $logfile or die "Can't open $logfile: $!"; 
  select $log;
  foreach my $file ( keys(%known_files)){
    foreach my $size ( keys( %{$known_files{$file}} )){
      my $dir_count = keys %{$known_files{$file}{$size}};
      if ( $dir_count > 1 ){
        print  "$file:    ";
        print "Size: $size\n";
        foreach my $dir ( keys( %{$known_files{$file}{$size}}) ){
          print "  $dir\n";
        }
      }
    }
  } 
  print "\n";
  close $logfile;
}

sub write_list_to_logfile {
  my ( $list, $logfile ) = @_;
  open my $file, '>', $logfile or die "Can't open $logfile: $!";
  foreach my $line ( @$list ){
    print $file "$line\n";
  }
  close $file;
}

sub write_log { 
  my ( $dir, $total_file_count, $known_files, $known_dirs, $exclude_list, $exclude_dir ) = @_;
  return unless defined $dir;
  return unless defined $known_files;
  return unless defined $known_dirs;
  my %known_files   = %{$known_files};
  my %known_dirs    = %{$known_dirs};
  my %exclude_list  = %{$exclude_list} if defined $exclude_list;
  my %exclude_dir   = %{$exclude_dir} if defined $exclude_dir;
  my $actual_file_count = scalar(keys(%known_files));
  print "With $actual_file_count unique files, there are $total_file_count copies.\n";
  my @single_version_files;
  my @multiple_version_files;
  foreach my $file ( keys( %known_files ) ){
    my @values = keys(%{$known_files{$file}});
    if ( scalar(@values)  > 1 ) {
      push @multiple_version_files, $file;
    } else {
      push @single_version_files, $file;
    }
  }
  @multiple_version_files  = sort(@multiple_version_files);
  @single_version_files    = sort(@single_version_files);
  if ( scalar( @multiple_version_files ) ) {
    my $mvf_filename = "$dir/multiple_version_files.list";
    write_list_to_logfile(\@multiple_version_files, $mvf_filename);
  }
  if ( scalar( @single_version_files ) ){
    my $svf_filename = "$dir/single_version_files.list";
    write_list_to_logfile(\@single_version_files, $svf_filename);
  }
  if ( keys(%exclude_dir) ){
    my @excluded_dirs = ( keys(%exclude_dir) );
    my $excluded_dirs_filename = "$dir/excluded_dirs.list";
    write_list_to_logfile(\@excluded_dirs, $excluded_dirs_filename);
  }
  if ( keys( %exclude_list ) ) {
    my @excluded_files = keys(%exclude_list);
    my $excluded_files_filename = "$dir/excluded_files.list";
    write_list_to_logfile(\@excluded_files, $excluded_files_filename);
  }
  if ( keys(%known_dirs) ) {
    my @known_dirs = keys(%known_dirs);
    my $known_dirs_filename = "$dir/known_dirs.list";
    write_list_to_logfile(\@known_dirs, $known_dirs_filename);
  }
}

1;
