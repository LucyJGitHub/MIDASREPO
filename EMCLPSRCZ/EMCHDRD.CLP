/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Retrieve jrn seq. no & receiver name')       */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                   */
/*                                                                  */
/*       EMCHDRD - EMCEXX1 READ FOR JRN. SEQUENCE NO.  &            */
/*                 JRN RECEIVER NAME                                */
/*                 CALLED BY EMC0202 DURING CHANGE OF JRN.          */
/*                 RECEIVERS.                                       */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E13205             Date 17/02/89             */
/*                      S01128             Date 00/00/00             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       E13205 - OVERRIDE FILE TO SHARE(*NO)                       * /*E13205*/
/*       S01128 - FIELD JNSQ IN EMCEXX1 CHANGED TO JOSEQN TO        */
/*                  MATCH DEFINITION IN FRF                         */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JNSQ1 &JNRCN1)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCLF       FILE(EMCEXX1)                                 /*E81129*/
             DCL        VAR(&JNSQ1) TYPE(*DEC) LEN(10)                /*E81129*/
             DCL        VAR(&JNRCN1) TYPE(*CHAR) LEN(10)              /*E81129*/
/**/
/*   GLOBAL MONITOR MESSAGE                                        */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* Override file to SHARE(*NO) */                                     /*E13205*/
/**/                                                                  /*E13205*/
             OVRDBF     FILE(EMCEXX1) SHARE(*NO)                      /*E13205*/
           DLYJOB     DLY(30)
OPNDBF     FILE(EMCEXX1) OPTION(*INP)                                 /*E81129*/
             RCVF                                                     /*E81129*/
/****        CHGVAR  VAR(&JNSQ1) VALUE(&JNSQ)    ****/                /*S01128*/
             CHGVAR  VAR(&JNSQ1) VALUE(&JOSEQN)                       /*S01128*/
             CHGVAR  VAR(&JNRCN1) VALUE(&JNRCN)                       /*E81129*/
CLOF       OPNID(EMCEXX1)                                             /*E81129*/
           GOTO ENDTAG                                                /*E81129*/
/**/
ABNOR:       SNDPGMMSG  MSG('PROGRAM - EMCEX HEADER READ +
                         ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
   ENDTAG: ENDPGM
