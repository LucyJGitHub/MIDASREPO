/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facility history takeon')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LERC30B - Facility history takeon                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO  077925             DATE 20MAR96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       077925 - HISACT & FACACT should be cleared after takeon     */
/*                                                                   */
/*********************************************************************/
 
PGM
/*           DCL        VAR(&LERSTS) TYPE(*CHAR) LEN(128)            */
             DCL VAR(&RUNCHG) TYPE(*DEC) LEN(5 0)
             DCL VAR(&RUNDAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF FILE(SDBANKPD)
             RCVF       RCDFMT(SDBANKD0)
             CHGVAR     VAR(&RUNCHG) VALUE(&BJRDNB)
             CHGVAR     VAR(&RUNDAT) VALUE(&RUNCHG)
 
 
     SNDPGMMSG  MSG('Facility History Takeon') +
                                       TOMSGQ(MRUNQ)
 
/* CLEAR EXTRACT FILES */
 
     CLRPFM HISACT
     CLRPFM FACACT
     CLRPFM FACHISH
     CLRPFM FACHISA
 
 
  /* Call Manual Changes Extract Program */
 
             CALL LER030B
     IF COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)
             CLRPFM FACHISA
             CALL HISTO
 
/* IF THE HISTORY TAKEON HAS COMPLETED NORMALLY THEN THE LAST RUN */
/* DATES FOR THE PROFITABILITY SHOULD BE SET UP HERE FOR FIRST RUN*/
 
/*           IF         COND(%SWITCH(XXXXXX00)) THEN(CHGDTAARA +  */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
              CHGDTAARA   DTAARA(LERSTS (12 5)) VALUE(&RUNDAT)
              CHGDTAARA   DTAARA(LERSTS (97 5)) VALUE(&RUNDAT)
              CHGDTAARA   DTAARA(LERSTS (102 5)) VALUE(&RUNDAT)
              CHGDTAARA   DTAARA(LERSTS (107 5)) VALUE(&RUNDAT)
              CHGDTAARA   DTAARA(LERSTS (112 5)) VALUE(&RUNDAT)
              CHGDTAARA   DTAARA(LERSTS (117 5)) VALUE(&RUNDAT)
/*                                                                      077925*/
/* HISACT & FACACT should now be cleared as their details have          077925*/
/* already been written to FACHISH/FACHISA and if not cleared, the      077925*/
/* first run of LE0032 will double up the entries.                      077925*/
/*                                                                      077925*/
             CLRPFM     FILE(HISACT)                                  /*077925*/
             CLRPFM     FILE(FACACT)                                  /*077925*/
/*                                                                      077925*/
             ENDDO
 
             ELSE       CMD(SNDMSG MSG('JOB TERMINATED, DATABASE IN +
                          ERROR') TOMSGQ(MOPERQ MRUNQ))
 
ERROR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
