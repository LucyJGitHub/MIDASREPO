/*************************************************************/
/*STD    CLPBASE                                             */
/*EXI    TEXT('Midas GL Bal Base Ccy, by Br, GL level-CDL087')       */
/*************************************************************/
/*                                                           */
/*  Midas - General Ledger Module                            */
/*                                                           */
/*  GLC8704 - Midas GL Bal Base Ccy, by Br, GL level         */
/*                                                           */
/*  Parameters: - - &RUNTYPE --  1                           */
/*                  &RSEQ    --  5                           */
/*                  &RENT    --  3                           */
/*                                                           */
/*  (C) Finastra International Limited 2021                  */
/*                                                           */
/*                                                           */
/*  Last Amend No. CDL087  *CREATE    Date 04May21           */
/*  Prev Amend No. XXXXXX             Date DDMMMYY           */
/*                                                           */
/*-----------------------------------------------------------*/
/*                                                           */
/*  CDL087 - Multi Base CCY Spot and Forward Revaluation     */
/*           Upgrade to FM 2.1 2021.A                        */
/*                                                           */
/*************************************************************/
/*                                                           */
/*          C R E A T I O N     P A R A M E T E R S          */
/*                                                           */
/*************************************************************/
/**/
             PGM        PARM(&RUNTYPE &RSEQ &RENT)
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Finastra International Limited 2021')
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/**/
             SNDPGMMSG  MSG('GLC8704 - GL Balances in Local Base Ccy, +
                          by branch, at GL level') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(010001X0)
             CLRPFM     FILE(GLX16)
             CALL       PGM(GL0745) PARM(&RENT)
             OVRDBF     FILE(SGLEX) TOFILE(GLX16)
             CALL       PGM(GL8702) PARM(&RUNTYPE &RSEQ &RENT)
             CHGJOB     SWS(XXXXX0XX)
             DLTOVR     FILE(SGLEX)
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('FILE OUT OF BALANCE - SGLEX') +
                          TOMSGQ(MOPERQ MRUNQ))
/**/
             CHGVAR     VAR(&BISCPY) VALUE('(C) Finastra +
                          International Limited 2021')
/**/
             ENDPGM
