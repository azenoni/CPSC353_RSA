secret_key_bob = 3
secret_key_alice = 4

def compute_alice(p=1983499883,a=48651):
	return mod(a^secret_key_alice,p)

def compute_bob(p=1983499883, a=48651):
	return mod(a^secret_key_bob, p)

def compute_shared_alice(shared_val,p=1983499883):
	return mod(shared_val^secret_key_alice, p)

def compute_shared_bob(shared_val,p=1983499883):
	return mod(shared_val^secret_key_bob ,p)
