/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas¦ABS Restricted Retail Account Balances')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3772A -  RESTRICTED RETAIL ACCOUNTS BALANCES EXTRACT     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE024   *CREATE   Date 07Oct05              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE024 - COUNTRY LEVEL SWITCHABLE FEATURE :                 */
/*                SECURITY FEATURES FOR RESTRICTED ACCOUNTS          */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             SNDPGMMSG  MSG('REC3772A - Restricted Retail Account +
                             Balances Report') TOMSGQ(MRUNQ)
             CHGJOB SWS(00000000)
/**/
             OVRDBF FILE(RETACOQ) TOFILE(RETACRPA) SHARE(*YES)
/**/
             OPNQRYF    FILE((RETACRPA)) FORMAT(*FILE) +
                          KEYFLD((BRCA) (ZZ020) (CNUM) +
                                 (CCY) (ACOD) (ACSQ)) +
                          IGNDECERR(*YES)
/**/
             CALL PGM(RE3772A)
/**/
             DLTOVR FILE(*ALL)
             CLOF OPNID(RETACRPA)
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   RTVDTAARA DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                             TOMSGQ(MOPERQ MRUNQ)
                   GOTO CMDLBL(END)
                ENDDO
/**/
             CLRPFM FILE(RETACRPA)
/**/
END:
             CHGVAR     VAR(&MKICPY) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             ENDPGM
/**/
