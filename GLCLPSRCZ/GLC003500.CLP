/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL ATU Delete Selected Accounts')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC003500 - Midas GL ATU Delete Selected Accounts           */
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
                      Misys International Banking Systems Ltd. 2010')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&REFERENCE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN(2)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** Deleted Selected Accounts */
 
             OVRDBF     FILE(GLSLACPD) SHARE(*YES)
             OPNQRYF    FILE((GLSLACPD)) OPTION(*ALL) +
                        QRYSLT('(SLRFNO *EQ "' *CAT &REFERENCE +
                        *CAT '" *AND SLPRCD *EQ " ")')
 
             CALL       PGM(GL003500)
 
/** Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC003500 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('Copyright Midas-Kapiti International Ltd.')
 
             CLOF       OPNID(GLSLACPD)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(*ALL)
 
             ENDPGM
