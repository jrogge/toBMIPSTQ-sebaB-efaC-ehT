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

uniq_chars: .space 256

.align 2
event_horizon_data: .space 90000

radar_flag: .space 1
getting_coin: .space 1
got_bonked: .space 1
backtrack: .space 1
bt_reached_corner: .space 1
puzzle_flag: .space 1

.align 2
starcoin_count: .space 4
backtrack_x: .space 4
backtrack_y: .space 4

.align 2
target_coin: .space 8 #X, Y

.align 4
radar_map: .space 512

.align 2
puzzle_data:	.space 216		#64 char encrypted array, 144 char key, 1 char rounds, 1 int
.align 0
puzzle_key:	.space 144		#Key for puzzle
.align 0
puzzle_encrypted:	.space 16	#Current encrypted string to be passed
.align 0
puzzle_plaintext:	.space 64
.align 0
puzzle_rounds:	.space 1		#Puzzle rounds
.align 0
puzzle_solution: .space 80		#Maximum size of unique substr is 80, given in docs

inv_sbox:
.byte 0x52 0x09 0x6A 0xD5 0x30 0x36 0xA5 0x38 0xBF 0x40 0xA3 0x9E 0x81 0xF3 0xD7 0xFB
.byte 0x7C 0xE3 0x39 0x82 0x9B 0x2F 0xFF 0x87 0x34 0x8E 0x43 0x44 0xC4 0xDE 0xE9 0xCB
.byte 0x54 0x7B 0x94 0x32 0xA6 0xC2 0x23 0x3D 0xEE 0x4C 0x95 0x0B 0x42 0xFA 0xC3 0x4E
.byte 0x08 0x2E 0xA1 0x66 0x28 0xD9 0x24 0xB2 0x76 0x5B 0xA2 0x49 0x6D 0x8B 0xD1 0x25
.byte 0x72 0xF8 0xF6 0x64 0x86 0x68 0x98 0x16 0xD4 0xA4 0x5C 0xCC 0x5D 0x65 0xB6 0x92
.byte 0x6C 0x70 0x48 0x50 0xFD 0xED 0xB9 0xDA 0x5E 0x15 0x46 0x57 0xA7 0x8D 0x9D 0x84
.byte 0x90 0xD8 0xAB 0x00 0x8C 0xBC 0xD3 0x0A 0xF7 0xE4 0x58 0x05 0xB8 0xB3 0x45 0x06
.byte 0xD0 0x2C 0x1E 0x8F 0xCA 0x3F 0x0F 0x02 0xC1 0xAF 0xBD 0x03 0x01 0x13 0x8A 0x6B
.byte 0x3A 0x91 0x11 0x41 0x4F 0x67 0xDC 0xEA 0x97 0xF2 0xCF 0xCE 0xF0 0xB4 0xE6 0x73
.byte 0x96 0xAC 0x74 0x22 0xE7 0xAD 0x35 0x85 0xE2 0xF9 0x37 0xE8 0x1C 0x75 0xDF 0x6E
.byte 0x47 0xF1 0x1A 0x71 0x1D 0x29 0xC5 0x89 0x6F 0xB7 0x62 0x0E 0xAA 0x18 0xBE 0x1B
.byte 0xFC 0x56 0x3E 0x4B 0xC6 0xD2 0x79 0x20 0x9A 0xDB 0xC0 0xFE 0x78 0xCD 0x5A 0xF4
.byte 0x1F 0xDD 0xA8 0x33 0x88 0x07 0xC7 0x31 0xB1 0x12 0x10 0x59 0x27 0x80 0xEC 0x5F
.byte 0x60 0x51 0x7F 0xA9 0x19 0xB5 0x4A 0x0D 0x2D 0xE5 0x7A 0x9F 0x93 0xC9 0x9C 0xEF
.byte 0xA0 0xE0 0x3B 0x4D 0xAE 0x2A 0xF5 0xB0 0xC8 0xEB 0xBB 0x3C 0x83 0x53 0x99 0x61
.byte 0x17 0x2B 0x04 0x7E 0xBA 0x77 0xD6 0x26 0xE1 0x69 0x14 0x63 0x55 0x21 0x0C 0x7D

