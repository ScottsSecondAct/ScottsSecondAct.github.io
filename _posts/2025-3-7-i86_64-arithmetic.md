---
layout: post
title: A Guide to x64 Arithmetic Instructions
tags: computer_engineering, computer_science, assembly_language
---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Assembler Setup](#assembler-setup)
- [ADD Instruction](#add-instruction)
  - [Example 1: Register, Register](#example-1-register-register)
  - [Example 2: Register, Immediate](#example-2-register-immediate)
  - [Example 3: Memory, Register](#example-3-memory-register)
  - [Example 4: Register, Memory (Complex Addressing)](#example-4-register-memory-complex-addressing)
- [SUB Instruction](#sub-instruction)
  - [Example 1: Register, Register](#example-1-register-register-1)
  - [Example 2: Register, Immediate](#example-2-register-immediate-1)
  - [Example 3: Memory, Register](#example-3-memory-register-1)
  - [Example 4: Register, Memory (Complex Addressing)](#example-4-register-memory-complex-addressing-1)
- [MUL Instruction](#mul-instruction)
  - [Example 1: Unsigned Multiply Register](#example-1-unsigned-multiply-register)
  - [Example 2: Unsigned Multiply Memory](#example-2-unsigned-multiply-memory)
- [IMUL Instruction](#imul-instruction)
  - [Example 1: One Operand (Signed)](#example-1-one-operand-signed)
  - [Example 2: Two Operands (Destination, Source)](#example-2-two-operands-destination-source)
  - [Example 3: Three Operands](#example-3-three-operands)
- [DIV Instruction](#div-instruction)
- [IDIV Instruction](#idiv-instruction)
- [Sample Putting It All Together](#sample-putting-it-all-together)
- [Appendix: 8-bit, 16-bit, and 32-bit Arithmetic Variants](#appendix-8-bit-16-bit-and-32-bit-arithmetic-variants)
  - [8-bit Arithmetic](#8-bit-arithmetic)
  - [16-bit Arithmetic](#16-bit-arithmetic)
  - [32-bit Arithmetic](#32-bit-arithmetic)

## Assembler Setup

1. **`.intel_syntax noprefix`:** This directive specifies Intel syntax without register prefixes.
2. **64-bit code:** Use `as --64` for 64-bit mode. When linking, ensure you link for 64-bit binaries as well.

Below is a skeleton for our examples:

{% highlight nasm %}
.intel_syntax noprefix      # Use Intel syntax, no % prefix for registers

.data
val1: .quad 10
val2: .quad 20

.text                       # Place code in the .text section

.global _start              # Define entry point for the linker

_start:
    # Your assembly code goes here

    # Example exit routine:
    mov rax, 60             # 60 is the sys_exit syscall number on x86_64 Linux
    xor rdi, rdi            # Set exit code to 0
    syscall
{% endhighlight %}

Example commands to assemble and link:
{% highlight bash %}
as --64 -o myfile.o myfile.asm
ld -o myprog myfile.o
./myprog
{% endhighlight %}

## ADD Instruction

The `add` instruction performs an addition of the second operand to the first operand. The result is stored in the first operand. Valid permutations include register-to-register, register-to-immediate, memory-to-register, and register-to-memory.

### Example 1: Register, Register

{% highlight nasm %}
add rax, rbx                # rax = rax + rbx
{% endhighlight %}

### Example 2: Register, Immediate

{% highlight nasm %}
add rbx, 0x10               # rbx = rbx + 0x10
{% endhighlight %}

### Example 3: Memory, Register

- Uses the 64-bit value at memory location rax.

{% highlight nasm %}
add [val1], rbx             # [val1] = [val2] + rbx
{% endhighlight %}

### Example 4: Register, Memory (Complex Addressing)

{% highlight nasm %}
add rax, [rdx + rbx*8 + 32] # rax = rax + [rdx + rbx*8 + 32]
{% endhighlight %}

## SUB Instruction

The `sub` instruction performs a subtraction of the second operand from the first operand, storing the result in the first operand.  Valid permutations include register-to-register, register-to-immediate, memory-to-register, and register-to-memory.

### Example 1: Register, Register

{% highlight nasm %}
sub rcx, rdx                # rcx = rcx - rdx
{% endhighlight %}

### Example 2: Register, Immediate

{% highlight nasm %}
sub rax, 0x100              # rax = rax - 0x100
{% endhighlight %}

### Example 3: Memory, Register

{% highlight nasm %}
sub [val1], rcx              # [val1] = [val1] - rcx
{% endhighlight %}

### Example 4: Register, Memory (Complex Addressing)

{% highlight nasm %}
sub rbx, [rax + rdi*4]      # rbx = rbx - [rax + rdi*4]
{% endhighlight %}

## MUL Instruction

The `mul` instruction is the **unsigned** multiplication instruction in x64. It uses implicit operands:

- `rax` is multiplied by the specified operand, and the full 128-bit product is placed in `rdx:rax`.

### Example 1: Unsigned Multiply Register

{% highlight nasm %}
mov rax, 10
mov rbx, 20
mul rbx                     # rax:rdx = rax * rbx (unsigned)
                            # rax = 200, rdx = 0
{% endhighlight %}

### Example 2: Unsigned Multiply Memory

{% highlight nasm %}
mov rax, 10
mul qword ptr [val1]        # 64-bit operand from memory
                            # rax:rdx = rax * [val1]
{% endhighlight %}

## IMUL Instruction

The `imul` instruction is the **signed** multiplication instruction. It has multiple variants: one operand (like `mul`), two-operand, or three-operand forms.

### Example 1: One Operand (Signed)

{% highlight nasm %}

mov rax, -5
mov rdi, 3
imul rdi                    # rax:rdx = rax * rdi (signed)
                            # rax = -15, high part in rdx
{% endhighlight %}

### Example 2: Two Operands (Destination, Source)

{% highlight nasm %}
mov rbx, -4
mov rax, 6
imul rbx, rax               # rbx = rbx * rax (signed)
                            # rbx = -24
{% endhighlight %}

### Example 3: Three Operands

{% highlight nasm %}
mov rax, -3
imul rbx, rax, 12           # rbx = rax * 12 (signed), with an immediate
                            # rbx = -36
{% endhighlight %}

## DIV Instruction

The `div` instruction is the **unsigned** division, taking the 128-bit dividend from `rdx:rax` and dividing by the specified operand. The quotient is placed in `rax`, and the remainder goes to `rdx`.

{% highlight nasm %}

mov rax, 100
xor rdx, rdx                # zero-extend for unsigned
mov rbx, 10
div rbx                     # rax = 10, rdx = 0
                            # (rdx:rax) / rbx -> rax (quotient), rdx (remainder)
{% endhighlight %}

---

## IDIV Instruction

The `idiv` instruction is the **signed** division, also reading a 128-bit dividend from `rdx:rax`. The quotient goes to `rax`, and the remainder goes to `rdx`.

{% highlight nasm %}

mov rax, -64
cqo                         # sign-extend rax into rdx:rax
mov rsi, 8
idiv rsi                    # rax = quotient, rdx = remainder
                            # (rdx:rax) / rsi -> rax (quotient), rdx (remainder)
{% endhighlight %}

> **Note:** `cqo` (convert quadword to octaword) sign-extends `rax` into `rdx:rax`. This is needed before signed division to properly extend the sign bit.

## Sample Putting It All Together

Below is a small snippet demonstrating many of these instructions in sequence. You can name this file `arithmetic.asm`, assemble, link, and run it on a typical Linux system:

{% highlight bash %}
as --64 -o arithmetic.o arithmetic.asm
ld -o arithmetic arithmetic.o
./arithmetic
{% endhighlight %}

{% highlight nasm %}
.intel_syntax noprefix
.text
.global _start

_start:
    # 1. Demonstrate ADD
    mov rax, 5
    mov rbx, 10
    add rax, rbx            # rax = 15

    # 2. Demonstrate SUB
    sub rax, 2              # rax = 13

    # 3. Demonstrate MUL (unsigned)
    # rax:rdx = rax * rcx
    mov rcx, 3
    mul rcx                 # rax = 39, rdx = 0

    # 4. Demonstrate IMUL (signed, 3-operand)
    # rbx = rax * 4
    imul rbx, rax, 4        # rbx = 156

    # 5. Demonstrate DIV (unsigned)
    # (rdx:rax) / rbx -> rax
    xor rdx, rdx            # Clear rdx
    mov rax, 200
    mov rbx, 10
    div rbx                 # rax = 20, rdx = 0

    # 6. Demonstrate IDIV (signed)
    # (rdx:rax) / rbx -> rax
    mov rax, -100
    cqo                     # sign extend
    mov rbx, 7
    idiv rbx                # rax = -14, rdx = -2

    # Exit
    mov rax, 60             # sys_exit
    xor rdi, rdi            # exit code 0
    syscall
{% endhighlight %}

## Appendix: 8-bit, 16-bit, and 32-bit Arithmetic Variants

While x86‐64 primarily uses 64-bit registers (`rax`, `rbx`, etc.), you can also work with smaller sizes: 8-bit (AL, BL, etc.), 16-bit (AX, BX, etc.), and 32-bit (EAX, EBX, etc.). The operations work similarly but use smaller registers and, in some cases, different implicit registers for multiplication and division. Below is a brief overview:

### 8-bit Arithmetic

- **Registers**: AL, BL, CL, DL, etc.
- **add/sub**:
{% highlight nasm %}
  add al, bl         ; AL = AL + BL
  sub al, 0x5        ; AL = AL - 5
{% endhighlight %}
- **mul**:
  - Uses AL implicitly. The product is placed into AX (`AH:AL`).
{% highlight nasm %}
  ; Unsigned multiply: AX = AL * BL
  mul bl
{% endhighlight %}
- **imul**:
  - For the one-operand version, AX = AL * r8 (signed).
- **div**:
  - 16-bit dividend in AX is divided by r8. The quotient is in AL, remainder in AH.
{% highlight nasm %}
  ; AX / BL -> AL (quotient), AH (remainder)
  div bl
{% endhighlight %}
- **idiv**:
  - Same concept, but signed.

### 16-bit Arithmetic

- **Registers**: AX, BX, CX, DX, etc.
- **add/sub**:
{% highlight nasm %}
  add ax, bx         ; AX = AX + BX
  sub ax, 0x10       ; AX = AX - 0x10
{% endhighlight %}
- **mul**:
  - Uses AX as the implicit operand. The product goes into DX:AX.
{% highlight nasm %}
  ; Unsigned multiply: DX:AX = AX * BX
  mul bx
{% endhighlight %}
- **imul**:
  - For the one-operand version, DX:AX = AX * r16 (signed).
- **div**:
  - 32-bit dividend in DX:AX is divided by r16. The quotient goes to AX, remainder to DX.
{% highlight nasm %}
  ; DX:AX / BX -> AX, remainder DX
  div bx
{% endhighlight %}
- **idiv**:
  - Signed variant; sign-extend AX into DX:AX with `cwd` (convert word to doubleword) before dividing.

### 32-bit Arithmetic

- **Registers**: EAX, EBX, ECX, EDX, etc.
- **add/sub**:
{% highlight nasm %}
  add eax, ebx       ; EAX = EAX + EBX
  sub eax, 0x100     ; EAX = EAX - 0x100
{% endhighlight %}
- **mul**:
  - Uses EAX as the implicit operand. The product goes into EDX:EAX.
{% highlight nasm %}
  ; Unsigned multiply: EDX:EAX = EAX * EBX
  mul ebx
{% endhighlight %}
- **imul**:
  - For the one-operand version, EDX:EAX = EAX * r32 (signed).
- **div**:
  - 64-bit dividend in EDX:EAX is divided by r32. The quotient goes to EAX, remainder to EDX.
{% highlight nasm %}
  ; EDX:EAX / EBX -> EAX, remainder EDX
  div ebx
{% endhighlight %}
- **idiv**:
  - Signed variant; sign-extend EAX into EDX:EAX with `cdq` (convert doubleword to quadword) before dividing.

In each case, the “smaller” variants of the instructions behave the same way conceptually as their 64-bit counterparts, just with different registers and, for multiplication/division, different implicit register pairs. By mixing and matching these sizes as needed, you have fine-grained control over your arithmetic operations in x86‐64 assembly.
