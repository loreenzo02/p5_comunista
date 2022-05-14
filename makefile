all: pract5a.com pract5op.exe

pract5a.com: pract5a.obj
    tlink /t pract5a.obj

pract5a.obj: pract5a.asm
    tasm  /zi pract5a.asm

pract5op.exe: pract5op.obj
    tlink /v pract5op.obj

pract5op.obj: pract5op.asm
    tasm  /zi pract5op.asm,,pract5op.lst