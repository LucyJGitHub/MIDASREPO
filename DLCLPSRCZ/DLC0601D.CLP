/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Forward Rates Report')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0601D - FORWARD RATES LIST                              */
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
/*       Prev Amend No. S01117             Date 11/08/89             */
/*                      S01194             Date 11/08/89             */
/*            AMEND NO. E18                     DATE  31OCT89       */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01194 - NEW STANDING DATA FILES                           */
/*       E18    - REMOVE CALLING PARAMETERS                         */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
 
/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/
 
/*    FORWARD RATES REPORT                                    */
             SNDPGMMSG  MSG('FORWARD RATES REPORT') TOMSGQ(MRUNQ) +
                        MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01117*/
/*********** CALL       PGM(DL0225)                                   /*S01117*/
/************CALL       PGM(DL0225) PARM(&RSEQ)               /*E18     S01117*/
             CALL       PGM(DL0225)                           /*E18     S01117*/
/*********** DLTOVR     FILE(*ALL)                                    /*S01117*/
/*   ERROR MESSAGES                                           */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
