/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail accruals report')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC76 - INTEREST ACCRUALS REPORT                            */
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
/*       Prev Amend No. S01413             Date 13Arp93              */
/*                                         Date                      */
/*                      S01194                  12MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Header Box Standardised                            */
/*       S01117 - Multibranching                                     */
/*       S01194 - New Standing Data                                  */
/*                                                                   */
/*********************************************************************/
                PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          1984')
                DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                     /*S01117*/
                DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                    /*S01117*/
/**/
                SNDPGMMSG MSG('REC76 - Interest Accruals Report') TOMSGQ(MRUNQ)
/**/
/***************OVRDBF FILE(TABLE) TOFILE(TABRE2)                    * *S01194*/
/***************OVRDBF FILE(TABLED) TOFILE(TABRE2) SHARE(*NO)        * *S01194*/
/**/
/*/COPY WNCPYSRC,REC76001                                            */
                CALL PGM(RE0766)
/*/COPY WNCPYSRC,REC76002                                            */
/**/
/***************DLTOVR FILE(*ALL)                                    * *S01194*/
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   /*S01117*/
                  RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)             /*S01117*/
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))           /*S01117*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)                      /*S01117*/
                  ENDDO                                               /*S01117*/
                ELSE CMD(DO)                                          /*S01117*/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0766') TOMSGQ(MRUNQ +
                                MOPERQ)
                  ENDDO                                               /*S01117*/
                ENDDO
/**/
             RCLRSC                                                   /*S01117*/
/*/COPY WNCPYSRC,REC76003                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
/*/COPY WNCPYSRC,REC76004                                            */
