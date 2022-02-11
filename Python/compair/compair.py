def main():
    #Check if firstNum value entered is a number
    while True:
        try:
            first_num = int(input("Enter first number:"))
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
            second_num = int(input("Enter second number:"))
        except ValueError:
            print("Please enter a number.")
            continue
        else:
            #firstNum was successfully parsed!
            #exit loop
            break
    
    # Compairison Evaluation 
    if first_num is second_num:
        print(f"{first_num} and {second_num} are equal.")
    elif first_num < second_num:
        print(f"{first_num} is less than {second_num}!")
    else:
        print(f"{first_num} is greater than {second_num}!")

if __name__ == '__main__':
    main()