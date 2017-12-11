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

# *================================================================
# Press F12 to boot into ~recovery~ mode
recovery:
        sub     $sp, $sp, 24 
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)

recovery_main:
        li      $a0, 149 
        li      $a1, 149 
        jal     point_to
        sw      $s1, ANGLE 

        lw      $s2, BOT_X      # $s2 = curr.x = bot.x
        lw      $s3, BOT_Y      # $s3 = curr.y = bot.y
        
        li      $s4, 1          # $s4 = i = 1
recovery_loop:
        move    $a0, $s2 
        move    $a1, $s3 
        jal     get_value 
        beq     $v0, 2, recovery_end
        beq     $v0, 0, recovery_turn_180          # turn if found black hole
        bgt     $s4, 215, recovery_turn_180        # turn if never found jet
               
        move    $a0, $s1
        move    $a1, $s4
        jal     sb_cos
        add     $s2, $s2, $v0        # curr.x += i * cos(angle) 
        
        move    $a0, $s1
        move    $a1, $s4
        jal     sb_sin
        add     $s3, $s3, $v0        # curr.y += i * sin(angle) 
        
        add     $s4, 1
        j       recovery_loop        

recovery_turn_180:
        li      $s2, 180
        sw      $s2, ANGLE
        li      $t0, 0
        sw      $t0, ANGLE_CONTROL 
recovery_end:
        move    $v0, $s2
        move    $v1, $s3

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        add     $sp, $sp, 24
        
        jr      $ra

# =================================================================
