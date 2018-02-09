/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account Balances Extract')                   */
/********************************************************************/
/*                                                                  */
/*     Midas General Ledger Module                              */
/*                                                                  */
/*     GLC0570 -  Account Balances Extract                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097467          Date 16Apr13              */
/*                      CGL127AP           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                    CCB016            Date  03Aug07               */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    114269            DATE  19FEB98               */
/*                    075665            DATE  08SEP94               */
/*                    S01413            DATE  08NOV93               */
/*                    E26334            DATE  09SEP91               */
/*                    E21390            DATE  18JUL90               */
/*                    S01197            DATE  06/07/89              */
/*                    S01194            DATE  09/05/89              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     AR1097467B - Expected 15% COB run optimization not met       */
/*     CGL127AP - COB Restructure - GL COB Optimisation Phase 1     */
/*     CCB016 - CoB performance enhancement                         */
/*     114269 - Additional trace stmt that display object lock when */
/*              the problem occur again for LF/ACCNT. If it fails   */
/*              to allocate AACNT at the first time, delay the job  */
/*              for 30 sec. Then retry again. At the most, it will  */
/*              retry three times.                                  */
/*     075665 - INCORRECT CONDITIONING OF CALL TO GL0570 DURING COB */
/*              RESULTS IN PF/RETACRE NOT BEING UPDATED AT ALL.     */
/*              IE USING MODE 1 INSTEAD OF MODE 2.                  */
/*     S01413 - RETAIL 3 INCORPORATION.                             */
/*     E26334 - FIX E21390 USES 'OR' NOT 'AND' ON MODE              */
/*              CONDITIONING RESULTING IN RABEXOR BEING CLEARED     */
/*              WHEN RUN IN MODE '2'                                */
/*     E21390 - PROGRAM AMENDED TO RUN IF EITHER RETAIL II OR       */
/*              INTEREST ON ACCOUNTS SWITCHED ON.                   */
/*     S01197 - USE OF NEW STANDING DATA FOR RELEASE 10             */
/*     S01194 - R10 REPLACING GL WITH RE EQUIVALENTS                */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&MODE)
/**/
/* Mode is 1 or 2:                                                   */
/*    1: Run only if Retail module present; runs before Accounts     */
/*       Post to o/p                                                 */
/*          ACDETAB for retail a/cs with a close request today       */
/***********RABEXOR for retail a/c opening balances for Daily         /*S01413*/
/************Movements report                                         /*S01413*/
/*    2: Run after posts to produce reporting files                  */
/*          ACDETAB for all accounts with last change date today,    */
/*           for GLC48 Accounts Opened and Closed                    */
/*          IBPAIB for Inactive and blocked accounts                 */
/*          AXFIAX for a/cs to be transferred to inactive status     */
/*          RETACRE retail a/cs extract for several reports          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
/**/
             DCL VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL VAR(&ERROR) TYPE(*CHAR) LEN(1)                                         /*CGL127AP*/
/************DCL VAR(&MMOD) TYPE(*CHAR) LEN(256) */                   /*S01413*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
/**********  DCL VAR(&TEMP1) TYPE(*CHAR) LEN(10)                   */            /*114269 CGL127AP*/
/**********  DCL VAR(&TEMP2) TYPE(*CHAR) LEN(10)                   */            /*114269 CGL127AP*/
/**********  DCL VAR(&TEMP3) TYPE(*CHAR) LEN(1) VALUE('N')         */            /*114269 CGL127AP*/
/*/COPY WNCPYSRC,GLC0570002                                          */
/**/
             DCLF       FILE(SDMMODPD)                                /*S01413*/
             RCVF                                                     /*S01413*/
/************RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD) */            /*S01413*/
/**/
             SNDPGMMSG  MSG('GLC0570 - Account Balances Extract') +
                          TOMSGQ(MRUNQ)
/**/
/*  Clear ACDET PFs whether mode is 1 or 2  */
/**/
             CLRPFM FILE(ACDETAA)
             CLRPFM FILE(ACDETAB)
             CLRPFM FILE(ACDETAC)
