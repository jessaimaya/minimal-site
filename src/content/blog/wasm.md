---
title: "Wasm Notes"
description: "Notes about wasm"
pubDate: "Jun 22 2024"
heroImage: "/blog-placeholder-3.jpg"
---

> Jun 21 2024 | Binary Data

## Load data

Having a file `.wasm` file, we can decode it using some binary debug tools. An interest way to do it is analyzing the internal bits. It is as simple as read the file and write it's content to a buffer.

We just need to create a method to print out the content of a `.wasm` file, the result could be copied directly in javascript to create a byte array as `Int8Array` to be able to create a `WebAssembly` instance.

```rust
fn wasm_printer(filename: &str) {
    let mut file = File::open(filename).expect("could not open the file");
    let metadata = fs::metadata(filename).expect("could not read metadata from file");
    let mut buffer = vec![0; metadata.len() as usize];
    file.read(&mut buffer).expect("error writing file content into buffer");
    println!("{:?}", buffer);
}
```

We can translate the meaning of each bit reading the Spec of it's [Binary Format]("https://webassembly.github.io/spec/core/binary/conventions.html")

```bash
    [0, 97, 115, 109, 1, 0, 0, 0, 1, 7, 1, 96, 2, 127, 127, 1, 127, 3, 2, 1, 0, 7, 10, 1, 6, 97, 100, 100, 84, 119, 111, 0, 0, 10, 9, 1, 7, 0, 32, 0, 32, 1, 106, 11, 0, 10, 4, 110, 97, 109, 101, 2, 3, 1, 0, 0]
```

```javascript
async function load() {
  const byteArray = new Int8Array([
    0, 97, 115, 109, 1, 0, 0, 0, 1, 7, 1, 96, 2, 127, 127, 1, 127, 3, 2, 1, 0,
    7, 10, 1, 6, 97, 100, 100, 84, 119, 111, 0, 0, 10, 9, 1, 7, 0, 32, 0, 32, 1,
    106, 11, 0, 10, 4, 110, 97, 109, 101, 2, 3, 1, 0, 0,
  ]);
  const wasm = await WebAssembly.instantiate(byteArray.buffer);
  const addTwo = wasm.instance.exports.addTwo;
  console.log(addTwo(1, 10));
}
```

Or we can just simply load it the classic way using `fetch`.

```diff
async function load() {
+  const response = await fetch("test.wasm");
+  const buffer = await response.arrayBuffer();
-  const byteArray = new Int8Array([
-    0, 97, 115, 109, 1, 0, 0, 0, 1, 7, 1, 96, 2, 127, 127, 1, 127, 3, 2, 1, 0,
-    7, 10, 1, 6, 97, 100, 100, 84, 119, 111, 0, 0, 10, 9, 1, 7, 0, 32, 0, 32, 1,
-    106, 11, 0, 10, 4, 110, 97, 109, 101, 2, 3, 1, 0, 0,
-  ]);
+  const wasm = await WebAssembly.instantiate(buffer);
-  const wasm = await WebAssembly.instantiate(byteArray.buffer);
  const addTwo = wasm.instance.exports.addTwo;
  console.log(addTwo(1, 10));
}
```

## Import from wasm

If we need to call some methods from a mdoule inside wasm, we can do it pretty simple.
Imagine our module exports some methods.

```javascript
const module = {
  public: {
    hi: () => console.log("Hi from module"),
    bye: () => console.log("Bye! from module"),
  },
};
```

Pass this `module` to wasm instance.

```diff
- const wasm = await WebAssembly.instantiate(buffer);
+ const wasm = await WebAssembly.instantiate(buffer, module);
```

We need to import our exposed methods `public` -> `hi` & `public` -> `bye`

```wasm
  (import "public" "hi" (func $hi))
  (import "public" "bye" (func $bye))
```

Then we can invoke them like:

```wasm
    call $hi
    call $bye
```

## Sharing memory

### Wasm to Javascript

First let's add some memory in wasm file.

- 1 means a page, meaning around 64Kb
- `data` used to load some data into memory

```diff
(module
  (import "public" "hi" (func $hi))
  (import "public" "bye" (func $bye))
+ (memory $mem 1)
+ (data (i32.const 0) "hi")
  (func (export "addTwo") (param i32 i32) (result i32)
    call $hi
    call $bye
    local.get 0
    local.get 1
    i32.add)
+ (export "mem" (memory $mem))
)
```

Now lets retrieve this 2 bits string `hi` in javascript.

```diff
async function load() {
    const  module = {
        public: {
            hi: () => console.log("Hi from module"),
            bye: () => console.log("Bye! from module"),
        }
    };

    const response = await fetch("memory.wasm");
    const buffer = await response.arrayBuffer();

    const wasm = await WebAssembly.instantiate(buffer, module);
    const addTwo = wasm.instance.exports.addTwo;
+   const wasmMemory = wasm.instance.exports.mem;
+   const memoryArray = new Uint8Array(wasmMemory.array, 0, 2);

+   const wasmText = new TextDecoder().decode(memoryArray);
    console.log(addTwo(1,10))
+   console.log(wasmText)
}
```

### Javascript to Wasm

To test how we can set some memory from javascript into wasm memory let's define some memory in javacript file, then instantiate wasm file and fill this memory from it.

```diff javascript
+   const memory = WebAssembly.Memory({initial: 1}); //-> here memory is empty
    const  module = {
        public: {
+           mem: memory,
            hi: () => console.log("Hi from module"),
            bye: () => console.log("Bye! from module"),
        }
    };
    const response = await fetch("memjs.wasm");
    const buffer = await response.arrayBuffer();

    const wasm = await WebAssembly.instantiate(buffer, module);
    //-> after instantiate, memory mutated with "hi" from wasm file
    const addTwo = wasm.instance.exports.addTwo;
-   const wasmMemory = wasm.instance.exports.mem;
-   const memoryArray = new Uint8Array(wasmMemory.array, 0, 2);
+   const memoryArray = new Uint8Array(memory.buffer, 0, 2);
    const wasmText = new TextDecoder().decode(memoryArray);
    console.log(addTwo(1,10))
    console.log(wasmText)
```

```diff
(module
  (import "public" "hi" (func $hi))
  (import "public" "bye" (func $bye))
- (memory $mem 1)
+ (memory (import "public" "mem") 1) //-> here, memory is changed by the imported one, then "hi" is set to this memory slot.
  (data (i32.const 0) "hi")
  (func (export "addTwo") (param i32 i32) (result i32)
    call $hi
    call $bye
    local.get 0
    local.get 1
    i32.add)
- (export "mem" (memory $mem))
)
```
