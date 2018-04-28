/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Batch Journal Entry Hist. File Purge')          */
/*********************************************************************/
/*                                                                  */
/*     Midas General Ledger Module                          */
/*                                                                  */
/*     GLC4460 - BATCH HISTORY FILE PURGE                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD021155           Date 15Jul13              */
/*       Prev Amend No. CGL127AD           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11May95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD021155 - COB Restructure Phase 1 Remnants                 */
/*                - RGZPFM not moved                                 */
/*       CGL127AD - COB Restructure - GL COB Optimisation Phase 1    */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       S01408 - Addition of core hook GLC4460MPS                   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
/**/
/*   Declare Variables    */
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')                     */ /*CGL127AD*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                              */ /*CGL127AD*/
/**********  DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                               */ /*CGL127AD*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)                               */ /*CGL127AD*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(256)                                /*CGL127AD*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CGL127AD*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CGL127AD*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CGL127AD*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CGL127AD*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CGL127AD*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CGL127AD*/
/*/COPY WNCPYSRC,GLH00607                                            */
/**/
/*   Set off Switches                     */
/**/
             CHGJOB     SWS(XXXXXX00)
                                                                                        /*CGL127AD*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CGL127AD*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CGL127AD*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CGL127AD*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                  /*CGL127AD*/
 
/**/
/*   Call PGM CB0160 , to find out the value of Busy              */
/**/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)                          */ /*CGL127AD*/
/**/
/* SETUP LIBRARY NAME */
/**/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                         */ /*CGL127AD*/
/**********  CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')                      */ /*CGL127AD*/
/**********  CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')                      */ /*CGL127AD*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC4460MPS                                          */
                                                                      /*S01408*/
/**/
/* IF THIS IS NOT A RESTART THEN CREATE SECURITY COPIES */
/**/
/**********  IF         COND(&BUSY *EQ 'N') THEN(DO)                                 */ /*CGL127AD*/
/**********       DLTF       FILE(&DPLIB/XGLJEHHPD)                                  */ /*CGL127AD*/
/**********       MONMSG     MSGID(CPF0000)                                          */ /*CGL127AD*/
/**********       CPYF       FROMFILE(&DMLIB/GLJEHHPD) +
                               TOFILE(&DPLIB/XGLJEHHPD) +
                               MBROPT(*REPLACE) CRTFILE(*YES)                        */ /*CGL127AD*/
/**********                  MONMSG MSGID(CPF2817) CMPDTA(CPF2869)                   */ /*CGL127AD*/
/**/
/**********       DLTF       FILE(&DPLIB/XGLJEHPPD)                                  */ /*CGL127AD*/
/**********       MONMSG     MSGID(CPF0000)                                          */ /*CGL127AD*/
/**********       CPYF       FROMFILE(&DMLIB/GLJEHPPD) +
                               TOFILE(&DPLIB/XGLJEHPPD) +
                               MBROPT(*REPLACE) CRTFILE(*YES)                        */ /*CGL127AD*/
/**********                  MONMSG MSGID(CPF2817) CMPDTA(CPF2869)                   */ /*CGL127AD*/
/**/
/**********       DLTF       FILE(&DPLIB/XGLJEHSPD)                                  */ /*CGL127AD*/
/**********       MONMSG     MSGID(CPF0000)                                          */ /*CGL127AD*/
/**********       CPYF       FROMFILE(&DMLIB/GLJEHSPD) +
                               TOFILE(&DPLIB/XGLJEHSPD) +
                               MBROPT(*REPLACE) CRTFILE(*YES)                        */ /*CGL127AD*/
/**********                  MONMSG MSGID(CPF2817) CMPDTA(CPF2869)                   */ /*CGL127AD*/
/**/
/*/COPY WNCPYSRC,GLC4460001                                          */
/**********       CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')                       */ /*CGL127AD*/
/********** ENDDO                                                                    */ /*CGL127AD*/
/**/
/********** ELSE       CMD(DO)                                                       */ /*CGL127AD*/
/**/
/* IF THIS IS A RESTART THEN COPY SECURITY COPIES BACK TO MASTER FILE*/
/**/
/**********       CPYF       FROMFILE(&DPLIB/XGLJEHHPD) +
                               TOFILE(&DMLIB/GLJEHHPD) MBROPT(*REPLACE)              */ /*CGL127AD*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM FILE(&DMLIB/GLJEHHPD))                    */ /*CGL127AD*/
