/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Audit House-keeping')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0320 - Audit House-keeping                              */
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
 
             DCL        VAR(&PURDYS)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PURDNB)  TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/**********  DCLF       FILE(SDBANKPD)  */                                               /*CCB023B*/
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
 
/* Purge: */
/* USER INPUTS whose run date is more than 7 days old*/
 
             OVRDBF     FILE(GPAUUIPD) SHARE(*YES) OPNSCOPE(*JOB)
 
             CHGVAR     VAR(&PURDYS) VALUE(&BJRDNB - 7 )
             CHGVAR     VAR(&PURDNB) VALUE(&PURDYS)
             OPNQRYF    FILE((GPAUUIPD)) OPTION(*ALL) QRYSLT('AIRDNB +
                          *LT ' *CAT &PURDNB *CAT ' *AND AIZONE *EQ +
                          "' *CAT &ZOZONE *CAT '"')
 
             CALL       PGM(GPAUZPUI) PARM(&RTCD &ERMS &ZOZONE)
 
             CLOF       OPNID(GPAUUIPD)
             DLTOVR     FILE(GPAUUIPD)
 
             RCLRSC
             RCLACTGRP GPAUZPUI
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Purge: */
/* JOURNAL CHAINS whose run date is more than 31 days old*/
 
             OVRDBF     FILE(GPAUJCPD) SHARE(*YES) OPNSCOPE(*JOB)
 
             CHGVAR     VAR(&PURDYS) VALUE(&BJRDNB - 31)
             CHGVAR     VAR(&PURDNB) VALUE(&PURDYS)
             OPNQRYF    FILE((GPAUJCPD)) OPTION(*ALL) QRYSLT('JCRDNB +
                          *LT ' *CAT &PURDNB *CAT ' *AND JCZONE *EQ +
                          "' *CAT &ZOZONE *CAT '"')
 
             CALL       PGM(GPAUZPJC) PARM(&RTCD &ERMS &ZOZONE)
 
             CLOF       OPNID(GPAUJCPD)
             DLTOVR     FILE(GPAUJCPD)
 
             RCLRSC
             RCLACTGRP GPAUZPJC
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                             */ /*BG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                               /*BG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC0320 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
