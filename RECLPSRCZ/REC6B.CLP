/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Int Type/Sub-Type applied to A/cs')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC6B - INT. SUB-TYPES RATE CHANGES APPLIED TO ACCOUNTS     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083BV           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01413             Date 13APR93              */
/*                      S01117                  16MAR90              */
/*                      S01194                  09MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE083BV - COB Restructure - RE COB Optimistation Phase 1   */
/*       S01413  -  Header Box Standardised                          */
/*       S01117  -  Multibranching                                   */
/*       S01194  -  New Standing Data                                */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
             SNDPGMMSG MSG('REC6B - Interest Sub-Types Rate Changes Applied +
             To Accounts') TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(XXXXXX00)
/**/
             CLRPFM FILE(ICHGA)
             CLRPFM FILE(ICHGR1)
             CLRPFM FILE(ICHGR2)
             CLRPFM FILE(ICHGR3)
             CLRPFM FILE(ICHGZ)
/**/
             SCRUNSQL   SQL('declare global temporary table REACCTD0 +
                          as (select * from V_REACCTK0 order by +
                          BRCA, CNUM, CCY, ACOD, ACSQ) with data') +
                                                                                        /*CRE083BV*/
                                                                                        /*CRE083BV*/
             OVRDBF     FILE(REACCTPD) TOFILE(REACCTD0) +
                          NBRRCDS(20000) LVLCHK(*NO) SEQONLY(*YES +
                          20000)                                                        /*CRE083BV*/
                                                                                        /*CRE083BV*/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             OVRDBF FILE(UPRIN) TOFILE(UPRID)
/**/
             CALL PGM(RE0641)
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0641') TOMSGQ(MOPERQ)
               ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ENDDO
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
