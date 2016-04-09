/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Takeon for dealing YTD')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERYTDDEAL - YTD TAKEON OF DEALING                          */
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
/*       LAST AMEND NO. XXXXXX             DATE DDMMMYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare the variables for rerun checking */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             SNDPGMMSG  MSG('Year to date takeon of dealing') +
                          TOMSGQ(MRUNQ)
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
     IF COND(&STAT *EQ 'N') THEN(DO)
 
/* IF NOT RERUN Take Security Copy of History Files */
 
     CPYF       FROMFILE(LEPEDFD) TOFILE(XLEPDFD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPDFD))
     CPYF       FROMFILE(LEPECND) TOFILE(XLEPCND) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPCND))
     CPYF       FROMFILE(LEPEDFZ) TOFILE(XLEPDFZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPDFZ))
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
     ELSE CMD(DO)
 
/* IF RERUN Copy back Security Copy of History Files*/
 
     CPYF       FROMFILE(XLEPDFD) TOFILE(LEPEDFD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEDFD))
     CPYF       FROMFILE(XLEPCND) TOFILE(LEPECND) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPECND))
     CPYF       FROMFILE(XLEPDFZ) TOFILE(LEPEDFZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEDFZ))
 
     ENDDO
 
             OVRDBF     FILE(PECUSDE) TOFILE(PECUSDEMAT)
 
             CALL       PGM(DEALSTAKE)
 
  /* IF ERROR, SEND MSG */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
     ELSE  CMD(DO)
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
