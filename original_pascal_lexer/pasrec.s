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
        subq	$1344, %rsp 	  # make space for this stack frame
	movq	%rbx, %r9        # save %rbx (callee-saved) in %r9
# ------------------------- begin Your code -----------------------------
	movl	$48,%eax         	#  48 -> %eax
	movl	%eax,%edi         	#  %eax -> %edi
	call	new@PLT          	#  new()
	movq	%rax,-1016(%rbp)     	#  %rax -> john
	movl	$48,%eax         	#  48 -> %eax
	movl	%eax,%edi         	#  %eax -> %edi
	call	new@PLT          	#  new()
	movq	%rax,-1008(%rbp)     	#  %rax -> mary
	movl	$48,%eax         	#  48 -> %eax
	movl	%eax,%edi         	#  %eax -> %edi
	call	new@PLT          	#  new()
	movq	%rax,-1000(%rbp)     	#  %rax -> fred
	movl	$2,%eax         	#  2 -> %eax
	movq	-1016(%rbp),%rcx     	#  john -> %rcx
	movl	%eax,32(%rcx)         	#  %eax -> ^. [32+%rcx]
	movl	$19,%eax         	#  19 -> %eax
	movq	-1016(%rbp),%rcx     	#  john -> %rcx
	movl	%eax,0(%rcx)         	#  %eax -> ^. [0+%rcx]
.L1:
	movq	-1008(%rbp),%rax     	#  mary -> %rax
	movq	-1016(%rbp),%rcx     	#  john -> %rcx
	movq	%rax,8(%rcx)         	#  %rax -> ^. [8+%rcx]
	movsd	.LC4(%rip),%xmm0   	#  40000.000000 -> %xmm0
	movq	-1016(%rbp),%rax     	#  john -> %rax
	movsd	%xmm0,40(%rax)         	#  %xmm0 -> ^. [40+%rax]
	movsd	.LC5(%rip),%xmm0   	#  3.000000 -> %xmm0
	movq	-1016(%rbp),%rax     	#  john -> %rax
	movsd	%xmm0,16(%rax)         	#  %xmm0 -> ^. [16+%rax]
	movl	$21,%eax         	#  21 -> %eax
	movq	-1008(%rbp),%rcx     	#  mary -> %rcx
	movl	%eax,0(%rcx)         	#  %eax -> ^. [0+%rcx]
	movq	-1000(%rbp),%rax     	#  fred -> %rax
	movq	-1008(%rbp),%rcx     	#  mary -> %rcx
	movq	%rax,8(%rcx)         	#  %rax -> ^. [8+%rcx]
.L0:
	movl	$20,%eax         	#  20 -> %eax
	movq	-1000(%rbp),%rcx     	#  fred -> %rcx
	movl	%eax,0(%rcx)         	#  %eax -> ^. [0+%rcx]
	movq	$0,%rax         	#  0 -> %rax
	movq	-1000(%rbp),%rcx     	#  fred -> %rcx
	movq	%rax,8(%rcx)         	#  %rax -> ^. [8+%rcx]
	movsd	.LC6(%rip),%xmm0   	#  4.500000 -> %xmm0
	movq	-1016(%rbp),%rax     	#  john -> %rax
	movq	8(%rax),%rcx         	#  ^.[8+%rax] -> %rcx
	movq	8(%rcx),%rax         	#  ^.[8+%rcx] -> %rax
	movsd	%xmm0,24(%rax)         	#  %xmm0 -> ^. [24+%rax]
	movq	-1016(%rbp),%rax     	#  john -> %rax
	movsd	40(%rax),%xmm0         	#  ^.[40+%rax] -> %xmm0
	movl	$96,%eax         	#  96 -> %eax
	cltq	                  	#  sign-extend
	movsd	%xmm0,-1296(%rbp,%rax)	#  %xmm0 -> ac[%rax]
	movq	-1016(%rbp),%rax     	#  john -> %rax
	movq	%rax,-992(%rbp)     	#  %rax -> ptr
	movl	$0,%eax         	#  0 -> %eax
	movl	%eax,-1308(%rbp)     	#  %eax -> sum
	movl	$1,%eax         	#  1 -> %eax
	movl	%eax,-1312(%rbp)     	#  %eax -> i
.L2:
	movq	-992(%rbp),%rax     	#  ptr -> %rax
	movq	$0,%rcx         	#  0 -> %rcx
	cmpq	%rcx,%rax           	#  compare %rax - %rcx
	jne	.L7 			#  jump if     !=
	jmp	.L8 			#  jump 
