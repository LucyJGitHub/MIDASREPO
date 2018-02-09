/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Interest Sub-Types Listing')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC51 - INTEREST SUB-TYPES LISTING                          */
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
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      S01117                  16MAR90              */
/*                      S01194                  09MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413  -  Retail 3 Incorporation                           */
/*       S01117  -  Multibranching                                   */
/*       S01194  -  New Standing Data                                */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01117*/
             PGM     PARM(&RSEQ &RLEV &RENT)                          /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
             DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
             DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             SNDPGMMSG MSG('REC51 - Interest Sub-Types Listing') +
                       TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/************CALL PGM(RE0510)  */                                     /*S01117*/
             CALL PGM(RE0510) PARM(&RSEQ)                             /*S01117*/
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0510') TOMSGQ(MOPERQ)
               ENDDO
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                  RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/*****************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))          * *S01194*/
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))           /*S01194*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
               ENDDO
             ENDDO
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