inv_mix:
.byte 0x00 0x0e 0x1c 0x12 0x38 0x36 0x24 0x2a 0x70 0x7e 0x6c 0x62 0x48 0x46 0x54 0x5a
.byte 0xe0 0xee 0xfc 0xf2 0xd8 0xd6 0xc4 0xca 0x90 0x9e 0x8c 0x82 0xa8 0xa6 0xb4 0xba
.byte 0xdb 0xd5 0xc7 0xc9 0xe3 0xed 0xff 0xf1 0xab 0xa5 0xb7 0xb9 0x93 0x9d 0x8f 0x81
.byte 0x3b 0x35 0x27 0x29 0x03 0x0d 0x1f 0x11 0x4b 0x45 0x57 0x59 0x73 0x7d 0x6f 0x61
.byte 0xad 0xa3 0xb1 0xbf 0x95 0x9b 0x89 0x87 0xdd 0xd3 0xc1 0xcf 0xe5 0xeb 0xf9 0xf7
.byte 0x4d 0x43 0x51 0x5f 0x75 0x7b 0x69 0x67 0x3d 0x33 0x21 0x2f 0x05 0x0b 0x19 0x17
.byte 0x76 0x78 0x6a 0x64 0x4e 0x40 0x52 0x5c 0x06 0x08 0x1a 0x14 0x3e 0x30 0x22 0x2c
.byte 0x96 0x98 0x8a 0x84 0xae 0xa0 0xb2 0xbc 0xe6 0xe8 0xfa 0xf4 0xde 0xd0 0xc2 0xcc
.byte 0x41 0x4f 0x5d 0x53 0x79 0x77 0x65 0x6b 0x31 0x3f 0x2d 0x23 0x09 0x07 0x15 0x1b
.byte 0xa1 0xaf 0xbd 0xb3 0x99 0x97 0x85 0x8b 0xd1 0xdf 0xcd 0xc3 0xe9 0xe7 0xf5 0xfb
.byte 0x9a 0x94 0x86 0x88 0xa2 0xac 0xbe 0xb0 0xea 0xe4 0xf6 0xf8 0xd2 0xdc 0xce 0xc0
.byte 0x7a 0x74 0x66 0x68 0x42 0x4c 0x5e 0x50 0x0a 0x04 0x16 0x18 0x32 0x3c 0x2e 0x20
.byte 0xec 0xe2 0xf0 0xfe 0xd4 0xda 0xc8 0xc6 0x9c 0x92 0x80 0x8e 0xa4 0xaa 0xb8 0xb6
.byte 0x0c 0x02 0x10 0x1e 0x34 0x3a 0x28 0x26 0x7c 0x72 0x60 0x6e 0x44 0x4a 0x58 0x56
.byte 0x37 0x39 0x2b 0x25 0x0f 0x01 0x13 0x1d 0x47 0x49 0x5b 0x55 0x7f 0x71 0x63 0x6d
.byte 0xd7 0xd9 0xcb 0xc5 0xef 0xe1 0xf3 0xfd 0xa7 0xa9 0xbb 0xb5 0x9f 0x91 0x83 0x8d
.byte 0x00 0x0b 0x16 0x1d 0x2c 0x27 0x3a 0x31 0x58 0x53 0x4e 0x45 0x74 0x7f 0x62 0x69
.byte 0xb0 0xbb 0xa6 0xad 0x9c 0x97 0x8a 0x81 0xe8 0xe3 0xfe 0xf5 0xc4 0xcf 0xd2 0xd9
.byte 0x7b 0x70 0x6d 0x66 0x57 0x5c 0x41 0x4a 0x23 0x28 0x35 0x3e 0x0f 0x04 0x19 0x12
.byte 0xcb 0xc0 0xdd 0xd6 0xe7 0xec 0xf1 0xfa 0x93 0x98 0x85 0x8e 0xbf 0xb4 0xa9 0xa2
.byte 0xf6 0xfd 0xe0 0xeb 0xda 0xd1 0xcc 0xc7 0xae 0xa5 0xb8 0xb3 0x82 0x89 0x94 0x9f
.byte 0x46 0x4d 0x50 0x5b 0x6a 0x61 0x7c 0x77 0x1e 0x15 0x08 0x03 0x32 0x39 0x24 0x2f
.byte 0x8d 0x86 0x9b 0x90 0xa1 0xaa 0xb7 0xbc 0xd5 0xde 0xc3 0xc8 0xf9 0xf2 0xef 0xe4
.byte 0x3d 0x36 0x2b 0x20 0x11 0x1a 0x07 0x0c 0x65 0x6e 0x73 0x78 0x49 0x42 0x5f 0x54
.byte 0xf7 0xfc 0xe1 0xea 0xdb 0xd0 0xcd 0xc6 0xaf 0xa4 0xb9 0xb2 0x83 0x88 0x95 0x9e
.byte 0x47 0x4c 0x51 0x5a 0x6b 0x60 0x7d 0x76 0x1f 0x14 0x09 0x02 0x33 0x38 0x25 0x2e
.byte 0x8c 0x87 0x9a 0x91 0xa0 0xab 0xb6 0xbd 0xd4 0xdf 0xc2 0xc9 0xf8 0xf3 0xee 0xe5
.byte 0x3c 0x37 0x2a 0x21 0x10 0x1b 0x06 0x0d 0x64 0x6f 0x72 0x79 0x48 0x43 0x5e 0x55
.byte 0x01 0x0a 0x17 0x1c 0x2d 0x26 0x3b 0x30 0x59 0x52 0x4f 0x44 0x75 0x7e 0x63 0x68
.byte 0xb1 0xba 0xa7 0xac 0x9d 0x96 0x8b 0x80 0xe9 0xe2 0xff 0xf4 0xc5 0xce 0xd3 0xd8
.byte 0x7a 0x71 0x6c 0x67 0x56 0x5d 0x40 0x4b 0x22 0x29 0x34 0x3f 0x0e 0x05 0x18 0x13
.byte 0xca 0xc1 0xdc 0xd7 0xe6 0xed 0xf0 0xfb 0x92 0x99 0x84 0x8f 0xbe 0xb5 0xa8 0xa3
.byte 0x00 0x0d 0x1a 0x17 0x34 0x39 0x2e 0x23 0x68 0x65 0x72 0x7f 0x5c 0x51 0x46 0x4b
.byte 0xd0 0xdd 0xca 0xc7 0xe4 0xe9 0xfe 0xf3 0xb8 0xb5 0xa2 0xaf 0x8c 0x81 0x96 0x9b
.byte 0xbb 0xb6 0xa1 0xac 0x8f 0x82 0x95 0x98 0xd3 0xde 0xc9 0xc4 0xe7 0xea 0xfd 0xf0
.byte 0x6b 0x66 0x71 0x7c 0x5f 0x52 0x45 0x48 0x03 0x0e 0x19 0x14 0x37 0x3a 0x2d 0x20
.byte 0x6d 0x60 0x77 0x7a 0x59 0x54 0x43 0x4e 0x05 0x08 0x1f 0x12 0x31 0x3c 0x2b 0x26
.byte 0xbd 0xb0 0xa7 0xaa 0x89 0x84 0x93 0x9e 0xd5 0xd8 0xcf 0xc2 0xe1 0xec 0xfb 0xf6
.byte 0xd6 0xdb 0xcc 0xc1 0xe2 0xef 0xf8 0xf5 0xbe 0xb3 0xa4 0xa9 0x8a 0x87 0x90 0x9d
.byte 0x06 0x0b 0x1c 0x11 0x32 0x3f 0x28 0x25 0x6e 0x63 0x74 0x79 0x5a 0x57 0x40 0x4d
.byte 0xda 0xd7 0xc0 0xcd 0xee 0xe3 0xf4 0xf9 0xb2 0xbf 0xa8 0xa5 0x86 0x8b 0x9c 0x91
.byte 0x0a 0x07 0x10 0x1d 0x3e 0x33 0x24 0x29 0x62 0x6f 0x78 0x75 0x56 0x5b 0x4c 0x41
.byte 0x61 0x6c 0x7b 0x76 0x55 0x58 0x4f 0x42 0x09 0x04 0x13 0x1e 0x3d 0x30 0x27 0x2a
.byte 0xb1 0xbc 0xab 0xa6 0x85 0x88 0x9f 0x92 0xd9 0xd4 0xc3 0xce 0xed 0xe0 0xf7 0xfa
.byte 0xb7 0xba 0xad 0xa0 0x83 0x8e 0x99 0x94 0xdf 0xd2 0xc5 0xc8 0xeb 0xe6 0xf1 0xfc
.byte 0x67 0x6a 0x7d 0x70 0x53 0x5e 0x49 0x44 0x0f 0x02 0x15 0x18 0x3b 0x36 0x21 0x2c
.byte 0x0c 0x01 0x16 0x1b 0x38 0x35 0x22 0x2f 0x64 0x69 0x7e 0x73 0x50 0x5d 0x4a 0x47
.byte 0xdc 0xd1 0xc6 0xcb 0xe8 0xe5 0xf2 0xff 0xb4 0xb9 0xae 0xa3 0x80 0x8d 0x9a 0x97
.byte 0x00 0x09 0x12 0x1b 0x24 0x2d 0x36 0x3f 0x48 0x41 0x5a 0x53 0x6c 0x65 0x7e 0x77
.byte 0x90 0x99 0x82 0x8b 0xb4 0xbd 0xa6 0xaf 0xd8 0xd1 0xca 0xc3 0xfc 0xf5 0xee 0xe7
.byte 0x3b 0x32 0x29 0x20 0x1f 0x16 0x0d 0x04 0x73 0x7a 0x61 0x68 0x57 0x5e 0x45 0x4c
.byte 0xab 0xa2 0xb9 0xb0 0x8f 0x86 0x9d 0x94 0xe3 0xea 0xf1 0xf8 0xc7 0xce 0xd5 0xdc
.byte 0x76 0x7f 0x64 0x6d 0x52 0x5b 0x40 0x49 0x3e 0x37 0x2c 0x25 0x1a 0x13 0x08 0x01
.byte 0xe6 0xef 0xf4 0xfd 0xc2 0xcb 0xd0 0xd9 0xae 0xa7 0xbc 0xb5 0x8a 0x83 0x98 0x91
.byte 0x4d 0x44 0x5f 0x56 0x69 0x60 0x7b 0x72 0x05 0x0c 0x17 0x1e 0x21 0x28 0x33 0x3a
.byte 0xdd 0xd4 0xcf 0xc6 0xf9 0xf0 0xeb 0xe2 0x95 0x9c 0x87 0x8e 0xb1 0xb8 0xa3 0xaa
.byte 0xec 0xe5 0xfe 0xf7 0xc8 0xc1 0xda 0xd3 0xa4 0xad 0xb6 0xbf 0x80 0x89 0x92 0x9b
.byte 0x7c 0x75 0x6e 0x67 0x58 0x51 0x4a 0x43 0x34 0x3d 0x26 0x2f 0x10 0x19 0x02 0x0b
.byte 0xd7 0xde 0xc5 0xcc 0xf3 0xfa 0xe1 0xe8 0x9f 0x96 0x8d 0x84 0xbb 0xb2 0xa9 0xa0
.byte 0x47 0x4e 0x55 0x5c 0x63 0x6a 0x71 0x78 0x0f 0x06 0x1d 0x14 0x2b 0x22 0x39 0x30
.byte 0x9a 0x93 0x88 0x81 0xbe 0xb7 0xac 0xa5 0xd2 0xdb 0xc0 0xc9 0xf6 0xff 0xe4 0xed
.byte 0x0a 0x03 0x18 0x11 0x2e 0x27 0x3c 0x35 0x42 0x4b 0x50 0x59 0x66 0x6f 0x74 0x7d
.byte 0xa1 0xa8 0xb3 0xba 0x85 0x8c 0x97 0x9e 0xe9 0xe0 0xfb 0xf2 0xcd 0xc4 0xdf 0xd6
.byte 0x31 0x38 0x23 0x2a 0x15 0x1c 0x07 0x0e 0x79 0x70 0x6b 0x62 0x5d 0x54 0x4f 0x46

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

	sb	$0, getting_coin

        la      $s0, event_horizon_data
        sw      $s0, REQUEST_JETSTREAM
	la	$s1, radar_flag
	li	$s0, 2
	sb	$s0, 0($s1)
	la	$s0, radar_map
	sw	$s0, REQUEST_RADAR

	la	$s0, puzzle_flag
	li	$s1, 0
	sb	$s1, 0($s0)				#Initialize puzzle flag as 0

	la	$s0, backtrack
	sb	$0, 0($s0)
	la	$s0, bt_reached_corner
	sb	$0, 0($s0)

	# set velocity = 10
	li	$t0, 10
	sw	$t0 VELOCITY

        li      $t0, 0
        sw      $t0, ANGLE
        li      $t0, 1
        sw      $t0, ANGLE_CONTROL

        lw      $s5, BOT_X      # $s2 = curr.x = bot.x
        lw      $s6, BOT_Y      # $s3 = curr.y = bot.y
