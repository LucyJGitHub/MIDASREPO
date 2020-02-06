/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SWIFT accounts maintenance')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - MESSAGE MANAGEMENT                        */
/*                                                                  */
/*        MEC101     S.W.I.F.T. Accounts Maintenance                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 064773             Date 28Feb94              */
/*                      E40395             Date 19May92              */
/*                       E38492           DATE 15APR92              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       064773 - Condition the call to sdretlpd on retail being    */
/*                present.                                          */
/*       E40395 - USE INDICATOR FROM SDMGMEPD NOT MSSTAT            */
/*       E38492 - Check to see if Retail A/C No's are used.         */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/*/COPY WNCPYSRC,MEC101001                                           */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                   */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&MGME)   TYPE(*CHAR) LEN(200)            /*E40395*/
             DCLF       FILE(SDRETLPD)                               /*E40395*/
/*                                                                           */
/* Global monitor message                                                    */
/*                                                                           */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/***********RTVDTAARA  DTAARA(MSSTAT)  RTNVAR(&MSSTAT)                 *E40395*/
/**/
/*********** IF         COND(%SUBSTRING(&MSSTAT 1 1) *EQ 'N') +        *E40395*/
/***********              THEN(CHGJOB SWS(01000000))                   *E40395*/
             CALL       PGM(AOMGMER0) PARM('       ' '*FIRST ' &MGME) /*E40395*/
             IF         COND(%SUBSTRING(&MGME 25 1) *EQ 'N') +
                          THEN(CHGJOB SWS(01000000))                  /*E40395*/
/**/
             ELSE       CMD(CHGJOB SWS(00000000))
/**/
             RTVDTAARA  DTAARA(MMOD)    RTNVAR(&MMOD)
/**/
             IF         COND(%SUBSTRING(&MMOD 16 1) *EQ 'Y') THEN(DO) /*064773*/
             RCVF                                                     /*E38492*/
             ENDDO                                                    /*064773*/
/**********  IF         COND(%SUBSTRING(&MMOD 3 1) *EQ 'Y') +      */ /*E38492*/
/**********               THEN(CHGJOB SWS(1XXXXXXX))               */ /*E38492*/
/**********  IF         COND(%SUBSTRING(&MMOD 3 1) *EQ 'Y' *AND +     /*064773*/
             IF         COND(%SUBSTRING(&MMOD 16 1) *EQ 'Y' *AND +
                          &BMRANR *EQ 'Y') THEN(CHGJOB SWS(1XXXXXXX)) /*E38492*/
             OVRDBF     FILE(SWACBCHG) TOFILE(SWACB) SHARE(*NO)
/*/COPY WNCPYSRC,MEC101002                                           */
                        CALL ME0021
/*/COPY WNCPYSRC,MEC101003                                           */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA)    RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING( +
                              &LDA 134 50))
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO ENDPGM
/**/
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:         ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                SNDPGMMSG MSG('Transaction failed. Re-input +
                     necessary. Enter to continue.') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM:      ENDPGM
