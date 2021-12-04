include 'emu8086.inc'
.model large        ;modelo de memoria
.data               ;comienzo del segmento de datos
portax    db 6 dup(0) ;Valores de filas del portaviones
portay    db 6 dup(0) ;Valores de columnas del portaviones
crucex    db 6 dup(0) ;Valores de filas del crucero
crucey    db 6 dup(0) ;Valores de columnas del crucero
submax    db 6 dup(0) ;Valores de filas del submarino
submay    db 6 dup(0) ;Valores de columnas del submarino

vecp1     db 4 dup(0)
vecp2     db 4 dup(0)
vecp3     db 4 dup(0)
vecp4     db 4 dup(0)      ;Vectores de cada posicion de portaviones
vecp5     db 4 dup(0)

vecc1     db 4 dup(0)
vecc2     db 4 dup(0)
vecc3     db 4 dup(0)      ;Vectores de cada posicion de crucero
vecc4     db 4 dup(0)

vecs1     db 4 dup(0)
vecs2     db 4 dup(0)       ;Vectores de cada posicion de submarino
vecs3     db 4 dup(0)

f1        db 9 dup(0)
f2        db 9 dup(0)
f3        db 9 dup(0) ;Matriz general del tablero
f4        db 9 dup(0)
f5        db 9 dup(0)
f6        db 9 dup(0)


tip     db ?                ;tipo de posicionamiento
acum    db ?                ;---------------------
cor     db ?                ;y a pintar/borrar
lar     db ?                ;x a pintar/borrar
misiles db ?                ;misiles

barcos  db 3                ;barcos restantes en el tablero
celdasP db 5
celdasC db 4                ;Celdas restantes de cada barco
celdasS db 3

conteo db 20                ;Conteo de misiles
frase1 db 'Misil $'
frase2 db ' ............... $'
fraseE db 'Impacto Confirmado!!!!!$'
fraseI db 'Sin Impacto         !!!$'
fraseP db 'Portaviones derribado!!$'
fraseC db 'Crucero derribado!!!!!!$'       ;Mensajes notificacion
fraseS db 'Submarino derribado!!!!$'
fraseG db 'Haz ganado!!!!!!!!!!!!! $'
fraseD db 'No hay misiles.GAMEOVER $'
fraseV db 'Volver a jugar?????(s/n): $'
    

       ;variables de inicio (decoracion)
        c1 db 205
        c2 db 178
        c3 db 219                        ;Variables para decoracion con caracteres
        c4 db 220 
        c6 db 218 
        c7 db 191
   entrada db '  __   __  ___ ___     __  __           __    $'
  entrada2 db ' |  | |  |  |   |  |  |   |    |  |  | |  |  $'
  entrada3 db ' |--  |--|  |   |  |  |-- |__  |__|  | |--     $'
  entrada4 db ' |  | |  |  |   |  |  |      | |  |  | |     $'
  entrada5 db ' |__| |  |  |   |  |_ |__  __| |  |  | |     $' 
  bien     db 'Tienes 20 misiles para destruir la flota enemiga $'
  ini   db 'Presiona ENTER para visualizar el tablero y ubicar los barcos aleatoriamente: $'
  
  
        a db '      1 2 3 4 5 6 $'       
        b db '      _ _ _ _ _ _           $'
        c db '   A | | | | | | |          $'
        d db '     |-|-|-|-|-|-|          $' 
        e db '   B | | | | | | |          $'
        f db '     |-|-|-|-|-|-|          $'
        g db '   C | | | | | | |          $'
        h db '     |-|-|-|-|-|-|          $' 
        i db '   D | | | | | | |          $'
        j db '     |-|-|-|-|-|-|          $'
        k db '   E | | | | | | |          $' 
        l db '     |-|-|-|-|-|-|          $'
        m db '   F | | | | | | |          $'
        n db '      - - - - - -           $' 


  ceros   db '0$' ;Cero de la matriz
  unos    db '1$' ;Uno de la matris
  
  posx    db ?    ;
  posy    db ?    ;
  
  co      db ?    ;y de barco posible/existente
  fi      db ?    ;x de barco posible/existente
  mode    db 0    ;Modo llenado final o llenado de jugador
  numCP   db 0
  numCC   db 0    ;Celdas que faltan por mostrar
  numCS   db 0 
  volv    db ?    ;Volver o no
  
             
.code               ;comienzo del segmento de codigo
.start         
 
;Esta parte del codigo es unicamente decoracion del inicio :)
    
        limpiar_pantalla:
        mov ah,0FH
        int 10h
        mov ah,0     ; esta expresion permite limpiar la pantalla de cualquier presentacion
        int 10h
         
        
        
        inicio:
        mov bh,0
        mov dh,2
        mov dl,0     ; esta expresion permite cambiar la ubicacion el "cursor"
        mov ah,2
        int 10h
        
        
        mov ah,9h
        mov al,c1
        mov bh,0     ;imprime BORDE  con color AMARILLO
        mov bl,6
        mov cx,80
        int 10h 
        
        mov bh,0
        mov dh,10
        mov dl,0     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah,9h
        mov al,c1
        mov bh,0     ;imprime BORDE  con color AMARILLO
        mov bl,6
        mov cx,80
        int 10h
        
        mov bh,0        ;
        mov dh,9        ;  
        mov dl,0        ;
        mov ah,2        ;
        int 10h         ;
                        ;imprime el MAR
        mov ah,9h       ;
        mov al,c2       ;
        mov bh,0        ;
        mov bl,1        ;
        mov cx,80       ;
        int 10h         ;
        
        mov bh,0        
        mov dh,8        
        mov dl,5        ;Cambia posicion de puntero
        mov ah,2
        int 10h 
                        
        mov ah,9h       ;
        mov al,c3       ;
        mov bh,0        ;
        mov bl,5        ;
        mov cx,6        ; Imprime submarino 
        int 10h         ;
                        ;
        mov bh,0        ;
        mov dh,7        ; LADO IZQUIERDO
        mov dl,8        ;
        mov ah,2        ;
        int 10h         ;
                        ;
        mov ah,9h       ;
        mov al,c4       ;
        mov bh,0        ;
        mov bl,5        ;
        mov cx,1        ;
        int 10h         ;
        
        
        mov bh,0
        mov dh,6        ;Cambia posicion de puntero
        mov dl,8
        mov ah,2
        int 10h 
                        
        mov ah,9h       ;
        mov al,c6       ;
        mov bh,0        ;
        mov bl,5        ;
        mov cx,1        ;
        int 10h         ;  Imprime vista de submarino derecho      
                        ;
        mov bh,0        ;
        mov dh,8        ;
        mov dl,65       ;
        mov ah,2        ;
        int 10h         ;
                           
        mov ah,9h       ;
        mov al,c3       ;
        mov bh,0        ;
        mov bl,5        ;
        mov cx,6        ;
        int 10h         ;
                        ;
        mov bh,0        ;  Imprime un pequeno submarino
        mov dh,7        ;
        mov dl,68       ;
        mov ah,2        ;
        int 10h         ;
                        ;   LADO DERECHO
        mov ah,9h       ;
        mov al,c4       ;
        mov bh,0        ;
        mov bl,5        ;
        mov cx,1        ;
        int 10h         ;
        
        
        mov bh,0        ;
        mov dh,6        ;
        mov dl,68       ;
        mov ah,2        ;
        int 10h         ;
                        ;imprime vista de submarino(vista derecho)
        mov ah,9h       ;
        mov al,c7       ;
        mov bh,0        ;
        mov bl,5        ;
        mov cx,1        ;
        int 10h         ;   
        
        
        
