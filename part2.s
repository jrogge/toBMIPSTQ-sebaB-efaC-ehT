# syscall constants
PRINT_STRING	= 4
PRINT_CHAR	= 11
PRINT_INT	= 1

# memory-mapped I/O
VELOCITY	= 0xffff0010
ANGLE		= 0xffff0014
ANGLE_CONTROL	= 0xffff0018

BOT_X		= 0xffff0020
BOT_Y		= 0xffff0024

TIMER		= 0xffff001c

REQUEST_JETSTREAM	= 0xffff00dc
REQUEST_STARCOIN	= 0xffff00e0

PRINT_INT_ADDR		= 0xffff0080
PRINT_FLOAT_ADDR	= 0xffff0084
PRINT_HEX_ADDR		= 0xffff0088

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

REQUEST_STARCOIN_INT_MASK	= 0x4000
REQUEST_STARCOIN_ACK		= 0xffff00e4

.data
three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0

.align 2
event_horizon_data: .space 90000

ping_starcoins: .space 1
starcoins_ready: .space 1

.align 4
points_x: .space 4
points_y: .space 4
starcoins_map: .space 512

.text
main:

        sub     $sp, $sp, 36
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s6, 28($sp)
        sw      $s7, 32($sp)

        # init
init:
	# enable interrupts
        li	$t0, TIMER_MASK		# timer interrupt enable bit
        or	$t0, $t0, BONK_MASK	# bonk interrupt bit
        or      $t0, $t0, REQUEST_STARCOIN_INT_MASK
        or	$t0, $t0, 1		# global interrupt enable
        mtc0	$t0, $12		# set interrupt mask (Status register)

        la      $s2, event_horizon_data
        sw      $s2, REQUEST_JETSTREAM  # $s2 = &map
        
	lw	$t0, TIMER		# read current time
	add	$t0, $t0, 50		# add 50 to current time
	sw	$t0, TIMER		# request timer interrupt in 50 cycles

        la      $s5, starcoins_map      # $s5 = &starcoins_map

        la      $s6, ping_starcoins     # $s6 = ping_starcoins
        li      $t0, 0
        sb      $t0, 0($s6)             # set ping_starcoins to false as we just requested them

        la      $s6, ping_starcoins     # $s6 = ping_starcoins
        la      $s7, starcoins_ready    # $s7 = starcoins_ready
        sb      $0, 0($s7)              # set starcoins_ready to false

        lw      $s0, BOT_X              # $s0 = x
        lw      $s1, BOT_Y              # $s1 = y

        #TODO
        li      $t0, 10                 # set velocity
        sw      $t0, VELOCITY

init_direction:
        # === start in a valid angle for given quadrant ===
        li      $t0, 149
        ble     $s0, $t0, x_n
        # if x > 149

        ble     $s1, $t0, x_p_y_n
        # if y > 149
        li      $t0, 180
        sw      $t0, ANGLE
        li      $t1, 1
        sw      $t1, ANGLE_CONTROL

        li      $s3, -1
        li      $s4, 0
        j       main_loop

x_p_y_n:
        # if y <= 149
        li      $t1, 90
        sw      $t1, ANGLE
        li      $t1, 1
        sw      $t1, ANGLE_CONTROL

        li      $s3, 0
        li      $s4, 1
        j       main_loop

x_n:
        # if x <= 149
        
        ble     $s1, $t0, x_n_y_n
        # if y > 149
        li      $t1, 270
        sw      $t1, ANGLE
        li      $t1, 1
        sw      $t1, ANGLE_CONTROL

        li      $s3, 0
        li      $s4, -1
        j       main_loop

x_n_y_n:
        # if y <= 149
        li      $t1, 0
        sw      $t1, ANGLE
        li      $t1, 1
        sw      $t1, ANGLE_CONTROL

        li      $s3, 1
        li      $s4, 0
        
main_loop:
	# note that we infinite loop to avoid stopping the simulation early
        lw      $t6, BOT_X              # x
        lw      $t7, BOT_Y              # y

        lb      $t0, 0($s7)             # if starcoins_ready
        bne     $t0, $0, get_starcoins  # go get them

        lb      $t0, 0($s6)             # if ping_starcoins
        beq     $t0, $0, skip_ping
        sw      $s5, REQUEST_STARCOIN   # request starcoins
        sb      $0,  0($s6)             # set ping_starcoins to false

skip_ping:
        # if x or y has changed
        sne     $t0, $t6, $s0
        sne     $t1, $t7, $s1
        or      $t0, $t0, $t1
        beq     $t0, $0, main_loop

        lw      $s0, BOT_X              # x
        lw      $s1, BOT_Y              # y

        # read x + x vector, y + y vector
        add     $t0, $s1, $s4           # y + y-vector - old implementation
        mul     $t0, $t0, 300
        add     $t0, $t0, $s2           # &map[y + y-vector]
        add     $t1, $s0, $s3           # x + x-vector
        add     $t0, $t0, $t1           # &map[y + y-vector][x + x-vector]
        lbu     $t0, 0($t0)             # map[y + y-vector][x + x-vector]
        beq     $t0, 2, main_loop
        jal     hit_edge
	j	main_loop

