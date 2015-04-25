#include <stdio.h>
#include <ctype.h>
//TODO Global variables



int main(int argc, char* argv[])
{
    //Driver Class
    //Variable calls
    compress();
    decompress();

    return 0;
}

void compress(){
    //-------------------------------------------
    //Variables
    char fileString[1];
    FILE *fptrIn;
    FILE *fptrOut;
    int repeated = 0;


    //-------------------------------------------
    //file opening
    printf("File Compress\n");
    if ((fptrIn = fopen("tobeconverted.txt","r+"))==NULL){
        printf("Error opening file to be converted!\n");
        exit(1);
    }

    if ((fptrOut = fopen("convertedFile.rle","w+" ))==NULL){
        printf("Error opening file to write to!\n");
        exit(1);
    }

    fscanf(fptrIn,"%[^n]", fileString);
    //--------------------------------------------
    //file writing
    /* This function takes the ptr data from the In file
     * and adds it all into c
     * it then forces a single character from c into temp
     * goes through an if statement to test whether the data is similar
     * if it is, go ahead and add to repeated.
     * when there isn't a repeated letter, then dump the repeated int and
     * single letter that temp has in it into the temp buffer.
     */
    char *c = fptrIn->_base; //i had to cheat and actually access the object._base
    char temp = *c;
    while (*c){ // increment a letter of c
        if (temp != *c){ //check to see if the letters are different
            //fprintf(fptrOut,"%d",repeated);
            fputc(temp, fptrOut);//write the letter to the array
            fprintf(fptrOut,"%d",repeated); //write the number of letters to the array
            //writeCount++; // position in array hold[]
            printf("%d", repeated); // print the int that is in repeated.
            repeated=0; // reset repeated back to 0 to start counting again
            temp = *c; //dump a new letter into temp

        } else { // if they are the same
            repeated++; // increment repeated int
            putchar(*c++); // push next char.
        }
    }
    //TODO fix the error where the last letters aren't being recorded
    fputc(temp, fptrOut);//write the letter to the array
    printf("%d", repeated); // print the int that is in repeated.
    //------------------------------------------------
    //File Closing
    fclose(fptrIn);
    fclose(fptrOut);

}

void decompress(){
    //-------------------------------------------
    //Variables
    char fileString[1];
    FILE *fptrIn;
    FILE *fptrOut;
    int repeated = 0;


    //-------------------------------------------
    //file opening
    printf("File Decompress\n");
    if ((fptrIn = fopen("convertedFile.rle","r+" ))==NULL){
        printf("Error opening file to be converted!\n");
        exit(1);
    }

    if ((fptrOut = fopen("tobeconverted.txt","w+"))==NULL){
        printf("Error opening file to write to!\n");
        exit(1);
    }

    fscanf(fptrIn,"%[^n]", fileString);
    //--------------------------------------------
    //file writing
    /* This function takes the ptr data from the In file
     * and adds it all into c
     * it then forces a single character from c into temp
     * it will iterate through each character
     * a character value will be written so many times based on
     * the results of *c
     *
     * a4b3d2
     * check first letter
     * 	char *letterIn = *c
     * 	set to a letter char
     * check second char
     * 	4
     * 	int numIn = *c;
     * for (int i = 0; i < numIn; i++){
     *  printf("%s", letterIn);
     * }
     *
     */
    char *c = fptrIn->_base; //i had to cheat and actually access the object._base
    char temp = *c;
    char letterIn;
    int numIn;
    while (*c){ // increment a letter of c
        //TODO check to see what the current temp is.
        if (temp == 32){// is there a space?
            putchar(*c++);
            putchar(*c++);
            fprintf(fptrOut," ");
            temp = *c;
        }
        if (isalpha(temp)){
            letterIn = temp;
            putchar(*c++); // push next char
            temp = *c;
        }
        if (isdigit(temp)) {
            numIn = temp - '0';
            temp = putchar(*c++); // push next char
            temp = *c;
        }
        int i;
        for (i = 0; i < numIn; i++){
            fputc(letterIn, fptrOut);
        }
    }
    //------------------------------------------------
    //File Closing
    fclose(fptrIn);
    fclose(fptrOut);

}


/*
Sources
http://www.programiz.com/c-programming/examples/read-file
http://stackoverflow.com/questions/3213827/how-to-iterate-over-a-string-in-c
http://stackoverflow.com/questions/9840629/create-a-file-if-one-doesnt-exist-c
http://stackoverflow.com/questions/11573974/write-to-txt-file
http://www.cprogramming.com/tutorial/cfileio.html
https://qt-project.org/doc/qtcreator-2.6/creator-debug-mode.html
http://www.c4learn.com/c-programming/c-reference/fputc-function/
http://stackoverflow.com/questions/2229377/writing-an-integer-to-a-file-with-fputs
http://stackoverflow.com/questions/2736753/how-to-remove-extension-from-file-name
http://stackoverflow.com/questions/868496/how-to-convert-char-to-integer-in-c

*/

//void printToAray(char data){
//    int i;
//    //temp[writeCount] = data;
//    //fputc(temp[writeCount], fptrOut);
//    fputc(data, fptrOut);
//    //writeCount++;
////    for (i = 0; i < sizeof(data); i++)
////        temp[i] = data[i];
//}
