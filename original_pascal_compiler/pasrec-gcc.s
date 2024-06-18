	.file	"pasrec.c"
	.section	.rodata
.LC3:
	.string	"i = %d\n"
.LC4:
	.string	"Sum of ages = %d\n"
.LC5:
	.string	"Fred loc im = %f\n"
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
	subq	$1328, %rsp
	movl	$48, %edi
	call	malloc
	movq	%rax, -24(%rbp)
	movl	$48, %edi
	call	malloc
	movq	%rax, -32(%rbp)
	movl	$48, %edi
	call	malloc
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	movl	$2, 32(%rax)
	movq	-24(%rbp), %rax
	movl	$19, (%rax)
.L2:
	movq	-24(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-24(%rbp), %rax
	movabsq	$4675730371722084352, %rdx
	movq	%rdx, 40(%rax)
	movq	-24(%rbp), %rax
	movabsq	$4613937818241073152, %rdx
	movq	%rdx, 16(%rax)
	movq	-32(%rbp), %rax
	movl	$21, (%rax)
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, 8(%rax)
	jmp	.L3
.L8:
	nop
.L3:
	movq	-40(%rbp), %rax
	movl	$20, (%rax)
	movq	-40(%rbp), %rax
	movq	$0, 8(%rax)
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	8(%rax), %rax
	movabsq	$4616752568008179712, %rdx
	movq	%rdx, 24(%rax)
	movq	-24(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, -272(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	$0, -8(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L4
.L5:
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	addl	%eax, -8(%rbp)
	movl	-4(%rbp), %edx
	movq	-48(%rbp), %rax
	movl	(%rax), %ecx
	movslq	%edx,%rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	leaq	0(%rbp,%rax), %rax
	subq	$1328, %rax
	movl	%ecx, (%rax)
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	32(%rax), %ecx
	movslq	%edx,%rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$1, %rax
	movl	%ecx, -208(%rbp,%rax,4)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -48(%rbp)
	addl	$1, -4(%rbp)
.L4:
	cmpq	$0, -48(%rbp)
	jne	.L5
	movl	$.LC3, %eax
	movl	-4(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$.LC4, %eax
	movl	-8(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movq	-40(%rbp), %rax
	movsd	24(%rax), %xmm0
	movl	$.LC5, %eax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf
	cmpl	$2, -8(%rbp)
	jle	.L8
.L7:
	leave
	ret
	.cfi_endproc
.LFE0:
	.size	graph1, .-graph1
.globl main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	movl	$0, %eax
	call	graph1
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