hit_edge:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)
        jal     determine_edge
        bne     $v0, $0, inner
        # fall through to outer edge
        li      $t0, 45         # rotate 45 clockwise
        sw      $t0, ANGLE
        li      $t0, 0
        sw      $t0, ANGLE_CONTROL

        sub     $t0, $s3, $s4   # temp = x - y
        add     $s4, $s4, $s3   # y = y + x
        move    $s3, $t0        # x = x - y

        j       end_hit_edge
inner:
        li      $t0, -45        # rotate 45 counter-clockwise
        sw      $t0, ANGLE
        li      $t0, 0
        sw      $t0, ANGLE_CONTROL

        add     $t0, $s3, $s4   # temp = x + y
        sub     $s4, $s4, $s3   # y = y - x
        move    $s3, $t0        # x = x + y

        j       end_hit_edge
end_hit_edge:
        # handle edge cases of addition
        bge     $s3, -1, x_2
        li      $s3, -1
x_2:
        ble     $s3, 1, y_n2
        li      $s3, 1
y_n2:
        bge     $s4, -1, y_2
        li      $s4, -1
y_2:
        ble     $s4, 1, valid_vectors
        li      $s4, 1

valid_vectors:
        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra

determine_quad:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)

        lw      $s0, BOT_X              # x
        lw      $s1, BOT_Y              # y

        li      $t9, 149
        ble     $s0, $t9, x_neg
        # if x > 149
        ble     $s1, $t9, x_pos_y_neg
        # if y > 149
        li      $v0, 1          # quad = 1
        j       end_determine_quad
x_pos_y_neg:
        # if y <= 149
        li      $v0, 4          # quad = 4
        j       end_determine_quad
x_neg:
        # if x <= 149
        ble     $s1, $t9, x_neg_y_neg
        # if y > 149
        li      $v0, 2          # quad = 2
        j       end_determine_quad
x_neg_y_neg:
        # if y <= 149
        li      $v0, 3          # quad = 3
        # fall through to end_determine_quad
end_determine_quad:
        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra

check_is_inner: # returns whether or not the point is on the inner edge
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)

        jal     get_value       # point A that would be outside for inner edge
        move    $t0, $v0

        move    $a0, $a2
        move    $a1, $a3
        jal     get_value       # point B that would be outside for inner edge
        move    $t1, $v0

        seq     $t0, $t0, 1
        seq     $t1, $t1, 1
        and     $v0, $t0, $t1   # return <right out of js> & <left out of js>

        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra

get_value: # returns the value of jetstream at specified coord
        sub     $sp, $sp, 4
        sw      $s2, 0($sp)
        la      $s2, event_horizon_data
        mul     $a1, $a1, 300
        add     $a1, $s2, $a1   # &map[y]
        add     $a0, $a0, $a1   # &map[y][x]
        lbu     $v0, 0($a0)     # return map[y][x]
        lw      $s2, 0($sp)
        add     $sp, $sp, 4
        jr      $ra

determine_edge:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)

        lw      $s0, BOT_X              # x
        lw      $s1, BOT_Y              # y

        jal     determine_quad
        beq     $v0, 2, edge_quad_2
        beq     $v0, 3, edge_quad_3
        beq     $v0, 4, edge_quad_4

        # quad I, x > 0, y > 0
        # load x1 param
        add     $a0, $s0, $s3   # x + x-vector
        sub     $a0, $a0, 1     # to the left of prediction

        # load y1 param
        add     $a1, $s1, $s4   # y + y-vector

        # load x2 param
        add     $a2, $s0, $s3

        # load y2 param
        add     $a3, $s1, $s4
        sub     $a3, $a3, 1     # above prediction
        j       end_determine_edge

edge_quad_2:
        # quad II, x < 0, y > 0

        # load x1 param
        add     $a0, $s0, $s3   # x + x-vector
        add     $a0, $a0, 1     # to the right of prediction

        # load y1 param
        add     $a1, $s1, $s4

        # load x2 param
        add     $a2, $s0, $s3   # x + x-vector

        # load y2 param
        add     $a3, $s1, $s4
        sub     $a3, $a3, 1     # above prediction

        j       end_determine_edge

edge_quad_3:
        # quad III, x < 0, y < 0

        # load x1 param
        add     $a0, $s0, $s3   # x + x-vector
        add     $a0, $a0, 1     # to the right of prediction

        # load y1 param
        add     $a1, $s1, $s4

        # load x2 param
        add     $a2, $s0, $s3   # x + x-vector

        # load y2 param
        add     $a3, $s1, $s4
        add     $a3, $a3, 1     # below prediction

        j       end_determine_edge

