/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Restart journaling/subsystem on Main')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC1607 - Restart journaling and subsystem for Main system  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. BUG27134           Date 01Oct08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP016 *CREATE     Date 02Dec02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27134- Rewrite of SCBEGINJRN.                            */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SBSD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Get the Main System prefix. */
             RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MSPREFIX)
             CHGVAR     VAR(&SBSD) VALUE('M' *TCAT &MSPREFIX *TCAT +
                          'SBS')
 
             CALL       PGM(UPC0014) PARM(&MSPREFIX)
 
/* Start journaling on Main system. */
/**********  CALL       PGM(SCBEGINJRN) PARM(&MSPREFIX)                              */ /*BUG27134*/
             JRNZONE    PFX(&MSPREFIX) ACTION(*START)                                   /*BUG27134*/
 
/* Start subsystem. */
             STRSBS     SBSD(&SBSD)
 
/* Change System Value flag to make system available again. */
             CALL       PGM(SD009510) PARM('SystemLockStatus' +
                          '*AVAILABLE' ' ')
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC1607') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC1607' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
