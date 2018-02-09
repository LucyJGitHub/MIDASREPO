/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Final proc. for EOC in i/c')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1080  -  FINAL PROCESSING FOR EOC RUNS DURING INPUT CYCLE    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                  CED005             DATE 12AUG97                  */
/*                  098204             DATE 21FEB96                  */
/*                  078508             DATE 08NOV94                  */
/*                  S01456             DATE 01DEC93                  */
/*                  E59489             DATE 12FEB94                  */
/*                  E23409             DATE 31AUG90                  */
/*                  S01117             DATE 21JUN90                  */
/*                  S01240             DATE 25/04/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CRE020 - Midas Plus Online Printing of Advices (GE7)            */
/*   CPK009 - Packaging for DBA3 release. STRCMTCTL values set       */
/*            to CMTSCOPE(*JOB).                                     */
/*   CED005  -  Trade MIS and Cashflow                               */
/*   098204  -  CHANGES ON E59489 AND 078508                         */
/*              1. The CLRPFM cannot be done here due to a lock      */
/*                 problem.                                          */
/*              2. Records are deleted in FF0450 BUT an override     */
/*                 MUST BE DONE to be on the correct market.         */
/*              3. The markets for which the EOC is running in EOD,  */
/*                 the CLRPFM is made in FFC01                       */
/*   078508  -  Extention of change E59489.                          */
/*              - Remove CLRPFM of MEMOSME, PRONOME and FFACMVD.     */
/*   S01456  -  Monthly P&L Enhancements.                            */
/*   E59489  -  CLRPFM OF MEMOS, PRONO & FFACMVD in FFC1080 locks the*/
/*              EOC when one of these files are open (ie when        */
/*              enquiring on a/c movements)Records are deleted by    */
/*              FF0450.                                              */
/*              FFC01 calls new pgm (FFC0101) to do the RGZPFM.      */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*   S01240 - ADDITION OF REAL-TIME STATEMENTS                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CODE)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&CODE) TYPE(*CHAR)  LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM1) TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM1) TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL VAR(&S01456) TYPE(*CHAR) LEN(1) VALUE(' ')           /*S01456*/
             DCL VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            /*S01456*/
             DCL        VAR(&ED_RTCD) TYPE(*CHAR) LEN(7)              /*CED005*/
             DCL        VAR(&ED_FMT)  TYPE(*CHAR) LEN(200)            /*CED005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CRE020*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CRE020')                                                 /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CRE020*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SARD &FMT)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *NE '       ' *AND &RTNCDE *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
             DMPCLPGM                                                                     /*CRE020*/
             GOTO       CMDLBL(ABNOR)                                                     /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
                                                                      /*S01456*/
/*   CHECK IF MONLY P/L SAR IS PRESENT                */              /*S01456*/
/*                                                                    /*S01456*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01456')          /*S01456*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&S01456) VALUE('Y'))        /*S01456*/
                                                                      /*S01456*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SETON*U2*IF*PRESENT***//************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) +**************E23409*/
/*************************THEN(CHGJOB SWS(X1XXXXXX))*****************E23409*/
/**/
/*   OVERRIDE FILES TO MEMBER 'CODE'                                */
/**/
/************OVRDBF     FILE(MEMOSME) MBR(&CODE)                   */ /*059489*/
/************OVRDBF     FILE(PRONOME) MBR(&CODE)                   */ /*059489*/
                                                                     /*S01240*/
/************OVRDBF     FILE(FFACMV1) MBR(&CODE)        */ /*S01240*/ /*059489*/
                                                                     /*S01240*/
/*                                                                      098204*/
/*   OVERRIDE FILES TO MEMBER 'CODE'    || THAT MUST BE DONE ||         098204*/
/*                                                                      098204*/
             OVRDBF     FILE(MEMOSME) MBR(&CODE)                      /*098204*/
             OVRDBF     FILE(PRONOME) MBR(&CODE)                      /*098204*/
                                                                      /*098204*/
             OVRDBF     FILE(FFACMV1) MBR(&CODE)                      /*098204*/
                                                                      /*098204*/
/**/
/*   CALL PROGRAM FF0450                                            */
/**/
/**********  STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
             MONMSG     MSGID(CPF8351)
             CALL       PGM(FF0450) PARM(&CODE)
             ENDCMTCTL
/*/COPY WNCPYSRC,FFC1080002                                          */
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ                                                */
/*                                                                  */
         IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM1)         */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1080')
             CALL       FF0473 PARM(&CODE &ACT &MSG)
             GOTO       CMDLBL(END)
         ENDDO
 
/* Perform ED extract of FF account keys, if required */              /*CED005*/
             CALL       PGM(AOBUTFR0) PARM('EDFKEYPD' '          ' +
                          &ED_RTCD &ED_FMT)                           /*CED005*/
             IF         COND(&ED_RTCD *NE '*FAILED') THEN(DO)         /*CED005*/
                                                                      /*CED005*/
