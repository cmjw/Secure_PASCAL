; genasm.lsp       Generate Assembly Code for X86    ; 09 Aug 13   

; Copyright (c) 2013 Gordon S. Novak Jr. and The University of Texas at Austin
    

; Routines for use with CS 375 Code Generation assignment for X86. 

; We assume Linux assembly language conventions.   

; 
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License  or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful 
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not  see <http://www.gnu.org/licenses/>.
 

; Written by Gordon S. Novak Jr. 

; 22 Jan 00; 24 Jan 00; 26 Jan 00; 28 Jan 00; 02 Feb 00; 04 Feb 00;
;   09 Feb 00; 17 Apr 00; 26 Apr 00; 13 Apr 01; 15 Aug 03; 05 Jul 12;
;   06 Jul 12; 10 Jul 12; 16 Jul 12; 18 Jul 12; 23 Jul 12; 24 Jul 12;
;   26 Jul 12; 31 Jul 12; 01 Aug 12; 03 Aug 12; 06 Aug 12; 07 Aug 12;
;   08 Aug 12; 10 Aug 12; 13 Aug 12; 14 May 13
  
; Define register constants

; Registers are numbered 0-31 for general registers, 32-63 for floating
(defvar RBASE 0)         ; First local register to use = %eax
(defvar RMAX  3)         ; Last  local register to use
(defvar FBASE 8)         ; First F register to use = %xmm0
(defvar FMAX  23)        ; Last  F register to use

; Define register names

(defvar  EAX   0)        ; General integer register
(defvar  RAX   0)        ; General integer register, 64-bit
(defvar  ECX   1)        ; General integer register
(defvar  EDX   2)        ; General integer register
(defvar  EBX   3)        ; General integer register, out of order:
                         ; since EBX is callee-saved, we put it last. 
(defvar  ESI   4)        ; Source Index for string
(defvar  EDI   5)        ; Destination Index for string
(defvar  ESP   6)        ; Stack Pointer
(defvar  RSP   6)        ; Stack Pointer, 64-bit
(defvar  EBP   7)        ; Base Pointer
(defvar  RBP   7)        ; Base Pointer, 64-bit
(defvar  XMM0  8)        ; Float register: function result
(defvar  XMM1  9)        ; Float register
(defvar  XMM2 10)        ; Float register

(defvar MINIMMEDIATE -2147483648)   ; Minimum value of immediate constant
(defvar MAXIMMEDIATE  2147483647)   ; Maximum value of immediate constant

; Define symbolic constants for kind of data

(defvar BYTE     0)
(defvar HALFWORD 1)
(defvar WORD     2)
(defvar FLOAT    3)
(defvar ADDR     4)

(defvar WORDSIZE      4)             ; Integer
(defvar FLOATSIZE     8)             ; Integer
(defvar POINTERSIZE  16)             ; Integer

; Define op code constants

(defvar  JMP  0)        ;  jump                 
(defvar  JNE  1)        ;  jump not equal       
(defvar  JE   2)        ;  jump equal           
(defvar  JGE  3)        ;  jump greater or equal
(defvar  JL   4)        ;  jump less            
(defvar  JG   5)        ;  jump greater         
(defvar  JLE  6)        ;  jump less or equal   

; Define op codes for other instructions

(defvar MOVL   0)      ; Move long (32 bits)
(defvar MOVSD  1)      ; Move double
(defvar MOVQ   2)      ; Move quad (64 bits)
(defvar CLTQ   3)      ; sign-extend eax to rax
(defvar ADDL   4)      ; Add integer
(defvar SUBL   5)      ; Subtract
(defvar IMULL  6)      ; Multiply
(defvar DIVL    7)
(defvar ANDL    8)
(defvar NEGL    9)
(defvar ORL    10)    ; OR

(defvar CMPL   12)

(defvar ADDSD  13)
(defvar SUBSD  14)
(defvar MULSD  15)
(defvar DIVSD  16)
(defvar NEGSD  17)
(defvar CMPQ   18)    ; cmpq s2,s1 compares based on (s1 - s2)
(defvar CMPSD  19)

