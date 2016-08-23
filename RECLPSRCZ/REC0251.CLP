/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Stopped cheques input')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                                   */
/*                                                                   */
/*       REC0251 - STOPPED CHEQUES INPUT                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 080290             DATE 10JAN95              */
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      S01117                  19MAR90              */
/*                      S01194                  09MAR90              */
/*                      E21177                  27MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       080290 - Set off switches before calling program            */
/*       S01413 - Retail 3 Incorporation                             */
/*       S01117 - Multibranching                                     */
/*       S01194 - New Standing Data                                  */
/*       E21177 - 'DATABASE IN ERROR' error message added (this      */
/*                fix is put in as part of S01117)                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/*********** OVRDBF FILE(TABLE) TOFILE(TABRE2) **/         /*S01194*/ /*080290*/
/**/
             CHGJOB     SWS(00000000)                                 /*080290*/
                                                                      /*080290*/
             CALL PGM(RE0251)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
/************DLTOVR FILE(TABLE)                                      * *S01194*/
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                      /*S01117*/
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)               /*S01117*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01117*/
                ROLLBACK                                              /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)                                /*S01117*/
             ENDDO                                                    /*S01117*/
 ENDPGM:     RCLRSC                                                   /*S01117*/
/*NDPGM:*****ENDPGM                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
