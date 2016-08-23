/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FC I/C Init. Requests interact. pgm')           */
/*********************************************************************/
/*                                                                   */
/*      Midas - Report Control Facility Module               */
/*                                                                   */
/*      FCC0200A- APPLY OVERRIDES FOR REQUESTED IN THE COB           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      LAST AMEND NO. E00000                DATE DDMMMYY            */
/*      PREV AMEND NO.                       DATE DDMMMYY            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*  E00000 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROGRAM &CHNEXSEQ &LEVEL &ENTITY +
                          &LONGPARMS &PGRPG &CLSEQ)
 
/*  REPORT PROGRAM PROCESSING VARIABLES  */
 
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHNEXSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
/*/COPY WNCPYSRC,FCC0200A01                                          */
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PARACOMP) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,FCC0200A02                                          */
             DCL        VAR(&PGRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CLSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,FCC0200A03                                          */
             DCL        VAR(&LONGPARMS) TYPE(*CHAR) LEN(101)
/*/COPY WNCPYSRC,FCC0200A04                                          */
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(260)
             DCL        VAR(&APOST) TYPE(*CHAR) LEN(1) VALUE('''')
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*  GLOBAL MONITOR MESSAGE  */
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*  CREATE DTAARA/LDA  */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('LOCAL DATA AREA FOR FCC0200A') +
                          AUT(*USE)
             MONMSG     MSGID(CPF1023)
 
/*  CALL FC0030A TO ACCESS THE REPORT PARAMETERS  */
 
             CALL       PGM(FC0030A) PARM(&PROGRAM &CLSEQ &PARMS)
 
/*  OBTAIN THE REPORT PROMPT PARAMETER STRING  */
 
/*/COPY WNCPYSRC,FCC0200A05                                          */
             CHGVAR     VAR(&PARAMETERS) VALUE(%SST(&LONGPARMS 1 100))
/*/COPY WNCPYSRC,FCC0200A06                                          */
 
/*  SETUP CALL COMMAND FOR QCMDEXC  */
 
/*  IF THE REPORT HAS A PROMPT THEN ADD THE PROMPTS TO THE CMD  */
 
             IF         COND(&PARAMETERS *NE &PARACOMP) THEN(DO)
 
/*/COPY WNCPYSRC,FCH00005                                            */
                CHGVAR     VAR(&STRING) VALUE('CALL PGM(' *CAT +
                             &PROGRAM *CAT ')' *BCAT 'PARM(' *CAT +
                             &PARMS *BCAT &APOST *CAT &CHNEXSEQ *CAT +
                             &APOST *BCAT &LEVEL *BCAT &APOST *CAT +
                             &ENTITY *CAT &APOST *BCAT &APOST *CAT +
                             &PARAMETERS *CAT &APOST *CAT ')')
/*/COPY WNCPYSRC,FCH00006                                            */
 
             ENDDO
 
/*  IF THE REPORT HAS NO PROMPT THEN IGNORE &PARAMETERS  */
 
             IF         COND(&PARAMETERS *EQ &PARACOMP) THEN(DO)
 
/*/COPY WNCPYSRC,FCH00007                                            */
                CHGVAR     VAR(&STRING) VALUE('CALL PGM(' *CAT +
                             &PROGRAM *CAT ')' *BCAT 'PARM(' *CAT +
                             &PARMS *BCAT &APOST *CAT &CHNEXSEQ *CAT +
                             &APOST *BCAT &LEVEL *BCAT &APOST *CAT +
                             &ENTITY *CAT &APOST *CAT ')')
/*/COPY WNCPYSRC,FCH00008                                            */
 
             ENDDO
 
/*  CALL REPORT PROGRAM VIA QCMDEXC  */
 
             CALL       PGM(QCMDEXC) PARM(&STRING 260)
 
/*  IF THERE HAVE BEEN NO ERRORS UP TO THIS POINT THEN SKIP ABNOR  */
 
             GOTO       CMDLBL(ENDPGM)
 
/*  ABNOR PROCESSING  */
 
/*  SEND ABNORMAL TERMINATION MESSAGE  */
 
 ABNOR:      SNDPGMMSG  MSGID(RCF1088) MSGF(FCUSRMSG) +
                          MSGDTA(&CHNEXSEQ) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*  END OF PROGRAM PROCESSING  */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
 
             ENDPGM
