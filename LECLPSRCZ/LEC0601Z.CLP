/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas LE LOAN AMENDS Input Today Report I/C')         */
/********************************************************************/
/*                                                                  */
/*        Midas - Customer Lending Module                           */
/*                                                                  */
/*       LEC0601Z - Loan Amendments, Repayments and Manual          */
/*                  Repayments Input Today report                   */
/*                                                                  */
/*       (c) COPYRIGHT Misys Banking Systems 2006                   */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE045 *Create     Date  10Feb06            */
/* Midas Plus 1.2 ---------------- Base ----------------------------*/
/*                                                                  */
/********************************************************************/
/*       CLE045 - Make List of Today's Facilities report            */
/*                Availabale in I/C. Midas Plus upgrade             */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Misys Banking Systems 2006')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('LOAN AMENDMENTS AND REPAYMENTS +
                          INPUT TODAY REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             OVRDBF     FILE(LOAMST) TOFILE(LOAMS) SHARE(*NO)
/**/
             CALL       PGM(LE0320)
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&BISCPY) VALUE('(C) COPYRIGHT Misys +
                          Banking Systems 2006')
             ENDPGM
