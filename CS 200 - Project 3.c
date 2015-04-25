#include "stdlib.h"
#include "stdio.h"
#include "string.h"


//creating all my functions up here and calling them in main
//all results will be returned in main
char byteToDecimalStr(int n){
    //TODO add a input byte that will be turned into decimal
    //I think i'm misunderstanding what is going on here.
    //What i do know is that i'm passing an integer in, it is not a binary yet.
    return n;
}

char byteToBinaryStr(int n){
    //TODO add a input byte that will be turned into binary
    int rem, i=1, binary=0;
        while (n!=0)
        {
            rem=n%2;
            n/=2;
            binary+=rem*i;
            i*=10;
        }
        return binary;
}

char byteToHexStr(int n){
    //TODO add an input byte that will be turned into a hex
    int octal=0, decimal=0, i=0;
    while(n!=0)
    {
        decimal+=(n%10)*pow(2,i);
        ++i;
        n/=10;
    }

/*At this point, the decimal variable contains corresponding decimal value of binary number. */

    i=1;
    while (decimal!=0)
    {
        octal+=(decimal%16)*i;
        decimal/=16;
        i*=10;
    }
    return octal;
}

int AND(int a, int b){
    return a&b;
}

int OR(int a, int b){
    return a|b;
}

int XOR(int a, int b){
    return a^b;
}

int NOT(int a, int b){
    return ~a;
}

int shiftRight(int a, int b){
    return a>>b;
}


int shiftLeft(int a, int b){
    return a<<b;
}

int main(int argc, char* argv[]){
    //TODO get the argv commands (there should be two)
    //have them complete go through each of the functions
    int a, b;
    if (argc != 3){
        printf("usage cp <int> <int>");
        printf("\nPlease enter 1st <int>: ");
        scanf("%d", &a);
        printf("Please enter 2nd <int>: ");
        scanf("%d", &b);
    }else{
        a = (int)* argv[1] - '0'; //this piece took a lot of code wrangling
        b = (int)* argv[2] - '0'; //and trying a whole host of different things, this seems to work for some reason.
        //i'd like to note that it doesn't work for numbers greater than 9 or less than 0.
    }
    printf("inputs: a=%d, b=%d\n",a,b);
    //      13         19    32   11     43    15        58     16       74 <-- attempting to measure distances
    printf("Type      Input val    byte2dec        byte2bin        byte2hex\n");
    printf("AND:        %7d%12d%16d%16d\n",AND(a, b),        byteToDecimalStr(AND(a,b)),         byteToBinaryStr(AND(a,b)),          byteToHexStr(AND(a,b)));
    printf("OR:         %7d%12d%16d%16d\n",OR(a, b),         byteToDecimalStr(OR(a, b)),         byteToBinaryStr(OR(a, b)),          byteToHexStr(OR(a,b)));
    printf("XOR:        %7d%12d%16d%16d\n",XOR(a, b),        byteToDecimalStr(XOR(a, b)),        byteToBinaryStr(XOR(a, b)),         byteToHexStr(XOR(a,b)));
    printf("NOT:        %7d%12d%16d%16d\n",NOT(a, b),        byteToDecimalStr(NOT(a, b)),        byteToBinaryStr(NOT(a, b)),         byteToHexStr(NOT(a,b)));
    printf("ShiftRight: %7d%12d%16d%16d\n",shiftRight(a, b), byteToDecimalStr(shiftRight(a, b)), byteToBinaryStr(shiftRight(a, b)),  byteToHexStr(shiftRight(a,b)));
    printf("ShiftLeft:  %7d%12d%16d%16d\n",shiftLeft(a, b),  byteToDecimalStr(shiftLeft(a, b)),  byteToBinaryStr(shiftLeft(a, b)),   byteToHexStr(shiftLeft(a,b)));
//this print portion was going to be messy whether i attempted to isolate the outputs or have them be spit out straight to print. >_<
}

/*
Sources:
http://stackoverflow.com/questions/5029840/convert-char-to-int-in-c-and-c
http://www.cs.umd.edu/class/sum2003/cmsc311/Notes/BitOp/bitshift.html
http://www.codingunit.com/c-tutorial-functions-and-global-local-variables
https://blog.udemy.com/c-string-to-int/
http://www.programiz.com/c-programming/examples/binary-decimal-convert
http://www.programiz.com/c-programming/examples/octal-binary-convert
http://www.eecis.udel.edu/~trnka/CISC105-04F/making_columns.html
http://beej.us/guide/bgc/output/html/multipage/scanf.html

*/
