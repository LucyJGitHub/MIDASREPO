/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Audit report')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0240  - AUDIT REPORT                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 17SEP92              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRLN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&X) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ITEMX) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
             DCLF       FILE(HFFILEPD)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
 
/* */
/* Get date and time */
/* */
             RTVSYSVAL  SYSVAL(QSRLNBR) RTNVAR(&SRLN)
             RTVJOBA    DATE(&DATE)
 
/* */
/* Delete and recreate the work data area JRN2 in QTEMP */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRN2)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/JRN2) TYPE(*CHAR) LEN(256)
 
/* */
/* Delete and recreate the work data area JRN in QTEMP */
/* */
             DLTDTAARA  DTAARA(QTEMP/JRN)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/JRN) TYPE(*CHAR) LEN(256)
 
/* */
/* Read all records on file */
/* */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
 
/* */
/* If file not selected then read next record */
/* */
             IF         COND(&ENAB *NE 'E') THEN(GOTO CMDLBL(LOOP))
             IF         COND(&HEADER *NE '0') THEN(GOTO CMDLBL(LOOP))
             IF         COND((&AUDIT *NE 'Y') *AND (&AUDIT *NE 'y')) +
                          THEN(GOTO CMDLBL(LOOP))
 
/* */
/* Check for member DATASPY     */
/* */
             CHGVAR     VAR(&X) VALUE('F' *TCAT %SST(&FFILE 2 9))
             CHKOBJ     OBJ(&HFLIB/&X) OBJTYPE(*FILE) MBR(DATASPY)
 
/* */
/* If member DATASPY is not found then cannot produce the audit */
/* so read next record */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP))
 
/* */
/* Override to the right file members */
/* */
             OVRDBF     FILE(FIELDS) TOFILE(&HFLIB/&X) MBR(DATASPY)
             OVRDBF     FILE(JOURNAL) TOFILE(&HFLIB/&FFILE) +
                          MBR(JRNTEMP)
 
             CHGDTAARA  DTAARA(QTEMP/JRN (23 32)) VALUE(&FFILE)
             CHGVAR     VAR(&ITEMX) VALUE(&ITEM)
 
/* */
/* If file HFRGRPP* is not found then read next record as this one */
/* cannot be processed */
/* */
             CHGVAR     VAR(&XP) VALUE('HFRGRPP' *TCAT &ITEMX)
             CHKOBJ     OBJ(&HFLIB/&XP) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP))
             OVRDBF     FILE(HFRGRPPD) TOFILE(&XP)
 
/* */
/* Call the print control program */
/* */
             CALL       PGM(HF0300) PARM(&SRLN &DATE &ITEM)
 
/* */
/* Read next record */
/* */
             GOTO       CMDLBL(LOOP)
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0240 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
