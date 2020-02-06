/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL P/R TELEXES EXTRACT')                        */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0604A - PAY/RECEIVE TELEXES EXTRACT                     */
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
/*       Prev Amend No. S01194             Date 29/09/89             */
/*       LAST AMEND NO. S01194                  DATE  29/09/89      */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - RELEASE 10 NEW STANDING DATA                      */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
             CLRPFM     FILE(PREX1HH)
             CLRPFM     FILE(PREX1PH)
             CLRPFM     FILE(PREX1ZZ)
             CLRPFM     FILE(PREX2HH)
             CLRPFM     FILE(PREX2PH)
             CLRPFM     FILE(PREX2ZZ)
             CLRPFM     FILE(PREX3HH)
             CLRPFM     FILE(PREX3PH)
             CLRPFM     FILE(PREX3ZZ)
             CLRPFM     FILE(PREX4HH)
             CLRPFM     FILE(PREX4PH)
             CLRPFM     FILE(PREX4ZZ)
/*   PAY/RECEIVE EXTRACT FILES CREATION                      */
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXX100')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
             OVRDBF     FILE(DEALS) TOFILE(DLUPD)
             OVRDBF     FILE(DEAMS) TOFILE(DAUPD)
             OVRDBF     FILE(TRANS) TOFILE(DLIND)
             CALL       PGM(DL0304)
             DLTOVR     FILE(*ALL)
/**/
             IF       COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR')  +
                        TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
