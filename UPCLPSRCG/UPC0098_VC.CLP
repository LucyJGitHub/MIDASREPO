/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP MRGDLVLST Validity Checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0098_VC - Validity checker for MRGDLVLST                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CUP005 *CREATE     Date 29Oct99              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP005 - Changes for DBA R3.02                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BASELIB &MRGLIB &TGTLIB)
 
             DCL        VAR(&BASELIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRGLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TGTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* See if BASELIB exists */
             CHKOBJ     OBJ(*LIBL/&BASELIB) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000' *TCAT &BASELIB *BCAT +
                          'does not exist') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
             MONMSG     MSGID(CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000You do not have authority +
                          to' *BCAT &BASELIB) MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* See if MRGLIB exists */
             CHKOBJ     OBJ(*LIBL/&MRGLIB) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000' *TCAT &MRGLIB *BCAT +
                          'does not exist') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
             MONMSG     MSGID(CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000You do not have authority +
                          to' *BCAT &MRGLIB) MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* See if TGTLIB exists */
             IF         COND(&TGTLIB *NE '*BASELIB') THEN(DO)
                CHKOBJ     OBJ(*LIBL/&TGTLIB) OBJTYPE(*LIB) AUT(*CHANGE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000' *TCAT &TGTLIB *BCAT +
                             'does not exist') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000You do not have authority +
                             to' *BCAT &TGTLIB) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Check if driving file exists in BASELIB */
             CHKOBJ     OBJ(&BASELIB/UPDLVCL0) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Driving file does not exist +
                          in' *BCAT &BASELIB) MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check if driving file exists in MRGLIB */
             CHKOBJ     OBJ(&MRGLIB/UPDLVCL0) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Driving file does not exist +
                          in' *BCAT &MRGLIB) MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
 ABNOR:      IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
