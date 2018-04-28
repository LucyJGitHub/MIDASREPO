/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Set up label stationery')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGCLABEL - Set up label stationery                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01522             DATE 28NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PWIDTH &PLENGTH &XLABEL &YLABEL +
                          &LRMARGIN &TBMARGIN &LWIDTH &LLENGTH)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&PWIDTH) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLENGTH) TYPE(*CHAR) LEN(5)
             DCL        VAR(&XLABEL) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YLABEL) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LRMARGIN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&TBMARGIN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LWIDTH) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LLENGTH) TYPE(*CHAR) LEN(5)
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* Set up default label stationery details on DTAARA/CGDTA                    */
/*  o Page width (characters)                                                 */
             CHGDTAARA  DTAARA(CGDTA (116 5)) VALUE(&PWIDTH)
/*  o Page length (lines)                                                     */
             CHGDTAARA  DTAARA(CGDTA (121 5)) VALUE(&PLENGTH)
/*  o Number of labels across page                                            */
             CHGDTAARA  DTAARA(CGDTA (126 5)) VALUE(&XLABEL)
/*  o Number of labels down page                                              */
             CHGDTAARA  DTAARA(CGDTA (131 5)) VALUE(&YLABEL)
/*  o Left/right margin (in characters)                                       */
             CHGDTAARA  DTAARA(CGDTA (136 5)) VALUE(&LRMARGIN)
/*  o Top/bottom margin (in lines)                                            */
             CHGDTAARA  DTAARA(CGDTA (141 5)) VALUE(&TBMARGIN)
/*  o Width of label (in characters)                                          */
             CHGDTAARA  DTAARA(CGDTA (146 5)) VALUE(&LWIDTH)
/*  o Length of label (in lines)                                              */
             CHGDTAARA  DTAARA(CGDTA (151 5)) VALUE(&LLENGTH)
 
/* Normal termination                                                         */
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination processing */
ABNORMAL:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC0000 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGCLAYOUT ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* End program */
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
