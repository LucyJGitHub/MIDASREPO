/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Check physical file with DSPFD')             */
/*OVR  : OVRDBF JRNOUT QSYS/QAFDPHY                                 :*/
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0110  - CHECK PHYSICAL FILE                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 15SEP92              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*   Compiler directive for file JRNOUT                              */
/*********************************************************************/
 
             PGM        PARM(&PHYNAM &PHYTXT &PHYRL &PHYOK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PHYNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHYTXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PHYOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PHYRL) TYPE(*DEC) LEN(5)
             DCLF       FILE(JRNOUT)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Clear work file */
/* */
             CLRPFM     FILE(QTEMP/JRNOUT)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Default to file OK */
/* */
             CHGVAR     VAR(&PHYOK) VALUE('Y')
 
/* */
/* Get file description */
/* */
             DSPFD      FILE(&PHYNAM) TYPE(*ATR) OUTPUT(*OUTFILE) +
                          FILEATR(*PF) OUTFILE(QTEMP/JRNOUT)
 
/* */
/* Not found so set to not OK */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&PHYOK) VALUE('N')
               GOTO       CMDLBL(END)
             ENDDO
 
/* */
/* Read details of this file */
/* */
             RCVF
             CHGVAR     VAR(&PHYTXT) VALUE(&PHTXT)
             CHGVAR     VAR(&PHYRL) VALUE(&PHMXRL)
 
/* */
/* If file not journalled then set flag */
/* */
             IF         COND(&PHJRNL *EQ 'N') THEN(DO)
             CHGVAR     VAR(&PHYOK) VALUE('R')
             ENDDO
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0110 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
