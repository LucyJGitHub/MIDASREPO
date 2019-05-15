/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Help text control')                          */
/*********************************************************************/
/*                                                                   */
/*  Midas - STANDING DATA MODULE                                     */
/*                                                                   */
/*  YDDSHPR  - STANDING DATA ERROR CONTROL - INTERACTIVE JOBS ONLY   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. XNNNNN             Date XXNnnXX              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       xnnnnn -                                                    */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&PRM01 &PRM02 &PRM03 &PRM04)
 
             DCLF       FILE(YDDSHPR#)
 
             DCL        VAR(&PRM01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRM02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRM03) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRM04) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RTVJOBA    JOB(&JBNM) USER(&USER) NBR(&JBNO) +
                         TYPE(&TYPE)
 
 
             /* If error has occurred in an interactive job          */
             /*  - set up output fields for display                  */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DDDATE)
 
             CHGVAR     VAR(&DDUSER) VALUE(&USER)
             CHGVAR     VAR(&DDWSID) VALUE(&JBNM)
 
             SNDRCVF    RCDFMT(YDDSHPR#F)
 
             ENDPGM
 
/*===================================================================*/
