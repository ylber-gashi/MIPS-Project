.data
array: .space 20
jepNrAnt: .asciiz "Jep numrin e anetareve te vektorit (max. 5): "
shtypElem: .asciiz "Shtyp elementet nje nga nje: \n"
vleratEvekt: .asciiz "\nVlerat e vektorit jane: \n"
endl: .asciiz "\n"
n: .word 0

.text
    main:
    la $a0, array
    lw $a1, n

    jal populloVektorin  #thirret funksioni

    move $t0, $v1   #ne t0 po e ruajme n-in e cila eshte dhene ne funksionin populloVektorin
    la $a1, n 
    sw $t0, 0($a1) #e kemi ruajtur n-in e dhene nga perdoruesi tek adresa e n

    la $a0, array 
    lw $a1, n    
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
    la $a0, shtypElem   #printohet shtypElem
    syscall

    li $t1, 0

    loop: 
        beq $t1, $s1, endloop
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
    addi $s1, $s1, -1

    li $t0, 0 #t0 eshte p
    
    loop1: 
        beq $t0, $s1, endloop1
        
        li $t3, 4
        mul $t4, $t0, $t3
        add $t5, $s0, $t4 #adresen e array po e inkrementojme per vleren e $t4, e cila eshte p * 4

        lw $t1, 0($t5) #$t1 --> min = a[p]
        move $s6, $t1  #a[p]
        
        move $t2, $t0 #loc = p
        move $a2, $t0 #e dergojme p si parameter

        jal unazavlerave

        move $t8, $s6   #temp = a[p]
        
        li $t3, 4
        mul $t4, $t0, $t3 #$t3 e kemi deklaru ma nalt si 4, se na duhet per me nxjerr elemente nga array(si shumefisha te 4)
        add $t5, $s0, $t4 #qeshtu e inkrementojme adresen per casjen e elementeve te array
        sw $t1, 0($t5)  #a[p] = a[loc]  ose  a[p] = min se loc po na tregon indeksin ku eshte gjet ajo minimalja
                        # dmth $t1 eshte a[loc] ne kete pike

        mul $t4, $t2, $t3
        add $t5, $s0, $t4 #loc si shumefish i 4
        sw $t8, 0($t5) #a[loc] = temp

        addi $t0, $t0, 1
        j loop1

    endloop1:
        la $a0, array
        move $s0, $a0
        lw $t0, n
        li $t1, 0
        
        li $v0, 4
        la $a0, vleratEvekt  #text print
        syscall
        
    print:
        beq $t1, $t0, backHOME
        
        li $v0, 1
        lw $a0, 0($s0)
        syscall
        
        li $v0, 4
        la $a0, endl 
        syscall

        addi $s0, $s0, 4
        addi $t1, $t1, 1
        j print
    backHOME:
    lw $ra, 0($sp) #po e rikthejme adresen kthyese te ketij funksioni nga stack-u
    addi $sp, $sp, 4
    jr $ra


unazavlerave:
    move $s3, $a0 #adresa e array
    move $s4, $a1 #n 
    move $s5, $a2 #p
    # $t1 eshte min
    # $t2 eshte loc

    addi $t6, $s5, 0 #p + 1 = k

    loop2:
        beq $t6, $s4, endloop2   # $t6 eshte k, $s4 eshte n
        
        li $t3, 4
        mul $t4, $t6, $t3 # k * 4
        add $t5, $s3, $t4   # offset
        lw $t7, 0($t5)  # a[k]

        blt $t1, $t7, pass  # if min>a[k]
            move $t1, $t7   # min = a[k]
            move $t2, $t6   # loc = k
        
        pass:
            addi $t6, $t6, 1 # po edhe nese nuk gjindet su bo nomi, kalojm ne iterimin tjt
            j loop2
    endloop2:
        jr $ra
    











