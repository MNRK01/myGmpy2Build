# script to build gmpy2 (depends on gmp, mpfr, mpc, mpir) and bigfloat (depends on gmp and mpfr)
# this scripts assumes a working msys64 envirnoment (bash, ls, mv, cp, etc.), mingw-w64 gcc, binutils
# and yasm (for mpir). YMMV - you can always add a package using `pacman -S ...`, if something is missing

# ============= SETUP OF BASE VARIABLES ============================================

# from mingw-builds/library/functions.sh
function die {
	# $1 - message on exit
	# $2 - exit code
	local _retcode=1
	[[ -n $2 ]] && _retcode=$2
	echo
	>&2 echo $1
	exit $_retcode
}

# compiler type
SYSTYPE=x86_64-w64-mingw32

# root and lib install directories
ROOTDIR=/c/Software/python-build
INSTALLDIR=$ROOTDIR/build

# check for gmpy, gmpy-build dirs and build-info.txt, build-log.txt
[[ -d $ROOTDIR ]] || mkdir $ROOTDIR
[[ -d $INSTALLDIR ]] || mkdir $INSTALLDIR
[[ -e $ROOTDIR/build-info.txt ]] && rm $ROOTDIR/build-info.txt
[[ -e $ROOTDIR/build-log.txt ]] && rm $ROOTDIR/build-log.txt

# version numbers
GMPVER="6.2.1"
MPFRVER="4.1.0"
MPIRVER="3.0.0"
MPCVER="1.2.0"
GMPY2VER="2.1.1"
BIGFLOATVER="0.4.0"

# directory variables
GMPDIR=$ROOTDIR/gmp-$GMPVER
MPFRDIR=$ROOTDIR/mpfr-$MPFRVER
MPIRDIR=$ROOTDIR/mpir-$MPIRVER
MPCDIR=$ROOTDIR/mpc-$MPCVER
GMPY2DIR=$ROOTDIR/gmpy2-$GMPY2VER
BIGFLOATDIR=$ROOTDIR/bigfloat-$BIGFLOATVER

# compiler and linker flags, import to export these variables
export CPPFLAGS="${CPPFLAGS} -I$INSTALLDIR/include -D__USE_MINGW_ANSI_STDIO=1"
export CFLAGS="${CFLAGS} -D__USE_MINGW_ANSI_STDIO=1"
export C_INCLUDE_PATH="${CPPFLAGS}"
export LDFLAGS="${LDFLAGS} -L$INSTALLDIR/lib"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH} -L$INSTALLDIR/lib"

# capture variables to build-info.txt
cd $ROOTDIR
gcc -v 2>>$ROOTDIR/build-info.txt
echo "=======================================" >> $ROOTDIR/build-info.txt

# ============= BUILD GMP, MPFR, MPIR, MPC =========================================

# download, extract sources, build and install gmp
echo "Starting gmp-${GMPVER} build..."
echo "Starting gmp-${GMPVER} build..." >> $ROOTDIR/build-log.txt
cd $ROOTDIR
[[ -e gmp-${GMPVER}.tar.xz ]] || wget https://gmplib.org/download/gmp/gmp-${GMPVER}.tar.xz >> $ROOTDIR/build-log.txt 2>&1
[[ -d ${GMPDIR} ]] || tar -xJf gmp-${GMPVER}.tar.xz >> $ROOTDIR/build-log.txt
cd $GMPDIR
./configure --build=$SYSTYPE --host=$SYSTYPE --prefix=$INSTALLDIR --enable-static --disable-shared 1>>$ROOTDIR/build-log.txt 2>&1
make all 1>>$ROOTDIR/build-log.txt 2>&1
make check 1>>$ROOTDIR/build-log.txt 2>&1
make install 1>>$ROOTDIR/build-log.txt 2>&1
echo "=======================================" >> $ROOTDIR/build-log.txt
# add information to buildinfo.txt
echo "Writing build info to ${ROOTDIR}/build-info.txt"
echo "name         : gmp-${GMPVER}"                                                     >> $ROOTDIR/build-info.txt
echo "type         : .xz"                                                               >> $ROOTDIR/build-info.txt
echo "version      : $GMPVER"                                                           >> $ROOTDIR/build-info.txt
echo "url          : https://gmplib.org/download/gmp/gmp-${GMPVER}.tar.xz"              >> $ROOTDIR/build-info.txt
echo "patches      :"                                                                   >> $ROOTDIR/build-info.txt
echo "configuration: gmpy2-build-v3.sh"                                                 >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt
echo "# **************************************************************************"     >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt

