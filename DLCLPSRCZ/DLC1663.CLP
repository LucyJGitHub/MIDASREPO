/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Create Settlement Detail Control File')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1663 - OIS Create Settlement Control File                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CIR007 - Overnight Index Swaps                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
 
/** Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/** Clear the OIS Settlement Control File */
             CLRPFM     FILE(DLOISSPD)
 
/** Build the OIS Settlement Control File */
             CALL DL1663
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                MSGDTA('Program DL1663 ended abnormally - see +
                log') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                GOTO CMDLBL(END)
             ENDDO
 
/** Successful Completion. */
             GOTO CMDLBL(END)
 
/** Error Encountered. */
 ABNOR:
             CHGJOB SWS(XXXXXX11)
             IF COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                MSGDTA('Program DLC1663 ended abnormally - see +
                job log') TOMSGQ(MOPERQ)
                MONMSG MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
