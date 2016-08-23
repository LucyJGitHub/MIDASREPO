/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Copy one data queue to another')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       CPYDTAQ - Copy one data queue to another                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 24May04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015 *CREATE     DATE 28Feb02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CPK015 - 4.01 packaging.  Move data queues to DPLIB.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUAL1 &QUAL2 &COPYOPT &CREATE)
 
             DCL        VAR(&QUAL1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUAL2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&COPYOPT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CREATE) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQ1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQ2) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&DTAQD) TYPE(*CHAR) LEN(80)
             DCL        VAR(&DTAQD1) TYPE(*CHAR) LEN(80)
             DCL        VAR(&DTAQD2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSGLENB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KEYLENB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOOFMSGSB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGLEN1) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&KEYLEN1) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&SEQ1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SNDRID1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FORCE1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TEXT1) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOOFMSGS1) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MSGLEN2) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&KEYLEN2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&SEQ2) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CRTSEQ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CRTKEYLEN) TYPE(*DEC) LEN(3)
             DCL        VAR(&CRTSNDRID) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CRTFORCE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LIFO) TYPE(*CHAR) LEN(4) VALUE('*NO ')
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Retrieve data queue names and libraries. */
             CHGVAR     VAR(&DTAQ1) VALUE(%SST(&QUAL1 1 10))
             CHGVAR     VAR(&LIB1) VALUE(%SST(&QUAL1 11 10))
             CHGVAR     VAR(&DTAQ2) VALUE(%SST(&QUAL2 1 10))
             CHGVAR     VAR(&LIB2) VALUE(%SST(&QUAL2 11 10))
 
/* Retrieve information about first data queue. */
             CALL       PGM(UT0073) PARM(&QUAL1 &DTAQD)
             CHGVAR     VAR(&DTAQD1) VALUE(&DTAQD)
 
/* Get length of data queue. */
             CHGVAR     VAR(&MSGLENB) VALUE(%SST(&DTAQD1 9 4))
             CHGVAR     VAR(&MSGLEN1) VALUE(%BIN(&MSGLENB))
 
/* Get length of key (if data queue is keyed). */
             CHGVAR     VAR(&KEYLENB) VALUE(%SST(&DTAQD1 13 4))
             CHGVAR     VAR(&KEYLEN1) VALUE(%BIN(&KEYLENB))
             IF         COND(&KEYLEN1 *NE 0) THEN(DO)
                CHGVAR     VAR(&CRTKEYLEN) VALUE(&KEYLEN1)
             ENDDO
 
/* Get how data queue is sequenced. */
             CHGVAR     VAR(&SEQ1) VALUE(%SST(&DTAQD1 17 1))
             IF         COND(&SEQ1 *EQ 'F') THEN(DO)
                CHGVAR     VAR(&CRTSEQ) VALUE('*FIFO')
             ENDDO
             ELSE       CMD(DO)
                IF         COND(&SEQ1 *EQ 'L') THEN(DO)
                   CHGVAR     VAR(&CRTSEQ) VALUE('*LIFO')
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&CRTSEQ) VALUE('*KEYED')
                ENDDO
             ENDDO
 
/* Get Sender ID attribute. */
             CHGVAR     VAR(&SNDRID1) VALUE(%SST(&DTAQD1 18 1))
             IF         COND(&SNDRID1 *EQ 'N') THEN(DO)
                CHGVAR     VAR(&CRTSNDRID) VALUE('*NO')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&CRTSNDRID) VALUE('*YES')
             ENDDO
 
/* Get Force attribute. */
             CHGVAR     VAR(&FORCE1) VALUE(%SST(&DTAQD1 19 1))
             IF         COND(&FORCE1 *EQ 'N') THEN(DO)
                CHGVAR     VAR(&CRTFORCE) VALUE('*NO')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&CRTFORCE) VALUE('*YES')
             ENDDO
 
/* Get description of data queue. */
             CHGVAR     VAR(&TEXT1) VALUE(%SST(&DTAQD1 20 59))
             IF         COND(&TEXT1 *EQ ' ') THEN(DO)
                CHGVAR     VAR(&TEXT1) VALUE('*BLANK')
             ENDDO
 
/* Get number of messages on data queue. */
             CHGVAR     VAR(&NOOFMSGSB) VALUE(%SST(&DTAQD1 73 4))
             CHGVAR     VAR(&NOOFMSGS1) VALUE(%BIN(&NOOFMSGSB))
 
