/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Monthly Accruals Margin program')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC316 - Monthly Accruals Margin Program                   */
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
/*       LAST AMEND NO. E49419             DATE 11JAN93              */
/*       PREV AMEND NO. XXXXXX             DATE DDMMMYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       E49419  -  New program to call LER316 so that LERC315 can   */
/*                  call LER315 (for daily accruals).                */
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
 
     SNDPGMMSG  MSG('Monthly Accruals Margin Program') +
                                       TOMSGQ(MRUNQ)
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
     IF COND(&STAT *EQ 'Y') THEN(DO)
 
 
            CPYF FROMFILE(XLEPMGD) TOFILE(LEPEMGD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEMGD))
            CPYF FROMFILE(XLEPMGZ) TOFILE(LEPEMGZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEMGZ))
 
     ENDDO
 
     ELSE DO
 
/* Take Security Copy of Profitability Format Files */
 
     CPYF       FROMFILE(LEPEMGD) TOFILE(XLEPMGD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPMGD))
     CPYF       FROMFILE(LEPEMGZ) TOFILE(XLEPMGZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPMGZ))
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
 
  /* Call Margin Program */
 
             CALL       LER316
 
  /* IF ERROR, SEND MSG & COPY BACK SECURITY FILES     */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
     ELSE DO
 
                   CLRPFM     FILE(ACTN3DH)
                   CLRPFM     FILE(ACTN3DK)
                   CLRPFM     FILE(ACTN3DN)
                   CLRPFM     FILE(ACTN3ZX)
 
/* If the component has completed successfully reset the status field */
 
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
