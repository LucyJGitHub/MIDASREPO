/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Accounts Post - Spot Trade Hist. CALL')      */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC5345 - GL Accounts Post - Spot Trade Historic Call      */
/*                 (based on GLC35B)                                */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*       Prev Amend XXXXXX                 Date XXXXXXX              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*                                                                   */
/********************************************************************/
 
/* Valid parameters are '1' (Spot Trade Historic & Equiv. Postings,  */
/*                  and '2'  Spot Trade Hist. Revaluation Postings)  */
 
             PGM        PARM(&POSTNUM)
 
             DCL        VAR(&POSTNUM) TYPE(*CHAR) LEN(1)
 
             IF         COND(&POSTNUM *EQ '1') THEN(DO)
                SNDPGMMSG  MSG('ERC5345 - GL Accounts Post - Spot +
                          Trade Historic & Equivalent') TOMSGQ(MRUNQ)
                ENDDO
             ELSE       CMD(DO)
                SNDPGMMSG  MSG('ERC5345 - GL Accounts Post - Spot +
                          Trade Historic Revaluations') TOMSGQ(MRUNQ)
             ENDDO
 
/* Perform Spot Trade Historic Daily Journal                         */
             CALL       PGM(ERC5346) PARM(&POSTNUM)
 
/* Perform Ledger/Cleared Balance Update, then Account Postings      */
             IF         COND(%SWITCH(XXXXXX00)) THEN(TFRCTL +
                          PGM(ERC5347) PARM(&POSTNUM))
 
             ENDPGM
