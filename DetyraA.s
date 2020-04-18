.data
array: .space 20
n: .word 0
jepNrAnt: .asciiz "Jep numrin e anetareve te vektorit (max. 5): "
shtypElem: .asciiz "Shtyp elementet nje nga nje: \n"
vleratEvekt: .asciiz "\nVlerat e vektorit jane: \n"
endl: .asciiz "\n"

.text
    main:
    la $a0, array
    lw $a1, n
    jal populloVektorin           # thirret funksioni POPULLO VEKTORIN

    la $a0, array                 # vektorin e dergojme si parameter
    lw $a1, n                     # n si parametri i dyte
    jal unazaKalimit              # thirret funksioni UNAZA E KALIMIT

    li $v0, 10                    # mbyllet programi
    syscall

#Funksioni POPULLO VEKTORIN
populloVektorin:
    move $s0, $a0                 # vektorin po e ruajme nga parametri ne regjistrin $s0
    move $s1, $a1                 # n-in po e ruajme ne regjistrin $s1

    li $v0, 4
    la $a0, jepNrAnt
    syscall

    li $v0, 5                     # numri i anetareve i dhene nga perdoruesi
    syscall
    
    la $a2, n 
    sw $v0, 0($a2)                # n e dhene nga perdoruesi e ruajme te .data

    move $s1, $v0

    li $v0, 4
    la $a0, endl                  # rresht i ri
    syscall

    li $v0, 4
    la $a0, shtypElem             # printohet shtypElem
    syscall

#-------------------------------------------------------------------------------
    li $t1, 1                     # int i = 1
    ruaj: 
        bgt $t1, $s1, gotoMain

        li $v0, 5                 # inputi perdoruesit si numer
        syscall

        sw $v0, 0($s0)            # po e rujme ne array vleren e dhene prej perdoruesit             |MBUSHJA E VEKTORIT

        addi $s0, $s0, 4          # e inkrementojme per 4 adresen ku do ta shkruajme numrin e radhes ne array
        addi $t1, $t1, 1          # i++

        j ruaj
#-------------------------------------------------------------------------------
    gotoMain:
        jr $ra
        

#Funksioni UNAZA E KALIMIT
unazaKalimit:  
    addi $sp, $sp, -4
    sw $ra, 0($sp)                # adresen kthyese te ketij funksioni e ruajme ne stack

    move $s0, $a0                 # array
    move $s1, $a1                 # vlera e n
    addi $s1, $s1, -1

#-------------------------------------------------------------------------------
    li $t0, 0                     # t0 eshte p e for loop-it
    loop: 
        beq $t0, $s1, endloop
        
        li $t3, 4
        mul $t4, $t0, $t3
        add $t5, $s0, $t4         # adresen baze te vektorit po e inkrementojme per vleren e $t4, e cila eshte p * 4 (shumefish i katershit)

        lw $t1, 0($t5)            # $t1 --> min = a[p]
        move $s6, $t1             # a[p]
        
        move $t2, $t0             # loc = p
        move $a2, $t0             # e dergojme p si parameter

        jal unazavlerave          #                                                                |LOOP FOR PASS

        move $t6, $s6             # temp = a[p]
        
        li $t3, 4
        mul $t4, $t0, $t3         # $t3 e kemi deklaru ma nalt si 4, se na duhet per me nxjerr elemente nga array(si shumefisha te 4)
        add $t5, $s0, $t4         # e inkrementojme adresen baze per vektorin
        sw $t1, 0($t5)            # a[p] = a[loc]  ose  thene ndryshe ne a[p] po e ruajme minimumin e rezultuar nga funksioni unazaVlerave
                                  # dmth $t1 eshte a[loc] ne kete pike

        mul $t3, $t2, $t3
        add $t5, $s0, $t3         # loc si shumefish i 4, passi po i qasemi array-it
        sw $t6, 0($t5)            # a[loc] = temp

        addi $t0, $t0, 1
        j loop
#-------------------------------------------------------------------------------
    endloop:
        lw $t0, n                 # po e ruajme n-in edhe nje here ne $t0, ndersa vektorin e kemi ne $s0
  
        li $v0, 4
        la $a0, vleratEvekt       # text print
        syscall

#-------------------------------------------------------------------------------
        li $t1, 1                       #
    printoVektorin:                     #
        bgt $t1, $t0, backHOME          #
                                        #  
        li $v0, 1                       #
        lw $a0, 0($s0)                  #
        syscall                         #
                                        #       |PRINTIMI I VEKTORIT
        li $v0, 4                       #
        la $a0, endl                    #
        syscall                         #
                                        #
        addi $s0, $s0, 4                #
        addi $t1, $t1, 1                #
        j printoVektorin                #
#--------------------------------------------------------------------------------
    backHOME:
        lw $ra, 0($sp)            # po e rikthejme adresen kthyese te ketij funksioni nga stack-u
        addi $sp, $sp, 4
        jr $ra

    
#Funksioni UNAZA E VLERAVE
unazavlerave:
    move $s2, $a0                 # adresa e array
    move $s3, $a1                 # n 
    move $s4, $a2                 # p
    # $t1 eshte min
    # $t2 eshte loc
    
    addi $t7, $s4, 1              # k = p+1

    loop2:
        beq $t7, $s3, endloop2    # $t7 eshte k, $s3 eshte n
        
        li $t3, 4
        mul $t4, $t7, $t3         # k * 4
        add $t5, $s2, $t4         # offset
        lw $t6, 0($t5)            # a[k]

        blt $t1, $t6, goto        # if min>a[k]
            move $t1, $t6         # min = a[k]
            move $t2, $t7         # loc = k
        
        goto:
            addi $t7, $t7, 1      # po edhe nese nuk gjindet su bo nomi, kalojm ne iterimin tjt
            j loop2

    endloop2:
        jr $ra
    











