REM  make_hex&lst.bat wmh 2019-06-27 : generate extra info from .elf file
echo off

REM using GNU arm-none-eabi-gcc acquired AC6 installation
REM adjust the following to where you put the compiler
set path=.\;C:\Ac6\SystemWorkbench\plugins\fr.ac6.mcu.externaltools.arm-none.win32_1.13.3.201707031232\tools\compiler\bin;

REM we will work in the \Debug folder 
cd Debug

set DEST=DiscoBlinky

echo Generating .hex and .lst files for %DEST%
arm-none-eabi-objcopy -O ihex %DEST%.elf ..\%DEST%.hex
arm-none-eabi-objdump -S %DEST%.elf >..\%DEST%.lst
copy output.map ..\%DEST%.map

echo If no errors then done
 pause
 
