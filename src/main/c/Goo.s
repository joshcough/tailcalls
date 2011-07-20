	.text
.globl _sumExample
_sumExample:
LFB3:
	pushq	%rbp
LCFI0:
	movq	%rsp, %rbp
LCFI1:
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-8(%rbp), %eax
	addl	-4(%rbp), %eax
	leave
	ret
LFE3:
	.cstring
LC0:
	.ascii "%i\0"
	.text
.globl _main
_main:
LFB4:
	pushq	%rbp
LCFI2:
	movq	%rsp, %rbp
LCFI3:
	movl	$6, %esi
	movl	$5, %edi
	call	_sumExample
	movl	%eax, %esi
	leaq	LC0(%rip), %rdi
	movl	$0, %eax
	call	_printf
	movl	$0, %eax
	leave
	ret
LFE4:
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0x0
	.byte	0x1
	.ascii "zR\0"
	.byte	0x1
	.byte	0x78
	.byte	0x10
	.byte	0x1
	.byte	0x10
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.byte	0x90
	.byte	0x1
	.align 3
LECIE1:
.globl _sumExample.eh
_sumExample.eh:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB3-.
	.set L$set$2,LFE3-LFB3
	.quad L$set$2
	.byte	0x0
	.byte	0x4
	.set L$set$3,LCFI0-LFB3
	.long L$set$3
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE1:
.globl _main.eh
_main.eh:
LSFDE3:
	.set L$set$5,LEFDE3-LASFDE3
	.long L$set$5
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB4-.
	.set L$set$6,LFE4-LFB4
	.quad L$set$6
	.byte	0x0
	.byte	0x4
	.set L$set$7,LCFI2-LFB4
	.long L$set$7
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$8,LCFI3-LCFI2
	.long L$set$8
	.byte	0xd
	.byte	0x6
	.align 3
LEFDE3:
	.subsections_via_symbols
