/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL0113P Report')                                */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GL0113C - COMPONENT FOR OVERALL CURRENCY TOTALS REPORT     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    LAST AMEND NO. RT0032             DATE 21MAY91                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*    RT0032  -  THIS PROGRAM IS NOW CALLED VIA FCC0200 WHICH       */
/*               CREATES DTAARA/LDA THEREFORE THIS PGM SHOULD       */
/*               MONITOR FOR IT ALREADY BEING PRESENT.              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
PGM  PARM(&PGM &SEQ &LEVEL &ENTITY)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
   DCL  VAR(&PGM)    TYPE(*CHAR)  LEN(8)
   DCL  VAR(&SEQ)    TYPE(*CHAR)  LEN(5)
   DCL  VAR(&LEVEL)  TYPE(*CHAR)  LEN(1)
   DCL  VAR(&ENTITY) TYPE(*CHAR)  LEN(3)
   DCL  VAR(&RTNCD)  TYPE(*CHAR)  LEN(7)
   DCL  VAR(&MSG)    TYPE(*CHAR)  LEN(75)
   DCL  VAR(&SWS)    TYPE(*CHAR)  LEN(8)
 
   CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
   MONMSG     MSGID(CPF1023)                                          /*RT0032*/
   CALL  PGM(&PGM)  PARM(&RTNCD  &SEQ)
   MONMSG  MSGID(CPF0001)  EXEC(DO)
      CHGVAR  VAR(&MSG)  VALUE('Error on call to program' *BCAT &PGM)
      SNDPGMMSG  TOMSGQ(MRUNQ MOPERQ)  MSG(&MSG)
   ENDDO
 
   RTVJOBA  SWS(&SWS)
 
   IF  (%SST(&SWS 7 2) *EQ '11') THEN(DO)
      CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE IN ERROR')
      SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)
   ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
