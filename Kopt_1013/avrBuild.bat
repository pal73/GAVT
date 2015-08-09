cd "C:\Users\Pal\CVproects\MNSmini\"
C:
del "C:\Users\Pal\CVproects\MNSmini\jjj.map"
del "C:\Users\Pal\CVproects\MNSmini\jjj.lst"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler\avrasm32.exe" -fI  -o "C:\Users\Pal\CVproects\MNSmini\jjj.hex" -d "C:\Users\Pal\CVproects\MNSmini\jjj.obj" -e "C:\Users\Pal\CVproects\MNSmini\jjj.eep" -I "C:\Users\Pal\CVproects\MNSmini" -I "C:\Program Files\Atmel\AVR Tools\AvrAssembler\Appnotes" -w  -m "C:\Users\Pal\CVproects\MNSmini\jjj.map" "C:\Users\Pal\CVproects\MNSmini\mns48.asm"
