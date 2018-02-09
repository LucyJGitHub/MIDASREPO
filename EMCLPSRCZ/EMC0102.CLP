/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Terminate job EM0101')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Exposure Management Module                          */
/*                                                                   */
/*       EMC0102 - Terminate EM0101                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB001 *CREATE     Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB001 - CoB Enhancements (Batch Processing)                */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*EMCPYSRC,EMC0102INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EMC0102INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*EMCPYSRC,EMC0102MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EMC0102MPS                                          */                   /*CPK024*/
 
/* Terminate EM0101 */
 
             RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)
 
             CHGVAR     VAR(&JOBN) VALUE(%SUBSTRING(&EMSTAT 100 10))
             CHGVAR     VAR(&USRN) VALUE(%SUBSTRING(&EMSTAT 110 10))
             CHGVAR     VAR(&JBNB) VALUE(%SUBSTRING(&EMSTAT 120 6))
 
             ENDJOB     JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED) +
                          SPLFILE(*YES)
             MONMSG     MSGID(CPF0001 CPF1321 CPF1362)
 
/***COPY*EMCPYSRC,EMC0102MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EMC0102MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*EMCPYSRC,EMC0102ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EMC0102ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          EMC0102 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
/***COPY*EMCPYSRC,EMC0102END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EMC0102END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
