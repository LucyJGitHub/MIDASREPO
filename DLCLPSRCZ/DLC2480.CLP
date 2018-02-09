/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deals By Customer Print (Batch)')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC2480  DEALS BY CUSTOMER PRINT SUBMIT TO RCF             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL038             Date 10May05              */
/*                      CDL021             Date 03Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E27942             DATE 03SEP91             */
/*                      DT0204             DATE 05JUN91             */
/*                      E20773             DATE 25FEB90             */
/*                      S01117             DATE 17/07/89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL038 - Extended Deal Sub Type                            */
/*       CDL021 - Reports by Deal Type                              */
/*       E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A      */
/*                LEVEL OF BLANKS                                   */
/*       DT0204 - PARAMETERS CHANGED TO STANDARD RCF ONES           */
/*       E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)       */
/*                & INLLIBL(*JOBD).  (Redundant: superseded by      */
/*                S01117.)                                          */
/*                                                                  */
/*       S01117  -  MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
/*********** PGM        PARM(&CNUMA &LIREC &MAREC)                    /*S01117*/
/*********** PGM PARM(&CNUMA &LIREC &MAREC &RSEQ &RLEV &RENT)         /*S01117*/
/*********** PGM PARM(&RSEQ &RLEV &RENT &CNUMA &LIREC &MAREC) *S01117* *DT0204*/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM)                       /*DT0204*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
   DCL VAR(&RPARM) TYPE(*CHAR) LEN(100) /* RCF PROMPT PARAMETER */    /*DT0204*/
             DCL        VAR(&CNUMA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MAREC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIREC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYP1) TYPE(*CHAR) LEN(2)                                     /*CDL021*/
             DCL        VAR(&TYP2) TYPE(*CHAR) LEN(2)                                     /*CDL021*/
             DCL        VAR(&TYP3) TYPE(*CHAR) LEN(4)                                     /*CDL038*/
/*********** DCL        VAR(&VARA) TYPE(*CHAR) LEN(1)                 /*S01117*/
/*********** DCL        VAR(&VARB) TYPE(*CHAR) LEN(1)                 /*S01117*/
/*********** CHGVAR     VAR(&VARA) VALUE('''')                        /*S01117*/
/*********** CHGVAR     VAR(&VARB) VALUE('''')                        /*S01117*/
/*********   SBMJOB     JOB(DLC2480A) JOBD(MBATCH) JOBQ(*JOBD) +      /*S01117*/
/*********                RQSDTA('CALL DLC2480A PARM(' *CAT &VARA +   /*S01117*/
/*********                *CAT &CNUMA *CAT &VARB *BCAT &LIREC *BCAT + /*S01117*/
/*********                &MAREC *CAT ')')                            /*S01117*/
                                                                      /*S01117*/
             CHGVAR     VAR(&CNUMA) VALUE(%SST(&RPARM 1 6))           /*DT0204*/
             CHGVAR     VAR(&LIREC) VALUE(%SST(&RPARM 7 1))           /*DT0204*/
             CHGVAR     VAR(&MAREC) VALUE(%SST(&RPARM 8 1))           /*DT0204*/
             CHGVAR     VAR(&TYP1) VALUE(%SST(&RPARM 9 2))                                /*CDL021*/
             CHGVAR     VAR(&TYP2) VALUE(%SST(&RPARM 11 2))                               /*CDL021*/
             CHGVAR     VAR(&TYP3) VALUE(%SST(&RPARM 13 4))                               /*CDL038*/
 
/*  REPORT BY SYSTEM  */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2480) +  * *E27942*/
/************           PARM(&RSEQ &CNUMA &LIREC &MAREC))     *S01117* *E27942*/
/********************   PARM(&CNUMA &LIREC &MAREC &RSEQ))         /*E5**S01117*/
/**********  IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL2480) PARM(&RSEQ &CNUMA +
                          &LIREC &MAREC)) */                                       /*E27942 CDL021*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL2480) PARM(&RSEQ &CNUMA +
                          &LIREC &MAREC &TYP1 &TYP2 &TYP3))                               /*CDL038*/
/*********** IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +        ****************/  /*CDL038*/
/***********              THEN(CALL PGM(DL2480) PARM(&RSEQ &CNUMA +    ****************/  /*CDL038*/
/***********              &LIREC &MAREC &TYP1 &TYP2))                  *********CDL021*/  /*CDL038*/
                                                                      /*S01117*/
/*  REPORT BY BRANCH  */                                              /*S01117*/
/**********  IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2481) +
                        PARM(&RSEQ &RENT &CNUMA &LIREC &MAREC)) */                 /*S01117 CDL021*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2481) +
                        PARM(&RSEQ &RENT &CNUMA &LIREC &MAREC +
                        &TYP1 &TYP2 &TYP3))                                               /*CDL038*/
/*********** IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2481) +    ****************/  /*CDL038*/
/***********            PARM(&RSEQ &RENT &CNUMA &LIREC &MAREC +        ****************/  /*CDL038*/
/***********            &TYP1 &TYP2))                                  *********CDL021*/  /*CDL038*/
/********************   PARM(&CNUMA &LIREC &MAREC &RSEQ &RENT))    /*E5*S01117*/
                                                                      /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