;-----------------------------------------------------------------------------------------

;Esta parte del codigo solo muestra el titulo de "battleship"        
        mov bh,0
        mov dh,3
        mov dl,18     ;ubica el "cursor"
        mov ah,2
        int 10h
        
        mov ah, 09h         ;funcion para mostrar cadena de caracteres        
        lea dx, entrada        ;load efective address---> coloca contenido de variable entrada en dx 
        int 21h             ;interrupcion para mostrar contenido de dx en pantalla
        
        mov bh,0
        mov dh,4
        mov dl,18     ;ubica el "cursor"
        mov ah,2
        int 10h
        
        mov ah, 09h
        lea dx, entrada2        ;load efective address---> coloca contenido de variable entrada2 en dx 
        int 21h
        
        mov bh,0
        mov dh,5
        mov dl,18     ;ubica el "cursor"
        mov ah,2
        int 10h
        
        mov ah, 09h   
        lea dx, entrada3        ;load efective address---> coloca contenido de variable entrada3 en dx 
        int 21h
        
        mov bh,0
        mov dh,6
        mov dl,18     ;ubica el "cursor"
        mov ah,2
        int 10h
                 
        mov ah, 09h   
        lea dx, entrada4        ;load efective address---> coloca contenido de variable entrada4 en dx 
        int 21h           
       
        mov bh,0
        mov dh,7
        mov dl,18     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, entrada5        ;load efective address---> coloca contenido de variable entrada5 en dx 
        int 21h
        
        
        enter:
        mov bh,0
        mov dh,15
        mov dl,14     ;ubica el "cursor"
        mov ah,2
        int 10h  
        
        mov ah, 09h
        lea dx, bien    ;Presenta la informacion de misiles
        int 21h  
        
        mov bh,0
        mov dh,17
        mov dl,1     ;ubica el "cursor"
        mov ah,2
        int 10h  
        
        mov ah, 09h
        lea dx, ini     ;ENTER para continuar
        int 21h 
        
        mov bh,0
        mov dh,0
        mov dl,0     ;ubica el "cursor"
        mov ah,2
        int 10h  
         
 
        tecla:
        mov ah,01h
        int 21h
        cmp al,0Dh
        jz limpia
        jnz limpiar_pantalla:   
        
        limpia:
        mov ah,0FH
        int 10h
        mov ah,0     ; esta expresion permite limpiar la pantalla de cualquier presentacion
        int 10h
        jmp largo
 
 
;---------------------------------------UBICACION PORTAVIONES---------------------------------- 
 
  
largo:         ;Permite obtener un numero random entre cierto rango
mov si,0 

MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,10      ;con 20- de 0 a 4, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl 
mov ax, 0000h
mov al,bl    
mov lar,al    ;Asignacion de numero largo rango
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,6      ;Se verifica que el numero sea menor que 6 sino se vuelve a buscar
jl corto
jmp largo


   
corto: 
mov si,0 

MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,15      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl    
mov cor,al    ;Asignacion eje numero corto rango
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,2      ;Se verifica que el numero sea menor que 2 sino se vuelve a buscar
jl tipo
jmp corto
                        
tipo:     
mov si,0
MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,15      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl    
mov tip,al    ;Asignacion de tipo (0-1, horizontal-vertical)
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,2       ;Se confirma que sea menor que 2 sino se vuelve a buscar
jl  asignacion
jmp tipo


asignacion:      ;Se verifica el modo en ubicar el barco: 0->horizontal,1->vertical
mov ax,0000h
mov al,tip
cmp al,0
jz horizontal
jnz vertical

horizontal:      ;Se guarda en las filas que va a pertenecer el portaaviones
mov ax,0000h
mov al,lar
mov bx,0000h
mov bl,cor 
mov portax[0],al
mov portax[1],al
mov portax[2],al
mov portax[3],al
mov portax[4],al
mov portay[0],bl
inc bl  
mov portay[1],bl
inc bl
mov portay[2],bl
inc bl
mov portay[3],bl
inc bl
mov portay[4],bl  
jmp generalx


vertical:               ;Guarda las columnas del portaaviones
mov ax,0000h
mov al,cor
mov bx,0000h
mov bl,lar 
mov portay[0],bl
mov portay[1],bl
mov portay[2],bl
mov portay[3],bl
mov portay[4],bl 
mov portax[0],al
inc al 
mov portax[1],al
inc al
mov portax[2],al
inc al
mov portax[3],al
inc al
mov portax[4],al  
jmp generaly

generalx:                ;Se ubica la fila a llenar
mov ax,0000h
mov al,lar
cmp al,0  
jz llenar1
cmp al,1 
jz llenar2
cmp al,2
jz llenar3
cmp al,3
jz llenar4
cmp al,4
jz llenar5
cmp al,5
jz llenar6  

generaly:                  ;Se ubica la columna a llenar
mov ax,0000h
mov al,cor
cmp al,0
jz llenar7
cmp al,1
jz llenar8

llenar1:
mov ax,0000h                   ;Los siguientes procesos se encargan de llenar la matriz general en los puntos random y en el modo seleccionado.
mov al,cor   
mov si,ax
mov f1[si],1      
mov f1[si+1],1
mov f1[si+2],1
mov f1[si+3],1 
mov f1[si+4],1 
jmp largo2  

llenar2:
mov ax,0000h
mov al,cor
mov si,ax
mov f2[si],1      
mov f2[si+1],1
mov f2[si+2],1
mov f2[si+3],1
mov f2[si+4],1
jmp largo2

llenar3:
mov ax,0000h
mov al,cor
mov si,ax
mov f3[si],1      
mov f3[si+1],1
mov f3[si+2],1
mov f3[si+3],1
mov f3[si+4],1
jmp largo2

llenar4:
mov ax,0000h
mov al,cor
mov si,ax
mov f4[si],1      
mov f4[si+1],1
mov f4[si+2],1
mov f4[si+3],1
mov f4[si+4],1
jmp largo2

llenar5:
mov ax,0000h
mov al,cor
mov si,ax
mov f5[si],1      
mov f5[si+1],1
mov f5[si+2],1
mov f5[si+3],1
mov f5[si+4],1
jmp largo2

llenar6:
mov ax,0000h
mov al,cor
mov si,ax
mov f6[si],1      
mov f6[si+1],1
mov f6[si+2],1
mov f6[si+3],1
mov f6[si+4],1
jmp largo2

