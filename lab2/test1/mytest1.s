.arch armv7-a
.text
.global n
.section .rodata
.align 2
.type n, %object
.size n, 4
n:
    .word 5 @声明全局变量n
.align 2
str0:
    .ascii "answer:%d\n"

.text
.align 1
.global main
.type main, %function
main:
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0
    movs r2, #2
    str r2, [r7] @变量i赋值
    movs r2, #1
    str r2, [r7, #4] @变量f赋值
    b mywhile

L1:
    ldr r3, [r7, #4] @f
    ldr r2, [r7] @i
    mul r3, r2, r3 @乘法运算
    str r3, [r7, #4]
    ldr r3, [r7]
    adds r3, r3, #1 @加法运算
    str r3, [r7]

mywhile:
    movs r2, #5
    ldr r3, [r7] @i
    cmp r3, r2
    ble L1 @i<=n
    ldr r1, [r7, #4]
    ldr r0, answer
    bl printf(PLT)
    adds r7, r7, #8
    mov sp, r7
    pop {r7, pc}

answer:
    .word str0

.section .note.GNU-stack, "", %progbits
