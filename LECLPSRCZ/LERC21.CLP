/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facilities Extract for Prof Reports')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC21  - Facilities extract - 1st level                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. MOF60              DATE 23MAR92              */
/*       PREV AMEND NO.                    DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM  PARM(&CNAM &CSEQ)
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Facility Profitability Extract') +
                                       TOMSGQ(MRUNQ)
 
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
     IF COND(&STAT *EQ 'Y') THEN(DO)
 
/* If the component has previously failed use the security copies */
 
            CPYF FROMFILE(XLEPFCD) TOFILE(LEPEFCD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFCD))
            CPYF FROMFILE(XLEPFCZ) TOFILE(LEPEFCZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFCZ))
            ENDDO
 
     ELSE DO
/* IF NOT RERUN Take Security Copy of Profitability Format Files */
 
     CPYF       FROMFILE(LEPEFCD) TOFILE(XLEPFCD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFCD))
     CPYF       FROMFILE(LEPEFCZ) TOFILE(XLEPFCZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFCZ))
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
 
  /* Call FACILITIES EXTRACT Program */
 
             CALL       LER210
 
  /* IF ERROR, SEND MSG & COPY BACK SECURITY FILES     */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
 
     ELSE CMD(DO)
 
/* If the component has completed successfully reset the status field */
 
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
