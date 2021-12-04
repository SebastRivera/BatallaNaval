include 'emu8086.inc'
org 100h

.data

var1 db ?
.code        

mov ah,01h
int 21h 
mov var1,al
jmp algoritmo
        



algoritmo:
        mov al,var1
        cmp al,"F"
        je esM
        cmp al,"a"
        je hola 
        jmp salir
        
        
        
    esM:
    print 'Es m'
    jmp salir
    
    hola:
    print 'Hola'
    jmp salir
     
     
salir:
.exit    
end

        
       