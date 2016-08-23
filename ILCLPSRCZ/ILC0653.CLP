/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 ANWD items addition')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0653  - IBLC 2002 AWND Items addition                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 200733             Date 30Nov01              */
/*                      ULX043             Date 29Sep01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       200733 - ULX043 - ILITEMPDXX not restored when Reopen       */
/*                Put and take copy in xxDPLIB instead (WORKING FILE)*/
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
 
/***  Monitor for Error Messages from System.  ***/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if COB IBLC is running.  ***/
/***  Pos  1 : COB Run Flag.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/***  Send message to program message queue.  ***/
 
             SNDPGMMSG  MSG('ILC0653 - IBLC 2002 ANWD - non-working +
                          days items addition') TOMSGQ(MOPERQ MRUNQ)
 
/***  Determine TOLIB parameter.  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/****        CHGVAR     VAR(&TOLIB) VALUE(&SYSID *CAT 'DMLIB')  */    /*200733*/
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *CAT 'DPLIB')        /*200733*/
 
/***  Check if last try is completed.  ***/
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
             IF         COND(&STATUS *NE 'Y') THEN(DO)
 
/***  Save items  ***/
 
             CPYF       FROMFILE(ILITEMPD) TOFILE(&TOLIB/ILITEMPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
/***  Save audit information  ***/
 
             CPYF       FROMFILE(ILRKAUPD) TOFILE(&TOLIB/ILRKAUPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
/***  Save AWND items ***/
 
             CPYF       FROMFILE(ILDINWPD) TOFILE(&TOLIB/ILDINWPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
/***  Save AWND items - Audit ***/
 
             CPYF       FROMFILE(ILNWAUPD) TOFILE(&TOLIB/ILNWAUPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/***  Restore items ***/
 
             CPYF       FROMFILE(&TOLIB/ILITEMPDXX) TOFILE(ILITEMPD) +
                        MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
 
/***  Restore audit information ***/
 
             CPYF       FROMFILE(&TOLIB/ILRKAUPDXX) TOFILE(ILRKAUPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
 
/***  Restore AWND items ***/
 
             CPYF       FROMFILE(&TOLIB/ILDINWPDXX) TOFILE(ILDINWPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
 
/***  Restore AWND audit information  ***/
 
             CPYF       FROMFILE(&TOLIB/ILNWAUPDXX) TOFILE(ILNWAUPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
 
             ENDDO
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/***  Call extract pgm.  ***/
 
             CALL       PGM(IL0653)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                     TOMSGQ(MOPERQ MRUNQ)
                        GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Add AUDIT records in the file ***/
 
             CPYF       FROMFILE(ILNWAUPD) TOFILE(ILRKAUPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817)
 
/***  Clear intermediray file  ***/
 
             CLRPFM     FILE(ILDINWPD)
             CLRPFM     FILE(ILNWAUPD)
 
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             DLTF       FILE(ILITEMPDXX)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(ILRKAUPDXX)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(ILDINWPDXX)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(ILNWAUPDXX)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message to User alerting failure.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0653 - IBLC 2002 -AWND copy of items +
                          failed - see joblog for details.') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
