#
#
#

#Check if firstnum value entered is a number
while True:
    try:
        firstnum = int(input("Enter first number:"))
    except ValueError:
        print("Please enter a number.")
        continue
    else:
        #firstnum was successfully parsed!
        #exit loop
        break

#Check if secondnum value entered is a number
while True:
    try:
        secondnum = int(input("Enter second number:"))
    except ValueError:
        print("Please enter a number.")
        continue
    else:
        #firstnum was successfully parsed!
        #exit loop
        break
 
# Compairison Evaluation 
if firstnum > secondnum:
    print(str(firstnum) + " is greater than " + str(secondnum) + " !")
elif firstnum < secondnum:
    print(str(firstnum) + " is less than " + str(secondnum) + " !")
else:
    print( str(firstnum) + " and " + str(secondnum) + " are equal." )
