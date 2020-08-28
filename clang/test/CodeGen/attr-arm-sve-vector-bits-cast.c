// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// REQUIRES: aarch64-registered-target
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -msve-vector-bits=512 -fallow-half-arguments-and-returns -S -O1 -emit-llvm -o - %s | FileCheck %s

#include <arm_sve.h>

#define N __ARM_FEATURE_SVE_BITS_EXPERIMENTAL

typedef svint32_t fixed_int32_t __attribute__((arm_sve_vector_bits(N)));
typedef svfloat64_t fixed_float64_t __attribute__((arm_sve_vector_bits(N)));
typedef svbool_t fixed_bool_t __attribute__((arm_sve_vector_bits(N)));

// CHECK-LABEL: @to_svint32_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE:%.*]] = alloca <16 x i32>, align 16
// CHECK-NEXT:    [[TYPE_ADDR:%.*]] = alloca <16 x i32>, align 16
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast <16 x i32>* [[TYPE]] to <vscale x 4 x i32>*
// CHECK-NEXT:    store <vscale x 4 x i32> [[TYPE_COERCE:%.*]], <vscale x 4 x i32>* [[TMP0]], align 16
// CHECK-NEXT:    [[TYPE1:%.*]] = load <16 x i32>, <16 x i32>* [[TYPE]], align 16, !tbaa !2
// CHECK-NEXT:    store <16 x i32> [[TYPE1]], <16 x i32>* [[TYPE_ADDR]], align 16, !tbaa !2
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i32>* [[TYPE_ADDR]] to <vscale x 4 x i32>*
// CHECK-NEXT:    [[TMP2:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[TMP1]], align 16, !tbaa !2
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP2]]
//
svint32_t to_svint32_t(fixed_int32_t type) {
  return type;
}

// CHECK-LABEL: @from_svint32_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE_ADDR:%.*]] = alloca <vscale x 4 x i32>, align 16
// CHECK-NEXT:    [[RETVAL_COERCE:%.*]] = alloca <vscale x 4 x i32>, align 16
// CHECK-NEXT:    store <vscale x 4 x i32> [[TYPE:%.*]], <vscale x 4 x i32>* [[TYPE_ADDR]], align 16, !tbaa !5
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast <vscale x 4 x i32>* [[TYPE_ADDR]] to <16 x i32>*
// CHECK-NEXT:    [[TMP1:%.*]] = load <16 x i32>, <16 x i32>* [[TMP0]], align 16, !tbaa !2
// CHECK-NEXT:    [[RETVAL_0__SROA_CAST:%.*]] = bitcast <vscale x 4 x i32>* [[RETVAL_COERCE]] to <16 x i32>*
// CHECK-NEXT:    store <16 x i32> [[TMP1]], <16 x i32>* [[RETVAL_0__SROA_CAST]], align 16
// CHECK-NEXT:    [[TMP2:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[RETVAL_COERCE]], align 16
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP2]]
//
fixed_int32_t from_svint32_t(svint32_t type) {
  return type;
}

// CHECK-LABEL: @to_svfloat64_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE:%.*]] = alloca <8 x double>, align 16
// CHECK-NEXT:    [[TYPE_ADDR:%.*]] = alloca <8 x double>, align 16
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x double>* [[TYPE]] to <vscale x 2 x double>*
// CHECK-NEXT:    store <vscale x 2 x double> [[TYPE_COERCE:%.*]], <vscale x 2 x double>* [[TMP0]], align 16
// CHECK-NEXT:    [[TYPE1:%.*]] = load <8 x double>, <8 x double>* [[TYPE]], align 16, !tbaa !2
// CHECK-NEXT:    store <8 x double> [[TYPE1]], <8 x double>* [[TYPE_ADDR]], align 16, !tbaa !2
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x double>* [[TYPE_ADDR]] to <vscale x 2 x double>*
// CHECK-NEXT:    [[TMP2:%.*]] = load <vscale x 2 x double>, <vscale x 2 x double>* [[TMP1]], align 16, !tbaa !2
// CHECK-NEXT:    ret <vscale x 2 x double> [[TMP2]]
//
svfloat64_t to_svfloat64_t(fixed_float64_t type) {
  return type;
}

