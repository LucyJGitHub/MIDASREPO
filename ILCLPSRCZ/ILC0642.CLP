/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Retail Module Extraction')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0642 - IBLC 2002 Retail Module Extraction                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CAP204             Date 04Feb10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      IL0003             Date 30Nov01              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAP204 - Teller Related APIs - Account Transfer             */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       IL0003 - CPYF *NOCHK                                        */
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
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)                                    /*CAP204*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAP204*/
             DCL        VAR(&CAP204)   TYPE(*CHAR) LEN(1)                                 /*CAP204*/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos 13 : Retail Module is installed and IBLC Component must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
             IF         COND((%SST(&ILSTAT 13 1)) *EQ 'Y') THEN(DO)
 
/***  Reset external switches.  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0642 - IBLC 2002 - Retail Module +
                          Extraction.') TOMSGQ(MRUNQ MOPERQ)
 
/***  Retrieve master library  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (06 02)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
 
             CHGVAR     VAR(&CAP204) VALUE('N')                                           /*CAP204*/
             CALL       PGM(AOSARDR0) PARM(&RTNCD '*VERIFY' 'CAP204' &SCSARD)             /*CAP204*/
             IF         COND(&RTNCD *EQ '       ') THEN(DO)                               /*CAP204*/
                CHGVAR     VAR(&CAP204) VALUE('Y')                                        /*CAP204*/
             ENDDO                                                                        /*CAP204*/
                                                                                          /*CAP204*/
             IF         COND((&RTNCD *NE '       ') *AND (&RTNCD *NE +
                          '*NRF   ')) THEN(DO)                                            /*CAP204*/
                GOTO       CMDLBL(ABNOR)                                                  /*CAP204*/
             ENDDO                                                                        /*CAP204*/
                                                                                          /*CAP204*/
/***  Save the account keys : Every Day.  ***/
 
             IF         COND(&CSEQ *EQ 1) THEN(DO) +
 
/*****       CPYF       FROMFILE(GESOPD) TOFILE(&DMLIB/GESOPD1X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GESOPD) TOFILE(&DMLIB/GESOPD1X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GESOPD1X))
 
/*****       CPYF       FROMFILE(GECEPD) TOFILE(&DMLIB/GECEPD1X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GECEPD) TOFILE(&DMLIB/GECEPD1X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GECEPD1X))
                                                                                          /*CAP204*/
             IF         COND(&CAP204 = 'Y') THEN(DO)                                      /*CAP204*/
             CPYF       FROMFILE(GETXPD) TOFILE(&DMLIB/GETXPD1X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)                     /*CAP204*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GETXPD1X))                                                 /*CAP204*/
                                                                                          /*CAP204*/
             CPYF       FROMFILE(GETXPD) TOFILE(&DMLIB/GETXPD2X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)                     /*CAP204*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GETXPD2X))                                                 /*CAP204*/
             ENDDO                                                                        /*CAP204*/
 
/*****       CPYF       FROMFILE(GEICPD) TOFILE(&DMLIB/GEICPD1X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GEICPD) TOFILE(&DMLIB/GEICPD1X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GEICPD1X))
 
/*****       CPYF       FROMFILE(GEFAPD) TOFILE(&DMLIB/GEFAPD1X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GEFAPD) TOFILE(&DMLIB/GEFAPD1X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GEFAPD1X))
 
             ENDDO
 
             ELSE       CMD(DO)
 
/***  Save the account keys : EOM followed by non-working day  ***/
 
/*****       CPYF       FROMFILE(GESOPD) TOFILE(&DMLIB/GESOPD2X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)               *IL0002*/
             CPYF       FROMFILE(GESOPD) TOFILE(&DMLIB/GESOPD2X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GESOPD2X))
 
/*****       CPYF       FROMFILE(GECEPD) TOFILE(&DMLIB/GECEPD2X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GECEPD) TOFILE(&DMLIB/GECEPD2X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GECEPD2X))
                                                                                          /*CAP204*/
             IF         COND(&CAP204 = 'Y') THEN(DO)                                      /*CAP204*/
             CPYF       FROMFILE(GETXPD) TOFILE(&DMLIB/GETXPD1X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)                     /*CAP204*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GETXPD1X))                                                 /*CAP204*/
                                                                                          /*CAP204*/
             CPYF       FROMFILE(GETXPD) TOFILE(&DMLIB/GETXPD2X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)                     /*CAP204*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GETXPD2X))                                                 /*CAP204*/
             ENDDO                                                                        /*CAP204*/
 
/*****       CPYF       FROMFILE(GEIC2PD) TOFILE(&DMLIB/GEICPD2X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GEIC2PD) TOFILE(&DMLIB/GEICPD2X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GEICPD2X))
 
/*****       CPYF       FROMFILE(GEFAPD) TOFILE(&DMLIB/GEFAPD2X) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                IL0002*/
             CPYF       FROMFILE(GEFAPD) TOFILE(&DMLIB/GEFAPD2X) +
                        MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*IL0002*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GEFAPD2X))
 
             ENDDO
 
/***   Allocate switches depending on phases   ***/
/***   *INU1 : Standing Orders and Customer Exchanges extraction. ***/
/***   *INU2 : Interests extraction.                              ***/
/***   *INU3 : Fixed Accounts Extraction.                         ***/
 
             IF         COND(&CSEQ *EQ 1) THEN(CHGJOB SWS(11100000))
 
             IF         COND(&CSEQ *EQ 2) THEN(DO)
                        OVRDBF     FILE(GEICPD) TOFILE(GEIC2PD)
                        CHGJOB     SWS(01000000)
             ENDDO
 
/***  output file is QTEMP/ILDIWKPD.  ***/
 
             CPYF       FROMFILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD) +
                          MBROPT(*NONE) CRTFILE(*YES)
             OVRDBF     FILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD)
 
             CHGJOB     SWS(XXX1XXXX)                                                     /*CAP204*/
/***  Call Extraction Program.  ***/
 
             CALL       PGM(IL0642)
 
             DLTOVR     FILE(GEICPD)
             MONMSG     MSGID(CPF0000)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  If the 00002 SEQ and end of month, add IBLC items  ***/
/***  in the file ILDINWPD (it will use in the next C.O.B) ***/
/***  ILSTAT Pos 8 : EOM flag.  ***/
 
             IF         COND((&CSEQ *EQ 2) +
                             *AND (%SST(&ILSTAT 8 1) *EQ 'Y')) THEN(DO)
 
/*** Save Extracted details in New Working day intermediary file.  ***/
 
                        CPYF       FROMFILE(ILDIWKPD) TOFILE(ILDINWPD) +
                                   FROMMBR(*ALL) MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
             ENDDO
             ELSE       CMD(DO)
 
/*** Save Extracted details in Today IBLC 2002 items file.  ***/
 
                        CPYF       FROMFILE(ILDIWKPD) TOFILE(ILITEMPD) +
                                   MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
             ENDDO
 
             ENDDO   /*** ILSTAT pos 13 is 'Y'.  ***/
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0642 - IBLC 2002 Retail Extraction +
                          Program Ended Abnormally - see joblog for +
                          details.') TOMSGQ(MRUNQ MOPERQ)
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
