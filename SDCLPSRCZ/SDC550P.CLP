/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Base Rate Code Authorisation - Detail Rpt')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC550P - Base Rate Code Authorisation - Detail Rpt         */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD012             Date 15Oct02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD012 - Standing Data Authorisation                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &SEQ &LEVEL &ENTITY)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1) VALUE('R')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
 
             OVRDBF     FILE(SDBSRTL1) TOFILE(SDBRSHL1)
 
             CALL       PGM(&PGM) PARM(&RTNCD &MODE &SEQ &LEVEL +
                          &ENTITY)
 
             DLTOVR     FILE(*ALL)
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
             CHGVAR     VAR(&MSG) VALUE('Error on call to program' +
                          *BCAT &PGM)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             RTVJOBA    SWS(&SWS)
 
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(' JOB TERMINATED - DATABASE +
                          IN ERROR')
             SNDMSG     MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             ENDPGM
