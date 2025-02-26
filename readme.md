### Building help
---
```bash 
xorriso -as mkisofs -b main_floppy.img -no-emul-boot -boot-load-size 4 -o boot.iso .
```
```bash
make ; cd build/ ; xorriso -as mkisofs -b main_floppy.img -no-emul-boot -boot-load-size 4 -o boot.iso . ; mv boot.iso .. ; cd .. ;
```
---