main_loop:
        jal     check_need_recovery
	la	$s0, getting_coin
	lbu	$s0, 0($s0)
	bne	$0, $s0, main_getting_coin
	la	$s0, radar_flag
	lbu	$s0, 0($s0)
	beq	$s0, 1, main_has_coin
	la	$s0, puzzle_flag
	lbu	$s0, 0($s0)
	beq	$s0, 0, main_no_puzzle
	beq	$s1, 0, main_has_puzzle
	lw	$s0, MUSHROOM
	bge	$s0, 1, main_has_mushroom
	jal	next_point
	j	main_loop

main_getting_coin:
	jal	got_coin
	j	main_loop
main_has_coin:
	jal	has_coin
	j	main_loop
main_no_puzzle:
	la	$s0, puzzle_data
	lw	$s1, STARCOIN
	blt	$s1, 4, main_puzzle_not_enough_request
	sw	$s0, REQUEST_PUZZLE
main_has_puzzle:
	jal	solve_puzzle
	j	main_loop
main_puzzle_not_enough_request:
	jal	next_point
	j	main_loop
main_has_mushroom:
	jal	next_point
	sw	$0, MUSHROOM
	j	main_loop

###CHECK IF GOT COIN###
got_coin:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	la	$s0, starcoin_count
	lw	$s0, 0($s0)
	lw	$s1, STARCOIN
	bgt	$s1, $s0, got_coin_true
	j	got_coin_false
got_coin_true:
	la	$s0, starcoin_count
	sw	$s1, 0($s0)
	la	$s1, getting_coin
	sb	$0, 0($s1)
	la	$s1, radar_flag
	sb	$0, 0($s1)
	la	$s1, radar_map
	sw	$s1, REQUEST_RADAR
	jal	next_point
	j	got_coin_finish
got_coin_false:
	la	$s0, target_coin
	lw	$a0, 0($s0)
	lw	$a1, 4($s0)
	jal	point_to
	j	got_coin_finish
got_coin_finish:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, $sp, 16
	jr	$ra

###COIN METHOD###
has_coin:
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

	la	$s0, radar_map
	lw	$s1, 0($s0)
	jal	determine_quad
	move	$t0, $v0

