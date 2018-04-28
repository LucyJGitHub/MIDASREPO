/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Daily Movements Report')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC5B - DAILY MOVEMENTS REPORT                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413             DATE 13APR93              */
/*       PREV AMEND NO. S01117                  16MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413 - Header Box Standardised                            */
/*       S01117 - Multibranching                                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/**/
             SNDPGMMSG MSG('REC5B - Daily Movements Report') TOMSGQ(MRUNQ)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             CHGJOB SWS(00000000)
/**/
             CALL PGM(RE0566)
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                      /*S01117*/
               RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)                /*S01117*/
               CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))              /*S01117*/
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)                         /*S01117*/
               ENDDO                                                  /*S01117*/
             ELSE CMD(DO)                                             /*S01117*/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
                CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - RE0566')
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
             ENDDO                                                    /*S01117*/
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
