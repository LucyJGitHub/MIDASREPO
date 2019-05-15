/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Manual adjustment to int. pay history')      */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*        REC2192  MANUAL ADJUSTMENT TO INTEREST PAYMENT HISTORY    */
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
/*       Prev Amend No. S01383             Date 27Apr92              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01383 - BASIC RATE TAX INCORPORATION                      */
/*                NEW PROGRAM                                       */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             CHGJOB     SWS(00000000)
/**/
             OVRDBF     FILE(INTPSDD) MBR(INTPSDD)
             OVRDBF     FILE(COINTDD) MBR(COINTDD)
/**/
             CALL PGM(RE2192)
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR VAR(&MSG) VALUE('JOB TERMINATED - DATABASE IN ERROR')
                   ROLLBACK
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   SNDPGMMSG MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INFO)
             ENDDO
/**/
 ENDPGM:     RCLRSC
             DLTOVR     FILE(INTPSDD COINTDD)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
