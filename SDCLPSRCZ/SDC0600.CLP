/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Base Rates Update')                          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Standing Data Module                      */
/*                                                                  */
/*       SDC0600 - BASE RATES UPDATE                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CTI004             Date 12Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No.                    Date ddmmyy               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CTI004 - MidasPlus-TI Integration Enhancements              */
/*                Base Rates Integration                             */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL           VAR(&JOB) TYPE(*CHAR) LEN(10)
             RTVJOBA       JOB(&JOB)
/**/
             OVRDBF        FILE(TABLEI) TOFILE(TABSDU)
             OVRDBF        FILE(TABLEU) TOFILE(TABSDU) SHARE(*NO)
             OVRDBF        FILE(SDBSHSP0) TOFILE(SDBSHSL1) SHARE(*YES)                    /*CTI004*/
             CALL          PGM(SD0600)
             IF            COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(&JOB) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
          ENDPGM
