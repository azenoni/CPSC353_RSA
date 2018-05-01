import random
# Prime p = 719
# Primitive root a = 11
# Private key A = 697
# Public key B = 614

def sign_message(m, p=719, a=11, A=697):
	s = 0
	while s == 0:
		k = 1
		while gcd(k,p-1) != 1:
			k = random.randint(1,p-1)
		r = a.powermod(k,p)
		k_inv = inverse_mod(k, p-1)
		s = mod(k_inv*(m - A*r),p-1)
	# if s = 0, start over 
	return r, s

def verify(r,s,m,B,a=11):
	if r < p:
		v1 = a.powermod(m,p)
		v2 = mod(B.powermod(r,p)*r.powermod(s,p),p)
		if v1 == v2:
			return True
	return False
