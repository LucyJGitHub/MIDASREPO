/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL DEALS BY CUST. THIS MONTH - INTERIM')        */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0901 - DEALS BY CUSTOMER THIS MONTH - INTERIM           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 048933             DATE 19MAR93             */
/*       PREV AMEND NO. 048932             DATE 19MAR93             */
/*                      AUS019             DATE 20AUG92             */
/*                      E27942             DATE 03SEP91             */
/*                      S01117             DATE 17/07/89            */
/*                      S01194             DATE 17/07/89            */
/*                      S01179             DATE 14/09/88            */
/*                      S01098             DATE 22/09/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       048933 - RESTART RECOVERY PROCESSING REWRITE               */
/*       048932 - THIS REPORT IS AVAILABLE AS ON REQUEST BUT CAN    */
/*                ONLY RUN ONCE (SEE CODE BELOW). AUS019 INTRODUCED */
/*                A FEATURE INTO THIS REPORT ALLOWING IT TO RUN FOR */
/*                'ALL' DEALS AS WELL AS 'FX' AND 'MM' DEALS. THE   */
/*                INCORPORATION OF AUS019 INTO THIS PROGRAM DOES NOT*/
/*                APPRECIATE THE FACTS LAID ABOVE. THIS FIX SORTS   */
/*                THE PROBLEM OUT BY RUNNING THE THREE VERSIONS OF  */
/*                THE PROGRAM FOR EACH REQUEST.                     */
/*       AUS019  -  AUSTRALIAN CONVERSION - FX/MM DEALS THIS MONTH  */
/*                  BY CUSTOMER                                     */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*                                                                  */
/********************************************************************/
/************PGM                                                        S01117*/
 
/*&RLEV IS A STANDARD RCF PARAMTER NOT USED IN THIS PROGRAM           /*S01117*/
/************PGM PARM(&RSEQ &RLEV &RENT)                   /*S01117*/ /*AUS019*/
/**********  PGM PARM(&TYPE &RSEQ &RLEV &RENT)             /*AUS019*/ /*048932*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*048932*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */                                                                 /*AUS019*/
/** NEW PARAMETER: DEAL TYPE SELECTION (FX, MM OR BLANKS FOR BOTH) */ /*AUS019*/
/* */                                                                 /*AUS019*/
   DCL VAR(&TYPE) TYPE(*CHAR) LEN(2)                                  /*AUS019*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) +
                        VALUE('Job terminated - database error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) +
                        VALUE('THIS REPORT HAS ALREADY BEEN RUN +
                        TODAY - PRINT TERMINATED')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/*********** DCLDTAARA  DTAARA(LDA)                                     S01179*/
/**/
/************CHGJOB     SWS(00000010)                                 /*048933*/
             CHGJOB     SWS(10000000)                                 /*048933*/
             CLRPFM     FILE(EVDCMHH)
             CLRPFM     FILE(EVDCMED)
             CLRPFM     FILE(EVDCMZZ)
