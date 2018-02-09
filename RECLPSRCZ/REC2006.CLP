/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Outward Clearing Trans. Type List')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Banking.                                     */
/*                                                                   */
/*       REC2006 - Outward Clearing Transaction Types List           */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE023  *CREATE    Date 29Jul05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE023 - 2 O'clock Flag Upgrade to MidasPlus                */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RUNTYP &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
             DCL        VAR(&RUNTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          Terminated - Database in Error')
 
             SNDMSG MSG('Outward Clearing Transaction Types List') TOMSGQ(MRUNQ)
 
             CHGJOB SWS(00000000)
             CALL       PGM(RE2006) PARM(&RSEQ &RUNTYP)
 
             RTVJOBA SWS(&SWS)
             IF COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
                SNDMSG MSG('Outward Clearing Transaction Types List') TOMSGQ(MRUNQ)
             ENDDO
             IF COND(%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)
                SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ)
             ENDDO
             CHGJOB SWS(00000000)
 
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
