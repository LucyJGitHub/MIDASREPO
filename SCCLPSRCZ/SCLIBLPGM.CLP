/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Library list setup')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCLIBLPGM - Midas Library List Setup Prpgram                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK008  *CREATE    Date 19JUN97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK008 - DBA R2 packaging:                                  */
/*                - Creation of skeleton program to allow easy       */
/*                  setup of a Midas library list.                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PREFIX)
 
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10) VALUE(XXXLIB)
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10) VALUE(XXDVLIB)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) VALUE(XXDPLIB)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) VALUE(XXDMLIB)
             DCL        VAR(&UCLIB) TYPE(*CHAR) LEN(10) VALUE(XXUCLIB)
             DCL        VAR(&UPLIB) TYPE(*CHAR) LEN(10) VALUE(XXUPLIB)
             DCL        VAR(&CPLIB) TYPE(*CHAR) LEN(10) VALUE(XXCPLIB)
             DCL        VAR(&MPLIB) TYPE(*CHAR) LEN(10) VALUE(XXMPLIB)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10) +
                          VALUE(XXDTALIB)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10) VALUE(XXJLIB)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10) VALUE(XXDILIB)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10) VALUE(XXHFLIB)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Setup the standard Midas system library names using the supplied */
/* prefix (If supplied)                                             */
 
             IF         COND(&PREFIX *NE '  ') THEN(DO)
               CHGVAR     VAR(%SST(&XLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&DVLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&DPLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&UCLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&UPLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&CPLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&MPLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&DTALIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&DILIB 1 2)) VALUE(&PREFIX)
               CHGVAR     VAR(%SST(&HFLIB 1 2)) VALUE(&PREFIX)
 
 
               CHGLIBL    LIBL(&XLIB &DVLIB &DPLIB &DMLIB &UCLIB +
                            &UPLIB &CPLIB &MPLIB &DTALIB &JLIB &DILIB +
                            &HFLIB QGPL QTEMP)
             ENDDO
 
/* Amend standard library list to suit specific system requirements */
 
/*/COPY WNCPYSRC,SCLIBLPG01                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCLIBLPGM ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
