	

    ;Calculator by Kelvin Silva
     ;Note that you can only use single digit numbers and also note that this current project will not assemble
	 ;Failed project.
     
    ;Simple 4 operation calculator, +-*/
     
    SECTION .data
     
            AskForCalculationPrompt: db "Choose which operation you want", 0xA, "1. Addition", 0xA, "2.Subtraction", 0xA, "3. Multiplication", 0xA, "4. Division", 0x3
            AskForCalculationPromptln: equ $-AskForCalculationPrompt
     
            FirstOperandPrompt: db "Enter the first operand:", 0xA
            FirstOperandPromptln: equ $-FirstOperandPrompt
     
            SecondOperandPrompt: db "Enter the second operand:", 0xA
            SecondOperandPromptln: equ $-SecondOperandPrompt
     
            AnswerPrompt: db "The answer is: "
            AnswerPromptln: equ $-AnswerPrompt
     
            ErrorMsg: db "Wrong Choice made...insert correct choice"
            ErrorMsgln: equ $-ErrorMsg
     
     
    SECTION .bss
     
            Choice: resb 2
            FirstOperand: resb 2
            SecondOperand: resb 2
            Answer: resb 10
           
    SECTION .text
     
            ;Make interrupt to ask for a prompt ask for calculation prompt
            global _start
     
            _start:
     
            mov eax, 4 ;Specify sys_write call
            mov ebx, 1 ;Standard output
            mov ecx, AskForCalculationPrompt
            mov edx, AskForCalculationPromptln
            int 80h
     
            ;Make interrupt to read textfrom keyboard
            READ:
     
            mov eax, 3 ;Sys_read call
            mov ebx, 0 ;Standard input file descriptor 0
            mov ecx, Choice
            mov edx, 2
            int 80h
     
            ;Determine what we inserted
     
            ;Prompt for first operand
            mov eax, 4
            mov ebx, 1
            mov ecx, FirstOperandPrompt
            mov edx, FirstOperandPromptln
            int 80h
     
            ;Retrieve first operand input
            mov eax, 3
            mov ebx, 0
            mov ecx, FirstOperand
            mov ebx, 2
            int 80h
     
            ;Prompt for second operand
            mov eax, 4
            mov ebx, 1
            mov ecx, SecondOperandPrompt
            mov edx, SecondOperandPromptln
            int 80h
     
            ;Retrieve second operand input
            mov eax, 3
            mov ebx, 0
            mov ecx, SecondOperand
            mov edx, 2
            int 80h
     
            ;Load values retrieved into registers eax, ebx, ecx, for comparison and operation
            mov al, byte [Choice]
            mov bl, byte [FirstOperand]
            mov cl, byte [SecondOperand]
     
            ;Subtract each value by '0' to get numeric equivalent
            sub bl, 0x30
            sub cl, 0x30
     
            JMP SWITCH
    ;*******************************************************************************
    ;SWITCH*************************************************************************
    ;*******************************************************************************
            SWITCH:
     
                    cmp al, 0x31
                    je ADDLABEL
     
                    cmp al, 0x32
                    je SUBTRACTLABEL
     
                    cmp al, 0x33
                    je MULTIPLICATIONLABEL
     
                    cmp al, 0x34
                    je DIVISIONLABEL
     
                    JMP DEFAULTLABEL
     
            DEFAULTLABEL:
                   
                    mov eax, 4
                    mov ebx, 1
                    mov ecx, ErrorMsg
                    mov edx, ErrorMsgln
                    int 80h
                    JMP READ
     
           
    ;*****************************************************************************
    ;OPERATIONS*******************************************************************
    ;*****************************************************************************
     
            ADDLABEL:
                    clc
                    mov al, cl
                    add al, bl
                    JMP DISPLAYOPERATION
     
            SUBTRACTLABEL:
                    clc
                    mov al, cl
                    sub al, bl
                    JMP DISPLAYOPERATION
           
            MULTIPLICATIONLABEL:
                    clc
                    mov al, cl
                    mul cl
                    JMP DISPLAYOPERATION
     
            DIVISIONLABEL:
                   
                    clc
                    mov al, cl
                    div cl
                    JMP DISPLAYOPERATION
    ;*****************************************************************************
    ;Convert string to integer****************************************************
    ;*****************************************************************************
     
            KELVINSATOI:
                    push ebx
                    push ecx
                    push edx
                           
                    xor ecx, ecx
                    LOOPBEGIN:
                            cmp byte [eax+ecx], 0xA
                            je LOOPEND
                    sub byte [eax+ecx], 0x30               
     
                    inc ecx
                    jmp LOOPBEGIN  
     
                    LOOPEND:                       
                   
                    xor ebx, ebx
                    xor edx, edx
                    sub ecx, 1
                    push ecx
                    xor edi, edi
                    xor esi, esi
                    LOOP2BEGIN:
                    mov ebx, byte [eax+edi]
     
                       LOOP3BEGIN:
                                   
                            mov ecx, byte [eax+edi]
                            shl ebx, 3
                            add ebx, ecx
                            add ebx, ecx
                            xor ecx, ecx
                            pop ecx
                            inc edx
                            cmp edx, ecx
                             push ecx
                            jne LOOP3BEGIN
     
                        LOOP3END:
                    add esi, ebx   
                            pop ecx
                            dec ecx
                            push ecx
                            inc edi
                            xor edx, edx
                            cmp byte [eax+edi], 0xA
                            je LOOP2END
                            jmp LOOP2BEGIN         
     
                    LOOP2END:        
             
     
     
     
    ;*****************************************************************************
    ;DISPLAYOPERATION*************************************************************
    ;*****************************************************************************
     
            DISPLAYOPERATION:
                   
                    add eax, 0x30
                    mov [Answer], al
                    mov eax, 4
                    mov ebx, 1
                    mov ecx, Answer
                    mov edx, 1
                    int 80h
     
                    mov eax, 1
                    mov ebx, 0
                    int 80h

