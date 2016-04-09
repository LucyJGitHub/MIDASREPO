/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Amount Accruals Audit and List')             */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC1130 - AMOUNT ACCRUAL AUDIT REPORT                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01194               DATE  16/03/89         */
/*       PREV AMEND NO. S01117               DATE  02/03/89         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(75)
/*********** DCL        VAR(&MEM)     TYPE(*CHAR) LEN(44) */          /*S01194*/
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)             /*S01194*/
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
/* RCF parms blank for mandatory run of GL1130 */                     /*S01117*/
             DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
             DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
/**/
/*  Set on U1 for Audit mode of GL1130  */                            /*S01117*/
/**/
             CHGJOB   SWS(10000000)
/**/
/*********** OVRDBF     TABLE  TABGL*/                                /*S01194*/
/*********** OVRDBF     TABLED TABGL SHARE(*NO)*/                     /*S01194*/
             OVRDBF     MASTU  AMACC SHARE(*NO)
/**/
                   SNDPGMMSG  MSG('Amount Accrual Audit Report') +
                                TOMSGQ(MRUNQ)
/**/
/************CALL   GL1130*/                                          /*S01117*/
             CALL   PGM(GL1130) PARM(&RSEQ &RENT)                     /*S01117*/
/**/
/**/
                DLTOVR *ALL
/**/
/*  SEND FILE CONTROL MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
               CHGVAR &MSG VALUE('FILE CONTROLS OUT OF BALANCE - FILE +
                                 AMACC')
               SNDPGMMSG &MSG TOMSGQ(MOPERQ)
               SNDPGMMSG &MSG TOPGMQ(*EXT)
             ENDDO
/**/
/*  SEND DATABASE MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***********    CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 44)) */         /*S01194*/
                CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))            /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
