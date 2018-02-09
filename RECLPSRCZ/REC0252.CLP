/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Held items maintenance')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                 */
/*                                                                   */
/*       REC0252    HELD ITEMS MAINTENANCE                           */
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
/*       Prev Amend No. 054807             Date 06Dec95              */
/*                      S01413             Date 05Jun95              */
/*                      S01413             DATE 13APR93              */
/*                      S01117                  19MAR90              */
/*                      S01194                  09MAR90              */
/*                      E21177                  28MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       054807 - Check only U7/U8 for error processing              */
/*       S01408 - Addition of core hooks REC0252MPS                  */
/*                                       REC0252MP1                  */
/*       S01413 - Retail 3 Incorporation                             */
/*       S01117 - Multibranching                                     */
/*       S01194 - New standing data                                  */
/*       E21177 - Include details for displaying error message if    */
/*        the program RE0252 fails to read TABLE file correctly..    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL VAR(&MSG) TYPE(*CHAR) LEN(50)               /*E21177*/
/*DECLARE VARIABLES*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)               /*E21177*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)              /*E21177*/
/**/                                                         /*S01408*/
/*/COPY WNCPYSRC,REC0252MPS                                  /*S01408*/
/**/                                                         /*S01408*/
/************CHGJOB     SWS(XXXXXXX0)                 /*E21177 054807*/
             CHGJOB     SWS(XXXXXX00)                        /*054807*/
/**/                                                         /*S01408*/
/*/COPY WNCPYSRC,REC0252MP1                                  /*S01408*/
/**/                                                         /*S01408*/
/**/
/************OVRDBF FILE(TABLE) TOFILE(TABRE2)                       * *S01194*/
/**/
             CALL PGM(RE0252)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
/************DLTOVR FILE(TABLE)                                      * *S01194*/
/**/
/************IF COND(*NOT %SWITCH(XXX00000)) THEN(DO)                 /*054807*/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)                 /*054807*/
/**/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR VAR(&MSG) VALUE('JOB TERMINATED - DATABASE IN ERROR')
                   ROLLBACK
                ENDDO
/**/
                SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INFO)
/**/                                                            /*E21177*/
                ROLLBACK                                        /*E21177*/
                RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)              /*E21177*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))       /*E21177*/
                SNDPGMMSG MSGID(MEM0001) +
                          MSGF(MIDAS)    +
                          MSGDTA(&MEM)   +
                          TOMSGQ(MOPERQ)                        /*E21177*/
                SNDPGMMSG MSGID(MEM0001) +
                          MSGF(MIDAS)    +
                          MSGDTA(&MEM)   +
                          TOPGMQ(*EXT)                          /*E21177*/
/**/
             ENDDO
/**/
/*DPGM:      ENDPGM                                                   /*S01117*/
ENDPGM:      RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
