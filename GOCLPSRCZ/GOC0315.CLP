/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Audit Purge')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0315 - Audit Purge                                      */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB023B            Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB023B - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&RETDYS)  TYPE(*DEC) LEN(3 0) VALUE(999)
             DCL        VAR(&PURDYS)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PURDNB)  TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/**********  DCLF       FILE(SDBANKPD) */                                                /*CCB023B*/
             DCLF       FILE(SDSBNKTD)                                                   /*CCB023B*/
 
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CHGJOB     SWS(00000000)
 
/* Get zone */
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 READ:       RCVF
/* EOF. Goto abnormal proessing section */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ABNOR))
 
/* Audit Purge Retention Days */
 
             CALL       PGM(GOC0316) PARM(&RETDYS)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Purge: */
/* Audit changes whose generation date is prior to the retention date*/
/* Audit changes (manually) flagged for deletion */
 
             OVRDBF     FILE(GPAUCHPD) SHARE(*YES) OPNSCOPE(*JOB)
 
             CHGVAR     VAR(&PURDYS) VALUE(&BJRDNB - &RETDYS)
             CHGVAR     VAR(&PURDNB) VALUE(&PURDYS)
             OPNQRYF    FILE((GPAUCHPD)) OPTION(*ALL) QRYSLT('AHRDNB +
                          *LE ' *CAT &PURDNB *CAT ' *AND AHZONE *EQ +
                          "' *CAT &ZOZONE *CAT '" *OR AHDELT *EQ "Y"')
 
             CALL       PGM(GPAUZPCH) PARM(&RTCD &ERMS &ZOZONE)
 
             CLOF       OPNID(GPAUCHPD)
             DLTOVR     FILE(GPAUCHPD)
 
             RCLRSC
             RCLACTGRP GPAUZPCH
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC0315 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
