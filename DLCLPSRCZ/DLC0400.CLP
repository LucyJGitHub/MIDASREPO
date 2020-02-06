/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL input cycle termination')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0400 - Dealing I/C Termination                           */
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
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB001 *CREATE     Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*DLCPYSRC,DLC0400INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,DLC0400INT                                          */                   /*CPK024*/
 
/*/COPY WNCPYSRC,DLC0400001                                          */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RRNCNF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RRNPRC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,DLH00166                                            */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*DLCPYSRC,DLC0400MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,DLC0400MPS                                          */                   /*CPK024*/
 
/*/COPY WNCPYSRC,DLC0400002                                          */
/**/
/* If confirmations pr pay/receive failed last time                */
/* perform recovery run and normal run                             */
/**/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
             CHGVAR     VAR(&RRNCNF) VALUE(%SST(&DLSTAT 98 1))
             CHGVAR     VAR(&RRNPRC) VALUE(%SST(&DLSTAT 99 1))
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)
/*/COPY WNCPYSRC,DLH00167                                            */
 
             CALL       PGM(DLC04)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(&RRNCNF *NE ' ' *OR &RRNPRC *NE ' ') +
                          THEN(DO)
                CALL       PGM(DLC04)
                IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                             CMDLBL(ABNOR))
             ENDDO
 
/***COPY*DLCPYSRC,DLC0400MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,DLC0400MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*DLCPYSRC,DLC0400ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,DLC0400ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('DLC0400 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
/***COPY*DLCPYSRC,DLC0400END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,DLC0400END                                          */                   /*CPK024*/
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
