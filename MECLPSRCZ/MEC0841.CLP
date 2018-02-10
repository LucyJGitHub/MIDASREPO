/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Outgoing messages summary report')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC0841 - Outgoing Messages Summary Report                  */
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
 
/***COPY*MECPYSRC,MEC0841INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC0841INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*MECPYSRC,MEC0841MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC0841MPS                                          */                   /*CPK024*/
 
/**/
/*   CALL OUTGOING MESSAGES STATUS SUMMARY REPORT                  */
/**/
             CALL       PGM(MEC0840A)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/**/
/*   CALL OUTGOING MESSAGES RELEASED SUMMARY REPORT                */
/**/
             CALL       PGM(MEC0850)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*MECPYSRC,MEC0841MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC0841MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
ABNOR:
/***COPY*MECPYSRC,MEC0841ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC0841ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('MEC0841 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
/***COPY*MECPYSRC,MEC0841END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC0841END                                          */                   /*CPK024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
