/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Send message from DRSMM message file')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Common processing                          */
/*                                                                   */
/*           ZA0440 - SEND MESSAGE WITH DATA                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND NO. E25953    DATE   24SEP91                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      E25953 - MONITOR FOR AN ERROR IN SENDING THE MESSAGE         */
/*               TO AVOID PROGRAM CRASH IN PROGRAM CALLING ZA0440    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&@MSGID &@DAT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&@DAT) TYPE(*CHAR) LEN(45)
             DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(10)
/**/
/*/COPY WNCPYSRC,ZA0440001                                           */
             SNDPGMMSG  MSGID(&@MSGID) MSGF(DRSMM) MSGDTA(&@DAT)
/*/COPY WNCPYSRC,ZA0440003                                           */
             MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QCPFMSG) MSGDTA('Unable to send +
                          message' *BCAT &@MSGID))                    /*E25953*/
/*/COPY WNCPYSRC,ZA0440002                                           */
/**/
GOTO ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM: ENDPGM
