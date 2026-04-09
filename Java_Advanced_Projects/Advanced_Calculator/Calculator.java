package Java_Advanced_Projects.Advanced_Calculator;
import java.util.*;

public class Calculator {
    // Global memory storage that persists across calculations
    private static ArrayList<Double> memory = new ArrayList<Double>();

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        boolean continueProgram = true;
        System.out.println("Welcome to your very own calculator!");
        while (continueProgram) {
            System.out.println(
                    "This calculator can perform a variety of functions, including arithmetic calculations, comparisons, and memory storage.");
            System.out.println();

            // Let the user input the two numbers
            double num1, num2;
            System.out.print("Enter the first number: ");
            num1 = scanner.nextDouble();
            System.out.print("Enter the second number: ");
            num2 = scanner.nextDouble();

            // There are two diff types of things the user can do. Let them pick if they
            // want to simply use a normal calculator or have their two values be compared
            System.out.println("What would you like to do with these numbers?");
            System.out.println("1. Use a normal calculator");
            System.out.println("2. Compare the two numbers");
            int choice = scanner.nextInt();

            // Depending on which type the user has chosen, have them choose an operator and
            // perform the action

            // Arithmetic function:
            double storeNum = 0;
            boolean storeBool = false;
            if (choice == 1) {
                storeNum = arithmetic(scanner, num1, num2);
                System.out.println("The result of the calculation is: " + storeNum);
            }
            // Comparison function:
            else if (choice == 2) {
                storeBool = Comparison(scanner, num1, num2);
                System.out.println("The result of the comparison is: " + storeBool);
            } else {
                continueProgram = tryAgain(scanner, continueProgram, true);
                if (!continueProgram) {
                    break;
                }
            }

            // Memory function:
            if (choice == 1) {
                continueProgram = memory(scanner, storeNum);
            } else if (choice == 2) {
                continueProgram = memory(scanner, storeBool ? 1 : 0);
            }
            if (!continueProgram) {
                break;
            }
        }
        scanner.close();
    }

    public static double arithmetic(Scanner scanner, double num1, double num2) {
        double storeNum = 0;
        System.out.println("Choose an arithmetic operator: ");
        System.out.println("1. +");
        System.out.println("2. -");
        System.out.println("3. *");
        System.out.println("4. /");
        System.out.println("5. ^");
        System.out.println("6. %1 (meaning finding the percentage of the first number)");
        System.out.println("7. %2 (meaning finding the percentage of the second number)");
        System.out.println("8. %12 (meaning finding the percentage of the first and second number)");
        System.out.println("9. √1 (meaning finding the square root of the first number)");
        System.out.println("10. √2 (meaning finding the square root of the second number)");
        System.out.println("11. √12 (meaning finding the square root of the first and second number)");
        System.out.println("12. mod (meaning finding the modulus of the two numbers)");

        int operator = scanner.nextInt();

        if (operator == 1) {
            storeNum = num1 + num2;
        } else if (operator == 2) {
            storeNum = num1 - num2;
        } else if (operator == 3) {
            storeNum = num1 * num2;
        } else if (operator == 4) {
            storeNum = num1 / num2;
        } else if (operator == 5) {
            storeNum = Math.pow(num1, num2);
        } else if (operator == 6) {
            storeNum = (num1 / 100) * num2;
        } else if (operator == 7) {
            storeNum = (num2 / 100) * num1;
        } else if (operator == 8) {
            storeNum = ((num1 + num2) / 200) * (num1 + num2);
        } else if (operator == 9) {
            storeNum = Math.sqrt(num1);
        } else if (operator == 10) {
            storeNum = Math.sqrt(num2);
        } else if (operator == 11) {
            storeNum = Math.sqrt(num1 + num2);
        } else if (operator == 12) {
            storeNum = num1 % num2;
        }
        return storeNum;
    }

    public static boolean Comparison(Scanner scanner, double num1, double num2) {
        boolean storeBool = false;
        System.out.println("Choose a comparison operator: ");
        System.out.println("1. ==");
        System.out.println("2. >");
        System.out.println("3. <");
        System.out.println("4. >=");
        System.out.println("5. <=");
        System.out.println("6. !=");

        int operator = scanner.nextInt();
        if (operator == 1) {
            storeBool = (num1 == num2);
        } else if (operator == 2) {
            storeBool = (num1 > num2);
        } else if (operator == 3) {
            storeBool = (num1 < num2);
        } else if (operator == 4) {
            storeBool = (num1 >= num2);
        } else if (operator == 5) {
            storeBool = (num1 <= num2);
        } else if (operator == 6) {
            storeBool = (num1 != num2);
        }
        return storeBool;
    }

    public static boolean memory(Scanner scanner, double storeNum) {
        return memoryLoop(scanner, storeNum, true);
    }

    public static boolean memoryLoop(Scanner scanner, double storeNum, boolean firstTime) {
        // This function will allow the user to store a number in memory and recall it
        // later. It will also allow the user to clear the memory if they wish to do so.
        if (firstTime) {
            System.out
                    .println("Do you want to temporarily want to store a number for later use in calculations? (y/n)");
            String store = scanner.next();
            if (!store.equals("y")) {
                System.out.println("No problem! Let's continue with the calculations if you would like to do so.");
                return tryAgain(scanner, false, false);
            }
        }

        System.out.println("Choose a memory operator: ");
        System.out.println("1. MC (Memory Clear: Start from 0/Completely clear out the memory)");
        System.out.println(
                "2. MS (Memory Store: Store the value of the output of the calculations you have previously done)");
        System.out.println(
                "3. M+ (Memory Add: Add the value of the output of the calculations you have previously done to the last element in the memory)");
        System.out.println(
                "4. M- (Memory Subtract: Subtract the value of the output of the calculations you have previously done from the memory)");
        System.out.println("5. MR (Memory Recall: Show the value last stored in the memory)");
        System.out
                .println("6. MSN (Memory Store Number: Store a number of your choice to start off with in the memory)");
        int memoryOperator = scanner.nextInt();

        if (memoryOperator == 1) {
            // Memory Clear
            memory.clear();
            System.out.println("Memory cleared.");
        } else if (memoryOperator == 2) {
            // Memory Store
            memory.add(storeNum);
            System.out.println("Stored " + storeNum + " in memory.");
        } else if (memoryOperator == 3) {
            // Memory Add
            if (!memory.isEmpty()) {
                double lastValue = memory.get(memory.size() - 1);
                memory.set(memory.size() - 1, lastValue + storeNum);
                System.out.println("Added " + storeNum + " to memory. New value: " + memory.get(memory.size() - 1));
            } else {
                System.out.println("Memory is empty. Cannot add.");
            }
        } else if (memoryOperator == 4) {
            // Memory Subtract
            if (!memory.isEmpty()) {
                double lastValue = memory.get(memory.size() - 1);
                memory.set(memory.size() - 1, lastValue - storeNum);
                System.out.println(
                        "Subtracted " + storeNum + " from memory. New value: " + memory.get(memory.size() - 1));
            } else {
                System.out.println("Memory is empty. Cannot subtract.");
            }
        } else if (memoryOperator == 5) {
            // Memory Recall
            if (!memory.isEmpty()) {
                System.out.println("Last value currently stored in memory: " + memory.get(memory.size() - 1));
            } else {
                System.out.println("Memory is empty.");
            }
        } else if (memoryOperator == 6) {
            // Memory Store Number
            System.out.println("Enter the number you want to store in memory: ");
            double numToStore = scanner.nextDouble();
            memory.add(numToStore);
            System.out.println("Stored " + numToStore + " in memory.");
        }

        // Ask the user if they want to continue with memory operations or return to
        // main calculations
        System.out.println("Would you like to perform another memory operation? (y/n)");
        String continueMemory = scanner.next();
        if (continueMemory.equals("y")) {
            return memoryLoop(scanner, storeNum, false); // Recursive call to stay in memory mode
        } else {
            // Ask the user if they want to continue with calculations
            return tryAgain(scanner, false, false);
        }
    }

    public static boolean tryAgain(Scanner scanner, boolean continueProgram, boolean mistake) {
        if (mistake) {
            System.out.println("Sorry, I think you clicked something we couldn't register.");
        }
        System.out.println("Would you like to try again? (y/n)");
        String tryAgain = scanner.next();
        if (tryAgain.equals("y")) {
            continueProgram = true;
        } else if (tryAgain.equals("n")) {
            System.out.println("Hope you had fun! Bye!");
            continueProgram = false;
        }
        return continueProgram;
    }
}