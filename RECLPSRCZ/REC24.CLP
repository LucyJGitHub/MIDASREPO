/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Test for Hierarchies Validity')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC24 - Test for Hierarchies Validity                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 214254  *CREATE    DATE 21Feb03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       214254 - Cash Management falls over in COB (CRE008 FIX)     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(RECMVEPD)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO  +
                          CMDLBL(ABNOR))
 
             CHGJOB SWS(00000000)
             CALL       PGM(REC100410) PARM('Y')
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC24 ended abnormally - check file RECMVEPD') +
                          TOMSGQ(MOPERQ)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
