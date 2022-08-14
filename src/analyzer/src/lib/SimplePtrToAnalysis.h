#ifndef SIMPLE_PTR_TO_ANALYSIS_H
#define SIMPLE_PTR_TO_ANALYSIS_H

#include "Common.h"
#include "GlobalCtx.h"

using namespace llvm;
using namespace std;

typedef std::set<string> StringSet;

class SimplePtrToAnalysisPass : public IterativeModulePass {

private:
  StringRef handleType(Type *ty);
public:
  SimplePtrToAnalysisPass(GlobalContext *Ctx_)
      : IterativeModulePass(Ctx_, "SimplePtrToAnalysisPass") {}
  virtual bool doInitialization(Module *);
  virtual bool doFinalization(Module *);
  virtual bool doModulePass(Module *);

  void resolveRepr(Value *v, StringSet &strSet, std::set<Value *> &tracked);

  // obj_a are represented as obj_b:offset + sth
  // if we find obj_b:offset == obj_c
  // we think obj_a alias with obj_c

  
  
  std::map<string, StringSet> ObjMaps;

};

#endif