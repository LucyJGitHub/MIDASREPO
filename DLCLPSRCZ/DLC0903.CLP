/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL INTEREST THIS MONTH - INTERIM')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0903 - INTEREST THIS MONTH - INTERIM                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 048933             DATE 19MAR93             */
/*                      E19060             DATE 09AUG89             */
/*                      S01117             DATE 17/07/89            */
/*                      S01194             DATE 17/07/89            */
/*                      S01179             DATE 14/09/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       048933  -  RESTART RECOVERY PROCESSING REWRITE             */
/*       E19060  -  REINSERTION OF 'ALCOBJ' AND 'DLCOBJ' COMMANDS   *  *E19060*/
/*                  FOR ERROR NO. 11700.                            *  *E19060*/
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/************PGM                                                        S01117*/
 
/*&RLEV IS A STANDARD RCF PARAMTER NOT USED IN THIS PROGRAM           /*S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/*/COPY WNCPYSRC,DLC0903001                                          */
/**/
/*********** DCLDTAARA  DTAARA(MMOD)                                    S01179*/
/**/
/*********** RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('Interest this month extract - Interim') +
                          TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(IREXDHH)
             CLRPFM     FILE(IREXDIC)
             CLRPFM     FILE(IREXDZZ)
             OVRDBF     FILE(DEALS2) TOFILE(DEALS) SHARE(*NO)
/*********** OVRDBF     FILE(TABLE)    TOFILE(TABDLEE)                /*S01194*/
/**/
             CALL       PGM(DL1000)
             RTVJOBA    SWS(&SWS)
/**/
                IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
                   ALCOBJ     OBJ((ACCNT *FILE *EXCLRD)) WAIT(9999)   /*E19060*/
/****************  CHGJOB     SWS(10000010)                           /*048933*/
                   CHGJOB     SWS(11000000)                           /*048933*/
                   SNDMSG     MSG('Interest this month report - +
                                Interim') TOMSGQ(MRUNQ)
/****************  OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)           /*S01194*/
/****************  CALL       PGM(DL1030)                             /*S01117*/
/*/COPY WNCPYSRC,DLC0903002                                          */
                   CALL       PGM(DL1030) PARM(&RSEQ &RENT)           /*S01117*/
/*/COPY WNCPYSRC,DLC0903003                                          */
                   RTVJOBA    SWS(&SWS)
                   DLCOBJ     OBJ((ACCNT *FILE *EXCLRD))              /*E19060*/
/**/
                ENDDO
/**/
/************DLTOVR     FILE(TABLE DEALS2)                            /*S01194*/
             DLTOVR     FILE(DEALS2)                                  /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG('JOB TERMINATED - DATABASE +
                          IN ERROR') TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG('FILE CONTROLS OUT OF +
                          BALANCE') TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
