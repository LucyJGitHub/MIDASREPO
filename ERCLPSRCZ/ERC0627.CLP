/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS ABS European Reporting - SE Extract')           */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0627  - SE EXTRACT                                        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. UPG402             Date 03Oct04              */
/*                      CAD002 PT          Date 30May98              */
/*                    ER0362 TLI           DATE 02FEB94             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     UPG402 - Recompile due to upgrade to R4.02                   */
/*     CAD002 - EXTRACT TRADE DATE POSITIONS FOR CAD                */
/*     ER0362 - NEW EXTRACT PROGRAM FOR FORWARD TRADES              */
/*                                                                  */
/*********************************************************************/
/**/
PGM
/* CAD002 BEGIN  */
             DCLF       FILE(SDSTRDPD)
             RCVF       RCDFMT(SDSTRDD0)
             IF         COND(&BVSKTV *EQ 'V') THEN(CALL PGM(ER0627) +
                          PARM('T'))
             IF         COND(&BVSKTV *NE 'V') THEN(CALL PGM(ER0627) +
                          PARM('V'))
             IF         COND(&BVSKTV *NE 'V') THEN(CALL PGM(ER0627) +
                          PARM('R'))
/* CALL ER0627 */
/* CAD002 END */
 
/* ER0362 BEGIN  */
CALL ER0633
/* ER0362 END */
ENDPGM
