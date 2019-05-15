/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas GL Reset IAT/TPP data area for next day')       */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2830    Reset IAT/TPP data areas ready for next day         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   Prev Amendment No. CGL009 *CREATE   Date 18May99               */
/*                                                                  */
/*********************************************************************/
/*                                                                  */
/*   MD046248 - Finastra Rebranding                                 */
/*   CGL009 - Midas-Fontis IAT/TPP Interface                        */
/*                                                                  */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYST) TYPE(*CHAR) LEN(2)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYST)
/* Determine ??XLIB */
             CHGVAR     VAR(&XLIB) VALUE(&SYST *TCAT 'XLIB')
/**/
/*    Reset GLFIATDA positions */
 
             CHGDTAARA  DTAARA(GLFIATDA (1 26)) VALUE(' ')
             CHGDTAARA  DTAARA(GLFIATDA (28 1)) VALUE(' ')
             CHGDTAARA  DTAARA(GLFIATDA (29 1)) VALUE(' ')
             CHGDTAARA  DTAARA(GLFIATDA (30 3)) VALUE('000')
             CHGDTAARA  DTAARA(GLFIATDA (33 1)) VALUE(' ')
/**/
/*    Reset MEFTPPDA positions */
 
             CHGDTAARA  DTAARA(MEFTPPDA (1 26)) VALUE(' ')
             CHGDTAARA  DTAARA(MEFTPPDA (28 1)) VALUE(' ')
             CHGDTAARA  DTAARA(MEFTPPDA (29 1)) VALUE(' ')
/**/
/*    Rereate dtaqs */
             DLTDTAQ    DTAQ(&XLIB/METPPSA)
             MONMSG     MSGID(CPF0000)
             DLTDTAQ    DTAQ(&XLIB/GLIATSA)
             MONMSG     MSGID(CPF0000)
             CRTDTAQ    DTAQ(&XLIB/METPPSA) MAXLEN(1) TEXT('Midas ME +
                          Fontis TPP')
             MONMSG     MSGID(CPF0000)
             CRTDTAQ    DTAQ(&XLIB/GLIATSA) MAXLEN(1) TEXT('Midas GL +
                          Fontis IAT')
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC2830 ended abnormally ') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
 
