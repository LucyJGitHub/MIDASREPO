/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Retrieve midas message')                     */
/*********************************************************************/
/*                                                                   */
/*      Midas - History and Audit Facility Module            */
/*                                                                   */
/*      HFC0012 - RETRIEVE MESSAGE FROM MESSAGE FILE                 */
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
/*      PREV AMEND NO. S01379                DATE 29SEP92            */
/*                                           DATE ddmmmyy            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      MD046248 - Finastra Rebranding                               */
/*      S01379  -  New Program for HAF.                              */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &SUBVAR)
 
/*  Copyright Statement Variable  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*  Declare variables */
/**/
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SUBVAR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
/* */
/** Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*  If Substitution Variable is blank do the following */
/**/
             IF         COND(&SUBVAR *EQ ' ') THEN(DO)
              RTVMSG     MSGID(&MSGID) MSGF(MIDASMSG) MSG(&MESSAGE)
              CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                           VALUE(&MESSAGE)
             ENDDO
/* */
/* If Substitution Variable is not blank do the following */
/* */
             IF         COND(&SUBVAR *NE ' ') THEN(DO)
              RTVMSG     MSGID(&MSGID) MSGF(MIDASMSG) MSGDTA(&SUBVAR) +
                           MSG(&MESSAGE)
              CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                           VALUE(&MESSAGE)
             ENDDO
 
/* */
/*  Go to End of Program if ended Normally */
/* */
             GOTO       CMDLBL(END)
 
/* */
/*  End of Program Processing  */
/* */
 
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0012 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
