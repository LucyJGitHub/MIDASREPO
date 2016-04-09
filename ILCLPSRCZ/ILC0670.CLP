/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Merge Items')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0670  - IBLC 2002 Merge items                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
/***  Start Program.  ***/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
 
/***  Monitor for program errors.  ***/
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             SNDPGMMSG  MSG('ILC0670 - IBLC 2002 - Merge items') +
                          TOMSGQ(MRUNQ)
 
/* Merge IBLC items in MIDAS file */
 
             CPYF       FROMFILE(ILDIINPD) TOFILE(ILITEMPD) +
                        MBROPT(*ADD)
             MONMSG     MSGID(CPF2817)
 
             CLRPFM     FILE(ILDIINPD)
 
/***  IF F&O Module is present (ILSTAT position 18), then merge EOC items.  ***/
 
             IF         COND((%SST(&ILSTAT 18 1)) *EQ 'Y') THEN(DO)
                        SNDPGMMSG  MSG('ILC0670 - IBLC 2002 - Merge EOC items') +
                                   TOMSGQ(MRUNQ)
 
                        CPYF       FROMFILE(ILIEOCPD) TOFILE(ILITEMPD) +
                                   MBROPT(*ADD)
                        MONMSG     MSGID(CPF2817)
 
                        ENDDO
 
                        CLRPFM     FILE(ILIEOCPD)
                        MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message to User alerting failure.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0670 - IBLC 2002 - Items merge    +
                          ended abnormally') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