; Print strings for registers 
; EBX is put in position 3 since it is callee-save 
(defvar regpr
'#("%eax"  "%ecx"  "%edx"  "%ebx" 
                 "%esi"  "%edi"  "%esp"  "%ebp" 
                 "%xmm0"   "%xmm1"    "%xmm2"   "%xmm3" 
                 "%xmm4"   "%xmm5"   "%xmm6"   "%xmm7" 
                 "%xmm8"   "%xmm9"   "%xmm10"  "%xmm11" 
                 "%xmm12"  "%xmm13"  "%xmm14"  "%xmm15" ))

; Print strings for 64-bit versions of registers 
(defvar  dregpr '#("%rax"  "%rcx"  "%rdx"  "%rbx" 
                  "%rsi"  "%rdi"  "%rsp"  "%rbp" ))

; Define jump op codes 
(defvar
 jumppr  '#("jmp"  "jne"  "je"  "jge"  "jl"  "jg"  "jle" ))

; Define jump comments 

(defvar jumpcompr  '#(""  "if     !="  "if     =="  "if     >="  "if     <" 
                      "if     >"  "if     <=" ))

; Define op codes for other instructions 

 (defvar instpr
;   0        1       2       3      4       5      6        7  
 '#("movl"  "movsd"  "movq"  "cltq"  "addl"  "subl"  "imull"  "divl" 
;   8     9     10       11     12     13       14      15  
  "andl"  "negl"  "orl"  "notl"  "cmpl"  "addsd"  "subsd"  "mulsd" 
;   16       17      18      19      
  "divsd" "negsd"  "cmpq"  "cmpsd"
        ))

;                    0     1      2   3    4    5    6    7  
(defvar instcompr '#("->"  "->"  "->"  "sign-extend"  "+"  "-"  "*"  "/" 
;                     8     9     10     11     12        13   14   15  
                     " and"  "-"  "or"  "notl"  "compare"  "+"  "-"  "*" 
;                     16    17      18      19      
                       "/"  "-"  "compare"  "compare" ))
(defvar topcode '(
  "# ---------------- Beginning of Generated Code --------------------" 
  ))

(defvar topcodeb '(
  ".LFB0:" 
  "	.cfi_startproc" 
  "	pushq	%rbp              # save base pointer on stack" 
  "	.cfi_def_cfa_offset 16" 
  "	movq	%rsp  %rbp        # move stack pointer to base pointer" 
  "	.cfi_offset 6  -16" 
  "	.cfi_def_cfa_register 6" 
  ))

(defvar topcodec '(
  "	movq	%rbx  %r9        # save %rbx (callee-saved) in %r9" 
  "# ------------------------- begin Your code -----------------------------" 
  ))

(defvar bottomcode '( 
  "# ----------------------- begin Epilogue code ---------------------------" 
  "	movq	%r9  %rbx        # restore %rbx (callee-saved) from %r9" 
  "        leave" 
  "        ret" 
  "        .cfi_endproc" 
  ".LFE0:" 
  ))

(defvar bottomcodeb '( 
  "# ----------------- end Epilogue Literal data follows ------------------" 
  "        .section        .rodata" 
  ))

(defvar bottomcodec '( 
  "        .ident  \"CS 375 Compiler - Summer 2013\"" 
  ; "        .section     .note.GNU-stack \"\" @progbits"  ; need this? 
  ))

; constant needed for floating negation 
(defvar fnegconst '(
  "	.align 16" 
  ".LC666:                    # constant for floating negation" 
  "	.long	0" 
  "	.long	-2147483648" 
  "	.long	0" 
  "	.long	0" 
  ))

; Tables of literal constants, implemented as alist (label value)
(defvar iliterals nil)
(defvar fliterals nil)
(defvar bliterals nil)

; make something into a string
(defun stringify (x)
  (if (stringp x)
      x
      (if (symbolp x)
	  (symbol-name x)
	  (princ-to-string x))))

; lower-case name
(defun lc (name) (string-downcase (stringify name)))

; Print a section of canned code.  Quits on an empty string.  
(defun cannedcode (lines)
  (let ()
    (dolist (ln lines) (format t "~A~%" ln) )
  ))

; Round up n to be a multiple of m 
(defun roundup (n m)
  (* (truncate (+ n m -1) m) m) )

;	movl	%eax,-28(%rbp)     	#  %eax -> lim
;1234567890123456789012345678901234567890

