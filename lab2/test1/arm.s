	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"test1.c"
	.text
	.global	n
	.data
	.align	2
	.type	n, %object
	.size	n, 4
n:
	.word	5
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%f\012\000"
	.text
	.align	1
	.global	main
	.arch armv7-a
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0
	ldr	r2, .L8
.LPIC3:
	add	r2, pc
	ldr	r3, .L8+4
	ldr	r3, [r2, r3]
	ldr	r3, [r3]
	str	r3, [r7, #28]
	mov	r3,#0
	movs	r3, #0
	str	r3, [r7]
	movw	r3, #52429
	movt	r3, 16268
	str	r3, [r7, #4]	@ float
	b	.L2
.L3:
	ldr	r3, [r7]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vldr.32	s15, [r7, #4]
	vmul.f32	s14, s14, s15
	ldr	r3, .L8+8
.LPIC0:
	add	r3, pc
	ldr	r3, [r3]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s15, s15
	vadd.f32	s15, s14, s15
	ldr	r3, [r7]
	lsls	r3, r3, #2
	add	r2, r7, #32
	add	r3, r3, r2
	subs	r3, r3, #24
	vstr.32	s15, [r3]
	ldr	r3, [r7]
	adds	r3, r3, #1
	str	r3, [r7]
.L2:
	ldr	r3, .L8+12
.LPIC1:
	add	r3, pc
	ldr	r3, [r3]
	ldr	r2, [r7]
	cmp	r2, r3
	blt	.L3
	b	.L4
.L5:
	ldr	r3, [r7]
	rsb	r3, r3, #5
	lsls	r3, r3, #2
	add	r2, r7, #32
	add	r3, r3, r2
	subs	r3, r3, #24
	vldr.32	s15, [r3]
	vcvt.f64.f32	d7, s15
	vmov	r2, r3, d7
	ldr	r1, .L8+16
.LPIC2:
	add	r1, pc
	mov	r0, r1
	bl	printf(PLT)
	ldr	r3, [r7]
	subs	r3, r3, #1
	str	r3, [r7]
.L4:
	ldr	r3, [r7]
	cmp	r3, #0
	bgt	.L5
	movs	r3, #0
	ldr	r1, .L8+20
.LPIC4:
	add	r1, pc
	ldr	r2, .L8+4
	ldr	r2, [r1, r2]
	ldr	r1, [r2]
	ldr	r2, [r7, #28]
	eors	r1, r2, r1
	mov	r2, #0
	beq	.L7
	bl	__stack_chk_fail(PLT)
.L7:
	mov	r0, r3
	adds	r7, r7, #32
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L9:
	.align	2
.L8:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC3+4)
	.word	__stack_chk_guard(GOT)
	.word	n-(.LPIC0+4)
	.word	n-(.LPIC1+4)
	.word	.LC0-(.LPIC2+4)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC4+4)
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",%progbits
