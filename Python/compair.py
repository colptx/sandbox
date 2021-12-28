def main():
    #Check if firstNum value entered is a number
    while True:
        try:
            firstNum = int(input("Enter first number:"))
        except ValueError:
            print("Please enter a number.")
            continue
        else:
            #firstNum was successfully parsed!
            #exit loop
            break

    #Check if secondNum value entered is a number
    while True:
        try:
            secondNum = int(input("Enter second number:"))
        except ValueError:
            print("Please enter a number.")
            continue
        else:
            #firstNum was successfully parsed!
            #exit loop
            break
    
    # Compairison Evaluation 
    if firstNum > secondNum:
        print(f"{firstNum} is greater than {secondNum}!")
    elif firstNum < secondNum:
        print(f"{firstNum} is less than {secondNum}!")
    else:
        print(f"{firstNum} and {secondNum} are equal.")

if __name__ == '__main__':
    main()