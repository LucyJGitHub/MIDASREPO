/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD DATE FORMAT')                                */
/*********************************************************************/
/*                                                                   */
/*        Midas     - IBM DATE FORMAT                            */
/*                                                                   */
/*       DATFMT - GET THE IBM DATE FORMAT FOR DL1810                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. XXXXXX             DATE 00XXX00              */
/*       PREV AMEND NO. XXXXXX             DATE 00XXX00              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DFMT)
/**/
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FROMFMT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL ERROR TRAP */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)
/**/
/* HANDLE EACH TYPE OF DATE FORMAT PROVIDED BY IBM */
/**/
             IF         COND(&DATFMT *EQ 'DMY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('D'))
             IF         COND(&DATFMT *EQ 'MDY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('M'))
             IF         COND(&DATFMT *EQ 'YDM') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('Y'))
             IF         COND(&DATFMT *EQ 'JUL') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('J'))
             GOTO       CMDLBL(END)
/**/
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSG('PROGRAM DATFMT ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
