# Runno WASI runtime

> This is a simplified version of the [`@runno/wasi`](https://www.npmjs.com/package/@runno/wasi) runtime.

This package allows you to run WASI binaries on the web with an emulated
filesystem. If the binary receives calls to stdin/out/err then you get callbacks
you'll need to handle. In future there may be other callbacks to intercept
interesting system level events, or hooks into the filesystem.

## Quickstart

The quickest way to get started with Runno is by using the `WASI.start` class
method. It will set up everything you need and run the Wasm binary directly.

Be aware that this will run on the main thread, not inside a worker. So you will
interrupt any interactive use of the browser until it completes.

```html
<script src="https://unpkg.com/@antonz/runno/dist/runno.js"></script>
```

```js
const { WASI } = window.Runno;

//...

const result = WASI.start(fetch("/binary.wasm"), {
    args: ["binary-name", "--do-something", "some-file.txt"],
    env: { SOME_KEY: "some value" },
    stdout: (out) => console.log("stdout", out),
    stderr: (err) => console.error("stderr", err),
    stdin: () => prompt("stdin:"),
    fs: {
        "/some-file.txt": {
            path: "/some-file.txt",
            timestamps: {
                access: new Date(),
                change: new Date(),
                modification: new Date(),
            },
            mode: "string",
            content: "Some content for the file.",
        },
    },
});
```

_Note: The `args` should start with the name of the binary. Like when you run
a terminal command, you write `cat somefile` the name of the binary is `cat`._

## The filesystem

`@runno/wasi` internally emulates a unix-like filesystem (FS) from a flat
structure. All files must start with a `/` to indicate they are in the root
directory. The `/` directory is preopened by `@runno/wasi` for your WASI binary
to use.

Paths provided to the FS can include directory names `/like/this.png`. The FS
will treat files with the same prefix `/like/so.png` as if they are in the same
folder. Any folders created will contain an empty `.runno` file `/like/.runno`
as a placeholder.

WASI has a complex permissions system that is entirely ignored. All files you
provide can be accessed by the WASI binary, with all permissions.

## Which WASI standards are supported?

Currently `@runno/wasi` supports running only `unstable` and `snapshot-preview1`
WASI binaries. The `snapshot-preview1` standard is more recent, and preferred.
Additionally its likely some details of `unstable` have been missed. If you spot
these, please file a bug.

Other extension standards like WASMEdge, and WASIX are currently not supported,
but could be. WASI Modules are also not supported, but I'm interested in
learning more about them.

## License

Copyright 2023 [Ben Taylor](https://taybenlor.com/).

The software is available under the MIT license.
