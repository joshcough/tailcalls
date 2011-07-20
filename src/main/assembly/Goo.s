MAKE_A_MILLION:
	cmpl $999999, %eax
	je DONE
	jmp MORE
MORE:
	addl $2, %eax
	pushl $Generated_Label_1
	pushl %ebp
	movl %esp, %ebp
	jmp MAKE_A_MILLION
Generated_Label_1:
DONE:
	movl %ebp, %esp
	popl %ebp
	ret

