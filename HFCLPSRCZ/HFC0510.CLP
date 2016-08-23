/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Select entries from run date')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0510  - SELECT JOURNAL ENTRIES FOR RUNDATE               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 099185             DATE 10JUL96              */
/*                      S01379             DATE 17SEP92              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*      099185  - HAF uses date format DDMMYY, so change job to use  */
/*                date format *DMY, and reset it afterwards.         */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&OVR &NPEF)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&OVR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NPEF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&X) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&RUNPTY) TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSSV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSPG) TYPE(*CHAR) LEN(10) VALUE('HFC0510')
             DCL        VAR(&MSFM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSRP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QDATFMT) TYPE(*CHAR) LEN(4)           /*099185*/
 
             DCLF       FILE(HFFILEPD)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get the system date */
/* */
/************RTVJOBA    DATE(&DAT)                                 /*099185*/
             RTVJOBA    DATE(&DAT) DATFMT(&QDATFMT)                /*099185*/
 
/* */
/* Save the current priority */
/* */
             RTVJOBA    RUNPTY(&RUNPTY)
 
/* Change Date Format to be DDMMYY, which is the format used by HAF.  *099185*/
             CHGJOB     DATFMT(*DMY)                                 /*099185*/
 
/* */
/* Call HF0510 to determine the time interval for display */
/* */
             CALL       PGM(HF0510)
 
/* */
/* On error then return */
/* */
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO CMDLBL(END))
             IF         COND(%SWITCH(XXXX1XXX)) THEN(GOTO CMDLBL(END))
 
/* */
/* Retrieve the times from HF0510 */
/* */
             RTVDTAARA  DTAARA(JRN2 (1 6)) RTNVAR(&TIM1)
             RTVDTAARA  DTAARA(JRN2 (7 6)) RTNVAR(&TIM2)
 
/* */
/* Build the DSPJRN command */
/* */
/************CHGVAR     VAR(&X) VALUE('DSPJRN JRN(*LIBL/ICJRN) +
                          RCVRNG(ICRCV001 *CURRENT) FILE(')*********************************CSC020*/
             CHGVAR     VAR(&X) VALUE('DSPJRN JRN(*LIBL/ICJRN) +
                          RCVRNG(*CURCHAIN) FILE(')                                       /*CSC020*/
 
/* */
/* Delete the old QTEMP/XX */
/* */
             DLTF       FILE(QTEMP/XX)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Build the DSPJRN command */
/* */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             CHGVAR     VAR(&X) VALUE(&X *BCAT '(*LIBL/' *TCAT +
                          &NPEF *TCAT ' *ALL)')
                          GOTO DISPLAY
                          ENDDO
 
/* */
/* Read all records on file */
/* */
 RETRY:      RCVF
 
/* */
/* EOF so exit loop */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DISPLAY))
 
/* */
/* If file not selected then read next record */
/* */
             IF         COND(&ENAB *NE 'E') +
                          THEN(GOTO CMDLBL(RETRY))
             IF         COND(&OVR *NE &FFILE) THEN(GOTO CMDLBL(RETRY))
 
/* */
/* Add this file into the DSPJRN command */
/* */
             CHGVAR     VAR(&X) VALUE(&X *BCAT '(*LIBL/' *TCAT +
                          &FFORM *TCAT ' *ALL)')
 
/* */
/* Process all files */
/* */
             GOTO       CMDLBL(RETRY)
 
/* */
/* DSPJRN to QTEMP/XX. Reduce priority as this command is heavy */
/* on processing. */
/* */
 
 
 DISPLAY:    IF         COND(&RUNPTY *LT 49) THEN(CHGJOB RUNPTY(49))
 
/* */
/* Finish the DSPJRN command */
/* */
 
 
             CHGVAR     VAR(&X) VALUE(&X *BCAT ') JRNCDE(R)' *BCAT +
                          'ENTDTALEN(9874) OUTPUT(*OUTFILE)' *BCAT +
                          'FROMTIME(' *TCAT &DAT *BCAT &TIM1 *TCAT +
                          ')  TOTIME(' *TCAT &DAT *BCAT &TIM2 *TCAT +
                          ') OUTFILE(QTEMP/XX)')
 
/* */
/* Ask the user to wait as this command may take some time. */
/* */
 
             CHGVAR     VAR(&MSGID) VALUE('HFM0010')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0510')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
 
/* */
/* Execute the DSPJRN command using QCMDEXEC */
/* */
             CALL       PGM(QCMDEXC) PARM(&X 5000)
 
/* */
/* Monitor for failure of DSPJRN command */
/* */
             MONMSG     MSGID(CPF0000)
 
 XX:
/* */
/* Reset runpty back to initial value */
/* */
/************CHGJOB     RUNPTY(&RUNPTY)                              /*099185*/
             CHGJOB     RUNPTY(&RUNPTY) DATFMT(&QDATFMT)             /*099185*/
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0510 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
