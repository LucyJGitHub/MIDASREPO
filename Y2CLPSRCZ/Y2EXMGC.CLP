/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. XNNNNN  *CREATE    Date DDMmmYY              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 EXCMSG (revised version)')                  */
/*********************************************************************/
/*T: YAPPOBJ EXCMSG - (Revised version)   */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON1 SUBROUTINE                                    */
/*H: PROGRAMMER : P.WILSON                                             */
/*       (c) Finastra International Limited 2001                     */
/*       (c) Finastra International Limited 2001                     */
 
/*H:  SYNOPSIS:                                                              */
/*H:  Retrieve the second level text of the supplied message id using        */
/*H:  supplied message insertion data.                                       */
/*H:  If the message is successfully retrieved then then text is             */
/*H:  executed as a CPF command.                                             */
/*H:                                                                   ..... */
/*H:  INTERFACE DETAILS ;                                                    */
/*H:  *..................................................................... */
/*H:  *  Execute a user EXC message.                                         */
/*H: C                     CALL 'Y2EXMGC'                  SEND MESSAGE      */
/*H: C                     PARM           W0RTN   7        O:Return code     */
/*H: C                     PARM           ZAMSID  7        I:Message Id      */
/*H: C                     PARM           ZAMSGF 10        I:MESSAGE FILE    */
/*H: C                     PARM           ZAMSDA132        I:Message data    */
/*H:  *..................................................................... */
/********************************************************************/
PGM   (&W0RTN &ZAMSID &ZAMSGF &ZAMSDA)
 
DCL &W0RTN    *CHAR  7  /* Return code.        */
DCL &ZAMSID   *CHAR  7  /* MESSAGE ID. XXXNNNN.*/
DCL &ZAMSDA   *CHAR 132 /* MESSAGE SUBSTITION DATA. */
DCL &ZAMSGF   *CHAR 10 /* MESSAGE FILE        */
 
DCL &MSGID    *CHAR  7  /* MESSAGE ID. XXXNNNN.*/
DCL &MSGDTA   *CHAR 132 /* MESSAGE SUBSTITION DATA. */
DCL &MSG      *CHAR 132 /* IMPROMPTU MESSAGE. */
DCL &MSGF    *CHAR 10 /* Message file.*/
DCL &MSGFLIB *CHAR 10 /* Message file library..*/
DCL &KEYVAR  *CHAR   4  /* MESSAGE KEY */
DCL &RTNTYPE *CHAR   2  /* MESSAGE TYPE CODE        */
DCL &MSGTYPE *CHAR   8  /* MESSAGE TYPE CODE        */
DCL &SECLVL   *CHAR 1425   /* Second level message text */
DCL &SECLVLLEN *DEC (5 0)  /* Second level message text length */
DCL &CMDLEN    *DEC (15 5) /* Second level message text length */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*..............................................................*/
/*H: 1. Global error monitor.*/
             MONMSG (CPF0000) EXEC(GOTO ERROR)
/*..............................................................*/
/*H: 2. Retrieve 2nd level message text.*/
             RTVMSG     MSGID(&ZAMSID) MSGF(&ZAMSGF) MSGDTA(&ZAMSDA) +
                          SECLVL(&SECLVL) SECLVLLEN(&SECLVLLEN)
/*..............................................................*/
/*H: 3. Execute command string.*/
             CHGVAR &CMDLEN &SECLVLLEN
             CALL QCAEXEC (&SECLVL &CMDLEN)
             CHGVAR &W0RTN ' '
/*..............................................................*/
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
                          Finastra International Limited')
 
ENDPGM
