/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ZA Concatenate variables to message control')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Common Processing Module                            */
/*                                                                   */
/*       ZAC1310  - Sub-program to Format Message Control            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 206018             Date 04Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 128437  *CREATE    Date 07Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       206018 - OVRMSGF fails as &GBMSG becomes '  SDUSRMSG'.      */
/*                Override is already made in calling program.       */
/*       128437 - Allows selection of a specified message file.      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &MSGDTA0 &MSGDTA1 &MSGDTA2 +
                          &MSGDTA3 &MSGDTA4 &MSGDTA5 &MSGDTA6 +
                          &MSGDTA7 &MSGDTA8 &MSGDTA9 &RESULT &GBMSG)
 
/*/COPY WNCPYSRC,ZAC1310INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Declare input variables */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA0) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA1) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA2) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA3) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA4) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA5) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA6) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA7) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA8) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA9) TYPE(*CHAR) LEN(40)
             DCL        VAR(&RESULT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&GBMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AORTCD) TYPE(*DEC) LEN(7)
             DCL        VAR(&AOOPTN) TYPE(*CHAR) LEN(7) VALUE(*KEY)
             DCL        VAR(&AOUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(211)
 
/**********  RTVJOBA    USER(&AOUSER)                                                  */ /*206018*/
/**********                                                                            */ /*206018*/
/**********  CALL       PGM(AOUSERR0) PARM(&AORTCD &AOOPTN &AOUSER +                   */ /*206018*/
/**********               &AOFMT)                                                      */ /*206018*/
/**********                                                                            */ /*206018*/
/***Selects*language*for*message*file**/                                                  /*206018*/
/**********  CHGVAR     VAR(&GBMSG) VALUE((%SST(&AOFMT 163 2)) *CAT +                  */ /*206018*/
/**********               SDUSRMSG)                                                    */ /*206018*/
/**********                                                                            */ /*206018*/
/**********  OVRMSGF    MSGF(QUSERMSG) TOMSGF(&GBMSG)                                  */ /*206018*/
 
/*/COPY WNCPYSRC,ZAC1310MPS                                          */
 
             CALL       PGM(ZA1310) PARM(&MSGID &MSGDTA0 &MSGDTA1 +
                          &MSGDTA2 &MSGDTA3 &MSGDTA4 &MSGDTA5 +
                          &MSGDTA6 &MSGDTA7 &MSGDTA8 &MSGDTA9 +
                          &RESULT)
 
/*/COPY WNCPYSRC,ZAC1310MPE                                          */
 
             GOTO       CMDLBL(END)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,ZAC1310END                                          */
 
             ENDPGM
