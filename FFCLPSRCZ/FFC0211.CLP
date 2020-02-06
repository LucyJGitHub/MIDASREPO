/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Option Exercise Input')                      */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0211  -  OPTION EXERCISE INPUT                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CFF003             Date 03Apr97              */
/*                      S01408             Date 15Aug96              */
/*                  S01408             DATE 14MAY96                  */
/*                  E44676(FUJI-FF0004)   DATE 01AUG92               */
/*                  S01195             DATE 23APR90                  */
/*                  S01117             DATE 27FEB90                  */
/*                  S01240             DATE 06/03/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*   CFF003  - ENHANCED OTC PROCESSING - PHASE II                    */
/*             UPGRADE FROM BLI LBL001                               */
/*   S01408  - Core hook FFC0211INT added.                           */
/*           - Core hook FFC0211MPS added.                           */
/*           - Core hook FFC0211006 added.                           */
/*           - Core hook FFC0211005 added.                           */
/*           - Core hook FFC0211004 added.                           */
/*           - Core hook FFC0211003 added.                           */
/*   S01408  - Core hook FFC0211002 added.                           */
/*           - Core hook FFC0211001 added.                           */
/*   E44676      - Automatically update unrealised P&L after         */
/*               - position closeout and trades input.               */
/*   S01195  -  HOLIDAY PROCESSING AMENDMENT                         */
/*   S01117  -  MULTIBRANCHING                                       */
/*   S01240  -  ADDITION OF REAL-TIME STATEMENTS                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211INT                                           /*S01408*/
/**                                                                   /*CFF003*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CFF003*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CFF003*/
/**                                                                   /*S01408*/
             DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3)             /*E44676*/
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)            /*E44676*/
             DCL        VAR(&PACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMKTN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PRUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRUND) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PDATF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMBIN) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&PBUSD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PMKLC) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMLOC) TYPE(*CHAR) LEN(3)                /*S01195*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211MPS                                           /*S01408*/
/**                                                                   /*S01408*/
/**/
/* INITIAL CONTROL PROGRAM - SELECT 'ACTION CODE' + 'MARKET CENTRE' */
/**/
INITL:
/**/                                                                  /*S01117*/
/*********** CALL       PGM(FF0030) PARM(&PACTN &PMRKT &PMKTN &PRUNA + */
/***********                             &PRUND &PDATF &PBUSD &PMKLC)  */
             CALL       PGM(FF0030) PARM(&PACTN &PMRKT &PMKTN &PRUNA +
                                         &PRUND &PDATF &PMBIN &PBUSD +
                                         &PMKLC &PMLOC)               /*S01195*/
/***********                             &PMKLC)        */ /*S01117*/ /*S01195*/
/**/
/* DATABASE ERRORS, IF U7 + U8 ON */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
/**/
/* CMD/3 TAKEN, IF ACTION CODE BLANK */
/**/
             IF         COND(&PACTN *EQ ' ') THEN(GOTO ENDPGM)
/**/
/*  OVERRIDE FILES TO MARKET MEMBERS */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
                 OVRDBF     FILE(TRANS) MBR(&PMRKT)
                 OVRDBF     FILE(TRSET) MBR(&PMRKT)
                 OVRDBF     FILE(POSTNC) MBR(&PMRKT)
                 OVRDBF     FILE(POSTNK) MBR(&PMRKT)
                 OVRDBF     FILE(CLOST) MBR(&PMRKT)
                 OVRDBF     FILE(CLOST2) MBR(&PMRKT)
                 OVRDBF     FILE(MEMOSM) MBR(&PMRKT)
                 OVRDBF     FILE(PRONOM) MBR(&PMRKT)
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211003                                           /*S01408*/
/**                                                                   /*S01408*/
                                                                     /*S01240*/
                 OVRDBF     FILE(FFACMVD) MBR(&PMRKT)                /*S01240*/
                                                                     /*S01240*/
                 OVRDBF     FILE(TRANSA) MBR(&PMRKT)
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211004                                           /*S01408*/
/**                                                                   /*S01408*/
/**/
                 OVRDBF     FILE(TRANSIN) TOFILE(TRANS) +
                             MBR(&PMRKT) SHARE(*NO)
                 OVRDBF     FILE(TRSETIN) TOFILE(TRSET) +
                             MBR(&PMRKT) SHARE(*NO)
             ENDDO
             ELSE DO
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211005                                           /*S01408*/
/**/                                                                  /*CFF003*/
/* Check if OTC enhancemets CFF003 are switched on */                 /*CFF003*/
/**/                                                                  /*CFF003*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CFF003*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CFF003*/
             CHGVAR     VAR(&SARD) VALUE('CFF003')                    /*CFF003*/
