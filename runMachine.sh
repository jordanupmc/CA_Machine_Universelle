#! /bin/bash
if [ $# -ne 1 ]
then
  echo Usage <$0> filename
  exit 1
fi

ant run -Dfile=$1
