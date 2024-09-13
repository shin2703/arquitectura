ORG 0000H           ; Inicio del programa en la dirección 0000H
MOV P1, #00H        ; Limpiar el puerto P1 (asumiendo que el display está en P1)
MOV DPTR, #Tabla    ; Cargar la dirección de la tabla de segmentos

Bucle_Principal:
   ; Verificar si el botón en P3.2 (cuenta regresiva) está presionado
   JB P3.2, Verificar_Creciente    ; Saltar si el botón no está presionado
   ACALL Cuenta_Regresiva           ; Llamar subrutina de cuenta regresiva
   SJMP Bucle_Principal             ; Regresar al bucle

Verificar_Creciente:
   ; Verificar si el botón en P3.3 (cuenta creciente) está presionado
   JB P3.3, Bucle_Principal        ; Saltar si el botón no está presionado
   ACALL Cuenta_Creciente           ; Llamar subrutina de cuenta creciente
   SJMP Bucle_Principal             ; Regresar al bucle

; Subrutina para la cuenta regresiva (de 9 a 0)
Cuenta_Regresiva:
   MOV R0, #09H                     ; Iniciar en 9
Regresar:
   MOV A, R0
   MOVC A, @A+DPTR                  ; Obtener el patrón del número para el display de 7 segmentos
   MOV P1, A                        ; Mostrar el número en el display
   ACALL Retardo_500ms               ; Esperar 500 ms
   DJNZ R0, Regresar                 ; Decrementar y repetir hasta que R0 sea 0
   SJMP Cuenta_Regresiva             ; Volver a contar regresivamente de 9

; Subrutina para la cuenta creciente (de 0 a 9)
Cuenta_Creciente:
   MOV R0, #00H                     ; Iniciar en 0
Crecer:
   MOV A, R0
   MOVC A, @A+DPTR                  ; Obtener el patrón del número para el display de 7 segmentos
   MOV P1, A                        ; Mostrar el número en el display
   ACALL Retardo_500ms               ; Esperar 500 ms
   INC R0                           ; Incrementar el contador
   CJNE R0, #0AH, Crecer             ; Si no es 10, seguir contando
   SJMP Cuenta_Creciente             ; Volver a contar desde 0

; Subrutina de retardo de 500ms utilizando Timer 0 en modo 0
Retardo_500ms:
   MOV TMOD, #01H                   ; Configurar Timer 0 en modo 1 (16-bit)
   MOV TH0, #3CH                    ; Cargar TH0 para ~500ms delay (con 12 MHz)
   MOV TL0, #0B0H
   SETB TR0                         ; Iniciar Timer 0
Esperar:
   JNB TF0, Esperar                 ; Esperar que TF0 se ponga en alto (Timer overflow)
   CLR TR0                          ; Detener el temporizador
   CLR TF0                          ; Limpiar la bandera de desbordamiento
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

END                                 ; Fin del programa