; Make entry code for a program. 
; name is entry name  size is size of local storage on stack frame. 
; returns actual stack frame size 
(defun asmentry (name size)
  (let (stackframesize)  
;     GCC requires stack aligned to 16-byte boundary 
;     Add to make space for a floating temporary just below rbp 
     (setq stackframesize (roundup (+ size 16) 16))
     (cannedcode topcode)          ; canned stuff at top 
     (format t "        .file   \"~A\"~%"  "foo")
     (format t "        .text~%")
     (format t ".globl ~A~%"  (lc name))
     (format t "        .type   ~A  @function~%" (lc name))
     (format t "~A:~%"  (lc name))
     (cannedcode topcodeb)
     (format t 
       "        subq~16T$%d, %rsp ~32T # make space for this stack frame~%" 
            stackframesize )
     (cannedcode topcodec)
     stackframesize
   ))

; Make exit code for a program. 
; This is just canned code following calling conventions for target machine 
(defun asmexit (name)
  (let ()
    (cannedcode bottomcode)
    (format t "        .size   ~A  .-~A~%"  name  name)
    (outlits)                         ; Output literals 
   ))

; Make a label 
(defun asmlabel (labeln)
  (let ()  (format t ".L~D:~%"  labeln)
   ))

; Subroutine call 
; Example:  asmcall(code->stringval)    Call function 
(defun asmcall (name)
  (let ()  (format t "~8Tcall~16T~A ~29T #  ~A()~%"  (lc name) (lc name))
  ))

; Generate a jump instruction.  Example:  (asmjump JG 17)
(defun asmjump (code labeln)
  (let ()
    (format t "~8T~A~16T.L~D ~29T #  jump ~A~%" 
          (aref jumppr code)  labeln  (aref jumpcompr code))  ))

; Get the right register name depending on instruction
; (regnm 2 movq)
(defun regnm (reg instr)
  (let ()
    (if (or (eql instr MOVQ) (eql instr CMPQ) )
        (aref dregpr reg)
        (aref regpr reg) ) ))

; Generate an immediate instruction: move an to a register   
; Example:  (asmimmed MOVL 3 2)   Moves 3 to reg  
; Example:  asmimmed(ADD  1  EAX)    Adds 1 to EAX  
(defun asmimmed(inst ival reg)
  (let ()
    (format t "~8T~A~16T$~D,~A"  (aref instpr inst)  ival  (regnm reg inst))
    (if (or (eql inst MOVL) (eql inst MOVSD) )
        (format t " ~29T#  ~D -> ~A~%"  ival  (regnm reg inst))
        (format t " ~29T#  ~A ~D -> ~A~%" 
                  (aref instcompr inst)  ival  (regnm reg inst)) )
  ))

; Generate an instruction with just the op. 
; Example:  asmop(CLTQ) 
(defun asmop(inst)
  (let ()
    (format t "~8T~A~16T ~29T #  ~A~%"  (aref instpr inst)  (aref instcompr inst))
    ))

; Generate a register to register instruction. 
; op rs rd     ADDL  
; Example:  (asmrr ADDL ECX EAX)  EAX + ECX -> EAX 
(defun asmrr(inst srcreg dstreg)
  (let ()
    (format t "~8T~A~16T~A,~A"  (aref instpr inst)  (regnm srcreg inst) 
           (regnm dstreg inst))
    (if (or (eql inst CMPL) (eql inst CMPQ) (eql inst CMPSD) )
        (format t " ~29T #  compare ~A - ~A~%"  (regnm dstreg inst) 
                (regnm srcreg inst))
        (if (or (eql inst MOVL) (eql inst MOVQ) (eql inst MOVSD) )
            (format t " ~29T #  ~A -> ~A~%" (aref regpr srcreg) (aref regpr dstreg))
            (format t " ~29T #  ~A ~A ~A -> ~A~%" (aref regpr dstreg)
                    (aref instcompr inst) (aref regpr srcreg) (aref regpr dstreg))
          ) )
    ))

; Generate a load instruction relative to RBP: 
; Example:  if code points to an integer variable 
;           asmld(MOVL  -code->symentry->offset  0  code->stringval)   
; (asmld movl -32 eax "i")
(defun asmld(inst off reg str)
  (let ()
   (format t "~8T~A~16T~D(%rbp),~A"  (aref instpr inst)  off  (regnm reg inst))
   (format t " ~29T #  ~A -> ~A~%"  str  (regnm reg inst))
  ))

