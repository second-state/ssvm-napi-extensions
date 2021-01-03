# Second State WebAssembly VM for Node.js Addon with all extensions

The [Second State VM (SSVM)](https://github.com/second-state/ssvm) is a high-performance WebAssembly runtime optimized for server-side applications. This project provides support for accessing SSVM as a Node.js addon. It allows Node.js applications to call WebAssembly functions written in Rust or other high-performance languages. [Why do you want to run WebAssembly on the server-side?](https://cloud.secondstate.io/server-side-webassembly/why) The SSVM addon could interact with the wasm files generated by the [ssvmup](https://github.com/second-state/ssvmup) compiler tool.

## NOTICE

SSVM Node.js Addon is in active development.

In the current stage, our prebuilt version **only supports** x86\_64 Linux.
Or you could use `--build-from-source` flag to build from source during addon installation.

## Requirements

After SSVM Napi 0.4.0 release, we upgrade the base image from `Ubuntu 18.04` to `Ubuntu 20.04`.

Users should install the dependencies by the following requirments:

* boost >= 1.65.0
* llvm >= 10
* liblld-10-dev >= 10
* libstdc++6 >= 6.0.28 (GLIBCXX >= 3.4.28)
* g++ version >= 9.0 (Optional, if you have to build from source)

For the tensorflow extensions:

* libpng-dev 
```bash
sudo aptitude install libpng-dev
```
* libjpeg-dev
```bash
sudo aptitude install libjpeg-dev
```
* libtensorflow.so
	* Please refer to [the TensorFlow website](https://www.tensorflow.org/install/lang_c) for more details
	```bash
	cd ~
        wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-2.4.0.tar.gz
        sudo tar -C /usr/local -xzf libtensorflow-cpu-linux-x86_64-2.4.0.tar.gz
	rm -rf libtensorflow-cpu-linux-x86_64-2.4.0.tar.gz
        sudo ldconfig
	```
* libtensorflowlite\_c.so
	* You can use the following commands to get libtensorflowlite\_c.so
	```bash
	# Download TensorFlow deps
	cd ~
	wget https://github.com/second-state/ssvm-tensorflow-deps/releases/download/0.1.0/ssvm-tensorflow-deps-lite-0.1.0-linux-x64.tar.gz
	sudo tar -C /usr/local/lib -xzf ssvm-tensorflow-deps-lite-0.1.0-linux-x64.tar.gz
	sudo ldconfig
	```

## Prepare environment

### Use our docker image or dockerfile

```bash
$ docker pull secondstate/ssvm-extensions
# Or you can build it on your local environment.
$ docker build . -f utils/docker/Dockerfile -t secondstate/ssvm-extensions
```

### Verify the version of llvm

```bash
$ sudo apt list | grep llvm
...omitted...
llvm-dev/focal,now 1:10.0-50~exp1 amd64 [installed]
llvm-runtime/focal,now 1:10.0-50~exp1 amd64 [installed,automatic]
llvm/focal,now 1:10.0-50~exp1 amd64 [installed,automatic]
...omitted...

# If the version is 1:10.x, then your llvm version is correct.
```

### Verify the version of libstdc++6

```bash
$ strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX
...omitted...
GLIBCXX_3.4.24
GLIBCXX_3.4.25
GLIBCXX_3.4.26
GLIBCXX_3.4.27
GLIBCXX_3.4.28
GLIBCXX_DEBUG_MESSAGE_LENGTH

# If you can find GLIBCXX_3.4.28 in the output, then your libstdc++6 version is correct.
```

### Works with Rust library using Wasm-Bindgen

Please refer to [Tutorial: A Wasm-Bindgen application](./Tutorial_Wasm_Bindgen.md).

### Works with Rust application using standalone wasm32-wasi backend

Please refer to [Tutorial: A standalone wasm32-wasi application](./Tutorial_Wasm32_Wasi.md).

## APIs

### Constructor: `ssvm.VM(wasm, ssvm_options) -> vm_instance`
* Create a ssvm instance by given wasm file and options.
* Arguments:
	* `wasm`: Input wasm file, can be the following three formats:
		1. Wasm file path (String, e.g. `/tmp/hello.wasm`)
		2. Wasm bytecode format which is the content of a wasm binary file (Uint8Array)
	* `options`: An options object for setup the SSVM execution environment.
		* `options` <JS Object>
			* `args` <JS Array>: An array of strings that Wasm application will get as function arguments. Default: `[]`
			* `env` <JS Object>: An object like `process.env` that Wasm application will get as its environment variables. Default: `{}`
			* `preopens` <JS Object>: An object which maps '<guest_path>:<host_path>'. E.g. `{'/sandbox': '/some/real/path/that/wasm/can/access'}` Default: `{}`
			* `EnableWasiStartFunction`: This option will disable wasm-bindgen mode and prepare the working environment for standalone wasm program. If you want to run an appliation with `main()`, you should set this to `true`. Default: `false`.
			* `EnableAOT`: This option will enable ssvm aot mode. Default: `false`.
			* `EnableMeasurement`: This option will enable measurement but decrease its performance. Default: `false`.
* Return value:
	* `vm_instance`: A ssvm instance.

### Methods

#### `Start() -> Integer`
* Emit `_start()` and expect the return value type is `Integer` which represents the error code from `main()`.
* Arguments:
	* If you want to append arguments for the standalone wasm program, please set the `args` in `wasi options`.
* Example:
```javascript
let error_code = Start();
```

#### `Run(function_name, args...) -> void`
* Emit `function_name` with `args` and expect the return value type is `void`.
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
Run("Print", 1234);
```

#### `RunInt(function_name, args...) -> Integer`
* Emit `function_name` with `args` and expect the return value type is `Integer` (Int32).
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
let result = RunInt("Add", 1, 2);
// result should be 3
```

#### `RunUInt(function_name, args...) -> Integer`
* Emit `function_name` with `args` and expect the return value type is `Integer` (UInt32).
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
let result = RunInt("Add", 1, 2);
// result should be 3
```

#### `RunInt64(function_name, args...) -> BigInt`
* Emit `function_name` with `args` and expect the return value type is `BigInt` (Int64).
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
let result = RunInt("Add", 1, 2);
// result should be 3
```

#### `RunUInt64(function_name, args...) -> BigInt`
* Emit `function_name` with `args` and expect the return value type is `BigInt` (UInt64).
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
let result = RunInt("Add", 1, 2);
// result should be 3
```

#### `RunString(function_name, args...) -> String`
* Emit `function_name` with `args` and expect the return value type is `String`.
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
let result = RunString("PrintMathScore", "Amy", 98);
// result: "Amy’s math score is 98".
```

#### `RunUint8Array(function_name, args...) -> Uint8Array`
* Emit `function_name` with `args` and expect the return value type is `Uint8Array`.
* Arguments:
	* `function_name` <String>: The function name which users want to emit.
	* `args` <Integer/String/Uint8Array>\*: The function arguments. The delimiter is `,`
* Example:
```javascript
let result = RunUint8Array("Hash", "Hello, world!");
// result: "[12, 22, 33, 42, 51]".
```

#### `Compile(output_filename) -> boolean`
* Compile a given wasm file (can be a file path or a byte array) into a native binary whose name is the given `output_filename`.
* This function uses SSVM AOT compiler.
* Return `false` when the compilation failed.
```javascript
// Compile only
let vm = ssvm.VM("/path/to/wasm/file", options);
vm.Compile("/path/to/aot/file");

// When you want to run the compiled file
let vm = ssvm.VM("/path/to/aot/file", options);
vm.RunXXX("Func", args);
```

#### `GetStatistics() -> Object`
* If you want to enable measurement, set the option `EnableMeasurement` to `true`. But please notice that enabling measurement will significantly affect performance.
* Get the statistics of execution runtime.
* Return Value `Statistics` <Object>
	* `Measure` -> <Boolean>: To show if the measurement is enabled or not.
	* `TotalExecutionTime` -> <Integer>: Total execution time (Wasm exeuction time + Host function execution time) in `ns` unit.
	* `WasmExecutionTime` -> <Integer>: Wasm instructions execution time in `ns` unit.
	* `HostFunctionExecutionTime` -> <Integer>: Host functions (e.g. eei or wasi functions) execution time in `ns` unit.
	* `InstructionCount` -> <Integer>: The number of executed instructions in this execution.
	* `TotalGasCost` -> <Integer>: The cost of this execution.
	* `InstructionPerSecond` -> <Float>: The instructions per second of this execution.
```javascript
let result = RunInt("Add", 1, 2);
// result should be 3
let stat = GetStatistics();
/*
If the `EnableMeasurement: true`:

stat = Statistics:  {
  Measure: true,
  TotalExecutionTime: 1512,
  WasmExecutionTime: 1481,
  HostFunctionExecutionTime: 31,
  InstructionCount: 27972,
  TotalGasCost: 27972,
  InstructionPerSecond: 18887238.35246455
}

Else:

stat = Statistics:  {
  Measure: false
}
*/
```
