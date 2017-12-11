# syscall constants
PRINT_STRING = 4
PRINT_CHAR   = 11
PRINT_INT    = 1

# debug constants
PRINT_INT_ADDR   = 0xffff0080
PRINT_FLOAT_ADDR = 0xffff0084
PRINT_HEX_ADDR   = 0xffff0088

# spimbot memory-mapped I/O
VELOCITY       = 0xffff0010
ANGLE          = 0xffff0014
ANGLE_CONTROL  = 0xffff0018
BOT_X          = 0xffff0020
BOT_Y          = 0xffff0024
OTHER_BOT_X    = 0xffff00a0
OTHER_BOT_Y    = 0xffff00a4
TIMER          = 0xffff001c
SCORES_REQUEST = 0xffff1018

REQUEST_JETSTREAM	= 0xffff00dc
REQUEST_RADAR		= 0xffff00e0
BANANA			= 0xffff0040
MUSHROOM		= 0xffff0044
STARCOIN		= 0xffff0048

REQUEST_PUZZLE		= 0xffff00d0
SUBMIT_SOLUTION		= 0xffff00d4

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

REQUEST_RADAR_INT_MASK	= 0x4000
REQUEST_RADAR_ACK	= 0xffff00e4

REQUEST_PUZZLE_ACK	= 0xffff00d8
REQUEST_PUZZLE_INT_MASK	= 0x800

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
starcoins_map: .space 512

.text


main:
        #jal test
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

	# request jetstream data
        la      $s0, event_horizon_data
        sw      $s0, REQUEST_JETSTREAM  # $s0 = &map

	# set velocity = 10
	li	$t0, 1
	sw	$t0 VELOCITY

        li      $t0, 0
        sw      $t0, ANGLE
        li      $t0, 1
        sw      $t0, ANGLE_CONTROL
main_loop:
	# note that we infinite loop to avoid stopping the simulation early
	#lw      $t6, BOT_X              # x
        #lw      $t7, BOT_Y              # y

###     test mod function
        li      $a0, 361
        li      $a1, 360
        jal     mod

        li      $a0, -361
        li      $a1, 360
        jal     mod

        li      $a0, -45
        li      $a1, 360
        jal     mod

        li      $a0, 500
        li      $a1, 360
        jal     mod

	jal	standard

#        lb      $t0, 0($s7)             # if starcoins_ready
#        bne     $t0, $0, get_starcoins  # go get them
#
#        lb      $t0, 0($s6)             # if ping_starcoins
#        beq     $t0, $0, skip_ping
#        sw      $s5, REQUEST_STARCOIN   # request starcoins
#        sb      $0,  0($s6)             # set ping_starcoins to false
#
#skip_ping:
#        # if x or y has changed
#        sne     $t0, $t6, $s0
#        sne     $t1, $t7, $s1
#        or      $t0, $t0, $t1
#        beq     $t0, $0, main_loop
#
#        lw      $s0, BOT_X              # x
#        lw      $s1, BOT_Y              # y
#
#        # read x + x vector, y + y vector
#        add     $t0, $s1, $s4           # y + y-vector - old implementation
#        mul     $t0, $t0, 300
#        add     $t0, $t0, $s2           # &map[y + y-vector]
#        add     $t1, $s0, $s3           # x + x-vector
#        add     $t0, $t0, $t1           # &map[y + y-vector][x + x-vector]
#        lbu     $t0, 0($t0)             # map[y + y-vector][x + x-vector]
#        beq     $t0, 2, main_loop
#        jal     hit_edge
#	 j	 main_loop

# *===============================================================
# go_to
# takes control of the SPIMBot and moves it to the specified point
# $a0 - x
# $a1 - y
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

# ================================================================

# *===============================================================
# test 
test:
        li      $a0, 25 
        li      $a1, 100  
        jal     sb_sin
        li      $a0, -25 
        li      $a1, 100
        jal     sb_sin
        li      $a0, 140
        li      $a1, 100
        jal     sb_sin
        li      $a0, -140
        li      $a1, 100
        jal     sb_sin

