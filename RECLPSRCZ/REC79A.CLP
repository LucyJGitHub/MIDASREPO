/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas¦ABS Restricted Retail Accounts Excess Report')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC79A - RESTRICTED RETAIL EXCESS REPORT                    */
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
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             SNDPGMMSG MSG('REC79A - Restricted Retail Excess Report') +
                       TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(XXXXXXX0)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
             OVRDBF FILE(SODAC) TOFILE(ODACON) SHARE(*YES)
/**/
             OPNQRYF    FILE(ODACON) FORMAT(*FILE) +
                          QRYSLT('ZZ040 *NE " "') +
                          KEYFLD((BRCA) (ZZ040) (ACOC) +
                          (CNUM) (CCY) (ACOD) (ACSQ)) +
                          IGNDECERR(*YES)
/**/
             CALL PGM(RE0790A)
/**/
             DLTOVR FILE(*ALL)
             CLOF   OPNID(ODACON)
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
               RTVDTAARA DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             RCLRSC
             CHGVAR     VAR(&MKICPY) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             ENDPGM
/**/
