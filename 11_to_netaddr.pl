########################################################
# キャプチャログファイル内のIPアドレスをネットワークアドレスに変換する。
#
# ・第一引数	：	キャプチャログファイル
# ・第二引数	：	ネットワークアドレスリスト
#
#	作成日		：	2015/05/07	信本
#
#	更新日		：	


if ( @ARGV > 1 ){
	my $tgtcapfile = $ARGV[0];
	my $tgtnetfile = $ARGV[1];
	
	my @restxt;
	open(CAPFILE, "<".$tgtcapfile) or die "$!";
	
	
	foreach my $capline (<CAPFILE>){
		####### キャプチャファイルのIPアドレスを抽出 #######
		if( $capline =~ /(\d+\.\d+\.\d+\.\d+)\s+<->\s+(\d+\.\d+\.\d+\.\d+)/){
#			print $1.":::::".$2."\n";
#			my $mask = "255.255.255.0";
			my $capsrcaddr = $1;
			my $capdstaddr = $2;

			## 戻り値格納変数↓↓
			#		送信元情報用		#
			my $srccategory;
			my $srclocation;
			my $srcsegname;
			
			my $capsrcnetaddr;
			my $capsrcnetmask;
			my $flgSrcConvCmp = 0;

			#		送信先情報用		#
			my $dstcategory;
			my $dstslocation;
			my $dstsegname;
			
			my $capdstnetaddr;
			my $capdstnetmask;
			my $flgDstConvCmp = 0;
			## 戻り値格納変数↑↑
			
			open(NETFILE, "<".$tgtnetfile) or die "$!";
			foreach my $netline (<NETFILE>){
				chomp($netline);
				my @netaddrmask = split(/,/,$netline);
#				my $netaddr = $netaddrmask[1];
#				my $netmask = $netaddrmask[0];
				my $netaddr = $netaddrmask[6];
				my $netmask = $netaddrmask[5];
				my $category = $netaddrmask[0];
				my $location = $netaddrmask[1];
				my $segname = $netaddrmask[2];
				
				
				chomp($netaddr);
#				print $netaddr.":::::".$netmask."\n";
				## キャプチャアドレスのネットワークアドレスとカレントのネット
				## ワークアドレスの比較（source アドレス）
				if($flgSrcConvCmp < 1){
					($capsrcnetaddr, $capsrcnetmask) = &GetNetAddr( $capsrcaddr, $netmask);
					
					
					
	#				print $capsrcnetaddr.":::::".$capsrcnetmask."\n";
					## ネットワークアドレス的に等しい場合
					if($capsrcnetaddr eq $netaddr){

						if($flgSrcConvCmp < 1){
							## そのまま変更後sourceアドレスとして採用する。
							$capsrcnetaddr = $capsrcnetaddr;
							$capsrcnetmask = $netmask;
		#					$capsrcnetmask = $capsrcnetmask;
							
							## 拠点情報を取得する。
							$srccategory = $category;
							$srclocation = $location;
							$srcsegname = $segname;
		#					print $netaddrmask[6].",".$netaddrmask[5]."\n";
#							#dbg
#								my @testsplit = split(/\./,$netaddr);
#								if($testsplit[0] eq "172" && $testsplit[1] eq "38"){
#									print "fileline1:::".$capline."\n";
#									print "fileline2:::".$netline."\n";
#									print "#########".$capsrcaddr."#########".$netmask."=====".$netaddr."##".$capsrcnetaddr."\n\n\n\n\n";
#								}
#							#dbg
							$flgSrcConvCmp = 1;
						}
					}else{
						if($flgSrcConvCmp < 1){
							$capsrcnetaddr = $capsrcaddr;
							$capsrcnetmask = "255.255.255.255";
							$srccategory = "";
							$srclocation = "";
							$srcsegname = "";

						}
					}
				}
				
				## キャプチャアドレスのネットワークアドレスとカレントのネット
				## ワークアドレスの比較（destination アドレス）
				if($flgDstConvCmp < 1){
					($capdstnetaddr, $capdstnetmask) = &GetNetAddr( $capdstaddr, $netmask);
	#				print $capdstaddr."/".$netmask."=".$capdstnetaddr."\n";
					## ネットワークアドレス的に等しい場合
					if($capdstnetaddr eq $netaddr){
						if($flgDstConvCmp < 1){
							## そのまま変更後destinationアドレスとして採用する。
							$capdstnetaddr = $capdstnetaddr;
							$capdstnetmask = $netmask;
		#					$capdstnetmask = $capdstnetmask;
							
							## 拠点情報を取得する。
							$dstcategory = $category;
							$dstlocation = $location;
							$dstsegname = $segname;

		#					print $netaddrmask[6].",".$netaddrmask[5]."\n";

							$flgDstConvCmp = 1;
						}
						
					}else{
						if($flgDstConvCmp < 1){
							$capdstnetaddr = $capdstaddr;
							$capdstnetmask = "255.255.255.255";

							$dstcategory = "";
							$dstlocation = "";
							$dstsegname = "";

						}
					}
				}
				
				if($flgSrcConvCmp > 0 && $flgDstConvCmp > 0){
					last:
				}
			}
			close(NETFILE);
#print $capdstaddr."aaaaaa\n";

			#### 出力フォーマットに従い標準出力へ出力する ####
			####	[システム名],[設置拠点＆フロア],[IPアドレス],
#			print $capsrcnetaddr."/".$capsrcnetmask." <-> ".$capdstnetaddr."/".$capdstnetmask."\n";
			my @srcaddrSplits = split(/\./, $capsrcnetaddr);
			my $outputLine = "";



			## 送信元の日本語の情報を取得
			$outputLine = $srcsegname.",".$srccategory.",".$srclocation;
			
			## 送信元アドレス情報を取得
			$outputLine = $outputLine.",".$srcaddrSplits[0].",".$srcaddrSplits[1].",".$srcaddrSplits[2].",".$srcaddrSplits[3];
			
			## 送信元サブネットマスクを取得
			$outputLine = $outputLine.",".$capsrcnetmask;
			
			## 送信先の日本語の情報を取得
			my @dstaddrSplits = split(/\./, $capdstnetaddr);
			$outputLine = $outputLine.",".$dstsegname.",".$dstcategory.",".$dstlocation;
			
			## 送信先アドレス情報を取得
			$outputLine = $outputLine.",".$dstaddrSplits[0].",".$dstaddrSplits[1].",".$dstaddrSplits[2].",".$dstaddrSplits[3];
			
			## 送信先サブネットマスクを取得
			$outputLine = $outputLine.",".$capdstnetmask;

			chomp($outputLine);
#			print $capsrcnetaddr."\n";\

			print $outputLine."\n";
		}
	}
	
	close(CAPFILE);
	

}else{
	print "ファイルの指定がありません。";

}