# download, extract sources, build and install mpfr
echo "Starting mpfr-${MPFRVER} build..."
echo "Starting mpfr-${MPFRVER} build..." >> $ROOTDIR/build-log.txt
cd $ROOTDIR
[[ -e mpfr-${MPFRVER}.tar.xz ]] || wget https://www.mpfr.org/mpfr-current/mpfr-${MPFRVER}.tar.xz >> $ROOTDIR/build-log.txt 2>&1
[[ -d ${MPFRDIR} ]] || tar -xJf mpfr-${MPFRVER}.tar.xz >> $ROOTDIR/build-log.txt
cd $MPFRDIR
./configure --build=$SYSTYPE --host=$SYSTYPE --prefix=$INSTALLDIR --with-gmp=$INSTALLDIR --enable-static --disable-shared 1>>$ROOTDIR/build-log.txt 2>&1
make all 1>>$ROOTDIR/build-log.txt 2>&1
make check 1>>$ROOTDIR/build-log.txt 2>&1
make install 1>>$ROOTDIR/build-log.txt 2>&1
echo "=======================================" >> $ROOTDIR/build-log.txt
# add information to buildinfo.txt
echo "Writing build info to ${ROOTDIR}/build-info.txt"
echo "name         : mpfr-${MPFRVER}"                                                   >> $ROOTDIR/build-info.txt
echo "type         : .xz"                                                               >> $ROOTDIR/build-info.txt
echo "version      : $MPFRVER"                                                          >> $ROOTDIR/build-info.txt
echo "url          : https://www.mpfr.org/mpfr-current/mpfr-${MPFRVER}.tar.xz"          >> $ROOTDIR/build-info.txt
echo "patches      :"                                                                   >> $ROOTDIR/build-info.txt
echo "configuration: gmpy2-build-v3.sh"                                                 >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt
echo "# **************************************************************************"     >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt

# download, extract sources, build and install mpir
echo "Starting mpir-${MPIRVER} build..."
echo "Starting mpir-${MPIRVER} build..." >> $ROOTDIR/build-log.txt
cd $ROOTDIR
[[ -e mpir-${MPIRVER}.zip ]] || wget http://mpir.org/mpir-${MPIRVER}.zip >> $ROOTDIR/build-log.txt 2>&1
[[ -d ${MPIRDIR} ]] || unzip mpir-${MPIRVER}.zip >> $ROOTDIR/build-log.txt
cd $MPIRDIR
./configure --build=$SYSTYPE --host=$SYSTYPE --prefix=$INSTALLDIR --enable-static --disable-shared 1>>$ROOTDIR/build-log.txt 2>&1
make all 1>>$ROOTDIR/build-log.txt 2>&1
make check 1>>$ROOTDIR/build-log.txt 2>&1
make install 1>>$ROOTDIR/build-log.txt 2>&1
echo "=======================================" >> $ROOTDIR/build-log.txt
# add information to buildinfo.txt
echo "Writing build info to ${ROOTDIR}/build-info.txt"
echo "name         : mpir-${MPIRVER}"                                                   >> $ROOTDIR/build-info.txt
echo "type         : .zip"                                                              >> $ROOTDIR/build-info.txt
echo "version      : $MPIRVER"                                                          >> $ROOTDIR/build-info.txt
echo "url          : http://mpir.org/mpir-${MPIRVER}.zip"                               >> $ROOTDIR/build-info.txt
echo "patches      :"                                                                   >> $ROOTDIR/build-info.txt
echo "configuration: gmpy2-build-v3.sh"                                                 >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt
echo "# **************************************************************************"     >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt

