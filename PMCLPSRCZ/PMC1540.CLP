/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM FF Performance Analysis Update')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1540 - FF Performance Analysis Update                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 109563             DATE 01NOV96              */
/*       PREV AMEND NO. CPM003             DATE 26FEB96              */
/*                      049421             DATE 18JAN93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       109563 - Exit program if Bank Portfolio switched on.        */
/*       CPM003 - Portfolio Management Upgrade to Release 10.        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
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
             DCL        VAR(&FCPORS) TYPE(*CHAR) LEN(1)               /*109563*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*109563*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*109563*/
             DCL        VAR(&SDPORT) TYPE(*CHAR) LEN(200)             /*109563*/
 
/*  RESET JOB SWITCHES  */
             CHGJOB     SWS(00000000)
/**/                                                                  /*109563*/
/*  Check if Bank Portfolio is supported. */                          /*109563*/
/**/                                                                  /*109563*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*109563*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*109563*/
/**/                                                                  /*109563*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &SDPORT)       /*109563*/
/**/                                                                  /*109563*/
/*  Database error handling.                                          /*109563*/
/**/                                                                  /*109563*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ERROR))                              /*109563*/
             ELSE       CMD(CHGVAR VAR(&FCPORS) VALUE(%SST(&SDPORT +
                          112 1)))                                    /*109563*/
/**/                                                                  /*109563*/
             IF         COND(&FCPORS *EQ 'B') THEN(GOTO +
                          CMDLBL(ENDPGM))                             /*109563*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1540 - FF Performance Analysis +
                          Update') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* IF RUN TYPE PARAMETER IS '1'   */
             IF         COND(&RTYP = '1') THEN(DO)
/**/
/************OVRDBF     FILE(PMPTRAPP) MBR(FF1)                    */ /*CPM003*/
/************CLRPFM     FILE(PMPTRAPP) MBR(FF1)                    */ /*CPM003*/
             OVRDBF     FILE(PMPTRAPD) MBR(FF1)                       /*CPM003*/
             CLRPFM     FILE(PMPTRAPD) MBR(FF1)                       /*CPM003*/
             ENDDO
/**/
             ELSE       CMD(DO)
 
/* IF RUN TYPE PARAMETER IS '5'   */
             IF         COND(&RTYP = '5') THEN(DO)
/**/
/************OVRDBF     FILE(PMPTRAPP) MBR(FF5)                    */ /*CPM003*/
/************CLRPFM     FILE(PMPTRAPP) MBR(FF5)                    */ /*CPM003*/
             OVRDBF     FILE(PMPTRAPD) MBR(FF5)                       /*CPM003*/
             CLRPFM     FILE(PMPTRAPD) MBR(FF5)                       /*CPM003*/
             ENDDO
/**/
             ENDDO
/**/
/* CALL PM1540              */
             CALL       PGM(PM1540)
 
             DLTOVR     FILE(*ALL)
 
/*     PROCESS ANY DATA BASE ERROR                           */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 ERROR:                                                               /*109563*/
             CHGJOB SWS(XXXXXX11)                                     /*109563*/
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG)+*/ /*CPM003*/
/************             TOMSGQ(MOPERQ MRUNQ)                     */ /*CPM003*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM003*/
             ENDDO
 
/*ENDPGM:****ENDPGM                                                */ /*CPM003*/
 ENDPGM:                                                              /*CPM003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*CPM003*/
