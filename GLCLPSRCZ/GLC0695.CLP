/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Spot Rate + Base Rate History Purge')           */
/*********************************************************************/
/*                                                                  */
/*     Midas General Ledger Module                          */
/*                                                                  */
/******GLC0695 - SPOT RATE + BASE RATE HISTORY FILE PURGE           */                  /*CGL127AE*/
/*     GLC0695 - BASE RATE HISTORY FILE PURGE                       */                  /*CGL127AE*/
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD021155           Date 09Jul13              */
/*       Prev Amend No. CGL127AE           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 04May95              */
/*                      S01267             Date 18Sep90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - CPY and RGZ of *X files is unneccessary          */
/*                - RGZ of *PA files (single record) is pointless    */
/*       CGL127AE - COB Restructure - GL COB Optimisation Phase 1    */
/*       228542 - RGZPFM has changed at R5V3                         */
/*        S01408 - Addition of core hook GLC0695MPS                 */
/*        S01267 - CREATED FOR MIS RELEASE 2.2 CHANGES              */
/*                                                                  */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
/**/
/*   Declare Variables    */
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')   */                   /*CGL127AE*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CGL127AE*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CGL127AE*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CGL127AE*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CGL127AE*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CGL127AE*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CGL127AE*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CGL127AE*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CGL127AE*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CGL127AE*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CGL127AE*/
 
/**/                                                                                    /*CGL127AE*/
/* Write current journal sequence number to file SCJSEQPD  */                           /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CGL127AE*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CGL127AE*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CGL127AE*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CGL127AE*/
/*/COPY WNCPYSRC,GLC0695001                                          */
/**/
/*   Set off Switches                     */
/**/
             CHGJOB     SWS(XXXXXX00)
/**********                                                        */                   /*CGL127AE*/
/****Call*PGM CB0160 , to find out the value of Busy               */                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)        */                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
/**SETUP*LIBRARY NAME                                              */                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0695MPS                                          */
                                                                      /*S01408*/
/**********                                                        */                   /*CGL127AE*/
/**IF*THIS*IS NOT A RESTART THEN CREATE SECURITY COPIES            */                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
/**********  IF         COND(&BUSY *EQ 'N') THEN(DO)               */                   /*CGL127AE*/
/**********       CLRPFM     FILE(XSDBSHSPD)                       */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(SDBSHSPD) TOFILE(XSDBSHSPD) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********                  MONMSG     MSGID(CPF2817)             */                   /*CGL127AE*/
/**/
/**********       CLRPFM     FILE(XSDBSHSPA)                       */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(SDBSHSPA) TOFILE(XSDBSHSPA) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********                  MONMSG     MSGID(CPF2817)             */                   /*CGL127AE*/
/**/
/**********       CLRPFM     FILE(XSDCUHSPD)                       */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(SDCUHSPD) TOFILE(XSDCUHSPD) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********                  MONMSG     MSGID(CPF2817)             */                   /*CGL127AE*/
/**/
/**********       CLRPFM     FILE(XSDCUHSPA)                       */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(SDCUHSPA) TOFILE(XSDCUHSPA) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********                  MONMSG     MSGID(CPF2817)             */                   /*CGL127AE*/
/*/COPY WNCPYSRC,GLC0695002                                          */
/**/
/**********       CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')     */                   /*CGL127AE*/
/********** ENDDO                                                  */                   /*CGL127AE*/
/**/
/********** ELSE       CMD(DO)                                     */                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
/**IF*THIS*IS A RESTART THEN COPY SECURITY COPIES BACK TO MASTER FILE                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
/**********       CLRPFM     FILE(SDBSHSPD)                        */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(XSDBSHSPD) TOFILE(SDBSHSPD) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF2817)                        */                   /*CGL127AE*/
/**/
/**********       CLRPFM     FILE(SDBSHSPA)                        */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(XSDBSHSPA) TOFILE(SDBSHSPA) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF2817)                        */                   /*CGL127AE*/
/**/
/**********       CLRPFM     FILE(SDCUHSPD)                        */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(XSDCUHSPD) TOFILE(SDCUHSPD) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF2817)                        */                   /*CGL127AE*/
/**/
/**********       CLRPFM     FILE(SDCUHSPA)                        */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF0000)                        */                   /*CGL127AE*/
/**********       CPYF       FROMFILE(XSDCUHSPA) TOFILE(SDCUHSPA) +
                               MBROPT(*REPLACE)                    */                   /*CGL127AE*/
