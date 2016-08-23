/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas SC Re-organise journal receiver reference')     */
/********************************************************************/
/*                                                                  */
/*          MIDAS SYSTEM CONTROL MODULE                             */
/*                                                                  */
/*          SCC2474 - Re-organise journal receiver reference file   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2004          */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 10Aug04             */
/*       Prev Amend No. CSC020 *CREATE     Date 31Mar04             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       228542 - RGZPFM has changed at R5V3                        */
/*       CSC020 - Journaling changes for MidasPlus.                 */
/*                                                                  */
/********************************************************************/
             PGM
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/** Call program SC002474 to drop old records from SCJSEQPD                                       */
/* */
             CALL       PGM(SC002474)
/* */
/*  Re-organise file SCJSEQPD.                                                                    */
/* */
/**********  RGZPFM     FILE(SCJSEQPD)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('SCJSEQPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
/* */
/*  Terminate program.                                                                            */
/* */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2474 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             RETURN
             ENDPGM
