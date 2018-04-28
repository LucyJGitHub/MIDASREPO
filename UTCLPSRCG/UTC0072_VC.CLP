/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPYDTAARA validity checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0072_VC - Validity checker for CPYDTAARA                 */
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
             PGM        PARM(&QUAL1 &QUAL2)
 
             DCL        VAR(&QUAL1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUAL2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTAARA1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAARA2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&DTAARA1) VALUE(%SST(&QUAL1 1 10))
             CHGVAR     VAR(&LIB1) VALUE(%SST(&QUAL1 11 10))
             CHGVAR     VAR(&DTAARA2) VALUE(%SST(&QUAL2 1 10))
             CHGVAR     VAR(&LIB2) VALUE(%SST(&QUAL2 11 10))
 
/*    Check that first library exists */
             IF         COND(&LIB1 *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIB1) OBJTYPE(*LIB) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIB1 +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/*    Check that second library exists */
             IF         COND(&LIB2 *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&LIB2) OBJTYPE(*LIB) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIB2 +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/*    Check that first data area exists */
             CHKOBJ     OBJ(&LIB1/&DTAARA1) OBJTYPE(*DTAARA) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Data area' *BCAT &DTAARA1 +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*    Check that second data area exists */
             CHKOBJ     OBJ(&LIB2/&DTAARA2) OBJTYPE(*DTAARA) +
                          AUT(*CHANGE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Data area' *BCAT &DTAARA2 +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* See if the 'to' data area is DDM; if it is then do not copy to it */
             RTVOBJD    OBJ(&LIB2/&DTAARA2) OBJTYPE(*DTAARA) +
                          OBJATR(&ATR)
             IF         COND(&ATR *EQ 'DDMDTAARA') THEN(DO)
                SNDPGMMSG MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000Do +
                          not attempt to copy to a DDM data area') +
                          MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
ABNOR:      IF  COND(&ERROR *EQ 'Y') THEN(+
            SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
