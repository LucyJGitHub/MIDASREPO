/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Start SWIFT compression programs ctl')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Midas Swift Module                              */
/*                                                                   */
/*       MSC0204 - Start SWIFT Compression Programs Control          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 077466             Date 17Oct94              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       077466 - New program created to control the SWIFT           */
/*                compression programs startup.                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01426')
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Clear trace data file */
 
             CLRPFM     FILE(MSTRACPD)
             MONMSG     MSGID(CPF3142)
 
/* If S01426 is in the system, Bypass SWIFT start up */
 
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
 
             IF         COND(&RTN *NE '       ') THEN(DO)
               CALL       PGM(MSC0203)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal termination processing */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program MSC0204 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
