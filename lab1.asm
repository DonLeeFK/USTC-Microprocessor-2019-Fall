DATA SEGMENT
    FILENAME1 DB 'Input1.txt',0
    FILENAME2 DB 'Output1.txt',0
    BUFSIZE DB 100
    ACTLEN DB ?
    BUFFER DB 100 DUP(?)
    PROMPT DB 'INPUT A STRING:$'
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV DX,OFFSET FILENAME1
    MOV CX,0H
    MOV AH,3CH
    INT 21H
    ;creat file with name in DX
    JNC AFTERCREATFILE
    JMP EXIT
AFTERCREATFILE:
    MOV BX,AX

    MOV DX,OFFSET PROMPT
    MOV AH,09H
    INT 21H
    ;print string in DX, which is prompt
    ;write string to STDOUT
    MOV DX,OFFSET BUFSIZE
    MOV AH,0AH
    INT 21H
    ;fill buffer with user input
    
    ;MOV DL,0DH
    ;MOV AH,02H
    ;INT 21H
    ;print string in DL
    ;write character to STDOUT
    MOV DL,0AH
    MOV AH,02H
    INT 21H   ;\n
    ;write file
    MOV DX,OFFSET BUFFER
    XOR CX,CX
    ;CX is number of data to write
    MOV CL,ACTLEN
    MOV AH,40H
    INT 21H
    MOV AH,3EH
    INT 21H
    ;read file
    MOV DX,OFFSET FILENAME1
    MOV AL,2H
    MOV AH,3DH
    INT 21H
    JNC AFTEROPENFILE
    JMP EXIT
AFTEROPENFILE:
    MOV BX,AX
    MOV DX,OFFSET BUFFER
    MOV CX,100
    MOV AH,3FH
    INT 21H
    MOV CX,AX
    ;move number of bytes actually read to CX
    MOV AH,3EH
    INT 21H
    ;
    MOV BX,CX
    MOV SI,OFFSET BUFFER
NEXT:
    MOV DL,[SI]
    CMP DL,61H
    JB CAP
    SUB DL,20H
    MOV [SI],DL
CAP:
    INC SI
    MOV AH,02H
    INT 21H
    LOOP NEXT
    ;write data to output
    
    MOV DX,OFFSET FILENAME2
    MOV CX,0H
    MOV AH,3CH
    INT 21H
    MOV CX,BX
    MOV BX,AX
    MOV DX,OFFSET BUFFER
    MOV AH,40H
    INT 21H
    MOV AH,3EH
    INT 21H
EXIT:
    MOV AX,4C00H
    INT 21H
CODE ENDS
END START