; Generate a store instruction relative to RBP: 
; Example:  asmst(MOVL  EAX  -code->symentry->offset  code->stringval)  
; (asmst movl eax -32 "i")
(defun asmst(inst reg off str)
  (let ()
    (format t "~8T~A~16T~A,~D(%rbp)" (aref instpr inst) (regnm reg inst) off)
    (format t " ~29T #  ~A -> ~A~%"  (regnm reg inst)  str)
  ))

; Generate a floating store into a temporary on stack 
; Example:  (asmsttemp xmm0)
(defun asmsttemp( reg )
  (let ()
    (asmst MOVSD reg -8 "temp")
  ))

; Generate a floating from a temporary on stack 
; Example:  (asmldtemp xmm0)
(defun asmldtemp( reg )
  (let ()
    (asmld MOVSD  -8  reg "temp")
  ))

; Generate a load instruction using offset and a register: 
; Example:  asmldr(MOVL  4  RAX  ECX  code->stringval)  4(%rax) --> %ecx 
; (asmldr movl -9 rax ecx "x")
(defun asmldr(inst offset reg dstreg str)
  (let ()
    (format t "~8T~A~16T~D(~A),~A" (aref instpr inst) offset (aref dregpr reg) 
            (regnm dstreg inst))
    (format t " ~29T #  ~A[~D+~A] -> ~A~%"  str  offset  (aref dregpr reg) 
         (regnm dstreg inst))
  ))

; Generate a load instruction using offset  RBP and another register: **** check
; Example:
;   (asmldrr MOVL  -8  RAX  ECX  "x")  -8(%rbp %rax) --> %ecx 
(defun asmldrr(inst offset reg dstreg str)
  (let ()
    (format t "~8T~A~16T~D(%rbp,~A),~A" (aref instpr inst) offset (aref dregpr reg) 
            (regnm dstreg inst))
     (format t " ~29T #  ~A[~D] -> ~A~%" str offset (regnm dstreg inst))
  ))

; Generate a load instruction using offset  RBP and
;   another register with multiplier (2  4 or 8): 
; Example:
;   (asmldrrm MOVL  -8  RAX  4  ECX  "x") -8(%rbp %rax 4) --> %ecx 
(defun asmldrrm (inst offset reg mult dstreg str)
  (let ()
    (format t "~8T~A~16T~D(%rbp,~A,~D),~A" (aref instpr inst) offset
            (aref dregpr reg) mult (regnm dstreg inst))
    (format t " ~29T #  ~A[~D+%rbp+~A*~D] -> ~A~%" str offset (aref dregpr reg)
            mult(regnm dstreg inst))
  ))

; Generate a store instruction relative to a register: 
; Example:  (asmstr MOVL  ECX  4  RAX  "x")  %ecx --> 4(%rax) 
(defun asmstr (inst srcreg offset reg str)
  (let ()
    (format t "~8T~A~16T~A,~D(~A)" (aref instpr inst) (regnm srcreg inst) offset 
            (aref dregpr reg))
    (format t " ~29T #  ~A -> ~A[~D+~A]~%" (regnm srcreg inst) str offset 
            (aref dregpr reg))
  ))

; Generate a store instruction using offset  RBP and another register: 
; Example:
;   (asmstrr MOVL  ECX  -8  RAX  "x")  -8(%rbp %rax) --> %ecx 
(defun asmstrr (inst srcreg offset reg str)
  (let ()
    (format t "~8T~A~16T~A,~D(%rbp,~A)" (aref instpr inst) (regnm srcreg inst)
            offset (aref dregpr reg) )
    (format t " ~29T #  ~A -> ~A[~A]~%"  (regnm srcreg inst)  str 
            (aref dregpr reg))
  ))

; Generate a store instruction using offset  RBP and
;   another register with multiplier (2  4 or 8): 
; Example:
;   (asmstrrm MOVL  ECX  -8  RAX  4  "x") %ecx --> -8(%rbp %rax 4) 
(defun asmstrrm (inst srcreg offset reg mult str)
  (let ()
    (format t "~8T~A~16T~A,~D(%rbp,~A,~D)" (aref instpr inst) (regnm srcreg inst)
            offset (aref dregpr reg)  mult)
    (format t " ~29T #  ~A -> ~A[~D+%rbp+~A*~D]~%" (regnm srcreg inst) str 
            offset (aref dregpr reg) mult)
  ))

