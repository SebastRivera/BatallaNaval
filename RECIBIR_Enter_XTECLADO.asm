
.model small        ;modelo de memoria
.data               ;comienzo del segmento de datos
var1 db ?             
.code               ;comienzo del segmento de codigo
.start 

 
tecla:
mov ah,01h
int 21h
cmp al,0Dh
jz salir
jnz tecla
       
       
salir:
.exit  

end           

;Asignar x , y valores a cada punto de barco
;asignar y a letras
;si x, y es igual a X por usuario ; Y convertido a numero por el usuario
;Tener una funcion que ubique un valor en la pantalla(Si cumple imprime una O, si no una X)
;pero que este vaya cambiando segun la forma
;si 