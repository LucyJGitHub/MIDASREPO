/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Work station timeout processor')            */
/*********************************************************************/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E21879             Date 09Jan92              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes                          */
/*       E21879 - CREATION PARAMETER USRPRF CHANGED FROM *USER TO   */
/*                *OWNER                                            */
/*********************************************************************/
PGM (&PGMDS)
DCL &PGMDS *CHAR 429 /* RPG PROGRAM DATA STRUCTURE. */
DCL &REPLY    *CHAR 1    /* MESSAGE REPLY*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
DCLF       FILE(Y2WSTOC#)
             RTVJOBA    JOB(&JOB) USER(&USER)
             RTVDTAARA  DTAARA(Y2WSTOA) RTNVAR(&Y2WSTOA)
             SNDF       RCDFMT(#TIMEOUT)
/**********  SNDUSRMSG  MSG('Work station '***&JOB**> 'has +
                          timed-out. (C,I)') VALUES(C I) +
                          TOMSGQ(Y2WSTOM) MSGRPY(&REPLY)                            */  /*BG18886*/
             SNDUSRMSG  MSG('Work station ' *CAT &JOB *BCAT 'has +
                          timed-out. (C,I)') VALUES(C I) +
                          TOMSGQ(Y2WSTOM) MSGRPY(&REPLY)                                /*BG18886*/
             IF         COND(&REPLY = C) THEN(SIGNOFF LOG(*LIST))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
