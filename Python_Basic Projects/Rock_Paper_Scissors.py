import random

CompScore = 0
MyScore = 0
Playing = 1

while(Playing == 1):
	MyChoice = input("Rock, Paper, or Scissors (Choose R, P, or S): ")
	
	Rand = random.randint(1, 3)
	
	if Rand == 1:
		CompChoice = "Rock"
	if Rand == 2:
		CompChoice = "Paper"
	if Rand == 3:
		CompChoice = "Scissors"
	
	print("The computer’s choice is ", CompChoice)
	
	if MyChoice == "R":
		if Rand == 1:
			print("It’s a tie!")
			MyScore = MyScore + 1/2
			CompScore = CompScore + 1/2
		if Rand == 2:
			print("The computer wins")
			CompScore = CompScore + 1
		if Rand == 3:
			print("You win")
			MyScore = MyScore + 1
	if MyChoice == "P":
		if Rand == 2:
			print("It’s a tie!")
			MyScore = MyScore + 1/2
			CompScore = CompScore + 1/2
		if Rand == 3:
			print("The computer wins")
			CompScore = CompScore + 1
		if Rand == 1:
			print("You win")
			MyScore = MyScore + 1
	if MyChoice == "S":
		if Rand == 3:
			print("It’s a tie!")
			MyScore = MyScore + 1/2
			CompScore = CompScore + 1/2
		if Rand == 1:
			print("The computer wins")
			CompScore = CompScore + 1
		if Rand == 2:
			print("You win")
			MyScore = MyScore + 1    
	Playing = int(input("Enter in 1 if you would like to continue playing. Enter in 0 if you wish to stop: "))
	if Playing == 0:
		print("This is your score, ", MyScore, ".", "This is the computer's score, ", CompScore, ".")	