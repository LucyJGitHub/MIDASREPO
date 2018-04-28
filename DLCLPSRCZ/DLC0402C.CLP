/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL UPDATE P/R INDS & DTRIX HDR')                */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0402C - UPDATE PAY/RECEIVE INDICATORS & DTRIX HEADER    */
/*                                          AT I/C TERMINATION      */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                  DATE  04/09/89      */
/*       PREV AMEND NO. S01194                  DATE  04/09/89      */
/*------------------------------------------------------------------*/
/*       S01117 - MULTIBRANCHING                                    */
/*       S01194 - NEW STANDING DATA FILES                           */
/********************************************************************/
/* &RLEV IS A STANDARD RCF PARAMETER NOT USED BY THIS PROGRAM  */
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*    UPDATE PAY/RECEIVE INDICATORS                              */
             SNDPGMMSG  MSG('UPDATE PAY/RECEIVE INDICATORS') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXXXX0')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01117*/
             CALL       PGM(DL0330)
/*********** DLTOVR     FILE(*ALL)                                    /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                CLRPFM     FILE(PREX1HH)
                CLRPFM     FILE(PREX1PH)
                CLRPFM     FILE(PREX1ZZ)
                CLRPFM     FILE(PREX2HH)
                CLRPFM     FILE(PREX2PH)
                CLRPFM     FILE(PREX2ZZ)
                CLRPFM     FILE(PREX3HH)
                CLRPFM     FILE(PREX3PH)
                CLRPFM     FILE(PREX3ZZ)
             ENDDO
             ELSE       DO
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
