/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Initialisation program for CFF006 feature')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Futures and Options Module                          */
/*                                                                   */
/*       FFC0006 - Midas FF Initialisation program for CFF006        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CFF006  *CREATE    Date 28Nov00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CFF006 - Fractional Ticks enhancement.                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'DPLIB')
 
             IF         COND(&PMODE *NE '3') THEN(DO)
 
               CPYF       FROMFILE(*LIBL/INTYPD) TOFILE(&LIB/XINTYPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CALL       PGM(FF0006)
 
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               CPYF       FROMFILE(&LIB/XINTYPD) TOFILE(INTYPD) +
                          MBROPT(*REPLACE)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
             SNDPGMMSG  MSG('Program FFC0006 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
 END:         DLTF       FILE(XINTYPD)
              MONMSG     MSGID(CPF2105)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
