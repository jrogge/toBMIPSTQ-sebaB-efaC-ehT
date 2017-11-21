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
        sub     $sp, $sp,36
        sw      $ra, 0($sp)

        sw      $s0, 4($sp)     # s register saving
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s6, 28($sp)
        sw      $s7, 32($sp)

        move    $s0, $a0        # hold onto parameters
        move    $s1, $a1
        move    $s2, $a2
        move    $s3, $a3

        sub     $sp, $sp, 16    # allocate arrays on stack
        move    $s4, $sp        # $s4 = A
        sub     $sp, $sp, 16
        move    $s5, $sp        # $s5 = B
        sub     $sp, $sp, 16
        move    $s6, $sp        # $s6 = C
        sub     $sp, $sp, 16
        move    $s7, $sp        # $s7 = D

                                # key_addition(ciphertext, &key[16 * rounds], C)
                                # a0 is already what it should be
        mul     $a1, $s3, 16    # 16 * rounds
        add     $a1, $a1, $s2   # &key[16 * rounds]
        move    $a2, $s6
        jal     key_addition
        
        move    $a0, $s6        # inv_shift_rows(C, (unsigned int *) B);
        move    $a1, $s5
        jal     inv_shift_rows

        move    $a0, $s5        # inv_byte_substitution(B, A);
        move    $a1, $s4
        jal     inv_byte_substitution
        
                                # for (unsigned int k = rounds - 1; k > 0; k--){
        #sub     $sp, $sp, 4    # we have run out of registers, reuse s0*
        #sw      $s0, 0($sp)    # *don't do this because we never need s3 again

        sub     $s3, $s3, 1     # $s3 = k = rounds - 1
d_for_loop:
        ble     $s3, $0, end_loop
        
        move    $a0, $s4        # key_addition(A, &key[16 * k], D);
        mul     $a1, $s3, 16    # 16 * rounds
        add     $a1, $a1, $s2   # &key[16 * rounds]
        move    $a2, $s7
        jal     key_addition

        move    $a0, $s7        # inv_mix_column(D, C);
        move    $a1, $s6
        jal     inv_mix_column

        move    $a0, $s6        # inv_shift_rows(C, (unsigned int *) B);
        move    $a1, $s5
        jal     inv_shift_rows

        move    $a0, $s5        # inv_byte_substitution(B, A);
        move    $a1, $s4
        jal     inv_byte_substitution

        sub     $s3, $s3, 1
        j       d_for_loop
end_loop:
        move    $a0, $s4        # key_addition(A, key, plaintext);
        move    $a1, $s2
        move    $a2, $s1
        jal     key_addition

        add     $sp, $sp, 64    # deallocate arrays

        lw      $ra, 0($sp)     # restore ra
        lw      $s0, 4($sp)     # restore s registers
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        lw      $s6, 28($sp)
        lw      $s7, 32($sp)
        add     $sp, $sp, 36

    jr $ra
