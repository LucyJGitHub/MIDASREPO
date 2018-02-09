/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Submit job?')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0012 - Submit job?                                       */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015 *CREATE     Date 22Mar02              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - 4.01 packaging.  Improve copy of data libraries.   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SUBMITJOB)
 
             DCL        VAR(&SUBMITJOB) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
             CRTDTAARA  DTAARA(QTEMP/SUBMITJOB) TYPE(*CHAR) LEN(4) +
                          TEXT('Temporary data area for SUBMITJOB +
                          command')
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(QTEMP/SUBMITJOB) VALUE(&SUBMITJOB)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0012') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC0012' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
