/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Daily items extract list')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0380  - IBLC 2002 Daily items extract list               */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare Data String for Midas Error Message.  ***/
 
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(75)
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/***  Retrieve ILSTAT data area to check if module is selected.  ***/
/***  Pos  1 : COB Run Flag.  ***/
 
             RTVDTAARA  DTAARA(ILSTAT) RTNVAR(&ILSTAT)
             IF         COND((%SST(&ILSTAT 1 1)) *NE 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RTRN) VALUE(' ')
 
/***  Send message to program message queue.  ***/
 
             CHGVAR     VAR(&MSG) VALUE('ILC0380 - IBLC 2002 Items +
                          Extracted Today List.')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
 
/***  Call Program.   ***/
 
             CALL       PGM(IL0380) PARM(&RSEQ &RLEV &RENT)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                        CHGVAR     VAR(&RTRN) VALUE('E')
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message to User alerting failure.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0380 - IBLC 2002 - Items Extracted +
                          Today List Ended Abnormally- see joblog +
                          for details.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&RTRN) VALUE('E')
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
