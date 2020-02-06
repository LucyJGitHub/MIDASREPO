/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS input cycle rate fixing')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1642 - OIS Deal Rate Fixing                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CIR007 - Overnight Index Swaps                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARMS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RUNRAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS)  TYPE(*CHAR)  LEN(8)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(3)
 
/* */
/* MONITOR FOR ALL ERRORS */
/* */
             MONMSG     MSGID(CPA0000 MCH0000 RPG0000 CPF0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Derive Required Currency Code */
/**/
             CHGVAR     VAR(&CURR) VALUE(%SST(&PARMS 1 3))
/**/
             CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('Y')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 
             OVRDBF     FILE(DLDOISL1) SHARE(*NO)
             OVRDBF     FILE(DLOISSL4) SHARE(*NO)
 
             CALL       PGM(DL1642) PARM(&RSEQ &RLEV &RENT &CURR)
 
             RTVJOBA    JOB(&WID) SWS(&SWS)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('N')
                GOTO CMDLBL(END)
             ENDDO
/**/
 ABNOR:      SNDPGMMSG  MSG('OIS Rate Fixing Ended Abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Reset OIS Control data area to indicate no longer active          */
/**/
             CHGDTAARA  DTAARA(DLOISDTA (1 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             ENDPGM
