#!/bin/sh

die () {
  echo "*** build.sh: $*" 1>&2
  exit 1
}

for component in boolector picosat precosat lingeling minisat
do
  archive=`ls archives/${component}-*.tar.gz`
  name=`basename $archive .tar.gz`
  tar xf $archive
  rm -rf $component
  mv $name $component
  echo "extracted $component"
done

echo "building minisat"
cd minisat
make r >/dev/null || die "'make r' failed in 'minisat'"
cd ..

for component in picosat precosat lingeling boolector
do
  echo "building $component"
  cd $component
  ./configure >/dev/null || die "'./configure' failed in '$component'"
  make >/dev/null || die "'make' failed in '$component'"
  cd ..
done
