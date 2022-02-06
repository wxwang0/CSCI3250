      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      * CSCI3180 Principles of Programming Languages
      *
      * --- Declaration ---
      *
      * I declare that the assignment here submitted is original except for source
      * material explicitly acknowledged. I also acknowledge that I am aware of
      * University policy and regulations on honesty in academic work, and of the
      * disciplinary guidelines and procedures applicable to breaches of such policy
      * and regulations, as contained in the website
      * http://www.cuhk.edu.hk/policy/academichonesty/
      *
      * Assignment 1
      * Name : Wang Wei Xiao
      * Student ID : 1155141608
      * Email Addr : 1155141608@cse.cuhk.edu.hk
      *
      ******************************************************************
              IDENTIFICATION DIVISION.
       PROGRAM-ID. ATMS.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MASTER ASSIGN TO  "master.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS711 ASSIGN TO "trans711.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713 ASSIGN TO "trans713.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  MASTER.
       01  ACCOUNT.
           03 HOLDER PIC X(20)  VALUE "0".
           03 AID PIC X(16)  VALUE "0".
           03 PWD PIC X(6)  VALUE "0".
           03 BALANCE PIC S9(15)  VALUE 0.

       FD  TRANS711.
       01  TRANS1.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)  VALUE 0.

       FD  TRANS713.
       01  TRANS2.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)   VALUE 0.

       WORKING-STORAGE SECTION.

       01  INP PIC X(1)   VALUE "0".
       01  TS PIC 9(5)   VALUE 0.
       01  EOF PIC 9(1)   VALUE 0.
       01  ACTION_TYPE PIC X(1)   VALUE "0".
       01  ATMID PIC X(1)  VALUE "0".
       01  INP_ACCOUNT PIC X(16)  VALUE "0".
       01  INP_PWD PIC X(6)  VALUE "0".
       01  AMOUNT PIC 9(13)V9(2)  VALUE 0.
       01  USER_ACCOUNT.
           02 AID PIC X(16)   VALUE "0".
           02 PWD PIC X(6)   VALUE "0".
           02 BALANCE PIC S9(15)   VALUE 0.
       01  TARGET_ACCOUNT.
           02 AID PIC X(16)   VALUE "0".



       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           DISPLAY "##############################################"
           DISPLAY "##         GRINGOTTS WIZARDING BANK         ##"
           DISPLAY "##                 WELCOME                  ##"
           DISPLAY "##############################################"
           GO TO CHOOSE_ATM.

       CHOOSE_ATM.
           DISPLAY "PLEASE CHOOSE THE ATM"
           DISPLAY "PRESS 1 FOR ATM 711"
           DISPLAY "PRESS 2 FOR ATM 713"

           ACCEPT INP FROM SYSIN.
           IF INP NOT = "1" AND INP NOT = "2" THEN
              DISPLAY "INVALID INPUT"
              GO TO CHOOSE_ATM
           END-IF.

           MOVE INP TO ATMID.
           GO TO INPUT_ACC.


       INPUT_ACC.
           DISPLAY "ACCOUNT"
           ACCEPT INP_ACCOUNT FROM SYSIN.
           DISPLAY "PASSWORD"
           ACCEPT INP_PWD FROM SYSIN.
           OPEN INPUT MASTER.
           GO TO FIND_ACCOUNT.


       FIND_ACCOUNT.
           READ MASTER INTO ACCOUNT
               AT END
                  DISPLAY " INCORRECT ACCOUNT/PASSWORD"
                  MOVE 1 TO EOF
               END-READ.

           IF EOF = 1 THEN
               CLOSE MASTER
               GO TO INPUT_ACC
           END-IF.

           IF AID IN ACCOUNT = INP_ACCOUNT AND PWD IN ACCOUNT = INP_PWD AND BALANCE IN ACCOUNT > 0 THEN
               CLOSE MASTER
               MOVE AID IN ACCOUNT TO AID IN USER_ACCOUNT
               MOVE BALANCE IN ACCOUNT TO AID IN USER_ACCOUNT
               GO TO CHOOSE_TYPE
           END-IF.

           IF AID IN ACCOUNT = INP_ACCOUNT AND PWD IN ACCOUNT = INP_PWD AND BALANCE IN ACCOUNT < 0 THEN
               DISPLAY " NEGATIVE REMAINS TRANSACTION ABORT"
               CLOSE MASTER
               GO TO CHOOSE_ATM
           END-IF.

           GO TO FIND_ACCOUNT.

       CHOOSE_TYPE.
           DISPLAY " PLEASE CHOOSE YOUR SERVICE"
           DISPLAY " PRESS D FOR DEPOSIT"
           DISPLAY " PRESS W FOR WITHDRAW"
           DISPLAY " PRESS T FOR TRANSFER"
           ACCEPT INP FROM SYSIN.

           IF INP = 'D' THEN
               MOVE 'D' TO ACTION_TYPE
               GO TO DEPOSIT
           END-IF.

           IF INP = 'W' THEN
               MOVE 'W' TO ACTION_TYPE
               GO TO WITHDRAW
           END-IF.

           IF INP = 'T' THEN
               MOVE 'T' TO ACTION_TYPE
               GO TO TRANSFER
           END-IF.

           DISPLAY " INVALID INPUT"
           GO TO CHOOSE_TYPE.



       DEPOSIT.
           DISPLAY " AMOUNT"
           ACCEPT AMOUNT FROM SYSIN.
           IF AMOUNT <0 THEN
               DISPLAY " INVALID INPUT"
               GO TO DEPOSIT
           END-IF.
           GO TO PRINT_DATA.

       WITHDRAW.
           DISPLAY " AMOUNT"
           ACCEPT AMOUNT FROM SYSIN.

           IF AMOUNT <0 THEN
                DISPLAY " INVALID INPUT"
               GO TO WITHDRAW
           END-IF.
           IF AMOUNT > BALANCE IN USER_ACCOUNT THEN
               DISPLAY " INSUFFICIENT BALANCE"
               GO TO WITHDRAW
           END-IF.
           GO TO PRINT_DATA.

       TRANSFER.
           DISPLAY " TARGET ACCOUNT"
           ACCEPT INP_ACCOUNT FROM SYSIN.
           IF INP_ACCOUNT = AID IN USER_ACCOUNT THEN
               DISPLAY " YOU CANNOT TRANSFER TO YOURSELF"
               GO TO TRANSFER
           END-IF.

           IF AMOUNT > BALANCE IN USER_ACCOUNT THEN
               DISPLAY " INSUFFICIENT BALANCE"
               GO TO TRANSFER
           END-IF.
           MOVE INP_ACCOUNT TO AID IN TARGET_ACCOUNT.
           GO TO PRINT_DATA.

       PRINT_DATA.
           IF ATMID = "1" THEN

               OPEN OUTPUT TRANS711
               MOVE AID IN USER_ACCOUNT TO AID IN TRANS1

               IF ACTION_TYPE = 'D' THEN
                  MOVE 'D' TO ACT IN TRANS1
               END-IF
               IF ACTION_TYPE = 'W' OR ACTION_TYPE = 'T' THEN
                  MOVE 'W' TO ACT IN TRANS1
               END-IF

               MOVE AMOUNT TO MONEY IN TRANS1
               MOVE TS TO TIMESTAMP IN TRANS1
               WRITE TRANS1

               ADD 1 TO TS

               IF ACTION_TYPE = 'T' THEN
                  MOVE AID IN TARGET_ACCOUNT TO AID IN TRANS1
                  MOVE 'D' TO ACT IN TRANS1
                  MOVE AMOUNT TO MONEY IN TRANS1
                  MOVE TS TO TIMESTAMP IN TRANS1
               END-IF
               WRITE TRANS1

               ADD 1 TO TS

               CLOSE TRANS711
           END-IF.

           IF ATMID = "2" THEN
               OPEN OUTPUT TRANS713
               MOVE AID IN USER_ACCOUNT TO AID IN TRANS2

               IF ACTION_TYPE = 'D' THEN
                  MOVE 'D' TO ACT IN TRANS2
               END-IF
               IF ACTION_TYPE = 'W' OR ACTION_TYPE = 'T' THEN
                  MOVE 'W' TO ACT IN TRANS2
               END-IF

               MOVE AMOUNT TO MONEY IN TRANS2
               MOVE TS TO TIMESTAMP IN TRANS2
               WRITE TRANS2

               ADD 1 TO TS

               IF ACTION_TYPE = 'T' THEN
                  MOVE AID IN TARGET_ACCOUNT TO AID IN TRANS1
                  MOVE 'D' TO ACT IN TRANS2
                  MOVE AMOUNT TO MONEY IN TRANS2
                  MOVE TS TO TIMESTAMP IN TRANS2
               END-IF
               WRITE TRANS2

               ADD 1 TO TS

               CLOSE TRANS713
           END-IF.

           GO TO ASK_CONTINUE.

           ASK_CONTINUE.
               DISPLAY" CONTINUE"
               ACCEPT INP FROM SYSIN.
               IF INP NOT = 'Y' AND INP NOT = 'N' THEN
                   DISPLAY " INVALID INPUT"
                   GO TO ASK_CONTINUE
               END-IF.
               IF INP ='Y' THEN
                   GO TO CHOOSE_ATM
               END-IF.
               IF INP = 'N' THEN
                   STOP RUN
               END-IF.


           STOP RUN.
       END PROGRAM ATMS.
