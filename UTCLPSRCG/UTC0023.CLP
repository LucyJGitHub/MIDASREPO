/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Check /COPY for omit processing')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0023 - Check /COPY for Omit Processing.                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 082942             Date 07Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       082942 - New program to check a /COPY for /OMITSTART or     */
/*                /OMITEND statements.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COPYFIL &COPYMBR &RTNCODE)
 
             DCL        VAR(&COPYFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPYMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(*LIBL/STDCRTPARM)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Override to the selected /COPY source member */
             OVRDBF     FILE(STDCRTPARM) TOFILE(&COPYFIL) MBR(&COPYMBR)
 
/* Initialise the return value to indicate no omit processing */
             CHGVAR     VAR(&RTNCODE) VALUE('COPY ')
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0684) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* If a start of omit processing */
             IF         COND(%SST(&SRCDTA 9 9) *EQ 'OMITSTART') +
                          THEN(DO)
                CHGVAR     VAR(&RTNCODE) VALUE('START')
                GOTO       CMDLBL(END)
             ENDDO
 
/* If a end of omit processing */
             IF         COND(%SST(&SRCDTA 9 7) *EQ 'OMITEND') +
                          THEN(DO)
                CHGVAR     VAR(&RTNCODE) VALUE('END  ')
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
 ABNOR:
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
