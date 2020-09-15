; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-linux-gnu < %s \
; RUN:   -stop-after=finalize-isel -verify-machineinstrs | FileCheck %s 

; Verify if the mayRaiseFPException is set for FCMPD/FCMPS
define i32 @fcmpu(double %a, double %b) {
  ; CHECK-LABEL: name: fcmpu
  ; CHECK: bb.0.entry:
  ; CHECK:   liveins: $f1, $f2
  ; CHECK:   [[COPY:%[0-9]+]]:f8rc = COPY $f2
  ; CHECK:   [[COPY1:%[0-9]+]]:f8rc = COPY $f1
  ; CHECK:   %2:crrc = nofpexcept FCMPUD [[COPY1]], [[COPY]]
  ; CHECK:   [[COPY2:%[0-9]+]]:crbitrc = COPY %2.sub_gt
  ; CHECK:   [[LI8_:%[0-9]+]]:g8rc_and_g8rc_nox0 = LI8 0
  ; CHECK:   [[LI8_1:%[0-9]+]]:g8rc_and_g8rc_nox0 = LI8 1
  ; CHECK:   [[ISEL8_:%[0-9]+]]:g8rc = ISEL8 [[LI8_1]], [[LI8_]], [[COPY2]]
  ; CHECK:   $x3 = COPY [[ISEL8_]]
  ; CHECK:   BLR8 implicit $lr8, implicit $rm, implicit $x3
entry:
  %r = fcmp ogt double %a, %b
  %g = zext i1 %r to i32
  ret i32 %g
}
