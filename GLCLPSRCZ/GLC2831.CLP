/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Initialisation program for IAT/TPP fontis')  */
/*********************************************************************/
/*                                                                   */
/*   Midas - Midas-Fontis Interface                                  */
/*                                                                   */
/*   GLC2831 Initialisation program for Fontis TPP/IAT Interface     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 180223             Date 13Jun00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009 *C *CREATE  Date 28Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   180223 - General initialisation problems.                       */
/*   CGL009 - Midas-Fontis IAT/TPP Interface                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYST) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(8)                                      /*180223*/
 
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYST)
/* Determine ??XLIB */
             CHGVAR     VAR(&XLIB) VALUE(&SYST *TCAT 'XLIB')
/* */
/** Mode 1 - Calling program for the first time                    */
/** Mode 2 - Re-calling program if already previously used         */
/* */
 
             IF  COND((&IPMODE = '1') *OR (&IPMODE = '2')) THEN(DO)
/* Receive TPP files set to Y */
               CHGDTAARA  DTAARA(MEFTPPDA *ALL) VALUE(' ')
               CHGDTAARA  DTAARA(MEFTPPDA (27 1)) VALUE('Y')
/* Receive IAT files set to Y */
               CHGDTAARA  DTAARA(GLFIATDA *ALL) VALUE(' ')
               CHGDTAARA  DTAARA(GLFIATDA (27 1)) VALUE('Y')
               IF  COND((&IPMODE = '1')) THEN(DO)
                 CHGJOB     SWS(XXXXXX00)
                 CRTDTAQ    DTAQ(&XLIB/METPPSA) MAXLEN(1) +
                           TEXT('Midas ME fontis TPP')
                 CRTDTAQ    DTAQ(&XLIB/GLIATSA) MAXLEN(1) +
                           TEXT('Midas GL fontis IAT')
                 GOTO       CMDLBL(END)
               ENDDO
               RTVDTAARA  DTAARA(MEDTA (1 8)) RTNVAR(&SEQ)                                /*180223*/
               IF         COND(&SEQ *EQ '        ') THEN(DO)                              /*180223*/
                  CHGDTAARA  DTAARA(MEDTA (1 8)) VALUE('00000000')                        /*180223*/
               ENDDO                                                                      /*180223*/
             ENDDO
 
             IF         COND(&IPMODE = '3') THEN(DO)
               CHGJOB     SWS(XXXXXX00)
               GOTO       CMDLBL(END)
             ENDDO
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC2831 ended abnormally ') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