/*/COPY WNCPYSRC,GLC0570003                                          */
/**/
/*  Mode 1: o/p ACDETAB and RABEXOR        */
/*          U1 for ACDETAB, U2 for RABEXOR */
/*          Only do if Retail present      */
/*  Retail 3 moved RABEXOR extraction to GLC3570  */                  /*S01413*/
/**/                                                                  /*E23190*/
/************IF         COND((((%SST(&MMOD 16 1)) *EQ Y) +            /*E26334*/
/*************          *OR (%SST(&MMOD 23 1)) *EQ Y) +               /*E26334*/
/*************          *OR (&MODE = '1')) THEN(DO)          /*E23190* *E26334*/
/************IF         COND(((%SST(&MMOD 16 1)) *EQ Y) +
                        *AND (&MODE = '1') +
                        *OR ((%SST(&MMOD 23 1)) *EQ Y) +
                        *AND (&MODE = '1')) THEN(DO) */      /*E26334* *S01413*/
                IF      COND((&BGNXST *EQ 'Y') *AND (&MODE = '1') +
                        *OR (&BGNYST *EQ 'Y') *AND (&MODE = '1')) +
                          THEN(DO)                                    /*S01413*/
                CHGJOB SWS(10000000)                                  /*S01413*/
/***************CHGJOB SWS(11000000) */                               /*S01413*/
/***************CLRPFM FILE(RABEXOR) */                               /*S01413*/
/***************CLRPFM FILE(RTZZ) MBR(RABEX) */                       /*S01413*/
/***************OVRDBF FILE(RABEXZZ) TOFILE(RTZZ) MBR(RABEX) */       /*S01413*/
             ENDDO
/**/
/*  Mode 2: o/p ACDETAB, and if Retail IBPAIB, AXFIAX, RETACRE  */
/**/
             IF COND(&MODE = '2') THEN(DO)
/**/
/*  Condition ACDET to be output */
                CHGJOB SWS(10000000)
/**/
/*  Processing for retail files */
/*  Switches: U5 for AXFI PFs,   U6 for IBPA and RETAC PFs   */
/**/                                                                  /*E23190*/
/***************IF ((((%SST(&MMOD 16 1)) *EQ Y) +
                *OR (%SST(&MMOD 23 1)) *EQ Y)) THEN(DO) */ /*E23190*/ /*S01413*/
/***************IF      COND((&BGNXST *EQ 'Y') *AND (&MODE = '1') +   /*075665*/
/***************        *OR (&BGNYST *EQ 'Y') *AND (&MODE = '1')) +   /*075665*/
/***************          THEN(DO)                         /*S01413*/ /*075665*/
                IF      COND((&BGNXST *EQ 'Y') *AND (&MODE = '2') +
                          *OR (&BGNYST *EQ 'Y') *AND (&MODE = '2')) +
                          THEN(DO)                                    /*075665*/
/**/
/**********        CHGJOB SWS(X0001100)                            */                   /*CGL127AP*/
/**/
                   CLRPFM FILE(IBPAIB)
                   CLRPFM FILE(AXFIAX)
                   CLRPFM FILE(RETACRE)
                   CLRPFM FILE(RTZZ) MBR(IBPA)
                   CLRPFM FILE(RTZZ) MBR(RETAC)
                   CLRPFM FILE(RTZZ) MBR(AXFI)
/**/
                   OVRDBF FILE(IBPAIZZ) TOFILE(RTZZ) MBR(IBPA)
                   OVRDBF FILE(AXFIAZZ) TOFILE(RTZZ) MBR(AXFI)
                   OVRDBF FILE(RETACZZ) TOFILE(RTZZ) MBR(RETAC)
/**/
                ENDDO
/**/
             ENDDO
/**/
/**********  ALCOBJ OBJ((ACCNT  *FILE *SHRRD))                     */            /*114269 CGL127AP*/
/**********  MONMSG MSGID(CPF1002) EXEC(CHGVAR VAR(&TEMP3) +
                                        VALUE('Y'))                */            /*114269 CGL127AP*/
/**********  IF COND(&TEMP3 *EQ 'Y') THEN(DO)                      */            /*114269 CGL127AP*/
/**********      RTVJOBA OUTQ(&TEMP1) OUTQLIB(&TEMP2)              */            /*114269 CGL127AP*/
/**********      CHGJOB OUTQ(*LIBL/MPRINTAU)                       */            /*114269 CGL127AP*/
/**********      WRKOBJLCK OBJ(ACCNT) OBJTYPE(*FILE) +
                           OUTPUT(*PRINT)                          */            /*114269 CGL127AP*/
