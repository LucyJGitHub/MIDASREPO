/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Customer documentation maintenance')         */
/********************************************************************/
/*                                                                  */
/*      Midas PORTFOLIO MANAGEMENT MODULE                       */
/*                                                                  */
/*      PMC0160 PM CUSTOMER DOCUMENTATION                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      S01486             Date 05Aug94              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*      S01486  -  Portfolio Management Upgrade to R10              */
/********************************************************************/
/**/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(1)
 
 /* START COMMITMENT CONTROL */
/**********  STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
             MONMSG     MSGID(CPF8351)
 
 /* CALL CUSTOMER DOCUMENTATION PROGRAM */
             CALL       PGM(PM0160) PARM(&PARM1 &PARM2 &PARM3 &PARM4)
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