/**/                                                                  /*CFF003*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CFF003*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CFF003*/
                 OVRDBF     FILE(TRANS) MBR(OTC) SHARE(*NO)           /*CFF003*/
             ENDDO                                                    /*CFF003*/
             ELSE DO                                                  /*CFF003*/
/**                                                                   /*S01408*/
                 OVRDBF     FILE(TRANS) MBR(OTC)
/**                                                                   /*CFF003*/
             ENDDO                                                    /*CFF003*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211006                                           /*S01408*/
/**                                                                   /*S01408*/
                 OVRDBF     FILE(TRSET) MBR(OTC)
                 OVRDBF     FILE(POSTNC) MBR(OTC)
                 OVRDBF     FILE(POSTNK) MBR(OTC)
                 OVRDBF     FILE(CLOST) MBR(OTC)
                 OVRDBF     FILE(CLOST2) MBR(OTC)
                 OVRDBF     FILE(MEMOSM) MBR(OTC)
                 OVRDBF     FILE(PRONOM) MBR(OTC)
                                                                     /*S01240*/
                 OVRDBF     FILE(FFACMVD) MBR(OTC)                   /*S01240*/
                                                                     /*S01240*/
                 OVRDBF     FILE(TRANSA) MBR(OTC)
/**/
                 OVRDBF     FILE(TRANSIN) TOFILE(TRANS) +
                             MBR(OTC) SHARE(*NO)
                 OVRDBF     FILE(TRSETIN) TOFILE(TRSET) +
                             MBR(OTC) SHARE(*NO)
             ENDDO
/**/
/* MAIN DETAILS PROGRAM */
/**/
/**/                                                                  /*S01117*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211001                                           /*S01408*/
/**                                                                   /*S01408*/
/*********** CALL       PGM(FF0040) PARM(&PACTN &PMRKT &PMKTN &PRUNA + */
/***********                             &PRUND &PDATF &PBUSD &PMKLC)  */
             CALL       PGM(FF0040) PARM(&PACTN &PMRKT &PMKTN &PRUNA +
                                         &PRUND &PDATF &PMBIN &PBUSD +
                                         &PMKLC &PMLOC)               /*S01195*/
/***********                             &PMKLC)        */ /*S01117*/ /*S01195*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,FFC0211002                                           /*S01408*/
/**                                                                   /*S01408*/
/**/
/* DEALLOCATE MARKET DATA AREA, + DELETE FILE OVERRIDES */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
                 DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))
             ENDDO
/**/
             DLTOVR     FILE(*ALL)
/**/
/* DATABASE ERRORS, IF U7 + U8 ON */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
/**/
/* CMD/5 TAKEN, IF ACTION CODE BLANK */
/**/
             IF         COND(&PACTN *EQ ' ') THEN(GOTO INITL)
/**/                                                                  /*E44676*/
/* Submit job to update unrealised P&L                             */ /*E44676*/
/**/                                                                  /*E44676*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E44676*/
/*                                                        */          /*E44676*/
/** Pass the market parameter as 'OTC' for OTC's          */          /*E44676*/
/*                                                        */          /*E44676*/
                                                                      /*E44676*/
             IF         COND(&PMRKT *EQ '  ') THEN(DO)                /*E44676*/
                CHGVAR     VAR(&MARKT) VALUE('OTC')                   /*E44676*/
             ENDDO                                                    /*E44676*/
             ELSE       CMD(DO)                                       /*E44676*/
             CHGVAR     VAR(&MARKT) VALUE(&PMRKT)                     /*E44676*/
             ENDDO                                                    /*E44676*/
                                                                      /*E44676*/
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &MARKT *CAT ')')                            /*E44676*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*E44676*/
/************SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)           /*E44676*/ /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)               /*E44676*/ /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
             ENDDO                                                    /*E44676*/
/**/                                                                  /*E44676*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
