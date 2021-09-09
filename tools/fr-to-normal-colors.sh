#!/bin/bash

if [ $# -eq 0 ]; then
  echo 'No files specified'
  exit 1
fi

gimp -i -b "$(cat fr-to-normal-colors.scm)" -b "(fr-to-normal-colors \"$@\")" -b "(gimp-quit 0)"
