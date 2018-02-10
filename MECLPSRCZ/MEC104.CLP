/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EOD SWIFT accounts list')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - MESSAGE MANAGEMENT                            */
/*                                                                  */
/*        MEC104     End of Day S.W.I.F.T. Accounts List            */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.  00000            DATE 00XXX00              */
/*                       00000            DATE 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE('B')
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('ALL')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) VALUE('FILE +
                          CONTROLS OUT OF BALANCE')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGJOB     SWS(00000000)
/**/
             SNDPGMMSG  MSG('End of Day S.W.I.F.T. Account List') +
                          TOMSGQ(MRUNQ)
/**/
             CALL       PGM(ME0030) PARM(&RSEQ &RLEV &RENT)
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ)
                   CHGJOB     SWS(XXXXXX01)
                   ENDDO
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
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
