Periodic builds of [dawn][] WebGPU implementation for Mac, Linux and Windows (x64 and arm64).

All builds include `webgpu.h` for use with the dawn shared library.

### For Windows
Build includes a single `webgpu_dawn.dll` file that exports all public Dawn WebGPU C functions.
To use in your code - either load the `webgpu_dawn.dll` file dynamically or link to it via `webgpu_dawn.lib` import library.

### For Linux/Mac
Build includes single `libwebgpu_dawn.so` or `libwebgpu_dawn.dylib`

Download binary build as zip archive from [latest release][] page.


For small example of using Dawn in C see this [gist][].

[dawn]: https://dawn.googlesource.com/dawn/
[latest release]: https://github.com/mmozeiko/build-dawn/releases/latest
[gist]: https://gist.github.com/mmozeiko/4c68b91faff8b7026e8c5e44ff810b62
