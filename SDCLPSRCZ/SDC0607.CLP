/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Base Rates Update')                          */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/*       SDC0607 - BASE RATES UPDATE                                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG3393            Date 24Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      186713             Date 26Jan01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      074135             Date 11Aug94              */
/*                      S01267                  DATE  10MAY90       */
/*                      S01189                  DATE  06APR89       */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG3393 - Component fails with file SDBSHSP0 not found.     */
/*       186713 - SD0600 calls MC0440 but no security copies        */
/*                taken of MCACHRPD.                                */
/*       074135 - DO NOT FAIL IF FILE SDBSHSPD CONTAINS NO RECORDS  */
/*       S01267 - INCORPORATE HISTORIC BASE RATE PROCESSING             S01267*/
/*       S01189 - STANDARDISE DATABASE ERROR JOB SWITCH SETTINGS    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**          PGM            */                                        /*S01267*/
/*   ACCEPT COB PARAMETERS  */                                        /*S01267*/
/**/                                                                  /*S01267*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01267*/
/**/
/*   DECLARE VARIABLES      */
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01267*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01267*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01267*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01267*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10) +
                           VALUE('  DPLIB')                           /*186713*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                /*186713*/
/*/COPY WNCPYSRC,SDH00526                                            */
/**/
/*   SET UP COPYRIGHT  */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*S01267*/
/*   SET OFF SWITCHES  */                                             /*S01267*/
/**/                                                                  /*S01267*/
             CHGJOB     SWS(00000000)                                 /*S01267*/
/*/COPY WNCPYSRC,SDH00527                                            */
/**/
/*   RETRIEVE JOB INFORMATION  */
/**/
             RTVJOBA       JOB(&JOB)
/* Retrieve system prefix from data area SDSTAT. */                                       /*186713*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*186713*/
             CHGVAR     VAR(%SST(&TOLIB 1 2)) VALUE(&SYSID)                               /*186713*/
/**/                                                                  /*S01267*/
/*   CALL CB0160 TO FIND VALUE OF 'STAT'  */                          /*S01267*/
/**/                                                                  /*S01267*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01267*/
/**/                                                                  /*S01267*/
/*   IF STAT IS 'Y', I.E. PROGRAM ENDED ABNORMALLY  */                /*S01267*/
/**/                                                                  /*S01267*/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                  /*S01267*/
/**/                                                                  /*S01267*/
/*   CLEAR SDBSHSPD AND SDBSHSPA                */                    /*S01267*/
/*   COPY XSDBSHSPD (SECURITY COPY) TO SDBSHSPD */                    /*S01267*/
/*   COPY XSDBSHSPA (SECURITY COPY) TO SDBSHSPA */                    /*S01267*/
/*   COPY XMCACHRPD (SECURITY COPY) TO MCACHRPD */                    /*186713*/
/*   AND MONITOR MESSAGES                       */                    /*S01267*/
/**/                                                                  /*S01267*/
             CLRPFM     FILE(SDBSHSPD)                                /*S01267*/
             MONMSG     MSGID(CPF0000)                                /*S01267*/
             CPYF       FROMFILE(XSDBSHSPD) TOFILE(SDBSHSPD) +
                          MBROPT(*REPLACE)                            /*S01267*/
             MONMSG     MSGID(CPF2817)                                /*S01267*/
             CLRPFM     FILE(SDBSHSPA)                                /*S01267*/
             MONMSG     MSGID(CPF0000)                                /*S01267*/
             CPYF       FROMFILE(XSDBSHSPA) TOFILE(SDBSHSPA) +
                          MBROPT(*REPLACE)                            /*S01267*/
             MONMSG     MSGID(CPF2817)                                /*S01267*/
             CLRPFM     FILE(MCACHRPD)                                /*186713*/
             MONMSG     MSGID(CPF0000)                                /*186713*/
             CPYF       FROMFILE(XMCACHRPD) TOFILE(MCACHRPD) +
                          MBROPT(*REPLACE)                            /*186713*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*186713*/
/*/COPY WNCPYSRC,SDH00528                                            */
/**/
             ENDDO                                                    /*S01267*/
             ELSE DO                                                  /*S01267*/
