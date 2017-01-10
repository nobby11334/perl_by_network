########################################################
# �L���v�`�����O�t�@�C������IP�A�h���X���l�b�g���[�N�A�h���X�ɕϊ�����B
#
# �E������	�F	�L���v�`�����O�t�@�C��
# �E������	�F	�l�b�g���[�N�A�h���X���X�g
#
#	�쐬��		�F	2015/05/07	�M�{
#
#	�X�V��		�F	


if ( @ARGV > 1 ){
	my $tgtcapfile = $ARGV[0];
	my $tgtnetfile = $ARGV[1];
	
	my @restxt;
	open(CAPFILE, "<".$tgtcapfile) or die "$!";
	
	
	foreach my $capline (<CAPFILE>){
		####### �L���v�`���t�@�C����IP�A�h���X�𒊏o #######
		if( $capline =~ /(\d+\.\d+\.\d+\.\d+)\s+<->\s+(\d+\.\d+\.\d+\.\d+)/){
#			print $1.":::::".$2."\n";
#			my $mask = "255.255.255.0";
			my $capsrcaddr = $1;
			my $capdstaddr = $2;

			## �߂�l�i�[�ϐ�����
			#		���M�����p		#
			my $srccategory;
			my $srclocation;
			my $srcsegname;
			
			my $capsrcnetaddr;
			my $capsrcnetmask;
			my $flgSrcConvCmp = 0;

			#		���M����p		#
			my $dstcategory;
			my $dstslocation;
			my $dstsegname;
			
			my $capdstnetaddr;
			my $capdstnetmask;
			my $flgDstConvCmp = 0;
			## �߂�l�i�[�ϐ�����
			
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
				## �L���v�`���A�h���X�̃l�b�g���[�N�A�h���X�ƃJ�����g�̃l�b�g
				## ���[�N�A�h���X�̔�r�isource �A�h���X�j
				if($flgSrcConvCmp < 1){
					($capsrcnetaddr, $capsrcnetmask) = &GetNetAddr( $capsrcaddr, $netmask);
					
					
					
	#				print $capsrcnetaddr.":::::".$capsrcnetmask."\n";
					## �l�b�g���[�N�A�h���X�I�ɓ������ꍇ
					if($capsrcnetaddr eq $netaddr){

						if($flgSrcConvCmp < 1){
							## ���̂܂ܕύX��source�A�h���X�Ƃ��č̗p����B
							$capsrcnetaddr = $capsrcnetaddr;
							$capsrcnetmask = $netmask;
		#					$capsrcnetmask = $capsrcnetmask;
							
							## ���_�����擾����B
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
				
				## �L���v�`���A�h���X�̃l�b�g���[�N�A�h���X�ƃJ�����g�̃l�b�g
				## ���[�N�A�h���X�̔�r�idestination �A�h���X�j
				if($flgDstConvCmp < 1){
					($capdstnetaddr, $capdstnetmask) = &GetNetAddr( $capdstaddr, $netmask);
	#				print $capdstaddr."/".$netmask."=".$capdstnetaddr."\n";
					## �l�b�g���[�N�A�h���X�I�ɓ������ꍇ
					if($capdstnetaddr eq $netaddr){
						if($flgDstConvCmp < 1){
							## ���̂܂ܕύX��destination�A�h���X�Ƃ��č̗p����B
							$capdstnetaddr = $capdstnetaddr;
							$capdstnetmask = $netmask;
		#					$capdstnetmask = $capdstnetmask;
							
							## ���_�����擾����B
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

			#### �o�̓t�H�[�}�b�g�ɏ]���W���o�͂֏o�͂��� ####
			####	[�V�X�e����],[�ݒu���_���t���A],[IP�A�h���X],
#			print $capsrcnetaddr."/".$capsrcnetmask." <-> ".$capdstnetaddr."/".$capdstnetmask."\n";
			my @srcaddrSplits = split(/\./, $capsrcnetaddr);
			my $outputLine = "";



			## ���M���̓��{��̏����擾
			$outputLine = $srcsegname.",".$srccategory.",".$srclocation;
			
			## ���M���A�h���X�����擾
			$outputLine = $outputLine.",".$srcaddrSplits[0].",".$srcaddrSplits[1].",".$srcaddrSplits[2].",".$srcaddrSplits[3];
			
			## ���M���T�u�l�b�g�}�X�N���擾
			$outputLine = $outputLine.",".$capsrcnetmask;
			
			## ���M��̓��{��̏����擾
			my @dstaddrSplits = split(/\./, $capdstnetaddr);
			$outputLine = $outputLine.",".$dstsegname.",".$dstcategory.",".$dstlocation;
			
			## ���M��A�h���X�����擾
			$outputLine = $outputLine.",".$dstaddrSplits[0].",".$dstaddrSplits[1].",".$dstaddrSplits[2].",".$dstaddrSplits[3];
			
			## ���M��T�u�l�b�g�}�X�N���擾
			$outputLine = $outputLine.",".$capdstnetmask;

			chomp($outputLine);
#			print $capsrcnetaddr."\n";\

			print $outputLine."\n";
		}
	}
	
	close(CAPFILE);
	

}else{
	print "�t�@�C���̎w�肪����܂���B";

}

## IP�A�h���X�ƃT�u�l�b�g�}�X�N�������Ƃ��A�l�b�g���[�N�A�h���X��Ԃ��B
## �����P�F		�l�b�g���[�N�A�h���X��������IP�A�h���X�i������j
## �����Q�F		�l�b�g���[�N�����W��\���T�u�l�b�g�}�X�N
## �߂�l		�z��B�v�f�ԍ��P�˃l�b�g���[�N�A�h���X�A�v�f�ԍ��Q�˃T�u�l�b�g�}�X�N
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




