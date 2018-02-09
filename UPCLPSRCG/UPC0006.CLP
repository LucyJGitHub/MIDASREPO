/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Enter an user name and description')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC0006 - Enter an user name and description                */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. CSM002  *CREATE    Date 31Oct02              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM002 - Allow rename of old users and description in       */
/*                migration.                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USRNM &USRTXT)
 
             DCL        VAR(&USRNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRTXT) TYPE(*CHAR) LEN(25)
 
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
 
             CRTDTAARA  DTAARA(QTEMP/USERNAME) TYPE(*CHAR) LEN(35) +
                          TEXT('Temporary data area for USERNAME +
                          command')
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(QTEMP/USERNAME (1 10)) VALUE(&USRNM)
             CHGDTAARA  DTAARA(QTEMP/USERNAME (11 25)) VALUE(&USRTXT)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0006') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC0006' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
