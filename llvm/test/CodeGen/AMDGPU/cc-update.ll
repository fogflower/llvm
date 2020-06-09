; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx803 < %s | FileCheck --check-prefix=GFX803 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck --check-prefix=GFX900 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 < %s | FileCheck --check-prefix=GFX1010 %s

define amdgpu_kernel void @test_kern_empty() local_unnamed_addr #0 {
; GFX803-LABEL: test_kern_empty:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_kern_empty:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_kern_empty:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_endpgm
entry:
  ret void
}

define amdgpu_kernel void @test_kern_stack() local_unnamed_addr #0 {
; GFX803-LABEL: test_kern_stack:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    v_mov_b32_e32 v0, 0
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_kern_stack:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    v_mov_b32_e32 v0, 0
; GFX900-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_kern_stack:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    v_mov_b32_e32 v0, 0
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX1010-NEXT:    s_endpgm
entry:
  %x = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %x, align 4
  ret void
}

define amdgpu_kernel void @test_kern_call() local_unnamed_addr #0 {
; GFX803-LABEL: test_kern_call:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    s_getpc_b64 s[4:5]
; GFX803-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX803-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX803-NEXT:    s_mov_b32 s32, 0
; GFX803-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_kern_call:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    s_getpc_b64 s[4:5]
; GFX900-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX900-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX900-NEXT:    s_mov_b32 s32, 0
; GFX900-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_kern_call:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_mov_b32 s32, 0
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    s_getpc_b64 s[4:5]
; GFX1010-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX1010-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX1010-NEXT:    s_endpgm
entry:
  tail call void @ex() #0
  ret void
}

define amdgpu_kernel void @test_kern_stack_and_call() local_unnamed_addr #0 {
; GFX803-LABEL: test_kern_stack_and_call:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    v_mov_b32_e32 v0, 0
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    s_getpc_b64 s[4:5]
; GFX803-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX803-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX803-NEXT:    s_movk_i32 s32, 0x400
; GFX803-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX803-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_kern_stack_and_call:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    v_mov_b32_e32 v0, 0
; GFX900-NEXT:    s_getpc_b64 s[4:5]
; GFX900-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX900-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX900-NEXT:    s_movk_i32 s32, 0x400
; GFX900-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX900-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_kern_stack_and_call:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_movk_i32 s32, 0x200
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    v_mov_b32_e32 v0, 0
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    s_getpc_b64 s[4:5]
; GFX1010-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX1010-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:4
; GFX1010-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX1010-NEXT:    s_endpgm
entry:
  %x = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %x, align 4
  tail call void @ex() #0
  ret void
}

define amdgpu_kernel void @test_force_fp_kern_empty() local_unnamed_addr #2 {
; GFX803-LABEL: test_force_fp_kern_empty:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_mov_b32 s33, 0
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_force_fp_kern_empty:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_mov_b32 s33, 0
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_force_fp_kern_empty:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_mov_b32 s33, 0
; GFX1010-NEXT:    s_endpgm
entry:
  ret void
}

define amdgpu_kernel void @test_force_fp_kern_stack() local_unnamed_addr #2 {
; GFX803-LABEL: test_force_fp_kern_stack:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_mov_b32 s33, 0
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    v_mov_b32_e32 v0, 0
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    buffer_store_dword v0, off, s[0:3], s33 offset:4
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_force_fp_kern_stack:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_mov_b32 s33, 0
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    v_mov_b32_e32 v0, 0
; GFX900-NEXT:    buffer_store_dword v0, off, s[0:3], s33 offset:4
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_force_fp_kern_stack:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_mov_b32 s33, 0
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    v_mov_b32_e32 v0, 0
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    buffer_store_dword v0, off, s[0:3], s33 offset:4
; GFX1010-NEXT:    s_endpgm
entry:
  %x = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %x, align 4
  ret void
}

define amdgpu_kernel void @test_force_fp_kern_call() local_unnamed_addr #2 {
; GFX803-LABEL: test_force_fp_kern_call:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    s_getpc_b64 s[4:5]
; GFX803-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX803-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX803-NEXT:    s_mov_b32 s32, 0
; GFX803-NEXT:    s_mov_b32 s33, 0
; GFX803-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_force_fp_kern_call:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    s_getpc_b64 s[4:5]
; GFX900-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX900-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX900-NEXT:    s_mov_b32 s32, 0
; GFX900-NEXT:    s_mov_b32 s33, 0
; GFX900-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_force_fp_kern_call:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_mov_b32 s32, 0
; GFX1010-NEXT:    s_mov_b32 s33, 0
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    s_getpc_b64 s[4:5]
; GFX1010-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX1010-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX1010-NEXT:    s_endpgm
entry:
  tail call void @ex() #2
  ret void
}

define amdgpu_kernel void @test_force_fp_kern_stack_and_call() local_unnamed_addr #2 {
; GFX803-LABEL: test_force_fp_kern_stack_and_call:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_mov_b32 s33, 0
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    v_mov_b32_e32 v0, 0
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    s_getpc_b64 s[4:5]
; GFX803-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX803-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX803-NEXT:    s_movk_i32 s32, 0x400
; GFX803-NEXT:    buffer_store_dword v0, off, s[0:3], s33 offset:4
; GFX803-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_force_fp_kern_stack_and_call:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    s_mov_b32 s33, 0
; GFX900-NEXT:    v_mov_b32_e32 v0, 0
; GFX900-NEXT:    s_getpc_b64 s[4:5]
; GFX900-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX900-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX900-NEXT:    s_movk_i32 s32, 0x400
; GFX900-NEXT:    buffer_store_dword v0, off, s[0:3], s33 offset:4
; GFX900-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_force_fp_kern_stack_and_call:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_movk_i32 s32, 0x200
; GFX1010-NEXT:    s_mov_b32 s33, 0
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    v_mov_b32_e32 v0, 0
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    s_getpc_b64 s[4:5]
; GFX1010-NEXT:    s_add_u32 s4, s4, ex@rel32@lo+4
; GFX1010-NEXT:    s_addc_u32 s5, s5, ex@rel32@hi+4
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    buffer_store_dword v0, off, s[0:3], s33 offset:4
; GFX1010-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX1010-NEXT:    s_endpgm
entry:
  %x = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %x, align 4
  tail call void @ex() #2
  ret void
}

