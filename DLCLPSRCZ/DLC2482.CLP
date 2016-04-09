/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deals By Customer Print (Batch) des date')   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC2482  DEALS BY CUSTOMER PRINT SUBMIT TO RCF             */
/*                LISTED IN DESCENDING DATE ORDER                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL038             Date 10May05             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev amend no. 046779             DATE 06NOV92             */
/*                      AUS015             DATE 24AUG92             */
/*                      E26937             DATE 10OCT91             */
/*                      DT0204             DATE 05JUN91             */
/*                      E20773             DATE 25FEB90             */
/*                      S01117             DATE 17/07/89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*                                                                  */
/*     THIS PROGRAM WAS CREATED FROM DLC2481                        */
/*     PLEASE NOTE THAT ALTHOUGH THE ERROR NUMBERS FROM DLC2481     */
/*     HAVE BEEN LEFT IN THE PROGRAM A NUMBER OF REDUNDANT          */
/*     LINES HAVE BEEN REMOVED. NEW CODE INSERTED HAS NOT BEEN      */
/*     ANNOTATED WITH E26937                                        */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CDL038 - Extended Deal Sub Type                            */
/*       046779 - Correction to AUS015 to ensure Print Option       */
/*                consistent with enquiry.                          */
/*       AUS015 - Customer FX/MM Deals Enquiry                      */
/*       E26937 - DISPLAY THE DEALS IN REVERSE DATE ORDER           */
/*       DT0204 - PARAMETERS CHANGED TO STANDARD RCF ONES           */
/*       E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)       */
/*                & INLLIBL(*JOBD).  (Redundant: superseded by      */
/*                S01117.)                                          */
/*                                                                  */
/*       S01117  -  MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM)                       /*DT0204*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
   DCL VAR(&RPARM) TYPE(*CHAR) LEN(100) /* RCF PROMPT PARAMETER */    /*DT0204*/
             DCL        VAR(&CNUMA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAREC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIREC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                 /*AUS015*/
             DCL        VAR(&TYP1) TYPE(*CHAR) LEN(2)                                     /*CDL038*/
             DCL        VAR(&TYP2) TYPE(*CHAR) LEN(2)                                     /*CDL038*/
             DCL        VAR(&TYP3) TYPE(*CHAR) LEN(4)                                     /*CDL038*/
                                                                      /*S01117*/
             CHGVAR     VAR(&CNUMA) VALUE(%SST(&RPARM 1 6))           /*DT0204*/
             CHGVAR     VAR(&LIREC) VALUE(%SST(&RPARM 7 1))           /*DT0204*/
             CHGVAR     VAR(&MAREC) VALUE(%SST(&RPARM 8 1))           /*DT0204*/
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 9 2))            /*AUS015*/
 
/*/COPY WNCPYSRC,DLC2482001                                          */
/*  REPORT BY SYSTEM  */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2480) +
                          PARM(&RSEQ &CNUMA &LIREC &MAREC))        */ /*AUS015*/
/*********** IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2480) +   ******************/ /*CDL038*/
/***********              PARM(&TYPE &RSEQ &CNUMA &LIREC &MAREC))     ***********AUS015*/ /*CDL038*/
             IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2480) +
                          PARM(&RSEQ &CNUMA &LIREC &MAREC &TYP1 &TYP2 &TYP3))             /*CDL038*/
                                                                      /*S01117*/
/*  REPORT BY BRANCH  */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2482)  +
                          PARM(&RSEQ &RENT &CNUMA &LIREC &MAREC)) +
                                                           /*S01117*/ /*046779*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2482) +
                          PARM(&TYPE &RSEQ &RENT &CNUMA &LIREC +
                          &MAREC)) /*046779*/
                                                                      /*S01117*/
/*/COPY WNCPYSRC,DLC2482002                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
