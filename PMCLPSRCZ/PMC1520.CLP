/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM DL Performance Analysis Update')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1520 - DL Performance Analysis Update                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 11AUG94              */
/*       PREV AMEND NO. 049421             DATE 18JAN93              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
                          Misys International Banking Systems Ltd. +
                          2001')
/*    FOR DBERROR MESSAGE                                    */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/*    PARAMETER DECLARATION                                  */
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
 
/*  RESET JOB SWITCHES  */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1520 - DL Performance Analysis +
                          Update') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* IF RUN TYPE PARAMETER IS '1'   */
             IF         COND(&RTYP = '1') THEN(DO)
/**/
/*********** OVRDBF     FILE(PMPTRAPP) MBR(DL1)                    */ /*S01486*/
             OVRDBF     FILE(PMPTRAPD) MBR(DL1)                       /*S01486*/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(DL1)                    */ /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(DL1)                       /*S01486*/
             ENDDO
/**/
             ELSE       CMD(DO)
 
/* IF RUN TYPE PARAMETER IS '5'   */
             IF         COND(&RTYP = '5') THEN(DO)
/**/
/*********** OVRDBF     FILE(PMPTRAPP) MBR(DL5)                    */ /*S01486*/
             OVRDBF     FILE(PMPTRAPD) MBR(DL5)                       /*S01486*/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(DL5)                    */ /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(DL5)                       /*S01486*/
             ENDDO
/**/
             ENDDO
/**/
/* CALL PM1520              */
             CALL       PGM(PM1520)
 
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
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
