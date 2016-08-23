/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AO Call Leo access object CAOUBR')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     Access Object                                     */
/*                                                                   */
/*       AOC0005 - Call Leo Access Object CAOUBR                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 081649  *CREATE    Date 09Feb95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       081649  -  Midas-Leo Integration - New program              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN &OPTN &LEOKEY &MIDASKEY &KEYSTS +
                          &FFMT)
 
/***COPY*AOCPYSRC,AOC0005INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,AOC0005INT                                          */                   /*CPK024*/
 
/** Declare the parameters and variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LEOKEY) TYPE(*DEC) LEN(2)
             DCL        VAR(&MIDASKEY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&KEYSTS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FFMT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Change the switches U7 & U8 off */
 
             CHGJOB     SWS(XXXXXX00)
 
/***COPY*AOCPYSRC,AOC0005MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,AOC0005MPS                                          */                   /*CPK024*/
 
/* Retrieve the Library name for the LEO access object CAOUBR */
 
             RTVDTAARA  DTAARA(*LDA (101 10)) RTNVAR(&LIB1)
 
/* Special case processing - *FIND */
 
             IF         COND(&OPTN *EQ '*FIND') THEN(DO)
                CALL       PGM(&LIB1/CAOUBR) PARM(&RTN '*FIRST' +
                             &LEOKEY &KEYSTS &FFMT)
 NEXT:
                IF         COND(&MIDASKEY *NE %SST(&FFMT 55 3)) +
                             THEN(DO)
                   CALL       PGM(&LIB1/CAOUBR) PARM(&RTN '*NEXT' +
                                &LEOKEY &KEYSTS &FFMT)
                   IF         COND(&RTN *NE '*EOF') THEN(GOTO +
                                CMDLBL(NEXT))
                   CHGVAR     VAR(&RTN) VALUE('*NRF')
                ENDDO
                GOTO       CMDLBL(END)
             ENDDO
 
/* Call the LEO program  CAOUBR */
 
             CALL       PGM(&LIB1/CAOUBR) PARM(&RTN &OPTN &LEOKEY +
                          &KEYSTS &FFMT)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/***COPY*AOCPYSRC,AOC0005MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,AOC0005MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
/* Abnormal error processing */
 
 ABNOR:
/***COPY*AOCPYSRC,AOC0005ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,AOC0005ERR                                          */                   /*CPK024*/
 
             SNDPGMMSG  MSG('Program AOC0005 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
/***COPY*AOCPYSRC,AOC0005END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,AOC0005END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
