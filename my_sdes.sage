from operator import xor
load("convert.sage")

# Sbox definitions
s0 = ([[1, 0, 3, 2],
      [3, 2, 1, 0],
      [0, 2, 1, 3],
      [3, 1, 3, 2]])

s1 = ([[0, 1, 2, 3],
      [2, 0, 1, 3],
      [3, 0, 1, 0],
      [2, 1, 0, 3]])        

def encrypt(m, k):
    k0, k1 = _generate_keys(k)
    encrypted = cipher_blockchain(m,k0,k1)
    return encrypted
    
def decrypt(c, k):
    k0, k1 = _generate_keys(k)
    decrypted = cipher_blockchain(m,k0,k1)
    return decrypted

# Helper functions to use in the cipher blockchaining
# m is cipher message, k0 k1 are keys
def cipher_blockchain(m,k0,k1):
  encrypted_message = []
  #assuming m is a string of characters
  for i in m:
    num = txt_to_num(i)
    encrypted_message.append(_encrypt_single(_tobits(num,8),k0,k1))
  enc = []
  #print encrypted_message
  tmp = []
  for i in encrypted_message:
    for j in i:
      tmp.append(j)
  for i in encrypted_message:
    enc.append(_frombits(i))

  #print "tmp is:", tmp
  otherTMP = _frombits(tmp)
  #print num_to_txt(otherTMP)
  #print enc
  encrypted_message = []
  for i in enc:
    #print i
    encrypted_message.append(num_to_txt(i))
  return encrypted_message
  

# Perform SDES encryption on one 8-bit element
def _encrypt_single(x, k0, k1):
  
  # Permute bits of plain text
  x = _permute(x)

  # split message into left and right chunks
  l = x[0:4]
  r = x[4:8]

  # Perform first feistal function
  feistal1 = _feistal(k0,r)

  # Build next layer with swap

  # Build the r next
  r_next = []
  for i in range(4):
    r_next.append(xor(l[i], feistal1[i]))

  # set the next l
  l_next = r

  # Step 4: perform second feistal function
  feistal2 = _feistal(k1,r_next)

  # build final l
  l_final = []
  for i in range(4):
    l_final.append(xor(l_next[i], feistal2[i]))

  # set the final r
  r_final = r_next

  # step 5: return inverse permutation of combination of l_final and r_final
  return _inv_permute(l_final + r_final)

# Perform SDES decryption on one 8-bit element
def _decrypt_single(y, k0, k1):

  #Step 1: Permute text
  y = _permute(y)

  # split message into left and right chunks
  l = y[0:4]
  r = y[4:8]

  # Perform a feistal function with second key
  feistal1 = _feistal(k1, r)

  # create the next l
  r_next = []
  for i in range(4):
    r_next.append(xor(l[i], feistal1[i]))

  # set next r
  l_next = r

  # Perform second feistal function with first key
  feistal2 = _feistal(k0, r_next)

  # Build the final l
  l_final = []
  for i in range(4):
    l_final.append(xor(l_next[i], feistal2[i]))

  # set the last r
  r_final = r_next

  # Step 5: return inverse permutation of combined l and r
  return _inv_permute(l_final + r_final)


# rotate bits as specified by definition
def _permute(pt):
  permuted = []
  permuted.append(pt[1])
  permuted.append(pt[5])
  permuted.append(pt[2])
  permuted.append(pt[0])
  permuted.append(pt[3])
  permuted.append(pt[7])
  permuted.append(pt[4])
  permuted.append(pt[6])
  return permuted

# rotate bits as specified by definition
def _inv_permute(ct):
  permuted = []
  permuted.append(ct[3])
  permuted.append(ct[0])
  permuted.append(ct[2])
  permuted.append(ct[4])
  permuted.append(ct[6])
  permuted.append(ct[1])
  permuted.append(ct[7])
  permuted.append(ct[5])
  return permuted

# Pass in 8-bits, and 4-bits respectively
def _feistal(key, r):
    # create matricies
    n = ([[r[3],r[0],r[1],r[2]], 
        [r[1],r[2],r[3],r[0]]])

    k = ([[key[0],key[1],key[2],key[3]],
          [key[4],key[5],key[6],key[7]]])

    # xor the n and k matricies
    p = ([[xor(n[0][0], k[0][0]), xor(n[0][1], k[0][1]), xor(n[0][2], k[0][2]), xor(n[0][3], k[0][3])],
          [xor(n[1][0], k[1][0]), xor(n[1][1], k[1][1]), xor(n[1][2], k[1][2]), xor(n[1][3], k[1][3])]])

    # perform operations for s box 0
    first_bits = [p[0][0], p[0][3]]
    first_out = _frombits(first_bits)
    second_bits = [p[0][1], p[0][2]]
    second_out = _frombits(second_bits)
    s_0 = s0[first_out][second_out]

    # perform operations for s box 1
    first_bits = [p[1][0], p[1][3]]
    first_out = _frombits(first_bits)
    second_bits = [p[1][1], p[1][2]]
    second_out = _frombits(second_bits)
    s_1 = s1[first_out][second_out]

    # convert back to bits
    s_0_bits = _tobits(s_0,2)
    s_1_bits = _tobits(s_1,2)

    # combine s box return values for return
    s_combined = s_0_bits + s_1_bits
    return [s_combined[1],s_combined[3],s_combined[2],s_combined[0]]

def _generate_keys(k10):
    # Convert key to bits and truncate 
    key = format(k10, '#012b')[2:]
    # Create array of bits for 10 bit key
    key_b = [int(digit) for digit in key]

    # Follow initial permutation
    p10 = [2, 4, 1, 6, 3, 9, 0, 8, 7, 5]
    key_perm = [0] * 10
    for i in range(10):
        key_perm[i] = key_b[p10[i]]
    
    # Create key 0 and key 1
    k0 = list(key_perm)
    k1 = list(key_perm)

    # Rotate bits of key 0 left
    k0[0:5] = k0[1:5] + [k0[0]]
    k0[5:10] = k0[6:10] + [k0[5]]

    # Rotate bits of key 0 left twice to get key 1
    k1[0:5] = k0[2:5] + k0[0:2]
    k1[5:10] = k0[7:10] + k0[5:7]

    # Follow second permutation
    p8 = [5, 2, 6, 3, 7, 4, 9, 8]
    k0p = [0] * 8 # Permuted keys
    k1p = [0] * 8
    for i in range(8):
        k0p[i] = k0[p8[i]]
        k1p[i] = k1[p8[i]]

    # return keys as a tuple
    return k0p, k1p

# Helper function to convert numeric value to a list of bits
# Assumes bit length is less than or equal to 10
def _tobits(num,bit_length):
    # Convert num to bits and truncate "0b" header and leading 6 bits
    num = format(num, '#012b')[(12-bit_length):]
    # Convert from bit string to integer list
    return [int(digit) for digit in num]

# Find the numeric value contained by a list of bits by adding
# 2^i for each i position that is 1
def _frombits(bits):
    num = 0
    for i in range(len(bits)):
        if int(str(bits[-(i+1)])) == 1:
            num = num + (2 ** (i)) 
    return num