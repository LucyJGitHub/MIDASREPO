/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Repayment schedule consolidated report')     */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                        */
/*                                                                   */
/*       LEC0865B - REPAYMENT SCHEDULE CONSOLIDATED REPORT           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CCB016  *Create    Date 28May08              */
/*      Midas Plus 1.4 Base -----------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   CCB016 - CoB Performance Enhancements                           */
/*            Split LEC0865 into two components, LEC0865A for report */
/*            by branch and LEC0865B for consolidated report.        */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
 
/* Retrieve system prefix and set program variables                                               */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/* Create copy of LEREPSPD in QTEMP and override to this file                                     */
 
             CRTDUPOBJ  OBJ(LEREPSPD) FROMLIB(&DPLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
             OVRDBF     FILE(LEREPSPD) TOFILE(QTEMP/LEREPSPD)
 
/* Call LE0865 for consolidated report                                                            */
 
             CHGJOB     SWS(X1XXXXXX)
             CALL       PGM(LE0865)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))
 
/* If there are errors output the details to the message queue                                    */
 
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
 
             ENDPGM
