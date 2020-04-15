.data
array: .space 20
jepNrAnt: .asciiz "Jep numrin e anetareve te vektorit (max. 5): "
shtypElem: .asciiz "Shtyp elementet nje nga nje: \n"
vleratEvekt: .asciiz "Vlerat e vektorit jane: \n"
endl: .asciiz "\n"
n: .word 0

.text
    main:
    la $a0, array
    lw $a1, n

    jal populloVektorin  #thirret funksioni
    #move $t0, $v1   #ne t0 po e ruajme n-in e cila eshte dhene ne funksionin populloVektorin
    
    
    la $a0, array 
    move $a1, $v1
    jal unazaKalimit

    li $v0, 10
    syscall


populloVektorin:
    move $s0, $a0
    move $s1, $a1

    li $v0, 4
    la $a0, jepNrAnt
    syscall
    li $v0, 5       #numri i anetareve i dhene nga perdoruesi
    syscall
    
    move $v1, $v0   #n po e ruajme ne v1 si return value
    move $s1, $v1  #n po ruhet ne variablen e ardhur nga main $s1

    li $v0, 4
    la $a0, endl        #rresht i ri
    syscall

    li $v0, 4
    la $a0, endl        #rresht i ri
    syscall

    li $v0, 4
    la $a0, shtypElem   #printohet shtypElem
    syscall

    li $t1, 0

    loop: beq $t1, $s1, endloop
        li $v0, 5      # inputi perdoruesit
        syscall

        sw $v0, 0($s0) #po e rujme ne array vleren e dhene prej perdoruesit

        addi $s0, $s0, 4
        addi $t1, $t1, 1

        j loop

    endloop:
        jr $ra
        

unazaKalimit:  
    addi $sp, $sp, -4
    sw $ra, 0($sp)      #adresen kthyese te ketij funksioni e ruajme ne stack

    move $s0, $a0  #array
    move $s1, $a1   #vlera e n

    li $t0, 0
    
    loop1: 
        beq $t0, $s1, endloop1
        
        li $t3, 4
        mul $t4, $t0, $t3
        add $t5, $s0, $t4 #adresen e array po e inkrementojme per vleren e $t8, e cila shumezohet me 4 pas cdo iterimi

        lw $t1, 0($t5) #variabla min
        addi $t2, $t0, 0 #loc
        
        addi $a2, $t0, 0  #parametri p qe do ti jipet funksionit ne vazhdim
        addi $a3, $t1, 0   #parametri min
        addi $sp, $sp, -8
        sw $t2, 0($sp)  #po e ruajme ne stack loc per me e shfrytezu si parameter

        jal unazavlerave
        lw $t1, 0($sp)
        lw $t2, 4($sp)
        addi $sp, $sp, 8

        li $t3, 4
        mul $t4, $t0, $t3 #$t3 e kemi deklaru ma nalt si 4, se na duhet per me nxjerr elemente nga array(si shumefisha te 4)
        add $t5, $s0, $t4 #qeshtu e inkrementojme adresen per casjen e elementeve te array

        lw $t8, 0($t5) #temp = a[p]
        sw $s7, 0($t5) #a[p] = a[loc]

        mul $t6, $t2, $t3
        add $t4, $s0, $t6 #loc si shumefish i 4
        sw $t8, 0($t4) #a[loc] = temp
        addi $t0, $t0, 1
        j loop1
    endloop1:
        lw $ra, 0($sp)
        addi $sp, $sp, 4

    li $t0, 0

    printimi:
        bgt $t0, $s1, fuckinEXIT

        li $v0, 1
        lw $a0, 0($s0)
        syscall 

        addi $s0, $s0, 4 #se adresat e anetareve jane shumefish i 4
        addi $t0, $t0, 1

        li $v0, 4
        la $a0, endl        #rresht i ri
        syscall

        j printimi
    fuckinEXIT:
        jr $ra


unazavlerave:
    move $s3, $a0 #adresa e array
    move $s4, $a1 #n 
    move $s5, $a2 #p
    move $s6, $a3 #min
    lw $s7, 0($sp) #loc

    addi $t6, $s5, 1 #p + 1 = k

    loop2:
        bgt $t6, $s4, endloop2
        li $t4, 4
        mul $t5, $t6, $t4
        add $t4, $s3, $t5

        lw $t7, 0($t4)  #po e marrim nje anetar nga array si min

        blt $s6, $t7, pass
        move $s6, $t7   #min = a[k]
        move $s7, $t6   #loc = k
        sw $s6, 0($sp)
        sw $s7, 4($sp)
        addi $t6, $t6, 1 #po edhe nese nuk gjindet su bo nomi, kalom ne iterimin tjt
            j loop2
        pass:
            addi $t6, $t6, 1 #po edhe nese nuk gjindet su bo nomi, kalom ne iterimin tjt
            j loop2
    endloop2:
        jr $ra
    











