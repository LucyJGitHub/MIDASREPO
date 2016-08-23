/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Mapping Maintenance')                                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU RETAIL UTILITIES                                */
/*                                                                   */
/*       EUC0130  - Mapping Maintenance                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE008             Date 19Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU022 *Create     Date 02Dec97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE008 - Cash Management                                    */
/*       CEU022 - EMU Retail Utilities                               */
/*                                                                   */
/*********************************************************************/
/*********** PGM **************************************/     /*CRE008*/
             PGM        PARM(&EMUM)                          /*CRE008*/
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EMUM)    TYPE(*CHAR) LEN(1)     /*CRE008*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Call EU0120 */
 
/*********** CALL ***** PGM(EU0120) ***********************/ /*CRE008*/
             CALL       PGM(EU0120) PARM(&EMUM)              /*CRE008*/
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
