
if ( @ARGV > 0 ){
	$tgtfile = $ARGV[0];
	open(INFILE, "<".$tgtfile) or die "$!";
	foreach(<INFILE>){
		if( $_ =~ /\d+\.\d+\.\d+\.\d+\s+<->\s+\d+\.\d+\.\d+\.\d+/){
			print $&."\n";
		}
	}
	
	close(INFILE);
}

exit(0);




