/*
 CSCI3180 Principles of Programming Languages
 --- Declaration ---

 I declare that the assignment here submitted is original except for source
 material explicitly acknowledged. I also acknowledge that I am aware of
 University policy and regulations on honesty in academic work, and of the
 disciplinary guidelines and procedures applicable to breaches of such policy
 and regulations, as contained in the website
 http://www.cuhk.edu.hk/policy/academichonesty/

 Assignment 1
 Name : Wang Wei Xiao
 Student ID : 1155141608
 Email Addr : 1155141608@cse.cuhk.edu.hk
*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>


static char balance[16];
//find if balance is sufficient

int find_account(char*account){//find_target account
    int incorrect_account;
    char input = 0;
    int line_order =0;
    FILE *master = fopen( "master.txt" , "r" );
    incorrect_account = 0;

    do{
        input = fgetc( master );
        //check account
        if (incorrect_account == 0 && line_order >= 20 && line_order < 36){
            if(input != account[line_order-20]){
                incorrect_account = 1;
            }
        }
        line_order +=1;
        if(input == '\n'||input =='\r\n'){
            if (incorrect_account == 0){
                fclose(master);
                return 1;
            }//find the account
            line_order = 0;
            incorrect_account = 0;
        }
    }while( input != EOF);

    fclose(master);
    return 0;
}
//find if there is such a account
int find_account_password(char*account, char*password){
    int incorrect_account,incorrect_password,negative_balance;
    char input = 0;
    int line_order =0;


    FILE *master = fopen( "master.txt" , "r" );
    incorrect_account = 0;
    incorrect_password = 0;
    negative_balance = 0;
    do{
        input = fgetc( master );
        //check account
        if (incorrect_account == 0 && line_order >= 20 && line_order < 36){
            if(input != account[line_order-20]){
                incorrect_account = 1;
            }
        }
        //check password
        if (incorrect_password == 0 && line_order >= 36 && line_order < 42){
            if(input != password[line_order-36]){
                incorrect_password = 1;
            }
        }
        //newline
        if (incorrect_account == 0 && incorrect_password == 0 && line_order >=42 && line_order<58){
            if (input =='-'){
                fclose(master);
                return 2;//negative balance
            }
            else{
                balance[line_order-42] = input;
            }
        }
        line_order +=1;
        if(input == '\n'){
            if (incorrect_account == 0 && incorrect_password == 0){
                fclose(master);
                return 1;
            }//find the account
            line_order = 0;
            incorrect_account = 0;
            incorrect_password = 0;
        }
    }while( input != EOF);

    fclose(master);
    return 0;
}

int atms(FILE *trans711,FILE *trans713,int time){
    FILE *master;
    char input = 0;//account and passwords
    char *amount = malloc(16*sizeof(char));//input digit
    char *adjusted_amount = malloc(16*sizeof(char));//adjusted amount
    int account_amount = 1;//number of accounts
    int atm;//the ATM
    master = fopen( "master.txt" , "r" );
    if (master == NULL ){
        printf(" non-existing file!\n ");
        return -2;
    }
    do{
        input = fgetc( master );
        if ( input == '\n' || input == '\r\n'){
            account_amount +=1;
        }
    }while( input != EOF);
    fclose(master);

    int next = 0;//1 for next step, 0 for recursion

    //choose ATM
    do{
        printf(" PLEASE CHOOSE THE ATM\n");
        printf(" PRESS 1 FOR ATM 711\n");
        printf(" PRESS 2 FOR ATM 713\n");
        scanf("%c",&input);
        if (input != '1' && input != '2'){
            while (input != '\n' && input != '\r\n'){
                scanf("%c",&input);
            }
            printf(" INVALID INPUT \n");
            next = 0;
        }
        else{
            atm = input;
            scanf("%c",&input);
            if (input != '\n' && input != '\r\n'){
                while (input != '\n' && input != '\r\n'){
                    scanf("%c",&input);
                }
                printf(" INVALID INPUT \n");
            }
            else{
                next = 1;
            }
        }
    }while (next == 0);

    int account_condition = 0;//0 for no exist account/password, 1for positive 2for negative
    char *account = malloc(16 * sizeof(char));
    char *t_account = malloc(16 * sizeof(char));
    char *password = malloc(6 * sizeof(char));
    //register
    next = 0;
    do{
       printf(" ACCOUNT\n");
       input = '\0';
       int i;//number of input digits
       for(i=0;input!= '\n';i++){
        scanf("%c",&input);
        if(i<16){
            account[i]=input;
        }
       }
       printf(" PASSWORD\n");
       input = '\0';
       int j;//number of input digits
       for(j=0;input!= '\n';j++){
        scanf("%c",&input);
        if(j<6){
            password[j]=input;
        }
       }
       //read the account data to check
       if (i != 17 || j!= 7){
        printf(" INCORRECT ACCOUNT/PASSWORD\n");//incorrect size
       }
       else{
            account_condition = find_account_password(account,password);
            if ( account_condition == 0){
                 printf(" INCORRECT ACCOUNT/PASSWORD\n");//account incorrect
           }
           else{
             if ( account_condition == 2){
                 printf(" NEGATIVE REMAINS TRANSACTION ABORT\n");//account incorrect
                 return -1;
            }
             if ( account_condition == 1){
                next = 1;//continue
            }
           }
       }

    }while (next == 0);

    //transaction
    next = 0;
    char type;
    do{
        printf(" PLEASE CHOOSE YOUR SERVICE\n");
        printf(" PRESS D FOR DEPOSIT\n");
        printf(" PRESS W FOR WITHDRAW\n");
        printf(" PRESS T FOR TRANSFER\n");
        scanf("%c",&input);
        if (input != 'D' && input != 'W' && input != 'T'){
            printf(" INVALID INPUT\n");
        }
        else{
            next = 1;
            type = input;
        }
        while(input != '\n' && input != '\r\n'){
            scanf("%c",&input);//clear the \n
        }
    }while(next == 0);

    next = 0;
    int invalid;
    int transfer = 0;//whether transfer

    if (type == 'D'){//deposit
        do{
            printf(" AMOUNT OF MONEY TO DEPOSIT\n");
            input = 0;
            invalid = 0;
            for(int i = 0; i< 16 && input != '\n' && invalid == 0;i++){
                scanf("%c",&input);
                if (input == '-'){
                    printf(" INVALID INPUT\n");
                    invalid = 1;
                }
                else{
                    amount[i]=input;
                }
            }
            if(invalid == 0){
                next = 1;
                //adjust the amount
                int decimal = 0;
                int decimal_point = -1;
                int enough = 1;//sufficient or not
                int equal = 1;//the digit at same position is equal
                //adjust the amount
                for (int i = 0;i<16&&decimal_point == -1;i++){
                    if (amount[i]=='.'){
                        decimal = 1;
                        decimal_point = i;//if there is a decimal, find its place
                    }
                    if (decimal_point == -1 && amount[i] == '\n'){
                        decimal_point = i;//if no, decimal is at the end of string
                    }
                }
                adjusted_amount[0] = '+';
                for (int i = 1;i<16;i++){
                    if (i<14-decimal_point){
                        adjusted_amount[i] = '0';

                    }
                    else if (i<14){
                        adjusted_amount[i] = amount[i-14+decimal_point];

                    }
                    else{
                        if (decimal && amount[i-13+decimal_point]!= '\n'){
                            adjusted_amount[i] = amount[i];
                        }
                        else{
                            adjusted_amount[i] = '0';
                        }

                    }
                }
            }

        }while(next==0);
    }

    if (type == 'T'){//transfer
        int j;//number of input digits
        int same_account;
        do{
            printf(" TARGET ACCOUNT\n");
            input = '\0';
            for(j=0;input!= '\n';j++){
                scanf("%c",&input);
                if(j<16){
                    t_account[j]=input;
                }
            }
            //judge account
            same_account = 1;
            for(int i=0;i<16 && same_account == 1;i++){
                if (t_account[i]!= account[i]){
                    same_account =0;
                }
            }
            if (same_account){
                printf(" YOU CANNOT TRANSFER TO YOURSELF\n");
            }
            else{
                if (find_account(t_account)){
                   type ='W';
                   transfer = 1;
                   next = 1;
                }
                else{
                 printf(" TARGET ACCOUNT DOES NOT EXIST\n");
                }
            }

            while(input != '\n' && input != '\r\n'){
                scanf("%c",&input);//clear the \n
            }
        }while(next == 0);
    }
    next = 0;

    if (type == 'W'){//withdraw
        do{
            printf(" AMOUNT\n");
            input = 0;
            invalid = 0;
            for(int i = 0; i< 16 && input != '\n' && invalid == 0;i++){
                scanf("%c",&input);
                if (input == '-'){
                    printf(" INVALID INPUT\n");
                    invalid = 1;
                }
                else{
                    amount[i]=input;
                }
            }

            if(invalid == 0){
                int digit;
                int decimal = 0;
                int decimal_point = -1;
                int enough = 1;//sufficient or not
                int equal = 1;//the digit at same position is equal
                //adjust the amount
                for (int i = 0;i<16&&decimal_point == -1;i++){
                    if (amount[i]=='.'){
                        decimal = 1;
                        decimal_point = i;//if there is a decimal, find its place
                    }
                    if (decimal_point == -1 && amount[i] == '\n'){
                        decimal_point = i;//if no, decimal is at the end of string
                    }
                }

                adjusted_amount[0] = '+';
                for (int i = 1;i<16;i++){
                    if (i<14-decimal_point){
                        adjusted_amount[i] = '0';

                    }
                    else if (i<14){
                        adjusted_amount[i] = amount[i-14+decimal_point];

                    }
                    else{
                        if (decimal && amount[i-13+decimal_point]!= '\n'){
                            adjusted_amount[i] = amount[i];
                        }
                        else{
                            adjusted_amount[i] = '0';
                        }

                    }
                }
                //compare the amount
                for (int i = 1;i<16&&equal;i++){
                    if ( adjusted_amount[i] > balance[i]){
                        equal = 0;
                        enough = 0;
                    }//amount>balance,insufficient,end
                    if ( adjusted_amount[i]< balance[i]){
                        equal = 0;
                    }//amount<balance,end
                }

                if(enough){
                    next = 1;
                }
                else{
                    printf(" INSUFFICIENT BALANCE\n");
                }
            }
        }while(next==0);
    }
    //generate files
    FILE *atm_record;
    if (atm == '1'){
        atm_record = trans711;
    }
    if (atm == '2'){
        atm_record = trans713;
    }

    //print the records
    if(type == 'W'){//withdraw or transfer
            for (int i =0;i<16;i++){
                fprintf(atm_record,"%c",account[i]);

            }
            fprintf(atm_record,"W");

            for (int i =9;i<16;i++){
                fprintf(atm_record,"%c",adjusted_amount[i]);


            }
            for (int i = 10000;i>=1;i/=10){
                fprintf(atm_record,"%d",time/i);

            }
            fprintf(atm_record,"\n");

            time +=1;
        }

    if(type == 'D' || transfer == 1){//deposit
            for (int i =0;i<16;i++){
                if(transfer){
                    fprintf(atm_record,"%c",t_account[i]);

                }
                else{
                    fprintf(atm_record,"%c",account[i]);

                }
            }
            fprintf(atm_record,"D");

            for (int i =9;i<16;i++){
                fprintf(atm_record,"%c",adjusted_amount[i]);
                printf("%c",adjusted_amount[i]);
            }
            for (int i = 10000;i>=1;i/=10){
                fprintf(atm_record,"%d",time/i);

            }
            fprintf(atm_record,"\n");

            time+=1;
    }

    return time;
}

int main(){
    printf("##############################################\n");
    printf("##         Gringotts Wizarding Bank         ##\n");
    printf("##                 Welcome                  ##\n");
    printf("##############################################\n");

    char conti = 'Y';//whether continue
    char input;//wild inputs
    int time = 0;
    int jump = 0;
    FILE *trans711, *trans713;
    trans711 = fopen( "trans711.txt" , "w+" );
    trans713 = fopen( "trans713.txt" , "w+" );
    if (trans711 == NULL || trans713 == NULL){
        printf("non-existing file!\n ");
        return 1;
     }
    do{
        if (conti == 'Y'){//continue
            int tmp = atms(trans711,trans713,time);
            if (tmp > 0){
                time = tmp;
            }
            else if (tmp == -1){//negative balance
                jump = 1;
            }
            else{//error
                return 0;
            }
        }
        if (jump){
            jump = 0;
        }
        else{
            int invalid = 0;
            printf(" CONTINUE?\n");
            scanf("%c",&conti);
            input = conti;

            if (input != 'Y' && input != 'N'){
            printf(" INVALID INPUT \n");
            }
        }
        while (input != '\n' && input != '\r\n'){
        scanf("%c",&input);
        }

    }while(conti != 'N');

    fclose(trans711);
    fclose(trans713);
    return 0;
}
