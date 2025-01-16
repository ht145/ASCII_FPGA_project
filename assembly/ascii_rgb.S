/*///////////////////////////////////////////////////////////////////////////////////////////////////////
//	ASCII_Art: ascii_rgb.S
//
//    In this program, using the left and right push buttonsb to modify the rgb control register values:
//        -	Read the push button state 
//            -	pressing the left/down buttons will increase or decrease the value in the reg by one value
//           

*///////////////////////////////////////////////////////////////////////////////////////////////////////

// primary constant register in the program
# s0    holds Push Button address
# s2    holds address to the column position register
# s3    holds the push button current state
# s5    shift left right counter
# a1    passes delay time to the Delay subroutine

// Defines 
#define PBTN_ADDR           0x80001500      // address to the push buttons
#define COLUMN_ADDR         0x80001508      // address to the column position register

// Masks for the Buttons
#define BTNC                0x01            
#define BTNU                0x02
#define BTNL                0x04
#define BTNR                0x08
#define BTND                0x10                     

#define Delay_50ms          0x00006432      // delay time ~ 50 ms
#define Delay_L             0x01FD7840      // long delay
#define Delay_M             0x000F7840      // medium delay

.global main
main:
    li      s0, PBTN_ADDR       # loading the base address of the memory mappped GPIO registers
    li      s2, COLUMN_ADDR     # loading the Column register address
    li      s5, 0               # loading 8 to s5, the column register
    sw      s5, 0(s2)           # updating the column position register

   
// go into the repeat loop to wait for an input from the user    
repeat:

    li      a1, Delay_M         # setting the delay parameter to about 1 second
    jal     DELAY               # Delay to let the bouncing of the switch settle
    lw      s3, 0(s0)           # updating the current register after the delay, should be stable by now


B_RIGHT:
    andi    t1, s3, BTNR        # getting the state of BTND
    addi    t0, zero, BTNR      # setting termorrary varaiable to BTND mask
    bne     t0, t1, B_LEFT      # branch if BTND is not pressed
    // check if s5 > 64
    addi    t0, zero, 64
    bge     s5, t0, B_LEFT      # branch if colum counter is less than 8
    addi    s5, s5, 1           # increase by 4
    sw      s5,0(s2)            # updating the row register

B_LEFT:
    andi    t1, s3, BTNL        # getting the state of BTNL
    addi    t0, zero, BTNL      # setting termorrary varaiable to BTNL mask
    bne     t0, t1, E1     # branch if BTNL is not pressed
    // check if s > 0
    addi    t0, zero, 0
    blt     s5, t0, D1     # branch if colum counter is less than 8
    addi    s5, s5, -1          # reduce by 4
    sw      s5,0(s2)            # updating the column register
E1

    j       repeat

DELAY: # Delay subrouting                             
    add     t2, zero, zero      # resetting the counter for the delay
D1:
    addi    t2, t2, 1           # counting up the t2 register     
    bne     a1, t2, D1          # checking if t2 != delay time. if true branch to DEALY
    jr      ra                  # jump back

.end