/**********       MONMSG     MSGID(CPF2817)                        */                   /*CGL127AE*/
/*/COPY WNCPYSRC,GLC0695003                                          */
/********** ENDDO                                                  */                   /*CGL127AE*/
/**/
/* CALL BASE RATES HISTORY PURGE PROGRAM */
/**/
             CALL       PGM(GL0695)
/**********                                                        */                   /*CGL127AE*/
/**CALL*SPOT RATES HISTORY PURGE PROGRAM                           */                   /*CGL127AE*/
/**********                                                        */                   /*CGL127AE*/
/**********  IF COND(%SWITCH(XXXXXX00)) THEN(DO)                   */                   /*CGL127AE*/
/**********  CALL       PGM(GL0696)                                */                   /*CGL127AE*/
/**********  ENDDO                                                 */                   /*CGL127AE*/
/*******************************************************************                 */ /*MD021155*/
/**IF*PURGES*ARE*SUCCESSFUL*THEN*REORGANIZE*MASTER*FILES************                 */ /*MD021155*/
/*******************************************************************                 */ /*MD021155*/
/**********  IF COND(%SWITCH(XXXXXX00)) THEN(DO)                                     */ /*MD021155*/
/**********      CPYF       FROMFILE(&DMLIB/SDBSHSPD) +                                   /*228542*/
/**********                   TOFILE(QTEMP/SDBSHSPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/SDBSHSPD) +                              */ /*MD021155*/
/**********                   TOFILE(QTEMP/SDBSHSPDX) MBROPT(*REPLACE) +             */ /*MD021155*/
/**********                   CRTFILE(*YES)                                   */ /*228542 MD021155*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                */ /*MD021155*/
/**********      RGZPFM     FILE(QTEMP/SDBSHSPD)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('SDBSHSPDX' '*FIRST')         */ /*228542 MD021155*/
/*******************************************************************          */ /*228542 MD021155*/
/**********      CPYF       FROMFILE(QTEMP/SDBSHSPD) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/SDBSHSPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/SDBSHSPDX) +                              */ /*MD021155*/
/**********                  TOFILE(&DMLIB/SDBSHSPD) MBROPT(*REPLACE) +              */ /*MD021155*/
/**********                  CRTFILE(*NO)                                     */ /*228542 MD021155*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +               */ /*MD021155*/
/**********                   EXEC(CLRPFM FILE(&DMLIB/SDBSHSPD))                     */ /*MD021155*/
/**/
/**********      CPYF       FROMFILE(&DMLIB/SDBSHSPA) +                                   /*228542*/
/**********                   TOFILE(QTEMP/SDBSHSPA) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/SDBSHSPA) +                              */ /*MD021155*/
/**********                   TOFILE(QTEMP/SDBSHSPAX) MBROPT(*REPLACE) +             */ /*MD021155*/
/**********                   CRTFILE(*YES)                                   */ /*228542 MD021155*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                */ /*MD021155*/
/**********      RGZPFM     FILE(QTEMP/SDBSHSPA)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('SDBSHSPAX' '*FIRST')         */ /*228542 MD021155*/
/*******************************************************************          */ /*228542 MD021155*/
/**********      CPYF       FROMFILE(QTEMP/SDBSHSPA) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/SDBSHSPA) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/SDBSHSPAX) +                              */ /*MD021155*/
/**********                  TOFILE(&DMLIB/SDBSHSPA) MBROPT(*REPLACE) +              */ /*MD021155*/
/**********                  CRTFILE(*NO)                                     */ /*228542 MD021155*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +               */ /*MD021155*/
/**********                   EXEC(CLRPFM FILE(&DMLIB/SDBSHSPA))                     */ /*MD021155*/
/**/
/**********      CPYF       FROMFILE(&DMLIB/SDCUHSPD) +                                   /*228542*/
/**********                   TOFILE(QTEMP/SDCUHSPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/SDCUHSPD) +
                              TOFILE(QTEMP/SDCUHSPDX) MBROPT(*REPLACE) +
                              CRTFILE(*YES)                        */            /*228542 CGL127AE*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                   /*CGL127AE*/
