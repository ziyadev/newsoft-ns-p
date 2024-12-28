@echo off
echo erasing...
del /S Thumbs.db *.dcu *.bak *.ddp *.dsk *.~* *.drc *.dsm %1 %2 %3 %4 %5 %6 %7 %8 %9 >NUL
cd units
del /S Thumbs.db *.dcu *.bak *.ddp *.dsk *.~* *.drc *.dsm %1 %2 %3 %4 %5 %6 %7 %8 %9 >NUL
cd ..
:LEAVE