# download, extract sources, build and install mpc
echo "Starting mpc-${MPCVER} build..."
echo "Starting mpc-${MPCVER} build..." >> $ROOTDIR/build-log.txt
cd $ROOTDIR
[[ -e mpc-${MPCVER}.tar.gz ]] || wget https://ftp.gnu.org/gnu/mpc/mpc-${MPCVER}.tar.gz >> $ROOTDIR/build-log.txt 2>&1
[[ -d ${MPCDIR} ]] || tar -xzf mpc-${MPCVER}.tar.gz >> $ROOTDIR/build-log.txt
cd $MPCDIR
./configure --build=$SYSTYPE --host=$SYSTYPE --prefix=$INSTALLDIR --with-gmp=$INSTALLDIR --with-mpfr=$INSTALLDIR --enable-static --disable-shared --disable-silent-rules 1>>build-log.txt 2>&1
make all 1>>build-log.txt 2>&1
make check 1>>build-log.txt 2>&1
make install 1>>build-log.txt 2>&1
echo "=======================================" >> $ROOTDIR/build-log.txt
# add information to buildinfo.txt
echo "Writing build info to ${ROOTDIR}/build-info.txt"
echo "name         : mpc-${MPCVER}"                                                     >> $ROOTDIR/build-info.txt
echo "type         : .tar.gz"                                                           >> $ROOTDIR/build-info.txt
echo "version      : $MPCVER"                                                           >> $ROOTDIR/build-info.txt
echo "url          : https://ftp.gnu.org/gnu/mpc/mpc-${MPCVER}.tar.gz"                  >> $ROOTDIR/build-info.txt
echo "patches      :"                                                                   >> $ROOTDIR/build-info.txt
echo "configuration: gmpy2-build-v3.sh"                                                 >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt
echo "# **************************************************************************"     >> $ROOTDIR/build-info.txt
echo                                                                                    >> $ROOTDIR/build-info.txt

# ============= BUILD GMPY2 AND BIGFLOAT ===========================================

# python needed for building gmpy2 and bigfloat, gmpy2 can use mpir
PYTHONDIR=/c/Software/Anaconda3
PYTHONSCRIPTSDIR=$PYTHONDIR/scripts
PYTHONLIBBINDIR=$PYTHONDIR/Library/bin
PYGMPY2DIR=$PYTHONDIR/Lib/site-packages/gmpy2
[[ -d $PYTHONDIR ]] || die "Python directory not found!"
OLDPATH=$PATH
PATH=$PYTHONDIR:$PYTHONSCRIPTSDIR:$PYTHONLIBBINDIR:$PATH

# download, extract sources, build and install gmpy2
# **this requires a patched ccygwincompiler.py, and (lib)python3x.{a,def}, (lib)vcruntime140.{a,def} in $PYTHONDIR/libs**
# dlltool --dllname vcruntime140.dll --input-def vcruntime140.def --output-lib libvcruntime140.a && mv *.a *.def libs
# dlltool --dllname python39.dll --input-def python39.def --output-lib libpython39.a && mv *.a *.def libs
echo "Starting gmpy2-${GMPY2VER} build..."
echo "Starting gmpy2-${GMPY2VER} build..." >> $ROOTDIR/build-log.txt
cd $ROOTDIR
# [[ -e gmpy2-${GMPY2VER}.tar.gz ]] || wget https://files.pythonhosted.org/packages/1d/6c/f913b453446d2ed8bf2151be5f92ce2eabaa72ceb2f98c071ad77329b964/gmpy2-${GMPY2VER}.tar.gz >> $ROOTDIR/build-log.txt 2>&1
[[ -e gmpy2-${GMPY2VER}.tar.gz ]] || wget https://files.pythonhosted.org/packages/7b/b9/a2b3ab43beff51d0bdec1363c6eea4e6cdbd01f6c3527ad4192a037cf324/gmpy2-${GMPY2VER}.tar.gz >> $ROOTDIR/build-log.txt 2>&1
[[ -d ${GMPY2DIR} ]] || tar -xzf gmpy2-${GMPY2VER}.tar.gz >> $ROOTDIR/build-log.txt 2>&1
cd $GMPY2DIR
# patch -uN --verbose --binary setup.py < ~/Scripts/python3-gmpy2-setup.py.patch >> $ROOTDIR/build-log.txt 2>&1
python setup.py build_ext --compiler="mingw32" --include-dirs="$INSTALLDIR/include"  --library-dirs="$INSTALLDIR/lib" >> $ROOTDIR/build-log.txt 2>&1
pip wheel . >> $ROOTDIR/build-log.txt 2>&1
mv *.whl ..
if [ -e $PYTHONSCRIPTSDIR/sphinx-build.exe ]
then
    cd $GMPY2DIR/docs
    make singlehtml >> $ROOTDIR/build-log.txt 2>&1