# ================================================================




# *===============================================================
# mod
# $a0 = a
# $a1 = b
# returns a % b
mod:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)
        
        ble     $a0, $a1, mod_else
mod_first_while_loop:
        ble     $a0, $a1, mod_end
        sub     $a0, $a0, $a1
        j       mod_first_while_loop

mod_else:
        bge     $a0, 0, mod_end
mod_second_while_loop:
        bge     $a0, $0, mod_end
        add     $a0, $a0, $a1
        j       mod_second_while_loop
mod_end:
        move    $v0, $a0

        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra
# ================================================================

# *===============================================================
# standard 
standard:
        sub     $sp, $sp, 24 
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)

standard_main:

        lw      $t0, BOT_X      # $s2 = curr.x = bot.x
        lw      $t1, BOT_Y      # $s3 = curr.y = bot.y

        li      $a0, 0
        jal     get_probe
        move    $s0, $v0        # $s0 = p_left.x
        move    $s1, $v1        # $s1 = p_left.y
        li      $a0, 1
        jal     get_probe
        move    $s2, $v0        # $s2 = p_right.x
        move    $s3, $v1        # $s3 = p_right.y
       
        add     $s0, $s0, $s2   # $s0 = dest.x = p_left.x + p_right.x 
        srl     $s0, $s0, 1
        add     $s1, $s1, $s3   # $s1 = dest.y = p_left.y + p_right.y
        srl     $s1, $s1, 1

        move    $a0, $s0
        move    $a1, $s1
        jal     point_to
        lw      $s4, ANGLE
        j       standard_main        
standard_end:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        add     $sp, $sp, 24
        
        jr      $ra

# ================================================================

# *===============================================================
# get_probe 
# $a0 = isRight
# returns first point along 45-deg offset line that lies outside jetstream 
get_probe:
        sub     $sp, $sp, 20 
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)

probe_main:
        li      $s0, 1          # $s0 = diff = -1
        bne     $a0, 1, probe_skip_neg
        li      $s0, -1
probe_skip_neg:
        mul     $s1, $s0, 45 
        lw      $s0, ANGLE
        #add     $s1, $s1, $s0   # $s1 = angle = bot.angle + diff * 45
        add     $s1, $s1, $s0   # $s1 = angle = bot.angle + diff * 45
        ble     $s1, 360, probe_skip_mod
probe_do_mod:
        move    $a0, $s1
        li      $a1, 360
        jal     mod
        move    $s1, $v0
probe_skip_mod:
        blt     $s1, -360, probe_do_mod
        lw      $s2, BOT_X      # $s2 = curr.x = bot.x
        lw      $s3, BOT_Y      # $s3 = curr.y = bot.y
        
        li      $s4, 1          # $s4 = i = 1
probe_loop:
        move    $a0, $s2 
        move    $a1, $s3 
        jal     get_value 
        bne     $v0, 2, probe_end
       
        move    $a0, $s1
        move    $a1, $s4
        jal     sb_cos
        add     $s2, $s2, $v0        # curr.x += i * cos(angle) 
        
        move    $a0, $s1
        move    $a1, $s4
        jal     sb_sin
        move    $s5, $v0 
        add     $s3, $s3, $v0        # curr.y += i * sin(angle) 
        
        add     $s4, 1
        j       probe_loop        
probe_end:
        move    $v0, $s2
        move    $v1, $s3

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        add     $sp, $sp, 20
        
        jr      $ra

# ================================================================

