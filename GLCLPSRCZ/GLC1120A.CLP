/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Amount Accrual Input Controller')            */
/*********************************************************************/
/*                                                                   */
/*        Midas     - General Ledger Module                     */
/*                                                                   */
/*      GLC1120A - AMOUNT ACCRUAL INPUT PROCEDURE                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 05/06/89             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      S01194 - NEW STANDING DATA                                   */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*           DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)              */    /*S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL     VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL     VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
/**/
    TOP:     RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/**/
             IF COND((%SST(&LDA 1 2)) *NE '**') THEN(DO)
                CHGVAR VAR(&PGM) VALUE(%SST(&LDA 1 8))
/**/
                CALL &PGM
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
                RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
                IF COND(%SWITCH(X0000000)) THEN(GOTO TOP)
                 IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                    ROLLBACK
                    RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***********        CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))    */   /*S01194*/
                    CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01194*/
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT)
                 ENDDO
/**/
                ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:       ENDPGM
