/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Master switching program.')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC8999 - - Common transfer control handler                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01522             DATE 01JAN95              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RETURN)
 
 
/* Declare variables */
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&NEXT)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLAG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Global Monitor Message                                           */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
 
/*  Get the name of the next program to be executed:                 */
             RTVDTAARA  DTAARA(*LDA (813 10)) RTNVAR(&NEXT)
 
 
/*  Perform process according to retrieved name.                     */
             IF         COND(&NEXT *EQ '*EXIT*') THEN(GOTO CMDLBL(REQ))
 
             IF         COND(&NEXT *EQ 'CG8000') THEN(GOTO +
                          CMDLBL(EXEC))
             IF         COND(&NEXT *EQ 'CG8100') THEN(GOTO +
                          CMDLBL(EXEC))
             IF         COND(&NEXT *EQ 'CG8200') THEN(GOTO +
                          CMDLBL(EXEC))
             IF         COND(&NEXT *EQ 'CG8300') THEN(GOTO +
                          CMDLBL(EXEC))
             IF         COND(&NEXT *EQ 'CG8400') THEN(GOTO +
                          CMDLBL(EXEC))
 
             IF         COND(&NEXT *EQ '      ') THEN(DO)
                   CHGVAR     VAR(&NEXT) VALUE('CG8000    ')
                   CHGDTAARA  DTAARA(*LDA (813 10)) VALUE(&NEXT)
                   GOTO       CMDLBL(EXEC)
             ENDDO
 
 
/*  Retrieved name is invalid - none of the above.                   */
             GOTO       CMDLBL(INVALID)
 
 
/*  Transfer control to CGC8000, which will execute program &NEXT:   */
 EXEC:       TFRCTL     PGM(CGC8000) PARM(&RETURN)
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
/*  Handle an invalid &NEXT value:                                   */
 INVALID:    SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('An +
                          invalid program was given as the next to +
                          be called -- ' *CAT &NEXT)
             SNDPGMMSG  MSG('An invalid program was given as the +
                          next to be called -- ' *CAT &NEXT) +
                          TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
/*  Handle an exit request:                                          */
 REQ:        RTVDTAARA  DTAARA(*LDA (993 1)) RTNVAR(&FLAG)
 
             IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&NEXT) VALUE('CG8300    ')
                   CHGDTAARA  DTAARA(*LDA (813 10)) VALUE(&NEXT)
                   GOTO       CMDLBL(EXEC)
             ENDDO
 
             GOTO       CMDLBL(ENDCLPGM)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC8999 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC8999 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 
 ENDCLPGM:   CHGDTAARA  DTAARA(*LDA (805 28)) +
                          VALUE('                            ')
 
             RCLRSC     LVL(*CALLER)
 
             ENDPGM
