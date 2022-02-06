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

/*
code below cited from sort.c in http://course.cse.cuhk.edu.hk/~csci3180/submit/hw1.html
*/
void read_str(char input_line[], char output_line[], int start_index, int length) {
    strncpy(output_line, input_line + start_index, length);
    output_line[length] = '\0';
}

////////////////////////////////////////////////
// global variable
int MAX_TRAN = 10;

struct transaction {
    char transac_account[20];
    char others[15];
    char timestamp[10];
};

struct transaction * process_one_transaction(char line[]) {
    struct transaction * result_transaction = (struct transaction *) malloc(sizeof(struct transaction));

    char temp_str[30];

    // transaction account
    read_str(line, temp_str, 0, 16);
    strcpy(result_transaction->transac_account , temp_str);

    // operation
    read_str(line, temp_str, 16, 8);
    strcpy(result_transaction->others , temp_str);

    // timestamp
    read_str(line, temp_str, 24, 5);
    strcpy(result_transaction->timestamp , temp_str);

    return result_transaction;
}

struct transaction ** get_transactions(char stat_path[]){
    struct transaction ** all_transactions = (struct transaction **) malloc(sizeof(struct transaction *) * MAX_TRAN);
    FILE * fp = fopen(stat_path, "r");
    for (int i = 0; i < MAX_TRAN; i++) all_transactions[i] = NULL;
    char line[60];
    int cnt = 0;
    while (fgets(line, 60, fp) != NULL) {
        all_transactions[cnt] = process_one_transaction(line);
        cnt += 1;

        if (cnt == MAX_TRAN) {
            // allocate more space
            MAX_TRAN *= 2;
            struct transaction ** all_transactions_temp;
            all_transactions_temp = realloc(all_transactions, sizeof(struct transaction *) * MAX_TRAN);
            all_transactions = all_transactions_temp;
        }
    }
    return all_transactions;

}

void swap(struct transaction *a , struct transaction *b)
{
    struct transaction temp ;
    temp = *a ;
    *a = *b ;
    *b = temp ;
    return ;
}

struct transaction ** sort_transactions(struct transaction ** transaction_i){

    int transaction_index = 0, temp_index = 0;
    while (transaction_i[transaction_index] != NULL) {
        temp_index = transaction_index;
        while (transaction_i[temp_index] != NULL){
            if (strcmp(transaction_i[temp_index]->transac_account,transaction_i[transaction_index]->transac_account)<0){
                swap(transaction_i[temp_index], transaction_i[transaction_index]);
            }
            else{
                if (strcmp(transaction_i[temp_index]->transac_account,transaction_i[transaction_index]->transac_account)==0){
                    if (strcmp(transaction_i[temp_index]->timestamp,transaction_i[transaction_index]->timestamp)<0){
                        swap(transaction_i[temp_index], transaction_i[transaction_index]);
                    }
                }
            }
            temp_index += 1;

        }
        transaction_index += 1;
    }
    return transaction_i;
}

void save_transactions(struct transaction ** transactions, char save_path[]){
    FILE * fp = fopen(save_path, "w");
    int transaction_index = 0;
    while(transactions[transaction_index] != NULL){
        fprintf(fp, "%.16s%.8s%.5s", transactions[transaction_index]->transac_account, transactions[transaction_index]->others, transactions[transaction_index]->timestamp);
        fprintf(fp, "%s", "\n");
        transaction_index += 1;
    }
    fclose(fp);
}

void sort_transaction(char path[], char sort_path[]){
    struct transaction ** transactions = get_transactions(path);
    struct transaction ** transactions_sort = sort_transactions(transactions);
    save_transactions(transactions_sort, sort_path);
}
/*
 code above cited from sort.c in http://course.cse.cuhk.edu.hk/~csci3180/submit/hw1.html
*/

void updatebalance(char*account,long change){
    FILE *master,*updatedMaster;
    master = fopen( "negReport.txt" , "r" );
    updatedMaster = fopen( "updatedMaster.txt" , "w" );

    int incorrect_account = 0;
    long balance = 0;
    char input = 0;
    char* line[100]={0};
    int line_order =0;

    do{
        input = fgetc( master );
        line[line_order] = input;
        //check account
        if (incorrect_account == 0 && line_order >= 20 && line_order < 36){
            if(input != account[line_order-20]){
                incorrect_account = 1;
            }
        }
        line_order +=1;

        if(input == '\n'||input =='\r\n'){
            if (incorrect_account == 0){
                //find account,update the balance

                for(int i = 43;i<58;i++){
                     long a = (line[i]-'0');
                     long b = i;
                      while (b<57){
                      a*=10;
                      b+=1;
                      }
                      balance += a;
                }

                if(line[42]=='-'){
                    balance *= -1;
                }
                balance += change;//update balance
                if(balance < 0){
                    line[42] = '-';
                    balance *= -1;
                }
                for(int i = 43;i<58;i++){
                    long b = i;
                    long a = balance;
                    while(b<57){
                        a/=10;
                        b+=1;
                    }
                    a = a%10;
                    line[i]= a+'0';
                }
            }
            //rewrite upmaster
            for(int i = 0; line[i] !='\n';i++){
                    fprintf(updatedMaster,"%c",line[i]);

                }
                fprintf(updatedMaster,"\n");

            //find the account
            memset(line,0, sizeof(line));
            line_order = 0;
            incorrect_account = 0;
        }
    }while( input != EOF);

    fclose(updatedMaster);
    fclose(master);

    return;
}

