.data

.text

## void
## decrypt(unsigned char *ciphertext, unsigned char *plaintext, unsigned char *key,
##         unsigned char rounds) {
##     unsigned char A[16], B[16], C[16], D[16];
##     key_addition(ciphertext, &key[16 * rounds], C);
##     inv_shift_rows(C, (unsigned int *) B);
##     inv_byte_substitution(B, A);
##     for (unsigned int k = rounds - 1; k > 0; k--) {
##         key_addition(A, &key[16 * k], D);
##         inv_mix_column(D, C);
##         inv_shift_rows(C, (unsigned int *) B);
##         inv_byte_substitution(B, A);
##     }
##     key_addition(A, key, plaintext);
##     return;
## }

.globl decrypt
decrypt:
	sub	$sp, $sp, 16		#Stack sub for arrays
	move	$s0, $sp		#&A[0]
	sub	$sp, $sp, 16
	move	$s1, $sp		#&B[0]
	sub	$sp, $sp, 16
	move	$s2, $sp		#C[0]
	sub	$sp, $sp, 16
	move	$s3, $sp		#D[0]

	sub	$sp, $sp, 20		#"Normal" stack stuff
	sw	$ra, 0($sp)
	sw	$s4, 4($sp)		#Store plaintext, ciphertext not stored
	sw	$s5, 8($sp)		#key
	sw	$s6, 12($sp)		#rounds w/ padding
	sw	$s7, 16($sp)		#k
	move	$s4, $a1
	move	$s5, $a2
	move	$s6, $a3
	move	$s7, $0
	
	mul	$t0, $s6, 16		#16 * rounds
	add	$t0, $s5, $t0		#&key[16*k]
	move	$a1, $t0
	move	$a2, $s2
	jal	key_addition

	move	$a0, $s2
	move	$a1, $s1
	jal	inv_shift_rows

	move	$a0, $s1
	move	$a1, $s0
	jal	inv_byte_substitution

	sub	$s7, $s6, 1		#k = round - 1

for:
	ble	$s7, $0, postFor
	move	$a0, $s0
	mul	$t0, $s7, 16		#16 * k
	add	$t0, $t0, $s5		#&key[16*k]
	move	$a1, $t0
	move	$a2, $s3
	jal	key_addition

	move	$a0, $s3
	move	$a1, $s2
	jal	inv_mix_column

	move	$a0, $s2
	move	$a1, $s1
	jal	inv_shift_rows

	move	$a0, $s1
	move	$a1, $s0
	jal	inv_byte_substitution

	sub	$s7, $s7, 1		#k--
	j	for

postFor:
	move	$a0, $s0
	move	$a1, $s5
	move	$a2, $s4
	jal	key_addition

	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s5, 8($sp)
	lw	$s6, 12($sp)
	lw	$s7, 16($sp)
	add	$sp, $sp, 20

	add	$sp, $sp, 64

	r	$ra
