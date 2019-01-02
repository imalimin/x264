#!/bin/bash
NDK=/Users/lmy/Library/Android/android-ndk-r14b

build(){
  ARCH=$1
  PLATFORM=
  TOOLCHAIN=
  HOST=
  EXTRA_CFLAGS=
  EXTRA_X264_FLAGS=
  PREFIX=$(pwd)/product/$ARCH

  OS=linux-x86_64
  if [ ` uname -s ` = "Darwin" ]; then
    OS=darwin-x86_64
  fi

  if [ "$ARCH" = "armv7a" ]; then
    echo "------BUILD armv7a--------"
    PLATFORM=$NDK/platforms/android-19/arch-arm/
    TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}/bin/arm-linux-androideabi-
    HOST=arm-linux
    EXTRA_CFLAGS="${EXTRA_FLAGS} -fPIC -marm -DX264_VERSION -DANDROID -DHAVE_PTHREAD -DNDEBUG -static -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__"
    EXTRA_CFLAGS="${EXTRA_FLAGS} -O3 -march=armv7-a -mfpu=neon -mtune=generic-armv7-a"
    EXTRA_FLAGS="${EXTRA_FLAGS} -mfloat-abi=softfp -ftree-vectorize -mvectorize-with-neon-quad -ffast-math"
    EXTRA_X264_FLAGS="${EXTRA_X264_FLAGS} --disable-lavf"
  elif [ "$ARCH" = "x86" ]; then
    echo "------BUILD x86--------"
    PLATFORM=$NDK/platforms/android-19/arch-x86/
    TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/${OS}/bin/i686-linux-android-
    HOST=i686-linux
    EXTRA_CFLAGS="${EXTRA_FLAGS} -fPIC -DX264_VERSION -DANDROID -DHAVE_PTHREAD -DNDEBUG"
    EXTRA_CFLAGS="${EXTRA_FLAGS} -static -O3 -march=atom -mtune=atom -mssse3 -ffast-math -ftree-vectorize -mfpmath=sse"
    EXTRA_X264_FLAGS="${EXTRA_X264_FLAGS} --disable-asm"
  else
    echo "Need a arch param"
    exit 1
  fi

  ./configure \
  --prefix=$PREFIX \
  --enable-pic \
  --enable-static \
  --host=$HOST \
  --cross-prefix=$TOOLCHAIN \
  --sysroot=$PLATFORM \
  --extra-cflags=${EXTRA_CFLAGS} \
  $EXTRA_X264_FLAGS

  make clean
  make -j4
  make install
}

build $1
