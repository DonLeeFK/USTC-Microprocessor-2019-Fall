DATA SEGMENT
    BUFFER DB 100 DUP(?)
    PROMPT DB 'INPUT A N:$'
    STOREN DB 1 DUP(?)
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV BX,AX

;PRINT:    
    MOV DX,OFFSET PROMPT
    MOV AH,09H
    INT 21H
    XOR AX,AX
    LEA DI,STOREN
    MOV AH,01H
    INT 21H
    ;load n
    
    ;MOV AL,5H
    MOV DL,AL
    ;MOV AL,05H
    SUB DL,30H
    MOV [DI],DL
    
    MOV DL,0AH
    MOV AH,02H
    INT 21H 
    
CACULATE:
    MOV BX,AX
    MUL BL
    LEA DI,BUFFER
    MOV BX,AX
    MOV AL,1H
WRITEBUFFER:
    
    
    MOV [DI],AL
    INC AL
    INC DI
    CMP AL,BL
    JLE WRITEBUFFER
    JG OUTPUT

OUTPUT:
    ;LEA SI,STOREN
    ;MOV CL,[SI]
    ;CL=N
    MOV CL,0
    MOV BL,1
    MOV SI,OFFSET BUFFER
    MOV DL,0AH
    MOV AH,02H
    INT 21H 
WHILE:
    

    CMP CL,BL
    JL PRINTNUM
    JGE PRINTLINE
    
PRINTNUM:
    XOR AX,AX
    MOV DL,[SI]
    CMP DL,0AH
    JGE ABOVE10
    ADD DL,30H
    MOV AH,02H
    INT 21H
    MOV DL,32
    MOV AH,2
    INT 21H
    
    INC CL
    INC SI
    JMP WHILE

ABOVE10:
    XOR AX,AX
    MOV DL,[SI]
    MINUS10:
        INC AL
        SUB DL,0AH
        JNS MINUS10
        SUB AL,01H
        ADD DL,0AH
    ADD DL,30H
    MOV DH,DL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
    MOV DL,DH
    MOV AH,02H
    INT 21H
    MOV DL,32
    MOV AH,2
    INT 21H

    INC CL
    INC SI
    JMP WHILE

PRINTLINE:
    XOR AX,AX
    MOV DL,0AH
    MOV AH,02H
    INT 21H 
    
    
    ;LEA SI,STOREN
    ;MOV AX,[SI]
    ;ADD SI,AX
    
    CMP BL,[STOREN]
    JE EXIT
    XOR AX,AX
    LEA SI,STOREN
    MOV AL,[SI]
    LEA SI,BUFFER
    MUL BL
    INC BL
    ADD SI,AX
    MOV CL,0
    JMP WHILE
EXIT:
    MOV AX,4C00H
    INT 21H
CODE ENDS
END START

