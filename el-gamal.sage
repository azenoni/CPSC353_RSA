import random
# Prime p = 1983499883
# Primitive root a = 48651
# Private key A = 1042187964
# Public key B = 1918098439

def sign_message(m, p=1983499883, a=48651, A=1042187964):
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

def verify(r,s,m,a=48651,B=1918098439):
	if r < p:
		v1 = a.powermod(m,p)
		v2 = mod(B.powermod(r,p)*r.powermod(s,p),p)
		if v1 == v2:
			return True
	return False
