@echo off
ca65 src/backgrounds.s
ca65 src/reset.asm
ld65 src/reset.o src/backgrounds.o -C nes.cfg -o backgrounds.nes