define amdgpu_kernel void @test_sgpr_offset_kernel() #1 {
; GFX803-LABEL: test_sgpr_offset_kernel:
; GFX803:       ; %bb.0: ; %entry
; GFX803-NEXT:    s_add_u32 s4, s4, s7
; GFX803-NEXT:    s_lshr_b32 flat_scratch_hi, s4, 8
; GFX803-NEXT:    s_add_u32 s0, s0, s7
; GFX803-NEXT:    s_addc_u32 s1, s1, 0
; GFX803-NEXT:    buffer_load_dword v0, off, s[0:3], 0 offset:8
; GFX803-NEXT:    s_mov_b32 s4, 0x40000
; GFX803-NEXT:    s_mov_b32 flat_scratch_lo, s5
; GFX803-NEXT:    s_waitcnt vmcnt(0)
; GFX803-NEXT:    buffer_store_dword v0, off, s[0:3], s4 ; 4-byte Folded Spill
; GFX803-NEXT:    ;;#ASMSTART
; GFX803-NEXT:    ;;#ASMEND
; GFX803-NEXT:    s_mov_b32 s4, 0x40000
; GFX803-NEXT:    buffer_load_dword v0, off, s[0:3], s4 ; 4-byte Folded Reload
; GFX803-NEXT:    s_waitcnt vmcnt(0)
; GFX803-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:8
; GFX803-NEXT:    s_endpgm
;
; GFX900-LABEL: test_sgpr_offset_kernel:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; GFX900-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; GFX900-NEXT:    s_add_u32 s0, s0, s7
; GFX900-NEXT:    s_addc_u32 s1, s1, 0
; GFX900-NEXT:    buffer_load_dword v0, off, s[0:3], 0 offset:8
; GFX900-NEXT:    s_mov_b32 s6, 0x40000
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_store_dword v0, off, s[0:3], s6 ; 4-byte Folded Spill
; GFX900-NEXT:    ;;#ASMSTART
; GFX900-NEXT:    ;;#ASMEND
; GFX900-NEXT:    s_mov_b32 s6, 0x40000
; GFX900-NEXT:    buffer_load_dword v0, off, s[0:3], s6 ; 4-byte Folded Reload
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:8
; GFX900-NEXT:    s_endpgm
;
; GFX1010-LABEL: test_sgpr_offset_kernel:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_add_u32 s4, s4, s7
; GFX1010-NEXT:    s_addc_u32 s5, s5, 0
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s4
; GFX1010-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s5
; GFX1010-NEXT:    s_add_u32 s0, s0, s7
; GFX1010-NEXT:    s_addc_u32 s1, s1, 0
; GFX1010-NEXT:    s_mov_b32 s6, 0x20000
; GFX1010-NEXT:    buffer_load_dword v0, off, s[0:3], 0 offset:8
; GFX1010-NEXT:    ; implicit-def: $vcc_hi
; GFX1010-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-NEXT:    buffer_store_dword v0, off, s[0:3], s6 ; 4-byte Folded Spill
; GFX1010-NEXT:    v_nop
; GFX1010-NEXT:    s_mov_b32 s6, 0x20000
; GFX1010-NEXT:    ;;#ASMSTART
; GFX1010-NEXT:    ;;#ASMEND
; GFX1010-NEXT:    buffer_load_dword v0, off, s[0:3], s6 ; 4-byte Folded Reload
; GFX1010-NEXT:    s_waitcnt vmcnt(0)
; GFX1010-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:8
; GFX1010-NEXT:    s_endpgm
entry:
  ; Occupy 4096 bytes of scratch, so the offset of the spill of %a does not
  ; fit in the instruction, and has to live in the SGPR offset.
  %alloca = alloca i8, i32 4092, align 4, addrspace(5)
  %buf = bitcast i8 addrspace(5)* %alloca to i32 addrspace(5)*

  %aptr = getelementptr i32, i32 addrspace(5)* %buf, i32 1
  ; 0x40000 / 64 = 4096 (for wave64)
  ; CHECK: s_add_u32 s6, s7, 0x40000
  ; CHECK: buffer_store_dword v{{[0-9]+}}, off, s[{{[0-9]+:[0-9]+}}], s6 ; 4-byte Folded Spill
  %a = load volatile i32, i32 addrspace(5)* %aptr

  ; Force %a to spill
  call void asm sideeffect "", "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7}" ()

  %outptr = getelementptr i32, i32 addrspace(5)* %buf, i32 1
  store volatile i32 %a, i32 addrspace(5)* %outptr

  ret void
}

declare hidden void @ex() local_unnamed_addr #0

attributes #0 = { nounwind }
attributes #1 = { nounwind "amdgpu-num-vgpr"="8" }
attributes #2 = { nounwind "frame-pointer"="all" }