#j	no_usable_coin # //TODO DELETE THIS SHIT
#SKIPS VALUE CHECK
#	bne	$s4, 0xffffffff, skip_check_coin
#	j	no_usable_coin
#SEARCHES FOR COIN WITH GOOD VALUES
find_coin_loop:
	beq	$s1, 0xffffffff, no_usable_coin
	and	$s2, $s1, 0x0000ffff			#Y value
	and	$s3, $s1, 0xffff0000
	srl	$s3, $s3, 16				#X value
	move	$a0, $s3
	move	$a1, $s2
	jal	get_value
	move	$s4, $v0
	beq	$s4, 2, coin_in_jetstream
get_next_coin:
	add	$s0, $s0, 4
	lw	$s1, 0($s0)
	j	find_coin_loop
coin_in_jetstream:
	j	usable_coin
skip_check_coin:
	and	$s2, $s1, 0x0000ffff
	and	$s3, $s1, 0xffff0000
	srl	$s3, $s3, 16
usable_coin:
	#li	$t0, 10
	#sw	$t0, VELOCITY
	move	$a0, $s3
	move	$a1, $s2
	jal	point_to
	la	$s0, getting_coin
	li	$s1, 1
	sb	$s1, 0($s0)
	la	$s1, target_coin
	sw	$s3, 0($s1)
	sw	$s2, 4($s1)
	lw	$s5, STARCOIN
	la	$s6, starcoin_count
	sw	$s5, 0($s6)
	j	finish_coin
no_usable_coin:
	la	$s0, radar_flag
	sb	$0, 0($s0)
	la	$s0, radar_map
	sw	$s0, REQUEST_RADAR
finish_coin:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        lw      $s6, 28($sp)
	lw	$s7, 32($sp)
        add     $sp, $sp, 36
	jr	$ra

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
	#        bne     $s0, $0, valid_quotient # if deltaX == 0
	#        #beq     $s1, $0, point_to_kill # if deltaY == 0
	#        blt     $s1, $0, point_up       # if deltaY > 0
	#        li      $s2, 90                 # set angle = 90
	#        j       end_point
	#point_up:
	#        li      $s2, 270                # else set angle = 270
	#        j       end_point
	#valid_quotient:
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
        sub     $sp, $sp, 12
        sw      $ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

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
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
        add     $sp, $sp, 12
        jr      $ra
# ================================================================

# *===============================================================
# next_point
# no parameters
# no return
# points the spimbot in the direction of the next pixel along the inner edge of jetstream
next_point:
	#sub	$sp, $sp, #TODO:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	lw	$s0, BOT_X
	lw	$s1, BOT_Y
	li	$s2, 1

	jal	determine_quad
	beq	$v0, 1, np_quad_1
	beq	$v0, 2, np_quad_2
	beq	$v0, 3, np_quad_3
	beq	$v0, 4, np_quad_4
	# we should never get to this point
	# point at point 0,0 to indicate we got here
	move	$a0, $0
	move	$a1, $0
	jal	point_to
	j	np_end
np_quad_1:
	la	$t0, backtrack
	lbu	$t0, 0($t0)	# backtracking
	beq	$t0, 1, q1_op2	# if we're backtracking, don't try to go in the optimal 
	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	get_value
	# if point to left (x - 1, y) is in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q1_op2

	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	banana_at_point
	bne	$v0, $0, q1_op2 #np_banana_found

	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end
	#np_banana_found:
	#	j	np_end
q1_op2:	# quadrant 1 option (candidate pixel) 2
	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	banana_at_point
	bne	$v0, $0, q1_op3 #np_banana_found

	la	$t0, backtrack
	lbu	$t0, 0($t0)
	beq	$t0, 0, q1_keep_bt	# if we aren't backtracking, point like normal
	la	$t0, bt_reached_corner
	lbu	$t0, 0($t0)
	beq	$t0, 1, q1_check_past_corner	# if we're backtracking and we haven't reached the corner yet, we've reached corner
	la	$t0, bt_reached_corner
	li	$t1, 1
	sb	$t1, 0($t0)		# we've reached corner, set bt_reached_corner to true
	# set destX and destY	
	lw	$t0, BOT_X
	la	$t1, backtrack_x
	sw	$t1, 0($t1)
	lw	$t0, BOT_Y
	la	$t1, backtrack_y
	sw	$t1, 0($t1)
	# point to that point
	j	q1_keep_bt

q1_check_past_corner: # backtracking and we've reached the corner
	la	$t0, backtrack_x
	lw	$t0, 0($t0)
	lw	$t1, BOT_X
	bne	$t0, $t1, q1_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	la	$t0, backtrack_y
	lw	$t0, 0($t0)
	lw	$t1, BOT_Y
	bne	$t0, $t1, q1_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	j	q1_keep_bt
q1_stop_bt:
	# only do this if we've reached the corner and x and y have changed
	la	$t0, backtrack
	sb	$0, 0($t0)	# backtracking = false
	la	$t0, bt_reached_corner
	sb	$0, 0($t0)	# reached corner = false
q1_keep_bt:

	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	point_to
	j	np_end
q1_op3:
	la	$t0, backtrack
	li	$t1, 1
	sb	$t1, 0($t0)	# backtracking
	add	$a0, $s0, 1	# x + 1
	move	$a1, $s1	# y
	#	jal	get_value
	#	# if point to left (x - 1, y) is in jetstream, point at it
	#	li	$t0, 2
	#	bne	$v0, $t0, q1_op3
	#
	#	move	$a0, $s0	# x
	#	add	$a1, $s1, $s2	# y + 1
	#	jal	banana_at_point
	#	bne	$v0, $0, q1_op2 #np_banana_found

	jal	point_to
	j	np_end

np_quad_2:
	la	$t0, backtrack
	lbu	$t0, 0($t0)	# backtracking
	beq	$t0, 1, q2_op2	# if we're backtracking, don't try to go in the optimal 
	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	get_value
	# if point above (x, y - 1) in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q2_op2

	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	banana_at_point
	bne	$v0, $0, q2_op2

	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	point_to
	j	np_end
q2_op2:	# quadrant 2 option (candidate pixel) 2
	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	banana_at_point
	bne	$v0, $0, q2_op3

	la	$t0, backtrack
	lbu	$t0, 0($t0)
	beq	$t0, 0, q2_keep_bt	# if we aren't backtracking, point like normal
	la	$t0, bt_reached_corner
	lbu	$t0, 0($t0)
	beq	$t0, 1, q2_check_past_corner	# if we're backtracking and we haven't reached the corner yet, we've reached corner
	la	$t0, bt_reached_corner
	li	$t1, 1
	sb	$t1, 0($t0)		# we've reached corner, set bt_reached_corner to true
	# set destX and destY	
	lw	$t0, BOT_X
	la	$t1, backtrack_x
	sw	$t1, 0($t1)
	lw	$t0, BOT_Y
	la	$t1, backtrack_y
	sw	$t1, 0($t1)
	# point to that point
	j	q2_keep_bt

