/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Midas Retrieve number of members')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - GL Module                                           */
/*                                                                   */
/*       GLC2826 - Retrieve number of members of a file              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Last Amend No. CGL009  *CREATE    Date 21MAY99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL009 - Midas-Fontis IAT/TPP Interface                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILENM &NUMMBR)
 
 
             DCL        VAR(&MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRIDX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILENM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUMMBR) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&NUMMBR) VALUE(0)
             RTVMBRD    FILE(&FILENM) RTNMBR(&MBRN)
             MONMSG     MSGID(CPF3019) EXEC(GOTO CMDLBL(END))
/* Loop until all the members have been retrieved  */
RTVM:
             CHGVAR     VAR(&NUMMBR) VALUE(&NUMMBR + 1)
             CHGVAR     VAR(&MBRIDX) VALUE(&MBRN)
             RTVMBRD    FILE(&FILENM) MBR(&MBRIDX *NEXT) RTNMBR(&MBRN)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(END))
             GOTO       CMDLBL(RTVM)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC2826 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
/* We do nothing */
 
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
