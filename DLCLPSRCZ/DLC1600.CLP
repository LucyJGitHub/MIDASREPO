/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS Deal Maintenance Control')           */
/*********************************************************************/
/*                                                                   */
/* Midas - FRA/IRS Module                                    */
/*                                                                   */
/* DLC1600 - FORWARD RATE AGREEMENTS / INTEREST RATE SWAPS           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 125872             DATE 12NOV97              */
/*       LAST AMEND NO. S01408             DATE 30OCT95              */
/*       PREV AMEND NO. CIR001             DATE 13JUN95              */
/*                      042960             DATE 21AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   125872 - Override PRONO to SHARE(*NO) to prevent commitment     */
/*            control problems.                                      */
/*   S01408 - ADDITION OF CORE HOOK DLC1600INT                       */
/*            ADDITION OF CORE HOOK DLC1600END                       */
/*   CIR001 - Interest Rate Calendars.                               */
/*   042960 - Chain to DEALSALL instead of DEALS and CADENQLL        */
/*            to better check for duplicate Deal Numbers.            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DLC1600INT                                        */ /*S01408*/
 
             DCL     VAR(&DPLIB) TYPE(*CHAR) LEN(8) VALUE('  DPLIB ') /*CIR001*/
             DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                /*CIR001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*CIR001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CIR001*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)  +
                          VALUE('CIR001')                             /*CIR001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CIR001*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,DLC1600002                                          */
/**/                                                                  /*CIR001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CIR001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CIR001*/
               RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)              /*CIR001*/
               CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) +
                            VALUE(%SUBSTRING(&SDSTAT 6 2))            /*CIR001*/
                                                                      /*CIR001*/
               CRTDUPOBJ  OBJ(DLOLACPD) FROMLIB(&DPLIB) +
                 OBJTYPE(*FILE) TOLIB(QTEMP)                          /*CIR001*/
               MONMSG CPF0000                                         /*CIR001*/
               CRTDUPOBJ  OBJ(DLOLCFPD) FROMLIB(&DPLIB) +
                 OBJTYPE(*FILE) TOLIB(QTEMP)                          /*CIR001*/
               MONMSG CPF0000                                         /*CIR001*/
                                                                      /*CIR001*/
               OVRDBF     FILE(DEALS) TOFILE(DEALS) SHARE(*NO)        /*CIR001*/
               OVRDBF     FILE(PRONO) TOFILE(PRONO) SHARE(*NO)        /*125872*/
               OVRDBF     FILE(DLOLACPD) TOFILE(QTEMP/DLOLACPD)       /*CIR001*/
               OVRDBF     FILE(DLOLCFPD) TOFILE(QTEMP/DLOLCFPD)       /*CIR001*/
                                                                      /*CIR001*/
             ENDDO                                                    /*CIR001*/
/*/COPY WNCPYSRC,DLC1600001                                          */
/**/
/************OVRDBF     FILE(DEALSCH) TOFILE(DEALS)  SHARE(*NO)    */ /*042960*/
             OVRDBF     FILE(DEALSCH) TOFILE(DEALSALL)  SHARE(*NO)    /*042960*/
             CALL       PGM(DL1600)
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DLC1600END                                        */ /*S01408*/
 
             ENDPGM
