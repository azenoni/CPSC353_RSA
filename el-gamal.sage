def key_gen(p=1983499883, a=48651):
	secret_key = random_between(1,p-2)
	private_key = mod(a^secret_key,p)