# -----------------------------------------------------------------------
# sb_cos: computes a * cos(x)
# $a0 = x
# $a1 = a
# returns the cosine
# -----------------------------------------------------------------------
sb_cos:
        sub     $sp, $sp, 12
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)

        # NOTE: below is not a mix up. It makes more sense for mult to be s0 and a1
        move    $s0, $a1
        move    $s1, $a0

        mtc1,   $s0, $f0        # mult factor
        mtc1,   $s1, $f1        # angle

        cvt.s.w $f0, $f0
        cvt.s.w $f1, $f1

        # convert to radians
        l.s     $f2, F180       # load 180.0
        div.s   $f1, $f1, $f2   # value / 180
        l.s     $f2, PI         # load PI
        mul.s   $f1, $f1, $f2   # PI * value / 180.0

        mul.s   $f1, $f1, $f1   # $f1 = v^^2
        mul.s   $f2, $f1, $f1   # $f2 = v^^4
        mul.s   $f3, $f1, $f2   # $f3 = v^^6
        mul.s   $f4, $f1, $f3   # $f4 = v^^8
        mul.s   $f5, $f1, $f4   # $f4 = v^^10

        # multiplication parts
        li.s    $f6, 2.0        # 2!
        div.s   $f1, $f1, $f6   # $f1 = x^^2 / 2!

        li.s    $f6, 24.0       # 4!
        div.s   $f2, $f2, $f6   # $f2 = x^^4 / 4!

        li.s    $f6, 720.0      # 6!
        div.s   $f3, $f3, $f6   # $f3 = x^^6 / 6!

        li.s    $f6, 40320.0    # 8!
        div.s   $f4, $f4, $f6   # $f4 = x^^8 / 8!

        li.s    $f6, 3628800.0  # 10!
        div.s   $f5, $f5, $f6   # $f5 = x^^10 / 10!

        li.s    $f6, 1.0
        sub.s   $f1, $f6, $f1   # 1 - X^^2/2!
        sub.s   $f2, $f2, $f3   # x^^4/4! - x^^6/6!
        sub.s   $f4, $f4, $f5   # x^^8/8! - x^^10/10!
        add.s   $f1, $f1, $f2   # 1 - X^^2/2! + x^^4/4! - x^^6/6!
        add.s   $f1, $f1, $f4   # 1 - X^^2/2! + x^^4/4! - x^^6/6! + x^^8/8! - x^^10/10!

        mul.s   $f0, $f0, $f1   # a * (1 - X^^2/2! + x^^4/4! - x^^6/6! + x^^8/8! - x^^10/10!)

        cvt.w.s $f0, $f0
        mfc1    $v0, $f0

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        add     $sp, $sp, 12
        jr      $ra

# -----------------------------------------------------------------------
# sb_sin: computes a * sin(x)
# $a0 = x
# $a1 = a
# returns the sine
# -----------------------------------------------------------------------
sb_sin:
        sub     $sp, $sp, 12
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)

        # NOTE: below is not a mix up. It makes more sense for mult to be s0 and a1
        move    $s0, $a1
        move    $s1, $a0

        mtc1,   $s0, $f0        # mult factor
        mtc1,   $s1, $f1        # angle

        cvt.s.w $f0, $f0
        cvt.s.w $f1, $f1

        # convert to radians
        l.s     $f2, F180       # load 180.0
        div.s   $f1, $f1, $f2   # value / 180
        l.s     $f2, PI         # load PI
        mul.s   $f1, $f1, $f2   # PI * value / 180.0

        #mul.s  $f1, $f1, $f1   # $f1 = v
        mul.s   $f6, $f1, $f1   # v^^2
        mul.s   $f2, $f1, $f6   # $f2 = v^^3
        mul.s   $f3, $f2, $f6   # $f3 = v^^5
        mul.s   $f4, $f3, $f6   # $f4 = v^^7
        mul.s   $f5, $f4, $f6   # $f4 = v^^9

        # multiplication parts
        li.s    $f6, 6.0        # 3!
        div.s   $f2, $f2, $f6   # $f2 = x^^3 / 3!

        li.s    $f6, 120.0       # 5!
        div.s   $f3, $f3, $f6   # $f3 = x^^5 / 5!

        li.s    $f6, 5040.0      # 7!
        div.s   $f4, $f4, $f6   # $f4 = x^^7 / 7!

        li.s    $f6, 362880.0    # 9!
        div.s   $f5, $f5, $f6   # $f5 = x^^9 / 9!

        sub.s   $f1, $f1, $f2   # x - X^^3/3!
        sub.s   $f3, $f3, $f4   # x^^5/5! - x^^7/7!
        add.s   $f1, $f1, $f3   # x - X^^3/3! + x^^5/5! - x^^7/7!
        add.s   $f1, $f1, $f5   # x - X^^3/3! + x^^5/5! - x^^7/7! + x^^9/9!

        mul.s   $f0, $f0, $f1   # a * (x - X^^3/3! + x^^5/5! - x^^7/7! + x^^9/9!)

        cvt.w.s $f0, $f0
        mfc1    $v0, $f0

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        add     $sp, $sp, 12
        jr      $ra


