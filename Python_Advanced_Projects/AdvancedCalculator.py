#Calculator
import math

memory = 0;
while True:
    print("Welcome to the Advanced Calculator!")
    
    #Let the user input the two numbers
    num1 = float(input("Enter a number: "))
    num2 = float(input("Enter another number: "))
    
    #There are two diff types of things the user can do. Let them pick if they want to simply use a normal calculator or have their two values be compared
    types = str(input("Do you want to perform an arithmetic operation (A), or compare two values (C)? "))
    
    #Depending on which type the user has chosen, have them choose an operator and perform the action
    storenum = 0
    if(types == "A"):
        arithemeticOP = str(input("Choose an arithmetic operator: (+, -, *, /, ^, %1/%2/%12 (meaning finding the percentage of the first, second, or both numbers), mod (meaning finding the remainder of the two numbers divided), and sqrt1/sqrt2/sqrt12 (meaning finding the square root of the first, second, or both numbers)) "))
        if(arithemeticOP == "+"):
            storenum = (num1 + num2)
            print(storenum)
        elif(arithemeticOP == "-"):
            storenum = (num1 - num2)
            print(storenum)
        elif(arithemeticOP == "*"):
            storenum = (num1 * num2)
            print(storenum)            
        elif(arithemeticOP == "/"):
            storenum = (num1 / num2)
            print(storenum)  
        elif(arithemeticOP == "^"):
            storenum = (num1 ** num2)
            print(storenum)   
        elif(arithemeticOP == "%1"):
            storenum = int(num1)
            print(str(int(num1)) + "%")
        elif(arithemeticOP == "%2"):
            storenum = int(num2)            
            print(str(int(num2)) + "%")
        elif(arithemeticOP == "%12"):
            storenum = int(num2)
            print(str(int(num1)) + "%")
            print(str(int(num2)) + "%")
        elif(arithemeticOP == "mod"):
            storenum = (num1 % num2)
            print(storenum)
        elif(arithemeticOP == "sqrt1"):
            storenum = (math.sqrt(num1))
            print(storenum)            
        elif(arithemeticOP == "sqrt2"):
            storenum = (math.sqrt(num2))
            print(storenum)        
        elif(arithemeticOP == "sqrt12"):
            storenum = (math.sqrt(num2))
            print(math.sqrt(num1))
            print(math.sqrt(num2))
    elif(types == "C"):
        compareOP = str(input("Choose a comparision operator: (==, >, <, >=, <=, and !=) "))
        if(compareOP == "=="):
            if(num1 == num2):
                print(True)
            else:
                print(False)
        elif(compareOP == ">"):
            if(num1 > num2):
                print(True)
            else:
                print(False)
        elif(compareOP == "<"):
            if(num1 < num2):
                print(True)
            else:
                print(False)
        elif(compareOP == ">="):
            if(num1 >= num2):
                print(True)
            else:
                print(False)
        elif(compareOP == "<="):
            if(num1 <= num2):
                print(True)
            else:
                print(False)   
        elif(compareOP == "!="):
            if(num1 != num2):
                print(True)
            else:
                print(False)
    else:
        print("Sorry, I think you clicked something we couldn't register.")
        again = str(input("Do you want to try again? (y/n) "))
        if(again == "y"):
            continue;
        else:
            print("Hope you had fun! Bye!")
            break;        
    
    #Memory function code
    types = str(input("Do you want to temporarily want to store a number for later use in calculations? (y/n)"))
    if(types == "y"):
        memoryOP = str(input("Choose a memory operator: (Memory Clear (Start from 0/Completely clear out the memory)(MC), Memory Store (Store the value of the output of the calculations you have previously done)(MS), Memory Store: value (Store a number of your choice to start off with in the memory)(MSN), Add to Memory (M+), Subtract from Memory (M-), and Memory Recall(Show the value currently stored in memory)(MR)) "))   
        if(memoryOP == "MSN"):
            num = float(input("Enter a number: "))
        if(memoryOP == "MC"):
            memory = 0
        elif(memoryOP == "MSN"):
            memory = num
        elif(memoryOP == "MS"):
            memory = storenum
            storenum = 0;
        elif(memoryOP == "M+"):
            memory = memory + storenum
            storenum = 0;
        elif(memoryOP == "M-"):
            memory = memory - storenum
            storenum = 0;
        elif(memoryOP == "MR"):
            print(memory)
    
    #If the user wants to play again
    again = str(input("Do you want to play again? (y/n) "))    
    if(again == "y"):
        continue;
    else:
        print("Hope you had fun! Bye!")
        break;