## IPアドレスとサブネットマスクを引数とし、ネットワークアドレスを返す。
## 引数１：		ネットワークアドレス化したいIPアドレス（文字列）
## 引数２：		ネットワークレンジを表すサブネットマスク
## 戻り値		配列。要素番号１⇒ネットワークアドレス、要素番号２⇒サブネットマスク
sub GetNetAddr{
	my $ipaddr;
	my $mask;
	($ipaddr, $mask ) = @_;
	
	my $netaddr;
	my $netmask;
	
	if( $ipaddr =~ /\d+\.\d+\.\d+\.\d+/ && $mask =~ /\d+\.\d+\.\d+\.\d+/ ){
		my @ipaddrs = split(/\./,$ipaddr);
		my @masks = split(/\./, $mask);
		
		my @netaddrs;
		my @netmasks;
		
		$netaddrs[0] = $ipaddrs[0] + 0 ;
		$netaddrs[1] = $ipaddrs[1] + 0 ;
		$netaddrs[2] = $ipaddrs[2] + 0 ;
		$netaddrs[3] = $ipaddrs[3] + 0 ;
		
		$netmasks[0] = $masks[0] + 0;
		$netmasks[1] = $masks[1] + 0;
		$netmasks[2] = $masks[2] + 0;
		$netmasks[3] = $masks[3] + 0;
		
		$netaddrs[0] = $netaddrs[0] & $netmasks[0];
		$netaddrs[1] = $netaddrs[1] & $netmasks[1];
		$netaddrs[2] = $netaddrs[2] & $netmasks[2];
		$netaddrs[3] = $netaddrs[3] & $netmasks[3];

		$netaddr = $netaddrs[0].".".$netaddrs[1].".".$netaddrs[2].".".$netaddrs[3];
		$netmask = $mask;
		return($netaddr, $netmask);

	}else{
		return("","");
	}

}




exit(0);




