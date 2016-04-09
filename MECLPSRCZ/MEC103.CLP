/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Update SWIFT closed account')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - MESSAGE MANAGEMENT                            */
/*                                                                  */
/*        MEC103     Update S.W.I.F.T. Closed Accounts              */
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
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) VALUE('FILE +
                          CONTROLS OUT OF BALANCE')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDPGMMSG  MSG('Update S.W.I.F.T. Accounts for Closed +
                          Accounts') TOMSGQ(MRUNQ)
/**/
             CALL       PGM(ME0240)
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(DO)
/**/
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                   CHGJOB     SWS(XXXXXX01)
                   ENDDO
/**/
                ELSE       CMD(DO)
/**/
                   RTVDTAARA  DTAARA(LDA)    RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
/**/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
/**/
                ENDDO
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
