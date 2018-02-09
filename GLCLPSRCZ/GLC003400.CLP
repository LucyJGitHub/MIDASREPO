/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL ATU Reverse Selected Accounts')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC003400 - Midas GL ATU Reverse Selected Accounts          */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGL114  *CREATE    Date 04Jan10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL114 - Account Transfer Utility                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&REFERENCE &RTCD)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2010')
             DCL        VAR(&REFERENCE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN(2)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(GLSLACPD) SHARE(*YES)
             OPNQRYF    FILE((GLSLACPD)) OPTION(*ALL) +
                          QRYSLT('(SLRFNO *EQ "' *CAT &REFERENCE +
                          *CAT '" *AND SLSTAT *EQ "CP")')
 
             CALL       PGM(GL003400)
 
/** Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:       CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC003400 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             CLOF       OPNID(GLSLACPD)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(*ALL)
 
             ENDPGM
