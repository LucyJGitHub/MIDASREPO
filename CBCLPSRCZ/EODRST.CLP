/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Restart COB processing')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Module.                       */
/*                                                                   */
/*       EODRST - Reroute COB processing restart.                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01463             DATE 11FEB94              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01463 - New program to allow the rerouting of the COB      */
/*                processing to be updated without the need to       */
/*                change the subsystem routing entries. All of       */
/*                the old EODRST processing has been moved to a      */
/*                new program CBC0101.                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
 
/* Global monitor */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Retrieve job identifier */
 
             RTVJOBA    JOB(&JOB)
 
/* Create the Midas Information Screen data area */
 
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')
             MONMSG     MSGID(CPF1023)
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
 
/* Call the COB restart program via ML initiation */
 
             CALL       PGM(MLC0000) PARM('CBC0101' &PARM1 &PARM2 +
                          &PARM3 &PARM4 &PARM5)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Inform user that the program is in error */
 
             SNDPGMMSG  MSG('Reroute of the close of business +
                          terminated abnormally') TOMSGQ(MOPERQ &JOB)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
