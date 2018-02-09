/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP CMPOUTQ validity checker')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0400_VC - Validity checker for CMPOUTQ command           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CUP012 *CREATE     Date 07Aug00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP012 - Creation of CMPOUTQ command.  This is a re-write   */
/*                 of CMPCOB.                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OUTQ1 &OUTQ2 &LIN &COLDIF &MOVLIN)
 
             DCL        VAR(&OUTQ1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTQ2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LIN) TYPE(*DEC) LEN(1)
             DCL        VAR(&COLDIF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MOVLIN) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&OUTQUEUE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQUEUE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&OUTQUEUE1) VALUE(%SST(&OUTQ1 1 10))
             CHGVAR     VAR(&OUTQLIB1) VALUE(%SST(&OUTQ1 11 10))
             CHGVAR     VAR(&OUTQUEUE2) VALUE(%SST(&OUTQ2 1 10))
             CHGVAR     VAR(&OUTQLIB2) VALUE(%SST(&OUTQ2 11 10))
 
/*    Check output queues exist */
             CHKOBJ     OBJ(&OUTQLIB1/&OUTQUEUE1) OBJTYPE(*OUTQ) +
                          AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Output queue' *BCAT +
                          &OUTQUEUE1 *BCAT 'does not exist or you +
                          have insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
             MONMSG     MSGID(CPF9810) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &OUTQLIB1 *BCAT +
                          'does not exist') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHKOBJ     OBJ(&OUTQLIB2/&OUTQUEUE2) OBJTYPE(*OUTQ) +
                          AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Output queue' *BCAT +
                          &OUTQUEUE2 *BCAT 'does not exist or you +
                          have insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
             MONMSG     MSGID(CPF9810) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &OUTQLIB2 *BCAT +
                          'does not exist') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Send message to cause CPF to pass earlier messages back */
ABNOR:
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
