#ifndef ALLOCATION_FINDER_H
#define ALLOCATION_FINDER_H

#include "Common.h"
#include "GlobalCtx.h"

using namespace llvm;

class AllocationFinderPass : public IterativeModulePass {

private:
  StringRef targetSt;
  StringRef handleType(Type *ty);

public:
  AllocationFinderPass(GlobalContext *Ctx_, StringRef St)
      : IterativeModulePass(Ctx_, "AllocationFinder") {
    targetSt = St;
  }
  virtual bool doInitialization(Module *);
  virtual bool doFinalization(Module *);
  virtual bool doModulePass(Module *);

  void dump();
};

#endif
