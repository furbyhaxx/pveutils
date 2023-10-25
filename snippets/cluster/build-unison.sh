#!/bin/bash

apt install gcc build-essential curl bubblewrap unzip ocaml -y

# Remove current references of oCaml
#  apt purge ocaml
#  rm -r /usr/bin/ocaml*

  # Remove current versions of unison binaries
  apt purge unison
  rm -r /usr/bin/unison
  rm -r /usr/bin/unison-*

  # Compile OCaml from source
#  mkdir -p /usr/src/ocaml
#  cd /usr/src/ocaml
#  wget https://github.com/ocaml/ocaml/archive/refs/tags/4.8.1.tar.gz
#  tar xzvf ocaml-4.08.1.tar.gz --strip-components 1
#  ./configure
#  make world.opt
#  make install
#  make clean

  # Compile Unison from source
  rm -rf /usr/src/unison/
  mkdir -p /usr/src/unison/
  cd /usr/src/unison/
  wget https://github.com/bcpierce00/unison/archive/refs/tags/v2.53.3.tar.gz -O unison.tar.gz
  tar xzvf unison.tar.gz  --strip-components 1
  make UISTYLE=text || true

  BUILDDIR=/usr/src/unison/src/


  chmod +x $BUILDDIR/unison $BUILDDIR/unison-fsmonitor
  ln -s $BUILDDIR/unison /usr/bin/
  ln -s $BUILDDIR/unison-fsmonitor /usr/bin/

  unison -version
