/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CVTSRCLEN pre-processor')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0080 - CVTSRCLEN pre-processor                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP002             Date 12Jul99              */
/*                      CUP001 *C *CREATE  Date 21Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP002 - Changed from UP to UT module                       */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUALFIL &LENDEC &NEWLIB)
 
             DCL        VAR(&QUALFIL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LENDEC) TYPE(*DEC) LEN(3)
             DCL        VAR(&NEWLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&SRCFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE('0')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Format qualified variables */
             CHGVAR     VAR(&SRCFIL) VALUE(%SST(&QUALFIL 1 10))
             CHGVAR     VAR(&SRCLIB) VALUE(%SST(&QUALFIL 11 10))
 
/* Display the file(s) to a driving file. +
     The main program uses this to check if it is a source file and to+
     determine its length.   +
     N.B. The DSPFD command handles &SRCFIL = '*ALL' without any+
          problem. */
 
             DSPFD      FILE(&SRCLIB/&SRCFIL) TYPE(*ATR) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/CVDSPFD)
 /* Remove the diagnostic message of prevous command */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
/* Call main program */
/************CALL       PGM(UPC0081) PARM(&SRCFIL &SRCLIB &LENDEC +                    */ /*CUP002*/
/************             &NEWLIB &ERR)                                                */ /*CUP002*/
             CALL       PGM(UTC0081) PARM(&SRCFIL &SRCLIB &LENDEC +
                          &NEWLIB &ERR)                                                   /*CUP002*/
             IF         COND(&ERR *EQ 'Y') THEN(GOTO CMDLBL(ABNOR))
             GOTO       CMDLBL(END)
 
/* Error processing */
ABNOR:
             RCLRSC
 /* Send escape messages for errors in RPG programs */
             IF         COND(&ERR *EQ 'Y') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('File is not a source file') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm +
                          CVTSRCLEN1') MSGTYPE(*ESCAPE)
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
                GOTO CMDLBL(ABNOR2)
             ENDDO
 /* Receive escape error message */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             ENDPGM