# -----------------------------------------------------------------------

# *===============================================================
# get_value
# $a0 = target x
# $a1 = target y
# returns the value of jetstream at specified coord
get_value:
        sub     $sp, $sp, 8
	sw	$ra, 0($sp)
        sw      $s0, 4($sp)

        la      $s0, event_horizon_data
        mul     $a1, $a1, 300
        add     $a1, $s0, $a1   # &map[y]
        add     $a0, $a0, $a1   # &map[y][x]
        lbu     $v0, 0($a0)     # return map[y][x]

	lw	$ra, 0($sp)
        lw      $s0, 4($sp)
        add     $sp, $sp, 8
        jr      $ra
# ================================================================

# *===============================================================
# sets our boi flying off to a specified point
# $a0 = destX
# #a1 = destY
# no return value, set angle within funct
point_to:
        sub     $sp, $sp, 16
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)

        # TODO: change back to s0 and s1 resp
        lw      $t2, BOT_X              # $s0 = x
        lw      $t3, BOT_Y              # $s1 = y

        sub     $s0, $a0, $t2           # $s0 = deltaX
        sub     $s1, $a1, $t3           # $s1 = deltaY
                
        # make sure we don't divide by 0
        bne     $s0, $0, valid_quotient # if deltaX == 0
        #beq     $s1, $0, point_to_kill # if deltaY == 0
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
point_to_kill: 
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        add     $sp, $sp, 16
        jr      $ra
# ================================================================

# *===============================================================
# determine_quad
# no parameters
# returns 1, 2, 3 or 4 depending on the position of the bot
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
# ================================================================

# *===============================================================
# next_point
# no parameters
# no return
# points the spimbot in the direction of the next pixel along the inner edge of jetstream
next_point:
	#sub	$sp, $sp, #TODO:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	#sw	$s2, 12($sp)

	lw	$s0, BOT_X
	lw	$s1, BOT_Y

	jal	determine_quad
	# if quadrant == 1
	li	$t0, 1
	bne	$v0, $t0, quad_2
	sub	$a0, $s0, 1	# x - 1
	move	$a1, $s1	# y
	jal	get_value
	# if point to left (x - 1, y) is in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q1_op2
	sub	$a0, $s0, 1	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end
q1_op2:	# quadrant 1 option (candidate pixel) 2
	sub	$a0, $s0, 1	# x - 1
	add	$a1, $s1, 1	# y + 1
	jal	get_value
	li	$t0, 2
	bne	$v0, $t0, q1_op3
	sub	$a0, $s0, 1	# x - 1
	add	$a1, $s1, 1	# y + 1
	jal	point_to
	j	np_end
q1_op3:	# quadrant 1 option (candidate pixel) 3
#	# test if the last point is in jetstream
#	# only need this part if we want to be very robust
#	sub	$a0, $s0, 1	# x - 1
#	add	$a1, $s1, 1	# y + 1
#	jal	get_value
#	li	$t0, 2
#	bne	$v0, $t0, q1_op3
	move	$a0, $s0	# x
	add	$a1, $s1, 1	# y + 1
	jal	point_to
	j	np_end
	
