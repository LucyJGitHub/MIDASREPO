/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL PROJECTED NOSTRO BALANCES ENQUIRY')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC0303 - PROJECTED NOSTRO BALANCE ENQUIRY                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01194                  DATE  01/08/89      */
/*                      E14948                  DATE  04/11/88      */
/*                      S01179                  DATE  10/09/88      */
/*                      S01127                  DATE  18/08/87      */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01194  -  NEW STANDING DATA                               */
/*       E14948  -  SWITCHES U7 & U8 WERE NOT BEING SET OFF BEFORE  */
/*                  RPG PROGRAMS WERE CALLED                        */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01127  -  FUTURES AND OPTIONS INCORPORATION               */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/**/
/*           DCLDTAARA  DTAARA(MMOD)                             S01127 S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/*           RCVDTAARA  DTAARA(MMOD)                             S01127 S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
             IF         COND(%SUBSTRING(&MMOD 50 1) = 'Y') THEN(CHGJOB +
                        SWS('1XXXXXXX'))                             /*S01127*/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                   /*S01194*/
                                                        /* E14948 */
             CHGJOB     SWS(XXXXXX00)
                                                        /* E14948 */
             CALL       PGM(DL0140)
/************DLTOVR     FILE(TABLE)                                  /*S01194*/
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(&JOB)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
