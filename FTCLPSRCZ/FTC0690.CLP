/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Funds transfer i/c termination')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       FTC0690 - Call Pay/Receive Processing in COB.               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. CSW220             Date 09Mar20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB001 *C *CREATE  Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSW220 - SWIFT Changes 2020                                 */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*FTCPYSRC,FTC0690INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,FTC0690INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE(S)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CSW2020) TYPE(*CHAR) LEN(6) VALUE('CSW220')                  /*CSW220*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                   /*CSW220*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*FTCPYSRC,FTC0690MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,FTC0690MPS                                          */                   /*CPK024*/
 
                                                                                          /*CSW220*/
 /* Check if switchable feature CSW220 is on */                                           /*CSW220*/
             CALL       PGM(SWIFTACTV) PARM(&CSW2020 &PRTCD)                              /*CSW220*/
                                                                                          /*CSW220*/
             IF         COND(&PRTCD *EQ 'CSWACTV') THEN(DO)                               /*CSW220*/
             CALL       PGM(FT000200)                                                     /*CSW220*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO CMDLBL(ABNOR))                  /*CSW220*/
             ENDDO                                                                        /*CSW220*/
                                                                                          /*CSW220*/
             CALL       PGM(FTC0630) PARM(&RSEQ &RLEV &RENT)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*FTCPYSRC,FTC0690MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,FTC0690MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*FTCPYSRC,FTC0690ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,FTC0690ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('FTC0690 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
/***COPY*FTCPYSRC,FTC0690END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,FTC0690END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
