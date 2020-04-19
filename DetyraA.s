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
    la $a1, n
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
    
    sw $v0, 0($s1)                # n e dhene nga perdoruesi e ruajme te adresa e n pra $a1

    move $s1, $v0                 # n e dhene nga inputi e vendosim edhe ne $s1

    li $v0, 4
    la $a0, endl                  # rresht i ri
    syscall

    li $v0, 4
    la $a0, shtypElem             # printohet shtypElem
    syscall

#-------------------------------------------------------------------------------
    li $t1, 1                     # int i = 1
    ruaj: 
        bgt $t1, $s1, gotoMain    # $t1 eshte i, ndersa $s1 eshte n (for loop)

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
    addi $sp, $sp, -4             # po e lirojme nje hapesire 32-biteshe ne stack pointer sepse kemi me e ruajt adresen kthyese $ra qe eshte 32bit
    sw $ra, 0($sp)                # adresen kthyese te ketij funksioni e ruajme ne stack

    move $s0, $a0                 # array
    move $s1, $a1                 # vlera e n
    addi $s1, $s1, -1

#-------------------------------------------------------------------------------
    li $t0, 0                     # t0 eshte p e for loop-it
    loop: 
        beq $t0, $s1, endloop
        
        mul $t3, $t0, 4
        add $t5, $s0, $t3         # adresen baze te vektorit po e inkrementojme per vleren e $t4(p * 4), sepse adresat e elementeve ne array duhet te jene shumefish i 4

        lw $t1, 0($t5)            # $t1 --> min = a[p]. $t5 paraqet adresen e vleres qe kemi me e marr nga vektori
        move $s6, $t1             # a[p]
        
        move $a2, $t0             # e dergojme p si parameter
        move $t2, $t0             # loc = p

        jal unazavlerave                                                                                                    # |LOOP FOR PASS

        move $t6, $s6             # temp = a[p]
        
        mul $t4, $t0, 4           # $t3 e kemi deklaru ma nalt si 4, se na duhet per me nxjerr elemente nga array(si shumefisha te 4)
        add $t5, $s0, $t4         # e inkrementojme adresen baze te vektorit per vleren e $t4 e cila eshte p*4
        sw $t1, 0($t5)            # a[p] = a[loc]  ose  thene ndryshe ne a[p] po e ruajme minimumin e rezultuar nga funksioni unazaVlerave
                                  # dmth $t1 eshte a[loc] ne kete pike

        mul $t3, $t2, 4
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
        
        mul $t3, $t7, 4         # k * 4
        add $t5, $s2, $t3         # inkrementohet adresa baze e vektorit dhe kjo velere ($t5) paraqet adresen e sakte per elementin qe duam t'i qasemi
        lw $t6, 0($t5)            # a[k]

        blt $t1, $t6, goto        # if min>a[k]
            move $t1, $t6         # min = a[k]
            move $t2, $t7         # loc = k
        
        goto:
            addi $t7, $t7, 1      # po edhe nese nuk gjindet su bo nomi, kalojm ne iterimin tjt
            j loop2

    endloop2:
        jr $ra
    











