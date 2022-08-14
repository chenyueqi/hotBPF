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

#include "SimplePtrToAnalysis.h"

using namespace llvm;
using namespace std;

bool SimplePtrToAnalysisPass::doInitialization(Module *M) { return false; }

bool SimplePtrToAnalysisPass::doFinalization(Module *M) { return false; }

bool SimplePtrToAnalysisPass::doModulePass(Module *M) {

  for (auto &F : *M) {
    for (auto &BB : F) {
      for (auto &II : BB) {
        Instruction *I = &II;

        if (auto CI = dyn_cast<CallInst>(I)) {
          Function *F = CI->getCalledFunction();
          if (!F) continue;
          Type *funcTy = F->getReturnType();
          auto typeName = handleType(funcTy);
          if (!typeName.startswith("struct.")) {
            continue;
          }

          if (ObjMaps.find(typeName) == ObjMaps.end()) {
            std::set<string> strSet;
            ObjMaps[typeName] = strSet;
          }

          for(const BasicBlock &BB : *F){
            for(const Instruction &I : BB){
              if(const ReturnInst *RI = dyn_cast<ReturnInst>(&I)){
                if(Value *rValue = RI->getReturnValue()){
                  std::set<Value *> tracked;
                  // StrSet strSet;
                  KA_LOGS(0, "Finding alias for "<<typeName);
                  resolveRepr(rValue, ObjMaps[typeName], tracked);
                  // ObjMaps[typeName].insert(strSet.begin(), strSet.end());
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

StringRef SimplePtrToAnalysisPass::handleType(Type *ty) {

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
      return stname;

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

void SimplePtrToAnalysisPass::resolveRepr(Value *v, StringSet &strSet, std::set<Value *> &tracked) {
  if (!isa<Instruction>(v)) {
    return;
  }

  if (!tracked.insert(v).second) {
    return;
  }

  Instruction *I = cast<Instruction>(v);
  switch (I->getOpcode()) {
  case Instruction::Call: {
    Function *F = cast<CallInst>(I)->getCalledFunction();
    // find it's ret
    if (!F) break;

    for(const BasicBlock &BB : *F){
        for(const Instruction &I : BB){
          if(const ReturnInst *RI = dyn_cast<ReturnInst>(&I)){
            if(Value *rValue = RI->getReturnValue()){
              // TODO: make sure this only return to current function
              resolveRepr(rValue, strSet, tracked);
            }
          }        
        }
      }
    break;
  }
  case Instruction::Load: {
    // should have a pair GEI
    LoadInst *LI = cast<LoadInst>(I);
    Type *lType = LI->getPointerOperandType();
    StringRef stName = handleType(lType);

    // would find a GetElementType
    if (!isa<GetElementPtrInst>(LI->getOperand(0))) {
      // it may not in some cases
      // outs() << "in " << LI->getFunction()->getName() << "\n";
      // assert(0 && "didn't find a GetElementPtrInst before LoadInst");
    } else {
      GetElementPtrInst *GEI = cast<GetElementPtrInst>(LI->getOperand(0));
      if (auto offset =
              dyn_cast<ConstantInt>(GEI->getOperand(GEI->getNumIndices()))) {
        unsigned offset_val = offset->getZExtValue();
        // store these two.
        StringRef name = handleType(GEI->getSourceElementType());
        if (!GEI->getSourceElementType()->isArrayTy()) {
          // if (GEI->getSourceElementType()->isPointerTy()) {
          //   KA_LOGS(0, " a structure type\n");
          // } else if (GEI->getSourceElementType()->isArrayTy()) {
          //   KA_LOGS(0, " a array type\n");
          // }

          KA_LOGS(0, "Found " << name.str() << offset_val);
          strSet.insert(name.str()+std::to_string(offset_val));
        }
      }
    }
    break;
  }

  case Instruction::GetElementPtr: {
    // nested, should skip all cast
    auto vv = I->getOperand(0);
    while (isa<CastInst>(vv)) {
      auto CI = cast<CastInst>(vv);
      vv = CI->getOperand(0);
    }
    resolveRepr(vv, strSet, tracked);
    break;
  }

  // avoid potential path explosion
  case Instruction::PHI: {
    auto PHI = cast<PHINode>(I);
    for (unsigned i = 0; i < PHI->getNumIncomingValues(); i++) {
      resolveRepr(PHI->getIncomingValue(i), strSet, tracked);
    }
  }
  default:
    break;
  }

  if (I->isUnaryOp() || I->isBinaryOp()) {
    for (int i = 0; i < I->getNumOperands(); i++) {
      resolveRepr(I->getOperand(i), strSet, tracked);
    }
  }

  for (int i = 0; i < I->getNumOperands(); i++) {
    resolveRepr(I->getOperand(i), strSet, tracked);
  }
}