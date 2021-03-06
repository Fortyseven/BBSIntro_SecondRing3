{$G+,A+,R-,S-,I-,D-,N-,E-}
Program RandomMix_ASMVersion;
Const
     seed1	:word=	$1234;
     seed2	:word=	$5678;
     seed3	:word=	$1234;
     seed4	:word=	$5678;
{Var
         z      :word;
         x      :byte;
Label
     Foo;}
Procedure Random; Assembler;
Asm
	mov	ax,ds:seed1
	mov	bx,ds:seed2
	mov	cx,ds:seed3
	mov	dx,ds:seed4
	add	ax,bx
	rol	ax,cl
	xor	ax,dx
	xchg	cl,ch
	add	bx,cx
	add	dx,bx
	add	cx,ax
	ror	bx,1
	sbb	ax,dx
	mov	ds:seed4,dx
	mov	ds:seed3,dx
	mov	ds:seed2,dx
	mov	ds:seed1,ax
End;

Begin
{       z:=random($FFFF);
       x:=random($FF);}
asm
@@St:     call random;
          push ax;
          call random;
          push ax;
	  shr al,1           {  �����This checks if 'z' is odd or not...}
	  jc @@J3;           {  �    due to text mode arch...}
          dec byte ptr [bp]; {  �}
@@J3:     mov ax,$B800;      { <�}
          mov es,ax;         { <�}
          pop bx;
          mov di, bx;        {  �����This plots the attribute in $B800...}
          pop bx
          mov dh, bh;        {  �}
          mov [es:di], dh;   { <�}
          mov dx,60h;        { <�}
          in al,dx;          {  �����Is ESC pressed????}
          cmp al,1;          {  �}
          jne @@St;          { <�}
          mov ax,$B800        {<�}
          mov es,ax;           {�}
          mov cx,4000          {�}
       @@J2:                   {�}
          mov di,cx;           {������'ClrScr'}
         mov byte ptr [es:di],0;{ �}
          loop @@J2;            {<�}
       end;
End.