/**/
/**********       CPYF       FROMFILE(&DPLIB/XGLJEHPPD) +
                               TOFILE(&DMLIB/GLJEHPPD) MBROPT(*REPLACE)              */ /*CGL127AD*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM FILE(&DMLIB/GLJEHPPD))                    */ /*CGL127AD*/
/**/
/**********       CPYF       FROMFILE(&DPLIB/XGLJEHSPD) +
                               TOFILE(&DMLIB/GLJEHSPD) MBROPT(*REPLACE)              */ /*CGL127AD*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM FILE(&DMLIB/GLJEHSPD))                    */ /*CGL127AD*/
/*/COPY WNCPYSRC,GLC4460002                                          */
/********** ENDDO                                                                    */ /*CGL127AD*/
/**/
/* CALL BATCH HISTORY PURGE PROGRAM */
/**/
             CALL       PGM(GL4460)
/**/
/* IF PURGE IS SUCCESSFUL THEN REORGANIZE MASTER FILES */
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**********      CPYF       FROMFILE(&DMLIB/GLJEHHPD) +                                   /*228542*/
/**********                   TOFILE(QTEMP/GLJEHHPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/GLJEHHPD) +
                              TOFILE(QTEMP/GLJEHHPDX) MBROPT(*REPLACE) +
                              CRTFILE(*YES)                                   */ /*228542 CGL127AD*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                */ /*CGL127AD*/
/**********      RGZPFM     FILE(QTEMP/GLJEHHPD)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('GLJEHHPDX' '*FIRST')         */ /*228542 CGL127AD*/
                                                                                          /*228542*/
/**********      CPYF       FROMFILE(QTEMP/GLJEHHPD) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/GLJEHHPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/GLJEHHPDX) +
                             TOFILE(&DMLIB/GLJEHHPD) MBROPT(*REPLACE) +
                             CRTFILE(*NO)                                     */ /*228542 CGL127AD*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(&DMLIB/GLJEHHPD))                     */ /*CGL127AD*/
/**/
/**********      CPYF       FROMFILE(&DMLIB/GLJEHPPD) +                                   /*228542*/
/**********                   TOFILE(QTEMP/GLJEHPPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/GLJEHPPD) +
                              TOFILE(QTEMP/GLJEHPPDX) MBROPT(*REPLACE) +
                              CRTFILE(*YES)                                   */ /*228542 CGL127AD*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                */ /*CGL127AD*/
/**********      RGZPFM     FILE(QTEMP/GLJEHPPD)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('GLJEHPPDX' '*FIRST')         */ /*228542 CGL127AD*/
                                                                                          /*228542*/
/**********      CPYF       FROMFILE(QTEMP/GLJEHPPD) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/GLJEHPPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/GLJEHPPDX) +
                             TOFILE(&DMLIB/GLJEHPPD) MBROPT(*REPLACE) +
                             CRTFILE(*NO)                                     */ /*228542 CGL127AD*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(&DMLIB/GLJEHPPD))                     */ /*CGL127AD*/
/**/
/**********      CPYF       FROMFILE(&DMLIB/GLJEHSPD) +                                   /*228542*/
/**********                   TOFILE(QTEMP/GLJEHSPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                   CRTFILE(*YES)                                               /*228542*/
/**********      CPYF       FROMFILE(&DMLIB/GLJEHSPD) +
                              TOFILE(QTEMP/GLJEHSPDX) MBROPT(*REPLACE) +
                              CRTFILE(*YES)                                   */ /*228542 CGL127AD*/