llenar7:
mov ax,0000h
mov al,lar
mov si,ax
mov f1[si],1
mov f2[si],1
mov f3[si],1
mov f4[si],1
mov f5[si],1
jmp largo2

llenar8:
mov ax,0000h
mov al,lar
mov si,ax
mov f2[si],1
mov f3[si],1
mov f4[si],1
mov f5[si],1
mov f6[si],1
jmp largo2
          

;----------------------------------------SEGUNDO BARCO-------------------------------------------------------

;Se repite el mismo proceso pero tambien se verifica que si hay valores para no hacer choque          
largo2:
mov si,0 

MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,10      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl 
mov ax, 0000h
mov al,bl    
mov lar,al    
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,6
jl corto2
jmp largo2


   
corto2: 
mov si,0 

MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,20      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl    
mov cor,al    
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,3
jl tipo2
jmp corto2
                        
tipo2:     
mov si,0
MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,15      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl    
mov tip,al    
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,2
jl  asignacion2
jmp tipo2          
          
          
asignacion2:       
mov ax,0000h
mov al,tip
cmp al,0
jz generalVerx
jnz generalVery


generalVerx:         ;Proceso parecido al de llenar, pero este verifica que si esta llena cierta celda
mov ax,0000h
mov al,lar
cmp al,0  
jz veri1
cmp al,1 
jz veri2
cmp al,2
jz veri3
cmp al,3
jz veri4
cmp al,4
jz veri5
cmp al,5
jz veri6  

generalVery:          ;TODOS ESTOS PROCESOS SON DE VERIFICACION DE QUE SI HAY OTRO BARCO O UN "1" EN UNA CELDA QUE SE BUSCA INSERTAR
mov ax,0000h
mov al,cor
cmp al,0
jz veri7
cmp al,1
jz veri8 
cmp al,2
jz veri9

veri1:
mov ax,0000h
mov al,cor  
mov si,ax
cmp f1[si],1
jz largo2     
cmp f1[si+1],1
jz largo2 
cmp f1[si+2],1
jz largo2
cmp f1[si+3],1 
jz largo2 
jmp horizontal2  

veri2:
mov ax,0000h
mov al,cor  
mov si,ax
cmp f2[si],1
jz largo2     
cmp f2[si+1],1             ;SI SE CHOCA EN ALGUN LAGO, SE VUELVE A GENERAR EL BARCO
jz largo2 
cmp f2[si+2],1
jz largo2
cmp f2[si+3],1 
jz largo2 
jmp horizontal2  

veri3:
mov ax,0000h
mov al,cor  
mov si,ax
cmp f3[si],1
jz largo2     
cmp f3[si+1],1
jz largo2 
cmp f3[si+2],1
jz largo2
cmp f3[si+3],1 
jz largo2 
jmp horizontal2  

veri4:
mov ax,0000h
mov al,cor  
mov si,ax
cmp f4[si],1
jz largo2     
cmp f4[si+1],1
jz largo2 
cmp f4[si+2],1
jz largo2
cmp f4[si+3],1 
jz largo2 
jmp horizontal2  

veri5:
mov ax,0000h
mov al,cor  
mov si,ax
cmp f5[si],1
jz largo2     
cmp f5[si+1],1
jz largo2 
cmp f5[si+2],1
jz largo2
cmp f5[si+3],1 
jz largo2 
jmp horizontal2  

veri6:
mov ax,0000h
mov al,cor  
mov si,ax
cmp f6[si],1
jz largo2     
cmp f6[si+1],1
jz largo2 
cmp f6[si+2],1
jz largo2
cmp f6[si+3],1 
jz largo2 
jmp horizontal2   

veri7:
mov ax,0000h
mov al,lar
mov si,ax
cmp f1[si],1 
jz largo2    
cmp f2[si],1
jz largo2 
cmp f3[si],1
jz largo2  
cmp f4[si],1
jz largo2   
jmp vertical2 

veri8:
mov ax,0000h
mov al,lar
mov si,ax
cmp f2[si],1 
jz largo2    
cmp f3[si],1
jz largo2 
cmp f4[si],1
jz largo2  
cmp f5[si],1
jz largo2   
jmp vertical2

veri9:
mov ax,0000h
mov al,lar
mov si,ax
cmp f3[si],1 
jz largo2    
cmp f4[si],1
jz largo2 
cmp f5[si],1
jz largo2  
cmp f6[si],1
jz largo2   
jmp vertical2

horizontal2:
mov ax,0000h
mov al,lar
mov bx,0000h
mov bl,cor 
mov crucex[0],al
mov crucex[1],al
mov crucex[2],al
mov crucex[3],al           ;COLOCACION DE VECTORES X, Y EN ARREGLOS QUE GUARDAN LAS UBICACIONES DE LOS "1"
mov crucey[0],bl
inc bl  
mov crucey[1],bl
inc bl
mov crucey[2],bl
inc bl
mov crucey[3],bl  
jmp general2x


vertical2:
mov ax,0000h
mov al,cor
mov bx,0000h
mov bl,lar                 ;COLOCACION DE VECTORES X, Y EN ARREGLOS QUE GUARDAN LAS UBICACIONES DE LOS "1"
mov crucey[0],bl
mov crucey[1],bl
mov crucey[2],bl
mov crucey[3],bl 
mov crucex[0],al
inc al 
mov crucex[1],al
inc al
mov crucex[2],al
inc al
mov crucex[3],al  
jmp general2y

general2x:
mov ax,0000h
mov al,lar
cmp al,0  
jz llenar12
cmp al,1 
jz llenar22
cmp al,2
jz llenar32
cmp al,3
jz llenar42
cmp al,4
jz llenar52
cmp al,5                        ;LLENADO DE MATRIZ CON UN BARCO 
jz llenar62  

general2y:
mov ax,0000h
mov al,cor
cmp al,0
jz llenar72
cmp al,1
jz llenar82
cmp al,2
jz llenar92

llenar12:
mov ax,0000h
mov al,cor   
mov si,ax
mov f1[si],1      
mov f1[si+1],1
mov f1[si+2],1
mov f1[si+3],1  
jmp largo3  

llenar22:
mov ax,0000h
mov al,cor
mov si,ax
mov f2[si],1      
mov f2[si+1],1
mov f2[si+2],1
mov f2[si+3],1
jmp largo3

llenar32:
mov ax,0000h
mov al,cor
mov si,ax
mov f3[si],1      
mov f3[si+1],1
mov f3[si+2],1
mov f3[si+3],1
jmp largo3

llenar42:
mov ax,0000h
mov al,cor
mov si,ax
mov f4[si],1      
mov f4[si+1],1
mov f4[si+2],1
mov f4[si+3],1
jmp largo3

llenar52:
mov ax,0000h
mov al,cor
mov si,ax
mov f5[si],1      
mov f5[si+1],1
mov f5[si+2],1
mov f5[si+3],1
jmp largo3

