/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Transfer Utility COB Component')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       ACCTFR - Midas GL Account Transfer Utility COB component    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG27224           Date 16Mar10              */
/*       Prev Amend No. CGL114  *CREATE    Date 04Jan10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27224 - New files SOBTRD and SOBDMVD to be added         */
/*       CGL114 - Account Transfer Utility                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRSEQ &PRLEV &PRENT)
 
             DCL        VAR(&PRSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
             DCL        VAR(&REQD) TYPE(*CHAR) LEN(1)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(ACCNTL0) SHARE(*NO)
             OVRDBF     FILE(APOSTL1) SHARE(*NO)
             RTVDTAARA  DTAARA(ACCTFR (1 1)) RTNVAR(&REQD)
 
             IF         COND(&REQD = 'Y') THEN(DO)
 
             CALL       PGM(ACCTFRUTIL)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/** Generate Transfer Criteria Audit */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(GL000573) PARM(&PRSEQ)
             ENDDO
 
             ENDDO
 
 
/** Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CPYF       FROMFILE(TRADSD) TOFILE(SOBTRD) +
                          MBROPT(*REPLACE)                                              /*BUG27224*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                        FILE(SOBTRD))                                                   /*BUG27224*/
             CPYF       FROMFILE(DPTMVD) TOFILE(SOBDMVD) +
                        MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                             /*BUG27224*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SOBDMVD))                                                /*BUG27224*/
                                                                                        /*BUG27224*/
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            ACCTFR ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
