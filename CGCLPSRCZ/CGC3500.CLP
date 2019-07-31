/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC print address labels')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3500  -  Print address labels                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01522             Date 21Dec94              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
/* Hello                                                             */
             PGM        PARM(&RTCD &MBR &RBCH)
 
/* Parameter obtained from CGDTA                                     */
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIZX) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SIZY) TYPE(*CHAR) LEN(5)
 
/* Other declarations                                                */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RBCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message                                            */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Get page size, and over-ride printer file. If page description is */
/* blank, restore default values.                                    */
             RTVDTAARA  DTAARA(CGDTA (116 10)) RTNVAR(&SIZE)
 
             IF         COND(&SIZE *EQ '          ') THEN(DO)
/*  o Page width (characters)                                        */
             CHGDTAARA  DTAARA(CGDTA (116 5)) VALUE('00132')
/*  o Page length (lines)                                            */
             CHGDTAARA  DTAARA(CGDTA (121 5)) VALUE('00066')
/*  o Number of labels across page                                   */
             CHGDTAARA  DTAARA(CGDTA (126 5)) VALUE('00003')
/*  o Number of labels down page                                     */
             CHGDTAARA  DTAARA(CGDTA (131 5)) VALUE('00003')
/*  o Left/right margin (in characters)                              */
             CHGDTAARA  DTAARA(CGDTA (136 5)) VALUE('00010')
/*  o Top/bottom margin (in lines)                                   */
             CHGDTAARA  DTAARA(CGDTA (141 5)) VALUE('00010')
/*  o Width of label (in characters)                                 */
             CHGDTAARA  DTAARA(CGDTA (146 5)) VALUE('00020')
/*  o Length of label (in lines)                                     */
             CHGDTAARA  DTAARA(CGDTA (151 5)) VALUE('00010')
/* Get page size (again)                                             */
             RTVDTAARA  DTAARA(CGDTA (116 10)) RTNVAR(&SIZE)
             ENDDO
 
             CHGVAR     VAR(&SIZX) VALUE(%SST(&SIZE 1 5))
             CHGVAR     VAR(&SIZY) VALUE(%SST(&SIZE 6 5))
             OVRPRTF    FILE(CG3500P1) PAGESIZE(&SIZY &SIZX) +
                          OVRFLW(&SIZY) FOLD(*NO) PRTTXT(*BLANK) +
                          FILESEP(0) USRDTA(LABELS)
 
/* Set-off Data Base Error Switches                                  */
             CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,CGC3500001                                          */
 
/* Call RPG program                                                  */
             CALL       PGM(CG3500) PARM(&RTCD &MBR &RBCH)
/*/COPY WNCPYSRC,CGC3500002                                          */
 
/* Check for Database errors trapped by program                      */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
/* Terminate Program normally                                        */
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination processing                                   */
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program CGC3500 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC3500 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Bye                                                               */
             ENDPGM