/**********      RGZPFM     FILE(QTEMP/SDCUHSPD)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('SDCUHSPDX' '*FIRST')            /*228542 CGL127AE*/
                                                                                          /*228542*/
/**********      CPYF       FROMFILE(QTEMP/SDCUHSPD) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/SDCUHSPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/SDCUHSPDX) +
                             TOFILE(&DMLIB/SDCUHSPD) MBROPT(*REPLACE) +
                             CRTFILE(*NO)                          */            /*228542 CGL127AE*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(&DMLIB/SDBSHSPD))   */                   /*CGL127AE*/
/**/
/**********      CPYF       FROMFILE(&DMLIB/SDCUHSPA) +                                   /*228542*/
/**********                   TOFILE(QTEMP/SDCUHSPA) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/SDCUHSPA) +
                              TOFILE(QTEMP/SDCUHSPAX) MBROPT(*REPLACE) +
                              CRTFILE(*YES)                        */            /*228542 CGL127AE*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                   /*CGL127AE*/
/**********      RGZPFM     FILE(QTEMP/SDCUHSPA)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('SDCUHSPAX' '*FIRST')            /*228542 CGL127AE*/
                                                                                          /*228542*/
/**********      CPYF       FROMFILE(QTEMP/SDCUHSPA) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/SDCUHSPA) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/SDCUHSPAX) +
                             TOFILE(&DMLIB/SDCUHSPA) MBROPT(*REPLACE) +
                             CRTFILE(*NO)                          */            /*228542 CGL127AE*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(&DMLIB/SDCUHSPA))   */            /*228542 CGL127AE*/
/*/COPY WNCPYSRC,GLC0695004                                          */
/**/
/* SET OFF THE BUSY FLAG */
/**/
/**********      CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')      */            /*228542 CGL127AE*/
/**********      CLRPFM     FILE(XSDCUHSPD)                        */            /*228542 CGL127AE*/
/**********      CLRPFM     FILE(XSDCUHSPA)                        */            /*228542 CGL127AE*/
/**********      CLRPFM     FILE(XSDBSHSPD)                        */            /*228542 CGL127AE*/
/**********      CLRPFM     FILE(XSDBSHSPA)                        */            /*228542 CGL127AE*/
/*/COPY WNCPYSRC,GLC0695005                                          */
/**********  ENDDO                                                                   */ /*MD021155*/
/**/
/**********  ELSE       CMD(DO)                                                      */ /*MD021155*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                                        /*MD021155*/
                                                                                        /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
/* Retrieve Attributes of current job  */                                               /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
ABNOR:       RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CGL127AE*/
                                                                                        /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
/* Retrieve the most recent journal entry sequence number */                            /*CGL127AE*/
/* for the specific job                                   */                            /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CGL127AE*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CGL127AE*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CGL127AE*/
             ENDDO                                                                      /*CGL127AE*/
                                                                                        /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
/* Determine starting journal sequence number of current job */                         /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CGL127AE*/
                                                                                        /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
/* Remove journal changes */                                                            /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CGL127AE*/
             RMVJRNCHG  JRN(ICJRN) FILE((SDBSHSPD) (SDBSHSPA)) +
                          FROMENT(&START) TOENT(&FINISH) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)                                   /*CGL127AE*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CGL127AE*/
             ENDDO                                                                      /*CGL127AE*/
/**/
/* DATABASE ERROR ROUTINE */
/**/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                                        /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CGL127AE*/
/* command SCWRTJREG */                                                                 /*CGL127AE*/
/**/                                                                                    /*CGL127AE*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CGL127AE*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CGL127AE*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CGL127AE*/
 
/*/COPY WNCPYSRC,GLH00617                                            */
             ENDPGM
