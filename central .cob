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
       PROGRAM-ID. CENTRAL.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MASTER ASSIGN TO  "master.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS711 ASSIGN TO "trans711.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713 ASSIGN TO "trans713.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSS711 ASSIGN TO "transSorted711.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSS713 ASSIGN TO "transSorted713.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSS ASSIGN TO "transSorted.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT UMASTER ASSIGN TO "updatedMaster.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT NEGR ASSIGN TO "negReport.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT WORK1 ASSIGN TO "transSorted.txt"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT WORK2 ASSIGN TO "updatedMaster.txt"
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

       FD  TRANSS711.
       01  TRANSS1.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)   VALUE 0.

       FD  TRANSS713.
       01  TRANSS2.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)   VALUE 0.

       FD  TRANSS.
       01  TRANS.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)   VALUE 0.

       FD  UMASTER.
       01  UACCOUNT.
           03 HOLDER PIC X(20)  VALUE "0".
           03 AID PIC X(16)  VALUE "0".
           03 PWD PIC X(6)  VALUE "0".
           03 BALANCE PIC S9(15)  VALUE 0.

       FD  NEGR.
       01  REP.
           03 TIP1 PIC X(6) VALUE "NAME: ".
           03 HOLDER PIC X(20)  VALUE "0".
           03 TIP2 PIC X(17) VALUE " ACCOUNT NUMBER: ".
           03 AID PIC X(16)  VALUE "0".
           03 TIP3 PIC X(10) VALUE " BALANCE: ".
           03 BALANCE PIC S9(15)  VALUE 0.

       SD  WORK1.
       01  TRANSW.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)  VALUE 0.

       SD  WORK2.
       01  TRANSW2.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)  VALUE 0.

       WORKING-STORAGE SECTION.

       01  SMALLER PIC 9(1) VALUE 1.
       01  INP PIC X(1)   VALUE "0".
       01  TS PIC 9(5)   VALUE 0.
       01  EOF PIC 9(1)   VALUE 0.
       01  ACTION_TYPE PIC X(1)   VALUE "0".
       01  ATMID PIC X(1)  VALUE "0".
       01  INP_ACCOUNT PIC X(16)  VALUE "0".
       01  INP_PWD PIC X(6)  VALUE "0".
       01  AMOUNT PIC 9(13)V9(2)  VALUE 0.

       01  END0 PIC 9(1) VALUE 0.
       01  END1 PIC 9(1) VALUE 0.
       01  END2 PIC 9(1) VALUE 0.

       01  USER_ACCOUNT.
           03 HOLDER PIC X(20)  VALUE "0".
           03 AID PIC X(16)  VALUE "0".
           03 PWD PIC X(6)  VALUE "0".
           03 BALANCE PIC S9(15)  VALUE 0.

       01  TRANSACTION1.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)  VALUE 0.

       01  TRANSACTION2.
           03 AID PIC X(16)  VALUE "0".
           03 ACT PIC X(1)  VALUE "0".
           03 MONEY PIC 9(7)  VALUE 0.
           03 TIMESTAMP PIC 9(5)  VALUE 0.


       PROCEDURE DIVISION.


       MAIN-PROCEDURE.
           OPEN INPUT TRANS711.
           OPEN OUTPUT TRANSS711.
           SORT WORK1 ON ASCENDING KEY AID IN TRANS1
                      ON ASCENDING KEY TIMESTAMP IN TRANS1
           USING TRANS711 GIVING TRANSS711.

           CLOSE TRANS711.
           CLOSE TRANSS711.

           OPEN INPUT TRANS713.
           OPEN OUTPUT TRANSS713.
           SORT WORK1 ON ASCENDING KEY AID IN TRANS2
                      ON ASCENDING KEY TIMESTAMP IN TRANS2
           USING TRANS713 GIVING TRANSS713.

           CLOSE TRANS713.
           CLOSE TRANSS713.

           OPEN INPUT TRANSS711.
           OPEN OUTPUT TRANSS.
           GO TO MERGE1.


       MERGE1.

           IF END1 = 0 THEN
               READ TRANSS711 INTO TRANSS1
                   AT END
                       MOVE 1 TO END1
                       MOVE 2 TO SMALLER
                   END-READ
                   MOVE TRANSS1 TO TRANS
           END-IF.

           IF AID IN TRANS NOT = '0' THEN
               WRITE TRANS
           END-IF.

           IF END1 NOT = 0 THEN
               GO TO MERGE1
           END-IF.

           OPEN INPUT TRANSS713.
           CLOSE TRANSS711.
           GO TO MERGE2.


       MERGE2.
           IF END2 = 0 THEN
               READ TRANSS713 INTO TRANSS2
                   AT END
                       MOVE 1 TO END2
                   END-READ
                   MOVE TRANSS2 TO TRANS
           END-IF.

           IF AID IN TRANS NOT = '0' THEN
               WRITE TRANS
           END-IF.

           IF END2 NOT = 0 THEN
               GO TO MERGE2
           END-IF.

           CLOSE TRANSS713.
           CLOSE TRANSS.
           GO TO MERGE3.


       MERGE3.
           SORT WORK2 ON ASCENDING KEY AID IN TRANS
                      ON ASCENDING KEY TIMESTAMP IN TRANS
           USING TRANSS GIVING TRANSS.
           GO TO UPDATEMASTER.

       UPDATEMASTER.
           OPEN INPUT MASTER
           OPEN OUTPUT UMASTER
           MOVE 0 TO END1
           MOVE 0 TO END2
           GO TO UPDATEMASTER2.

       UPDATEMASTER2.
           IF END1 =0 THEN
               READ MASTER INTO ACCOUNT
               AT END
                   MOVE 1 TO END1
               END-READ
               MOVE ACCOUNT TO USER_ACCOUNT
               OPEN INPUT TRANSS
               GO TO UPDATE_BALANCE
           END-IF.

           IF END1 = 1 THEN
               CLOSE MASTER
               CLOSE UMASTER
               MOVE 0 TO END1
               GO TO GIVE_REPORT

           END-IF.
           GO TO UPDATEMASTER2.

       UPDATE_BALANCE.
           IF END2 = 0 THEN
               READ TRANSS INTO TRANS
               AT END
                   MOVE 1 TO END2
               END-READ
           IF AID IN TRANS = AID IN USER_ACCOUNT THEN
               IF ACT IN TRANS = 'W' THEN
                   SUBTRACT 0 FROM MONEY IN TRANS GIVING MONEY IN TRANS
               END-IF
               GO TO UPDATEMASTER2
           END-IF.

           IF END2 = 1 THEN
               CLOSE TRANSS
               IF AID IN USER_ACCOUNT NOT = '0' THEN
                   ADD MONEY IN TRANS TO BALANCE IN USER_ACCOUNT
                   MOVE USER_ACCOUNT TO UACCOUNT
                   WRITE UACCOUNT
               END-IF
               MOVE 0 TO END2
               GO TO UPDATEMASTER2
           END-IF.
           GO TO UPDATE_BALANCE.

       GIVE_REPORT.
           OPEN INPUT UMASTER.
           OPEN OUTPUT NEGR.
           GO TO GENERATE_REPORTS.

       GENERATE_REPORTS.
           IF END1 = 0 THEN
               READ UMASTER INTO UACCOUNT
               AT END
                   MOVE 1 TO END1
               END-READ
           IF BALANCE IN UACCOUNT < 0 THEN
               MOVE HOLDER IN UACCOUNT TO HOLDER IN REP
               MOVE AID IN UACCOUNT TO HOLDER IN REP
               MOVE BALANCE IN UACCOUNT TO HOLDER IN REP
               WRITE REP
           END-IF.

           IF END1 = 1 THEN
               CLOSE UMASTER
               CLOSE NEGR
               STOP RUN
           END-IF.


       STOP RUN.
       END PROGRAM CENTRAL.
