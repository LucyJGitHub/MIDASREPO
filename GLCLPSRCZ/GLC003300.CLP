/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Transfer A/Cs to be Transfered')     */
/*********************************************************************/
/*                                                                   */
/*       Midas   -  General Ledger Module                            */
/*                                                                   */
/*       GLC003300 - Midas GL ATU Accounts to be Transferred         */
/*                                                                   */
/*       Called by: GL019000                                         */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD040242A *CREATE  Date 02Sep16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD040242A - Send error message when no account exists for   */
/*                   entered selection criteria.                     */
/*                 - Applied for MD040318A.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM &NOREC)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2016')
             DCL        VAR(&MEM)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&PARM)      TYPE(*CHAR) LEN(65)
             DCL        VAR(&REFERENCE) TYPE(*CHAR) LEN(010)
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN(002)
             DCL        VAR(&QRYSLT)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&NOREC)     TYPE(*CHAR) LEN(001)
             DCLF       FILE(GLACCSJ0)
 
/** Global monitor message **/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(ACCNTL0) MBR(*FIRST) SHARE(*NO)
/** Build Query Selection String **/
 
             CALL       PGM(GL003200) PARM(&REFERENCE &RTCD &QRYSLT &PARM)
 
/** Database error processing **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** Build Open Query File Selection **/
 
             OVRDBF     FILE(GLACCSJ0) SHARE(*YES)
             OPNQRYF    FILE((GLACCSJ0)) QRYSLT(&QRYSLT)
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(CHGVAR VAR(&NOREC) +
                          VALUE('Y'))
 
/** Database error processing **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC003300 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('(c) Finastra International Limited')
 
             CLOF       OPNID(GLACCSJ0)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(*ALL)
 
             ENDPGM