q2_check_past_corner: # backtracking and we've reached the corner
	la	$t0, backtrack_x
	lw	$t0, 0($t0)
	lw	$t1, BOT_X
	bne	$t0, $t1, q2_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	la	$t0, backtrack_y
	lw	$t0, 0($t0)
	lw	$t1, BOT_Y
	bne	$t0, $t1, q2_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	j	q2_keep_bt
q2_stop_bt:
	# only do this if we've reached the corner and x and y have changed
	la	$t0, backtrack
	sb	$0, 0($t0)	# backtracking = false
	la	$t0, bt_reached_corner
	sb	$0, 0($t0)	# reached corner = false
q2_keep_bt:

	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end
q2_op3:
	la	$t0, backtrack
	li	$t1, 1
	sb	$t1, 0($t0)	# backtracking
	move	$a0, $s0	# x
	add	$a1, $s1, 1	# y + 1
	jal	point_to
	j	np_end

np_quad_3:
	la	$t0, backtrack
	lbu	$t0, 0($t0)	# backtracking
	beq	$t0, 1, q3_op2	# if we're backtracking, don't try to go in the optimal 
	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	get_value
	li	$t0, 2
	bne	$v0, $t0, q3_op2

	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	banana_at_point
	bne	$v0, $0, q3_op2

	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end

q3_op2:	# quadrant 3 option (candidate pixel) 3
	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	banana_at_point
	bne	$v0, $0, q3_op3

	la	$t0, backtrack
	lbu	$t0, 0($t0)
	beq	$t0, 0, q3_keep_bt	# if we aren't backtracking, point like normal
	la	$t0, bt_reached_corner
	lbu	$t0, 0($t0)
	beq	$t0, 1, q3_check_past_corner	# if we're backtracking and we haven't reached the corner yet, we've reached corner
	la	$t0, bt_reached_corner
	li	$t1, 1
	sb	$t1, 0($t0)		# we've reached corner, set bt_reached_corner to true
	# set destX and destY	
	lw	$t0, BOT_X
	la	$t1, backtrack_x
	sw	$t1, 0($t1)
	lw	$t0, BOT_Y
	la	$t1, backtrack_y
	sw	$t1, 0($t1)
	# point to that point
	j	q3_keep_bt

q3_check_past_corner: # backtracking and we've reached the corner
	la	$t0, backtrack_x
	lw	$t0, 0($t0)
	lw	$t1, BOT_X
	bne	$t0, $t1, q3_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	la	$t0, backtrack_y
	lw	$t0, 0($t0)
	lw	$t1, BOT_Y
	bne	$t0, $t1, q3_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	j	q3_keep_bt
q3_stop_bt:
	# only do this if we've reached the corner and x and y have changed
	la	$t0, backtrack
	sb	$0, 0($t0)	# backtracking = false
	la	$t0, bt_reached_corner
	sb	$0, 0($t0)	# reached corner = false
q3_keep_bt:

	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	point_to
	j	np_end
q3_op3:
	la	$t0, backtrack
	li	$t1, 1
	sb	$t1, 0($t0)	# backtracking

	sub	$a0, $s0, 1	# x - 1
	move	$a1, $s1
	jal	point_to
	j	np_end

np_quad_4:
	la	$t0, backtrack
	lbu	$t0, 0($t0)	# backtracking
	beq	$t0, 1, q4_op2	# if we're backtracking, don't try to go in the optimal 
	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	get_value
	# if point below (x, y + 1) is in jetstream, point at it
	li	$t0, 2
	bne	$v0, $t0, q4_op2

	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	banana_at_point
	bne	$v0, $0, q4_op2

	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	point_to
	j	np_end
q4_op2:	# quadrant 4 option (candidate pixel) 2
	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	banana_at_point
	bne	$v0, $0, q4_op3

	la	$t0, backtrack
	lbu	$t0, 0($t0)
	beq	$t0, 0, q4_keep_bt	# if we aren't backtracking, point like normal
	la	$t0, bt_reached_corner
	lbu	$t0, 0($t0)
	beq	$t0, 1, q4_check_past_corner	# if we're backtracking and we haven't reached the corner yet, we've reached corner
	la	$t0, bt_reached_corner
	li	$t1, 1
	sb	$t1, 0($t0)		# we've reached corner, set bt_reached_corner to true
	# set destX and destY	
	lw	$t0, BOT_X
	la	$t1, backtrack_x
	sw	$t1, 0($t1)
	lw	$t0, BOT_Y
	la	$t1, backtrack_y
	sw	$t1, 0($t1)
	# point to that point
	j	q4_keep_bt

q4_check_past_corner: # backtracking and we've reached the corner
	la	$t0, backtrack_x
	lw	$t0, 0($t0)
	lw	$t1, BOT_X
	bne	$t0, $t1, q4_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	la	$t0, backtrack_y
	lw	$t0, 0($t0)
	lw	$t1, BOT_Y
	bne	$t0, $t1, q4_stop_bt # if we've reached the corner and either x or y has changed, stop backtracking
	j	q4_keep_bt
q4_stop_bt:
	# only do this if we've reached the corner and x and y have changed
	la	$t0, backtrack
	sb	$0, 0($t0)	# backtracking = false
	la	$t0, bt_reached_corner
	sb	$0, 0($t0)	# reached corner = false
q4_keep_bt:

	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	point_to
	j	np_end

q4_op3:
	la	$t0, backtrack
	li	$t1, 1
	sb	$t1, 0($t0)	# backtracking

	move	$a0, $s0	# x
	sub	$a1, $s1, 1	# y - 1
	jal	point_to
	j	np_end

np_end:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, $sp, 16
	jr	$ra
# ================================================================

# *===============================================================
# next_point
# no parameters
# no return
# points the spimbot in the direction of the next pixel along the inner edge of jetstream
circle_black_hole:
	#sub	$sp, $sp, #TODO:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	lw	$s0, BOT_X
	lw	$s1, BOT_Y
	li	$s2, 1

	jal	determine_quad
	beq	$v0, 1, cbh_quad_1
	beq	$v0, 2, cbh_quad_2
	beq	$v0, 3, cbh_quad_3
	beq	$v0, 4, cbh_quad_4
	# we should never get to this point
	# point at point 0,0 to indicate we got here
	move	$a0, $0
	move	$a1, $0
	jal	point_to
	j	cbh_end
