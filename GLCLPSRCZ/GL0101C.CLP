/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL reports with prompt')                        */
/********************************************************************/
/*                                                                  */
/*       Midas     GENERAL LEDGER MODULE                        */
/*                                                                  */
/*       GL0101C - GL REPORTS WITH PROMPT                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    LAST AMEND NO. BHF960           DATE 25APR91                  */
/*    PREV AMEND NO. LN0855           DATE 15OCT90                  */
/*                   LN0832           DATE 03OCT90                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*    BHF960 - DATA AREA LDA NOT FOUND(ADD MONMSG CPF1023)          */
/*    LN0855 - CREATE DATA AREA LDA FOR SUBMITTED JOB               */
/*    LN0832 - REPORTS NO LONGER USE THE DATA AREA GLBHNO           */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*PGM  PARM(&PGM &SEQ &LEVEL &ENTITY)                                   LN0832*/
PGM  PARM(&PGM &SEQ &LEVEL &ENTITY &BTNB)                             /*LN0832*/
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
   DCL        VAR(&BTNB) TYPE(*CHAR) LEN(3)
 
/* RTVDTAARA  DTAARA(GLBHNO (1 3)) RTNVAR(&BTNB)                        LN0832*/
   CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                  /*LN0855*/
   MONMSG     MSGID(CPF1023)                                          /*BHF960*/
 
   CALL  PGM(&PGM)  PARM(&RTNCD  &BTNB  &SEQ  &LEVEL  &ENTITY)
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
