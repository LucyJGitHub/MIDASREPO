/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Export data dripfeed closedown')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Eureka Interface                                    */
/*                                                                   */
/*       EDC0110 - Eureka Interface Dripfeed Closedown.              */
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
/*                      CCB001 *C *CREATE  Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*EDCPYSRC,EDC0110INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EDC0110INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBN)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&USRN)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&JBNB)    TYPE(*CHAR)  LEN(6)
             DCL        VAR(&EDDRIP) TYPE(*CHAR) LEN(43)
 
             RTVDTAARA  DTAARA(EDDRIP) RTNVAR(&EDDRIP)
 
             CHGVAR     VAR(&JOBN) VALUE(%SST(&EDDRIP 18 10))
             CHGVAR     VAR(&USRN) VALUE(%SST(&EDDRIP 28 10))
             CHGVAR     VAR(&JBNB) VALUE(%SST(&EDDRIP 38 6))
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***COPY*EDCPYSRC,EDC0110MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EDC0110MPS                                          */                   /*CPK024*/
 
             ENDJOB     JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED) +
                          SPLFILE(*YES)
             MONMSG     MSGID(CPF0001 CPF1321 CPF1362)
 
             ALCOBJ     OBJ((EDC0040 *DTAARA *EXCL)) WAIT(60)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))
 
             DLCOBJ     OBJ((EDC0040 *DTAARA *EXCL))
 
             CALL       PGM(EDC0040)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*EDCPYSRC,EDC0110MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EDC0110MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*EDCPYSRC,EDC0110ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EDC0110ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('EDC0110 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
/***COPY*EDCPYSRC,EDC0110END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,EDC0110END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
