/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Fees Enhancements extract for SE')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0652 - IBLC 2002 Fees enhancement Extraction for SE      */
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
             PGM        PARM(&CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Check if the feature USW022 Fees enhancement is installed.  ***/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERFIY')
             CHGVAR     VAR(&SARD) VALUE('USW022')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
 
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
/***  Pos 16 : Securties Trading Module is installed and IBLC Component must run.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
             IF         COND((%SST(&ILSTAT 16 1)) *EQ 'Y') THEN(DO)
 
/***  Reset external switches.  ***/
 
             CHGJOB     SWS(XXXXXX00)
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0652 - IBLC 2002 - Fees Enhancement +
                          Extraction for SE.') TOMSGQ(MOPERQ MRUNQ)
 
/***  Retrieve master library  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (06 02)) RTNVAR(&ID)
             CHGVAR     VAR(&DMLIB) VALUE(&ID *CAT 'DMLIB')
 
/***  Save the account keys : Every Day.  ***/
 
             IF         COND(&CSEQ *EQ 1) THEN(DO)
 
             CPYF       FROMFILE(GEFEPP) TOFILE(&DMLIB/GEFEPP1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(GESCPD) TOFILE(GEFEPP)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/***  Save the account keys : EOM followed by non-working day  ***/
 
             CPYF       FROMFILE(GEFE2PP) TOFILE(&DMLIB/GEFE2P1X) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(GESCPD) TOFILE(GEFE2PP)
             ENDDO
 
/***  output file is QTEMP/ILDIWKPD.  ***/
 
             CPYF       FROMFILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD) +
                          MBROPT(*NONE) CRTFILE(*YES)
             OVRDBF     FILE(ILDIWKPD) TOFILE(QTEMP/ILDIWKPD)
 
/***  Call program.  ***/
 
             CALL       PGM(IL0650)
 
             DLTOVR     FILE(GESCPD)
             MONMSG     MSGID(CPF0000)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  If the 00002 SEQ and end of month, add IBLC items  ***/
/***  in the file ILDINWPD (it will use in the next C.O.B) ***/
/***  ILSTAT Pos 8 : EOM flag.  ***/
 
             IF         COND((&CSEQ *EQ 2) +
                             *AND (%SST(&ILSTAT 8 1) *EQ 'Y')) THEN(DO)
 
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
 
             ENDDO   /*** ILSTAT pos 16 is 'Y'.  ***/
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0652 - IBLC 2002 - Fees Enhancement +
                          Extraction Program Ended Abnormally - See +
                          joblog for details.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             DLTOVR     FILE(ILDIWKPD)
             MONMSG     MSGID(CPF0000)
             ENDPGM
