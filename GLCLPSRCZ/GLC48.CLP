/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Accounts Opened and Closed')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC48 - ACCOUNTS OPENED AND CLOSED                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CTI005             Date 12Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. BHF798             Date 25Apr91              */
/*                      S01194             Date 16Mar89              */
/*       PREV AMEND.NO. S01117             DATE  02/03/89           */
/*                      E11873             DATE  11/05/88           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CTI005 - Midas Plus-TI Integration Enhancements             */
/*                Automatic Account Opening                          */
/*       BHF798  -  FIX TO CLOF INCASE OF MULTIPLE CALL             */
/*       S01194   -   NEW STANDING DATA                             */
/*       MB105  - ACDET* FILES SHOULD NOT BE CLEARED                */
/*                THEY ARE REQUIRED FOR SUBSEQUENT OFFLINE REPORTS  */
/*       S01117   -   MULTIBRANCHING                                */
/*       E11873   -   DATA BASE ERROR HANDLING                      */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                               **/  /* S01117 */
             PGM        PARM(&RSEQ &RLEV &RENT)                      /*S01117 */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */ /*E11873*/   /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
/*********** DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)*/             /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                /*S01117 */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                /*S01117 */
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                /*S01117 */
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CTI005*/
             DCL        VAR(&CTI005) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CTI005*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CTI005*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CTI005*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)                                   /*CTI005*/
/**/
             SNDPGMMSG  MSG('GLC48 - Accounts Opened and Closed') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABGL) SHARE(*NO)*/       /*S01194*/
/**********  CALL       PGM(GL0480)                               *//* S01117 */
                IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                           THEN(DO)                                   /*S01117*/
                           OVRDBF FILE(SADETB) POSITION(*KEY 1 +
                           ACCNTAB &RENT)                             /*S01117*/
                          OPNDBF FILE(SADETB) OPTION(*ALL)            /*S01117*/
                          MONMSG MSGID(CPF0000) EXEC(DO)              /*S01117*/
                          DLTOVR FILE(SADETB)                         /*S01117*/
                          ENDDO                                       /*S01117*/
                          ENDDO                                       /*S01117*/
             CALL       PGM(GL0480) PARM(&RSEQ &RENT)                /*S01117 */
/*********** DLTOVR     FILE(TABLE TABLED)*/                          /*S01194*/
             DLTOVR     FILE(SADETB)                                  /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
/***********    IF         COND(%SUBSTRING(&MMOD 26 1) *EQ 'N') THEN(DO)S01117*/
/**/
 /***              CLRPFM     FILE(ACDETAA)     ***/                /* S01117*/
 /***              CLRPFM     FILE(ACDETAB)     ***/                /* S01117*/
  /***             CLRPFM     FILE(ACDETAC)     ***/                /* S01117*/
/**/
 /***           ENDDO                           ***/                /* S01117*/
/**/
             ENDDO
/**/
/*           DATABASE ERROR MESSAGE SENDING             */   /*E11873*/
/*           ELSE       CMD(DO)                         */   /*E11873*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)     /*E11873*/
 
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM) /*E11873*/  /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)                     /*E11873*/
             ENDDO                                           /*E11873*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)     /*E11873*/
/**/
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - SADET') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - SADET') +
                             TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             CLOF       OPNID(SADETB)                                 /*BHF798*/
                          MONMSG MSGID(CPF0000)                       /*BHF798*/
/**/                                                                                      /*CTI005*/
/* Check if switchable feature CTI005 is ON */                                            /*CTI005*/
/**/                                                                                      /*CTI005*/
             CHGVAR     VAR(&SARD) VALUE('CTI005')                                        /*CTI005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CTI005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CTI005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CTI005*/
/**/                                                                                      /*CTI005*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CTI005*/
                          CHGVAR VAR(&CTI005) VALUE('Y')                                  /*CTI005*/
             ENDDO                                                                        /*CTI005*/
/**/                                                                                      /*CTI005*/
             IF         COND(%SWITCH(XXXXXX00) *AND &CTI005 *EQ 'Y') THEN(DO)             /*CTI005*/
             CALL       PGM(TI0390) PARM(&RSEQ)                                           /*CTI005*/
             ENDDO                                                                        /*CTI005*/
/**/                                                                  /*BHF798*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
