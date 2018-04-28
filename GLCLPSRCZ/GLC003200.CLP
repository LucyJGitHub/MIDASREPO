/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Transfer A/Cs to be Transfered')     */
/*********************************************************************/
/*                                                                   */
/*       Midas   -  General Ledger Module                            */
/*                                                                   */
/*       GLC003200 - Midas GL ATU Accounts to be Transferred         */
/*                                                                   */
/*       Called by: GL003000                                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGL114  *CREATE    Date 04Jan10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL114 - Account Transfer Utility                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&REFERENCE &RTCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
 
             DCL        VAR(&MEM)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&QRYSLT)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&REFERENCE) TYPE(*CHAR) LEN(010)
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN(002)
 
/** Global monitor message **/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** Build Query Selection String **/
 
             CALL       PGM(GL003200) PARM(&REFERENCE &RTCD &QRYSLT)
 
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
 
             CALL       PGM(GL003300) PARM(&REFERENCE &RTCD)
 
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
                          GLC003200 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('(c) Misys International Banking Systems Ltd')
 
             CLOF       OPNID(GLACCSJ0)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(*ALL)
 
             ENDPGM
