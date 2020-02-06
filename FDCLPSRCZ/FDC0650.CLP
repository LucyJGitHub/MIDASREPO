/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD SD Deal type/subtype Audit Report')          */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/*       FDC0650 - DEAL TYPE/SUBTYPE AUDIT LISTING                  */
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
/*       Prev Amend No. 048557             Date 18Mar93              */
/*                      AUS011             Date 18Jun92              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*   048557 - THIS IS ON REQUEST AND SHOULD BE CODED ACCORDINGLY    */
/*       AUS011 - AUSTRALIAN PRODUCT - DEAL TYPE/SUBTYPE            */
/*                VALIDATION                                        */
/*                                                                  */
/********************************************************************/
/*/                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* SET UP PGM MESSAGE */
/**/
             CHGVAR     VAR(&MSG) VALUE('FDC0650 - Deal type/subtype +
                          Audit List')
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
/* CALL THE PROGRAM */
/**/
/*********   CALL       PGM(FD0650P) PARM(' ' 'A' &RSEQ &RLVL &RENT)    048557*/
             CALL       PGM(FD0650P) PARM(' ' 'R' &RSEQ &RLVL &RENT)  /*048557*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:         ENDPGM
