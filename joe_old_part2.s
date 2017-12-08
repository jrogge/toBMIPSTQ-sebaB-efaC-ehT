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
	li	$t0, 10
	sw	$t0 VELOCITY
        
main_loop:
	# note that we infinite loop to avoid stopping the simulation early
	#lw      $t6, BOT_X              # x
        #lw      $t7, BOT_Y              # y
	j	main_loop

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
