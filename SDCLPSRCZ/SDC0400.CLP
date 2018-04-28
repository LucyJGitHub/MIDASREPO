/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Check customer not on ext. sett.')           */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/********SD0400C - CHECK CUSTOMER NOT ON EXTENDED SETTLEMENT        */
/*       SDC0400 - CHECK CUSTOMER NOT ON EXTENDED SETTLEMENT        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 063444             Date 25Feb94             */
/*                      RT0118             Date 28Jun91             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       063444 - ADD NEW PARAMETER TO INPUT PARMS AND CALL TO      */
/*                SD0400U.                                          */
/*       RT0118 - RENAME PROGRAMME TO SDC0400                       */
/*                                                                  */
/********************************************************************/
/*********** PGM        PARM(&CUSTNO &ERRCODE) */                     /*063444*/
             PGM        PARM(&CUSTNO &ERRCODE &PARMS)                 /*063444*/
                                                                      /*063444*/
             DCL        VAR(&CUSTNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ERRCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(217)
/**********  DCL        VAR(&PARMS) TYPE(*CHAR) LEN(300) */                    /*063444*/ /*CGL029*/
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(340)                                  /*CGL029*/
             DCL        VAR(&PARMSA) TYPE(*CHAR) LEN(150)             /*063444*/
/**********  DCL        VAR(&PARMSB) TYPE(*CHAR) LEN(150) */                   /*063444*/ /*CGL029*/
             DCL        VAR(&PARMSB) TYPE(*CHAR) LEN(190)                                 /*CGL029*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*/COPY WNCPYSRC,SDC0400001                                          */
             CHGVAR     VAR(&SELECT) VALUE('BYCUST="' *CAT &CUSTNO +
                          *CAT '" *OR BYROBN="' *CAT &CUSTNO *CAT +
                          '" *OR BYROCS="' *CAT &CUSTNO *CAT '" +
                          *OR BYRIBN="' *CAT &CUSTNO *CAT '" *OR +
                          BYPOBN="' *CAT &CUSTNO *CAT '" *OR +
                          BYPOCS="' *CAT &CUSTNO *CAT '" *OR +
                          BYPIBN="' *CAT &CUSTNO *CAT '" *OR +
                          BYRCNO="' *CAT &CUSTNO *CAT '" *OR +
                          BYRCNB="' *CAT &CUSTNO *CAT '" *OR +
                          BYACBN="' *CAT &CUSTNO *CAT '" *OR +
                          BYBYNB="' *CAT &CUSTNO *CAT '"')
/*/COPY WNCPYSRC,SDC0400002                                          */
             OVRDBF     FILE(SDEXSTPD) SHARE(*YES)
             OPNQRYF    FILE((SDEXSTPD)) OPTION(*ALL) QRYSLT(&SELECT)
/*********** CALL       PGM(SD0400U) PARM(&CUSTNO &ERRCODE) */        /*063444*/
             CALL       PGM(SD0400U) PARM(&CUSTNO &ERRCODE &PARMSA +
                          &PARMSB)                                    /*063444*/
             CHGVAR     VAR(&PARMS) VALUE(&PARMSA *CAT &PARMSB)       /*063444*/
             CLOF SDEXSTPD
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
