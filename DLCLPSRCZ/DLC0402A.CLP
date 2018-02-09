/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL I/C TERM PAY/RECEIVE TELEXES')               */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0402A - CREATE PAY/RECEIVE REPORTING FILES AT I/C       */
/*                                               TERMINATION        */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E19344             Date 24Jul90              */
/*                      S01194             Date 04/09/89             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                 */
/*       MD046248 - Finastra Rebranding                              */
/*       E19344 - DATABASE ERROR IN DL0300 SHOULD HALT PROGRAM     */
/*       S01194 - NEW STANDING DATA FILES                           */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
             CLRPFM     FILE(DTRIEHH)
             CLRPFM     FILE(DTRIEPH)
             CLRPFM     FILE(DTRIEZZ)
             CLRPFM     FILE(PREX1HH)
             CLRPFM     FILE(PREX1PH)
             CLRPFM     FILE(PREX1ZZ)
             CLRPFM     FILE(PREX2HH)
             CLRPFM     FILE(PREX2PH)
             CLRPFM     FILE(PREX2ZZ)
             CLRPFM     FILE(PREX3HH)
             CLRPFM     FILE(PREX3PH)
             CLRPFM     FILE(PREX3ZZ)
/*   OUTSTANDING DEALS TRANSACTIONS INDEX EXTRACT               */
             SNDPGMMSG  MSG('CREATE PAY/RECEIVE EXTRACT FILES') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXXX0X')
             CHGJOB     SWS(&SWS)
/************OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
             CALL       PGM(DL0300)
/************DLTOVR     FILE(*ALL)                                    /*S01194*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)     /*E19344*/
/*   CREATE PAY/RECEIVE EXTRACT FILE                             */
             SNDPGMMSG  MSG('PAY/RECEIVE EXTRACT FILES CREATION') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXXX10')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
             OVRDBF     FILE(TRANS) TOFILE(DTRIN)
             CALL       PGM(DL0304)
             DLTOVR     FILE(*ALL)
             ENDDO                                           /*E19344*/
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                CLRPFM     FILE(DTRIEHH)
                CLRPFM     FILE(DTRIEPH)
                CLRPFM     FILE(DTRIEZZ)
             ENDDO
/*   ERROR MESSAGES                                           */
             ELSE       DO
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