cbh_quad_1:
	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	get_value
	# if point to left (x - 1, y) is in jetstream, point at it
	li	$t0, 1
	bne	$v0, $t0, cbh_q1_op2
	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	cbh_end
cbh_q1_op2:	# quadrant 1 option (candidate pixel) 2
	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	point_to
	j	cbh_end

cbh_quad_2:
	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	get_value
	# if point above (x, y - 1) in jetstream, point at it
	li	$t0, 1
	bne	$v0, $t0, cbh_q2_op2
	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	point_to
	j	cbh_end
cbh_q2_op2:	# quadrant 2 option (candidate pixel) 2
	sub	$a0, $s0, $s2	# x - 1
	move	$a1, $s1	# y
	jal	point_to
	j	cbh_end

cbh_quad_3:
	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	get_value
	# if point to right (x + 1, y) is in jetstream, point at it
	li	$t0, 1
	bne	$v0, $t0, cbh_q3_op2
	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	point_to
	j	cbh_end

cbh_q3_op2:	# quadrant 3 option (candidate pixel) 3
	move	$a0, $s0	# x
	sub	$a1, $s1, $s2	# y - 1
	jal	point_to
	j	cbh_end

cbh_quad_4:
	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	get_value
	# if point below (x, y + 1) is in jetstream, point at it
	li	$t0, 1
	bne	$v0, $t0, cbh_q4_op2
	move	$a0, $s0	# x
	add	$a1, $s1, $s2	# y + 1
	jal	point_to
	j	cbh_end
cbh_q4_op2:	# quadrant 4 option (candidate pixel) 2
	add	$a0, $s0, $s2	# x + 1
	move	$a1, $s1	# y
	jal	point_to
	j	cbh_end

cbh_end:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, $sp, 16
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

# *================================================================
# check_need_recovery
check_need_recovery:
        la      $a0, getting_coin
        beq     $a0, 1, check_need_recovery_kill
        
        sub     $sp, $sp, 4       
        sw      $ra, 0($sp)
 
        la      $a0, got_bonked
        lb      $a1, 0($a0) 
        bne     $a1, 1, check_need_recovery_end
        li      $a1, 0
        sb      $a1, 0($a0) 
        #lw      $a0, BOT_X
        #lw      $a1, BOT_Y
        #jal     get_value
        #beq     $v0, 2, check_need_recovery_end
check_need_recovery_go:
        jal     recovery
check_need_recovery_end:
        lw      $ra, 0($sp)
        add     $sp, $sp, 4       
check_need_recovery_kill:
        jr      $ra

# ================================================================

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
        li      $a0, 10
        sw      $a0, VELOCITY
        
recovery_loop:
        lw      $a0, BOT_X      # $s2 = curr.x = bot.x
        lw      $a1, BOT_Y      # $s3 = curr.y = bot.y
        jal     get_value
        beq     $v0, 2, recovery_end 
        j       recovery_loop        
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

# *=====================================================================
# banana_at_point
# $a0 = X
# $a1 = Y
# $v0 = boolean (0 = no banana, 1 = banana)
banana_at_point:
	

        sub     $sp, $sp, 20 
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)

	li      $v0, 0          # default return 0

	la	$s0, radar_flag
	lw	$s1, 0($s0)
	beq	$s1, 2, banana_at_point_done

	la	$s0, radar_map
	lw	$s1, 0($s0)

        
banana_at_point_skip_coins:
	beq	$s1, 0xffffffff, banana_at_point_loop 
	add	$s0, $s0, 4
	lw	$s1, 0($s0)
        j       banana_at_point_skip_coins      

banana_at_point_loop:
	add	$s0, $s0, 4
	lw	$s1, 0($s0)
	beq	$s1, 0xffffffff, banana_at_point_done 
	and	$s2, $s1, 0x0000ffff			#Y value
	and	$s3, $s1, 0xffff0000
	srl	$s3, $s3, 16				#X value
        
        sub     $s3, $a0, $s3           # aX - bX
        sub     $s2, $a1, $s2           # aY - bY
        
        bgt     $s3, 5, banana_at_point_loop
        blt     $s3,-5, banana_at_point_loop
        bgt     $s2, 5, banana_at_point_loop
        blt     $s2,-5, banana_at_point_loop    # no risk if |dist| > 4 on either axis
        
        li      $v0, 1      # if we reach here, banana intersects point 
                 
banana_at_point_done:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        add     $sp, $sp, 20 
        jr      $ra

circular_shift:
	mul	$t0, $a1, 8
	srl	$t1, $a0, $t0
	sub	$t2, $0, $t0
	add	$t2, $t2, 32
	sll	$t2, $a0, $t2
	or	$v0, $t1, $t2
	jr	$ra

inv_byte_substitution:
	li	$t0, 0
	la	$t1, inv_sbox
inv_byte_substitution_for:
	bge	$t0, 16, inv_byte_substitution_end
	add	$t9, $a0, $t0
	lbu	$t9, 0($t9)
	add	$t9, $t1, $t9
	lbu	$t9, 0($t9)
	add	$t8, $a1, $t0
	sb	$t9, 0($t8)
	add	$t0, $t0, 1
	j	inv_byte_substitution_for
inv_byte_substitution_end:
	jr	$ra

key_addition:
	li	$t0, 0
key_addition_for:
	bge	$t0, 16, key_addition_end
	add	$t1, $a0, $t0
	add	$t2, $a1, $t0
	lbu	$t1, 0($t1)
	lbu	$t2, 0($t2)
	xor	$t1, $t1, $t2
	add	$t2, $a2, $t0
	sb	$t1, 0($t2)
	add	$t0, $t0, 1
	j	key_addition_for
key_addition_end:
	jr	$ra

inv_shift_rows:
	#7 saved registers, 20 for stack
	sub	$sp, $sp, 36
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)

	#Assign M
	add	$s0, $sp, 20
	#Assign in
	move	$s1, $a0
	#assign out
	move	$s2, $a1

	move	$a0, $s1
	move	$a1, $s0
	jal	rearrange_matrix

	#Assign I
	move	$s3, $zero
isr_for_loop:
	bge	$s3, 4, isr_end_for

	li	$a1, 4
	sub	$a1, $a1, $s3

	mul	$t0, $s3, 4
	add	$t0, $s0, $t0

	lw	$a0, 0($t0)
	jal	circular_shift

	mul	$t0, $s3, 4
	add	$t0, $s0, $t0
	sw	$v0, 0($t0)

	add	$s3, $s3, 1
	j	isr_for_loop