/**/
             SNDMSG     MSG('DEALS BY CUSTOMER THIS MONTH EXTRACT - +
                          INTERIM') TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
             OVRDBF     FILE(DEALS2) TOFILE(DEALS) SHARE(*NO)
/**/                                                                  /*S01098*/
/*                BLOCK LARGE FILES                                 *  *S01098*/
/**/                                                                  /*S01098*/
             OVRDBF     FILE(EVDCMED) SEQONLY(*YES 100)               /*S01098*/
             CALL       PGM(DL1040)
             DLTOVR     FILE(EVDCMED)                                 /*S01098*/
             RTVJOBA    SWS(&SWS)
/**/
             IF    COND(%SUBSTRING(&SWS 6 1) *EQ '1') THEN(DO)
                   SNDPGMMSG MSG(&MSG2) TOMSGQ(MRUNQ)
             CLRPFM     FILE(EVDCMHH)
             CLRPFM     FILE(EVDCMED)
             CLRPFM     FILE(EVDCMZZ)
             ENDDO
/**/
             IF    COND(%SUBSTRING(&SWS 6 3) *EQ '000') THEN(DO)
/**/
             SNDMSG     MSG('DEALS BY CUSTOMER THIS MONTH REPORT - +
                          INTERIM') TOMSGQ(MRUNQ)
/***************CHGJOB     SWS(XXXXXX1X)                              /*048933*/
                CHGJOB     SWS(1XXXXXXX)                              /*048933*/
/***************CALL       PGM(DL1060)                                /*S01117*/
 
/*  REPORT BY SYSTEM  */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL1060) +
/************             PARM(&RSEQ))                       /*S01117* *E27942*/
/************IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
/************             THEN(CALL PGM(DL1060) PARM(&RSEQ)) /*E27942* *AUS019*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
             THEN(DO)                                                 /*048932*/
/**********       THEN(CALL PGM(DL1060) PARM(&TYPE &RSEQ)) /*AUS019*/ /*048932*/
                               CALL PGM(DL1060) PARM('  ' &RSEQ)      /*048932*/
                               CALL PGM(DL1060) PARM('FX' &RSEQ)      /*048932*/
                               CALL PGM(DL1060) PARM('MM' &RSEQ)      /*048932*/
                        ENDDO                                         /*048932*/
                                                                      /*S01117*/
/*  REPORT BY BRANCH  */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL1061) +
/************           PARM(&RSEQ &RENT))                   /*S01117* *AUS019*/
/**********  IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL1061) +    *048932*/
/**********             PARM(&TYPE &RSEQ &RENT))           /*AUS019*/ /*048932*/
             IF         COND(&RLEV *EQ 'B') THEN(DO)                  /*048932*/
                        CALL PGM(DL1061) PARM('  ' &RSEQ &RENT)       /*048932*/
                        CALL PGM(DL1061) PARM('FX' &RSEQ &RENT)       /*048932*/
                        CALL PGM(DL1061) PARM('MM' &RSEQ &RENT)       /*048932*/
                        ENDDO                                         /*048932*/
                                                                      /*S01117*/
                                                                      /*S01117*/
/*  REPORT BY COMPANY */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'C') THEN(CALL PGM(DL1062) +
/************           PARM(&RSEQ &RENT))                   /*S01117* *AUS019*/
/**********  IF         COND(&RLEV *EQ 'C') THEN(CALL PGM(DL1062) +    *048932*/
/**********             PARM(&TYPE &RSEQ &RENT))           /*AUS019*/ /*048932*/
             IF         COND(&RLEV *EQ 'C') THEN(DO)                  /*048932*/
                        CALL PGM(DL1062) PARM('  ' &RSEQ &RENT)       /*048932*/
                        CALL PGM(DL1062) PARM('FX' &RSEQ &RENT)       /*048932*/
                        CALL PGM(DL1062) PARM('MM' &RSEQ &RENT)       /*048932*/
                        ENDDO                                         /*048932*/
                                                                      /*S01117*/
                RTVJOBA    SWS(&SWS)
/**/
             ENDDO
/**/
/************DLTOVR     FILE(TABLE DEALS2)                            /*S01194*/
             DLTOVR     FILE(DEALS2)                                  /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                        SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ)
/***************        RCVDTAARA DTAARA(LDA)                           S01179*/
                        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)           /*S01179*/
/********               CHGVAR VAR(%SUBSTRING(&MEM 1 10)) +           /*S01117*/
/********               VALUE(%SUBSTRING(&LDA 168 10))                /*S01117*/
/********               CHGVAR VAR(%SUBSTRING(&MEM 11 34)) +          /*S01117*/
/********               VALUE(%SUBSTRING(&LDA 134 34))                /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
/********               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +        /*S01117*/
                        SNDPGMMSG MSGID(MEM0011) MSGF(MIDAS) +
                        MSGDTA(&MEM) TOPGMQ(*EXT)
             ENDDO
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG('FILE CONTROLS OUT OF +
                          BALANCE') TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
