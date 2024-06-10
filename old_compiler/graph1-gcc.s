	.file	"graph1.c"
	.section	.rodata
.LC5:
	.string	" "
.LC6:
	.string	"*"
	.text
.globl graph1
	.type	graph1, @function
graph1:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	$0, -4(%rbp)
	jmp	.L2
.L4:
	cvtsi2sd	-4(%rbp), %xmm0
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm1
	movsd	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	call	exp
	movsd	%xmm0, -40(%rbp)
	movsd	-16(%rbp), %xmm1
	movsd	.LC2(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	call	sin
	mulsd	-40(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	call	round
	movsd	.LC4(%rip), %xmm1
	addsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	movl	%eax, -8(%rbp)
.L3:
	movl	$.LC5, %edi
	movl	$0, %eax
	call	write
	subl	$1, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jg	.L3
	movl	$.LC6, %edi
	movl	$0, %eax
	call	writeln
	addl	$1, -4(%rbp)
.L2:
	cmpl	$32, -4(%rbp)
	jle	.L4
	leave
	ret
	.cfi_endproc
.LFE0:
	.size	graph1, .-graph1
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1068498944
	.align 16
.LC1:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC2:
	.long	4028335726
	.long	1075388921
	.align 8
.LC3:
	.long	0
	.long	1077936128
	.align 8
.LC4:
	.long	0
	.long	1078001664
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
