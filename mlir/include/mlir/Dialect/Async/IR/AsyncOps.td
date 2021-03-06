//===- AsyncOps.td - Async operations definition -----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is the operation definition file for Async dialect operations.
//
//===----------------------------------------------------------------------===//

#ifndef ASYNC_OPS
#define ASYNC_OPS

include "mlir/Dialect/Async/IR/AsyncBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

//===----------------------------------------------------------------------===//
// Async op definitions
//===----------------------------------------------------------------------===//

// Base class for the operation in this dialect
class Async_Op<string mnemonic, list<OpTrait> traits = []> :
    Op<AsyncDialect, mnemonic, traits>;

def Async_ExecuteOp : Async_Op<"execute"> {
  let summary = "Asynchronous execute operation";
  let description = [{
    The `body` region attached to the `async.execute` operation semantically
    can be executed concurrently with the successor operation. In the followup
    example "compute0" can be executed concurrently with "compute1".

    The actual concurrency semantics depends on the dialect lowering to the
    executable format. Fully sequential execution ("compute0" completes before
    "compute1" starts) is a completely legal execution.

    Because concurrent execution is not guaranteed, it is illegal to create an
    implicit dependency from "compute1" to "compute0" (e.g. via shared global
    state). All dependencies must be made explicit with async execute arguments
    (`async.token` or `async.value`).

    ```mlir
    %done, %values = async.execute {
      %0 = "compute0"(...) : !some.type
      async.yield %1 : f32
    } : !async.token, !async.value<!some.type>

    %1 = "compute1"(...) : !some.type
    ```
  }];

  // TODO: Take async.tokens/async.values as arguments.
  let arguments = (ins );
  let results = (outs Async_TokenType:$done,
                      Variadic<Async_AnyValueType>:$values);
  let regions = (region SizedRegion<1>:$body);

  let printer = [{ return ::mlir::async::print(p, *this); }];
  let parser = [{ return ::mlir::async::parse$cppClass(parser, result); }];
}

def Async_YieldOp :
    Async_Op<"yield", [HasParent<"ExecuteOp">, NoSideEffect, Terminator]> {
  let summary = "terminator for Async execute operation";
  let description = [{
    The `async.yield` is a special terminator operation for the block inside
    `async.execute` operation.
  }];

  let arguments = (ins Variadic<AnyType>:$operands);

  let assemblyFormat = "attr-dict ($operands^ `:` type($operands))?";

  let verifier = [{ return ::mlir::async::verify(*this); }];
}

#endif // ASYNC_OPS
