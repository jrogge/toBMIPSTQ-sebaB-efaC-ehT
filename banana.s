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

	la	$s0, radar_map
	lw	$s1, 0($s0)

        
banana_at_point_skip_coins:
	beq	$s1, 0xffffffff, banana_at_point_loop 
	add	$s0, $s0, 4
	lw	$s1, 0($s0)
        j       banana_at_point_skip_coins      
        
banana_at_point_loop:
	beq	$s1, 0xffffffff, banana_at_point_done 
	and	$s2, $s1, 0x0000ffff			#Y value
	and	$s3, $s1, 0xffff0000
	srl	$s3, $s3, 16				#X value
        
        sub     $s3, $a0, $s3           # aX - bX
        sub     $s2, $a1, $s2           # aY - bY
        
        bgt     $s3, 4, banana_at_point_loop
        blt     $s3,-4, banana_at_point_loop
        bgt     $s2, 4, banana_at_point_loop
        blt     $s2,-4, banana_at_point_loop    # no risk if |dist| > 4 on either axis
        
        li      $v0, 1      # if we reach here, banana intersects point 
                 
banana_at_point_done:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        add     $sp, $sp, 20 
        jr      $ra
# ======================================================================
