/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM CUSTOMER LIMIT/EXPOSURE/AVAIL')              */
/********************************************************************/
/*                                                                  */
/*              Midas EXPOSURE MANAGEMENT MODULE            */
/*                                                                  */
/*       EMC0802 - CUSTOMER LIMIT/EXPOSURE/AVAILABILITY REPORT      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*           LAST AMEND NO.  LN0081         DATE   01MAY90          */
/*           PREV AMEND NO.  E10841         DATE   28/07/87         */
/*                                                                  */
/*------------------------------------------------------------------*/
/*           LN0081  -  NO RCF PARMS RECEIVED                       *  *LN0081*/
/*           E10841  -  USE NEW LOGICAL FILE SORTED ON CUSTOMERS    *  *E10841*/
/*                      ACCOUNT OFFICER CODE                        *  *E10841*/
/*           S01117 - RELEASE TEN MULTIBRANCHING                    *  *S01117*/
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/******      PGM                                               */     /*LN0081*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*LN0081*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
/*           DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)          */     /*LN0081*/
/*           DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)          */     /*LN0081*/
/*           DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)          */     /*LN0081*/
/**/
                SNDPGMMSG  MSG('Customer Limit/Exposure/Availability +
                Report') TOMSGQ(MRUNQ)
/**/
           OVRDBF FILE(EMDEX) TOFILE(EMDEX1)                          /*E10841*/
/*           CALL       PGM(EM0600)*/                                 /*S01117*/
             CALL       PGM(EM0600) PARM(&RSEQ &RENT &RPARM)          /*S01117*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
           ENDPGM
