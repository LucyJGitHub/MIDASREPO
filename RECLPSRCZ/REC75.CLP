/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Uncleared funds report')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC75 - UNCLEARED FUNDS REPORT                              */
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
/*       PREV AMEND NO. LN0316                  08JUN90              */
/*                      S01117                  16MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413 - Header Box Standardised                            */
/*       LN0316 - Program tries to delete an override that           */
/*                has already been deleted                           */
/*       S01117 - Multibranching                                     */
/*                                                                   */
/*********************************************************************/
/************PGM */
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
             DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
             DCL VAR(&RLEV) TYPE(*CHAR) LEN(1)                        /*S01117*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/**/
                SNDPGMMSG MSG('REC75 - Uncleared Funds Report') TOMSGQ(MRUNQ)
                OVRDBF FILE(TABLE) TOFILE(TABRE2)
/*              IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +       */
/*                         THEN(OVRDBF FILE(UNCOL) POSITION(*KEY 1 +          */
/*                         APOSTPDF &RENT)                            /*S01117*/
                IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                           THEN(DO)                                   /*S01117*/
                           OVRDBF FILE(UNCOL) POSITION(*KEY 1 +
                           APOSTPDF &RENT)                            /*S01117*/
                           OPNDBF FILE(UNCOL) OPTION(*ALL)            /*S01117*/
                           MONMSG MSGID(CPF0000) EXEC(DO)             /*S01117*/
                           DLTOVR FILE(UNCOL)                         /*S01117*/
                           ENDDO                                      /*S01117*/
                           ENDDO                                      /*S01117*/
/************   CALL PGM(RE0750)  */                                  /*S01117*/
                CALL PGM(RE0750) PARM(&RSEQ &RENT)                    /*S01117*/
                DLTOVR FILE(TABLE)
                IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*LN0316*/
/*                         THEN(DLTOVR FILE(UNCOL))     */ /*S01117*/ /*LN0316*/
                           DLTOVR FILE(UNCOL)                         /*LN0316*/
                           MONMSG MSGID(CPF9841)                      /*LN0316*/
                      ENDDO                                           /*LN0316*/
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   /*S01117*/
                  RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)             /*S01117*/
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))           /*S01117*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)                      /*S01117*/
                  ENDDO                                               /*S01117*/
                ELSE CMD(DO)                                          /*S01117*/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0750') TOMSGQ(MRUNQ +
                                                                        MOPERQ)
                  ENDDO                                               /*S01117*/
                ENDDO
/**/
                RCLRSC                                                /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
