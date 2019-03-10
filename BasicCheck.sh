#!/bin/bash
folderName=${1}
executable=${2}
cd  ${folderName}
make
seccesfull=$?
if [[ seccesfull -gt 0 ]]; then
outcompile=1
else
outcompile=0
fi

valgrind --leak-check=full ./$executable $@
seccesfull=$?
if [[ seccesfull -gt 0 ]]; then
outvalgrind=1
else
outvalgrind=0
fi

valgrind --tool=helgrind ./$executable $@
seccesfull=$?
if [[ seccesfull -gt 0 ]]; then
outhalgrind=1
else
outhalgrind=0
fi

echo comile  memory leaks  thread race
echo "   $outcompile      $outvalgrind            $outhalgrind"

if [[ $outcompile -eq 0 && $outvalgrind -eq 0 && $outvalgrind -eq 0 ]]; then
exit 0
elif [[ $outcompile -eq 0 && $outvalgrind -eq 0 && $outvalgrind -eq 1 ]]; then
exit 1
elif [[ $outcompile -eq 0 && $outvalgrind -eq 1 && $outvalgrind -eq 1 ]]; then
exit 3
elif [[ $outcompile -eq 1 && $outvalgrind -eq 1 && $outvalgrind -eq 1 ]]; then
exit 7
fi