; Load float literal into specified register 
; Example:  (asmldflit MOVSD 7 XMM0)  literal with label .LC7 --> XMM0 
(defun asmldflit (inst label dstreg)
  (let (pair)
    (setq pair (assoc label fliterals))
    (format t "~8T~A~16T.LC~D(%rip),~A ~29T #  ~F -> ~A~%"  (aref instpr inst) 
               label (aref regpr dstreg) (or (cadr pair) 0.0) (aref regpr dstreg))
  ))

; Set up a literal address argument for subroutine call 
; Example:  (asmlitarg 8 EDI)   addr of literal 8 --> %edi 
(defun asmlitarg(labeln  dstreg)
  (let ()
    (format t "~8Tmovl~16T$.LC~D,~A ~29T #  addr of literal .LC~D~%" 
                labeln  (aref regpr dstreg)  labeln)
  ))

; Generate a left-shift instruction to shift left n bits  zero fill.   
; Example:  (asmlshift EAX 3 EAX)     L1 shifted left 3 bits --> L1 
(defun asmlshift (srcreg n dstreg)
  (let ()
    (format t "~8Tsll~16T~A,~D,~A ~29T #  shift left ~D~%"  (aref regpr srcreg)  n 
             (aref regpr dstreg)  n)
  ))

; Generate instructions to float data from an integer register to F reg. 
; reg is integer source  freg is double float destination register.
; (asmfloat EAX XMM0)
(defun asmfloat (reg freg)
  (let ()
    (format t "~8Tcvtsi2sd ~16T~A,~A    ~29T #  float ~A -> ~A~%"  (aref regpr reg) 
              (aref regpr freg)  (aref regpr reg)  (aref regpr freg))
  ))

; Generate instruction to fix data from float register freg to reg. 
; reg is integer source  freg is double float destination register.
; (asmfix XMM0 EAX) 
(defun asmfix (freg reg)
  (let ()
    (format t "~8Tcvttsd2si ~16T~A,~A    ~29T #  fix ~A -> ~A~%"  (aref regpr freg) 
              (aref regpr reg)  (aref regpr freg)  (aref regpr reg))
  ))

; Generate instructions to negate a float reg. 
; reg is value to be negated  extrareg is another float register.
; (asmfneg XMM1 XMM0)
(defun asmfneg (reg extrareg)
  (let ()
    (asmldflit MOVSD 666 extrareg)
    (format t "~8Txorpd~16T~A,~A           ~29T #  negate ~A~%" 
              (aref regpr extrareg)  (aref regpr reg)  (aref regpr reg))
  ))

; Make a literal for integer n with label number labeln 
(defun makeilit (n labeln)
  (push (list labeln n) iliterals))

; Make a literal for float f with label number labeln 
(defun makeflit (f labeln)
  (push (list labeln f) fliterals))

; Make a literal for byte string s with label number labeln 
(defun makeblit (s labeln)
  (push (list labeln s) bliterals))

; Output literals 
(defun outlits()
  (let ()
    (cannedcode bottomcodeb)
    (cannedcode fnegconst)
  (dolist (pair (reverse iliterals))
    (format t "~8T.align~16T4~%")
    (format t ".LC~d:~%" (first pair))
    (format t "~8T.long~16T0x~x   ~40T# ~d~%" (second pair) (second pair))
    )
  (dolist (pair (reverse bliterals))
    (format t "~8T.align~16T4~%")
    (format t ".LC~d:~%" (first pair))
    (format t "~8T.string~16T\"~A\\0\"~%" (second pair))
    )
  (dolist (pair (reverse fliterals))
    (format t "~8T.align~16T8~%")
    (format t ".LC~d:~%" (first pair))
    (format t "~8T.long~16T0x~x ~29T #  ~e~%" (righth (second pair)) (second pair))
    (format t "~8T.long~16T0x~x ~%" (lefth (second pair)) )
    )
   ))

; the following are kludges to simulate getting the two halves of a double
; float as integers.
(defun righth (x) 0)
(defun lefth (x)
  (let (pair)
    (if (setq pair
	      (assoc x '((0.0625   1068498944)
			 (0.3      1070805811)
                         (3.0      1074266112)
                         (3.14     1074339512)
                         (4.5      1074921472)
                         (6.28318  1075388922)
			 (32.0     1077936128)
                         (40000.0  1088653312)
                        )
		     :test #'(lambda (u v) (< (abs (- u v)) 0.0001))) )
	(cadr pair)
        0)))
