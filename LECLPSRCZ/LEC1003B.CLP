/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE LOAN EXPOSURE BY COUNTRY OF DOMICILE')       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*      LEC1003B - LOAN EXPOSURE BY COUNTRY OF DOMICILE             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 113277             Date 23Oct96              */
/*                      S01339             Date 09Apr92              */
/*                     BHF798        DATE  02MAY90                  */
/*                     BHF127        DATE  14AUG90                  */
/*                     BHF156        DATE  14JUN90                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*      113277 - Report LE0890 not produced in single-branch        */
/*               system. Allow call to LE0890 when &RLEV is blank.  */
/*      S01339 - REMOVE SYNDICATED LOANS PROCESSING, DUE TO         */
/*               MODULE REDUNDANCY.                                 */
/*      BHF798 - CLOF ALL OPNDBF AT THE END OF PGM                  */
/*      BHF127 - FILES MISMATCHED BETWEEN BRANCHES AND COMPANIES    */
/*      BHF156 - CALL TO LE0800 WITH NO PARAMETERS IS INCORRECT     */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
   PGM PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*/COPY WNCPYSRC,LEC1003B01                                          */
 
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
 
             SNDPGMMSG  MSG('LOAN EXPOSURE REPORTING') +
                        TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,LEC1003B02                                          */
/**/                                                         /*S01339*/
/**CHECK*FOR*COMMERCIAL*LOANS*MODULE*PRESENT***********/     /*S01339*/
/**/                                                         /*S01339*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)  ***/     /*S01339*/
/************IF      COND(%SST(&MMOD 4 1)=Y) THEN(CHGJOB **/ /*S01339*/
/************************SWS(1XXXXXXX))     *************/   /*S01339*/
/****CALL       PGM(LE0880)                                           /*BHF156*/
 
/****IF*********COND(&RLEV *EQ 'S') THEN(DO)                       */ /*113277*/
     IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') THEN(DO)        /*113277*/
/*/COPY WNCPYSRC,LEC1003B03                                          */
                  CALL    PGM(LE0890) PARM(&RSEQ)
/*/COPY WNCPYSRC,LEC1003B04                                          */
                    ENDDO
     IF         COND(&RLEV *EQ 'C') THEN(DO)
/* POSITION FILE TO THE PARTICULAR COMPANY                           * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
/****************OVRDBF    FILE(SLVN2) POSITION(*KEY 1 LVENTELF +     /*BHF127*/
                 OVRDBF    FILE(SLVN2L2) POSITION(*KEY 1 LVENTELF +
                           &RENT)                                     /*S01117*/
/*************** OPNDBF    FILE(SLVN2) OPTION(*ALL)          /*S01117* *BHF127*/
                 OPNDBF    FILE(SLVN2L2) OPTION(*ALL)                 /*BHF127*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
/***************     DLTOVR     FILE(SLVN2)                  /*S01117* *BHF127*/
                     DLTOVR     FILE(SLVN2L2)                         /*BHF127*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,LEC1003B05                                          */
                  CALL    PGM(LE0892) PARM(&RSEQ &RENT)
/*/COPY WNCPYSRC,LEC1003B06                                          */
                    ENDDO
     IF         COND(&RLEV *EQ 'B') THEN(DO)
/* POSITION FILE TO THE PARTICULAR BRANCH                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SLVN2L1) POSITION(*KEY 1 LVENTELF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SLVN2L1) OPTION(*ALL)                 /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SLVN2L1)                         /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,LEC1003B07                                          */
                  CALL    PGM(LE0891) PARM(&RSEQ &RENT)
/*/COPY WNCPYSRC,LEC1003B08                                          */
                    ENDDO
             CLOF       OPNID(SLVN2L2)                                /*BHF798*/
             MONMSG MSGID(CPF0000)                                    /*BHF798*/
             CLOF       OPNID(SLVN2L1)                                /*BHF798*/
             MONMSG MSGID(CPF0000)                                    /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
