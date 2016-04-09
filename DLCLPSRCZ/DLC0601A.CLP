/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL LIST OF TODAYS DEALS')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0601A - DAILY ACTIVITY REPORTS                          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD030956                Date  09Oct14       */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL038                  Date  10May05       */
/*                      CDL021                  Date  03Feb04       */
/*                      CTI004                  Date  12Apr04        */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      116082                  Date  08Jan97        */
/*                      E47978                  Date  01Feb93        */
/*                      AUS016                  DATE  14SEP92       */
/*                      S01319                  DATE  30SEP90       */
/*                      E293                    DATE  29MAR90       */
/*                      E263                    DATE  14MAR90       */
/*                      S01194                  DATE  11/08/89      */
/*                      S01179                  DATE  12/09/88      */
/*                      E12574                  DATE  10/03/88      */
/*                      S01136                  DATE  04/01/88      */
/********************************************************************/
/*                                                                  */
/*       MD030956 - Additional changes to BFM-TI enhancement        */
/*       CDL038 - Extended Deal Sub Type                            */
/*       CDL021  -  Reports by Deal Type                            */
/*       CTI004 - MidasPlus-TI Integration Enhancements              */
/*                FX Deals Integration                               */
/*       116082  -  IF S01471 IS ON THEN CHANGE OVERFLOW VALUE FOR  */
/*                  DL0205P1 TO 51 (AS IN PROGRAM DLC0214) SO PAGE  */
/*                  ENDINGS COME OUT CORRECTLY.                     */
/*       E47978  -  CLOF MUST BE MONITORED AS OPNDBF MAY FAIL IF NO */
/*                  RECORDS FOUND FOR KEY POSITION.  ALSO, CLOF IN  */
/*                  WRONG PLACE.                                    */
/*       AUS016  -  FX/MM List of Today's Deals                     */
/*       S01319  -  Remove redundant processing                     */
/*       E293 - ENSURE ALL RPG USE SAME SEQ NO FROM DL0205          */
/*       E263   - PROG SHOULD PASS SEQUENCE NO. TO DL0205           */
/*       S01194 - NEW STANDING DATA FILES                           */
/*       S01179 - AS400 CONVERSION                                  */
/*       E12574 - PROGRAM RECOMPILED DUE TO MMOD CHANGED LENGTH     */
/*                TO 256 FOR MRPLIB22                               */
/*       S01136 - DRS 'TODAY'S DEALS DELETED 'REPORT CALLED -       */
/*                PROGRAM DL0205A                                   */
/********************************************************************/
/************PGM                                                   */ /*AUS016*/
/**********  PGM        PARM(&TYPE &RSEQ &RLVL &RENT)                              /*AUS016 CDL021*/
             PGM        PARM(&TYPE &RSEQ &RLVL &RENT &PARMS)                              /*CDL021*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/************DCLDTAARA  DTAARA(MMOD)                             S01136 S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*E263*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*AUS016*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*AUS016*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                 /*AUS005*/
/************DCL********VAR(&PARMS)*TYPE(*CHAR)*LEN(4)***************************CDL021*/ /*CDL038*/
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(8)                                    /*CDL038*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*116082*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CTI004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CTI004*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)                                   /*CTI004*/
/*/COPY WNCPYSRC,DLC0601A03                                          */
 
/*   LIST OF TODAYS DEALS                                        */
             IF         COND((&TYPE *NE 'FX') *AND (&TYPE *NE 'MM')) +
                        THEN(DO)                                      /*AUS016*/
             SNDPGMMSG  MSG('LIST OF TODAYS DEALS') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             ENDDO                                                    /*AUS016*/
/* */                                                                 /*AUS016*/
/** List of Todays FX Deals                                        */ /*AUS016*/
/* */                                                                 /*AUS016*/
             IF         COND(&TYPE *EQ 'FX') THEN(DO)                 /*AUS016*/
                        SNDPGMMSG  MSG('LIST OF TODAYS FX DEALS') +
                                   TOMSGQ(MRUNQ) MSGTYPE(*INFO)       /*AUS016*/
             ENDDO                                                    /*AUS016*/
/* */                                                                 /*AUS016*/
/** List of Todays MM Deals                                        */ /*AUS016*/
/* */                                                                 /*AUS016*/
             IF         COND(&TYPE *EQ 'MM') THEN(DO)                 /*AUS016*/
                        SNDPGMMSG  MSG('LIST OF TODAYS MM DEALS') +
                                   TOMSGQ(MRUNQ) MSGTYPE(*INFO)       /*AUS016*/
             ENDDO                                                    /*AUS016*/
/* */                                                                 /*AUS016*/
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/**/                                                                  /*S01390*/
/*  POSITION FILE IF FOR A SPECIFIC BRANCH */                         /*S01390*/
/**/                                                                  /*S01390*/
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                          '   ')) THEN(DO)                            /*S01390*/
             OVRDBF     FILE(DTRSD) POSITION(*KEY 3 DTRIXDF ('DD' +
                          *CAT &RENT))                                /*S01390*/
                OPNDBF     FILE(DTRSD) OPTION(*ALL)                   /*S01390*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*S01390*/
                   DLTOVR     FILE(DTRSD)                             /*S01390*/
                ENDDO                                                 /*S01390*/
/***************CLOF       OPNID(DTRSD)                    /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
/************CHGVAR     VAR(&RSEQ) VALUE('     ')               *E263* *AUS016*/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLEE)       /*E0052*/   /*S01194*/
 
