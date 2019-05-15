/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL PRINT P/R REPORTS AT I/C TERM')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0402B - PRINT PAY/RECEIVE REPORTS AT I/C TERMINATION    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01117             Date 17/04/89             */
/*                      S01194             Date 17/04/89             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01194 - STANDING DATA CHANGES.                            */
/*                                                                  */
/********************************************************************/
/*********** PGM                                                      /*S01117*/
 
/* &RLEV IS A STANDARD RCF PARAMETER NOT USED BY THIS PROGRAM  */
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/*   CALL PAY/RECEIVE TELEXES REPORT PROGRAM                    */
             SNDPGMMSG  MSG('PAY/RECEIVE TELEXES REPORTS') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXXX10')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
/*********** CALL       PGM(DL0308)                                   /*S01117*/
             CALL       PGM(DL0308) PARM(&RSEQ &RENT)                 /*S01117*/
/*********** DLTOVR     FILE(*ALL)                                    /*S01194*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*   CALL INCOMPLETE INSTRUCTIONS PROGRAM                         */
                SNDPGMMSG  MSG('INCOMPLETE INSTRUCTIONS REPORT') +
                           TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                RTVJOBA    SWS(&SWS)
                CHGVAR     VAR(&SWS) VALUE('XXXXXX1X')
                CHGJOB     SWS(&SWS)
/************** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/************** CALL       PGM(DL0312)                                /*S01117*/
                CALL       PGM(DL0312) PARM(&RSEQ &RENT)              /*S01117*/
/************** DLTOVR     FILE(*ALL)                                 /*S01194*/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*   CALL BANKERS AUTHORISATIONS REPORT                           */
                   SNDPGMMSG  MSG('BANKERS AUTHORISATION REPORT') +
                              TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                   RTVJOBA    SWS(&SWS)
                   CHGVAR     VAR(&SWS) VALUE('XXXXXX1X')
                   CHGJOB     SWS(&SWS)
/***************** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)             /*S01194*/
/***************** CALL       PGM(DL0314)                             /*S01117*/
                   CALL       PGM(DL0314) PARM(&RSEQ &RENT)           /*S01117*/
/***************** DLTOVR     FILE(*ALL)                              /*S01194*/
                ENDDO
/**/
             ENDDO
/*   ERROR MESSAGE                                                */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
