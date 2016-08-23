/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Transfer Utility COB Component 1')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC003600 - Midas GL Account Transfer Utility               */
/*                   Conversion Utility - Control 1                  */
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
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
             DCL        VAR(&ENDCMTCTL) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&DPLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&STARTSEQ) TYPE(*DEC) LEN(10)
             DCL        VAR(&STARTSEQA) TYPE(*CHAR) LEN(10)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area +
                          Equivalent') AUT(*USE))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDMSG     MSG('GLC003600 - Account Transfer Conversion +
                          Utility-Phase 1 started') TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&ENDCMTCTL) +
                          VALUE('N'))
/** Retrieve the system prefix xx */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DPLIB)
             CHGVAR     VAR(&DPLIB) VALUE(&DPLIB *TCAT 'DPLIB')
 
/** Set Conversion Utility Data Area - Active */
 
             CHGDTAARA  DTAARA(GLDA10) VALUE('A')
             MONMSG     MSGID(CPF0000) EXEC(DO)
                SNDPGMMSG  MSG('ERROR:When CHGDTAARA of GLDA10') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(TAG9999)
             ENDDO
 
/** Check Journal Sequence Data Area Exists */
 
             CHKOBJ     OBJ(&DPLIB/ACCTFRJRNE) OBJTYPE(*DTAARA)
 
/** If not, create it. */
 
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(&DPLIB/ACCTFRJRNE) TYPE(*CHAR) +
                          LEN(20))
 
/** Retrieve the latest journal sequence number. */
 
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) +
                          RTNSEQNBR(&STARTSEQ)
 
             CHGVAR     VAR(&STARTSEQ) VALUE(&STARTSEQ + 1)
             CHGVAR     VAR(&STARTSEQA) VALUE(&STARTSEQ)
             CHGDTAARA  DTAARA(ACCTFRJRNE (1 10)) VALUE(&STARTSEQA)
 
             CLRPFM     FILE(GLAUTFPD)
 
/** Call Conversion Utility */
             CALL       PGM(GL003600)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGDTAARA  DTAARA(GLDA10) VALUE('F')
                GOTO       CMDLBL(TAG9999)
             ENDDO
 
/**********  CPYF       FROMFILE(TRADSD) TOFILE(SOBTRD) + */                            /*BUG27224*/
/**********             MBROPT(*REPLACE) */                                             /*BUG27224*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*BUG27224*/
/**********               FILE(SOBTRD)) */                                              /*BUG27224*/
/**********  CPYF       FROMFILE(DPTMVD) TOFILE(SOBDMVD) + */                           /*BUG27224*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP) */                        /*BUG27224*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*BUG27224*/
/**********               FILE(SOBDMVD)) */                                             /*BUG27224*/
 
             GOTO       CMDLBL(TAG0900)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC003600 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(GLDA10) VALUE('F')
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO       CMDLBL(TAG9999)
 TAG0900:    CHGDTAARA  DTAARA(GLDA10) VALUE('C')
 TAG9999:
             CHGVAR     VAR(&CPYFLD) VALUE(&CPYFLD)
             DLTOVR     FILE(*ALL)
 
             COMMIT
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&ENDCMTCTL = 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
