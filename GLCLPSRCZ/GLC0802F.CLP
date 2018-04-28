/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL CURRENT NET TRADING POSITION')               */
/********************************************************************/
/*                                                                  */
/*       Midas     - Dealing Module                             */
/*                                                                  */
/*       GLC0802F - CURRENT NET TRADING POSITION                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No.  BG18886           Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408            Date  03Aug95             */
/*                      E40440            DATE  22MAY92             */
/*                      E22608            DATE  30SEP90             */
/*                      S01117            DATE  17/07/89            */
/*                      S01194            DATE  17/07/89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       BG18886 - Amend non-standard codes.                        */
/*       S01408 - Core hook added, GLC0802F01                       */
/*                Core hook added, GLC0802F02                       */
/*                Core hook added, GLC0802F03                       */
/*                Core hook added, GLC0802F04                       */
/*                Core hook added, GLC0802F05                       */
/*                Core hook added, GLC0802F06                       */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       E22608 - PROGRAM RENAMED FROM DLC0802F,                    */
/*                DL0640/1/2 RENAMED TO GL0640/1/2                  */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  R10 - REMOVE TABLE FILE REFERENCES              */
/********************************************************************/
/*                                                                            */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                            */
/************PGM                                                        S01117*/
             PGM  (&RSEQ &RLEV &RENT)                                 /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*/COPY WNCPYSRC,GLC0802F08                                          */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(30)              /*S01117*/
             DCL        VAR(&BLK) TYPE(*CHAR) LEN(3) VALUE('   ')     /*S01117*/
/*/COPY WNCPYSRC,GLC0802F07                                          */
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDMSG     MSG('CURRENT NET TRADING POSITION REPORT') +
                           TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,GLC0802F09                                          */
/************OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
             OVRDBF     FILE(OLPOS) SHARE(*YES)                       /*S01117*/
/* Close off last Open Query File                                  */ /*S01117*/
                                                                      /*S01117*/
             CLOF       OLPOS                                         /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             CHGVAR     VAR(&SELECT) VALUE(*BLANK)                    /*S01117*/
 
/* REPORT BY SYSTEM  */
/*           IF COND(&RLEV *EQ 'S') THEN(DO)                  S01117E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(DO) /* E40440 */
/* Build Open Query File Keyed By Currency                         */ /*S01117*/
                                                                      /*S01117*/
             OPNQRYF    FILE((OLPOS *FIRST OLPOSOAF)) KEYFLD(CCY)     /*S01117*/
/* Run Current Net Tranding Position Report                        */ /*S01117*/
                                                                      /*S01117*/
/**********  CALL       PGM(DL0640)                                   /*S01117*/
/************CALL       PGM(DL0640) PARM(&RSEQ)         */ /*S01117*/ /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802F01                                           /*S01408*/
                                                                      /*S01408*/
             CALL       PGM(GL0640) PARM(&RSEQ)                       /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802F02                                           /*S01408*/
                                                                      /*S01408*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01117*/
/* REPORT BY BRANCH  */
             IF COND(&RLEV *EQ 'B') THEN(DO)                          /*S01117*/
/*  Setup &Select with Branch Code sent to program                 */ /*S01117*/
/*                                                                 */ /*S01117*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
             CHGVAR     VAR(&SELECT) VALUE('RECI *EQ "D"')            /*S01117*/
             OPNQRYF    FILE((OLPOS *FIRST OLPOSOAF)) QRYSLT(&SELECT) +
                          KEYFLD(BRCA CCY)                            /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01117*/
             ELSE CMD(DO)                                             /*S01117*/
/**********  CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' ** &RENT ** +                 */ /*BG18886*/
             CHGVAR     VAR(&SELECT) VALUE('BRCA *EQ "' *CAT &RENT +
                          *CAT '" ')                                          /*S01117*/ /*BG18886*/
/*  Build Open Query File keyed by currency and selecting Branch   */ /*S01117*/
/*  sent into program                                              */ /*S01117*/
/*                                                                 */ /*S01117*/
             OPNQRYF    FILE((OLPOS *FIRST OLPOSOAF)) QRYSLT(&SELECT) +
                          KEYFLD(CCY)                                 /*S01117*/
/*  Run Current Net Trading Position Report by Branch              */ /*S01117*/
/*                                                                 */ /*S01117*/
             ENDDO                                                    /*S01117*/
/************CALL       DL0641 (&RSEQ)                  */ /*S01117*/ /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802F03                                           /*S01408*/
                                                                      /*S01408*/
             CALL       GL0641 (&RSEQ)                                /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802F04                                           /*S01408*/
                                                                      /*S01408*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01117*/
/* REPORT BY COMPANY   */
             IF COND(&RLEV *EQ 'C') THEN(DO)                          /*S01117*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01117*/
/**********  CHGVAR    VAR(&SELECT) VALUE('CMPYM *GE "' ** &BLK ** '" +               */ /*BG18886*/
             CHGVAR     VAR(&SELECT) VALUE('CMPYM *GE "' *CAT &BLK +
                          *CAT '" ')                                          /*S01117*/ /*BG18886*/
             OPNQRYF    FILE((OLPOS *FIRST OLPOSOAF)) QRYSLT(&SELECT) +
                          KEYFLD(CMPYM CCY)                           /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01117*/
             ELSE CMD(DO)                                             /*S01117*/
/*  Setup &Select with Company Code sent to program                */ /*S01117*/
/*                                                                 */ /*S01117*/
/**********  CHGVAR     VAR(&SELECT) VALUE('CMPYM *EQ "' ** &RENT ** +                */ /*BG18886*/
             CHGVAR     VAR(&SELECT) VALUE('CMPYM *EQ "' *CAT &RENT *CAT +
                          '" ')                                               /*S01117*/ /*BG18886*/
/*  Build Open Query File keyed by currency and selecting Company  */ /*S01117*/
/*  sent into program                                              */ /*S01117*/
/*                                                                 */ /*S01117*/
             OPNQRYF    FILE((OLPOS *FIRST OLPOSOAF)) QRYSLT(&SELECT) +
                          KEYFLD(CCY)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
/*  Run Current Net Trading Position Report by Company             */ /*S01117*/
/*                                                                 */ /*S01117*/
/************CALL       DL0642 (&RSEQ)                  */ /*S01117*/ /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802F05                                           /*S01408*/
                                                                      /*S01408*/
             CALL       GL0642 (&RSEQ)                                /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802F06                                           /*S01408*/
                                                                      /*S01408*/
             ENDDO                                                    /*S01117*/
/*  Delete data base overrides                                     */ /*S01117*/
/*                                                                 */ /*S01117*/
             RTVJOBA    SWS(&SWS)
/************DLTOVR     FILE(TABLE)                                     S01194*/
             DLTOVR     FILE(OLPOS)                                   /*S01117*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') +
                        TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
