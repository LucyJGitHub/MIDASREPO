/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP worker process')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4520 - Midas Cashier TCP/IP Worker Process               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CRT004  *CREATE    Date 10May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOBINT &BRC &JOBUSER &UNIT &SRVPGM)
 
/*/COPY WNCPYSRC,REC4520INT                                          */
 
             DCL        VAR(&JOBINT) TYPE(*CHAR) LEN(16)
             DCL        VAR(&BRC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNIT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SRVPGM) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC4520MPS                                          */
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
/* Main processing */
 
             CALL       PGM(RE4520) PARM(&JOBINT &BRC &JOBUSER &UNIT +
                          &SRVPGM)
 
/*/COPY WNCPYSRC,REC4520MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4520ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4520 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC4520END                                          */
 
             ENDPGM
