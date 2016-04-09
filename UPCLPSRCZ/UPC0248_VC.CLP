/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP MOVOUTQ validity checker')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UTC0248_VC - Validity checker for MOVOUTQ                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     DATE 14Sep98              */
/*       Prev Amend No. xxxxxx             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*********************************************************************/
             PGM        PARM(&QUALF &QUALT &CLR)
 
             DCL        VAR(&QUALF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUALT) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CLR) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&OUTQF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBT) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&OUTQF) VALUE(%SST(&QUALF 1 10))
             CHGVAR     VAR(&OUTQT) VALUE(%SST(&QUALT 1 10))
             CHGVAR     VAR(&LIBF) VALUE(%SST(&QUALF 11 10))
             CHGVAR     VAR(&LIBT) VALUE(%SST(&QUALT 11 10))
 
/*    Check that from output queue library exists */
             IF         COND(&LIBF *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIBF) OBJTYPE(*LIB) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIBF +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/*    Check that from output queue exists */
             CHKOBJ     OBJ(&LIBF/&OUTQF) OBJTYPE(*OUTQ) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Output queue' *BCAT &OUTQF +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*    Check that to output queue exists if *LIBL specified */
             IF         COND(&LIBT *EQ '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIBT/&OUTQT) OBJTYPE(*OUTQ) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Output queue' *BCAT &OUTQT +
                          *BCAT 'does not exist in the library list +
                          or you have insufficient authority') +
                          MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
ABNOR:      IF  COND(&ERROR *EQ 'Y') THEN(+
            SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
