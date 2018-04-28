/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail excess report')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC79 - RETAIL EXCESS REPORT                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 20JUN96              */
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      S01117                  12FEB90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Core hook REC79001 added.                          */
/*       S01413 - Header Box Standardised                            */
/*       S01117 - Multibranching                                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          1984')
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/**/
             SNDPGMMSG MSG('REC79 - Retail Excess Report') TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(XXXXXXX0)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             CALL PGM(RE0790)
             DLTOVR FILE(*ALL)
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                      /*S01117*/
               RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)                /*S01117*/
               CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))              /*S01117*/
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)                         /*S01117*/
               ENDDO                                                  /*S01117*/
             ELSE  CMD(DO)                                            /*S01117*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0790') TOMSGQ(MOPERQ)
               ENDDO                                                  /*S01117*/
             ENDDO
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,REC79001                                             /*S01408*/
/*                                                                    /*S01408*/
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/**/
