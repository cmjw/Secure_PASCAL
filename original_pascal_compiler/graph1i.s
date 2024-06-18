# ---------------- Beginning of Generated Code --------------------
        .file   "foo"
        .text
        .globl graph1
        .type   graph1, @function
graph1:
.LFB0:
	.cfi_startproc
	pushq	%rbp              # save base pointer on stack
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp        # move stack pointer to base pointer
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
        subq	$48, %rsp 	  # make space for this stack frame
	movq	%rbx, %r9        # save %rbx (callee-saved) in %r9
# ------------------------- begin Your code -----------------------------
	movl	$0,%eax         	#  0 -> %eax
	movl	%eax,-32(%rbp)     	#  %eax -> i
.L1:
	movl	-32(%rbp),%eax     	#  i -> %eax
	movl	$32,%ecx         	#  32 -> %ecx
	cmpl	%ecx,%eax           	#  compare %eax - %ecx
	jle	.L3 			#  jump if     <=
	jmp	.L4 			#  jump 
.L3:
	movsd	.LC5(%rip),%xmm0   	#  0.062500 -> %xmm0
	movl	-32(%rbp),%eax     	#  i -> %eax
	cvtsi2sd	%eax,%xmm1    	#  float %eax -> %xmm1
	mulsd	%xmm1,%xmm0         	#  %xmm0 * %xmm1 -> %xmm0
	movsd	%xmm0,-48(%rbp)     	#  %xmm0 -> x
	movsd	-48(%rbp),%xmm0     	#  x -> %xmm0
	movsd	.LC666(%rip),%xmm1   	#  0.000000 -> %xmm1
	xorpd	%xmm1,%xmm0           	#  negate %xmm0
	call	exp@PLT          	#  exp()
	movsd	%xmm0,-8(%rbp)     	#  %xmm0 -> temp
	movsd	.LC6(%rip),%xmm0   	#  6.283180 -> %xmm0
	movsd	-48(%rbp),%xmm1     	#  x -> %xmm1
	mulsd	%xmm1,%xmm0         	#  %xmm0 * %xmm1 -> %xmm0
	call	sin@PLT          	#  sin()
	movsd	-8(%rbp),%xmm1     	#  temp -> %xmm1
	mulsd	%xmm0,%xmm1         	#  %xmm1 * %xmm0 -> %xmm1
	movsd	%xmm1,-40(%rbp)     	#  %xmm1 -> y
	movsd	.LC7(%rip),%xmm0   	#  32.000000 -> %xmm0
	movsd	-40(%rbp),%xmm1     	#  y -> %xmm1
	mulsd	%xmm1,%xmm0         	#  %xmm0 * %xmm1 -> %xmm0
	call	iround@PLT          	#  iround()
	movl	$34,%ecx         	#  34 -> %ecx
	addl	%ecx,%eax         	#  %eax + %ecx -> %eax
	movl	%eax,-28(%rbp)     	#  %eax -> n
.L0:
	leaq	.LC8(%rip),%rdi  	#  addr of literal .LC8
	call	write@PLT          	#  write()
	movl	-28(%rbp),%eax     	#  n -> %eax
	movl	$1,%ecx         	#  1 -> %ecx
	subl	%ecx,%eax         	#  %eax - %ecx -> %eax
	movl	%eax,-28(%rbp)     	#  %eax -> n
	movl	-28(%rbp),%eax     	#  n -> %eax
	movl	$0,%ecx         	#  0 -> %ecx
	cmpl	%ecx,%eax           	#  compare %eax - %ecx
	je	.L9 			#  jump if     ==
	jmp	.L0 			#  jump 
	jmp	.L10 			#  jump 
.L9:
.L10:
	leaq	.LC11(%rip),%rdi  	#  addr of literal .LC11
	call	writeln@PLT          	#  writeln()
	movl	-32(%rbp),%eax     	#  i -> %eax
	movl	$1,%ecx         	#  1 -> %ecx
	addl	%ecx,%eax         	#  %eax + %ecx -> %eax
	movl	%eax,-32(%rbp)     	#  %eax -> i
	jmp	.L1 			#  jump 
.L4:
# ----------------------- begin Epilogue code ---------------------------
	movq	%r9, %rbx        # restore %rbx (callee-saved) from %r9
        leave
        ret
        .cfi_endproc
.LFE0:
        .size   graph1, .-graph1
# ----------------- end Epilogue; Literal data follows ------------------
        .section        .rodata
	.align 16
.LC666:                    # constant for floating negation
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align  4
.LC8:
	.string	" "
	.align  4
.LC11:
	.string	"*"
	.align  8
.LC5:
	.long	0   	#  0.062500
	.long	1068498944
	.align  8
.LC6:
	.long	0   	#  6.283180
	.long	1075388922
	.align  8
.LC7:
	.long	0   	#  32.000000
	.long	1077936128

        .ident  "CS 375 Compiler - Spring 2020"
