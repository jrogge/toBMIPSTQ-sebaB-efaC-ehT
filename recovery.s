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

radar_flag: .space 1

.align 4
radar_map: .space 512

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

	li	$t0, REQUEST_PUZZLE_INT_MASK
	or	$t0, $t0, BONK_MASK
	or	$t0, $t0, REQUEST_RADAR_INT_MASK
	or	$t0, $t0, 1
	mtc0	$t0, $12

	la      $s0, event_horizon_data
	sw	$s0, REQUEST_JETSTREAM

fake_loss:
	li	$t0, 10
	sw	$t0, VELOCITY
	li	$t0, 45
	sw	$t0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL

	li	$t0, 0
	li	$t1, 2000

fake_loss_loop:
	beq	$t0, $t1, fin_fake_loss
	add	$t0, $t0, 1
	j	fake_loss_loop

fin_fake_loss:
	li	$t0, 0
	sw	$t0, VELOCITY

main_loop:
	jal	get_recovery_status

get_recovery_status:
	lw	$t2, BOT_X
	lw	$t3, BOT_Y

	sub	$t4, $t2, 3
	add	$t5, $t2, 3
x_recovery_check:
	beq	$t4, $t5, fin_x_recovery_check
	mul	$t6, $t3, 300				#Row maj order Y
	add	$t6, $t6, $t4				#Row maj order index
	mul	$t6, $t6, 4				#Index of event_horizon_data
	la	$t1, event_horizon_data
	add	$t1, $t1, $t6				#Addr event_horizon_data at index
	lw	$t1, 0($t1)
	beq	$t1, 2, no_recovery_state
	add	$t4, $t4, 1
	j	x_recovery_check
fin_x_recovery_check:
	lw	$t2, BOT_X
	lw	$t3, BOT_Y

	sub	$t4, $t3, 3
	add	$t5, $t3, 3
y_recovery_check:
	beq	$t4, $t5, fin_y_recovery_check
	mul	$t6, $t4, 300
	add	$t6, $t6, $t2
	mul	$t6, $t6, 4
	la	$t1, event_horizon_data
	add	$t1, $t1, $t6
	lw	$t1, 0($t1)
	beq	$t1, 2, no_recovery_state
	add	$t4, $t4, 1
	j	y_recovery_check
fin_y_recovery_check:
	jal	getQuad
	move	$t0, $v0

	beq	$t0, 1, quad1_recovery_status
	beq	$t0, 2, quad2_recovery_status
	beq	$t0, 3, quad3_recovery_status
quad4_recovery_status:
	li	$t0, 0
	
quad4_rec_out:

quad4_rec_in:

quad1_recovery_status:

quad2_recovery_status:

quad3_recovery_status:

no_recovery_state:
	move	$v0, 0
	jr	$ra

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

getQuad:
	lw	$t1, BOT_X			#Get the current x coordinate
	lw	$t2, BOT_Y			#Get current y coord

	ble	$t2, 150, retQuad12		#If in quadrants 1,2
	j	retQuad34			#Else in quadrants 3,4
	
retQuad12:
	bge	$t1, 150, retQuad1		# x>150, y<150
	j	retQuad2			# x<150, y<150

retQuad34:
	bge	$t1, 150, retQuad4		# x>150, y>150
	j	retQuad3			# x<150, y>150

retQuad1:
	li	$v0, 1
	j	retGetQuad

retQuad2:
	li	$v0, 2
	j	retGetQuad

retQuad3:
	li	$v0, 3
	j	retGetQuad

retQuad4:
	li	$v0, 4
	j	retGetQuad

retGetQuad:
	jr	$ra


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

	and     $a0, $k0, REQUEST_RADAR_INT_MASK
	bne     $a0, 0, radar_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

radar_interrupt:
        sw      $a1, REQUEST_RADAR_ACK 
	li	$a0, 1
	la	$a1, radar_flag
	sw	$a0, 0($a1)
        j       interrupt_dispatch               # go back to handler

bonk_interrupt:
        sw      $a1, BONK_ACK

        li      $a0, 0
        sw      $a0, VELOCITY
        j       interrupt_dispatch       # see if other interrupts are waiting
      
timer_interrupt:
	sw	$a1, TIMER_ACK		# acknowledge interrupt
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
