ORG 00H
    LJMP START

ORG 0003H
    LJMP INT0_ISR

ORG 000BH
    LJMP TIMER0_ISR

START:
    MOV DPTR, #LCD_INIT_MSG  ; Mostrar mensaje inicial en el LCD
    ACALL LCD_WRITE
    MOV R0, #9               ; Iniciar el contador en 9
    ACALL DISPLAY_COUNT       ; Mostrar el valor inicial en el LCD

    ; Configuración del Timer 0 en modo 1
    MOV TMOD, #01H
    MOV TH0, #3CH           ; Valor alto para 5 segundos
    MOV TL0, #0B0H           ; Valor bajo para 5 segundos
    SETB ET0                 ; Habilitar interrupción del Timer 0
    SETB EA                  ; Habilitar interrupciones globales
    SETB TR0                 ; Iniciar el Timer 0

    ; Configuración de la interrupción externa INT0
    SETB IT0                 ; Flanco de bajada en INT0 (P3.2)
    SETB EX0                 ; Habilitar interrupción externa INT0

MAIN_LOOP:
     JB P3.7, MAIN_LOOP   ; Si hay falla, mantenerse en el bucle

    MOV A, R0
    CJNE A, #00H, COUNTING    ; Si el contador no es 0, seguir contando

    ; Si la cuenta llega a 0
    ACALL LCD_CLEAR           ; Limpiar el LCD
    MOV DPTR, #IGNICION_MSG   ; Mostrar mensaje "IGNICION" y "DESPEGUE"
    ACALL LCD_WRITE
    SJMP $                    ; Esperar indefinidamente (cohete despegó)

COUNTING:
    ACALL DELAY_1S            ; Esperar 1 segundo
    DJNZ R0, UPDATE_LCD       ; Decrementar el contador

UPDATE_LCD:
    ACALL DISPLAY_COUNT       ; Mostrar el nuevo valor del contador en el LCD
    SJMP MAIN_LOOP            ; Repetir el ciclo

; Rutina de interrupción del Timer 0 (simula falla a los 5 segundos)
TIMER0_ISR:
    CLR TR0                   ; Detener el Timer 0
    SETB P3.7                 ; Establecer la bandera de falla
    MOV DPTR, #FAIL_MSG       ; Mostrar "Existe una falla" en el LCD
    ACALL LCD_WRITE
    RETI                      ; Retorno de la interrupción

; Rutina de interrupción externa INT0 (P3.2)
INT0_ISR:
    CLR P3.7                  ; Limpiar la bandera de falla
    MOV DPTR, #LCD_INIT_MSG   ; Mostrar nuevamente el mensaje de cuenta
    ACALL LCD_WRITE
    SETB TR0                  ; Reiniciar el Timer 0
    RETI                      ; Retorno de la interrupción

; Mensajes del LCD
LCD_INIT_MSG: DB "Cuenta regresiva: 9", 00H
FAIL_MSG:     DB "Existe una falla ", 00H
IGNICION_MSG: DB "IGNICION", 00H, "DESPEGUE", 00H

; Subrutina para escribir mensajes en el LCD
LCD_WRITE:
    ; Implementar la rutina de envío de cadenas de texto al LCD
    RET

; Subrutina para mostrar el valor del contador en el LCD
DISPLAY_COUNT:
    MOV A, R0
    ADD A, #30H               ; Convertir el número en ASCII
    ACALL LCD_SEND_CHAR       ; Cambiado a ACALL (si está en el mismo bloque de memoria)
    RET

; Subrutina para limpiar el LCD
LCD_CLEAR:
    ; Implementar la rutina para limpiar el LCD
    RET

; Rutina de retardo de 1 segundo
DELAY_1S:
    ; Implementar retardo de 1 segundo, según la velocidad del cristal
    RET

; Subrutina para enviar un carácter al LCD
LCD_SEND_CHAR:
    ; Implementar el código de envío de un carácter al LCD
    RET

END