/* If CREATE = '*YES' and the second data queue doesn't already exist */
/*  then create a copy of the first.                                  */
             IF         COND(&CREATE *EQ '*YES') THEN(DO)
                CHKOBJ     OBJ(&LIB2/&DTAQ2) OBJTYPE(*DTAQ)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   IF         COND(&CRTSEQ *EQ '*KEYED') THEN(DO)
                      CRTDTAQ    DTAQ(&LIB2/&DTAQ2) MAXLEN(&MSGLEN1) +
                                   FORCE(&CRTFORCE) SEQ(&CRTSEQ) +
                                   KEYLEN(&CRTKEYLEN) SENDERID(&CRTSNDRID) +
                                   TEXT(&TEXT1)
                   ENDDO
                   ELSE       CMD(DO)
                      CRTDTAQ    DTAQ(&LIB2/&DTAQ2) MAXLEN(&MSGLEN1) +
                                   FORCE(&CRTFORCE) SEQ(&CRTSEQ) +
                                   SENDERID(&CRTSNDRID) TEXT(&TEXT1)
                   ENDDO
                ENDDO
             ENDDO
 
/* Create temporary copy of first data queue. */
             DLTDTAQ    DTAQ(QTEMP/TEMPDTAQ)
             MONMSG     MSGID(CPF2105)
             IF         COND(&CRTSEQ *EQ '*KEYED') THEN(DO)
                CRTDTAQ    DTAQ(QTEMP/TEMPDTAQ) MAXLEN(&MSGLEN1) +
                             FORCE(&CRTFORCE) SEQ(&CRTSEQ) +
                             KEYLEN(&CRTKEYLEN) SENDERID(&CRTSNDRID) +
                             TEXT(&TEXT1)
             ENDDO
             ELSE       CMD(DO)
                CRTDTAQ    DTAQ(QTEMP/TEMPDTAQ) MAXLEN(&MSGLEN1) +
                             FORCE(&CRTFORCE) SEQ(&CRTSEQ) +
                             SENDERID(&CRTSNDRID) TEXT(&TEXT1)
             ENDDO
 
/* Retrieve information about second data queue. */
             CALL       PGM(UT0073) PARM(&QUAL2 &DTAQD)
             CHGVAR     VAR(&DTAQD2) VALUE(&DTAQD)
 
/* Get length of data queue. */
             CHGVAR     VAR(&MSGLENB) VALUE(%SST(&DTAQD2 9 4))
             CHGVAR     VAR(&MSGLEN2) VALUE(%BIN(&MSGLENB))
 
/* Get length of key (if data queue is keyed). */
             CHGVAR     VAR(&KEYLENB) VALUE(%SST(&DTAQD2 13 4))
             CHGVAR     VAR(&KEYLEN2) VALUE(%BIN(&KEYLENB))
 
/* Get how data queue is sequenced. */
             CHGVAR     VAR(&SEQ2) VALUE(%SST(&DTAQD2 17 1))
 
/* If the second data queue is *LIFO then set a flag accordingly and  */
/*  create a copy of the first data queue with *LIFO sequence.        */
             IF         COND(&SEQ2 *EQ 'L') THEN(DO)
                CHGVAR     VAR(&LIFO) VALUE('*YES')
                DLTDTAQ    DTAQ(QTEMP/LIFODTAQ)
                MONMSG     MSGID(CPF2105)
                CRTDTAQ    DTAQ(QTEMP/LIFODTAQ) MAXLEN(&MSGLEN1) +
                             FORCE(&CRTFORCE) SEQ(*LIFO) +
                             SENDERID(&CRTSNDRID) TEXT(&TEXT1)
             ENDDO
 
/* If *REPLACE is specified then clear second data queue. */
             IF         COND(&COPYOPT *EQ '*REPLACE') THEN(DO)
                CALL       PGM(QCLRDTAQ) PARM(&DTAQ2 &LIB2)
             ENDDO
 
/* Call program to receive and send messages from one data queue */
/*  to another.                                                  */
             CALL       PGM(UT0074) PARM(&DTAQ1 &LIB1 &DTAQ2 &LIB2 +
                          &MSGLEN1 &MSGLEN2 &KEYLEN1 &KEYLEN2 +
                          &NOOFMSGS1 &LIFO)
 
             GOTO       CMDLBL(ENDPGM)
ERROR:
/* Recursive error handling. */
             IF         COND(&IN01) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                             MSGDTA('Recursive error in pgm UTC0073') +
                             MSGTYPE(*ESCAPE)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&IN01) VALUE('1')
ABNOR2:
/* Receive diagnostic error message. */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
             IF         COND(&MSGID *NE ' ') THEN(DO)
/* Pass it back to calling program. */
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                GOTO       CMDLBL(ABNOR2)
             ENDDO
/* Receive escape error message. */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
/* Pass it back to calling program. */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
