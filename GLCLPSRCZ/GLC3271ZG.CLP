/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Generate Extension File')                       */
/*********************************************************************/
/*                                                                   */
/*  Midas   Retail 3 Module                                  */
/*                                                                   */
/*  GLC3271ZG - GENERATE EXTENSION RECORDS FILE                      */
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
/*  PREV AMEND NO. S01413 *CREATE          DATE 13APR93              */
/*                 xnnnnn                  DATE nnxxxnn              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  MD046248 - Finastra Rebranding                                   */
/*  S01413 - Retail 3 Incorporation                                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
 
/* Global monitor message error trap                                 */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(MONTAG))
 
             GOTO       CMDLBL(RUN)
 
 MONTAG:     DMPCLPGM
             RETURN
 
/* Reset external switches                                           */
 
 RUN:        CHGJOB     SWS(XXXXXX00)
 
             CLRPFM     FILE(ACCNTBXC)
 
             CALL       PGM(GL3271ZG)
 
/* Data base error processing                                        */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                       TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:     ENDPGM
