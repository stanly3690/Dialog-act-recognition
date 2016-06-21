import sys

#usage : python accuracy.py <file>

f1 = open(sys.argv[1])

count = 0
true = 0
false = 0
sentences = 0
for line in f1:
	if line == '\n': #or line.split()==[]:
		sentences+=1
		continue
	count = count + 1
	x = line.strip().split()
	if(x[-1]==x[-2]):
		true=true+1
	else:
		false = false+1

#print '#true', '#false', '#total_words', '#sentences'
print '#correctly tagged words:', true
print '#incorrectly tagged words:', false

print '#total words', count
print '#total sentences', sentences
#print true, false, count, sentences

print 'Accuracy = ', (100.0*true/count)

f1.close()
