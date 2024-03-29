#ifndef WASMEDGEADDON_H
#define WASMEDGEADDON_H

#include "bytecode.h"
#include "cache.h"
#include "errors.h"
#include "options.h"
#include "utils.h"

#include <napi.h>
#include <string>
#include <unordered_map>
#include <vector>
#include <wasmedge.h>

class WasmEdgeAddon : public Napi::ObjectWrap<WasmEdgeAddon> {
public:
  static Napi::Object Init(Napi::Env Env, Napi::Object Exports);
  WasmEdgeAddon(const Napi::CallbackInfo &Info);
  ~WasmEdgeAddon() {
    if (Configure != nullptr) {
      WasmEdge_ConfigureDelete(Configure);
      Configure = nullptr;
    }
    if (VM != nullptr) {
      WasmEdge_VMDelete(VM);
      VM = nullptr;
    }
  };

  enum class IntKind { Default, SInt32, UInt32, SInt64, UInt64 };

private:
  using ErrorType = WASMEDGE::NAPI::ErrorType;
  static Napi::FunctionReference Constructor;
  WasmEdge_ConfigureContext *Configure;
  WasmEdge_StoreContext *Store;
  WasmEdge_VMContext *VM;
  WasmEdge_MemoryInstanceContext *MemInst;
  WasmEdge_StatisticsContext *Stat;
  WasmEdge_ImportObjectContext *WasiMod;
  WasmEdge_ImportObjectContext *ImageMod;
  WasmEdge_ImportObjectContext *TensorflowMod;
  WasmEdge_ImportObjectContext *TensorflowLiteMod;
  WASMEDGE::NAPI::Bytecode BC;
  WASMEDGE::NAPI::Options Options;
  WASMEDGE::NAPI::Cache Cache;
  bool Inited;

  /// Setup related functions
  void InitVM(const Napi::CallbackInfo &Info);
  void FiniVM();
  void InitWasi(const Napi::CallbackInfo &Info, const std::string &FuncName);
  void LoadWasm(const Napi::CallbackInfo &Info);
  /// WasmBindgen related functions
  void PrepareResource(const Napi::CallbackInfo &Info,
                       std::vector<WasmEdge_Value> &Args, IntKind IntT);
  void PrepareResource(const Napi::CallbackInfo &Info,
                       std::vector<WasmEdge_Value> &Args);
  void ReleaseResource(const Napi::CallbackInfo &Info, const uint32_t Offset,
                       const uint32_t Size);
  /// Run functions
  void Run(const Napi::CallbackInfo &Info);
  Napi::Value RunStart(const Napi::CallbackInfo &Info);
  Napi::Value RunCompile(const Napi::CallbackInfo &Info);
  Napi::Value RunIntImpl(const Napi::CallbackInfo &Info, IntKind IntT);
  Napi::Value RunInt(const Napi::CallbackInfo &Info);
  Napi::Value RunUInt(const Napi::CallbackInfo &Info);
  Napi::Value RunInt64(const Napi::CallbackInfo &Info);
  Napi::Value RunUInt64(const Napi::CallbackInfo &Info);
  Napi::Value RunString(const Napi::CallbackInfo &Info);
  Napi::Value RunUint8Array(const Napi::CallbackInfo &Info);
  /// Statistics
  Napi::Value GetStatistics(const Napi::CallbackInfo &Info);
  /// AoT functions
  bool Compile();
  bool CompileBytecodeTo(const std::string &Path);
  void InitReactor(const Napi::CallbackInfo &Info);
  /// Error handling functions
  void ThrowNapiError(const Napi::CallbackInfo &Info, ErrorType Type);
};

#endif