int main(){
    FILE *master,*trans711,*trans713,*transSorted711, *transSorted713, *transSorted,*updatedMaster, *negReport;
    trans711 = fopen( "trans711.txt" , "r" );
    trans713 = fopen( "trans713.txt" , "r" );
    transSorted711 = fopen( "transSorted711.txt" , "r" );
    transSorted713 = fopen( "transSorted713.txt" , "r" );

    if (master == NULL || trans711 == NULL||trans713 == NULL||transSorted711 == NULL||transSorted713 == NULL||transSorted == NULL||negReport == NULL){
        printf(" non-existing file!\n ");
        return -1;
    }

    char input;
    int t_amount = 0;
    char* line = malloc(100*sizeof(char));

    char path[100] ,sort_path[100];
    strcpy(path,"trans711.txt");
    strcpy(sort_path,"transSorted711.txt");
    sort_transaction( path,  sort_path);
    strcpy(path,"trans713.txt");
    strcpy(sort_path,"transSorted713.txt");
    sort_transaction( path,  sort_path);


    //merge
    transSorted711 = fopen( "transSorted711.txt" , "r" );
    transSorted713 = fopen( "transSorted713.txt" , "r" );
    updatedMaster = fopen( "updatedMaster.txt" , "w" );

    while(!feof(transSorted713))  {
        memset(line,0, sizeof(line));
        fgets(line,sizeof(line) - 1, transSorted713);
        fprintf(updatedMaster,"%s", line);
    }
    while(!feof(transSorted711))  {
        memset(line,0, sizeof(line));
        fgets(line,sizeof(line) - 1, transSorted711);
        fprintf(updatedMaster,"%s", line);
    }
    fclose(transSorted711);
    fclose(transSorted713);
    fclose(updatedMaster);


    strcpy(path,"updatedMaster.txt");
    strcpy(sort_path,"transSorted.txt");
    sort_transaction(path, sort_path);

    //update

    //copy master to negReport,use it as temporary storage
    master = fopen( "master.txt" , "r" );
    negReport = fopen( "negReport.txt" , "w" );
    while(!feof(master))  {
        memset(line,0, sizeof(line));
        fgets(line,sizeof(line) - 1, master);
        fprintf(negReport,"%s", line);
    }
    fclose(negReport);
    fclose(master);


    int num = 0;
    char *account = malloc(16*sizeof(char));
    char *last_account = malloc(16*sizeof(char));
    long change = 0;//change of balance

    int new_account = 0;

    transSorted = fopen( "transSorted.txt" , "r" );

    do {
        change = 0;
        for(int i =0;i<24;i++){
            input = fgetc( transSorted );
            line[i]=input;
        }
        //restore change
        for (int i =17;i<24&& new_account ==0;i++){
            long a = (line[i]-'0');
            long b = i;
            while (b<23){
                a*=10;
                b+=1;
            }
            change += a;
        }

        //check the account
        for (int i =0;i<16&& new_account ==0;i++){
             if (line[i]!=account[i]){
                new_account = 1;
             }
        }
        //update the change value
        if (line[16] == 'W'){
            change*= -1;
        }

        //new_account,update the final balance
            for (int i =0;i<16;i++){
                 account[i]=line[i];//change into new_account
             }
            if(change != 0){
                updatebalance(account,change);
                //update the changes
             if(change != 0){
                updatedMaster = fopen( "updatedMaster.txt" , "r" );
                negReport = fopen( "negReport.txt" , "w" );
                while(!feof(updatedMaster))  {
                    memset(line,0, sizeof(line));
                    fgets(line,sizeof(line) - 1, updatedMaster);
                    fprintf(negReport,"%s", line);
                 }
                  fclose(negReport);
                  fclose(updatedMaster);
                }
             }
        if (new_account){
            new_account = 0;

        }
        while(input!='\n'&&input!=EOF){
            input = fgetc( transSorted );
        }//clear the space
    }while (input != EOF);

    //report
    updatedMaster = fopen( "updatedMaster.txt" , "r" );
    negReport = fopen( "negReport.txt" , "w" );
    do{
        for(int i =0;i<58;i++){
            input = fgetc( updatedMaster );
            line[i]=input;
        }
        //negative
        if(line[42]=='-'){
            fprintf(negReport,"Name: ");
            for (int i=0;i<20;i++){
                fprintf(negReport,"%c",line[i]);
            }
            fprintf(negReport," Account Number: ");
            for (int i=20;i<36;i++){
                fprintf(negReport,"%c",line[i]);
            }
            fprintf(negReport," Balance: ");
            for (int i=42;i<58;i++){
                fprintf(negReport,"%c",line[i]);
            }
            fprintf(negReport,"\n");
        }

        while(input!='\n'&& input!=EOF){
            input = fgetc( updatedMaster );
        }//clear the space
    }while (input != EOF);

    fclose(updatedMaster);
    fclose(negReport);

    //closure
    fclose(trans711);
    fclose(trans713);
    fclose(transSorted711);
    fclose(transSorted713);
    fclose(transSorted);

    return 0;
}
