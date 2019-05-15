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
/*       (c) COPYRIGHT Finastra International Limited 2006          */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE045 *Create     Date  10Feb06            */
/* Midas Plus 1.2 ---------------- Base ----------------------------*/
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                             */
/*       CLE045 - Make List of Today's Facilities report            */
/*                Availabale in I/C. Midas Plus upgrade             */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Finastra International Limited 2016')
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
             CHGVAR     VAR(&BISCPY) VALUE('(C) COPYRIGHT Finastra +
                          International Limited 2006')
             ENDPGM
