/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Final JRN proc. for COB')                    */
/********************************************************************/
/*                                                                  */
/*   Midas  -  Futures and Options Module                   */
/*                                                                  */
/*   FFCJRN4  -  FINAL JOURNAL PROCESSING FOR CLOSE OF BUSINESS     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  079666             Date 01Dec94                 */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  BG18886 - Amend non-standard codes.                             */
/*  CCB009  -  Journal files throughout close of business           */
/*  079666  -  Add global monitor message processing                */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&LIB)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
                                                                      /*079666*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/*       SET UP NAME OF LIBRARY CONTAINING JOURNAL & RECEIVER       */
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**********  CHGVAR     VAR(&LIB) VALUE(%SST(&SDSTAT 6 2)****'JLIB')    */ /*BG18886*/
             CHGVAR     VAR(&LIB) VALUE(%SST(&SDSTAT 6 2) *CAT 'JLIB')     /*BG18886*/
/**/
/*       DELETE JOURNAL                                             */
/**/
             DLTJRN     JRN(&LIB/FFJRN)
             MONMSG     MSGID(CPF2105)
/**/
/*       DELETE JOURNAL RECEIVER                                    */
/**/
/* CANNOT MONITOR FOR CPA MSGS. BUT MUST ENSURE JOB TAKES DEFAULT   */
/* REPLY FOR MESSAGE CPA7025, (DELETE ISSUED WITHOUT FULL SAVE.)    */
/**/
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(&LIB/FFJRNRCV)
             CHGJOB     INQMSGRPY(*RQD)
/**/
             ENDDO                                                    /*CCB009*/
             GOTO       CMDLBL(END)                                   /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFCJRN4 - Final journal processing +
                          for COB terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
END:                                                                  /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