fi
echo "=======================================" >> $ROOTDIR/build-log.txt
# add information to buildinfo.txt
echo "Writing build info to ${ROOTDIR}/build-info.txt"
echo "name         : gmpy2-${GMPY2VER}"                                                           >> $ROOTDIR/build-info.txt
echo "type         : .tar.gz"                                                                     >> $ROOTDIR/build-info.txt
echo "version      : $GMPY2VER"                                                                   >> $ROOTDIR/build-info.txt
echo "url          : https://files.pythonhosted.org/packages/1d/6c/.../gmpy2-${GMPY2VER}.tar.gz"  >> $ROOTDIR/build-info.txt
echo "patches      : python3-gmpy2-setup.py.patch"                                                >> $ROOTDIR/build-info.txt
echo "configuration: gmpy2-build-v3.sh"                                                           >> $ROOTDIR/build-info.txt
echo                                                                                              >> $ROOTDIR/build-info.txt
echo "# **************************************************************************"               >> $ROOTDIR/build-info.txt
echo                                                                                              >> $ROOTDIR/build-info.txt

# download, extract sources, build and install bigfloat
# **this requires a patched ccygwincompiler.py, and (lib)python3x.{a,def}, (lib)vcruntime140.{a,def} in $PYTHONDIR/libs**
# dlltool --dllname vcruntime140.dll --input-def vcruntime140.def --output-lib libvcruntime140.a && mv *.a *.def libs
# dlltool --dllname python39.dll --input-def python39.def --output-lib libpython39.a && mv *.a *.def libs
echo "Starting bigfloat-${BIGFLOATVER} build..."
echo "Starting bigfloat-${BIGFLOATVER} build..." >> $ROOTDIR/build-log.txt
cd $ROOTDIR
[[ -e bigfloat-${BIGFLOATVER}.tar.gz ]] || wget https://files.pythonhosted.org/packages/e0/6c/34784aecbd34d8eaad938106a8b0e5af57dc7282baf613cb8414ef949c20/bigfloat-${BIGFLOATVER}.tar.gz >> $ROOTDIR/build-log.txt 2>&1
[[ -d ${BIGFLOATDIR} ]] || tar -xzf bigfloat-${BIGFLOATVER}.tar.gz >> $ROOTDIR/build-log.txt 2>&1
cd $BIGFLOATDIR
patch -uN --verbose --binary mpfr.c < ~/Scripts/python3-bigfloat-0.4.0-mpfr.c.patch >> $ROOTDIR/build-log.txt 2>&1
python setup.py build_ext --compiler="mingw32" --include-dirs="$INSTALLDIR/include"  --library-dirs="$INSTALLDIR/lib" >> $ROOTDIR/build-log.txt
pip wheel . >> $ROOTDIR/build-log.txt 2>&1
mv *.whl ..
echo "=======================================" >> $ROOTDIR/build-log.txt
# add information to buildinfo.txt
echo "Writing build info to ${ROOTDIR}/build-info.txt"
echo "name         : bigfloat-${BIGFLOATVER}"                                                           >> $ROOTDIR/build-info.txt
echo "type         : .tar.gz"                                                                           >> $ROOTDIR/build-info.txt
echo "version      : $BIGFLOATVER"                                                                      >> $ROOTDIR/build-info.txt
echo "url          : https://files.pythonhosted.org/packages/e0/6c/.../bigfloat-${BIGFLOATVER}.tar.gz"  >> $ROOTDIR/build-info.txt
echo "patches      : python3-bigfloat-0.4.0-mpfr.c.patch"                                               >> $ROOTDIR/build-info.txt
echo "configuration: gmpy2-build-v3.sh"                                                                 >> $ROOTDIR/build-info.txt
echo                                                                                                    >> $ROOTDIR/build-info.txt
echo "# **************************************************************************"                     >> $ROOTDIR/build-info.txt
echo                                                                                                    >> $ROOTDIR/build-info.txt

# ============= WRAPUP =============================================================

# now reset the path before we finish up
PATH=$OLDPATH

# and clean up
cd $ROOTDIR