/**********                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                */ /*CGL127AD*/
/**********      RGZPFM     FILE(QTEMP/GLJEHSPD)                                          /*228542*/
/**********                 MONMSG     MSGID(CPF2981)                                     /*228542*/
/**********      CALL       PGM(SCC000060) PARM('GLJEHSPDX' '*FIRST')         */ /*228542 CGL127AD*/
                                                                                          /*228542*/
/**********      CPYF       FROMFILE(QTEMP/GLJEHSPD) +                                    /*228542*/
/**********                  TOFILE(&DMLIB/GLJEHSPD) MBROPT(*REPLACE) +                   /*228542*/
/**********                  CRTFILE(*NO)                                                 /*228542*/
/**********      CPYF       FROMFILE(QTEMP/GLJEHSPDX) +
                             TOFILE(&DMLIB/GLJEHSPD) MBROPT(*REPLACE) +
                             CRTFILE(*NO)                                     */ /*228542 CGL127AD*/
/**********                 MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(&DMLIB/GLJEHSPD))                     */ /*CGL127AD*/
/*******************************************************************/          /*CGL127AD MD021155*/
/**Re-organise*forward*postings*************************************/          /*CGL127AD MD021155*/
/**********  RGZPFM     FILE(GLJEHHPD)                             */          /*CGL127AD MD021155*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CGL127AD MD021155*/
/**********  RGZPFM     FILE(GLJEHPPD)                             */          /*CGL127AD MD021155*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CGL127AD MD021155*/
/**********  RGZPFM     FILE(GLJEHSPD)                             */          /*CGL127AD MD021155*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CGL127AD MD021155*/
/**/
/*/COPY WNCPYSRC,GLC4460003                                          */
/* SET OFF THE BUSY FLAG */
/**/
/**********      CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')                        */ /*CGL127AD*/
/**********      DLTF       FILE(&DPLIB/XGLJEHHPD)                                   */ /*CGL127AD*/
/**********      MONMSG     MSGID(CPF0000)                                           */ /*CGL127AD*/
/**********      DLTF       FILE(&DPLIB/XGLJEHPPD)                                   */ /*CGL127AD*/
/**********      MONMSG     MSGID(CPF0000)                                           */ /*CGL127AD*/
/**********      DLTF       FILE(&DPLIB/XGLJEHSPD)                                   */ /*CGL127AD*/
/**********      MONMSG     MSGID(CPF0000)                                           */ /*CGL127AD*/
/*/COPY WNCPYSRC,GLC4460004                                          */
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
/* DATABASE ERROR ROUTINE */
/**/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                                                                                        /*CGL127AD*/
/* Retrieve attributes of current job  */                                               /*CGL127AD*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CGL127AD*/
                                                                                        /*CGL127AD*/
/* Retrieve the most recent journal entry sequence number */                            /*CGL127AD*/
/* for the specific job. */                                                             /*CGL127AD*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                          SEARCH(*DESCEND) JOB(&NBR/&USR/&JOB) +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          RTNSEQNBR(&START)                                             /*CGL127AD*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CGL127AD*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CGL127AD*/
             ENDDO                                                                      /*CGL127AD*/
                                                                                        /*CGL127AD*/
/* Determine starting journal sequence number of current job. */                        /*CGL127AD*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') JOB(&JOB) +
                          USER(&USR) NUMBER(&NBR) SEQ(&FINISH)                          /*CGL127AD*/
                                                                                        /*CGL127AD*/
/* Remove journal changes. */                                                           /*CGL127AD*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CGL127AD*/
             RMVJRNCHG  JRN(ICJRN) FILE((GLJEHHPD) (GLJEHPPD) +
                          (GLJEHSPD)) FROMENT(&START) +
                          TOENT(&FINISH)                                                /*CGL127AD*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*CGL127AD*/
             ENDDO                                                                      /*CGL127AD*/
             ENDDO
/**/
                                                                                        /*CGL127AD*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CGL127AD*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CGL127AD*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM *CAT +
                          &CSEQA)                                                       /*CGL127AD*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                  /*CGL127AD*/
                                                                                        /*CGL127AD*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
