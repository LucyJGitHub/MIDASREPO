/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Customer Collateral Report')                 */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0802   CUSTOMER COLLATERAL REPORT                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29113                  DATE  02OCT91       */
/*       PREV AMEND NO. S01117                  DATE  09JAN91       */
/*                      E23408                  DATE  06SEP90       */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         E29113 - FIELD CSBR STILL USED BUT SHOULD HAVE BEEN      */
/*                  CHANGED TO CSBA.                                */
/*         S01117 - MULTIBRANCHING                                  */
/*         E23408 - SETON U1 IF RETAIL II OR INTEREST ON ACCOUNTS   */
/*                  SWITCHED ON IN SYSTEM.                          */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
 
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(MMOD)                         ********  *S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
 
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(MMOD)                        *********  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
 
/* SETUP AND SEND PGM MESSAGE                          */
 
 
             CHGVAR     VAR(&MSG)  +
             VALUE('SEC0802 - Customer Collateral Report')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                    */
 
             CHGJOB     SWS(00000000)
 
/*     RESET SWITCHES                                               */
 
/************IF*********COND(%SST(&MMOD 16 1) = 'Y')*************+*E23408*/
/***********************THEN(CHGJOB SWS(1XXXXXXX))*****************E23408*/
             IF         COND((%SST(&MMOD 16 1) = 'Y') *OR +
                          (%SST(&MMOD 23 1) = 'Y')) THEN(CHGJOB +
                          SWS(1XXXXXXX))                         /*E23408*/
             IF         COND(%SST(&MMOD  2 1) = 'Y')             +
                        THEN(CHGJOB SWS(X1XXXXXX))
             IF         COND(%SST(&MMOD 10 1) = 'Y')             +
                        THEN(CHGJOB SWS(XX1XXXXX))
 
/*  OVERIDE DATABASE FILE                      */
 
             OVRDBF     FILE(CPOSNQ2) TOFILE(CPOSND) SHARE(*YES)
 
 
/*  OPEN QUERY FILE CPOSNQ2 */
/*           OPNQRYF    FILE((CPOSND) (SECTY) (INVTPD) (CLINTCB) +      S01179*/
/*                        (CLINTSE)) FORMAT(CPOSNQ2) QRYSLT('RECI.1 +   S01179*/
/*                        *EQ ''D''') KEYFLD((CSBR.1) (ACOC.4) +        S01179*/
/*                        (C1DI.5) (CSCN.1)) JFLD((CSSC.1 SESN.2) +     S01179*/
/*                        (SITP.2 INVT.3) (NMCY.2 CCYI.3)         +     S01179*/
/*                        (CSCN.1 CNUM.4) (CSCN.1 CNUM.5))              S01179*/
 
/*********** OPNQRYF    FILE((CPOSND) (SECTY) (INVTPD) (CLINTCB) +      E29113*/
/***********              (CLINTSE)) FORMAT(CPOSNQ2) QRYSLT('1/RECI +   E29113*/
/***********              *EQ ''D''') KEYFLD((1/CSBR) (4/ACOC) +        E29113*/
/***********              (5/C1DI) (1/CSCN)) JFLD((1/CSSC 2/SESN) +     E29113*/
/***********              (2/SITP 3/INVT) (2/NMCY 3/CCYI) (1/CSCN +     E29113*/
/***********              4/CNUM) (1/CSCN 5/CNUM))              S01179 *E29113*/
             OPNQRYF    FILE((CPOSND) (SECTY) (INVTPD) (CLINTCB) +
                          (CLINTSE)) FORMAT(CPOSNQ2) QRYSLT('1/RECI +
                          *EQ ''D''') KEYFLD((1/CSBA) (4/ACOC) +
                          (5/C1DI) (1/CSCN)) JFLD((1/CSSC 2/SESN) +
                          (2/SITP 3/INVT) (2/NMCY 3/CCYI) (1/CSCN +
                          4/CNUM) (1/CSCN 5/CNUM))                    /*E29113*/
 
/* CALL THE PROGRAM 1E1050                        */
 
/************CALL       PGM(SE1050)                                  * *S01117*/
             CALL       PGM(SE1050) PARM(&RSEQ &RENT)                 /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA      */
 
 ERROR:
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0802 - Job Terminated, +
                          Database in error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 ENDPGM:     RCLRSC
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
