/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Change spool file user data')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Report Control Facility                         */
/*                                                                   */
/*       FCC0320 - Change User Data of a Spool File.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. S01408             Date 07AUG95              */
/*       Prev Amend No. S01530             Date 16JAN95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Hooks moved to WNCPYSRC from FCCPYSRC:             */
/*                - FCC0320INT                                       */
/*                - FCC0320MPS                                       */
/*                - FCC0320MPE                                       */
/*                - FCC0320ERR                                       */
/*                - FCC0320END                                       */
/*       S01530 - New program introduced for this change:            */
/*                - Changes the user data attribute of a specified   */
/*                  spoolfile to a given value.                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FLNAM &BNAM &FLERR)
 
/*/COPY WNCPYSRC,FCC0320INT                                          */
 
             DCL        VAR(&FLNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,FCC0320MPS                                          */
 
/* Change spool file attributes using input parameters */
 
             CHGSPLFA   FILE(&FLNAM) SPLNBR(*LAST) USRDTA(&BNAM)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,FCC0320MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,FCC0320ERR                                          */
 
             CHGVAR     VAR(&FLERR) VALUE('Y')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             SNDPGMMSG  MSG('FCC0320 Change Attributes of a Spool +
                          File terminated abnormally.  See previous +
                          messages for further information.') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,FCC0320END                                          */
 
             ENDPGM
