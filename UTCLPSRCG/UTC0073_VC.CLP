/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPYDTAQ validity checker')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0073_VC - Validity checker for CPYDTAARA                 */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 24May04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015 *C *CREATE  Date 28Feb02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CPK015 - 4.01 packaging.  Move data queues to DPLIB.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUAL1 &QUAL2 &COPYOPT &CREATE)
 
             DCL        VAR(&QUAL1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUAL2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&COPYOPT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CREATE) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&DTAQ1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQ2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQD1) TYPE(*CHAR) LEN(80)
             DCL        VAR(&DTAQD2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SEQ1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEQ2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&DTAQ1) VALUE(%SST(&QUAL1 1 10))
             CHGVAR     VAR(&LIB1) VALUE(%SST(&QUAL1 11 10))
             CHGVAR     VAR(&DTAQ2) VALUE(%SST(&QUAL2 1 10))
             CHGVAR     VAR(&LIB2) VALUE(%SST(&QUAL2 11 10))
 
/* Check that the 'from' and 'to' data queues are not the same. */
             IF         COND(&QUAL1 *EQ &QUAL2) THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000The +
                             data queues must be different.') +
                             MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check that first library exists. */
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
 
/* Check that second library exists. */
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
 
/* Check that first data queue exists. */
             CHKOBJ     OBJ(&LIB1/&DTAQ1) OBJTYPE(*DTAQ) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Data queue' *BCAT &DTAQ1 +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If it does exist then retrieve data about it and store it. */
             CALL       PGM(UT0073) PARM(&QUAL1 &DTAQD1)
 
/* Check that second data queue exists. */
             CHKOBJ     OBJ(&LIB2/&DTAQ2) OBJTYPE(*DTAQ) AUT(*CHANGE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                   CHGVAR     VAR(&EXIST) VALUE('N')
             ENDDO
/* If it doesn't exist then and CREATE = '*NO' then it is an error. */
             IF         COND(&EXIST *EQ 'N') THEN(DO)
                IF         COND(&CREATE *EQ '*NO') THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000Data queue' *BCAT &DTAQ2 +
                                *BCAT 'does not exist or you have +
                                insufficient authority') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/* ... otherwise, if CREATE = '*YES', specify a library. */
                ELSE       CMD(DO)
                   IF         COND(&LIB2 *EQ '*LIBL') THEN(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000A +
                                   library must be specified if creating a +
                                   data queue.') MSGTYPE(*DIAG)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                ENDDO
             ENDDO
             ELSE       CMD(DO)
/* If second data queue did exist then check if it is DDM; if it is then */
/*  do not copy to it.                                                   */
                RTVOBJD    OBJ(&LIB2/&DTAQ2) OBJTYPE(*DTAQ) OBJATR(&ATR)
                IF         COND(&ATR *EQ 'DDMDTAQUE') THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000Do +
                                not attempt to copy to a DDM data queue') +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/* If second data queue does exist then retrieve data about it. */
                CALL       PGM(UT0073) PARM(&QUAL2 &DTAQD2)
/* Check that both data queues are comapatible; both keyed or not keyed. */
                CHGVAR     VAR(&SEQ1) VALUE(%SST(&DTAQD1 17 1))
                CHGVAR     VAR(&SEQ2) VALUE(%SST(&DTAQD2 17 1))
                IF         COND(&SEQ1 *EQ 'K' *AND &SEQ2 *NE 'K' *OR +
                             &SEQ1 *NE 'K' *AND &SEQ2 *EQ 'K') THEN(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000The +
                                specified data queues will not copy +
                                because of a key issue.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Send message to pass earlier messages back. */
ABNOR:
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
