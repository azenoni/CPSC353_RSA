def key_gen(p=1983499883, a=48651):
	secret_key = random_between(1,p-2)
	public_key = mod(a^secret_key,p)
	return public_key, secret_key

def sign_message(m, p=1983499883,a=48651):
	k = 1
	while gcd(k,p-1) != 1:
		k = random_between(1,p-1)
	r = mod(a^k,p)
	y, x = key_gen()
	#compute s, s (cong) (H(m) - xr)k^(-1) mod (p-1) 
	#[H is apparantly a "collision-resistant hash function", may be: "H(m) (cong) xr + sk mod (p-1)"]
	#if s=0, start over