/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Move contents of one OUTQ to another')       */
/*OVR    CRTPF FILE(QTEMP/MOVOUTQ) RCDLEN(132)                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0248 - Move contents of one output queue to another      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 26Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001 *CREATE     Date 15Sep98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - Changes caused by 5.1 OS.                          */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUALF &QUALT &CLR)
 
             DCL        VAR(&QUALF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUALT) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CLR) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&OUTQF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBT) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&DATSEP1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATSEP2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIMSEP1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIMSEP2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRACKET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FINALCHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPLF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPLFNO) TYPE(*CHAR) LEN(6)
/************DCL        VAR(&SPLFNON) TYPE(*DEC) LEN(6)                                   /*CPK015*/
             DCL        VAR(&SPLFNON) TYPE(*DEC) LEN(6 0)                                 /*CPK015*/
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(MOVOUTQ)
 
/*Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGVAR     VAR(&OUTQF) VALUE(%SST(&QUALF 1 10))
             CHGVAR     VAR(&OUTQT) VALUE(%SST(&QUALT 1 10))
             CHGVAR     VAR(&LIBF) VALUE(%SST(&QUALF 11 10))
             CHGVAR     VAR(&LIBT) VALUE(%SST(&QUALT 11 10))
 
/* If 'to' output queue does not alrady exist create it; if it does  */
/* and CLEAR is '*YES' then do so */
             CHKOBJ     OBJ(&LIBT/&OUTQT) OBJTYPE(*OUTQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTOUTQ    OUTQ(&LIBT/&OUTQT)
             ENDDO
             IF         COND(&CLR *EQ '*YES') THEN(DO)
                CLROUTQ    OUTQ(&LIBT/&OUTQT)
             ENDDO
 
/* Display 'from' output queue to print */
             WRKOUTQ    OUTQ(&LIBF/&OUTQF) OUTPUT(*PRINT)
/* Convert spool file to database file */
             DLTF       FILE(QTEMP/MOVOUTQ)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/MOVOUTQ) RCDLEN(132) +
                          TEXT('Temporary database file for MOVOUTQ +
                          utility')
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(QTEMP/MOVOUTQ) +
                          SPLNBR(*LAST)
/* Read file */
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
/* If relevant parts of field from MOVOUTQ are time dividers then */
/*  ignore */
/************CHGVAR     VAR(&DATSEP1) VALUE(%SST(&MOVOUTQ 102 1))                         /*CPK015*/
/************CHGVAR     VAR(&DATSEP2) VALUE(%SST(&MOVOUTQ 105 1))                         /*CPK015*/
/************CHGVAR     VAR(&TIMSEP1) VALUE(%SST(&MOVOUTQ 111 1))                         /*CPK015*/
/************CHGVAR     VAR(&TIMSEP2) VALUE(%SST(&MOVOUTQ 114 1))                         /*CPK015*/
             CHGVAR     VAR(&DATSEP1) VALUE(%SST(&MOVOUTQ 104 1))                         /*CPK015*/
             CHGVAR     VAR(&DATSEP2) VALUE(%SST(&MOVOUTQ 107 1))                         /*CPK015*/
             CHGVAR     VAR(&TIMSEP1) VALUE(%SST(&MOVOUTQ 113 1))                         /*CPK015*/
             CHGVAR     VAR(&TIMSEP2) VALUE(%SST(&MOVOUTQ 116 1))                         /*CPK015*/
             CHGVAR     VAR(&BRACKET) VALUE(%SST(&MOVOUTQ 6 1))
             CHGVAR     VAR(&FINALCHK) VALUE(%SST(&MOVOUTQ 2 1))
 
/* Check for all possible types of separators */
             IF         COND(&DATSEP1 *EQ '/' *OR &DATSEP1 *EQ '-' +
                          *OR &DATSEP1 *EQ '.' *OR &DATSEP1 *EQ ',' +
                          *OR &DATSEP1 *EQ ' ') THEN(DO)
                IF         COND(&DATSEP2 *EQ '/' *OR &DATSEP2 *EQ '-' +
                          *OR &DATSEP2 *EQ '.' *OR &DATSEP2 *EQ ',' +
                          *OR &DATSEP2 *EQ ' ') THEN(DO)
                   IF     COND(&TIMSEP1 *EQ ':' *OR &TIMSEP1 *EQ '.' +
                          *OR &TIMSEP1 *EQ ',' *OR &TIMSEP1 *EQ ' +
                          ') THEN(DO)
                      IF  COND(&TIMSEP2 *EQ ':' *OR &TIMSEP2 *EQ '.' +
                          *OR &TIMSEP2 *EQ ',' *OR &TIMSEP2 *EQ ' +
                          ') THEN(DO)
/* Final check if blank date and time separators have been used */
                         IF COND(&DATSEP1 *EQ ' ' +
                            *AND &DATSEP2 *EQ ' ' +
                            *AND &TIMSEP1 *EQ ' ' +
                            *AND &TIMSEP2 *EQ ' ') THEN(DO)
                            IF COND(&BRACKET *EQ '(' +
                                   *OR &FINALCHK *EQ ' ') +
                                     THEN(GOTO CMDLBL(READNEXT))
                         ENDDO
/* Break down field for relevant information */
                         CHGVAR     VAR(&SPLF) VALUE(%SST(&MOVOUTQ 2 10))
                         CHGVAR     VAR(&USER) VALUE(%SST(&MOVOUTQ 13 10))
/************            CHGVAR VAR(&JOB) VALUE(%SST(&MOVOUTQ 82 10))                     /*CPK015*/
/************            CHGVAR VAR(&JOBNO) VALUE(%SST(&MOVOUTQ 93 6))                    /*CPK015*/
/************            CHGVAR VAR(&SPLFNO) VALUE(%SST(&MOVOUTQ 71 6))                   /*CPK015*/
                         CHGVAR     VAR(&JOB) VALUE(%SST(&MOVOUTQ 84 10))                 /*CPK015*/
                         CHGVAR     VAR(&JOBNO) VALUE(%SST(&MOVOUTQ 95 6))                /*CPK015*/
                         CHGVAR     VAR(&SPLFNO) VALUE(%SST(&MOVOUTQ 73 6))               /*CPK015*/
                         CHGVAR     VAR(&SPLFNON) VALUE(&SPLFNO)
                         CHGSPLFA   FILE(&SPLF) JOB(&JOBNO/&USER/&JOB) +
                                      SPLNBR(&SPLFNON) OUTQ(&LIBT/&OUTQT)
                      ENDDO
                   ENDDO
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
             GOTO       CMDLBL(ENDPGM)
ABNOR:
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
 
                  SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm UTC0072') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             CHGVAR     VAR(&IN01) VALUE('1')
ABNOR2:
 /* Receive diagnostic error message */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
             IF         COND(&MSGID *NE ' ') THEN(DO)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       CMDLBL(ABNOR2)
             ENDDO
 /* Receive escape error message */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