// CHECK-LABEL: @from_svfloat64_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE_ADDR:%.*]] = alloca <vscale x 2 x double>, align 16
// CHECK-NEXT:    [[RETVAL_COERCE:%.*]] = alloca <vscale x 2 x double>, align 16
// CHECK-NEXT:    store <vscale x 2 x double> [[TYPE:%.*]], <vscale x 2 x double>* [[TYPE_ADDR]], align 16, !tbaa !7
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast <vscale x 2 x double>* [[TYPE_ADDR]] to <8 x double>*
// CHECK-NEXT:    [[TMP1:%.*]] = load <8 x double>, <8 x double>* [[TMP0]], align 16, !tbaa !2
// CHECK-NEXT:    [[RETVAL_0__SROA_CAST:%.*]] = bitcast <vscale x 2 x double>* [[RETVAL_COERCE]] to <8 x double>*
// CHECK-NEXT:    store <8 x double> [[TMP1]], <8 x double>* [[RETVAL_0__SROA_CAST]], align 16
// CHECK-NEXT:    [[TMP2:%.*]] = load <vscale x 2 x double>, <vscale x 2 x double>* [[RETVAL_COERCE]], align 16
// CHECK-NEXT:    ret <vscale x 2 x double> [[TMP2]]
//
fixed_float64_t from_svfloat64_t(svfloat64_t type) {
  return type;
}

// CHECK-LABEL: @to_svbool_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE:%.*]] = alloca <8 x i8>, align 16
// CHECK-NEXT:    [[TYPE_ADDR:%.*]] = alloca <8 x i8>, align 16
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x i8>* [[TYPE]] to <vscale x 16 x i1>*
// CHECK-NEXT:    store <vscale x 16 x i1> [[TYPE_COERCE:%.*]], <vscale x 16 x i1>* [[TMP0]], align 16
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i8>* [[TYPE]] to i64*
// CHECK-NEXT:    [[TYPE12:%.*]] = load i64, i64* [[TMP1]], align 16, !tbaa !2
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast <8 x i8>* [[TYPE_ADDR]] to i64*
// CHECK-NEXT:    store i64 [[TYPE12]], i64* [[TMP2]], align 16, !tbaa !2
// CHECK-NEXT:    [[TMP3:%.*]] = bitcast <8 x i8>* [[TYPE_ADDR]] to <vscale x 16 x i1>*
// CHECK-NEXT:    [[TMP4:%.*]] = load <vscale x 16 x i1>, <vscale x 16 x i1>* [[TMP3]], align 16, !tbaa !2
// CHECK-NEXT:    ret <vscale x 16 x i1> [[TMP4]]
//
svbool_t to_svbool_t(fixed_bool_t type) {
  return type;
}

// CHECK-LABEL: @from_svbool_t(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TYPE_ADDR:%.*]] = alloca <vscale x 16 x i1>, align 16
// CHECK-NEXT:    [[RETVAL_COERCE:%.*]] = alloca <vscale x 16 x i1>, align 16
// CHECK-NEXT:    store <vscale x 16 x i1> [[TYPE:%.*]], <vscale x 16 x i1>* [[TYPE_ADDR]], align 16, !tbaa !9
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast <vscale x 16 x i1>* [[TYPE_ADDR]] to i64*
// CHECK-NEXT:    [[TMP1:%.*]] = load i64, i64* [[TMP0]], align 16, !tbaa !2
// CHECK-NEXT:    [[TMP2:%.*]] = bitcast <vscale x 16 x i1>* [[RETVAL_COERCE]] to i64*
// CHECK-NEXT:    store i64 [[TMP1]], i64* [[TMP2]], align 16
// CHECK-NEXT:    [[TMP3:%.*]] = load <vscale x 16 x i1>, <vscale x 16 x i1>* [[RETVAL_COERCE]], align 16
// CHECK-NEXT:    ret <vscale x 16 x i1> [[TMP3]]
//
fixed_bool_t from_svbool_t(svbool_t type) {
  return type;
}
