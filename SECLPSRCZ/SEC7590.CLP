/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE CO Generate Forward Events Cust/Book')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7590 - SE CO Gen Forward Events Cust/Book Allocation     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSE007  *CREATE    Date 23Mar98              */
/*       Prev Amend No.                    Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')
 
/* Send Information Program Message */
             SNDPGMMSG  MSG('SEC7590 - Generation of forward events +
                          Cust/Book') TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(TREVED)  SEQONLY(*YES 100)
             OVRDBF     FILE(TREVEA)  SEQONLY(*YES 100)
             OVRDBF     FILE(PCTEVD)  SEQONLY(*YES 100)
             OVRDBF     FILE(PCTEVA)  SEQONLY(*YES 100)
             OVRDBF     FILE(XTREVED) SEQONLY(*YES 100)
             OVRDBF     FILE(XTREVEA) SEQONLY(*YES 100)
             OVRDBF     FILE(XPCTEVD) SEQONLY(*YES 100)
             OVRDBF     FILE(XPCTEVA) SEQONLY(*YES 100)
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If it's a Restart, Restore Security Copies */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DLIB/XTREVED) TOFILE(TREVED) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM TREVED)
 
             CPYF       FROMFILE(&DLIB/XTREVEA) TOFILE(TREVEA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM TREVEA)
 
             CPYF       FROMFILE(&DLIB/XPCTEVD) TOFILE(PCTEVD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PCTEVD)
 
             CPYF       FROMFILE(&DLIB/XPCTEVA) TOFILE(PCTEVA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PCTEVA)
 
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(&DLIB/XTREVED)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XTREVEA)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XPCTEVD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XPCTEVA)
             MONMSG MSGID(CPF0000)
 
             CPYF FROMFILE(TREVED) TOFILE(&DLIB/XTREVED) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XTREVED))
 
             CPYF FROMFILE(TREVEA) TOFILE(&DLIB/XTREVEA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XTREVEA))
 
             CPYF FROMFILE(PCTEVD) TOFILE(&DLIB/XPCTEVD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XPCTEVD))
 
             CPYF FROMFILE(PCTEVA) TOFILE(&DLIB/XPCTEVA) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DLIB/XPCTEVA))
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
/* Delete overrides */
             DLTOVR     FILE(TREVED TREVEA PCTEVD PCTEVA XTREVED +
                          XTREVEA XPCTEVD XPCTEVA)
 
/* Call RPG name */
             CALL       PGM(SE7590)
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SE7590 ended abnormally for job ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SE7590 ended abnormally for job ' *CAT  +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Delete Security Copies */
             DLTF       FILE(&DLIB/XTREVED)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XTREVEA)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XPCTEVD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XPCTEVA)
             MONMSG MSGID(CPF0000)
 
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
