/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Listing of Tables')                             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Standing Data Module                      */
/*                                                                  */
/*       SDC0602L -  LISTING OF TABLES                              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01314          DATE  12DEC90               */
/*                                                                  */
/*********************************************************************/
/*                                                                  */
/*       S01314  -   REWRITE. SD0560 REQUIRES PARAMETER             */
/*                                                                  */
/********************************************************************/
/*                                                                            */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &TABFL &RTCD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL &PROG *CHAR 6
             DCL &TABFL *CHAR 7
             DCL &RTCD *CHAR 1
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)                 /*S01314*/
             CHGJOB SWS(XXXXXXX0)                                    /*S01314*/
             IF         COND(&PROG = 'SD0560') THEN(CALL PGM(SD0560) +
                          PARM('A'))                                 /*S01314*/
                 ELSE (DO)                                           /*S01314*/
             OVRDBF TABLEU &TABFL  SHARE(*NO)
             OVRDBF TABLEI &TABFL  SHARE(*NO)
             OVRDBF TABCH  &TABFL  SHARE(*NO)
             OVRDBF TABLE  &TABFL  SHARE(*NO)
             CALL &PROG
             DLTOVR  *ALL
             ENDDO                                                   /*S01314*/
             RTVJOBA    SWS(&SWS)                                    /*S01314*/
             IF ((%SWITCH(XXXXXXX1)) *OR                                       +
                 (%SWITCH(XXXXXX1X))) THEN(CHGVAR &RTCD '1')
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
