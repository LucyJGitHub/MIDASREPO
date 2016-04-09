/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change CoB components')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0028 - Change CoB components                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CUP014 *CREATE     Date 17Apr01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP014 - New utility for the Bridge.                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&EXEPTY &TIMESLICE)
 
             DCL        VAR(&EXEPTY) TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXEPTYN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&TIMESLICE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIMESLICEN) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Manipulate strings so that it is easy to pass values as numeric */
             IF         COND(&EXEPTY *NE '*SAME') THEN(DO)
                CHGVAR     VAR(&EXEPTYN) VALUE(&EXEPTY)
             ENDDO
             IF         COND(&TIMESLICE *NE '*SAME') THEN(DO)
                CHGVAR     VAR(&TIMESLICEN) VALUE(&TIMESLICE)
             ENDDO
 
             CALL       PGM(UP0028) PARM(&EXEPTYN &TIMESLICEN)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0028') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC0028' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
