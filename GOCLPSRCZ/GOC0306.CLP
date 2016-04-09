/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Journal Entry Extraction')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0306 - Journal Entry Extraction                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ZOZONE &RCV &CDAT &FENT &TENT &LENT)
 
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RCV)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LENT) TYPE(*DEC) LEN(10 0)
 
             DCL        VAR(&TENTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LENTA) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&DJ) TYPE(*CHAR)   LEN(5000)
             DCL        VAR(&NOFIL) TYPE(*DEC) LEN(3 0)  VALUE(0)
             DCL        VAR(&LGTH) TYPE(*CHAR) LEN(4)    VALUE('4000')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(GPAUFLL0)
 
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CHGVAR     VAR(&LENTA) VALUE(&LENT)
             CHGVAR     VAR(&TENTA) VALUE(&TENT)
 
/* Set up the DSPJRN variable */
 
             CHGVAR     VAR(&DJ) VALUE('DSPJRN RCVRNG(' *CAT &RCV +
                          *CAT ' ' *CAT &RCV *CAT ') FROMENT(' *CAT +
                          &LENTA *CAT ') TOENT(' *CAT &TENTA *CAT +
                          ') JRN(ICJRN) FILE(')
 
/* Read all records from GPAUFLPD */
 
 READ:       RCVF
/* EOF. Goto main processing section */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(MAIN))
 
/* If the file is not active then read the next record */
 
             IF         COND(&AFACTV *NE 'Y') THEN(GOTO CMDLBL(READ))
 
/* Add this file name onto the end of the DSPJRN variable */
 
             CHGVAR     VAR(&DJ) VALUE(&DJ *BCAT '(*LIBL/' *TCAT +
                          &AFFILE *TCAT ' *ALL)')
             CHGVAR     VAR(&NOFIL) VALUE(&NOFIL + 1)
 
/* Next record */
 
             GOTO       CMDLBL(READ)
 
/* Complete the DSPJRN variable */
 
 MAIN:       CHGVAR     VAR(&DJ) VALUE(&DJ *BCAT ') JRNCDE(R)' *BCAT +
                          'ENTDTALEN(' *TCAT &LGTH *TCAT ') +
                          OUTPUT(*OUTFILE)' *BCAT 'OUTFILE(' *TCAT +
                          'QTEMP/GPAUJIPD) OUTMBR(*FIRST *REPLACE)')
 
/* If no files to be analysed do no further processing */
 
             IF         COND(&NOFIL *EQ 0) THEN(GOTO CMDLBL(END))
 
/* Create journal images file in QTEMP */
 
             CPYF       FROMFILE(GPAUJIPD) TOFILE(QTEMP/GPAUJIPD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/GPAUJIPD)
 
/* Call QCMDEXC to execute the DSPJRN variable stored in &DJ */
RETRY:
             CALL       PGM(QCMDEXC) PARM(&DJ 5000)
             MONMSG     MSGID(CPF7062)
 
             MONMSG     MSGID(CPF7007 CPF9803) EXEC(DO)
             DLYJOB     DLY(10)
             GOTO       RETRY
             ENDDO
 
/* Create audit header and details file in QTEMP */
 
             CPYF       FROMFILE(GPAUCHPD) TOFILE(QTEMP/GPAUCHPD) +
                          CRTFILE(*YES) FROMRCD(1) TORCD(1)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/GPAUCHPD)
 
             CPYF       FROMFILE(GPAUCDPD) TOFILE(QTEMP/GPAUCDPD) +
                          CRTFILE(*YES) FROMRCD(1) TORCD(1)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/GPAUCDPD)
 
/* Audit Extract */
 
             OVRDBF     FILE(GPAUJIPD) TOFILE(QTEMP/GPAUJIPD) +
                          OPNSCOPE(*ACTGRPDFN) SEQONLY(*YES 1000)
             OVRDBF     FILE(GPAUCHPD) TOFILE(QTEMP/GPAUCHPD) +
                          OPNSCOPE(*ACTGRPDFN) SEQONLY(*YES 1000)
             OVRDBF     FILE(GPAUCDPD) TOFILE(QTEMP/GPAUCDPD) +
                          OPNSCOPE(*ACTGRPDFN) SEQONLY(*YES 1000)
 
             CALL       PGM(GPAUZEXT) PARM(&RTCD &ERMS &ZOZONE)
 
             RCLRSC
             RCLACTGRP GPAUZEXT
 
             DLTOVR     FILE(GPAUJIPD) LVL(*ACTGRPDFN)
             DLTOVR     FILE(GPAUCHPD) LVL(*ACTGRPDFN)
             DLTOVR     FILE(GPAUCDPD) LVL(*ACTGRPDFN)
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CPYF       FROMFILE(QTEMP/GPAUCHPD) TOFILE(GPAUCHPD) +
                          MBROPT(*ADD)
             CPYF       FROMFILE(QTEMP/GPAUCDPD) TOFILE(GPAUCDPD) +
                          MBROPT(*ADD)
 
/* Journal Chain Update */
 
             CHGVAR     VAR(&LENT) VALUE(&TENT)
             CALL       PGM(GPAUJCUPD) PARM(&RTCD &ERMS 'Y' &ZOZONE +
                          &RCV &CDAT &FENT &TENT &LENT)
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC0306 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
