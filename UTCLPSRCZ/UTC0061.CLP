/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT FINDHOOK validity checker')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0061 - VALIDITY CHECKER FOR FINDHOOK COMMAND             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. Xnnnnn *CREATE     DATE ddmmmyy              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SRCM &SRCF &RPTTYPE &CPYTYPE &SUBM +
                          &NOOFLINES &JOBQ)
 
             DCL        VAR(&SRCM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPTTYPE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NOOFLINES) TYPE(*DEC) LEN(2)
             DCL        VAR(&CPYTYPE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUBM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&SFILE) VALUE(%SST(&SRCF 1 10))
             CHGVAR     VAR(&SLIB) VALUE(%SST(&SRCF 11 10))
 
/*    Check file exists */
             CHKOBJ     OBJ(&SLIB/&SFILE) OBJTYPE(*FILE) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Source file or library does not +
                          exist or you have insufficient authority') +
                          MSGTYPE(*DIAG)
             CHGVAR     VAR(&ERROR) VALUE('Y')
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*    Check member exists                                            */
             IF         COND(&SLIB *EQ '*LIBL') THEN(DO)
             CALL       PGM(UT0063) PARM(&SRCM &SFILE ' ' &ERROR)
                  IF         COND(&ERROR *EQ 'Y') THEN(DO)
                  SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Source member ' *CAT +
                          &SRCM *TCAT ' not found in file ' *CAT +
                          &SFILE *TCAT ' in library list') +
                          MSGTYPE(*DIAG)
                  ENDDO
             ENDDO
             ELSE       CMD(DO)
             RTVMBRD    FILE(&SLIB/&SFILE) MBR(&SRCM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Source member ' *CAT &SRCM +
                          *TCAT ' not found in file ' *CAT &SFILE) +
                          MSGTYPE(*DIAG)
             CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
             ENDDO
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
ABNOR:      IF  COND(&ERROR *EQ 'Y') THEN(+
            SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
