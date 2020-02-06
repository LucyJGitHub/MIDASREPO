/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas I/c SWIFT account list prompt')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     SWIFT MODULE                                    */
/*                                                                  */
/*        MSC102P    INPUT CYCLE SWIFT ACCOUNTS LIST PROMPT         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. LN0173             Date 14May90              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     LN0173 - PROGRAM WILL NOT PROGRESS WHEN F12 PRESSED          */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
             DCLF       FILE(MSC102PDF) RCDFMT(MSC102F1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PWSID) TYPE(*CHAR) LEN(10)
/**/
             CHGVAR   VAR(&RCMD) VALUE(' ')                        /*LN0173*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
             RTVJOBA    JOB(&PWSID)
             CHGVAR VAR(&WSID) VALUE(&PWSID)
             SNDRCVF
             CHGVAR     VAR(&RPARM) VALUE(&ANSWR)
             IF         &IN03  CHGVAR   VAR(&RCMD) VALUE('E')
             IF         &IN12  CHGVAR   VAR(&RCMD) VALUE('F')
/**/
             ENDPGM