.L7:
	movl	-1308(%rbp),%eax     	#  sum -> %eax
	movq	-992(%rbp),%rcx     	#  ptr -> %rcx
	movl	0(%rcx),%edx         	#  ^.[0+%rcx] -> %edx
	addl	%edx,%eax         	#  %eax + %edx -> %eax
	movl	%eax,-1308(%rbp)     	#  %eax -> sum
	movq	-992(%rbp),%rax     	#  ptr -> %rax
	movl	0(%rax),%ecx         	#  ^.[0+%rax] -> %ecx
	movl	$-48,%eax         	#  -48 -> %eax
	movl	$48,%edx         	#  48 -> %edx
	movl	-1312(%rbp),%ebx     	#  i -> %ebx
	imull	%ebx,%edx         	#  %edx * %ebx -> %edx
	addl	%edx,%eax         	#  %eax + %edx -> %eax
	cltq	                  	#  sign-extend
	movl	%ecx,-976(%rbp,%rax)	#  %ecx -> people[%rax]
	movq	-1016(%rbp),%rax     	#  john -> %rax
	movl	32(%rax),%ecx         	#  ^.[32+%rax] -> %ecx
	movl	$-8,%eax         	#  -8 -> %eax
	movl	$12,%edx         	#  12 -> %edx
	movl	-1312(%rbp),%ebx     	#  i -> %ebx
	imull	%ebx,%edx         	#  %edx * %ebx -> %edx
	addl	%edx,%eax         	#  %eax + %edx -> %eax
	cltq	                  	#  sign-extend
	movl	%ecx,-1136(%rbp,%rax)	#  %ecx -> aco[%rax]
	movq	-992(%rbp),%rax     	#  ptr -> %rax
	movq	8(%rax),%rcx         	#  ^.[8+%rax] -> %rcx
	movq	%rcx,-992(%rbp)     	#  %rcx -> ptr
	movl	-1312(%rbp),%eax     	#  i -> %eax
	movl	$1,%ecx         	#  1 -> %ecx
	addl	%ecx,%eax         	#  %eax + %ecx -> %eax
	movl	%eax,-1312(%rbp)     	#  %eax -> i
	jmp	.L2 			#  jump 
.L8:
	leaq	.LC9(%rip),%rdi  	#  addr of literal .LC9
	call	write@PLT          	#  write()
	movl	-1312(%rbp),%eax     	#  i -> %eax
	movl	%eax,%edi         	#  %eax -> %edi
	call	writelni@PLT          	#  writelni()
	leaq	.LC10(%rip),%rdi  	#  addr of literal .LC10
	call	write@PLT          	#  write()
	movl	-1308(%rbp),%eax     	#  sum -> %eax
	movl	%eax,%edi         	#  %eax -> %edi
	call	writelni@PLT          	#  writelni()
	leaq	.LC11(%rip),%rdi  	#  addr of literal .LC11
	call	write@PLT          	#  write()
	movq	-1000(%rbp),%rax     	#  fred -> %rax
	movsd	24(%rax),%xmm0         	#  ^.[24+%rax] -> %xmm0
	call	writelnf@PLT          	#  writelnf()
	movl	-1308(%rbp),%eax     	#  sum -> %eax
	movl	$3,%ecx         	#  3 -> %ecx
	cmpl	%ecx,%eax           	#  compare %eax - %ecx
	jl	.L12 			#  jump if     <
	jmp	.L13 			#  jump 
.L12:
	jmp	.L0 			#  jump 
.L13:
# ----------------------- begin Epilogue code ---------------------------
	movq	%r9, %rbx        # restore %rbx (callee-saved) from %r9
        leave
        ret
        .cfi_endproc
.LFE0:
        .size   graph1, .-graph1
# ----------------- end Epilogue; Literal data follows ------------------
        .section        .rodata
	.align  4
.LC9:
	.string	"i = "
	.align  4
.LC10:
	.string	"Sum of ages = "
	.align  4
.LC11:
	.string	"Fred loc im = "
	.align  8
.LC4:
	.long	0   	#  40000.000000
	.long	1088653312
	.align  8
.LC5:
	.long	0   	#  3.000000
	.long	1074266112
	.align  8
.LC6:
	.long	0   	#  4.500000
	.long	1074921472

        .ident  "CS 375 Compiler - Spring 2024"