edge_quad_4:
        # quad IV, x > 0, y < 0
        # load x1 param
        add     $a0, $s0, $s3   # x + x-vector
        sub     $a0, $a0, 1     # to the left of prediction

        # load y1 param
        add     $a1, $s1, $s4

        # load x2 param
        add     $a2, $s0, $s3   # x + x-vector

        # load y2 param
        add     $a3, $s1, $s4
        add     $a1, $a1, 1     # below prediction

        # fall through to end-determine_edge
end_determine_edge:
        jal     check_is_inner

        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra
       
# --- goes and grabs a star then puts the 
get_starcoins:
        sub     $sp, $sp, 36
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s7, 28($sp)
        sw      $s8, 32($sp)
        
        lw      $s7, BOT_X              # $s7 = x
        lw      $s8, BOT_Y              # $s8 = y

        la      $s5, starcoins_map
        jal     determine_quad
        move    $s0, $v0
        
        li      $s1, 0          # curr_idx = 0
get_sc_loop:
        mul     $t0, $s1, 4     
        add     $t0, $t0, $s5   # &starcoins_map[curr_idx]
        lw      $s2, 0($t0)     # starcoins_map[curr_idx]
        beq     $s2, 0xFFFFFFFF, end_get_sc

        srl     $s3, $s2, 16            # $s3 = x
        and     $s4, $s2, 0x0000FFFF    # $s4 = y

        add     $s1, $s1, 1     # cur_idx++
        beq     $s0, 2, get_sc_quad_2
        beq     $s0, 3, get_sc_quad_3
        beq     $s0, 4, get_sc_quad_4
        # if we're in quad 1, take x > cx
        blt     $s3, $s7, get_sc_loop   # if x >= botX
        #bgt     $s4, $s8, get_sc_loop   # if y <= botY
        j       get_sc_retrieve
get_sc_quad_2:
        # if we're in quad 2, take y > cy
        #blt     $s3, $s7, get_sc_loop   # if x <= botX
        blt     $s4, $s8, get_sc_loop   # if y >= botY
        j       get_sc_retrieve
get_sc_quad_3:
        # if we're in quad 3, take x < cx
        bgt     $s3, $s7, get_sc_loop   # if x <= botX
        #blt     $s4, $s8, get_sc_loop   # if y >= botY
        j       get_sc_retrieve
get_sc_quad_4:
        # if we're in quad 4, take y < cy
        #bgt     $s3, $s7, get_sc_loop   # if x <= botX
        bgt     $s4, $s8, get_sc_loop   # if y <= botY
get_sc_retrieve:
        # go get the star
        move    $a0, $s3
        move    $a1, $s4
        jal     go_to
        #TODO
        # if you've left the jetstream,
        # and come straight home mister
        move    $a0, $s7
        move    $a1, $s8
        jal     go_to
end_get_sc:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        lw      $s7, 28($sp)
        lw      $s8, 32($sp)
        add     $sp, $sp, 36

#        la      $t0, ping_starcoins
#        li      $t1, 1
#        sb      $t1, 0($t0)
        la      $t0, starcoins_ready
        sb      $0, starcoins_ready
        j       init_direction

# --- sets our boy flying off to a specified point ---
# $a0 = destX
# #a1 = destY
# no return value, set angle within funct
point_to:
        sub     $sp, $sp, 16
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)

        lw      $s0, BOT_X              # $s0 = x
        lw      $s1, BOT_Y              # $s1 = y

        sub     $s0, $a0, $s0           # $s0 = deltaX
        sub     $s1, $a1, $s1           # $s1 = deltaY

        # make sure we don't divide by 0
        bne     $s0, $0, valid_quotient # if deltaX == 0
        blt     $s1, $0, point_up       # if deltaY > 0
        li      $s2, 90                 # set angle = 90
        j       end_point
point_up:
        li      $s2, 270                # else set angle = 270
        j       end_point
valid_quotient:
        move    $a0, $s0
        move    $a1, $s1
        jal     sb_arctan               # get alpha
        move    $s2, $v0                # angle = alpha
end_point:
        sw      $s2, ANGLE
        li      $t0, 1
        sw      $t0, ANGLE_CONTROL
        
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        add     $sp, $sp, 16
        jr      $ra

# -----------------------------------------------------------------------
# go_to takes control of the SPIMBot and moves it to the specified point
# $a0 - x
# $a1 - y
# -----------------------------------------------------------------------
go_to:
        sub     $sp, $sp, 20
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)

        move    $s0, $a0
        move    $s1, $a1

        lw      $s2, BOT_X              # $s2 = x
        lw      $s3, BOT_Y              # $s3 = y
