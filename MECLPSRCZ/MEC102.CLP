/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas I/c SWIFT account list')                        */
/********************************************************************/
/*                                                                  */
/*        Midas     - MESSAGE MANAGEMENT                            */
/*                                                                  */
/*        MEC102     INPUT CYCLE SWIFT ACCOUNTS LIST                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  00000            DATE 00XXX00              */
/*       PREV AMEND NO.  00000            DATE 00XXX00              */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) VALUE('FILE +
                          CONTROLS OUT OF BALANCE')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
/**/
             CHGVAR     VAR(&RPY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGJOB     SWS(00000000)
/**/
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(CHGJOB SWS(1XXXXXXX))
             CALL       PGM(ME0030) PARM(&RSEQ &RLEV &RENT)
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(DO)
/**/
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(SNDPGMMSG +
                             MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ))
/**/
                ELSE       CMD(DO)
/**/
                   RTVDTAARA  DTAARA(LDA)    RTNVAR(&LDA)
                   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50)) +
 
/**/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
                ENDDO
/**/
             ENDDO
/**/
             ENDPGM
