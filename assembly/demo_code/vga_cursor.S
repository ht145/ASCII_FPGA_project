/*///////////////////////////////////////////////////////////////////////////////////////////////////////
//	HW_LAB_4.B: vga_cursor.S
//
//    In this program, using the push buttons & VGA Dispaly we can do the following on Nexys A7 Dev board:
//        -	Read the push button state 
//            -	pressing the left/right buttons will move the cursor left or right 
//            -	pressing the up/down buttons will move the cursor up or down
//            -    
//
//    Author          : Abhijeet Prem
//    Last modified   : 11/7/22
//	
//	Demo link: https://drive.google.com/file/d/1RrEO0KSTgVcdhyH_ufcC-GOlZXnN32Ys/view?usp=share_link
//
//    Stretch goals:
//        - Button debounce
//        - timmer based delay
//  
*///////////////////////////////////////////////////////////////////////////////////////////////////////

// primary constant register in the program
# s0    holds Push Button address
# s1    holds address to the row position register
# s2    holds address to the column position register
# s3    holds the push button current state
# s4    shift left right counter
# s5    counter reg for up and down
# a1    passes delay time to the Delay subroutine

// Defines 
#define PBTN_ADDR           0x80001500      // address to the push buttons
#define ROW_ADDR            0x80001504      // address to the row position register
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
    li      s1, ROW_ADDR        # loading the Row Register address
    li      s2, COLUMN_ADDR     # loading the Column register address
    li      s4, 8               # loading 8 to s4, the row position register
    li      s5, 0               # loading 8 to s5, the column register
    sw      s4, 0(s1)           # updating the row position register
    sw      s5, 0(s2)           # updating the column position register
// blue
    li      s5, 3               # loading 8 to s5, the column register
    sw      s5, 0(s2)           # updating the column position register

// green
    li      s5, 8               # loading 8 to s5, the column register
    sw      s5, 0(s2)           # updating the column position register
// red
    li      s5, 32              # loading 8 to s5, the column register
    sw      s5, 0(s2)           # updating the column position register

   
// go into the repeat loop to wait for an input from the user    
repeat:

    li      a1, Delay_M         # setting the delay parameter to about 1 second
    jal     DELAY               # Delay to let the bouncing of the switch settle
    lw      s3, 0(s0)           # updating the current register after the delay, should be stable by now

B_UP:   
    andi    t1, s3, BTNU        # getting the state of BTNU
    addi    t0, zero, BTNU      # setting termorrary varaiable to BTNU
    bne     t0, t1, B_DOWN      # branch if BTNU is not pressed
    // check if s4 > 8
    addi    t0, zero, 8
    blt     s4, t0, B_DOWN       # branch if colum counter is less than 8
    addi    s4, s4, -4           # reduce by 4
    sw      s4,0(s1)             # updating the row register

B_DOWN:
    andi    t1, s3, BTND        # getting the state of BTND
    addi    t0, zero, BTND      # setting termorrary varaiable to BTND mask
    bne     t0, t1, B_LEFT      # branch if BTND is not pressed
    // check if s4 > 8
    addi    t0, zero, 468
    bge     s4, t0, B_LEFT      # branch if colum counter is less than 8
    addi    s4, s4, 1           # increase by 4
    sw      s4,0(s1)            # updating the row register

B_LEFT:
    andi    t1, s3, BTNL        # getting the state of BTNL
    addi    t0, zero, BTNL      # setting termorrary varaiable to BTNL mask
    bne     t0, t1, B_RIGHT     # branch if BTNL is not pressed
    // check if s > 8
    addi    t0, zero, 0
    blt     s5, t0, B_RIGHT     # branch if colum counter is less than 8
    addi    s5, s5, -1          # reduce by 4
    sw      s5,0(s2)            # updating the column register

B_RIGHT:
    andi    t1, s3, BTNR        # getting the state of BTNR
    addi    t0, zero, BTNR      # setting termorrary varaiable to BTNR mask
    bne     t0, t1, repeat      # branch if BTNR is not pressed
    // check if s4 > 8
    addi    t0, zero, 632
    bge     s5, t0, repeat      # branch if colum counter is less than 8
    addi    s5, s5, 4           # increase by 4
    sw      s5, 0(s2)           # updating the column register

    j       repeat

DELAY: # Delay subrouting                             
    add     t2, zero, zero      # resetting the counter for the delay
D1:
    addi    t2, t2, 1           # counting up the t2 register     
    bne     a1, t2, D1          # checking if t2 != delay time. if true branch to DEALY
    jr      ra                  # jump back

.end