/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas LE Facilities Input Today Report I/C')          */
/********************************************************************/
/*                                                                  */
/*        Midas - Customer Lending Module                           */
/*                                                                  */
/*       LEC0601X - FACILITIES INPUT TODAY                          */
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
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT Finastra International Limited 2006')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('FACILITIES INPUT TODAY REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             CALL       PGM(LE0300)
/**/
             CHGVAR     VAR(&BISCPY) VALUE('(C) Copyright Finastra +
                          International Limited 2006')
             ENDPGM
