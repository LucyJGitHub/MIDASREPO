/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail account activity report')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*        REC8E      RETAIL ACCOUNT ACTIVITY REPORT                 */
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
/*       Prev Amend No. S01117             Date 16Feb90              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*        S01117 - MULTIBRANCHING                                   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/**/
                SNDPGMMSG MSG('REC8E - Retail Account Activity Report') +
                          TOMSGQ(MRUNQ)
/**/
                OVRDBF FILE(TABLE) TOFILE(TABRE2)
                CALL PGM(RE0861)
                DLTOVR FILE(TABLE)
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   /*S01117*/
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)            /*S01117*/
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))          /*S01117*/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01117*/
                ENDDO                                                 /*S01117*/
                ELSE CMD(DO)                                          /*S01117*/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0861') TOMSGQ(MRUNQ +
                             MOPERQ)
                ENDDO
                ENDDO                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
