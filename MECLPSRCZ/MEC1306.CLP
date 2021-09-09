/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1306 - Close Down FT IMM JOB                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. MKCAR9            Date 22Mar06               */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB001 *CREATE     Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       MKCAR9 - New dataarea for storing STP status.               */
/*       CCB001 - CoB Enhancements (Batch Processing)                */
/*                                                                   */
/*********************************************************************/
             PGM

/***COPY*MECPYSRC,MEC1306INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC1306INT                                          */                   /*CPK024*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&NEW_STAT) TYPE(*CHAR) LEN(5)                                 /*MKCAR9*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/***COPY*MECPYSRC,MEC1306MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC1306MPS                                          */                   /*CPK024*/

/*  Close Down FT IMM Job  */

             CALL       PGM(MEC1302) PARM('' 'End' ' ')

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             CHGDTAARA  DTAARA(MESTPSTAT (1 5)) VALUE('STOP ')                            /*MKCAR9*/

/***COPY*MECPYSRC,MEC1306MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC1306MPE                                          */                   /*CPK024*/

             GOTO       CMDLBL(END)

 ABNOR:
/***COPY*MECPYSRC,MEC1306ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC1306ERR                                          */                   /*CPK024*/

             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

             SNDMSG     MSG('Funds Transfer Autogeneration ended +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:

/***COPY*MECPYSRC,MEC1306END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MEC1306END                                          */                   /*CPK024*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

             ENDPGM