go_to_loop: 
        lw      $t0, BOT_X              # $t0 = x
        lw      $t1, BOT_Y              # $t1 = y
        sne     $t0, $s2, $t0
        sne     $t1, $s3, $t1
        or      $t0, $t0, $t1
        beq     $t0, $0, go_to_loop     # if x or y has changed

        lw      $s2, BOT_X              # $s2 = x
        lw      $s3, BOT_Y              # $s3 = y

        seq     $t0, $s2, $s0
        seq     $t1, $s3, $s1
        and     $t0, $t0, $t1
        bne     $t0, $0, end_go_to      # if x!=destX && y != destY

        move    $a0, $s0
        move    $a1, $s1
        jal     point_to
        j       go_to_loop
end_go_to:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        add     $sp, $sp, 20
        jr      $ra

# -----------------------------------------------------------------------
# sb_arctan - computes the arctangent of y / x
# $a0 - x
# $a1 - y
# returns the arctangent
# -----------------------------------------------------------------------

sb_arctan:
	li	$v0, 0		# angle = 0;

	abs	$t0, $a0	# get absolute values
	abs	$t1, $a1
	ble	$t1, $t0, no_TURN_90	  

	## if (abs(y) > abs(x)) { rotate 90 degrees }
	move	$t0, $a1	# int temp = y;
	neg	$a1, $a0	# y = -x;      
	move	$a0, $t0	# x = temp;    
	li	$v0, 90		# angle = 90;  

no_TURN_90:
	bgez	$a0, pos_x 	# skip if (x >= 0)

	## if (x < 0) 
	add	$v0, $v0, 180	# angle += 180;

pos_x:
	mtc1	$a0, $f0
	mtc1	$a1, $f1
	cvt.s.w $f0, $f0	# convert from ints to floats
	cvt.s.w $f1, $f1
	
	div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

	mul.s	$f1, $f0, $f0	# v^^2
	mul.s	$f2, $f1, $f0	# v^^3
	l.s	$f3, three	# load 3.0
	div.s 	$f3, $f2, $f3	# v^^3/3
	sub.s	$f6, $f0, $f3	# v - v^^3/3

	mul.s	$f4, $f1, $f2	# v^^5
	l.s	$f5, five	# load 5.0
	div.s 	$f5, $f4, $f5	# v^^5/5
	add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

	l.s	$f8, PI		# load PI
	div.s	$f6, $f6, $f8	# value / PI
	l.s	$f7, F180	# load 180.0
	mul.s	$f6, $f6, $f7	# 180.0 * value / PI

	cvt.w.s $f6, $f6	# convert "delta" back to integer
	mfc1	$t0, $f6
	add	$v0, $v0, $t0	# angle += delta

	jr 	$ra


# === Interrupt Handler ===
.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 16	# space for four registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"

.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     

	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                
	and	$a0, $a0, 0xf		# ExcCode field                            
	bne	$a0, 0, non_intrpt         

interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, BONK_MASK	# is there a bonk interrupt?                
	bne	$a0, 0, bonk_interrupt   

	and	$a0, $k0, TIMER_MASK	# is there a timer interrupt?
	bne	$a0, 0, timer_interrupt

        and     $a0, $k0, REQUEST_STARCOIN_INT_MASK
        bne     $a0, 0, star_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

star_interrupt:
        sw      $a1, REQUEST_STARCOIN_ACK       # acknowledge starcoin
	la	$k0, chunkIH
        sw      $t0, 8($k0)
        sw      $s7, 12($k0)

        la      $s7, starcoins_ready    # $s7 = starcoins_ready

        li      $t0, 1
        sb      $t0, 0($s7)                     # set starcoins_ready to true
        lw      $t0, 8($k0)
        lw      $s7, 12($k0)
        j       interrupt_handler               # go back to handler

bonk_interrupt:
      sw      $a1, 0xffff0060($zero)   # acknowledge interrupt

      li      $a1, 0                  #  ??
      lw      $a0, 0xffff001c($zero)   # what
      j       interrupt_dispatch       # see if other interrupts are waiting
      
timer_interrupt:
	sw	$a1, TIMER_ACK		# acknowledge interrupt
	la	$k0, chunkIH
        sw      $t0, 8($k0)
        sw      $v0, 12($k0)

	lw	$v0, TIMER		# current time
	add	$v0, $v0, 50000  
	sw	$v0, TIMER		# request timer in 50000 cycles

        #TODO: request starcoins every so often
        la      $t0, ping_starcoins
        li      $v0, 1
        sb      $v0, 0($t0)

        lw      $t0, 8($k0)
        lw      $v0, 12($k0)
	j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
	li	$v0, PRINT_STRING
	la	$a0, non_intrpt_str
	syscall				# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret
