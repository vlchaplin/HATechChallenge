#!/usr/bin/perl -w
use strict;
use File::Basename;

$|=1;



sub load_randoms
{
    my @lib;
    my @files=@_;
    foreach my $f (@files)
    {
        open(my $fh, "<".$f);
        while (my $line = <$fh>) {
            
            $line =~ s/\s//;
            chomp($line );
          
            next if $line=~/^#/;
            push(@lib, $line );
            #print($_);
        }
        close($fh);
    }
    return @lib
}

sub contains
{
    my $str = shift @_;
    my $tag = shift @_;
    my $i=index($str,$tag );
    return $i >= 0;
}

sub count_sets
{
    my $str = shift @_;
    my @line;
    

    foreach my $tag (@_)
    {
        
        my $cont = contains($str,$tag);
        
        push( @line, contains($str,$tag) );
    }
    return @line;
}

my $libfile = shift @ARGV;
my @lib = load_randoms("$libfile");

print("#".$libfile."\t".join("\t",@lib)."\n");

foreach my $file (@ARGV)
{
    open(my $fh, "<".$file) or print "$file: $!\n";
    next unless $fh;
    
    my $n =0;
    my $count=0;

    #exit;
    my @frags_count = map{ 0 } @lib;
    
    #print join("|",@lib)."\n";
    
    while (<$fh>) {
            chomp;
            
            next unless substr($_,0,1) eq '@';
            $_=<$fh>;
            chomp;
            
            my @row = count_sets($_, @lib);
            #print(@row);
            for (my $i=0; $i<@lib; $i++)
            {
                $frags_count[$i] += $row[$i];
                #print(($row[$i]+0)." ")
            }
            #print("\n");
            
            #$count+=contains($_);
            #print sprintf("%8d",$count)." ".$_."\n";
            $n++;
            
           #if ($n>40) {
           #    last;
           #}
            
    }
    close($fh);
    print(sprintf("%-s",basename($file))."\t".join( "\t", map{sprintf("%10d",$_)} @frags_count)."\n")
}
