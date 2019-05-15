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
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD040242A          Date 02Sep16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGL114  *CREATE    Date 04Jan10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD040242A - Send error message when no account exists for   */
/*                   entered selection criteria.                     */
/*                 - Applied for MD040318A.                          */
/*       CGL114 - Account Transfer Utility                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&REFERENCE &RTCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2010')
 
             DCL        VAR(&MEM)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&QRYSLT)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&REFERENCE) TYPE(*CHAR) LEN(010)
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN(002)
             DCL        VAR(&NOREC)     TYPE(*CHAR) LEN(001)                           /*MD040242A*/
 
/** Global monitor message **/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** Build Query Selection String **/
 
/*           CALL       PGM(GL003200) PARM(&REFERENCE &RTCD &QRYSLT) */                /*MD040242A*/
             CALL       PGM(GL003200) PARM(&REFERENCE &RTCD &QRYSLT &NOREC)            /*MD040242A*/
 
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
                     VALUE('(c) Finastra International Limited')
 
             CLOF       OPNID(GLACCSJ0)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(*ALL)
 
             ENDPGM
