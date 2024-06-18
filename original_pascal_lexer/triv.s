# ---------------- Beginning of Generated Code --------------------
        .file   "foo"
        .text
.globl graph1
        .type   graph1, @function
graph1:
.LFB0:
        .cfi_startproc
        pushq   %rbp              # save base pointer on stack
        .cfi_def_cfa_offset 16
        movq    %rsp, %rbp        # move stack pointer to base pointer
        .cfi_offset 6, -16
        .cfi_def_cfa_register 6
        subq    $32, %rsp         # make space for this stack frame
        movq    %rbx, %r9        # save %rbx (callee-saved) in %r9
# ------------------------- begin Your code -----------------------------
        movl    $3,%eax                 #  3 -> %eax
        movl    %eax,-32(%rbp)          #  %eax -> i
# ----------------------- begin Epilogue code ---------------------------
        movq    %r9, %rbx        # restore %rbx (callee-saved) from %r9
        leave
        ret
        .cfi_endproc
.LFE0:
        .size   graph1, .-graph1
# ----------------- end Epilogue; Literal data follows ------------------
        .section        .rodata

        .ident  "CS 375 Compiler - Fall 2017"
