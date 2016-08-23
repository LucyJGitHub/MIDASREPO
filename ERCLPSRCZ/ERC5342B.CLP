/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Copy ACPO5 in EODPONR')                         */
/********************************************************************/
/*                                                                  */
/*       MIDAS/ABS EUROPEAN REPORTING SYSTEM                        */
/*                                                                  */
/*       ERC5342B - Copy ACPO5 in EODPO2PD                          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ER0311 ADS         Date 28Jan93              */
/*                      ER0307 TLI         Date 25Jan93              */
/*                     ER0300 TLI        DATE  18JAN93              */
/*                                                                  */
/********************************************************************/
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*  ER0311 - 1. REMOVE FIX ER0307 IN THIS CLP                       */
/*         - 2. MODIFIED PROCESSING FOR CPYF ERROR                  */
/*  ER0307 - MODIFIED PROCESSING FOR CPYF ERROR                     */
/*  WRITTEN FOR ER0300 : CHANGE PLACE FOR REVAL IN EOD PROCESSING   */
/********************************************************************/
             PGM
 
             DCL        VAR(&SPTA) TYPE(*CHAR) LEN(4)
 
/**********  DCLF       FILE(SDDEALX4) RCDFMT(SDDEALF4)                                   /*CER001*/
             DCLF       FILE(SDDLX1PD) RCDFMT(SDDEALF4)                                   /*CER001*/
 
             CHGJOB     SWS(00000000)
 
/* Call CLP/ERCSPTA to retrieve value of BLSPTA                      */
             CALL       PGM(ERC5342A) PARM(&SPTA)
 
/**Copy*postings*in*file*EODPO2PD*for*Revaluation*********************/                   /*CER001*/
/* Copy postings in file GLPSX1PD for Revaluation                    */                   /*CER001*/
             RCVF       RCDFMT(SDDEALF4)
 
/* ER0311 */ CLRPFM     FILE(EODPO2PD)
 
/**********  CPYF       FROMFILE(ACPO5) TOFILE(EODPO2PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CER001*/
             CPYF       FROMFILE(ACPO5) TOFILE(GLPSX1PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CER001*/
/* ER0311 ***MONMSG*****MSGID(CPF2817)                         */
/* ER0311 */ MONMSG     MSGID(CPF2817) EXEC(CHGJOB SWS(00000011))
 
             ENDPGM
