/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE CUSTOMER LENDING NEXT DAY SETUP')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC09 - CUSTOMER LENDING NEXT DAY SET-UP                   */
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
/*       Prev Amend No. S01194             Date 11Dec89              */
/*                      S01179             Date 15Sep89              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/************DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
/**/
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&MSG) VALUE('CUSTOMER LENDING NEXT DAY +
                                               SET-UP')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/* R E T A I L ONLY (NOW PERFORMED IN I/C INITIATION)                */
/************IF         COND(%SUBSTRING(&MMOD 3 1) *EQ 'Y') +        */
/************** THEN(CALL PGM(LEC0901))                              */
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(LEC0902))
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(LEC0903))
/*/COPY WNCPYSRC,LEC09001                                            */
/**/
/*   ERROR MESSAGES                                             */
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*******CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))        */ /*S01194*/
        CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))           /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF +
                                               BALANCE')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:         ENDPGM
