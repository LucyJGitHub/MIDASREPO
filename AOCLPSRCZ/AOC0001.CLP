/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AO Call Leo access object CAOUCU')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     Access Object                                     */
/*                                                                   */
/*       AOC0001 - CALL LEO ACCESS OBJECT CAOUCU                     */
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
/*       PREV AMEND NO. S01467             DATE 31MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01467  -  Midas-Leo Integration - New program              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN &OPTN &CUSN &KEYS &FFMT)
 
/** Declare the parameters and variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CUSN) TYPE(*DEC) LEN(8)
             DCL        VAR(&KEYS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FFMT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
 
/** Global monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Change the switches U7 & U8 off */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Retrieve the Library name for the LEO access object CAOUCU */
 
             RTVDTAARA  DTAARA(*LDA (71 10)) RTNVAR(&LIB1)
 
/** Call the LEO program  CAOUCU */
 
             CALL       PGM(&LIB1/CAOUCU) PARM(&RTN &OPTN &CUSN +
                          &KEYS &FFMT)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal error processing */
 
 ABNOR:      SNDPGMMSG  MSG('Program AOC0001 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
