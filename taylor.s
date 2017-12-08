.data
three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0
	
.text


# -----------------------------------------------------------------------
# sb_cos: computes a * cos(x)
# $a0 = x
# $a1 = a
# returns the cosine
# -----------------------------------------------------------------------
sb_cos:
        sub     $sp, $sp, 12
	sw	$ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)

	# NOTE: below is not a mix up. It makes more sense for mult to be s0 and a1
	move	$s0, $a1
	move	$s1, $a0

        mtc1,   $s0, $f0	# mult factor
        mtc1,   $s1, $f1        # angle

        cvt.s.w $f0, $f0
        cvt.s.w $f1, $f1

	# convert to radians
	l.s	$f2, F180	# load 180.0
	div.s	$f1, $f1, $f2	# value / 180
	l.s	$f2, PI		# load PI
	mul.s	$f1, $f1, $f2	# PI * value / 180.0

	mul.s	$f1, $f1, $f1	# $f1 = v^^2
	mul.s	$f2, $f1, $f1	# $f2 = v^^4
	mul.s	$f3, $f1, $f2	# $f3 = v^^6
	mul.s	$f4, $f1, $f3	# $f4 = v^^8
	mul.s	$f5, $f1, $f4	# $f4 = v^^10

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
	add.s	$f1, $f1, $f2	# 1 - X^^2/2! + x^^4/4! - x^^6/6!
	add.s	$f1, $f1, $f4	# 1 - X^^2/2! + x^^4/4! - x^^6/6! + x^^8/8! - x^^10/10!

        mul.s   $f0, $f0, $f1   # a * (1 - X^^2/2! + x^^4/4! - x^^6/6! + x^^8/8! - x^^10/10!)

        cvt.w.s $f0, $f0
        mfc1    $v0, $f0

	lw	$ra, 0($sp)
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
	sw	$ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)

	# NOTE: below is not a mix up. It makes more sense for mult to be s0 and a1
	move	$s0, $a1
	move	$s1, $a0

        mtc1,   $s0, $f0	# mult factor
        mtc1,   $s1, $f1        # angle

        cvt.s.w $f0, $f0
        cvt.s.w $f1, $f1

	# convert to radians
	l.s	$f2, F180	# load 180.0
	div.s	$f1, $f1, $f2	# value / 180
	l.s	$f2, PI		# load PI
	mul.s	$f1, $f1, $f2	# PI * value / 180.0

	#mul.s	$f1, $f1, $f1	# $f1 = v
	mul.s	$f6, $f1, $f1	# v^^2
	mul.s	$f2, $f1, $f6	# $f2 = v^^3
	mul.s	$f3, $f2, $f6	# $f3 = v^^5
	mul.s	$f4, $f3, $f6	# $f4 = v^^7
	mul.s	$f5, $f4, $f6	# $f4 = v^^9

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
	add.s	$f1, $f1, $f3	# x - X^^3/3! + x^^5/5! - x^^7/7!
	add.s	$f1, $f1, $f5	# x - X^^3/3! + x^^5/5! - x^^7/7! + x^^9/9!

        mul.s   $f0, $f0, $f1   # a * (x - X^^3/3! + x^^5/5! - x^^7/7! + x^^9/9!)

        cvt.w.s $f0, $f0
        mfc1    $v0, $f0

	lw	$ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        add     $sp, $sp, 12
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
	

# -----------------------------------------------------------------------
# euclidean_dist - computes sqrt(x^2 + y^2)
# $a0 - x
# $a1 - y
# returns the distance
# -----------------------------------------------------------------------

euclidean_dist:
	mul	$a0, $a0, $a0	# x^2
	mul	$a1, $a1, $a1	# y^2
	add	$v0, $a0, $a1	# x^2 + y^2
	mtc1	$v0, $f0
	cvt.s.w	$f0, $f0	# float(x^2 + y^2)
	sqrt.s	$f0, $f0	# sqrt(x^2 + y^2)
	cvt.w.s	$f0, $f0	# int(sqrt(...))
	mfc1	$v0, $f0
	jr	$ra


# -----------------------------------------------------------------------
# Test code for Arctangent infinite series approximation example
# -----------------------------------------------------------------------

# This test code calls the sb_arctan code with some constants.  With
# an X value that is twice the Y value, the approximate algorithm
# computes 26 degrees (an exact algorithm would have gotten 26.56
# degrees).

.data
thirty:	 .word 30
sixty:	 .word 60
hundred: .word 100
endl:	 .asciiz "\n"
xequals: .asciiz "x="
yequals: .asciiz ", y="
expect:	.asciiz ".  Expected: "
yougot:	.asciiz ", got: "
ystring:
	.word	30	52	30	5	-2	-170	-35	0	2
xstring:
	.word	0	30	45	60	90	120	135	150	180
answers:
	.word	100	86	70	50	0	-50	-70	-86	-100

PRINT_INT = 0xffff0080

.text
main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)		# save return address on stack

	li	$s0, 0
testloop:				# calls user procedure eight times, twice for each quadrant
	move	$a0, $s0
	jal	test2
	add	$s0, $s0, 1
	bne	$s0, 8, testloop

	jal	test_euclidean_dist

	lw	$ra, 0($sp)		# restore return address
	add	$sp, $sp, 4		# fixup stack
	jr	$ra			# return

test2:
	sub	$sp, $sp, 12	#calling conventions
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	mul	$t0, $a0, 4	#calculate argument array offset
	
	la	$t2, xstring
	add	$t2, $t2, $t0
	lw	$s0, 0($t2)	#load x
	
	la	$t2, ystring
	add	$t2, $t2, $t0
	lw	$s1, 0($t2)	#load y
	
	la	$a0, xequals	#print "x="
	li	$v0, 4
	syscall

	move	$a0, $s0	#print x
	li	$v0, 1
	syscall
	
	la	$a0, yequals	#print "y="
	li	$v0, 4
	syscall

	move	$a0, $s1	#print y
	li	$v0, 1
	syscall
	
	la	$a0, expect	
	li	$v0, 4
	syscall

	la	$t2, answers	#print reference answer
	add	$t2, $t2, $t0
	lw	$a0, 0($t2)
	li	$v0, 1
	syscall
		
	la	$a0, yougot
	li	$v0, 4
	syscall

	move	$a0, $s0	#call user procedure
	li	$a1, 100
	#move	$a1, $s1
	#jal	sb_arctan
	jal	sb_cos
	move	$a0, $v0
	li	$v0, 1
	syscall			#print calculated answer
	
	la	$a0, endl	#print newline
	li	$v0, 4
	syscall
	
	lw	$s0, 4($sp)	#restore stack
	lw	$ra, 0($sp)
	add	$sp, $sp, 12
	jr	$ra

test_euclidean_dist:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)

	li	$a0, 3
	li	$a1, 4
	jal	euclidean_dist
	sw	$v0, PRINT_INT	# should print 5

	li	$a0, -5
	li	$a1, -12
	jal	euclidean_dist
	sw	$v0, PRINT_INT	# should print 13

	li	$a0, 32
	li	$a1, -64
	jal	euclidean_dist
	sw	$v0, PRINT_INT	# should print 71

	li	$a0, -150
	li	$a1, 150
	jal	euclidean_dist
	sw	$v0, PRINT_INT	# should print 212

	lw	$ra, 0($sp)
	jr	$ra