isr_end_for:
	move	$a0, $s0
	move	$a1, $s2
	jal	rearrange_matrix

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 36
	jr	$ra

inv_mix_column:
	sub	$sp, $sp, 16
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)

	move	$s0, $zero
imc_for_first:
	bge	$s0, 4, imc_for_first_done
	move	$s1, $zero
imc_for_second:
	bge	$s1, 4, imc_for_second_done    

	#store where out[4*k+i] is 
	mul	$t0, $s0, 4    
	add	$t0, $t0, $s1
	add	$s3, $a1, $t0
	sb	$zero, 0($s3)

	move	$s2, $zero
imc_for_third:
	bge	$s2, 4, imc_for_third_done
	mul	$t0, $s2, 256     
	add	$t1, $s1, $s2
	rem	$t1, $t1, 4
	mul	$t2, $s0, 4
	add	$t2, $t2, $t1
	add	$t2, $t2, $a0

	lbu	$t2, 0($t2)

	add	$t0, $t0, $t2
	la	$t4, inv_mix
	add	$t0, $t0, $t4
	lbu	$t0, 0($t0)    

	lb	$t5, 0($s3)
	xor	$t5, $t5, $t0
	sb	$t5, 0($s3)

	add	$s2, $s2, 1
	j	imc_for_third
imc_for_third_done:
	add	$s1, $s1, 1
	j	imc_for_second
imc_for_second_done:
	add	$s0, $s0, 1
	j	imc_for_first
imc_for_first_done:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	add	$sp, $sp, 16
	jr	$ra

rearrange_matrix:
	move	$t0, $zero
rm_for_loop: 
	bge	$t0, 4, rm_end_for_loop

	#pointer to out
	mul	$t1, $t0, 4
	add	$t1, $t1, $a1

	sw	$zero, 0($t1)

	move	$t2, $zero
rm_second_for_loop:
	#load in
	bge	$t2, 4, rm_end_second_for_loop
	mul	$t3, $t2, 4  
	add	$t3, $t3, $t0
	add	$t3, $a0, $t3

	lbu	$t4, 0($t3)         
	mul	$t5, $t2 ,8
	sllv	$t4, $t4, $t5

	lw	$t5, 0($t1)
	or	$t5, $t5, $t4
	sw	$t5, 0($t1)

	add	$t2, $t2, 1
	j	rm_second_for_loop

rm_end_second_for_loop:
	add	$t0, $t0, 1
	j	rm_for_loop
rm_end_for_loop:
	jr	$ra

decrypt:
    # Your code goes here :)
    #There is the stack mem and the saved reg 
    sub $sp, $sp, 100 
 	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)


    #Args, except rounds
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    #stored in s7
    move $s7, $a3

    #A,B,C D loc 
    add $s3, $sp, 36
    add $s4, $sp, 52
    add $s5, $sp, 68
    add $s6, $sp, 84
    
    move $a0, $s0
    mul $t0, $s7,16
    add $a1,$s2 ,$t0
    move $a2, $s5
    jal key_addition

    move $a0, $s5
    move $a1, $s4
    jal inv_shift_rows

    move $a0,$s4
    move $a1,$s3
    jal inv_byte_substitution

    #Rounds - 1
    sub $s7, $s7, 1
decrypt_for_loop:
    ble $s7, 0,decrypt_end_for_loop

    move $a0, $s3
    mul $t0, $s7,16
    add $a1, $s2,$t0
    move $a2, $s6
    jal key_addition

    move $a0, $s6
    move $a1, $s5
    jal inv_mix_column

    move $a0, $s5
    move $a1, $s4
    jal inv_shift_rows

    move $a0,$s4
    move $a1,$s3
    jal inv_byte_substitution

    sub $s7, $s7, 1
    j decrypt_for_loop
decrypt_end_for_loop:

    move $a0, $s3
    move $a1, $s2 
    move $a2, $s1
    jal key_addition    

 	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
    add $sp, $sp, 100 

    jr $ra

###MAX_UNIQUE_N_SUBSTR###
my_strncpy:
	sub	$sp, $sp, 16
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$ra, 12($sp)
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2

	move	$a0, $a1
	jal	my_strlen
	add	$v0, $v0, 1
	bge	$s2, $v0, my_strncpy_if
	move	$v0, $s2
my_strncpy_if:
	li	$t0, 0
my_strncpy_for:
	bge	$t0, $v0, my_strncpy_end
	add	$t1, $s1, $t0
	lb	$t2, 0($t1)
	add	$t1, $s0, $t0
	sb	$t2, 0($t1)
	add	$t0, $t0, 1
	j	my_strncpy_for
my_strncpy_end:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)
	add	$sp, $sp, 16
	jr	$ra

nth_uniq_char:
	bne	$a0, $0, nthPostCond
	bne	$a1, $0, nthPostCond
	li	$v0, -1
	jr	$ra

nthPostCond:
	lbu	$t0, 0($a0)		#*in_str
	la	$t7, uniq_chars		#Start address of uniq_chars
	sb	$t0, 0($t7)		#Stores *in_str in uniq_chars[0]
	li	$t1, 1			#uniq_so_far
	move	$t2, $0			#position = 0
	add	$a0, $a0, 1		#Increments in_str
	
nthWhile:
	bge	$t1, $a1, nthPostWhile	#uniq_so_far < n
	lbu	$t0, 0($a0)		#Get value of *in_str
	beq	$t0, $0, nthPostWhile	#Move on if *in_str is NULL
	li	$t3, 1			#is_uniq = 1
	move	$t4, $0			#j = 0

nthInnerFor:
	bge	$t4, $t1, nthPostFor	#j<uniq_so_far
	add	$t6, $t7, $t4		#Contains address of uniq_chars[j]
	lbu	$t6, 0($t6)		#Value of uniq_chars[j]
	bne	$t6, $t0, nthPostInnerCond
	move	$t3, $0
	j 	nthPostFor

nthPostInnerCond:
	add	$t4, $t4, 1
	j	nthInnerFor

nthPostFor:
	beq	$t3, $0, nthPostSecCond
	add	$t6, $t7, $t1		#Address of uniq_chars[uniq_so_far]
	sb	$t0, 0($t6)		#Stores *in_str in uniq_chars[uniq_so_far]
	add	$t1, $t1, 1		#Increments uniq_so_far

nthPostSecCond:
	add	$t2, $t2, 1		#Increments position
	add	$a0, $a0, 1		#Increments in_str
	j	nthWhile

nthPostWhile:
	bge	$t1, $a1, nthPostFinalCond
	add	$t2, $t2, 1