llenar62:
mov ax,0000h
mov al,cor
mov si,ax
mov f6[si],1      
mov f6[si+1],1
mov f6[si+2],1
mov f6[si+3],1
jmp largo3

llenar72:
mov ax,0000h
mov al,lar
mov si,ax
mov f1[si],1
mov f2[si],1
mov f3[si],1
mov f4[si],1
jmp largo3

llenar82:
mov ax,0000h
mov al,lar
mov si,ax
mov f2[si],1
mov f3[si],1
mov f4[si],1
mov f5[si],1
jmp largo3    

llenar92:
mov ax,0000h
mov al,lar
mov si,ax
mov f3[si],1
mov f4[si],1
mov f5[si],1
mov f6[si],1
jmp largo3

                    
;--------------------------------TERCER BARCO---------------------------


largo3:
mov si,0 
MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,10      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl 
mov ax, 0000h
mov al,bl    
mov lar,al    
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,6
jl corto3
jmp largo3


   
corto3: 
mov si,0 

MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,15      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl    
mov cor,al    ;Asignacion eje y
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,4
jl tipo3
jmp corto3
                        
tipo3:     
mov si,0
MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,15      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl    
mov tip,al    ;Asignacion eje y
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,2
jl  asignacion3
jmp tipo3          
          
          
asignacion3:      ;Segun el primer numero random se va a colocar el rango alto en X o en Y 
mov ax,0000h
mov al,tip
cmp al,0
jz generalVerx2
jnz generalVery2

generalVerx2:         ;EL PROCESO DE LLENADO ES EL MISMO QUE EL BARCO ANTERIOR
mov ax,0000h          ;PERO EN ESTE CASO SE LE QUITA UNA CELDA (SUBMARINO)
mov al,lar
cmp al,0  
jz veri12
cmp al,1 
jz veri22
cmp al,2
jz veri32
cmp al,3
jz veri42
cmp al,4
jz veri52
cmp al,5
jz veri62  

generalVery2:
mov ax,0000h
mov al,cor
cmp al,0
jz veri72
cmp al,1
jz veri82 
cmp al,2
jz veri92
cmp al,3
jz veri102

veri12:
mov ax,0000h
mov al,cor   
mov si,ax
cmp f1[si],1
jz largo3     
cmp f1[si+1],1
jz largo3 
cmp f1[si+2],1
jz largo3 
jmp horizontal22  

veri22:
mov ax,0000h
mov al,cor   
mov si,ax
cmp f2[si],1
jz largo3     
cmp f2[si+1],1
jz largo3 
cmp f2[si+2],1
jz largo3 
jmp horizontal22   

veri32:
mov ax,0000h
mov al,cor   
mov si,ax
cmp f3[si],1
jz largo3     
cmp f3[si+1],1
jz largo3 
cmp f3[si+2],1
jz largo3 
jmp horizontal22  

veri42:
mov ax,0000h
mov al,cor   
mov si,ax
cmp f4[si],1
jz largo3     
cmp f4[si+1],1
jz largo3 
cmp f4[si+2],1
jz largo3 
jmp horizontal22  

veri52:
mov ax,0000h
mov al,cor   
mov si,ax
cmp f5[si],1
jz largo3     
cmp f5[si+1],1
jz largo3 
cmp f5[si+2],1
jz largo3 
jmp horizontal22  

veri62:
mov ax,0000h
mov al,cor   
mov si,ax
cmp f6[si],1
jz largo3     
cmp f6[si+1],1
jz largo3 
cmp f6[si+2],1
jz largo3 
jmp horizontal22  

veri72:
mov ax,0000h
mov al,lar
mov si,ax
cmp f1[si],1 
jz largo3    
cmp f2[si],1
jz largo3   
cmp f3[si],1
jz largo3  
jmp vertical22 

veri82:
mov ax,0000h
mov al,lar
mov si,ax
cmp f2[si],1 
jz largo3    
cmp f3[si],1
jz largo3   
cmp f4[si],1
jz largo3  
jmp vertical22

veri92:
mov ax,0000h
mov al,lar
mov si,ax
cmp f3[si],1 
jz largo3    
cmp f4[si],1
jz largo3   
cmp f5[si],1
jz largo3  
jmp vertical22

veri102:
mov ax,0000h
mov al,lar
mov si,ax
cmp f4[si],1 
jz largo3    
cmp f5[si],1
jz largo3   
cmp f6[si],1
jz largo3  
jmp vertical22

horizontal22:
mov ax,0000h
mov al,lar
mov bx,0000h
mov bl,cor 
mov submax[0],al
mov submax[1],al
mov submax[2],al
mov submay[0],bl
inc bl  
mov submay[1],bl
inc bl
mov submay[2],bl  
jmp general2x2


vertical22:
mov ax,0000h
mov al,cor
mov bx,0000h
mov bl,lar 
mov submay[0],bl
mov submay[1],bl
mov submay[2],bl 
mov submax[0],al
inc al 
mov submax[1],al
inc al
mov submax[2],al  
jmp general2y2

general2x2:
mov ax,0000h
mov al,lar
cmp al,0  
jz llenar122
cmp al,1 
jz llenar222
cmp al,2
jz llenar322
cmp al,3
jz llenar422
cmp al,4
jz llenar522
cmp al,5
jz llenar622  

general2y2:
mov ax,0000h
mov al,cor
cmp al,0
jz llenar722
cmp al,1   
jz llenar822
cmp al,2
jz llenar922
cmp al,3
jz llenar1022

llenar122:
mov ax,0000h
mov al,cor   
mov si,ax
mov f1[si],1      
mov f1[si+1],1
mov f1[si+2],1  
jmp carga  

llenar222:
mov ax,0000h
mov al,cor
mov si,ax
mov f2[si],1      
mov f2[si+1],1
mov f2[si+2],1
jmp carga

llenar322:
mov ax,0000h
mov al,cor
mov si,ax
mov f3[si],1      
mov f3[si+1],1
mov f3[si+2],1
jmp carga

llenar422:
mov ax,0000h
mov al,cor
mov si,ax
mov f4[si],1      
mov f4[si+1],1
mov f4[si+2],1
jmp carga

llenar522:
mov ax,0000h
mov al,cor
mov si,ax
mov f5[si],1      
mov f5[si+1],1
mov f5[si+2],1
jmp carga

llenar622:
mov ax,0000h
mov al,cor
mov si,ax
mov f6[si],1      
mov f6[si+1],1
mov f6[si+2],1
jmp carga

llenar722:
mov ax,0000h
mov al,lar
mov si,ax
mov f1[si],1
mov f2[si],1
mov f3[si],1
jmp carga

llenar822:
mov ax,0000h
mov al,lar
mov si,ax
mov f2[si],1
mov f3[si],1
mov f4[si],1
jmp carga    

llenar922:
mov ax,0000h
mov al,lar
mov si,ax
mov f3[si],1
mov f4[si],1
mov f5[si],1
jmp carga          
          
