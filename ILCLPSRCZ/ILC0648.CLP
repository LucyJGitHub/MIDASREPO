/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 General Ledger Module Extraction')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0648 - IBLC 2002 General Ledger Module Extraction        */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAME &CSEQ &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos 12 : General Ledger Module is installed and IBLC Component must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
             IF         COND((%SST(&ILSTAT 12 1)) *EQ 'Y') THEN(DO)
 
/***  Reset external switches.  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0648 - IBLC 2002 - General Ledger +
                          Module Extraction.') TOMSGQ(MRUNQ MOPERQ)
 
/***  Determine TOLIB parameter.  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *CAT 'DMLIB')
 
/***  Check if last try is completed.  ***/
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STATUS)
 
             IF         COND(&STATUS *NE 'Y') THEN(DO)  /** not a restart **/
 
/***  Security Copy of Future values GL items in case of restart.  ***/
 
             CPYF       FROMFILE(ILDIVAPD) TOFILE(&TOLIB/ILDIVAPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(ILDIVAPDXX))
 
/***  Security Copy of Batch items Ext. file  in case of restart.  ***/
 
/**********  CPYF       FROMFILE(GLJENPXL) TOFILE(&TOLIB/GLJENPXLXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
             CPYF       FROMFILE(GLJPX1PD) TOFILE(&TOLIB/GLJENPXLXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(GLJENPXLXX))
 
             ENDDO
 
             ELSE       CMD(DO)
 
/***  Restore Security Copy of Future value GL items.  ***/
 
             CPYF       FROMFILE(ILDIVAPDXX) TOFILE(ILDIVAPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ILDIVAPD))
 
/***  Restore Security Copy of Batch Items Ext. file.  ***/
 
/**********  CPYF       FROMFILE(GLJENPXLXX) TOFILE(GLJENPXL) +
                          MBROPT(*REPLACE)                                                /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GLJENPXL))                                                 /*CER001*/
             CPYF       FROMFILE(GLJENPXLXX) TOFILE(GLJPX1PD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GLJPX1PD))                                                 /*CER001*/
 
             ENDDO
 
/***  Set Component flag as started. ***/
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STATUS)
 
/***  Duplicate Future Values GL Items File in working File   ***/
/***  and Clean Future Values GL Items File.  ***/
 
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *CAT 'DPLIB     ')
             CPYF       FROMFILE(ILDIVAPD) TOFILE(&TOLIB/ILXXVAPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&TOLIB/ILXXVAPD))
 
             CLRPFM     FILE(ILDIVAPD)
 
/***  OUTPUT file are : ILDIWKPD and ILDIVAPD (Future Value).  ***/
 
             CPYF       FROMFILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD) +
                          MBROPT(*NONE) CRTFILE(*YES)
             OVRDBF     FILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD)
 
 
             SNDPGMMSG  MSG('ILC0648 - IBLC 2002 - IL0648 : General +
                          Ledger Module Extraction.') TOMSGQ(MRUNQ +
                          MOPERQ)
 
             CALL       PGM(IL0648)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('ILC0648 - IBLC 2002 - IL0648 : Program +
                          is abnormally terminated - see joblog') +
                          TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*** If normally terminated, clear working file and save items.  ***/
 
             CLRPFM     FILE(ILXXVAPD)
             CPYF       FROMFILE(ILDIWKPD) TOFILE(ILITEMPD) +
                        MBROPT(*ADD)
             MONMSG     MSGID(CPF2817)
 
/***  Set Component flag as terminated.  ***/
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STATUS)
 
             DLTF       FILE(ILDIVAPDXX)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(GLJENPXLXX)
             MONMSG     MSGID(CPF0000)
             ENDDO   /*** ILSTAT pos 12 is 'Y'.  ***/
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0648 - IBLC 2002 General Ledger   +
                          Extraction Program Ended Abnormally - see +
                          joblog for details.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ILDIWKPD)
             MONMSG     MSGID(CPF0000)
             ENDPGM