nthPostFinalCond:
	move	$v0, $t2
	jr	$ra

my_strlen:
	lbu	$t0, 0($a0)		#Get the first char, if null, ret 0
	bne	$t0, $0, msPostCond	#"Base case" of sorts
	move	$v0, $0
	jr	$ra

msPostCond:
	move	$t0, $0			#Count

msWhileLoop:
	lbu	$t1, 0($a0)		#Get current char
	beq	$t1, $0, msPostWhile	#Iterate while string is not null
	add	$t0, $t0, 1
	add	$a0, $a0, 1
	j	msWhileLoop		#Jump to top of while loop
	
msPostWhile:
	move	$v0, $t0
	jr	$ra

max_unique_n_substr:
	bne	$a0, $0, munsPostCond	#Base cases
	bne	$a1, $0, munsPostCond
	bne	$a2, $0, munsPostCond
	jr	$ra

munsPostCond:
	sub	$sp, $sp, 36		#Setup stack pointer
	sw	$ra, 0($sp)		#Save return address
	sw	$s0, 4($sp)		#in_str
	sw	$s1, 8($sp)		#out_str
	sw	$s2, 12($sp)		#n
	sw	$s3, 16($sp)		#max_marker
	sw	$s4, 20($sp)		#len_max
	sw	$s5, 24($sp)		#len_in_str
	sw	$s6, 28($sp)		#cur_pos
	sw	$s7, 32($sp)		#i
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $s0		#max_marker = in_str, SHOULD BE ADDR
	move	$s4, $0			#len_max = 0
	jal	my_strlen		#Calls my_strlen with in_str as $a0
	move	$s5, $v0		#len_in_str = my_strlen(in_str)
	move	$s6, $0			#cur_pos = 0

munsFor:
	bge	$s6, $s5, munsEndFor	#Branch if cur_pos >= len_in_str
	add	$s7, $s0, $s6		#i = in_str + cur_pos
	move	$a0, $s7		#Sets arg0 as i
	add	$a1, $s2, 1		#Sets arg1 as n+1
	jal	nth_uniq_char		#nth_uniq_char(i, n + 1)
	move	$t0, $v0		#len_cur = nth_uniq_char(i, n + 1)
	ble	$t0, $s4, munsPostInnerCond
	move	$s4, $t0
	move	$s3, $s7

munsPostInnerCond:
	add	$s6, $s6, 1
	j	munsFor

munsEndFor:
	move	$a0, $s1
	move	$a1, $s3
	move	$a2, $s4
	jal	my_strncpy
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	add	$sp, $sp, 36
	jr	$ra

###SOLVE PUZZLE###
solve_puzzle:
	sub	$sp, $sp, 36
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)

	li	$s0, 64				#Start index of key
	li	$s1, 208			#Last index of array
	
get_key_loop:
	bge	$s0, $s1, post_get_key
	la	$s2, puzzle_data
	add	$s2, $s2, $s0			#Get address of key char
	lbu	$s2, 0($s2)			#Current char
	la	$s3, puzzle_key
	sub	$s4, $s0, 64			#Get index of puzzle_key
	add	$s3, $s3, $s4			#Address of puzzle_key at index
	sb	$s2, 0($s3)			#Store into puzzle_key
	add	$s0, $s0, 1
	j	get_key_loop

post_get_key:
	la	$s0, puzzle_rounds
	la	$s1, puzzle_data
	lbu	$s1, 208($s1)			#Number of rounds
	sb	$s1, 0($s0)			#Store in puzzle_rounds

	li	$s2, 4				#Num iterations of decrypt
	li	$s3, 0				#Current decrypt iteration

decrypt_loop:
	bge	$s3, $s2, post_decrypt
	la	$s4, puzzle_encrypted
	la	$s6, puzzle_data
	li	$s0, 0
	li	$s1, 16

get_encrypted_loop:
	bge	$s0, $s1, post_get_encrypted
	mul	$s5, $s3, 16			#Offset based on which decrypt iteration
	add	$s5, $s5, $s0
	add	$s5, $s6, $s5			#Address of index of puzzle_data for encrypted
	lbu	$s5, 0($s5)			#Current encrypted character
	add	$s7, $s4, $s0			#Address of puzzle_encrypted at index
	sb	$s5, 0($s7)			#Store encrypted character in puzzle_encrypted
	add	$s0, $s0, 1
	j	get_encrypted_loop

post_get_encrypted:
	la	$a0, puzzle_encrypted
	la	$a1, puzzle_plaintext
	mul	$s7, $s3, 4
	add	$a1, $a1, $s7			#Address of plaintext at current iter offset
	la	$a2, puzzle_key
	la	$a3, puzzle_rounds
	lbu	$a3, 0($a3)
	jal	decrypt

	add	$s3, $s3, 1
	j	decrypt_loop

post_decrypt:
	la	$a0, puzzle_plaintext
	la	$a1, puzzle_solution
	la	$a2, puzzle_data
	lw	$a2, 212($a2)			#n
	jal	max_unique_n_substr		#Solution should be written to puzzle_solution

	la	$s0, puzzle_solution
	sw	$s0, SUBMIT_SOLUTION
	lw	$s2, MUSHROOM
	lw	$s3, BANANA

	la	$s0, puzzle_flag
	sb	$0, 0($s0)

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	add	$sp, $sp, 36

	jr	$ra

# ======================================================================

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

	and	$a0, $k0, REQUEST_PUZZLE_INT_MASK
	bne	$a0, $0, puzzle_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

radar_interrupt:
        sw      $a1, REQUEST_RADAR_ACK 
	li	$a0, 1
	la	$a1, radar_flag
	sb	$a0, 0($a1)
        j       interrupt_dispatch               # go back to handler

bonk_interrupt:
        sw      $a1, BONK_ACK
        la      $a1, got_bonked
        li      $a0, 1
        sb      $a0, 0($a1)
	lw	$a0, MUSHROOM
	blt	$a0, 1, bonk_intr_no_mushroom
	sw	$0, MUSHROOM
bonk_intr_no_mushroom:
        j       interrupt_dispatch       # see if other interrupts are waiting
      
timer_interrupt:
	sw	$a1, TIMER_ACK		# acknowledge interrupt
	j	interrupt_dispatch	# see if other interrupts are waiting

puzzle_interrupt:
	sw	$a1, REQUEST_PUZZLE_ACK

	la	$a0, puzzle_flag		#Set puzzle flag as 1
	li	$a1, 1
	sb	$a1, 0($a0)

	j	interrupt_dispatch

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
