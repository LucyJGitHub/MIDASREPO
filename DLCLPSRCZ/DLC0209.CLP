/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Man. Adjustments to Accrued Int')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0209-MANUAL ADJUSTMENTS TO ACCRUED INTEREST             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL026             Date 12NOV04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev AMEND NO. S01194                  DATE  01/09/89      */
/*                                                                  */
/********************************************************************/
/*  CDL026 - Authorisation on Dealing Accrued Interest Adjustments  */
/*       S01194 - NEW STANDING DATA CHANGES                         */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(35)
             DCL        VAR(&PPOPTN) TYPE(*CHAR) LEN(1) /* CDL026 */
             DCL        VAR(&PPDLNO) TYPE(*DEC) LEN(6 0) /* CDL026 */
             DCL        VAR(&PPCNUM) TYPE(*DEC) LEN(6 0) /* CDL026 */
             DCL        VAR(&@INKC) TYPE(*CHAR) LEN(1) /* CDL026 */
/*    MANUAL ADJUSTMENTS TO ACCRUED INTEREST             */
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
/*           CALL       PGM(DL0100)  *CDL026*/
             CALL       PGM(DL0100) PARM(&PPOPTN &PPDLNO &PPCNUM +
                          &@INKC) /* CDL026 */
/************DLTOVR     FILE(*ALL)                                    /*S01194*/
/*     ERROR MESSAGES                                        */
             IF         COND(%SWITCH(XXXXX1X1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED-STRAN FILE +
                                         FULL')
                RTVJOBA    JOB(&JOB) SWS(&SWS)
                ROLLBACK
                SNDPGMMSG  MSG(&MSG) TOMSGQ(&JOB) MSGTYPE(*INFO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                CHGVAR     VAR(&SWS) VALUE('XXXXX0X0')
                CHGJOB     SWS(&SWS)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
