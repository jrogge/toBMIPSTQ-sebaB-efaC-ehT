.text

## void
## max_unique_n_substr(char *in_str, char *out_str, int n) {
##     if (!in_str || !out_str || !n)
##         return;
## 
##     char *max_marker = in_str;
##     unsigned int len_max = 0;
##     unsigned int len_in_str = my_strlen(in_str);
##     for (unsigned int cur_pos = 0; cur_pos < len_in_str; cur_pos++) {
##         char *i = in_str + cur_pos;
##         int len_cur = nth_uniq_char(i, n + 1);
##         if (len_cur > len_max) {
##             len_max = len_cur;
##             max_marker = i;
##         }
##     }
## 
##     my_strncpy(out_str, max_marker, len_max);
## }

.globl max_unique_n_substr
max_unique_n_substr:
	bne	$a0, $0, postCond	#Base cases
	bne	$a1, $0, postCond
	bne	$a2, $0, postCond
	jr	$ra

postCond:
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

for:
	bge	$s6, $s5, endFor	#Branch if cur_pos >= len_in_str
	add	$s7, $s0, $s6		#i = in_str + cur_pos
	move	$a0, $s7		#Sets arg0 as i
	add	$a1, $s2, 1		#Sets arg1 as n+1
	jal	nth_uniq_char		#nth_uniq_char(i, n + 1)
	move	$t0, $v0		#len_cur = nth_uniq_char(i, n + 1)
	ble	$t0, $s4, postInnerCond
	move	$s4, $t0
	move	$s3, $s7

postInnerCond:
	add	$s6, $s6, 1
	j	for

endFor:
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
