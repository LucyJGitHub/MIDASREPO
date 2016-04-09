/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Run level file set up program')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     CLOSE OF BUSINESS PROCESSING UTILITIES            */
/*                                                                   */
/*       CHKLVLCL   RUN FILE LEVEL REPORT PROGRAMS                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01417             DATE 19/07/93             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01417 - NEW FIELD ADDED TO CHKDPRPD                        */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(CHKCOBDF)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
/* RESET SWITCHES U7 & U8 */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* SET SCREEN CONDITIONING INDICATOR ON AND DISPLAY SCREEN */
/**/
             CHGVAR     VAR(&IN50) VALUE('1')
             SNDRCVF
/**/
/* CLEAR THE LEVEL FILE AND COPY FROM THE COB FILES */
/* THE REQUESTED LIBRARY INTO THE CHECKING FILES */
/**/
             CLRPFM     FILE(CHKLVLPD)
             CPYF       FROMFILE(&LIB/CBCMPNPD) TOFILE(CHKCMPPD) +
                          MBROPT(*REPLACE)
             CPYF       FROMFILE(&LIB/CBDPRLPD) TOFILE(CHKDPRPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)               /*S01417*/
/************             MBROPT(*REPLACE)                         */ /*S01417*/
/**/
/** CALL THE PROGRAM TO SET THE COMPONENT LEVEL FILE        **/
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('COB +
                          Component Level file being generated') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CALL       PGM(CHKLVLSET)
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
/** CALL THE REPORT PROGRAM        **/
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('COB +
                          Component Level Report being produced') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CALL       PGM(CHKLVLRPT)
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             GOTO       CMDLBL(END)
/**/
ABNOR:                  SNDPGMMSG  MSG('PRODUCTION OF COMPONENT +
                        LEVEL REPORT TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOPGMQ(*EXT)
                        MONMSG     MSGID(CPF0000 MCH0000)
/**/
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
