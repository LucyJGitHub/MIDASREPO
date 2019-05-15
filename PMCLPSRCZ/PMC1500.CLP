/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Performance Cash Analysis Update')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1500 - Performance Cash Analysis Update                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01486             Date 11Aug94              */
/*                      049421             Date 18Jan93              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - WRITTEN FOR PORTFOLIO PERFORMANCE                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTYP)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*    FOR DBERROR MESSAGE                                    */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/*    PARAMETER DECLARATION                                  */
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
 
/*  RESET JOB SWITCHES  */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1500 - Performance Cash Analysis +
                          Update') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* IF RUN TYPE PARAMETER IS '1'   */
             IF         COND(&RTYP = '1') THEN(DO)
/**/
/*********** OVRDBF     FILE(PMPCAAPP) MBR(NEW1)                   */ /*S01486*/
             OVRDBF     FILE(PMPCAAPD) MBR(NEW1)                      /*S01486*/
/*********** CLRPFM     FILE(PMPCAAPP) MBR(NEW1)                   */ /*S01486*/
             CLRPFM     FILE(PMPCAAPD) MBR(NEW1)                      /*S01486*/
             ENDDO
/**/
             ELSE       CMD(DO)
 
/* IF RUN TYPE PARAMETER IS '5'   */
             IF         COND(&RTYP = '5') THEN(DO)
/**/
/*********** OVRDBF     FILE(ACPOPT) TOFILE(ACPOXPT)               */ /*S01486*/
             OVRDBF     FILE(PMACPOL0) TOFILE(PMACPOL2)               /*S01486*/
/*********** OVRDBF     FILE(PMPCAAPP) MBR(NEW5)                   */ /*S01486*/
             OVRDBF     FILE(PMPCAAPD) MBR(NEW5)                      /*S01486*/
/*********** CLRPFM     FILE(PMPCAAPP) MBR(NEW5)                   */ /*S01486*/
             CLRPFM     FILE(PMPCAAPD) MBR(NEW5)                      /*S01486*/
/**/
             ENDDO
             ENDDO
/**/
/* CALL PM1500              */
             CALL       PGM(PM1500)
 
             DLTOVR     FILE(*ALL)
 
/*     PROCESS ANY DATA BASE ERROR                           */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG)+*/ /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:     ENDPGM
