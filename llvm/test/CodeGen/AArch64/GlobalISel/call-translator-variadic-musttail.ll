; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc %s -verify-machineinstrs -mtriple aarch64-apple-darwin -global-isel -o - 2>&1 | FileCheck %s

; There are two things we want to test here:
;  (1) We can tail call musttail calls.
;  (2) We spill and reload all of the arguments around a normal call.

declare i32 @musttail_variadic_callee(i32, ...)
define i32 @test_musttail_variadic(i32 %arg0, ...) {
; CHECK-LABEL: test_musttail_variadic:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    b _musttail_variadic_callee
  %r = musttail call i32 (i32, ...) @musttail_variadic_callee(i32 %arg0, ...)
  ret i32 %r
}

declare [2 x i64] @musttail_variadic_aggret_callee(i32 %arg0, ...)
define [2 x i64] @test_musttail_variadic_aggret(i32 %arg0, ...) {
; CHECK-LABEL: test_musttail_variadic_aggret:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    b _musttail_variadic_aggret_callee
  %r = musttail call [2 x i64] (i32, ...) @musttail_variadic_aggret_callee(i32 %arg0, ...)
  ret [2 x i64] %r
}

; Test musttailing with a normal call in the block. Test that we spill and
; restore, as a normal call will clobber all argument registers.
@asdf = internal constant [4 x i8] c"asdf"
declare void @puts(i8*)
define i32 @test_musttail_variadic_spill(i32 %arg0, ...) {
; CHECK-LABEL: test_musttail_variadic_spill:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #224 ; =224
; CHECK-NEXT:    stp x28, x27, [sp, #128] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x26, x25, [sp, #144] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x24, x23, [sp, #160] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x22, x21, [sp, #176] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x20, x19, [sp, #192] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #208] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 224
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    .cfi_offset w21, -40
; CHECK-NEXT:    .cfi_offset w22, -48
; CHECK-NEXT:    .cfi_offset w23, -56
; CHECK-NEXT:    .cfi_offset w24, -64
; CHECK-NEXT:    .cfi_offset w25, -72
; CHECK-NEXT:    .cfi_offset w26, -80
; CHECK-NEXT:    .cfi_offset w27, -88
; CHECK-NEXT:    .cfi_offset w28, -96
; CHECK-NEXT:    mov x27, x8
; CHECK-NEXT:    adrp x8, _asdf@PAGE
; CHECK-NEXT:    mov w19, w0
; CHECK-NEXT:    add x0, x8, _asdf@PAGEOFF
; CHECK-NEXT:    mov x20, x1
; CHECK-NEXT:    mov x21, x2
; CHECK-NEXT:    mov x22, x3
; CHECK-NEXT:    mov x23, x4
; CHECK-NEXT:    mov x24, x5
; CHECK-NEXT:    mov x25, x6
; CHECK-NEXT:    mov x26, x7
; CHECK-NEXT:    stp q1, q0, [sp, #96] ; 32-byte Folded Spill
; CHECK-NEXT:    stp q3, q2, [sp, #64] ; 32-byte Folded Spill
; CHECK-NEXT:    stp q5, q4, [sp, #32] ; 32-byte Folded Spill
; CHECK-NEXT:    stp q7, q6, [sp] ; 32-byte Folded Spill
; CHECK-NEXT:    bl _puts
; CHECK-NEXT:    ldp q1, q0, [sp, #96] ; 32-byte Folded Reload
; CHECK-NEXT:    ldp q3, q2, [sp, #64] ; 32-byte Folded Reload
; CHECK-NEXT:    ldp q5, q4, [sp, #32] ; 32-byte Folded Reload
; CHECK-NEXT:    ldp q7, q6, [sp] ; 32-byte Folded Reload
; CHECK-NEXT:    mov w0, w19
; CHECK-NEXT:    mov x1, x20
; CHECK-NEXT:    mov x2, x21
; CHECK-NEXT:    mov x3, x22
; CHECK-NEXT:    mov x4, x23
; CHECK-NEXT:    mov x5, x24
; CHECK-NEXT:    mov x6, x25
; CHECK-NEXT:    mov x7, x26
; CHECK-NEXT:    mov x8, x27
; CHECK-NEXT:    ldp x29, x30, [sp, #208] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp, #192] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x22, x21, [sp, #176] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x24, x23, [sp, #160] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x26, x25, [sp, #144] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x28, x27, [sp, #128] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #224 ; =224
; CHECK-NEXT:    b _musttail_variadic_callee
  call void @puts(i8* getelementptr ([4 x i8], [4 x i8]* @asdf, i32 0, i32 0))
  %r = musttail call i32 (i32, ...) @musttail_variadic_callee(i32 %arg0, ...)
  ret i32 %r
}

; Test musttailing with a varargs call in the block. Test that we spill and
; reload all arguments in the variadic argument pack.
declare void @llvm.va_start(i8*) nounwind
declare void(i8*, ...)* @get_f(i8* %this)
define void @f_thunk(i8* %this, ...) {
; CHECK-LABEL: f_thunk:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #256 ; =256
; CHECK-NEXT:    stp x28, x27, [sp, #160] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x26, x25, [sp, #176] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x24, x23, [sp, #192] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x22, x21, [sp, #208] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x20, x19, [sp, #224] ; 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #240] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 256
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    .cfi_offset w21, -40
; CHECK-NEXT:    .cfi_offset w22, -48
; CHECK-NEXT:    .cfi_offset w23, -56
; CHECK-NEXT:    .cfi_offset w24, -64
; CHECK-NEXT:    .cfi_offset w25, -72
; CHECK-NEXT:    .cfi_offset w26, -80
; CHECK-NEXT:    .cfi_offset w27, -88
; CHECK-NEXT:    .cfi_offset w28, -96
; CHECK-NEXT:    mov x27, x8
; CHECK-NEXT:    add x8, sp, #128 ; =128
; CHECK-NEXT:    add x9, sp, #256 ; =256
; CHECK-NEXT:    mov x19, x0
; CHECK-NEXT:    mov x20, x1
; CHECK-NEXT:    mov x21, x2
; CHECK-NEXT:    mov x22, x3
; CHECK-NEXT:    mov x23, x4
; CHECK-NEXT:    mov x24, x5
; CHECK-NEXT:    mov x25, x6
; CHECK-NEXT:    mov x26, x7
; CHECK-NEXT:    stp q1, q0, [sp, #96] ; 32-byte Folded Spill
; CHECK-NEXT:    stp q3, q2, [sp, #64] ; 32-byte Folded Spill
; CHECK-NEXT:    stp q5, q4, [sp, #32] ; 32-byte Folded Spill
; CHECK-NEXT:    stp q7, q6, [sp] ; 32-byte Folded Spill
; CHECK-NEXT:    str x9, [x8]
; CHECK-NEXT:    bl _get_f
; CHECK-NEXT:    mov x9, x0
; CHECK-NEXT:    ldp q1, q0, [sp, #96] ; 32-byte Folded Reload
; CHECK-NEXT:    ldp q3, q2, [sp, #64] ; 32-byte Folded Reload
; CHECK-NEXT:    ldp q5, q4, [sp, #32] ; 32-byte Folded Reload
; CHECK-NEXT:    ldp q7, q6, [sp] ; 32-byte Folded Reload
; CHECK-NEXT:    mov x0, x19
; CHECK-NEXT:    mov x1, x20
; CHECK-NEXT:    mov x2, x21
; CHECK-NEXT:    mov x3, x22
; CHECK-NEXT:    mov x4, x23
; CHECK-NEXT:    mov x5, x24
; CHECK-NEXT:    mov x6, x25
; CHECK-NEXT:    mov x7, x26
; CHECK-NEXT:    mov x8, x27
; CHECK-NEXT:    ldp x29, x30, [sp, #240] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x20, x19, [sp, #224] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x22, x21, [sp, #208] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x24, x23, [sp, #192] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x26, x25, [sp, #176] ; 16-byte Folded Reload
; CHECK-NEXT:    ldp x28, x27, [sp, #160] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #256 ; =256
; CHECK-NEXT:    br x9
  %ap = alloca [4 x i8*], align 16
  %ap_i8 = bitcast [4 x i8*]* %ap to i8*
  call void @llvm.va_start(i8* %ap_i8)
  %fptr = call void(i8*, ...)*(i8*) @get_f(i8* %this)
  musttail call void (i8*, ...) %fptr(i8* %this, ...)
  ret void
}

; We don't need any spills and reloads here, but we should still emit the
; copies in call lowering.
define void @g_thunk(i8* %fptr_i8, ...) {
; CHECK-LABEL: g_thunk:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    br x0
  %fptr = bitcast i8* %fptr_i8 to void (i8*, ...)*
  musttail call void (i8*, ...) %fptr(i8* %fptr_i8, ...)
  ret void
}

; Test that this works with multiple exits and basic blocks.
%struct.Foo = type { i1, i8*, i8* }
@g = external global i32
define void @h_thunk(%struct.Foo* %this, ...) {
; CHECK-LABEL: h_thunk:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldrb w9, [x0]
; CHECK-NEXT:    tbz w9, #0, LBB5_2
; CHECK-NEXT:  ; %bb.1: ; %then
; CHECK-NEXT:    ldr x9, [x0, #8]
; CHECK-NEXT:    br x9
; CHECK-NEXT:  LBB5_2: ; %else
; CHECK-NEXT:  Lloh0:
; CHECK-NEXT:    adrp x10, _g@GOTPAGE
; CHECK-NEXT:    ldr x9, [x0, #16]
; CHECK-NEXT:  Lloh1:
; CHECK-NEXT:    ldr x10, [x10, _g@GOTPAGEOFF]
; CHECK-NEXT:    mov w11, #42
; CHECK-NEXT:  Lloh2:
; CHECK-NEXT:    str w11, [x10]
; CHECK-NEXT:    br x9
; CHECK-NEXT:    .loh AdrpLdrGotStr Lloh0, Lloh1, Lloh2
  %cond_p = getelementptr %struct.Foo, %struct.Foo* %this, i32 0, i32 0
  %cond = load i1, i1* %cond_p
  br i1 %cond, label %then, label %else

then:
  %a_p = getelementptr %struct.Foo, %struct.Foo* %this, i32 0, i32 1
  %a_i8 = load i8*, i8** %a_p
  %a = bitcast i8* %a_i8 to void (%struct.Foo*, ...)*
  musttail call void (%struct.Foo*, ...) %a(%struct.Foo* %this, ...)
  ret void

else:
  %b_p = getelementptr %struct.Foo, %struct.Foo* %this, i32 0, i32 2
  %b_i8 = load i8*, i8** %b_p
  %b = bitcast i8* %b_i8 to void (%struct.Foo*, ...)*
  store i32 42, i32* @g
  musttail call void (%struct.Foo*, ...) %b(%struct.Foo* %this, ...)
  ret void
}
