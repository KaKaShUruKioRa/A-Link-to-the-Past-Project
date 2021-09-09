#!/bin/bash

if [ $# -eq 0 ]; then
  echo 'No files specified'
  exit 1
fi

gimp -i -b "$(cat normal-to-fr-colors.scm)" -b "(normal-to-fr-colors \"$@\")" -b "(gimp-quit 0)"