/**********      SNDPGMMSG MSG('CANNOT ALLOCATE OBJECT - ACCNT +
                                IN GLC0570. +
                                PLEASE CONTACT SUPPORT DESK.') +
                               TOMSGQ(MOPERQ MRUNQ MSPECIAL)       */            /*114269 CGL127AP*/
/**********      CHGJOB OUTQ(&TEMP2/&TEMP1)                        */            /*114269 CGL127AP*/
/**/
/**********      DLYJOB DLY(30)                                    */            /*114269 CGL127AP*/
/**********      ALCOBJ OBJ((ACCNT  *FILE *SHRRD))                 */            /*114269 CGL127AP*/
/**********      MONMSG MSGID(CPF1002) EXEC(GOTO CMDLBL(ONCE))     */            /*114269 CGL127AP*/
/**********      GOTO CMDLBL(TRIPLE)                               */            /*114269 CGL127AP*/
/***ONCE:**      DLYJOB DLY(30)                                    */            /*114269 CGL127AP*/
/**********      ALCOBJ OBJ((ACCNT  *FILE *SHRRD))                 */            /*114269 CGL127AP*/
/**********      MONMSG MSGID(CPF1002) EXEC(GOTO CMDLBL(TWICE))    */            /*114269 CGL127AP*/
/**********      GOTO CMDLBL(TRIPLE)                               */            /*114269 CGL127AP*/
/***TWICE:*      DLYJOB DLY(30)                                    */            /*114269 CGL127AP*/
/**********      ALCOBJ OBJ((ACCNT  *FILE *SHRRD))                 */            /*114269 CGL127AP*/
/**********      MONMSG MSGID(CPF1002) EXEC(GOTO CMDLBL(TRIPLE))   */            /*114269 CGL127AP*/
/**********      GOTO CMDLBL(TRIPLE)                               */            /*114269 CGL127AP*/
/**********  ENDDO                                                 */            /*114269 CGL127AP*/
/***TRIPLE:  DLCOBJ OBJ((ACCNT *FILE *SHRRD))                      */            /*114269 CGL127AP*/
/**/
             OVRDBF     FILE(RETACRE) NBRRCDS(800) SEQONLY(*YES 800)  /*CCB016*/
             OVRDBF     FILE(IBPAIB) NBRRCDS(800) SEQONLY(*YES 800)   /*CCB016*/
 
/**********  CALL       PGM(GL0570) PARM(&MODE)                    */            /*S01197 CGL127AP*/
             IF         COND(&MODE *EQ '2' *AND (&BGNXST *EQ 'Y' *OR +
                          &BGNYST *EQ 'Y')) THEN(DO)                                    /*CGL127AP*/
                OVRDBF     FILE(ACCNTAB) SEQONLY(*YES)                                /*AR1097467B*/
                CALL       PGM(GL000570)                                                /*CGL127AP*/
                CALL       PGM(RE377801) PARM(&ERROR)                                   /*CGL127AP*/
                IF         COND(&ERROR *NE 'Y') THEN(DO)                                /*CGL127AP*/
                   OVRDBF     FILE(REINACPD) OVRSCOPE(*JOB) SEQONLY(*YES +
                                3500)                                                 /*AR1097467B*/
                   OVRDBF     FILE(AXFIAX) NBRRCDS(3500) SEQONLY(*YES +
                                3500)                                                 /*AR1097467B*/
                   CALL       PGM(GL000569)                                             /*CGL127AP*/
                ENDDO                                                                   /*CGL127AP*/
             ENDDO                                                                      /*CGL127AP*/
/**/
             DLTOVR FILE(*ALL)
/*/COPY WNCPYSRC,GLC0570001                                          */
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                 IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                    RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
                    CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01194*/
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)
                 ENDDO
/**/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG MSG('FILE OUT OF BALANCE - GL0570') TOMSGQ(MRUNQ +
                               MOPERQ)                                /*S01197*/
                ENDDO
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
