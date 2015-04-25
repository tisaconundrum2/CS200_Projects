/*
 * Author: Nicholas Finch
 * Date: 2/27/2015
 * Synopsis: A program that takes in a floating point number and
 * converts it to binary
 */
#include <stdio.h>
#include "string.h"


int main(void)
{
    unsigned int bits;
    char sig, exp, man;

    bits = askMe();
    sig = signBitShift(bits);
    exp = expoBitShift(bits);
    man = mantBitShift(bits);
    /*TODO    1 12345678 12345678912345678912345
     * input: 0 10000010 10000100000000000000000
     *        s exponent Significand/Mantissa
     *
     * output:
     * sign:        0 (positive)
     * Exponent:    100000010
     */


}

int askMe(){
    unsigned int bits;
    float f;

    scanf("%f",&f);
    printf("%f\n",f);
    bits = *((int*) &f);
    printf("%d\n",bits);
    return bits;
}

int signBitShift(unsigned int bits){
    //TODO bitshift the sign
    bits = bits >> 31;
    char bitstring;
    bitstring = bin2dec(bits, 1);
    return bitstring;
}

int expoBitShift(unsigned int bits){
    //TODO bitshifht the exponent
    bits = (bits << 1) >> 24;
    char bitstring;
    bitstring = bin2dec(bits, 7);
    return bitstring;
}

int mantBitShift(unsigned int bits){
    //TODO bitshift the mantissa
    bits = (bits << 9) >> 9;
    char bitstring;
    bitstring = bin2dec(bits, 22);
    return bitstring;
}

//int bin2dec(char* binary[]){
//    //TODO return an int of binary
//    //TODO fix the segmentation fault!
//    int decimal = strtol(binary, NULL, 2);
//    return decimal;
//}

int bin2dec(unsigned int num, unsigned int size){
    // declare some temporary variables to work with
    char resultStr[size];
    char tempStr[size];
    unsigned char tnum = (unsigned char)num;
    unsigned char remainder;
    int cnt = size;		// this is for padding leading 0s

    memset(resultStr, '\0', sizeof(resultStr));
    strcpy(resultStr, ""); //start with nothing!
    while (cnt != 0){				// loop until all digits are added
        remainder = tnum % 2;		// use modulo to get the digit
        tnum = tnum / 2;			// reduce the number for the next iteration
        switch (remainder){			// based on the digit, get a character
            case 0:
                tempStr = concat(tempStr, "0");
                break;
            case 1:
                strcat(tempStr, "1");
                break;
        }

        strcat(tempStr, resultStr);  // add the digit to the front
        strcpy(resultStr, tempStr);
        cnt--;
    }

    return &resultStr;
}

//this function was created as an attempt to change the strings above.
//It didn't work
int concat(char s1[100], char s2[100]) {

    char i, j;
    for (i = 0; s1[i] != '\0'; ++i); /* i contains length of string s1. */
    for (j = 0; s2[j] != '\0'; ++j, ++i) {
        s1[i] = s2[j];
    }
    return s1, s2;
    }



/*Sources
 *
Office Hours
http://cboard.cprogramming.com/c-programming/50920-bin2dec.html
http://stackoverflow.com/questions/3555108/multiple-word-string-input-through-scanf
http://rt.com/man/strtol.3.html
http://www.h-schmidt.net/FloatConverter/IEEE754.html
http://www.exploringbinary.com/base-conversion-in-php-using-bcmath/
http://cboard.cprogramming.com/c-programming/50920-bin2dec.html
http://stackoverflow.com/questions/2548282/decimal-to-binary-and-vice-versa
http://stackoverflow.com/questions/1544456/faster-version-of-dec2bin-function-for-converting-many-elements
http://stackoverflow.com/questions/1544456/faster-version-of-dec2bin-function-for-converting-many-elements?s=4|0.4380
http://stackoverflow.com/questions/8630138/c-filling-an-array-using-dec2bin-converter
http://stackoverflow.com/questions/8630138/c-filling-an-array-using-dec2bin-converter?s=1|1.2404
http://stackoverflow.com/search?q=dec2bin+C
https://www.ma.utexas.edu/users/friedman/prog/dec2bin.c
ftp://ftp.ntsg.umt.edu/pub/eostc/utils/dec2bin_code/dec2bin.C
http://stackoverflow.com/questions/3954498/how-to-convert-float-number-to-binary

 */

//#include <stdio.h>
//#include <string.h>

//int main()
//{
//   char src[40];
//   char dest[100];

//   memset(dest, '\0', sizeof(dest));
//   strcpy(src, "a");
//   strcat(src, "b");
//   strcat(src, "c");
//   strcat(src, "d");
//   strcat(dest, src);

//   printf("Final copied string : %s\n", dest);

//   return(0);
//}
