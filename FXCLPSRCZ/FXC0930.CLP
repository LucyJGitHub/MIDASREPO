/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX I/c termination - check unconfirmed nets')   */
/*********************************************************************/
/*                                                                   */
/*      Midas - Dealing Module - Foreign Exchange.                   */
/*                                                                   */
/*      FXC0930 - Midas Input Cycle Termination                      */
/*                Check on outstanding Netting Deals                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*      Last Amend No. CSD013             Date 29Aug02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      Prev Amend No. CDL002             DATE 29APR97               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      CSD013 - Replace dtaara CBPROMPT values with SDSVALPD record */
/*               values.                                             */
/*      CDL002 - FX Netting                                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&#1NTRC) TYPE(*CHAR) LEN(1)
 /********** DCL        VAR(&CBPROMPT) TYPE(*CHAR) LEN(256) **/                           /*CSD013*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSD013*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*CSD013*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                  /*CSD013*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*CSD013*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
 
/*  Call FX0931 to remove outstandind links to incomplete nets  */
 
             CALL       PGM(FX0931) PARM(&RTRN)
 
             IF         COND(&RTRN *EQ ' ') THEN(DO)
             CALL       PGM(FX0930) PARM('T' &RTRN)
 
/*     Send message warning that unconfirmed net deals still exist     */
 
                IF         COND(&RTRN *EQ 'NETDEALS') THEN(DO)
                   SNDPGMMSG  MSGID(FXM5048) MSGF(DRSMM) +
                                TOPGMQ(*SAME) TOMSGQ(MOPERQ)
/***************** RTVDTAARA  DTAARA(CBPROMPT) RTNVAR(&CBPROMPT) **/                      /*CSD013*/
/***************** CHGVAR     VAR(&#1NTRC) VALUE(%SST(&CBPROMPT 3 1)) **/                 /*CSD013*/
/*     Get 'ReopenFXNets' system value from file SDSVALPD  */                             /*CSD013*/
                                                                                          /*CSD013*/
                   CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                                'ReopenFXNets' &SVAL1 &SVALK2 +
                                &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                                &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                                &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                                &SVALK0 &SVAL10)
                                                                                          /*CSD013*/
/*     If the 'ReopenFXNets' system value is missing then end abnormally */               /*CSD013*/
                                                                                          /*CSD013*/
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNOR))
                   ELSE
                              CHGVAR     VAR(&#1NTRC) VALUE(%SST(&SVAL1 1 1))             /*CSD013*/
                                                                                          /*CSD013*/
                   IF         COND(&#1NTRC *EQ 'N') +
                                THEN(GOTO CMDLBL(END))
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             IF         COND(&RTRN *NE ' ' *AND &RTRN *NE +
                          'NETDEALS') THEN(DO)
 
/*     General error                                                   */
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*  If chosen to continue with ICT, FXC0950 will remove references       */
/*  to net from deals                                               */
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
