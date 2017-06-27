#! /bin/sh

PARALLEL=3

echo "Running docker"
echo "PARALLEL=$PARALLEL"

# make sure current directory is writable to the container
chmod a+w ../packages

docker run -i --volume $(pwd)/../packages:/home/nistmni/build minc-build_debian_8_x64  /bin/bash <<END
mkdir src
cd src
git clone --recursive --branch develop https://github.com/BIC-MNI/minc-toolkit-v2.git minc-toolkit-v2
mkdir -p build/minc-toolkit-v2
cd build/minc-toolkit-v2
cmake ../../minc-toolkit-v2 \
-DCMAKE_BUILD_TYPE:STRING=Release   \
-DCMAKE_INSTALL_PREFIX:PATH=/opt/minc/1.9.15 \
-DMT_BUILD_ABC:BOOL=ON   \
-DMT_BUILD_ANTS:BOOL=ON   \
-DMT_BUILD_C3D:BOOL=ON   \
-DMT_BUILD_ELASTIX:BOOL=ON   \
-DMT_BUILD_IM:BOOL=OFF   \
-DMT_BUILD_ITK_TOOLS:BOOL=ON   \
-DMT_BUILD_LITE:BOOL=OFF   \
-DMT_BUILD_SHARED_LIBS:BOOL=ON   \
-DMT_BUILD_VISUAL_TOOLS:BOOL=ON   \
-DMT_USE_OPENMP:BOOL=ON   \
-DMT_BUILD_OPENBLAS:BOOL=ON \
-DMT_BUILD_SHARED_LIBS:BOOL=ON \
-DBUILD_TESTING:BOOL=ON \
-DMT_BUILD_LITE:BOOL=OFF \
-DMT_BUILD_QUIET:BOOL=ON \
-DUSE_SYSTEM_GLUT:BOOL=OFF \
-DUSE_SYSTEM_FFTW3D:BOOL=OFF   \
-DUSE_SYSTEM_FFTW3F:BOOL=OFF   \
-DUSE_SYSTEM_GLUT:BOOL=OFF   \
-DUSE_SYSTEM_GSL:BOOL=OFF   \
-DUSE_SYSTEM_HDF5:BOOL=OFF   \
-DUSE_SYSTEM_ITK:BOOL=OFF   \
-DUSE_SYSTEM_NETCDF:BOOL=OFF   \
-DUSE_SYSTEM_NIFTI:BOOL=OFF   \
-DUSE_SYSTEM_PCRE:BOOL=OFF   \
-DUSE_SYSTEM_ZLIB:BOOL=OFF  && \
make -j${PARALLEL} &&
cpack -G DEB &&
cp -v *.deb ~/build/
END
exit