/**/                                                                  /*S01267*/
/*   ELSE IF STAT EQUALS 'N',               */                        /*S01267*/
/*   CREATE SECURITY COPIES OF UPDATE FILES */                        /*S01267*/
/**/                                                                  /*S01267*/
             CLRPFM     FILE(XSDBSHSPD)                               /*S01267*/
             MONMSG     MSGID(CPF0000)                                /*S01267*/
             CPYF       FROMFILE(SDBSHSPD) TOFILE(XSDBSHSPD) +
                          MBROPT(*REPLACE)                            /*S01267*/
/************MONMSG     MSGID(CPF2817)                       /*S01267   074135*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*074135*/
             CLRPFM     FILE(XSDBSHSPA)                               /*S01267*/
             MONMSG     MSGID(CPF0000)                                /*S01267*/
             CPYF       FROMFILE(SDBSHSPA) TOFILE(XSDBSHSPA) +
                          MBROPT(*REPLACE)                            /*S01267*/
             MONMSG     MSGID(CPF2817)                                /*S01267*/
             CLRPFM     FILE(XMCACHRPD)                               /*186713*/
             MONMSG     MSGID(CPF0000)                                /*186713*/
             CPYF       FROMFILE(MCACHRPD) TOFILE(&TOLIB/XMCACHRPD) +
                          MBROPT(*REPLACE)  CRTFILE(*YES)             /*186713*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM FILE(XMCACHRPD))               /*186713*/
/*/COPY WNCPYSRC,SDH00529                                            */
/**/
/*   CALL PGM CB0150 TO SET STAT TO 'Y'  */                           /*S01267*/
/**/                                                                  /*S01267*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')             /*S01267*/
/**/                                                                  /*S01267*/
             ENDDO
/**/                                                                  /*S01267*/
/**          OVRDBF        FILE(TABLEI) TOFILE(TABSDU)                /*S01267*/
/**          OVRDBF        FILE(TABLEU) TOFILE(TABSDU) SHARE(*NO)     /*S01267*/
/**/
/*  CALL SD0600  */
/**/
             OVRDBF     FILE(SDBSHSP0) TOFILE(SDBSHSL1)                                  /*BUG3393*/
             CALL          PGM(SD0600)
/**/
/*   IF SWITCHES 7 AND 8 ARE OFF  */                                  /*S01267*/
/**/                                                                  /*S01267*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01267*/
/**/                                                                  /*S01267*/
/*   CALL PGM CB0150 TO SET STAT TO 'N' */                            /*S01267*/
/**/                                                                  /*S01267*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')             /*S01267*/
/**/                                                                  /*S01267*/
/*   CLEAR SECURITY COPIES XSDBSHSPD and XSDBSHSPA */                 /*S01267*/
/**/                                                                  /*S01267*/
               CLRPFM     FILE(XSDBSHSPD)                             /*S01267*/
               CLRPFM     FILE(XSDBSHSPA)                             /*S01267*/
             DLTF       FILE(&TOLIB/XMCACHRPD)                        /*186713*/
/*/COPY WNCPYSRC,SDH00530                                            */
/**/                                                                  /*S01267*/
             ENDDO                                                    /*S01267*/
             ELSE DO                                                  /*S01267*/
/**/                                                                  /*S01267*/
/* IF SWITCHES 7 & 8 ARE ON, RETRIEVE ERROR NARRATIVE FROM LDA        /*S01267*/
/* SEND MESSAGE FROM MESSAGE FILE MIDAS TO MOPERQ MESSAGE QUEUE */    /*S01267*/
/**/                                                                  /*S01267*/
/**          IF            COND(%SWITCH(XXXXXXX1)) THEN(DO)           /*S01267*/
/**/            CHGJOB        SWS(XXXXXX1X)                           /*S01189*/
/**/                                                                  /*S01267*/
             IF            COND(%SWITCH(XXXXXX11)) THEN(DO)           /*S01267*/
/**/                                                                  /*S01267*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01267*/
/**/                                                                  /*S01267*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)               /*S01267*/
             MONMSG     MSGID(CPF0000)                                /*S01267*/
/**/                                                                  /*S01267*/
/**             SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
/**                           ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)   /*S01267*/
/**             SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +       S01267*/
/**                           ERROR') TOMSGQ(&JOB) MSGTYPE(*INFO)       S01267*/
             ENDDO                                                    /*S01267*/
/**                                                                     S01267*/
             ENDDO                                                    /*S01267*/
/**/                                                                  /*S01267*/
          ENDPGM                                                      /*S01267*/
