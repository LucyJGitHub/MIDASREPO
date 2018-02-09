/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS app days correction for all deals')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1643 - OIS Applicable Days Correction for all Deals      */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 214440  *CREATE    Date 30Jan03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       214440 - New function to Amend Applicable Days for all Deal */
/*                (OIS)                                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Main Processing */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Override files */
 
             OVRDBF     FILE(DLDOISPD) SHARE(*NO)
             OVRDBF     FILE(DEALS) SHARE(*NO)
 
/* Call program */
 
             CALL       PGM(DL1643)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DL1643 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
 END:
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
