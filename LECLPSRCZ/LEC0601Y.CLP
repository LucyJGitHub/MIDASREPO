/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas LE LOANS/PARTS Input Today Report I/C')         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                       */
/*                                                                  */
/*       LEC0601Y - LOANS/PARTICIPATIONS INPUT TODAY                */
/*                                                                  */
/*       (c) COPYRIGHT Finastra International Limited 2006          */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE045 *C *CREATE  Date 10Feb06              */
/* Midas Plus 1.2 ---------------- Base ----------------------------*/
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)         */
/*       CLE045 - Make List of Today's Facilities report            */
/*                Availabale in I/C. Midas Plus upgrade             */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          COPYRIGHT Finastra International Limited 2006')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('LOANS/PARTICIPATIONS INPUT +
                          TODAY REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             OVRDBF     FILE(CLONT) TOFILE(CLOAN) SHARE(*NO)
/**/
             CALL       PGM(LE0310)
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&BISCPY) VALUE('(c) Copyright Finastra +
                          International Limited 2006')
             ENDPGM
