include 'emu8086.inc'
.MODEL small, c
.STACK
.DATA
    
    
        a db '      A B C D E F $'       
        b db '      _ _ _ _ _ _           $'
        c db '   1 | |s| | | | |          $'
        d db '     |-|-|-|-|-|-|          $' 
        e db '   2 | | | | | | |          $'
        f db '     |-|-|-|-|-|-|          $'
        g db '   3 | | | | | | |          $'
        h db '     |-|-|-|-|-|-|          $' 
        i db '   4 | | | | | | |          $'
        j db '     |-|-|-|-|-|-|          $'
        k db '   5 | | | | | | |          $        ' 
        l db '      - - - - - -           $        '
  m1      db 'Misil 01, ingrese la celda a atacar:  '
  m2      db 'Misil 01, ingrese la celda a atacar:  '
  m3      db 'Misil 01, ingrese la celda a atacar:  '
  m4      db 'Misil 01, ingrese la celda a atacar:  '
  m5      db 'Misil 01, ingrese la celda a atacar:  '
  m6      db 'Misil 01, ingrese la celda a atacar:  '
  m7      db 'Misil 01, ingrese la celda a atacar:  '
  m8      db 'Misil 01, ingrese la celda a atacar:  '
  m9      db 'Misil 01, ingrese la celda a atacar:  '
  m10     db 'Misil 01, ingrese la celda a atacar:  '
  m11     db 'Misil 01, ingrese la celda a atacar:  '
  m12     db 'Misil 01, ingrese la celda a atacar:  '






.CODE
    .STARTUP 
    
        mov ah,0FH
        int 10h
        mov ah,0     ; esta expresion permite limpiar la pantalla de cualquier presentacion
        int 10h
        
        mov bh,0
        mov dh,2
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, a        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,3
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, b        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,4
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, c        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,5
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, d        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,6
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, e        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,7
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, f        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,8
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, g        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,9
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, h        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,10
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, i        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,11
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, j        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,12
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, k        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h 
        
        mov bh,0
        mov dh,13
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, l        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        mov bh,0
        mov dh,15
        mov dl,0
        mov ah,2
        int 10h
        
        mov ah, 09h
        lea dx, ingrese
        int 21h  
        
        GOTOXY 16,0
        printn ingrese
        
salir:
.exit

end