/************CALL       PGM(DL0205)                                     E263*/
/************CALL       PGM(DL0205) PARM(&RSEQ)           */ /*E263*/ /*AUS016*/
                                                                      /*116082*/
/* CHECK IF S01471 IS SWITCHED ON AND IF SO, OVERIDE OVERFLOW FOR +
   PRINTER FILE DL0205P1 TO 51 */                                     /*116082*/
                                                                      /*116082*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE '*VERIFY' +
                          'S01471' '')                                /*116082*/
                                                                      /*116082*/
             IF         COND(&RTNCDE *EQ '       ') THEN(OVRPRTF +
                          FILE(DL0205P1) OVRFLW(51))                  /*116082*/
/*/COPY WNCPYSRC,DLC0601A01                                          */
/**********  CALL       PGM(DL0205) PARM(&TYPE &RSEQ &RENT)                        /*AUS016 CDL021*/
             CALL       PGM(DL0205) PARM(&TYPE &RSEQ &RENT &PARMS)                        /*CDL021*/
/*/COPY WNCPYSRC,DLC0601A04                                          */
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   +
                          ')) THEN(DO)                                /*AUS016*/
             DLTOVR     FILE(DTRSD)                                   /*AUS016*/
                CLOF       OPNID(DTRSD)                               /*E47978*/
                MONMSG CPF0000                                        /*E47978*/
             ENDDO                                                    /*AUS016*/
/*/COPY WNCPYSRC,DLC0601A02                                          */
/* */                                                                 /*AUS016*/
/** Only Performed for All Types of Deals                          */ /*AUS016*/
/* */                                                                 /*AUS016*/
             IF         COND((&TYPE *NE 'FX') *AND (&TYPE *NE 'MM')) +
                        THEN(DO)                                      /*AUS016*/
/* */                                                                 /*AUS016*/
/*   INTERNAL CONTRACT TRANSACTIONS INPUT TODAY                  */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                SNDPGMMSG  MSG('INTERNAL CONTRACT TRANSACTIONS IN+
                           PUT TODAY') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*************  OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/*************  OVRDBF     FILE(TABLED) TOFILE(TABDLEE)               /*S01194*/
/************** CALL       PGM(DL2460)                                /*E293*/
 
/* RSEQ ALLOCATED BY DL0205 IS NOW PASSED TO DL2460  */
                CALL       PGM(DL2460) PARM(&RSEQ)
/*************  DLTOVR     FILE(TABLED)                               /*S01194*/
             ENDDO
/************DLTOVR     FILE(TABLE)                                   /*S01194*/
/*   TODAY'S DRS DEALS DELETED                                       */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(DRSCHK))                            /*S01136*/
             ELSE       CMD(GOTO CMDLBL(ERRCHK))                     /*S01136*/
DRSCHK:                                                              /*S01136*/
/**********  RCVDTAARA  DTAARA(MMOD)                             S01136 S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)             /*S01136 S01179*/
             IF         ((%SUBSTRING(&MMOD 13 2)  *EQ 'YY') *OR  +
                         (%SUBSTRING(&MMOD 13 2)  *EQ 'YN') *OR  +
                         (%SUBSTRING(&MMOD 13 2)  *EQ 'NY'))     +
                        THEN(DO)                                     /*S01136*/
 
/************SNDPGMMSG*MSG('LIST OF INCOMPLETE AND COMPLETE DEALS +*/ /*S01319*/
/*************DELETED TODAY')*TOMSGQ(MRUNQ)*MSGTYPE(*INFO) /*S01136*/ /*S01319*/
             SNDPGMMSG  MSG('LIST OF UNAUTHORISED DEALS DELETED +
                          TODAY') TOMSGQ(MRUNQ) MSGTYPE(*INFO)        /*S01319*/
/* RSEQ ALLOCATED BY DL0205 IS NOW PASSED TO DL0205A */
/************CALL       PGM(DL0205A)                                  /*E293*/
             CALL       PGM(DL0205A) PARM(&RSEQ)
             ENDDO                                                   /*S01136*/
/**/                                                                                      /*CTI004*/
/* List of FX deals received from Trade Innovation */                                     /*CTI004*/
/**/                                                                                      /*CTI004*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CTI004*/
                                                                                          /*CTI004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CTI004*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                                       /*CTI004*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)                              /*CTI004*/
                                                                                          /*CTI004*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE '*VERIFY' +
                          'CTI006' '')                                                  /*MD030956*/
/**********  IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(DO)                         /*MD030956*/
             IF         COND((%SST(&FMT 103 1) *EQ 'Y') *OR &RTNCDE +
                          *EQ '       ') THEN(DO)                                       /*MD030956*/
                                                                                          /*CTI004*/
             SNDPGMMSG  MSG('LIST OF FX DEALS RECEIVED FROM TRADE +
                          INNOVATION') TOMSGQ(MRUNQ) MSGTYPE(*INFO)                       /*CTI004*/
             CALL       PGM(DL0208) PARM(&RSEQ)                                           /*CTI004*/
                                                                                          /*CTI004*/
             ENDDO                                                                        /*CTI004*/
             ENDDO                                                                        /*CTI004*/
/* */                                                                 /*AUS016*/
             ENDDO                                                    /*AUS016*/
ERRCHK:                                                              /*S01136*/
/*   ERROR MESSAGES                                           */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
