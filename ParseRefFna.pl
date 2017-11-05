#!/usr/bin/perl -w
use strict;
use File::Basename;
use IO::Zlib;

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
    my $i=0;
    
    my $len = length($str);
    my $count=0;
    while($i>=0 && $i<$len)
    {
        #print($i."\n");
        $i = index($str,$tag, $i+1);
        $count++ if $i>=0;
        
    }
    
    
    return $count;
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
#my @lib = qw(GG);

print("#".$libfile."\t".join("\t",@lib)."\n");

foreach my $file (@ARGV)
{
    my $fh;
    if ($file =~ /.*\.gz/) {
        `gunzip $file`;
        $file =~ s//.*\.gz/;
    }
    else
    {
        open($fh, "<".$file) or print "$file: $!\n";
        next unless $fh;
    }
    
    my $n =0;
    my $count=0;

    #exit;
    my @frags_count = map{ 0 } @lib;
    
    #print join("|",@lib)."\n";
    <$fh>;
    while (<$fh>) {
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
            
           #if ($n>1e6) {
           #    last;
           #}
            
    }
    close($fh);
    print(sprintf("%-s",basename($file))."\t".join( "\t", map{sprintf("%10d",$_)} @frags_count)."\n")
}
