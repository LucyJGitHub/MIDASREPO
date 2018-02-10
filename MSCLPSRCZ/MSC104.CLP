/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EOD SWIFT accounts list')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     S.W.I.F.T. DIRECT LINK                      */
/*                                                                  */
/*        MSC104     End of Day S.W.I.F.T. Accounts List            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*        1988, 1989.                                               */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01189             DATE  04APR90            */
/*                      S01117             DATE  22DEC89            */
/*                      S01194             DATE  22DEC89            */
/*                      S01179             DATE 12/09/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     MD046248 - Finastra Rebranding                               */
/*     S01189  -  TO SETON SWITCH U8                                */
/*     S01117 - MULTIBRANCHING                                      */
/*     S01194 - STANDING DATA CHANGES.                              */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400           */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ') /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE('B')     /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('ALL')   /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) VALUE('FILE +
                          CONTROLS OUT OF BALANCE')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)             /*S01179*/
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDPGMMSG  MSG('End of Day S.W.I.F.T. Account List') +
                          TOMSGQ(MRUNQ)
/**/
/************CALL       PGM(MS0030)                                   /*S01117*/
             CALL       PGM(MS0030) PARM(&RSEQ &RLEV &RENT)           /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) +
                          THEN(DO)
/**/
/**/
/***************IF         COND(%SWITCH(XXXXXX10)) THEN(SNDPGMMSG +
 ****************************MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ))*/ /*S01189*/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)           /*S01189*/
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ)                 /*S01189*/
                   CHGJOB     SWS(XXXXXX01)                           /*S01189*/
                   ENDDO                                              /*S01189*/
/**/
                ELSE       CMD(DO)
/**/
/*                 RCVDTAARA  DTAARA(LDA)                           *  *S01179*/
                   RTVDTAARA  DTAARA(LDA)    RTNVAR(&LDA)             /*S01179*/
/******************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))/*S01117*/
                   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50)) +
                                                                      /*S01117*/
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
