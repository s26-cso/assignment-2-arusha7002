.bss    #arrays needed for code
a: .space 400000
stack: .space 400000
ans: .space 400000

.data
fmt: .string "%d "

.text 
.globl main

main:
	mv s2, x11   # save argv
    addi s0, x10, -1    #basically x10 has number of arguments passed and the zeroeth one is always prog name so we have to remove one from the count to get the actual number of array elemts
    li s1, -1   #int top = -1
    li t0, 0    #int i = 0

    createArrayOfInt:
        bge t0, s0, arraydone   #when i>=number of array elemts, break out of loop
        addi t1, t0, 1
        slli t1, t1, 3  #as this is a pointer variable which has size=8 not 4
        add t2, s2, t1
        ld t3, 0(t2)    #basically the argument array, say arg, st: arg[i+1] = t3
        mv x10, t3
        call atoi   #all args are actually strings this converst them to int and returns the int in x10
        slli t4, t0, 2  #i*4 as actually the size of each array blok is of int which is 4
        la t5, a #t5 has base address of array 'a'
        add t5, t5, t4
        sw x10, 0(t5)
        addi t0, t0, 1
        j createArrayOfInt
    
    arraydone:
        li t0, 0    #again this is int i = 0

        loopForInitRes:
            bge t0, s0, doneinitialising
            slli t1, t0, 2   #i*4 again 
            la t2, ans  #t1 stores base address of array 'ans'
            add t2, t2, t1
            li t3, -1
            sw t3, 0(t2)
            addi t0, t0, 1
            j loopForInitRes

        doneinitialising:

        addi t0, s0, -1 #int i = n-1 as the main loop in nge runs right to left

        nge:
            blt t0, x0, printloop
            innerwhile:
                blt s1, x0, whiledone   #if top<0 then break out of while loop or stop popping basically
                
                slli t1, s1, 2  #top*4
                la t2, stack    #t2 has base address of stack
                add t2, t2, t1
                lw t3, 0(t2)    #now t3 = stack[top]

                slli t4, t3, 2
                la t5, a 
                add t5, t5, t4
                lw  t6, 0(t5)   # t6 = arr[stack[top]]

                slli t2, t0, 2
                la t3, a 
                add t3, t3, t2
                lw t4, 0(t3)    # t9 = arr[i]

                #here we decide if we need to pop elements from stack and when we should stop
                bge t4, t6, pop #because now descending stack isnt maintained
                j whiledone

                pop:
                    addi s1, s1, -1 #top--
                    j innerwhile


            whiledone:
                blt s1, x0, minusOne

                slli t1, s1, 2  #top*4
                la t2, stack    #base address of stack at t2
                add t2, t2, t1
                lw t3, 0(t2)    # t3 = stack[top]

                slli t4, t0, 2  #i*4
                la t5, ans  #base address of ans is at t5
                add t5, t5, t4
                sw t3, 0(t5)
                j pushing

                minusOne:

		slli t4, t0, 2
    		la t5, ans
    		add t5, t5, t4
    		li t6, -1
    		sw t6, 0(t5)

                pushing:
                addi s1, s1, 1  #top++
                slli t1, s1, 2  #top*4
                la t2, stack
                add t2, t2, t1
                sw t0, 0(t2)

                addi t0, t0, -1

                j nge

    li t0, 0    #int i = 0

    printloop: 
        bge t0, s0, finishedprint

        slli t1, t0, 2  #i*4
        la t2, ans
        add t2, t2, t1
        lw t3, 0(t2)

        la x10, fmt     # first arg: format string
        mv x11, t3      # second arg: value
        call printf
        addi t0, t0, 1
        j printloop

    finishedprint:
    li x10, 0
    ret

























