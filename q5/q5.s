.data

filename: .string "input.txt"
mode: .string "r"

ispalin: .string "Yes\n"
notpalin: .string "No\n"

char1: .space 1
char2: .space 1

.text
.globl main
main:
    la x10, filename    #address of file like when we do file* f of stored in x10
    la x11, mode    #mode in which file is opened ie read mode is stored in x11
    call fopen  #to open file
    mv s0, x10  #now s0 has address of file

    #we need file size so:

    mv x10, s0
    li x11, 0
    li x12, 2   #this is like SEEK_END
    call fseek

    #now we do the ftell(f)

    mv x10, s0
    call ftell

    mv s1, x10  #now s1 stores file size which  is basically input word length so we can initialise right and left pointers 

    li s2, 0    #left = 0 this is left pointer
    addi s3, s1, -1 #right = n-1 this is right pointer

    whileloop:
        bge s2, s3, isapalindrome

        #now we read left character from file into a register using fseek

        mv x10, s0
        mv x11, s2
        li x12, 0
        call fseek

        #fread part:
        la x10, char1
        li x11, 1
        li x12, 1
        mv x13, s0
        call fread

        #similairly now we read a right character

        mv x10, s0
        mv x11, s3
        li x12, 0
        call fseek

        #fread part:

        la x10, char2
        li x11, 1
        li x12, 1
        mv x13, s0
        call fread

        #now we do comparison of left char and right char at saem relative postion from both ends of the file
        #if the characters char1 and char2 are same then we continue checking otherwise it's not a palindrome

        lb t0, char1    #t0 contains char on left
        lb t1, char2    #t1 contains char on right

        bne t0, t1, notapalindrome

        addi s2, s2, 1  #left++
        addi s3, s3, -1 #right--
        j whileloop

    notapalindrome: #basically we;re loading the No string and printing it
        la x10, notpalin
        call printf
        j done

    isapalindrome:  #basically we;re loading the Yes string and printing it
        la x10, ispalin
        call printf
        j done

    done:
        li x10, 0 
        ret



