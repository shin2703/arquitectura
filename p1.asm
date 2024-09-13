ORG 0000H           ; Inicio del programa en la dirección 0000H
MOV P1, #00H        ; Limpiar el puerto P1 (asumiendo que el display está en P1)
MOV R0, #00H        ; Inicializar el contador en 0
MOV DPTR, #Tabla    ; Cargar la dirección de la tabla de segmentos

Bucle_Principal:
   ; Mostrar el valor actual en el display
   MOV A, R0
   MOVC A, @A+DPTR
   MOV P1, A

   ; Verificar si el botón en P3.2 (incrementar) está presionado
   JB P3.2, Verificar_Decremento   ; Saltar si el botón no está presionado
   ACALL Incrementar               ; Llamar subrutina para incrementar
   SJMP Bucle_Principal            ; Regresar al bucle

Verificar_Decremento:
   ; Verificar si el botón en P3.3 (decrementar) está presionado
   JB P3.3, Bucle_Principal        ; Saltar si el botón no está presionado
   ACALL Decrementar               ; Llamar subrutina para decrementar
   SJMP Bucle_Principal            ; Regresar al bucle

; Subrutina para incrementar el contador
Incrementar:
   INC R0                          ; Incrementar el contador
   CJNE R0, #0AH, Mostrar           ; Compara R0 con 10. Si no es igual, salta a 'Mostrar'
   MOV R0, #09H                    ; Si es 10, establecer R0 en 9
   ACALL Extra_Azucar               ; Llamar a la subrutina de "Extra azucar"
   RET

Mostrar:
   RET

; Subrutina para decrementar el contador
Decrementar:
   CJNE R0, #00H, Decrementar_Seg   ; Compara si R0 es 0, si no es igual, saltar
   ACALL Sin_Azucar                 ; Si es 0, enviar "Sin azucar"
   RET
Decrementar_Seg:
   DEC R0                           ; Decrementar el contador
   RET

; Subrutina para mostrar el mensaje "Extra azucar"
Extra_Azucar:
   MOV DPTR, #MensajeExtra          ; Cargar el mensaje en DPTR
   ACALL Enviar_Mensaje             ; Enviar el mensaje al terminal
   RET

; Subrutina para mostrar el mensaje "Sin azucar"
Sin_Azucar:
   MOV DPTR, #MensajeSin            ; Cargar el mensaje en DPTR
   ACALL Enviar_Mensaje             ; Enviar el mensaje al terminal
   RET

; Subrutina para enviar un mensaje al terminal
Enviar_Mensaje:
   MOVC A, @A+DPTR                     ; Obtener el carácter actual del mensaje
   JZ Fin_Mensaje                   ; Si es el final del mensaje (cero), terminar
   ACALL Transmitir_Char            ; Enviar el carácter
   INC DPTR                         ; Mover al siguiente carácter
   SJMP Enviar_Mensaje              ; Repetir hasta enviar todo el mensaje
Fin_Mensaje:
   RET

; Subrutina para transmitir un carácter (UART)
Transmitir_Char:
   MOV SBUF, A                      ; Enviar el carácter a SBUF
Esperar_Transmision:
   JNB TI, Esperar_Transmision       ; Esperar hasta que la transmisión termine
   CLR TI                           ; Limpiar la bandera TI
   RET

; Tabla de codificación para los números del 0 al 9 en un display de 7 segmentos
Tabla:
   DB 3FH    ; 0
   DB 06H    ; 1
   DB 5BH    ; 2
   DB 4FH    ; 3
   DB 66H    ; 4
   DB 6DH    ; 5
   DB 7DH    ; 6
   DB 07H    ; 7
   DB 7FH    ; 8
   DB 6FH    ; 9

; Mensaje "Extra azucar"
MensajeExtra:
   DB 'Extra azucar', 00H           ; El mensaje termina con 00H

; Mensaje "Sin azucar"
MensajeSin:
   DB 'Sin azucar', 00H             ; El mensaje termina con 00H

END                                 ; Fin del programa
