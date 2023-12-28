.MODEL SMALL
 
.STACK 100H

.DATA  
                                                      
SELECT DB ?

OP_MESSAGE DB 0DH , 0AH , 0DH , 0AH , 'ALL OPERATIONS : $'
MESSAGE_1 DB 0DH , 0AH , '1. BINARY TO DECIMAL CONVERSION $'
MESSAGE_2 DB 0DH , 0AH , '2. DECIMAL TO BINARY $'
PRESS_CHOICE DB 0DH , 0AH , 'PRESS A NUMBER (1-2): $'
ERROR_MESSAGE DB 0DH , 0AH , 'PLEASE , ENTER THE NUMER AGAIN APPROPROAITELY... !!! $' 
    
    
                                                     
BIN_NUMBER DB 0DH , 0AH , 'INPUT A BINARY NUMBER : $' 

SHOW_DEC DB 0DH , 0AH , 'IN DECIMAL : $'
 
DECIMAL_NUMBER DB 0DH , 0AH , 'INPUT A DECIMAL NUMBER : $'

SHOW_BIN DB 0DH , 0AH , 'IN BINARY : $' 

NEW_LINE DB 0DH , 0AH , '$' 

binary DB 8 DUP(?)
a DB 30 DUP(?)
b db 30 dup(?)
power_sum db 0 
power dw 0
count DB 1 

.CODE 
    MAIN PROC 
    MOV AX,@DATA 
    MOV DS,AX
        MENU_BAR:                   
            
            LEA DX , OP_MESSAGE          
            MOV AH , 9
            INT 21H
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , MESSAGE_1      
            MOV AH , 9
            INT 21H
            
            LEA DX , MESSAGE_2
            MOV AH , 9
            INT 21H
            
            LEA DX , NEW_LINE       
            MOV AH , 9
            INT 21H
            
            LEA DX , PRESS_CHOICE   
            MOV AH , 9
            INT 21H     

        INPUT_CHOICE:            
        
            MOV AH , 1          
            INT 21H
            MOV SELECT,AL        
            
            CMP AL , 49         
            JE BIN_TO_DEC
            
            CMP AL , 50
            JE DEC_TO_BIN
            
            CMP AL , 49        
            JL ERROR
            
            CMP AL , 50                                            
            JG ERROR
        
        
        
        ERROR:                          
            
            LEA DX , NEW_LINE
            MOV AH , 9
            INT 21H
            
            LEA DX , ERROR_MESSAGE      
            MOV AH , 9
            INT 21H
            
            JMP MENU_BAR                
        
        




DEC_TO_BIN:

    LEA DX , DECIMAL_NUMBER 
    MOV AH , 9
    INT 21H

    MOV SI,0

    Input:

    MOV AH,1
    INT 21H 
    MOV BL,AL


    CMP BL,9H
    JE input_end


    sub bl, 30h
    MOV a[SI],BL
    
    INC SI

    JMP Input



    input_end:
    mov al, a[0]
    mov cl, 10
    mul cl
    add al, a[1]
    mov cl,10
    mul cl  
    add al, a[2]
    mov ah, 0

    MOV SI,0

    div_loop:
    mov dl, 2
    div dl
    mov b[si] , ah
    mov ah,0

    cmp al,0
    je next_loop

    inc si
    inc count 

    loop div_loop 


    next_loop:
    MOV SI,0
    
    mov cx,0
    mov cl,count  
    
    
    push_loop:
    MOV AX,0
    MOV AL ,b[SI]
    PUSH AX
    inc SI 
    loop push_loop

    mov cx,0
    mov cl,count
    
    
    
    LEA DX , NEW_LINE
    MOV AH , 9
    INT 21H
            
    LEA DX,SHOW_BIN   
    MOV AH,9
    INT 21H 

    print_bin:
    POP DX
    add dl,30h
    MOV AH,2
    INT 21H 
    loop print_bin

    EXIT: 
        
            MOV AH , 4CH
            INT 21H  
    
BIN_TO_DEC:    
    
    LEA DX , BIN_NUMBER 
    MOV AH , 9
    INT 21H

    MOV SI,0

    Input_bin:

    MOV AH,1
    INT 21H
    MOV BL,AL

    
    CMP BL,9H
    JE next


    sub bl, 30h
    MOV binary[SI],BL
    
    INC SI

    JMP Input_bin   
    
    
;================================================ 
    
    next:
    sub si,1 
    mov power,si
    mov si,0
    
    check:
    MOV AL, binary[si]
    cmp al, 1
    je power_cal:
    cmp al ,0
    inc si
    dec power
    jmp check
    
    
    power_cal:
        MOV AX,power
        MOV CL,AL           
        MOV BL,2            

        MOV AX,1            

        TEST CL,CL          
        JZ SHORT ADD_SUM    

    MUL_LOOP:
        MUL BL              
        DEC CL             
        JNZ MUL_LOOP       

    ADD_SUM:
        ADD power_sum, AL   
        
        
       DEC power
       inc si
       cmp power,0
       jl print
       jmp check
    
    print:  
        LEA DX , NEW_LINE
        MOV AH , 9
        INT 21H
            
        LEA DX,SHOW_DEC   
        MOV AH,9
        INT 21H
        
        MOV AH,0

        MOV AL,power_sum    
        CALL PRINT_NUMBER   

        MOV AH,4CH          
        INT 21H


    PRINT_NUMBER PROC
        PUSH BX             
        PUSH CX             
        PUSH DX           

        MOV BX,10           
        XOR CX,CX           

    PRINT_LOOP:
        XOR DX,DX           
        DIV BX              
        PUSH DX             
        INC CX              
        TEST AX,AX         
        JNZ PRINT_LOOP      

        MOV AH,02H          

    PRINT_DIGITS:
        POP DX              
        ADD DL,'0'          
        INT 21H            
        LOOP PRINT_DIGITS   

        POP DX            
        POP CX              
        POP BX              
        RET
    PRINT_NUMBER ENDP   
    
    
    

END: