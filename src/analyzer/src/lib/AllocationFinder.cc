#include <llvm/ADT/StringExtras.h>
#include <llvm/Analysis/CallGraph.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DebugInfo.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/TypeFinder.h>
#include <llvm/Pass.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>

#include "AllocationFinder.h"

using namespace llvm;
using namespace std;

bool AllocationFinderPass::doInitialization(Module *M) { return false; }

bool AllocationFinderPass::doFinalization(Module *M) { return false; }

bool AllocationFinderPass::doModulePass(Module *M) {
  for (auto &F : *M) {
    for (auto &BB : F) {
      for (auto &II : BB) {
        Instruction *I = &II;

        if (auto CI = dyn_cast<CallInst>(I)) {
          Function *F = CI->getCalledFunction();
          if (!F)
            continue;
          if (allocAPIVec.find(F->getName()) != allocAPIVec.end()) {
            for (auto *user : cast<Value>(I)->users()) {
              if (auto *SI = dyn_cast<StoreInst>(user)) {
                // find its first operand
                // if (auto *GEI =
                //         dyn_cast<GetElementPtrInst>(SI->getOperand(1))) {
                //   if (auto offset = dyn_cast<ConstantInt>(
                //           GEI->getOperand(GEI->getNumIndices()))) {
                //     // find the GEI, check if the struct and it's offset is
                //     in
                //     // the
                //     unsigned offset_val = offset->getZExtValue();
                //     StringRef name = handleType(GEI->getSourceElementType());
                //     if (Ctx->ElementOffset.find(name) !=
                //         Ctx->ElementOffset.end()) {
                //       if (Ctx->ElementOffset[name].find(offset_val) !=
                //           Ctx->ElementOffset[name].end()) {
                //         Ctx->Allocations.insert(CI);
                //       }
                //     }
                //   }
                // }
              } else if (auto *BCI = dyn_cast<BitCastInst>(user)) {
                StringRef name = handleType(BCI->getDestTy());
                if (name == targetSt) {
                  // KA_LOGS(0, "Got name " << name << "\n");
                  // KA_LOGS(0, "Found Bitcast :" << *BCI << "\n");
                  Ctx->Allocations.insert(CI);
                }
              }
            }
          }
        }
      }
    }
  }

  return false;
}

void AllocationFinderPass::dump() {
  KA_LOGS(0, "dumping location of allocating " << targetSt);
  for (auto CI : Ctx->Allocations) {
    // log the src information
    DILocation *Loc = CI->getDebugLoc();
    Function *F = CI->getFunction();

    if (!Loc || !F || !F->hasName())
      continue;
    StringRef sourceF = Loc->getScope()->getFilename();
    if (sourceF.startswith("./")) {
      sourceF = sourceF.split("./").second;
    }
    KA_LOGS(0, F->getName() << " " << sourceF + ":" << Loc->getLine());
    KA_LOGS(0, "Possible Caller for " << F->getName());
    CallInstSet CIS = Ctx->Callers[F];
    for (auto C : CIS) {
	Function *CF = C->getFunction();
	if (!CF || !CF->hasName())
	    continue;
        KA_LOGS(0, CF->getName());
    }
    KA_LOGS(0, "");
  }
}

StringRef AllocationFinderPass::handleType(Type *ty) {

  if (ty == nullptr)
    return StringRef("");

    // debug type
#if 0
    std::string type_str;
    llvm::raw_string_ostream rso(type_str);
    ty->print(rso);
    KA_LOGS(0, "type :" << rso.str());
#endif

  if (ty->isStructTy()) {
    StructType *ST = dyn_cast<StructType>(ty);
    StringRef stname = ST->getName();

    if (stname.startswith("struct.") && !stname.startswith("struct.anon"))
      return stname.split("struct.").second;

  } else if (ty->isPointerTy()) {
    ty = cast<PointerType>(ty)->getElementType();
    return handleType(ty);
  } else if (ty->isArrayTy()) {
    ty = cast<ArrayType>(ty)->getElementType();
    return handleType(ty);
  } else if (ty->isIntegerTy()) {
    return StringRef("int");
  }

  return StringRef("");
}
