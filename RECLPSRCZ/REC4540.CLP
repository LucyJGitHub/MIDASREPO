/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP socket debug functions')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4540 - Midas Cashier TCP/IP Socket Debugging Functions   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CRT004  *CREATE    Date 12May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,REC4540INT                                          */
 
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RE4540DA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&DBGLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DBGJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBGJUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBGJNB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,REC4540MPS                                          */
 
/* Main processing */
 
             RTVJOBA    JOB(&DBGJNM) USER(&DBGJUS) NBR(&DBGJNB)
             CHGVAR     VAR(%SST(&RE4540DA 1 1)) VALUE('Y')
             CHGVAR     VAR(%SST(&RE4540DA 2 10)) VALUE(&DBGJNM)
             CHGVAR     VAR(%SST(&RE4540DA 12 10)) VALUE(&DBGJUS)
             CHGVAR     VAR(%SST(&RE4540DA 22 10)) VALUE(&DBGJNB)
             CHGDTAARA  DTAARA(RE4540DA) VALUE(&RE4540DA)
/* Clear Trace File */
             CLRPFM     FILE(RETCPDPD)
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(RE4540)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,REC4540MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4540ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             CHGVAR     VAR(%SST(&RE4540DA 1 1)) VALUE('N')
             CHGVAR     VAR(%SST(&RE4540DA 2 10)) VALUE(' ')
             CHGVAR     VAR(%SST(&RE4540DA 12 10)) VALUE(' ')
             CHGVAR     VAR(%SST(&RE4540DA 22 10)) VALUE(' ')
             CHGDTAARA  DTAARA(RE4540DA) VALUE(&RE4540DA)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4540 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC4540END                                          */
 
 
             ENDPGM
