
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt


.model small        ;modelo de memoria
.data               ;comienzo del segmento de datos
var1 db ?             
.code               ;comienzo del segmento de codigo
.start 

mov var1, 50       

RANDNUM:  
mov ax,0000h
mov bx,0000h 
mov cx,0000h    ;Se limpian registros
mov dx,0000h
MOV AH, 2CH
INT 21H         ;Permite obtener un numero random acced
MOV AL,DL
MOV AH,0
MOV CL,15      ;con 20- de 0 a 5, con 15 de 0 a 6 de 10 de 0 a 7 y asi sucesivamente
DIV CL
MOV BL, AL      ;se guarda el numero random en bl
mov ax, 0000h
mov al,bl  
mov bx,0000h
mov cx,0000h
mov dx,0000h    
cmp al,2
jl convert
jmp RANDNUM

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
cmp cx, 0    ;verifica si el contador llego a 0
je  salir
jne mostrar  ;si lo anterior no se cumple, salta a la etiqueta mostrar
 
 
salir: 
mov bx, 0000h
mov bl,var1
dec bl
mov var1,bl
cmp var1,0h
jz adios
jnz RANDNUM   

adios:
.exit
end