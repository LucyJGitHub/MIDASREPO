/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting - FC Extract')               */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0625  - FCLT EXTRACT                                      */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139             Date 04Jan21              */
/*                      UIT021             Date 28JAN97              */
/*                      USW004             Date 10SEP96              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                                         Date                      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas */
/*       LUC139 - Upgrade UCI Italian Returns                       */
/*       UIT021 - Bank of Italy Monthly Reporting                    */
/*       USW004 - SNB Upgrade to R10                                 */
/*                + Copyright & Header Box Standardisation.          *
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*                                                                  */
/*                                                                  */
/*********************************************************************/
/**/
PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) +
                         VALUE('(C) Copyright Midas-Kapiti International +
                                 Ltd. 1992, 1996')                    /*USW004*/
                                                                      /*USW004*/
             DCL        VAR(&RTC) TYPE(*CHAR) LEN(7)                                      /*UIT021*/
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                     /*UIT021*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('UIT021')                      /*UIT021*/
             DCL        VAR(&UIT021) TYPE(*CHAR) LEN(1) VALUE('N')                        /*UIT021*/
             CALL       PGM(AOSARDR0) PARM(&RTC &OPT &SAR)                                /*UIT021*/
             IF         COND(&RTC *EQ '       ') THEN(CHGVAR +
                          VAR(&UIT021) VALUE('Y'))                                        /*UIT021*/
             IF         COND(&UIT021 *EQ 'Y') THEN(DO)                                    /*UIT021*/
             CALL       PGM(XX0625)                                                       /*LUC139*/
             ENDDO                                                                        /*UIT021*/
             ELSE       CMD(DO)                                                           /*UIT021*/
CALL ER0625
             ENDDO                                                                        /*UIT021*/
                                                                      /*USW004*/
             CHGVAR     VAR(&CPYFLD) +
                         VALUE('(C) Copyright Midas-Kapiti International +
                                 Ltd. 1992, 1996')                    /*USW004*/
ENDPGM
