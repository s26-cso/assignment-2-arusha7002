.text
.globl make_node

make_node:
    addi sp, sp, -16    #allocation of stack like we do for all functions to store the return address and also to store fp
    sd ra, 8(sp)
    sd s0, 0(sp)
    mv s0, x10  #saving the first argument passed
    li x10, 24
    call malloc #creating node
    sw s0, 0(x10)   #node is malloced
    sd x0, 8(x10)   #leftchild initalised to null
    sd x0, 16(x10)  #rightchild initialised to null as well

    #restore stack now because we have to return the pointer to this node that weve created
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret #x10 already has return value that is the pointer to the node we malloced

.globl get

get:
    #base case
    beq x10, x0, retNull
    lw t0, 0(x10)  #loading the current root's int value into temp (root keeps chainging because of recursion)
    beq x11, t0, foundval   #if root->val == val
    blt x11, t0, left   #if val<root->val

    right:
    ld x10, 16(x10) #now we make root = root->right and call the same function on root again
    call get
    ret

    left:
    ld x10, 8(x10)  #now we make root = root->left and call the same function on root again
    call get
    ret

    foundval:   #here we're coming after the root->val == val condition is met and we simply return pointer to this node
    ret

    retNull:
    mv x10, x0  #node with reqd val wasnt found so we return null pointer
    ret

.globl insert

insert:

    addi sp, sp, -32    #allocation of stack like we do for all functions to store the return address and also to store fp
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    mv s1, x11 #saving the og value to be inserted 
    beq x10, x0, newnode    #we have reached in recursion to a node with no children and can now add the reqd value node as a child to this node without breaking bst properties
    mv s0, x10  #save the root in each recursion as in backtracking we need it to propagate upwards
    lw t0, 0(x10)    #temp reg holds the value of the root node
    blt x11, t0, leftinsert

    rightinsert:
    ld t1, 16(x10) #we'll go to right subtree to search for a place to insert according to bst properties
    mv x10, t1  #now for next recursion call, the right child of current root is root itself
    mv x11, s1
    call insert
    sd x10, 16(s0)  #here after recursion, in backtracking we're just saving the new updated tree's root with the new node
    mv x10, s0  #for returning the pointer to root of modified tree
    j end 

    leftinsert:
    ld t1, 8(x10) #we'll go to left subtree to search for a place to insert according to bst properties
    mv x10, t1  #now for next recursion call, the left child of current root is root itself
    mv x11, s1  #restoring the value that needs to be passed to recursion
    call insert
    sd x10, 8(s0)  #here after recursion, in backtracking we're just saving the new updated tree's root with the new node
    mv x10, s0  #returning the pointer to root of modified tree
    j end

    newnode:
    mv x10, x11
    call make_node

    end:
    #restore stack and fp and get back og return address
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret
    
.globl getAtMost

getAtMost:
    #iterative version of like predecessor finding

    lw t0, -1 #this is the variable predecessor
    loop:
        beq x11, x0, done
        lw t1, 0(x11)
        beq t1, x10, match
        blt t1, x10, rightbranch    #we go right as root value is less than given val so given's pred will lie in right subtree
        ld x11, 8(x11)  #go make root as root->left
        j loop

        rightbranch:
        mv t0, t1
        ld x11, 16(x11) #check if an even greater pred of given value exists
        j loop

        match:
        mv x10, t1
        ret

    done:
    mv x10, t0
    ret






