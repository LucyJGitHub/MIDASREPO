/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Create an object on request')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0025 - Create an Object on Request                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 094515   *CREATE   Date 25OCT95              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       094515 - New program created for this fix.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OBJECT &TYPE &TOLIB &OBJTEXT &CRTINFO +
                          &PUBLIC &RTNCODE)
 
/*/COPY WNCPYSRC,SCC0025INT                                          */
 
             DCL        VAR(&OBJECT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CRTINFO) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PUBLIC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RTNCODE) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC0025MPS                                          */
 
/* Process default values */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
             IF         COND(&TOLIB *EQ 'XLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'XLIB'))
             IF         COND(&TOLIB *EQ 'DMLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'DMLIB'))
             IF         COND(&TOLIB *EQ 'DPLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'DPLIB'))
             IF         COND(&TOLIB *EQ 'DVLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'DVLIB'))
             IF         COND(&TOLIB *EQ 'DTALIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'DTALIB'))
             IF         COND(&TOLIB *EQ 'UCLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'UCLIB'))
             IF         COND(&TOLIB *EQ 'UPLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'UPLIB'))
             IF         COND(&TOLIB *EQ 'JLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'JLIB'))
             IF         COND(&TOLIB *EQ 'HFLIB') THEN(CHGVAR +
                          VAR(&TOLIB) VALUE(&PREFIX *CAT 'HFLIB'))
 
/* Output queue creation */
 
             IF         COND(&TYPE *EQ 'OUTQ') THEN(DO)
 
/* &CRTINFO  Posn 1 to 7    SEQ( ) value */
 
                CRTOUTQ    OUTQ(&TOLIB/&OBJECT) +
                             SEQ(%SST(&CRTINFO 1 7)) TEXT(&OBJTEXT)
 
                GRTOBJAUT  OBJ(&TOLIB/&OBJECT) OBJTYPE(*OUTQ) +
                             USER(*PUBLIC) AUT(&PUBLIC)
 
             ENDDO
 
/*/COPY WNCPYSRC,SCC0025MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC0025ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0025 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&RTNCODE) VALUE(E)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0025END                                          */
 
             ENDPGM