llenar1022:
mov ax,0000h
mov al,lar
mov si,ax
mov f4[si],1
mov f5[si],1
mov f6[si],1
jmp carga          
          


;____________________________________________CARGA DE MATRIZ VISIBLE____________________________                    
carga:
printn 'L O A D I N G . . . . . .'
jmp matriz          
          
        matriz:  
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
        lea dx, a        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,3
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, b        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,4
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, c        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,5
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, d        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,6
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, e        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,7
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, f        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,8
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, g        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,9
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, h        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,10
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, i        ;load efective address---> coloca contenido de variable en dx 
        int 21h
        
        mov bh,0
        mov dh,11
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, j        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,12
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, k        ;load efective address---> coloca contenido de variable  en dx 
        int 21h 
        
        mov bh,0
        mov dh,13
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, l        ;load efective address---> coloca contenido de variable  en dx 
        int 21h
        
        mov bh,0
        mov dh,14
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, m        ;load efective address 
        int 21h  
        
        mov bh,0
        mov dh,15
        mov dl,28     ;ubica el "cursor"
        mov ah,2
        int 10h 
        
        mov ah, 09h   
        lea dx, n         
        int 21h 
          
        
;-------------------------------------------------LLENADO DE CEROS---------------------------------       
        mov bh,0              
        mov dh,4
        mov dl,34
        mov ah,2               ;(0,0)
        int 10h
        
        mov ah, 09h
        lea dx, ceros
        int 21h 
       
        
        mov bh,0
        mov dh,6
        mov dl,34
        mov ah,2               ;(1,0)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h 
        
        
        mov bh,0
        mov dh,8
        mov dl,34               ;(2,0)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h 
       
        mov bh,0
        mov dh,10
        mov dl,34                ;(3,0)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
        mov bh,0
        mov dh,12
        mov dl,34
        mov ah,2                 ;(4,0)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
        mov bh,0
        mov dh,14
        mov dl,34                 ;(5,0)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
        mov bh,0
        mov dh,4
        mov dl,36                 ;(0,1)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
        mov bh,0
        mov dh,6
        mov dl,36                ;(1,1)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
      
        
 
        mov bh,0
        mov dh,8
        mov dl,36                  ;(2,1)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
          
        
        
        mov bh,0
        mov dh,10                   ;(3,1)
        mov dl,36
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
        
        mov bh,0
        mov dh,12                    ;(4,1)
        mov dl,36
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
          
        
        
        mov bh,0
        mov dh,14                   ;(5,1)
        mov dl,36
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
          
        
       
        mov bh,0
        mov dh,4                    ;(0,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h 
        
        
        
        mov bh,0
        mov dh,6                    ;(1,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
        
     
        mov bh,0
        mov dh,8                    ;(2,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
         
        
       
        mov bh,0
        mov dh,10
        mov dl,38                   ;(3,2)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
         
      
        mov bh,0
        mov dh,12                   ;(4,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
      
        mov bh,0
        mov dh,14                    ;(5,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
         
      
        mov bh,0
        mov dh,4
        mov dl,40                    ;(0,3)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
      
        mov bh,0
        mov dh,6                     ;(1,3)
        mov dl,40
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
      
        
        mov bh,0
        mov dh,8
        mov dl,40
        mov ah,2                     ;(2,3)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
        
        mov bh,0
        mov dh,10
        mov dl,40                    ;(3,3)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
      
     
        mov bh,0
        mov dh,12
        mov dl,40
        mov ah,2                     ;(4,3)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
        
       
        mov bh,0
        mov dh,14
        mov dl,40                     ;(5,3)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
         
        
      
        mov bh,0
        mov dh,4
        mov dl,42                      ;(0,4)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
         
       
        mov bh,0
        mov dh,6                      ;(1,4)
        mov dl,42
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
        
        
        mov bh,0
        mov dh,8
        mov dl,42                      ;(2,4)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
          
        
      
        mov bh,0
        mov dh,10
        mov dl,42                      ;(3,4)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
          
       
        mov bh,0
        mov dh,12
        mov dl,42
        mov ah,2                       ;(4,4)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
        mov bh,0
        mov dh,14
        mov dl,42
        mov ah,2                      ;(5,4)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
         
       
        mov bh,0
        mov dh,4
        mov dl,44
        mov ah,2                      ;(0,5)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
       
        
        mov bh,0
        mov dh,6
        mov dl,44                      ;(1,5)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
        
        
        
        mov bh,0
        mov dh,8
        mov dl,44                      ;(2,5)
        mov ah,2
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h
          
      
        mov bh,0
        mov dh,10
        mov dl,44
        mov ah,2
        int 10h 
        lea dx,ceros                   ;(3,5)
        mov ah, 09h
        int 21h
         
     
        mov bh,0
        mov dh,12
        mov dl,44
        mov ah,2                      ;(4,5)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h 
       
        
        
        mov bh,0
        mov dh,14
        mov dl,44
        mov ah,2                       ;(5,5)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h 
        jmp guardar
        
        
guardar:  ;guarda los vectores de los barcos en cada arreglo perteneciente a aquel
mov ax,0000h
mov bx,0000h
mov si,0
mov al,portax[si]
mov vecp1[si],al
mov al,portax[si+1]
mov vecp2[si],al 
mov al,portax[si+2]
mov vecp3[si],al
mov al,portax[si+3]
mov vecp4[si],al
mov al,portax[si+4]
mov vecp5[si],al
mov si,0
mov al,portay[si]
mov vecp1[si+1],al
mov al,portay[si+1]
mov vecp2[si+1],al
mov al,portay[si+2]
mov vecp3[si+1],al    
mov al,portay[si+3]
mov vecp4[si+1],al
mov al,portay[si+4]
mov vecp5[si+1],al

mov si,0
mov al,crucex[si]
mov vecc1[si],al
mov al,crucex[si+1]
mov vecc2[si],al 
mov al,crucex[si+2]
mov vecc3[si],al
mov al,crucex[si+3]
mov vecc4[si],al
mov si,0
mov al,crucey[si]
mov vecc1[si+1],al
mov al,crucey[si+1]
mov vecc2[si+1],al
mov al,crucey[si+2]
mov vecc3[si+1],al    
mov al,crucey[si+3]
mov vecc4[si+1],al

mov si,0
mov al,submax[si]
mov vecs1[si],al
mov al,submax[si+1]
mov vecs2[si],al 
mov al,submax[si+2]
mov vecs3[si],al
mov si,0
mov al,submay[si]
mov vecs1[si+1],al
mov al,submay[si+1]
mov vecs2[si+1],al
mov al,submay[si+2]
mov vecs3[si+1],al    
jmp textoMisil

textoMisil:
mov bh,0
mov dh,22
mov dl,0
mov ah,2                       ;PROCESO QUE MUESTRA MISILES DISPONIBLES HASTA QUE NO QUEDEN
int 10h    
mov dx,0000h
mov cx,0000h
mov ah, 09h
lea dx, frase1
int 21h
mov ax, 0000h
mov al,conteo
mov bl, conteo
dec bl
mov conteo,bl
mov bx,0000h
jmp convert


convert:             ;etiqueta que convierte los valores uno por uno en ASCII para poder mostrarlos(ya se ha utilizado en clases anteriormente)
mov bl, 10
div bl
mov dh, ah
mov dl, al            ;Codigo ya utilizado anteriormente en otras actividades
mov ah, 00h
mov al, dh
push ax
mov ax, 0000h
mov al, dl
add cx, 1
cmp dl, 0
jnz convert
jz mostrar


     
mostrar:           ;etiqueta que muestra los valores
sub cx, 1    ;decrementa cx en 1
pop ax       ;retira el ultimo valor ingresado en la pila y lo guarda en ax
mov ah, 02h  ;se coloca 02h en ah (funcion)
mov dl, al   ;se guarda el contenido de al en dl
add dl, 30h  ;se suma 30h a dl para obtener el caracter ascii correcto
int 21h      ;se llama a interrupcion 21h para mostrar el caracter por pantalla
cmp cx, 0000h    ;verifica si el contador llego a 0
je  textoPuntos
jne mostrar  ;si lo anterior no se cumple, salta a la etiqueta mostrar


textoPuntos: 
mov ah,09h
lea dx,frase2
int 21h
mov al,conteo               ;MUESTRA: ...........
cmp al,0
jl perder
jnz pedir1

pedir1: 
mov bh,0
mov dh,22
mov dl,35
mov ah,2                       ;PIDE PRIMER VALOR (LETRA)
int 10h  
mov ah,01h
int 21h
mov posx,al
jmp pedir2

pedir2:
mov bh,0
mov dh,22
mov dl,36                      ;PIDE SEGUNDO VALOR (NUMERO)
mov ah,2   
mov ah,01h
int 21h
mov posy,al
jmp colum


colum:
mov bl,posy
cmp bl,'1'
je colocar0 
cmp bl,'2'
je colocar1
cmp bl,'3'
je colocar2                            ;SE VERIFICA SI ES DE LA MATRIZ; SINO PIERDES MISIL
cmp bl,'4'                             ;Y TE PIDE OTRA VEZ INGRESAR
je colocar3
cmp bl,'5'
je colocar4
cmp bl,'6'
je colocar5
jmp textoMisil          ;<------------SI SE CAMBIA ESTA VARIABLE Y LA DE MAS ABAJO NO PIERDES MISIL

colocar0:
mov bl,0
mov co,bl
jmp confirmar  

colocar1:
mov bl,1
mov co,bl
jmp confirmar

colocar2:
mov bl,2
mov co,bl
jmp confirmar

colocar3:
mov bl,3
mov co,bl
jmp confirmar

colocar4:
mov bl,4
mov co,bl
jmp confirmar

colocar5:
mov bl,5
mov co,bl
jmp confirmar

confirmar: 
mov al,posx
cmp al,"a"
je confila1
cmp al,"A"
je confila1 

cmp al,"b"
je confila2
cmp al,"B"
je confila2

cmp al,"c"
je confila3
cmp al,"C"
je confila3

cmp al,"d"
je confila4
cmp al,"D"
je confila4

cmp al,"e"
je confila5
cmp al,"E"
je confila5

cmp al,"f"
je confila6 
cmp al,"F"
je confila6

jmp textoMisil    ;<------------------ SI SE CAMBIA ESTA VARIABLE Y OTRA DE ARRIBA NO PIERDES MISIL


confila1:
mov ax,0000h  
mov al,0 
mov fi,al
mov al,co
mov si,ax
cmp f1[si],1 
jz  borrar1
jnz aviso2                            ;SE CONFIRMA SI HUBO IMPACTO

borrar1:
mov al,co
mov si,ax
mov f1[si],0
jmp aviso 

confila2:
mov ax,0000h  
mov al,1 
mov fi,al
mov al,co
mov si,ax
cmp f2[si],1 
jz  borrar2
jnz aviso2

borrar2:
mov al,co
mov si,ax
mov f2[si],0
jmp aviso 

confila3:
mov ax,0000h  
mov al,2 
mov fi,al
mov al,co
mov si,ax
cmp f3[si],1 
jz  borrar3
jnz aviso2

borrar3:
mov al,co
mov si,ax
mov f3[si],0
jmp aviso 

confila4:
mov ax,0000h  
mov al,3 
mov fi,al
mov al,co
mov si,ax
cmp f4[si],1 
jz  borrar4
jnz aviso2

borrar4:
mov al,co
mov si,ax
mov f4[si],0
jmp aviso 

confila5:
mov ax,0000h  
mov al,4 
mov fi,al
mov al,co
mov si,ax
cmp f5[si],1 
jz  borrar5
jnz aviso2

borrar5:
mov al,co
mov si,ax
mov f5[si],0
jmp aviso 

confila6:
mov ax,0000h  
mov al,5 
mov fi,al
mov al,co
mov si,ax
cmp f6[si],1 
jz  borrar6
jnz aviso2

borrar6:
mov al,co
mov si,ax
mov f6[si],0
jmp aviso 

aviso:
mov bh,0
mov dh,23
mov dl,0
mov ah,2                       ;Avisa el impacto EXITOSO
int 10h 
mov ah,09h
lea dx,fraseE
int 21h
jmp pintar 

aviso2:
mov bh,0
mov dh,23
mov dl,0
mov ah,2                       ;Avisa el impacto FALLIDO
int 10h 
mov ah,09h
lea dx,fraseI
int 21h
jmp textoMisil 

 


;------------------------------------------SE PINTA LA CELDA CON UN 1---------------------------;
pintar:
mov al,co
cmp al,0
jz co0
cmp al,1
jz co1
cmp al,2
jz co2
cmp al,3
jz co3
cmp al,4
jz co4
cmp al,5
jz co5

co0:
mov al,fi
cmp al,0
jz fi00
cmp al,1
jz fi10
cmp al,2
jz fi20
cmp al,3
jz fi30
cmp al,4
jz fi40
cmp al,5
jz fi50
 
 
co1:
mov al,fi
cmp al,0
jz fi01
cmp al,1
jz fi11
cmp al,2
jz fi21
cmp al,3
jz fi31
cmp al,4
jz fi41
cmp al,5
jz fi51 
 
co2:
mov al,fi
cmp al,0
jz fi02
cmp al,1
jz fi12
cmp al,2
jz fi22
cmp al,3
jz fi32
cmp al,4
jz fi42
cmp al,5
jz fi52 
 
co3:
mov al,fi
cmp al,0
jz fi03
cmp al,1
jz fi13
cmp al,2
jz fi23
cmp al,3
jz fi33
cmp al,4
jz fi43
cmp al,5
jz fi53 
 
co4:
mov al,fi
cmp al,0
jz fi04
cmp al,1
jz fi14
cmp al,2
jz fi24
cmp al,3
jz fi34
cmp al,4
jz fi44
cmp al,5
jz fi54 

co5: 
mov al,fi
cmp al,0
jz fi05
cmp al,1
jz fi15
cmp al,2
jz fi25
cmp al,3
jz fi35
cmp al,4
jz fi45
cmp al,5
jz fi55

        
        fi00:
        mov bh,0
        mov dh,4
        mov dl,34
        mov ah,2               ;(0,0)
        int 10h
        
        mov ah, 09h
        lea dx, unos
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
       
        
        fi10:
        mov bh,0
        mov dh,6
        mov dl,34
        mov ah,2               ;(1,0)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco  
        
        
        fi20:
        mov bh,0
        mov dh,8
        mov dl,34               ;(2,0)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco  
        
        
        fi30:
        mov bh,0
        mov dh,10
        mov dl,34                ;(3,0)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        fi40:
        mov bh,0
        mov dh,12
        mov dl,34
        mov ah,2                 ;(4,0)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
       
        fi50:
        mov bh,0
        mov dh,14
        mov dl,34                 ;(5,0)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h  
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        fi01:
        mov bh,0
        mov dh,4
        mov dl,36                 ;(0,1)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        fi11:
        mov bh,0
        mov dh,6
        mov dl,36                ;(1,1)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
      
        
        fi21:
        mov bh,0
        mov dh,8
        mov dl,36                  ;(2,1)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h 
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
          
        
        fi31:
        mov bh,0
        mov dh,10                   ;(3,1)
        mov dl,36
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
       
        
        fi41:
        mov bh,0
        mov dh,12                    ;(4,1)
        mov dl,36
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
          
        
        fi51:
        mov bh,0
        mov dh,14                   ;(5,1)
        mov dl,36
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
          
        
        fi02:
        mov bh,0
        mov dh,4                    ;(0,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco  
        
        
        fi12:
        mov bh,0
        mov dh,6                    ;(1,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        
        fi22:
        mov bh,0
        mov dh,8                    ;(2,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
         
        
        fi32:
        mov bh,0
        mov dh,10
        mov dl,38                   ;(3,2)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
         
        fi42:
        mov bh,0
        mov dh,12                   ;(4,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
       
        
        fi52:
        mov bh,0
        mov dh,14                    ;(5,2)
        mov dl,38
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
         
        fi03:
        mov bh,0
        mov dh,4
        mov dl,40                    ;(0,3)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        
        fi13:
        mov bh,0
        mov dh,6                     ;(1,3)
        mov dl,40
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h 
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
      
        
        fi23:
        mov bh,0
        mov dh,8
        mov dl,40
        mov ah,2                     ;(2,3)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h 
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        
        fi33:
        mov bh,0
        mov dh,10
        mov dl,40                    ;(3,3)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
      
        
        fi43:
        mov bh,0
        mov dh,12
        mov dl,40
        mov ah,2                     ;(4,3)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
       
        
        fi53:
        mov bh,0
        mov dh,14
        mov dl,40                     ;(5,3)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
         
        
        fi04:
        mov bh,0
        mov dh,4
        mov dl,42                      ;(0,4)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
         
        
        fi14:
        mov bh,0
        mov dh,6                      ;(1,4)
        mov dl,42
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        
        fi24:
        mov bh,0
        mov dh,8
        mov dl,42                      ;(2,4)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
          
        
        fi34:
        mov bh,0
        mov dh,10
        mov dl,42                      ;(3,4)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
          
        
        fi44:
        mov bh,0
        mov dh,12
        mov dl,42
        mov ah,2                       ;(4,4)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        
        fi54:
        mov bh,0
        mov dh,14
        mov dl,42
        mov ah,2                      ;(5,4)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
         
        
        fi05:
        mov bh,0
        mov dh,4
        mov dl,44
        mov ah,2                      ;(0,5)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
       
        
        fi15:
        mov bh,0
        mov dh,6
        mov dl,44                      ;(1,5)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
        
        
        fi25: 
        mov bh,0
        mov dh,8
        mov dl,44                      ;(2,5)
        mov ah,2
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
          
        
        fi35:
        mov bh,0
        mov dh,10
        mov dl,44
        mov ah,2
        int 10h 
        lea dx,unos                   ;(3,5)
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 
         
        
        fi45:
        mov bh,0
        mov dh,12
        mov dl,44
        mov ah,2                      ;(4,5)
        int 10h 
        lea dx,unos 
        mov ah, 09h
        int 21h
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco  
       
        
        fi55:
        mov bh,0
        mov dh,14
        mov dl,44
        mov ah,2                       ;(5,5)
        int 10h 
        lea dx,ceros 
        mov ah, 09h
        int 21h 
        mov al,mode
        cmp al,0
        jz eliminar1
        jnz elBarco 


eliminar1:
mov ax,0000h
mov al,fi
mov si,0
cmp vecp1[si],al
jz eliminarCo                   ;SE VERIFICA A QUE BARCO PERTENECE EL DISPARO EXITOSO
cmp vecp2[si],al
jz eliminarCo
cmp vecp3[si],al
jz eliminarCo
cmp vecp4[si],al
jz eliminarCo
cmp vecp5[si],al
jz eliminarCo
jmp eliminar2

eliminarCo:
mov ax,0000h
mov al,co
mov si,1
cmp vecp1[si],al
jz menospor
cmp vecp2[si],al
jz menospor
cmp vecp3[si],al
jz menospor
cmp vecp4[si],al
jz menospor
cmp vecp5[si],al
jz menospor

eliminar2:
mov ax,0000h
mov al,fi
mov si,0
cmp vecc1[si],al
jz eliminarCo1
cmp vecc2[si],al
jz eliminarCo1
cmp vecc3[si],al
jz eliminarCo1
cmp vecc4[si],al
jz eliminarCo1
jmp eliminar3 

eliminarCo1:
mov ax,0000h
mov al,co
mov si,1
cmp vecc1[si],al
jz menospor1
cmp vecc2[si],al
jz menospor1
cmp vecc3[si],al
jz menospor1
cmp vecc4[si],al
jz menospor1


eliminar3:
mov ax,0000h
mov al,fi
mov si,0
cmp vecs1[si],al
jz eliminarCo2
cmp vecs2[si],al
jz eliminarCo2
cmp vecs3[si],al
jz eliminarCo2

eliminarCo2:
mov ax,0000h
mov al,co
mov si,1
cmp vecs1[si],al
jz menospor2
cmp vecs2[si],al
jz menospor2
cmp vecs3[si],al
jz menospor2



menospor:
mov ax,0000h
mov bx,0000h
mov cx,0000h
mov al,celdasP                  ;SE VERIFICA SI EL DISPARO ES DESTRUCCION DE BARCO O SOLO
dec al                          ;NORMAL
mov celdasP,al
cmp al,0
jz menosPorta
jnz textoMisil

menosPorta:

mov bh,0
mov dh,23
mov dl,0
mov ah,2                       ;Avisa DESTRUCCION DE PORTAVIONES
int 10h 
mov ah,09h
lea dx,fraseP
int 21h
mov ax,0000h
mov al,barcos
dec al
mov barcos,al
jmp verificar 
 


menospor1:
mov ax,0000h
mov bx,0000h
mov cx,0000h
mov al,celdasC
dec al
mov celdasC,al
cmp al,0
jz menosCruce
jnz textoMisil

menosCruce:
mov bh,0
mov dh,23
mov dl,0
mov ah,2                       ;Avisa DESTRUCCION DE CRUCERO
int 10h 
mov ah,09h
lea dx,fraseC
int 21h
mov ax,0000h
mov al,barcos
dec al
mov barcos,al
jmp verificar 

menospor2:
mov ax,0000h
mov bx,0000h
mov cx,0000h
mov al,celdasS
dec al
mov celdasS,al
cmp al,0
jz menosSub
jnz textoMisil

menosSub:
mov bh,0
mov dh,23
mov dl,0
mov ah,2                       ;Avisa DESTRUCCION DE SUBMARINO
int 10h 
mov ah,09h
lea dx,fraseS
int 21h
mov ax,0000h
mov al,barcos
dec al
mov barcos,al
jmp verificar


verificar:
mov al,barcos
cmp al,0                         ;SE VERIFICA SI QUEDAN BARCOS
jz ganar
jnz textoMisil

ganar:
mov bh,0
mov dh,23
mov dl,0
mov ah,2                         ;GANADOR, SE PREGUNTA SI SE QUIERE JUGAR OTRA VZ
int 10h 
mov ah,09h
lea dx,fraseG
int 21h
jmp volver   




perder:
mov bh,0
mov dh,23
mov dl,0                         ;PERDEDOR; SE REVELAN LOS BARCOS
mov ah,2
int 10h 
mov ah,09h
lea dx,fraseD
int 21h
jmp revelar

revelar:
mov ax,0000h
mov al,mode                      ;REVELACION DE BARCOS
inc al
mov mode,al
jmp elBarco

elBarco:
mov ax,0000h
mov al,mode
cmp al,1
jz Rporta
cmp al,2
jz Rcruce
cmp al,3
jz Rsubma
jmp volver  

Rporta:
mov ax,0000h
mov al,numCP
inc al
mov numCP,al
cmp al,1
jz m1p
cmp al,2
jz m2p
cmp al,3
jz m3p
cmp al,4
jz m4p
cmp al,5       
jz m5p

m1p:
mov ax,0000h
mov bx,0000h
mov al,vecp1[0]
mov bl,vecp1[1]
mov fi,al
mov co,bl
jmp pintar

m2p:
mov ax,0000h
mov bx,0000h
mov al,vecp2[0]
mov bl,vecp2[1]
mov fi,al
mov co,bl
jmp pintar

m3p:
mov ax,0000h
mov bx,0000h
mov al,vecp3[0]
mov bl,vecp3[1]
mov fi,al
mov co,bl
jmp pintar

m4p:
mov ax,0000h
mov bx,0000h
mov al,vecp4[0]
mov bl,vecp4[1]
mov fi,al
mov co,bl
jmp pintar 

m5p:
mov ax,0000h
mov bx,0000h
mov al,vecp5[0]
mov bl,vecp5[1]
mov fi,al
mov co,bl
mov ax,0000h
mov al,mode
inc al
mov mode,al
jmp pintar


       
Rcruce:
mov ax,0000h
mov al,numCC
inc al
mov numCC,al
cmp al,1
jz m1c
cmp al,2
jz m2c
cmp al,3
jz m3c
cmp al,4
jz m4c

m1c:
mov ax,0000h
mov bx,0000h
mov al,vecc1[0]
mov bl,vecc1[1]
mov fi,al
mov co,bl
jmp pintar

m2c:
mov ax,0000h
mov bx,0000h
mov al,vecc2[0]
mov bl,vecc2[1]
mov fi,al
mov co,bl
jmp pintar

m3c:
mov ax,0000h
mov bx,0000h
mov al,vecc3[0]
mov bl,vecc3[1]
mov fi,al
mov co,bl
jmp pintar

m4c:
mov ax,0000h
mov bx,0000h
mov al,vecc4[0]
mov bl,vecc4[1]
mov fi,al
mov co,bl
mov ax,0000h
mov al,mode
inc al
mov mode,al
jmp pintar   

      
       
Rsubma:
mov ax,0000h
mov al,numCS
inc al
mov numCS,al
cmp al,1
jz m1s
cmp al,2
jz m2s
cmp al,3
jz m3s

m1s:
mov ax,0000h
mov bx,0000h
mov al,vecs1[0]
mov bl,vecs1[1]
mov fi,al
mov co,bl
jmp pintar

m2s:
mov ax,0000h
mov bx,0000h
mov al,vecs2[0]
mov bl,vecs2[1]
mov fi,al
mov co,bl
jmp pintar

m3s:
mov ax,0000h
mov bx,0000h
mov al,vecs3[0]
mov bl,vecs3[1]
mov fi,al
mov co,bl
mov ax,0000h
mov al,mode
inc al
mov mode,al
jmp pintar 
                       
          


volver:
mov ax,0000h
mov bh,0
mov dh,23
mov dl,0
mov ah,2
int 10h 
mov ah,09h
lea dx,fraseV
int 21h 
mov bh,0
mov dh,22
mov dl,35
mov ah,2                       ;SE PREGUNTA SI SE QUIERE VOLVER A JUGAR s->Si n->No
int 10h  
mov ah,01h
int 21h
cmp al,'s'
jz  reset
cmp al,'n'
jz salir
jnz volver

reset:   
mov si,0
mov f1[si],0
mov f1[si+1],0
mov f1[si+2],0
mov f1[si+3],0
mov f1[si+4],0
mov f1[si+5],0
mov f2[si],0
mov f2[si+1],0
mov f2[si+2],0
mov f2[si+3],0
mov f2[si+4],0
mov f2[si+5],0
mov f3[si],0                    ;SE BORRAN LOS DATOS DE LA MATRIZ GUARDADA EN SISTEMA
mov f3[si+1],0
mov f3[si+2],0
mov f3[si+3],0
mov f3[si+4],0
mov f3[si+5],0
mov f4[si],0
mov f4[si+1],0
mov f4[si+2],0
mov f4[si+3],0
mov f4[si+4],0
mov f4[si+5],0
mov f5[si],0
mov f5[si+1],0
mov f5[si+2],0
mov f5[si+3],0
mov f5[si+4],0
mov f5[si+5],0
mov f6[si],0
mov f6[si+1],0
mov f6[si+2],0
mov f6[si+3],0
mov f6[si+4],0
mov f6[si+5],0  
mov al,20
mov conteo,al
mov al,3
mov barcos,3
mov al,5
mov celdasP,al
mov al,4
mov celdasC,al
mov al,3
mov celdasS,al
mov al,0
mov mode,al
mov numCP,al
mov numCC,al
mov numCS,al
mov ax,0000h
jmp limpiar_pantalla             ;SE VUELVE A JUGAR






          
salir:
.exit
end












 

