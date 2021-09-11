{
  "targets": [
    {
      "target_name": "action_before_build",
      "type": "none",
      "hard_dependency": 1,
      "actions": [
        {
          "action_name": "build rust-native-storage library",
          "inputs": [ "scripts/build_storage_lib.sh" ],
          "outputs": [ "" ],
          "action": ["scripts/build_storage_lib.sh"]
        }
      ]
    },
    {
      "target_name": "<(module_name)",
      "dependencies": [ "action_before_build" ],
      "cflags_cc": [ "-std=c++17" ],
      "cflags!": [ "-fno-exceptions", "-fno-rtti" ],
      "cflags_cc!": [ "-fno-exceptions", "-fno-rtti" ],
      "link_settings": {
          "libraries": [
              "../rust_native_storage_library/target/debug/librust_native_storage_library.a",
              "/usr/local/lib/libwasmedge-tensorflow_c.so",
              "/usr/local/lib/libwasmedge-tensorflowlite_c.so",
              "/usr/local/lib/libwasmedge-image_c.so",
              "/usr/local/lib/libwasmedge-storage_c.so",
              "/usr/local/lib/libwasmedge_c.so",
              "/usr/local/lib/libtensorflow.so",
              "/usr/local/lib/libtensorflow_framework.so",
              "/usr/local/lib/libtensorflowlite_c.so",
              "-ljpeg",
              "-lpng",
          ]
      },
      "sources": [
        "wasmedgeaddon.cc",
        "wasmedge-core/src/addon.cc",
        "wasmedge-core/src/bytecode.cc",
        "wasmedge-core/src/options.cc",
        "wasmedge-core/src/utils.cc",
      ],
      "include_dirs": [
        "<!@(node -p \"require('node-addon-api').include\")",
        "wasmedge-core/src",
        "/usr/local/include",
      ],
      'defines': [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ],
    },
    {
      "target_name": "action_after_build",
      "type": "none",
      "dependencies": [ "<(module_name)" ],
      "copies": [
        {
          "files": [ "<(PRODUCT_DIR)/<(module_name).node" ],
          "destination": "<(module_path)"
        }
      ]
    }
  ]
}
