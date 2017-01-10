## ファイルの内容をソートしてユニークにする。
## 引数１：		ソート＆ユニークにしたいファイルのフルパス（文字列）
## 戻り値		標準出力へ指定のファイルのソート＆ユニークの結果を出力
my %hash = ();
if ( @ARGV > 0 ){
	$tgtfile = $ARGV[0];
	open(INFILE, "<".$tgtfile) or die "$!";
	@ftxt = sort {$a cmp $b} <INFILE>;
	foreach(@ftxt){
		print unless $hash{$_}++; 
	}
	
	close(INFILE);
}

exit(0);




