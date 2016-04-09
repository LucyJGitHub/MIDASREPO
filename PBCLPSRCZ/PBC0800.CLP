/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PB Setup Reconciliation file')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       CLP/PBC0800 -  Setup Reconcilation file                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CPB001  *CREATE    Date 16Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CPB001 - 'Private Banking' Module                           */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Reset job switches */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF0000) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
             CHGJOB     SWS(00000000)
 
/* Clear Reconciliation file */
 
             CLRPFM     FILE(PBRECOPD)
 
/* Create an indexe on lending transaction file to speed up processing*/
 
 
             OVRDBF     FILE(LOAN1) TOFILE(LOAMSDK) MBR(*FIRST) +
                          SHARE(*YES)
             MONMSG CPF0000
             CLOF LOAN1
             MONMSG CPF0000
             OPNQRYF    FILE((LOAMSDK)) KEYFLD((CNUM)) OPNID(LOAN1) +
                          SEQONLY(*NO)
             MONMSG CPF0000
 
             OVRDBF     FILE(LOAN2) TOFILE(CLOANCL) MBR(*FIRST) +
                          SHARE(*YES)
             MONMSG CPF0000
             CLOF LOAN2
             MONMSG CPF0000
             OPNQRYF    FILE((CLOANCL)) KEYFLD((CNUM)) OPNID(LOAN2) +
                          SEQONLY(*NO)
             MONMSG CPF0000
 
 
 
/* Call Extract program */
 
             CALL       PGM(PB0800)
             DLTOVR *ALL
             MONMSG CPF0000
             CLOF LOAN1
             MONMSG CPF0000
             CLOF LOAN2
             MONMSG CPF0000
 
/* Error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ERROR:
             SNDPGMMSG  MSG('PBC0800 abnormally terminated, see +
                          joblog for further details.') +
                          TOMSGQ(MOPERQ)
 
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
