include 'emu8086.inc'
.model small        ;modelo de memoria
.data               ;comienzo del segmento de datos
conteo db 50
frase1 db 'Misil $'
frase2 db ' ............... $' 
var1   db ?
             
.code               ;comienzo del segmento de codigo
.start 

textoMisil:   
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
mov al,conteo
cmp al,0
jz .data
jnz limpia

limpia:
mov ax,0000h
mov bh,0
mov dh,0
mov dl,35     ;ubica el "cursor"
mov ah,2
int 10h 

mov ah,01
int 21h
sub al, 30h

mov var1,al 
mov ah,09h
lea dx,var1
int 21h
jmp textoMisil 


salir:
.exit  

end   