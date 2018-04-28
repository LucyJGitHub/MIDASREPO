/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. Xnnnnn  *CREATE    Date ddmmmyy              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes                          */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Obtain a user RTV message')                 */
/*********************************************************************/
/*T: YAPPOBJ Obtain a user RTV message.  (PRE-8.3 VERSION)  */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON/2 SHIPPED SUBROUTINE                           */
/*H: PROGRAMMER : P.WILSON                                             */
/*       (c) Misys International Banking Systems Ltd. 2001           */
 
/*H:  SYNOPSIS:                                                              */
/*H:  Retrieve the first level text of the supplied message id using         */
/*H:  supplied message insertion data.                                       */
/*H:  *..................................................................... */
/*H:  INTERFACE DETAILS ;                                                    */
/*H:  *..................................................................... */
/*H:  *  Execute a user EXC message.                                         */
/*H: C                     CALL 'Y2RVMSC'                  SEND MESSAGE      */
/*H: C                     PARM           W0RTN   7        O:Return code     */
/*H: C                     PARM           ZAMSID  7        I:Message Id      */
/*H: C                     PARM           ZAMSDA132        I:Message data    */
/*H: C                     PARM           ZAMSTX132        O:Message text    */
/*H:  *..................................................................... */
/*********************************************************************/
PGM   (&W0RTN &ZAMSID &ZAMSDA &ZAMSTX)
 
DCL &W0RTN    *CHAR  7  /* Return code.        */
DCL &ZAMSID   *CHAR  7  /* MESSAGE ID. XXXNNNN.*/
DCL &ZAMSDA   *CHAR 132 /* MESSAGE SUBSTITION DATA. */
DCL &ZAMSTX   *CHAR 132 /* MESSAGE TEXT. */
 
DCL &MSGID    *CHAR  7  /* MESSAGE ID. XXXNNNN.*/
DCL &MSGDTA   *CHAR 132 /* MESSAGE SUBSTITION DATA. */
DCL &MSG      *CHAR 132 /* IMPROMPTU MESSAGE. */
DCL &KEYVAR  *CHAR   4  /* MESSAGE KEY */
DCL &RTNTYPE *CHAR   2  /* MESSAGE TYPE CODE        */
DCL &MSGTYPE *CHAR   8  /* MESSAGE TYPE CODE        */
DCL &MSGF     *CHAR 10  /* MESSAGE FILE.*/
DCL &MSGFLIB  *CHAR 10  /* MESSAGE FILE.*/
DCL &SECLVL   *CHAR 1425   /* Second level message text */
DCL &SECLVLLEN *DEC (5 0)  /* Second level message text length */
DCL &CMDLEN    *DEC (15 5) /* Second level message text length */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*H: 1. Global error monitor.*/
             MONMSG (CPF0000) EXEC(GOTO ERROR)
 
/*H: 2. Determine message file.*/
               IF (%SST(&ZAMSID 1 3) = Y2U) CHGVAR &MSGF Y2USRMSG
          ELSE IF (%SST(&ZAMSID 1 3) = USR) CHGVAR &MSGF QUSRMSG
/********** ELSE CHGVAR &MSGF  (%SST(&ZAMSID 1 2)**< USRMSG)                         */ /*BG18886*/
          ELSE CHGVAR &MSGF  (%SST(&ZAMSID 1 2) *TCAT USRMSG)                           /*BG18886*/
/*H: 3. Retrieve 2nd level message text.*/
             RTVMSG     MSGID(&ZAMSID) MSGF(&MSGF) MSGDTA(&ZAMSDA) +
                          MSG(&ZAMSTX)
             GOTO ENDPGM
ERROR:
/*H: 5. Copy message queue to *PRV */
 NXTMSG:     RCVMSG     MSGTYPE(*NEXT) MSGKEY(*TOP) KEYVAR(&KEYVAR) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          RTNTYPE(&RTNTYPE) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             MONMSG CPF0000
             IF (&KEYVAR *EQ '    ') GOTO ENDPGM
             /* If escape message present then set return code. */
             IF (&RTNTYPE = '15') CHGVAR &W0RTN &MSGID /* ESCAPE */
             IF (&MSGID = ' ') DO  /* IMPROMPTU MESSAGES.*/
                SNDPGMMSG  MSG(&MSG)
                MONMSG CPF0000 EXEC(GOTO ENDPGM)
                GOTO NXTMSG
             ENDDO
                                  CHGVAR &MSGTYPE '*INFO'
             IF (&RTNTYPE = '01') CHGVAR &MSGTYPE '*COMP'
             IF (&RTNTYPE = '02') CHGVAR &MSGTYPE '*DIAG'
             /* Convert escape messages to *DIAG */
             IF (&RTNTYPE = '15') CHGVAR &MSGTYPE '*DIAG'
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
MSGDTA(&MSGDTA) MSGTYPE(&MSGTYPE)
             MONMSG CPF0000 EXEC(GOTO ENDPGM)
             GOTO NXTMSG
ENDPGM:      RCLRSC
             RMVMSG CLEAR(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
