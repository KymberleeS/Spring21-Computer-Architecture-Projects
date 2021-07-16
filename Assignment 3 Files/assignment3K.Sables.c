// Assignment 3
// Kymberlee Sables 

// imports
#include <stdio.h>

/*
  1. Do NOT declare ANY global variables
  2. ALL variables MUST be declared within the main function
  3. Declaring global constants using the #define keyword is okay
  4. Pass appropriate variables as arguments to each function
  5. The function MUST be an exact translation of the MIPS assembly code
*/

// function declarations
void displayResult(int num1, int num2);
void prepareData(int numArray[], int numArray2[], int numArray3[], int size0);
int processData(int numArray[], int size12);

int main() {
    int numArray[20] = {35, -34, 82, -95, -2, 22, -17, 80, -67, -39, 64, 94, -96, 95, -70, -63, 69, -3, 75, -10};
    int numArray2[10] = {};
    int numArray3[10] = {};
    int size0 = 20;
    int size12 = 10; 
    
    prepareData(numArray, numArray2, numArray3, size0);

    int num1 = processData(numArray2, size12);
    int num2 = processData(numArray3, size12);
    
	displayResult(num1, num2);
    return 0;
}

/*
  1. Add the appropriate arguments to the function
  2. The function MUST be an exact translation of the MIPS assembly code
*/
void displayResult(int num1, int num2) {
    printf("Assignment 3\n");
    printf("------------\n");
    printf("Result: %d", num1 + num2);
}

/*
  1. Add the appropriate arguments to the function
  2. The function MUST be an exact translation of the MIPS assembly code
*/
void prepareData(int numArray[], int numArray2[], int numArray3[], int size0) {
    int counter1 = 0;
    int counter2 = 0;
    
    for (int i = 0; i < size0; i++) {
        int remainder = numArray[i] % 2;
        
        if (remainder != 0) {
            numArray3[counter1++] = numArray[i];
        } else {
            numArray2[counter2++] = numArray[i];
        }
    }
}

/*
  1. Add the appropriate arguments to the function
  2. The function MUST be an exact translation of the MIPS assembly code
*/
int processData(int numArray[], int size12) {
    int result = 100;
    
    for (int i = 0; i < size12; i++) {
        int remainder = i % 2;
        
        if (remainder == 0) {
            result += numArray[i];
        } else {
            result -= numArray[i];
        }
        
    }
	return result; // Return the appropriate value
}
