/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Create messages for CGPNARMSG')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGMSGUTL - Set up Multi-Language Posting Narratives         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 109175             Date 16Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       Sxxxxx - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       109175 - Add 00880/881/890/900/910/920/930/940/950/960      */
/*                                                                   */
/*********************************************************************/
   PGM        PARM(&LGID)
 
   DCL        VAR(&LGID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00000') MSGF(CGPNARMSG) MSG('.') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00000') MSGF(CGPNARMSG) MSG('.') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00010') MSGF(CGPNARMSG) MSG('&4 +
                TRADING IMBALANCE &5 &7') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00010') MSGF(CGPNARMSG) MSG('&4 +
                TRADING IMBALANCE &5 &7') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00020') MSGF(CGPNARMSG) MSG('&4 +
                ACCRUAL SUMMARY') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00020') MSGF(CGPNARMSG) MSG('&4 +
                ACCRUAL SUMMARY') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00030') MSGF(CGPNARMSG) +
                MSG('SUS&6&7&8-&9 &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00030') MSGF(CGPNARMSG) +
                MSG('SUS&6&7&8-&9 &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00031') MSGF(CGPNARMSG) +
                MSG('SUS&6&7&8-&9 &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00031') MSGF(CGPNARMSG) +
                MSG('SUS&6&7&8-&9 &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00040') MSGF(CGPNARMSG) MSG('SPOT +
                REVALUATION') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00040') MSGF(CGPNARMSG) MSG('SPOT +
                REVALUATION') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00050') MSGF(CGPNARMSG) MSG('FORWARD +
                REVALUATIONS') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00050') MSGF(CGPNARMSG) MSG('FORWARD +
                REVALUATIONS') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00060') MSGF(CGPNARMSG) MSG('TRANSFER +
                F/C INCOME+EXPENSE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00060') MSGF(CGPNARMSG) MSG('TRANSFER +
                F/C INCOME+EXPENSE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00070') MSGF(CGPNARMSG) +
                MSG('TRANSFER FROM &6&7&8&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00070') MSGF(CGPNARMSG) +
                MSG('TRANSFER FROM &6&7&8&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00080') MSGF(CGPNARMSG) MSG('TRANSFER +
                TO P&L') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00080') MSGF(CGPNARMSG) MSG('TRANSFER +
                TO P&L') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00090') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - BATCH BRANCH') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00090') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - BATCH BRANCH') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00100') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - ENTRIES BRANCH') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00100') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - ENTRIES BRANCH') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00110') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - MAIN/ENTRIES BR') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00110') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - MAIN/ENTRIES BR') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00120') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - MAIN/BATCH BRCH') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00120') MSGF(CGPNARMSG) +
                MSG('INTERBRANCH - MAIN/BATCH BRCH') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00130') MSGF(CGPNARMSG) MSG('Charge +
                for Numbered Account') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00130') MSGF(CGPNARMSG) MSG('Charge +
                for Numbered Account') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00140') MSGF(CGPNARMSG) MSG('No. A/c +
                Charge to SUS &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00140') MSGF(CGPNARMSG) MSG('No. A/c +
                Charge to SUS &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00150') MSGF(CGPNARMSG) MSG('Charge +
                for Hold Mail') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00150') MSGF(CGPNARMSG) MSG('Charge +
                for Hold Mail') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00160') MSGF(CGPNARMSG) MSG('Hold +
                Mail Charge to SUS &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00160') MSGF(CGPNARMSG) MSG('Hold +
                Mail Charge to SUS &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00170') MSGF(CGPNARMSG) +
                MSG('Statement Charges') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00170') MSGF(CGPNARMSG) +
                MSG('Statement Charges') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00180') MSGF(CGPNARMSG) +
                MSG('Fixed Account Charges') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00180') MSGF(CGPNARMSG) +
                MSG('Fixed Account Charges') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00190') MSGF(CGPNARMSG) +
                MSG('Interest Adjustment')   +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00190') MSGF(CGPNARMSG) +
                MSG('Interest Adjustment')   +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00191') MSGF(CGPNARMSG) MSG('Interest +
                Adjustment &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00191') MSGF(CGPNARMSG) MSG('Interest +
                Adjustment &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD    MSGID(&LGID *TCAT '00192') MSGF(CGPNARMSG) MSG('Int Adj +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00192') MSGF(CGPNARMSG) MSG('Int Adj +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00200') MSGF(CGPNARMSG) +
                MSG('Interest') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00200') MSGF(CGPNARMSG) +
                MSG('Interest') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00201') MSGF(CGPNARMSG) MSG('Interest +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00201') MSGF(CGPNARMSG) MSG('Interest +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00202') MSGF(CGPNARMSG) MSG('Interest +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00202') MSGF(CGPNARMSG) MSG('Interest +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00210') MSGF(CGPNARMSG) +
                MSG('Charges') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00210') MSGF(CGPNARMSG) +
                MSG('Charges') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00211') MSGF(CGPNARMSG) MSG('Charges +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00211') MSGF(CGPNARMSG) MSG('Charges +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00212') MSGF(CGPNARMSG) MSG('Charges +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00212') MSGF(CGPNARMSG) MSG('Charges +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD    MSGID(&LGID *TCAT '00220') MSGF(CGPNARMSG) +
                MSG('Accruals') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00220') MSGF(CGPNARMSG) +
                MSG('Accruals') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00221') MSGF(CGPNARMSG) MSG('Accruals +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00221') MSGF(CGPNARMSG) MSG('Accruals +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00222') MSGF(CGPNARMSG) MSG('Accruals +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00222') MSGF(CGPNARMSG) MSG('Accruals +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00230') MSGF(CGPNARMSG) +
                MSG('Closure') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00230') MSGF(CGPNARMSG) +
                MSG('Closure') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00231') MSGF(CGPNARMSG) MSG('Closure +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00231') MSGF(CGPNARMSG) MSG('Closure +
                &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00232') MSGF(CGPNARMSG) MSG('Closure +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00232') MSGF(CGPNARMSG) MSG('Closure +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00240') MSGF(CGPNARMSG) +
                MSG('Withholding Taxes') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00240') MSGF(CGPNARMSG) +
                MSG('Withholding Taxes') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD    MSGID(&LGID *TCAT '00241') MSGF(CGPNARMSG) +
                MSG('Withholding Taxes &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00241') MSGF(CGPNARMSG) +
                MSG('Withholding Taxes &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00242') MSGF(CGPNARMSG) MSG('W/Taxes +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00242') MSGF(CGPNARMSG) MSG('W/Taxes +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00250') MSGF(CGPNARMSG) +
                MSG('Total Debit') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00250') MSGF(CGPNARMSG) +
                MSG('Total Debit') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00251') MSGF(CGPNARMSG) +
                MSG('Total Debit &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00251') MSGF(CGPNARMSG) +
                MSG('Total Debit &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00252') MSGF(CGPNARMSG) MSG('Total DR +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00252') MSGF(CGPNARMSG) MSG('Total DR +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00260') MSGF(CGPNARMSG) +
                MSG('Total Credit') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00260') MSGF(CGPNARMSG) +
                MSG('Total Credit') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00261') MSGF(CGPNARMSG) +
                MSG('Total Credit &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00261') MSGF(CGPNARMSG) +
                MSG('Total Credit &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00262') MSGF(CGPNARMSG) MSG('Total CR +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00262') MSGF(CGPNARMSG) MSG('Total CR +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD  MSGID(&LGID *TCAT '00270') MSGF(CGPNARMSG) MSG('Total CR +
                Subject to Tax') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT '00270') MSGF(CGPNARMSG) MSG('Total CR +
                Subject to Tax') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD* MSGID(&LGID *TCAT '00271') MSGF(CGPNARMSG) MSG('Total CR +
                Subj Tax &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT '00271') MSGF(CGPNARMSG) MSG('Total CR +
                Subj Tax &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT '00272') MSGF(CGPNARMSG) MSG('Subj Tax +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT '00272') MSGF(CGPNARMSG) MSG('Subj Tax +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD* MSGID(&LGID *TCAT '00280') MSGF(CGPNARMSG) MSG('Total CR +
                Not Subject to Tax') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT '00280') MSGF(CGPNARMSG) MSG('Total CR +
                Not Subject to Tax') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00281') MSGF(CGPNARMSG) MSG('Tot. CR +
                Not Subj &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00281') MSGF(CGPNARMSG) MSG('Tot. CR +
                Not Subj &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00282') MSGF(CGPNARMSG) MSG('No Tax +
                CR &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00282') MSGF(CGPNARMSG) MSG('No Tax +
                CR &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00290') MSGF(CGPNARMSG) MSG('Basic +
                Rate Tax on Interest') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00290') MSGF(CGPNARMSG) MSG('Basic +
                Rate Tax on Interest') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00291') MSGF(CGPNARMSG) MSG('BRT +
                Interest on &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00291') MSGF(CGPNARMSG) MSG('BRT +
                Interest on &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT '00292') MSGF(CGPNARMSG) MSG('BRT Int. +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT '00292') MSGF(CGPNARMSG) MSG('BRT Int. +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00300') MSGF(CGPNARMSG) MSG('Fixed +
                Commission') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00300') MSGF(CGPNARMSG) MSG('Fixed +
                Commission') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00301') MSGF(CGPNARMSG) MSG('Fixed +
                Commission &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00301') MSGF(CGPNARMSG) MSG('Fixed +
                Commission &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00302') MSGF(CGPNARMSG) MSG('Fixed +
                Com &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00302') MSGF(CGPNARMSG) MSG('Fixed +
                Com &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00310') MSGF(CGPNARMSG) MSG('Account +
                Commission') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00310') MSGF(CGPNARMSG) MSG('Account +
                Commission') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00311') MSGF(CGPNARMSG) MSG('Account +
                commission &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00311') MSGF(CGPNARMSG) MSG('Account +
                commission &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00312') MSGF(CGPNARMSG) MSG('A/C Com. +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00312') MSGF(CGPNARMSG) MSG('A/C Com. +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00320') MSGF(CGPNARMSG) +
                MSG('Commission on Debit Interest') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00320') MSGF(CGPNARMSG) +
                MSG('Commission on Debit Interest') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00321') MSGF(CGPNARMSG) MSG('DR +
                Interest Comm. &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00321') MSGF(CGPNARMSG) MSG('DR +
                Interest Comm. &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00322') MSGF(CGPNARMSG) MSG('Int Com. +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00322') MSGF(CGPNARMSG) MSG('Int Com. +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00330') MSGF(CGPNARMSG) +
                MSG('Commission on Highest O''draft') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00330') MSGF(CGPNARMSG) +
                MSG('Commission on Highest O''draft') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00331') MSGF(CGPNARMSG) +
                MSG('Highest O''Draft Com &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00331') MSGF(CGPNARMSG) +
                MSG('Highest O''Draft Com &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00332') MSGF(CGPNARMSG) MSG('H/O +
                Comm. &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00332') MSGF(CGPNARMSG) MSG('H/O +
                Comm. &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00340') MSGF(CGPNARMSG) +
                MSG('Inactive Account Charge') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00340') MSGF(CGPNARMSG) +
                MSG('Inactive Account Charge') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD* MSGID(&LGID *TCAT '00341') MSGF(CGPNARMSG) MSG('Inactive +
                A/C Charge &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT '00341') MSGF(CGPNARMSG) MSG('Inactive +
                A/C Charge &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00342') MSGF(CGPNARMSG) +
                MSG('Inact.Chg &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00342') MSGF(CGPNARMSG) +
                MSG('Inact.Chg &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00350') MSGF(CGPNARMSG) MSG('Minimum +
                Balance Commission') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00350') MSGF(CGPNARMSG) MSG('Minimum +
                Balance Commission') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00351') MSGF(CGPNARMSG) MSG('Min +
                Balance Comm. &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00351') MSGF(CGPNARMSG) MSG('Min +
                Balance Comm. &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00352') MSGF(CGPNARMSG) MSG('Min. +
                Com. &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00352') MSGF(CGPNARMSG) MSG('Min. +
                Com. &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00360') MSGF(CGPNARMSG) MSG('Turnover +
                Statement Charge') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00360') MSGF(CGPNARMSG) MSG('Turnover +
                Statement Charge') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00361') MSGF(CGPNARMSG) MSG('Extra +
                Stmt Charge &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00361') MSGF(CGPNARMSG) MSG('Extra +
                Stmt Charge &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '00362') MSGF(CGPNARMSG) MSG('Stmt Chg +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '00362') MSGF(CGPNARMSG) MSG('Stmt Chg +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*ADDMSGD*MSGID(&LGID *TCAT '00370') MSGF(CGPNARMSG) MSG('** VAT **') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
  ADDMSGD MSGID(&LGID *TCAT '00370') MSGF(CGPNARMSG) MSG('** VAT **') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD* MSGID(&LGID *TCAT '00371') MSGF(CGPNARMSG) MSG('** VAT +
                ** &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT '00371') MSGF(CGPNARMSG) MSG('** VAT +
                ** &25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00372') MSGF(CGPNARMSG) MSG('** VAT +
                ** &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00372') MSGF(CGPNARMSG) MSG('** VAT +
                ** &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00375') MSGF(CGPNARMSG) +
                MSG('                                       +
                RATE CHANGE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00375') MSGF(CGPNARMSG) +
                MSG('                                       +
                RATE CHANGE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT '00380') MSGF(CGPNARMSG) MSG('ACCR.A/C +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT '00380') MSGF(CGPNARMSG) MSG('ACCR.A/C +
                &5-&6&7&8-&9') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00390') MSGF(CGPNARMSG) +
                MSG('SETTLEMENT EXERCISE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00390') MSGF(CGPNARMSG) +
                MSG('SETTLEMENT EXERCISE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00400') MSGF(CGPNARMSG) +
                MSG('SETTLEMENT TRADE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00400') MSGF(CGPNARMSG) +
                MSG('SETTLEMENT TRADE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD* MSGID(&LGID *TCAT '00410') MSGF(CGPNARMSG) MSG('INTERNAL +
                BOOK - &23') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT '00410') MSGF(CGPNARMSG) MSG('INTERNAL +
                BOOK - &23') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00420') MSGF(CGPNARMSG) MSG('&4 +
                INTERBCH &1 &24') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00420') MSGF(CGPNARMSG) MSG('&4 +
                INTERBCH &1 &24') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00430') MSGF(CGPNARMSG) MSG('POSN. +
                SETTLEMENT RE &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00430') MSGF(CGPNARMSG) MSG('POSN. +
                SETTLEMENT RE &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00440') MSGF(CGPNARMSG) +
                MSG('TAX DEDUCTED BY USER') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00440') MSGF(CGPNARMSG) +
                MSG('TAX DEDUCTED BY USER') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*  BEGIN 109175  */
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00880') MSGF(CGPNARMSG) +
                MSG('TTRAN_&1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00880') MSGF(CGPNARMSG) +
                MSG('TTRAN_&1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00881') MSGF(CGPNARMSG) +
                MSG('TTRAN_&1_A/C_&25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00881') MSGF(CGPNARMSG) +
                MSG('TTRAN_&1_A/C_&25') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00890') MSGF(CGPNARMSG) +
                MSG('CASH_WDR_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00890') MSGF(CGPNARMSG) +
                MSG('CASH_WDR_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00900') MSGF(CGPNARMSG) +
                MSG('CHEQ_WDR_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00900') MSGF(CGPNARMSG) +
                MSG('CHEQ_WDR_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00910') MSGF(CGPNARMSG) +
                MSG('CASH_DEP_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00910') MSGF(CGPNARMSG) +
                MSG('CASH_DEP_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00920') MSGF(CGPNARMSG) +
                MSG('CHEQ_DEP_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00920') MSGF(CGPNARMSG) +
                MSG('CHEQ_DEP_&7_&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00930') MSGF(CGPNARMSG) +
                MSG('&1_FX - BUY    ') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00930') MSGF(CGPNARMSG) +
                MSG('&1_FX - BUY    ') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00940') MSGF(CGPNARMSG) +
                MSG('&1_FX - SELL   ') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00940') MSGF(CGPNARMSG) +
                MSG('&1_FX - SELL   ') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00950') MSGF(CGPNARMSG) +
                MSG('&1_FX - CHARGE ') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00950') MSGF(CGPNARMSG) +
                MSG('&1_FX - CHARGE ') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '00960') MSGF(CGPNARMSG) +
                MSG('BATCH NO. &1 OFFSET') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '00960') MSGF(CGPNARMSG) +
                MSG('BATCH NO. &1 OFFSET') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*   END  109175  */
 
/*         */
/**ADDMSGD*   MSGID(&LGID *TCAT '01000') MSGF(CGPNARMSG) MSG('&10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '01000') MSGF(CGPNARMSG) MSG('&10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '02000') MSGF(CGPNARMSG) MSG('&1 +
                &7&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '02000') MSGF(CGPNARMSG) MSG('&1 +
                &7&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '03000') MSGF(CGPNARMSG) MSG('&1 +
                &7&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '03000') MSGF(CGPNARMSG) MSG('&1 +
                &7&11') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT '04000') MSGF(CGPNARMSG) MSG('&1 DEP +
                INC TO &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT '04000') MSGF(CGPNARMSG) MSG('&1 DEP +
                INC TO &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '05000') MSGF(CGPNARMSG) MSG('&1 DEP +
                REPAY VAL &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '05000') MSGF(CGPNARMSG) MSG('&1 DEP +
                REPAY VAL &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(GB06000) MSGF(CGPNARMSG) MSG('&1 INT +
                DUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(GB06000) MSGF(CGPNARMSG) MSG('&1 INT +
                DUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '07000') MSGF(CGPNARMSG) MSG('&1 INT +
                &4 - &5') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '07000') MSGF(CGPNARMSG) MSG('&1 INT +
                &4 - &5') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '08000') MSGF(CGPNARMSG) MSG('&1 INT +
                PAY VAL &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '08000') MSGF(CGPNARMSG) MSG('&1 INT +
                PAY VAL &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '09000') MSGF(CGPNARMSG) MSG('&1 PURC +
                TO YLD &13') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '09000') MSGF(CGPNARMSG) MSG('&1 PURC +
                TO YLD &13') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '10000') MSGF(CGPNARMSG) MSG('&1 SALE +
                VALUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '10000') MSGF(CGPNARMSG) MSG('&1 SALE +
                VALUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '11000') MSGF(CGPNARMSG) MSG('&1 INT +
                TO &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '11000') MSGF(CGPNARMSG) MSG('&1 INT +
                TO &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '11001') MSGF(CGPNARMSG) MSG('&14 INT +
                TO &3 &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '11001') MSGF(CGPNARMSG) MSG('&14 INT +
                TO &3 &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '13000') MSGF(CGPNARMSG) MSG('&1 PROF +
                VALUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '13000') MSGF(CGPNARMSG) MSG('&1 PROF +
                VALUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '15000') MSGF(CGPNARMSG) MSG('&1 LOSS +
                VALUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '15000') MSGF(CGPNARMSG) MSG('&1 LOSS +
                VALUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '17000') MSGF(CGPNARMSG) MSG('&1 NEW +
                RATE &12') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '17000') MSGF(CGPNARMSG) MSG('&1 NEW +
                RATE &12') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '21000') MSGF(CGPNARMSG) MSG('&1 LOAN +
                TO  &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '21000') MSGF(CGPNARMSG) MSG('&1 LOAN +
                TO  &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '22000') MSGF(CGPNARMSG) MSG('&1 LOAN +
                REPAY VAL  &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '22000') MSGF(CGPNARMSG) MSG('&1 LOAN +
                REPAY VAL  &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '23000') MSGF(CGPNARMSG) MSG('&1 INT +
                DUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '23000') MSGF(CGPNARMSG) MSG('&1 INT +
                DUE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '24000') MSGF(CGPNARMSG) MSG('&1 INT +
                &2 - &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '24000') MSGF(CGPNARMSG) MSG('&1 INT +
                &2 - &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '25000') MSGF(CGPNARMSG) MSG('&1 DISC +
                LOAN TO &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '25000') MSGF(CGPNARMSG) MSG('&1 DISC +
                LOAN TO &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '26000') MSGF(CGPNARMSG) MSG('&1 +
                INTEREST ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '26000') MSGF(CGPNARMSG) MSG('&1 +
                INTEREST ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '27000') MSGF(CGPNARMSG) MSG('&1 +
                DIS/PREM ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '27000') MSGF(CGPNARMSG) MSG('&1 +
                DIS/PREM ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '28000') MSGF(CGPNARMSG) MSG('&1 +
                INTEREST TAX') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '28000') MSGF(CGPNARMSG) MSG('&1 +
                INTEREST TAX') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '29000') MSGF(CGPNARMSG) MSG('&1 +
                INTEREST TAX') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '29000') MSGF(CGPNARMSG) MSG('&1 +
                INTEREST TAX') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '30000') MSGF(CGPNARMSG) MSG('&1 C/F +
                &2 - &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '30000') MSGF(CGPNARMSG) MSG('&1 C/F +
                &2 - &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '31000') MSGF(CGPNARMSG) MSG('&1 +
                PRINCIPAL DIFF &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '31000') MSGF(CGPNARMSG) MSG('&1 +
                PRINCIPAL DIFF &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '32000') MSGF(CGPNARMSG) MSG('&1 COMM +
                FEE ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '32000') MSGF(CGPNARMSG) MSG('&1 COMM +
                FEE ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '33000') MSGF(CGPNARMSG) +
                MSG('UNREALISED P/L &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '33000') MSGF(CGPNARMSG) +
                MSG('UNREALISED P/L &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '34000') MSGF(CGPNARMSG) +
                MSG('COMM FEE ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '34000') MSGF(CGPNARMSG) +
                MSG('COMM FEE ACCRUED') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '35000') MSGF(CGPNARMSG) +
                MSG('PRINCIPAL INCREASE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '35000') MSGF(CGPNARMSG) +
                MSG('PRINCIPAL INCREASE &3') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '36000') MSGF(CGPNARMSG) +
                MSG('MGMT FEE &15') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '36000') MSGF(CGPNARMSG) +
                MSG('MGMT FEE &15') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '44000') MSGF(CGPNARMSG) +
                MSG('&16 &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '44000') MSGF(CGPNARMSG) +
                MSG('&16 &1') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '45000') MSGF(CGPNARMSG) MSG('INTEREST +
                ON &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '45000') MSGF(CGPNARMSG) MSG('INTEREST +
                ON &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '46000') MSGF(CGPNARMSG) MSG('COUPON +
                RE &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '46000') MSGF(CGPNARMSG) MSG('COUPON +
                RE &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '47000') MSGF(CGPNARMSG) MSG('&1 +
                SETTLEMENT RE &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '47000') MSGF(CGPNARMSG) MSG('&1 +
                SETTLEMENT RE &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '48000') MSGF(CGPNARMSG) MSG('&1 +
                SETTLEMENT RE &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '48000') MSGF(CGPNARMSG) MSG('&1 +
                SETTLEMENT RE &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT '49000') MSGF(CGPNARMSG) MSG('&1 +
                DISCREPANCY &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT '49000') MSGF(CGPNARMSG) MSG('&1 +
                DISCREPANCY &6') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*  MSGID(&LGID *TCAT '50000') MSGF(CGPNARMSG) MSG('REALISED +
                P/L RE &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD   MSGID(&LGID *TCAT '50000') MSGF(CGPNARMSG) MSG('REALISED +
                P/L RE &16') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD* MSGID(&LGID *TCAT 'FA000') MSGF(CGPNARMSG) MSG('&1 &10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD  MSGID(&LGID *TCAT 'FA000') MSGF(CGPNARMSG) MSG('&1 &10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*ADDMSGD*MSGID(&LGID *TCAT 'FB000') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                &10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
  ADDMSGD MSGID(&LGID *TCAT 'FB000') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                &10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*ADDMSGD*MSGID(&LGID *TCAT 'FC000') MSGF(CGPNARMSG) MSG('&18 &19 &10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
ADDMSGD MSGID(&LGID *TCAT 'FC000') MSGF(CGPNARMSG) MSG('&18 &19 &10') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT 'FD000') MSGF(CGPNARMSG) MSG('&1 +
                COMMISSION') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT 'FD000') MSGF(CGPNARMSG) MSG('&1 +
                COMMISSION') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT 'FE000') MSGF(CGPNARMSG) MSG('&1 +
                CHARGES DUE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT 'FE000') MSGF(CGPNARMSG) MSG('&1 +
                CHARGES DUE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT 'FF000') MSGF(CGPNARMSG) MSG('&1 +
                PREMIUM DUE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT 'FF000') MSGF(CGPNARMSG) MSG('&1 +
                PREMIUM DUE') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*   MSGID(&LGID *TCAT 'F1001') MSGF(CGPNARMSG) MSG('&1 +
                EXERCISE OPTION') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD    MSGID(&LGID *TCAT 'F1001') MSGF(CGPNARMSG) MSG('&1 +
                EXERCISE OPTION') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**DDMSGD *SGID(&LGID *TCAT 'F2001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                MARGIN CALL') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
  ADDMSGD MSGID(&LGID *TCAT 'F2001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                MARGIN CALL') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*ADDMSGD*MSGID(&LGID *TCAT 'F3001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                REALISED PROFIT') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
 ADDMSGD MSGID(&LGID *TCAT 'F3001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                REALISED PROFIT') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*ADDMSGD*MSGID(&LGID *TCAT 'F4001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                REALISED LOSS') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
 ADDMSGD MSGID(&LGID *TCAT 'F4001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                REALISED LOSS') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD MSGID(&LGID *TCAT 'F5001') MSGF(CGPNARMSG) MSG('&18 &17') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT 'F5001') MSGF(CGPNARMSG) MSG('&18 &17') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/*ADDMSGD*MSGID(&LGID *TCAT 'F6001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                &21 &22') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
ADDMSGD MSGID(&LGID *TCAT 'F6001') MSGF(CGPNARMSG) MSG('&18 &19 &20 +
                &21 &22') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT 'F7001') MSGF(CGPNARMSG) MSG('&18 &17 +
                &20') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT 'F7001') MSGF(CGPNARMSG) MSG('&18 &17 +
                &20') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT 'F8001') MSGF(CGPNARMSG) MSG('&1 &17') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT 'F8001') MSGF(CGPNARMSG) MSG('&1 &17') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
/**ADDMSGD*MSGID(&LGID *TCAT 'F9001') MSGF(CGPNARMSG) MSG('&18 &19') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 4) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
   ADDMSGD MSGID(&LGID *TCAT 'F9001') MSGF(CGPNARMSG) MSG('&18 &19') +
                 FMT((*CHAR 16) (*CHAR 7)  (*CHAR 7)  (*CHAR 2) +
                     (*CHAR 3)  (*CHAR 6)  (*CHAR 3)  (*CHAR 10) +
                     (*CHAR 2)  (*CHAR 20) (*CHAR 21) (*CHAR 14) +
                     (*CHAR 14) (*CHAR 6)  (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 20) (*CHAR 2)  (*CHAR 3)  (*CHAR 5) +
                     (*CHAR 1)  (*CHAR 15) (*CHAR 2)  (*CHAR 10) +
                     (*CHAR 10))                                                          /*CGL029*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
