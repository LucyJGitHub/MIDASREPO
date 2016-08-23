/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas IBLC 2002 Lending Module Extraction')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0641 - IBLC 2002 Lending Module Extraction               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CSEQ &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos 15 : Lending Module is installed and IBLC Component must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
             IF         COND((%SST(&ILSTAT 15 1)) *EQ 'Y') THEN(DO)
 
/***  Reset external switches.  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0641 - IBLC 2002 - Customer Lending +
                          Module Extraction.') TOMSGQ(MRUNQ MOPERQ)
 
/***  Retrieve master library  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (06 02)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
 
/***  Save the account keys : Every Day.  ***/
 
             IF         COND(&CSEQ *EQ 1) THEN(DO) +
 
             CPYF       FROMFILE(LKEY1HH) TOFILE(&DMLIB/LKEY1HH1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY2HH) TOFILE(&DMLIB/LKEY2HH1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY1DP) TOFILE(&DMLIB/LKEY1DP1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY2DP) TOFILE(&DMLIB/LKEY2DP1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY1ZZ) TOFILE(&DMLIB/LKEY1ZZ1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY2ZZ) TOFILE(&DMLIB/LKEY2ZZ1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(MATLNMT) TOFILE(&DMLIB/MATLNMT1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEYFED) TOFILE(&DMLIB/LKEYFED1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/***  Save the account keys : EOM followed by non-working day  ***/
 
             CPYF       FROMFILE(LKEY1HH) TOFILE(&DMLIB/LKEY1HH2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY2HH) TOFILE(&DMLIB/LKEY2HH2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY1DP) TOFILE(&DMLIB/LKEY1DP2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY2DP) TOFILE(&DMLIB/LKEY2DP2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY1ZZ) TOFILE(&DMLIB/LKEY1ZZ2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEY2ZZ) TOFILE(&DMLIB/LKEY2ZZ2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(MATLNMT) TOFILE(&DMLIB/MATLNMT2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(LKEYFED) TOFILE(&DMLIB/LKEYFED2X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
 
             ENDDO
 
/***  output file is QTEMP/ILDIWKPD.  ***/
 
             CPYF       FROMFILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD) +
                          MBROPT(*NONE) CRTFILE(*YES)
             OVRDBF     FILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD)
 
/***  Working Copy of SDFEEPD depending if LEndifn enhancement is or not present ***/
 
             CPYF       FROMFILE(SDFEEPD) TOFILE(ILFEEPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM FILE(ILFEEPD))
 
/***  Call Extraction Program.  ***/
 
             CALL       PGM(IL0641)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  If the 00002 phase and end of month, add IBLC items  ***/
/***  in the file ILDINWPD (it will use in the next C.O.B) ***/
/***  ILSTAT Pos 8 : EOM flag.  ***/
 
             IF         COND((&CSEQ *EQ 2) +
                             *AND (%SST(&ILSTAT 8 1) *EQ 'Y')) THEN(DO)
 
/*** Save Extracted details in New Working day intermediary file.  ***/
 
                        CPYF       FROMFILE(ILDIWKPD) TOFILE(ILDINWPD) +
                                   MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
             ENDDO
             ELSE       CMD(DO)
 
/*** Save Extracted details in Today IBLC 2002 items file.  ***/
 
                        CPYF       FROMFILE(ILDIWKPD) TOFILE(ILITEMPD) +
                                   MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
             ENDDO
             ENDDO   /*** ILSTAT pos 15 is 'Y'.  ***/
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0641 - IBLC 2002 Customer Lending +
                          Extraction Program Ended Abnormally - see +
                          joblog for details.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ILDIWKPD)
             MONMSG     MSGID(CPF0000)
             ENDPGM
