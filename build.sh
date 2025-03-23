#!/bin/bash

# first argument is the architecture valid values are x64, arm, arm64
ARCH=$1

# check if ARCH is set
if [ -z "$ARCH" ]; then
  # error out if ARCH is not set
  echo "ARCH is not set"
  exit 1
fi

# check if ARCH is valid
if [ "$ARCH" != "x64" ] && [ "$ARCH" != "arm" ] && [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x86_64" ]; then
  # error out if ARCH is not valid
  echo "ARCH is not valid $ARCH"
  exit 1
fi

#check if dawn directory exists
if [ -d "dawn" ]; then
  # error out if the directory exists
  echo "dawn directory already exists"
  exit 1
fi

# check if DAWN_COMMIT is set
if [ -z "$DAWN_COMMIT" ]; then
  # error out if DAWN_COMMIT is not set
  echo "DAWN_COMMIT is not set"
  exit 1
fi

# check if BUILD_DATE is set
if [ -z "$BUILD_DATE" ]; then
  # error out if BUILD_DATE is not set
  echo "BUILD_DATE is not set"
  exit 1
fi

mkdir dawn
pushd dawn
git init .
git remote add origin https://dawn.googlesource.com/dawn

git fetch origin $DAWN_COMMIT
git checkout --force FETCH_HEAD

popd

# build dawn
cmake \
  -S dawn                                     \
  -B dawn.build-$ARCH                         \
  -D CMAKE_BUILD_TYPE=Release                 \
  -D CMAKE_POLICY_DEFAULT_CMP0091=NEW         \
  -D CMAKE_POLICY_DEFAULT_CMP0092=NEW         \
  -D DAWN_BUILD_SAMPLES=OFF                   \
  -D DAWN_BUILD_TESTS=OFF                     \
  -D DAWN_ENABLE_D3D12=ON                     \
  -D DAWN_ENABLE_D3D11=OFF                    \
  -D DAWN_ENABLE_NULL=OFF                     \
  -D DAWN_ENABLE_DESKTOP_GL=OFF               \
  -D DAWN_ENABLE_OPENGLES=OFF                 \
  -D DAWN_USE_GLFW=OFF                        \
  -D DAWN_ENABLE_SPIRV_VALIDATION=OFF         \
  -D DAWN_DXC_ENABLE_ASSERTS_IN_NDEBUG=OFF    \
  -D DAWN_FETCH_DEPENDENCIES=ON               \
  -D DAWN_BUILD_MONOLITHIC_LIBRARY=ON         \
  -D TINT_BUILD_TESTS=OFF                     \
  -D TINT_BUILD_SPV_READER=ON                 \
  -D TINT_BUILD_SPV_WRITER=ON                 \
  -D TINT_BUILD_CMD_TOOLS=ON

cmake --build dawn.build-$ARCH --config Release --target webgpu_dawn tint_cmd_tint_cmd --parallel

# copy the output to the output directory
mkdir dawn-$ARCH
mkdir -p dawn-$ARCH/include
mkdir -p dawn-$ARCH/lib
mkdir -p dawn-$ARCH/bin

echo $DAWN_COMMIT > dawn-$ARCH/commit.txt

cp dawn.build-$ARCH/gen/include/dawn/webgpu.h dawn-$ARCH/include
cp dawn.build-$ARCH/Release/webgpu_dawn.so dawn-$ARCH/lib | true
cp dawn.build-$ARCH/Release/webgpu_dawn.dylib  dawn-$ARCH/lib | true
cp dawn.build-$ARCH/Release/tint              dawn-$ARCH/bin


zip -r dawn-$ARCH-$BUILD_DATE.zip dawn-$ARCH