/* Select matching a/c key records */                          /* START CED005*/
             OPNQRYF    FILE((FOKEYD &CODE) (EDFOKRPD) (SDBANKPD)) +
                          FORMAT(EDFKEYPD EDFKEYD0) JFLD((AKEYE1 +
                          AKEYR1 *EQ) (AKEYE11 AKEYR11)) +
                          GRPFLD(TNBR FFKY EDAT REVI) +
                          MAPFLD((AKEYE1 '%SST(FOKEYD/FFKY 1 3)') +
                          (AKEYR1 '%SST(EDFOKRPD/FYFFKY 1 3)') +
                          (AKEYE11 '%SST(FOKEYD/FFKY 11 4)') +
                          (AKEYR11 '%SST(EDFOKRPD/FYFFKY 11 4)') +
                          (AGRDNB '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(FOKEYD/RECI)') (CLON +
                          '%MIN(FOKEYD/CLON)') (CBCD +
                          '%MIN(FOKEYD/CBCD)') (BOKC +
                          '%MIN(FOKEYD/BOKC)') (BRCA +
                          '%MIN(FOKEYD/BRCA)') (OBKC +
                          '%MIN(FOKEYD/OBKC)') (ASEQ +
                          '%MIN(FOKEYD/ASEQ)') (EAMT +
                          '%SUM(FOKEYD/EAMT)') (CCY +
                          '%MIN(FOKEYD/CCY)') (VDAT +
                          '%MIN(FOKEYD/VDAT)') (SETP +
                          '%MIN(FOKEYD/SETP)') (SETA +
                          '%MIN(FOKEYD/SETA)') (SEBR +
                          '%MIN(FOKEYD/SEBR)') (ISTT +
                          '%MIN(FOKEYD/ISTT)') (YRNO +
                          '%MIN(FOKEYD/YRNO)') (MTHN +
                          '%MIN(FOKEYD/MTHN)') (PCAL +
                          '%MIN(FOKEYD/PCAL)') (STRP +
                          '%MIN(FOKEYD/STRP)') (ISTN +
                          '%MIN(FOKEYD/ISTN)') (PRFC +
                          '%MIN(FOKEYD/PRFC)') (PTFR +
                          '%MIN(FOKEYD/PTFR)')) OPNID(FOKEYD)    /* END CED005*/
                                                                      /*CED005*/
/* Copy to relevant member of ED extract file */                      /*CED005*/
             CPYFRMQRYF FROMOPNID(FOKEYD) TOFILE(EDSFKYPD) +
                          TOMBR(&CODE) MBROPT(*ADD) FMTOPT(*NOCHK)    /*CED005*/
                                                                      /*CED005*/
/* Close query file */                                                /*CED005*/
             CLOF       OPNID(FOKEYD)                                 /*CED005*/
                                                                      /*CED005*/
             ENDDO                                                    /*CED005*/
/**/
/*  CLEAR RELEVANT MEMBER OF FOKEYA,FOKEYD,MEMOSME,PRONOME          */
/**/
         CLRPFM     FILE(FOKEYD) MBR(&CODE)
         CLRPFM     FILE(FOKEYA) MBR(&CODE)
         INZPFM     FILE(FOKEYA) MBR(&CODE) TOTRCDS(1)
/******* CLRPFM     FILE(MEMOSME) MBR(&CODE) **/                      /*078508*/
/******* CLRPFM     FILE(PRONOME) MBR(&CODE) **/                      /*078508*/
                                                                     /*S01240*/
/******* CLRPFM     FILE(FFACMVD) MBR(&CODE) **/           /*S01240*/ /*078508*/
                                                                     /*S01240*/
/**/                                                                  /*S01456*/
         IF    COND(&S01456 *EQ Y) THEN(DO)                           /*S01456*/
/**/                                                                  /*S01456*/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET      */  /*S01456*/
/**/                                                                  /*S01456*/
             OVRDBF     FILE(POSTNCD) MBR(&CODE)                      /*S01456*/
             OVRDBF     FILE(POSTNKD) MBR(&CODE)                      /*S01456*/
             OVRDBF     FILE(PRICSD) MBR(&CODE)                       /*S01456*/
/**/                                                                  /*S01456*/
             CALL       PGM(FF0540) PARM(&CODE)                       /*S01456*/
/**/                                                                  /*S01456*/
             DLTOVR     FILE(POSTNKD)                                 /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
             DLTOVR     FILE(POSTNCD)                                 /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
             DLTOVR     FILE(PRICSD)                                  /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
/**/                                                                  /*S01456*/
             ENDDO                                                    /*S01456*/
/**/                                                                  /*S01456*/
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXXX00)) +
                     *AND (&CRE020 = 'Y')) THEN(DO)                                       /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FFC1001 FF)') INLLIBL(*JOBD) MSGQ(MOPERQ)                      /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FFEXTRSIN FF)') INLLIBL(*JOBD) MSGQ(MOPERQ)                    /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL REC000881 +
                          (FF000250 FF)') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ)                                                    /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
         GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                               */
/**/
 ABNOR: CHGJOB     SWS(XXXXXX1X)
/**/
/*  REMOVE ALL FILE OVERRIDES                                        */
/**/
END:    DLTOVR     FILE(MEMOSME)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(PRONOME)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                     /*S01240*/
        DLTOVR     FILE(FFACMV1)                                     /*S01240*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*S01240*/
/*/COPY WNCPYSRC,FFC1080003                                          */
                                                                     /*S01240*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
        ENDPGM
