/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Initialize C.O.B. files')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0603  - IBLC 2002 Initialize C.O.B. files                */
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
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/*** Declare Variables.   ***/
 
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&MMOD50) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT (1 256)) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             SNDPGMMSG  MSG('ILC0603 - IBLC 2002 Initialize C.O.B. +
                          files') TOMSGQ(MOPERQ MRUNQ)
 
/***  Determine TOLIB parameter.  ***/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *CAT 'DMLIB')
 
/***  Clear receiving file.   ***/
 
             CLRPFM     FILE(ILITEMPD)
             MONMSG     MSGID(CPF2817)
 
/***  Futures & Options : Clear FOKEYD1X, FOKEYD2X ***/
 
             DLTF       FILE(FOKEYD1X)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(FOKEYD2X)
             MONMSG     MSGID(CPF0000)
 
/***  Retrieve Pos. 50 of MMOD (Financial Futures Module).  ***/
 
             RTVDTAARA  DTAARA(MMOD (50 1)) RTNVAR(&MMOD50)
 
             IF         COND(&MMOD50 *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDROUND))
 
/**********  CLRPFM     FILE(FOKEYDXL) MBR(OTC)                                           /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(OTC)                                           /*CER001*/
 
/***  do it foe Every Market taken into account for COB.   ***/
 
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
 
ROUND:       IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(ENDROUND))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**********  CLRPFM     FILE(FOKEYDXL) MBR(&MKT)                                          /*CER001*/
             CLRPFM     FILE(FFAKX1PD) MBR(&MKT)                                          /*CER001*/
             MONMSG     MSGID(CPF3141)
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(ROUND)
 
/***  Normal Termination ***/
 
ENDROUND:
             GOTO       CMDLBL(ENDPGM)
 
/***  Program ended abnormally.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0603 - IBLC 2002 - File +
                          initialization ended abnormally - see +
                          joblog for details.') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
/***  End program ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
