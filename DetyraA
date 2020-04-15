.data
array: .space 20
jepNrAnt: .asciiz "Jep numrin e anetareve te vektorit (max. 5): "
shtypElem: .asciiz "Shtyp elementet nje nga nje: \n"
vleratEvekt: .asciiz "Vlerat e vektorit jane: \n"
endl: .asciiz "\n"

.text
    main:
    la $a0, array
    addi $a1, $zero, 0  #inicializimi i n-it (pra ne a1)

    jal populloVektorin  #thirret funksioni
    #move $t0, $v1   #ne t0 po e ruajme n-in e cila eshte dhene ne funksionin populloVektorin
    
    move $a1, $v1
    la $a0, array

    jal unazakalimit
    

    
    exit:
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
        

unazakalimit:  
    addi $sp, $sp, -12
    sw $ra, 0($sp)

    move $s0, $a0  #array
    move $s1, $a1   #vlera e n

    li $t0, 0
    
    loop1: 
        bgt $t0, $s1, stop
        
        li $t3, 4
        mul $t8, $t0, $t3
        add $t6, $s0, $t8 #adresen e array po e inkrementojme per vleren e $t8, e cila shumezohet me 4 pas cdo iterimi

        lw $t1, 0($t6) #variabla min
        move $t2, $t0 #loc
        
        move $a2, $t0   #parametri p qe do ti jipet funksionit ne vazhdim
        move $a3, $t1   #parametri min

        sw $t2, 4($sp)  #po e ruajme ne stack loc per me e shfrytezu si parameter

        jal unazavlerave
        j loop1
    stop:
        lw $ra, 0($sp)

        jr $ra


unazavlerave:
    move $s3, $a0 #adresa e array
    move $s4, $a1 #n 
    move $s5, $a2 #p
    move $s6, $a3 #min
    lw $s7, 4($sp) #loc

    jr $ra












