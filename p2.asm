ORG 0000H           ; Inicio del programa
MOV P1, #00H        ; Limpiar el puerto P1
MOV TMOD, #02H      ; Configurar Timer 0 en modo 2 (auto-reload de 8 bits)
MOV TH0, #0DCH      ; Cargar valor para generar 8 Hz (frecuencia inicial)
MOV TL0, TH0        ; Cargar el mismo valor en TL0 para sincronizar
SETB TR0            ; Iniciar Timer 0

Bucle_Principal:
   ; Verificar si el botón en P3.2 (frecuencia 14 Hz) está presionado
   JB P3.2, Verificar_24Hz         ; Si no está presionado, verificar P3.3
   ACALL Frecuencia_14Hz           ; Cambiar a 14 Hz
   SJMP Bucle_Principal            ; Regresar al bucle principal

Verificar_24Hz:
   ; Verificar si el botón en P3.3 (frecuencia 24 Hz) está presionado
   JB P3.3, Bucle_Principal        ; Si no está presionado, mantener la frecuencia actual
   ACALL Frecuencia_24Hz           ; Cambiar a 24 Hz
   SJMP Bucle_Principal            ; Regresar al bucle principal

; Subrutina para generar 8 Hz
Frecuencia_8Hz:
   MOV TH0, #0DCH                  ; Valor de recarga para 8 Hz (~0xDC)
   MOV TL0, TH0                    ; Cargar el mismo valor en TL0 para sincronizar
   RET

; Subrutina para generar 14 Hz
Frecuencia_14Hz:
   MOV TH0, #0F2H                  ; Valor de recarga para 14 Hz (~0xF2)
   MOV TL0, TH0                    ; Cargar el mismo valor en TL0 para sincronizar
   RET

; Subrutina para generar 24 Hz
Frecuencia_24Hz:
   MOV TH0, #0FAH                  ; Valor de recarga para 24 Hz (~0xFA)
   MOV TL0, TH0                    ; Cargar el mismo valor en TL0 para sincronizar
   RET

; Rutina de interrupción del Timer 0
Timer0_ISR:
   CPL P1.0                        ; Invertir el estado de P1.0 (toggle)
   RETI                            ; Retorno de la interrupción

ORG 000BH          ; Vector de interrupción para Timer 0
AJMP Timer0_ISR    ; Salta a la rutina de servicio de interrupción del Timer
END ;fin del programa