#TODO:
quad_2:
	li	$t0, 2
	bne	$v0, $t0, quad_3
	move	$a0, $s0	# x
	sub	$a1, $s1, 1	# y - 1
	jal	get_value
	# if point above (x, y - 1) in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q2_op2
	sub	$a0, $s0, 1	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end
q2_op2:	# quadrant 2 option (candidate pixel) 2
	sub	$a0, $s0, 1	# x - 1
	sub	$a1, $s1, 1	# y - 1
	jal	get_value
	li	$t0, 2
	bne	$v0, $t0, q2_op3
	sub	$a0, $s0, 1	# x - 1
	add	$a1, $s1, 1	# y - 1
	jal	point_to
	j	np_end
q2_op3:	# quadrant 2 option (candidate pixel) 3
#	# test if the last point is in jetstream
#	# only need this part if we want to be very robust
#	sub	$a0, $s0, 1	# x - 1
#	add	$a1, $s1, 1	# y + 1
#	jal	get_value
#	li	$t0, 2
#	bne	$v0, $t0, q1_op3
	sub	$a0, $s0, 1	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end

quad_3:
# TODO:
	li	$t0, 3
	bne	$v0, $t0, quad_4
	add	$a0, $s0, 1	# x + 1
	move	$a1, $s1	# y
	jal	get_value
	# if point to right (x + 1, y) is in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q3_op2
	add	$a0, $s0, 1	# x + 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end
q3_op2:	# quadrant 3 option (candidate pixel) 2
	add	$a0, $s0, 1	# x + 1
	sub	$a1, $s1, 1	# y - 1
	jal	get_value
	li	$t0, 2
	bne	$v0, $t0, q3_op3
	add	$a0, $s0, 1	# x + 1
	sub	$a1, $s1, 1	# y - 1
	jal	point_to
	j	np_end
q3_op3:	# quadrant 3 option (candidate pixel) 3
#	# test if the last point is in jetstream
#	# only need this part if we want to be very robust
#	sub	$a0, $s0, 1	# x - 1
#	add	$a1, $s1, 1	# y + 1
#	jal	get_value
#	li	$t0, 2
#	bne	$v0, $t0, q1_op3
	move	$a0, $s0	# x
	sub	$a1, $s1, 1	# y - 1
	jal	point_to
	j	np_end

quad_4:
# TODO:
	li	$t0, 1
	bne	$v0, $t0, quad_2
	move	$a0, $s0	# x
	add	$a1, $s1, 1	# y + 1
	jal	get_value
	# if point below (x, y + 1) is in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q4_op2
	move	$a0, $s0	# x
	add	$a1, $s1, 1	# y + 1
	jal	point_to
	j	np_end
q4_op2:	# quadrant 4 option (candidate pixel) 2
	add	$a0, $s0, 1	# x + 1
	add	$a1, $s1, 1	# y + 1
	jal	get_value
	li	$t0, 2
	bne	$v0, $t0, q4_op3
	add	$a0, $s0, 1	# x + 1
	add	$a1, $s1, 1	# y + 1
	jal	point_to
	j	np_end
q4_op3:	# quadrant 4 option (candidate pixel) 3
#	# test if the last point is in jetstream
#	# only need this part if we want to be very robust
#	sub	$a0, $s0, 1	# x - 1
#	add	$a1, $s1, 1	# y + 1
#	jal	get_value
#	li	$t0, 2
#	bne	$v0, $t0, q1_op3
	add	$a0, $s0, 1	# x + 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end

np_end:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	#add	$sp, $sp, #TODO:
	add	$sp, $sp, 12
	jr	$ra
# ================================================================

# *===============================================================
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
# ================================================================

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

#        and     $a0, $k0, REQUEST_STARCOIN_INT_MASK
#        bne     $a0, 0, star_interrupt

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
