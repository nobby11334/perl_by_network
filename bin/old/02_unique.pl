## �t�@�C���̓��e���\�[�g���ă��j�[�N�ɂ���B
## �����P�F		�\�[�g�����j�[�N�ɂ������t�@�C���̃t���p�X�i������j
## �߂�l		�W���o�͂֎w��̃t�@�C���̃\�[�g�����j�[�N�̌��ʂ��o��
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




