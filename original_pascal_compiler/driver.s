	.file	"driver.c"
	.section	.rodata
.LC0:
	.string	"calling graph1"
.LC1:
	.string	"exit from graph1"
	.text
.globl main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	movl	$.LC0, %edi
	call	puts
	movl	$0, %eax
	call	graph1
	movl	$.LC1, %edi
	call	puts
	leave
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
.LC2:
	.string	"%s"
	.text
.globl write
	.type	write, @function
write:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$.LC2, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	leave
	ret
	.cfi_endproc
.LFE1:
	.size	write, .-write
.globl writeln
	.type	writeln, @function
writeln:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	puts
	leave
	ret
	.cfi_endproc
.LFE2:
	.size	writeln, .-writeln
	.section	.rodata
.LC3:
	.string	"%g"
	.text
.globl writef
	.type	writef, @function
writef:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	movl	$.LC3, %eax
	movsd	-8(%rbp), %xmm0
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf
	leave
	ret
	.cfi_endproc
.LFE3:
	.size	writef, .-writef
	.section	.rodata
.LC4:
	.string	"%d"
	.text
.globl writei
	.type	writei, @function
writei:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	$.LC4, %eax
	movl	-4(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	leave
	ret
	.cfi_endproc
.LFE4:
	.size	writei, .-writei
	.section	.rodata
.LC5:
	.string	"%g\n"
	.text
.globl writelnf
	.type	writelnf, @function
writelnf:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	movl	$.LC5, %eax
	movsd	-8(%rbp), %xmm0
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf
	leave
	ret
	.cfi_endproc
.LFE5:
	.size	writelnf, .-writelnf
	.section	.rodata
.LC6:
	.string	"%d\n"
	.text
.globl writelni
	.type	writelni, @function
writelni:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	$.LC6, %eax
	movl	-4(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	leave
	ret
	.cfi_endproc
.LFE6:
	.size	writelni, .-writelni
.globl new
	.type	new, @function
new:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc
	leave
	ret
	.cfi_endproc
.LFE7:
	.size	new, .-new
.globl iround
	.type	iround, @function
iround:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	movsd	%xmm0, -24(%rbp)
	xorpd	%xmm1, %xmm1
	movsd	-24(%rbp), %xmm0
	ucomisd	%xmm1, %xmm0
	setae	%al
	testb	%al, %al
	je	.L18
	movsd	-24(%rbp), %xmm1
	movsd	.LC8(%rip), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	movl	%eax, -4(%rbp)
	jmp	.L19
.L18:
	movsd	-24(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	movl	%eax, -4(%rbp)
.L19:
	movl	-4(%rbp), %eax
	leave
	ret
	.cfi_endproc
.LFE8:
	.size	iround, .-iround
	.section	.rodata
.LC9:
	.string	" x = %e     sin x = %e\n"
	.text
.globl trsin
	.type	trsin, @function
trsin:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	call	sin
	unpcklpd	%xmm0, %xmm0
	cvtpd2ps	%xmm0, %xmm0
	movss	%xmm0, -4(%rbp)
	movss	-4(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movl	$.LC9, %eax
	movsd	-24(%rbp), %xmm2
	movapd	%xmm0, %xmm1
	movapd	%xmm2, %xmm0
	movq	%rax, %rdi
	movl	$2, %eax
	call	printf
	movl	-4(%rbp), %eax
	movl	%eax, -36(%rbp)
	movss	-36(%rbp), %xmm0
	leave
	ret
	.cfi_endproc
.LFE9:
	.size	trsin, .-trsin
	.section	.rodata
.LC10:
	.string	" x = %e     exp x = %e\n"
	.text
.globl trexp
	.type	trexp, @function
trexp:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	call	exp
	unpcklpd	%xmm0, %xmm0
	cvtpd2ps	%xmm0, %xmm0
	movss	%xmm0, -4(%rbp)
	movss	-4(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movl	$.LC10, %eax
	movsd	-24(%rbp), %xmm2
	movapd	%xmm0, %xmm1
	movapd	%xmm2, %xmm0
	movq	%rax, %rdi
	movl	$2, %eax
	call	printf
	movl	-4(%rbp), %eax
	movl	%eax, -36(%rbp)
	movss	-36(%rbp), %xmm0
	leave
	ret
	.cfi_endproc
.LFE10:
	.size	trexp, .-trexp
	.section	.rodata
.LC11:
	.string	" new(%d) = %ld\n"
	.text
.globl trnew
	.type	trnew, @function
trnew:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	new
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movl	$.LC11, %eax
	movl	-20(%rbp), %ecx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movq	-8(%rbp), %rax
	leave
	ret
	.cfi_endproc
.LFE11:
	.size	trnew, .-trnew
	.section	.rodata
	.align 8
.LC8:
	.long	0
	.long	1071644672
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
