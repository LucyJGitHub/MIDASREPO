/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Teller Transaction Balance Check')           */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                         */
/*                                                                   */
/*       REC4223  - Teller Transaction Balance Check                 */
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
/*       Prev Amend No. 096490             Date 28Nov95              */
/*                      CRT001             Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001  -  Retail Teller System                             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&LDA)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* MONITOR GLOBAL MESSAGES */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('REC4223 - Teller Transaction Balance Check') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CHANGE JOB SWITCH SETTINGS - U1 STOPS OUTPUT TO GETTP* & TTIBP* FILES */
             CHGJOB SWS(10000000)
 
             OVRDBF     FILE(TTRANL2) MBR(*ALL)
             CALL       PGM(RE4201)
             DLTOVR     (*ALL)
 
             CHGJOB SWS(0XXXXXXX)
 
/* U7 & U8 ON - DATABASE ERROR  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/* U7 ON - FILE CONTROLS OUT OF BALANCE */
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 168 8))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MEM)   +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* FOR ANY ERROR */
ERROR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4223 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
