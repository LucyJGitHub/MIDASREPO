/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Template reports no prompt')                 */
/********************************************************************/
/*                                                                  */
/*       Midas     GENERAL LEDGER MODULE                        */
/*                                                                  */
/*       GL0103C - GL REPORTS NO PROMPT                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*    Last Amend No. 244686             Date 23Feb07                 */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    Prev Amend No. S01340             Date 21Feb92                 */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*    244686 - Added missing fields to GLJESHPD which CAP086        */
/*             and CSC024 introduced to GZGLJENHPD in order for the */
/*             2 files to be synchronized. (Recompile only)         */
/*    S01340 - NEW PROGRAM FOR RELEASE 10 MIS CHANGES               */
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
 
   OVRDBF     FILE(GLJENHL1) TOFILE(GLJESHL1)
   OVRDBF     FILE(GLJENPL3) TOFILE(GLJESPL3)
 
   CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
   MONMSG     MSGID(CPF1023)
   CALL  PGM(&PGM)  PARM(&RTNCD  &SEQ  &LEVEL &ENTITY)
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
