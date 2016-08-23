/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas I/c SWIFT account list')                        */
/********************************************************************/
/*                                                                  */
/*        Midas     S.W.I.F.T. DIRECT LINK                      */
/*                                                                  */
/*        MSC102     INPUT CYCLE SWIFT ACCOUNTS LIST                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*        1988, 1989.                                               */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117             DATE  21DEC89            */
/*       PREV AMEND NO. S01194             DATE  21DEC89            */
/*                      S01179             DATE 12/09/88         */
/*                                                                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     S01117 - MULTIBRANCHING                                      */
/*     S01194 - STANDING DATA CHANGES.                              */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400           */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     */
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)               /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                    /*S01194*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)             /*S01117*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) VALUE('FILE +
                          CONTROLS OUT OF BALANCE')
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                /*S01117*/
/**/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)             /*S01179*/
/**/
/**********  CHGDTAARA  DTAARA(LDA) VALUE(' ')                       /*S01117*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             CHGVAR     VAR(&RPY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             CHGJOB     SWS(00000000)
/**/
/**/
/************SNDPGMMSG  MSG('DO YOU REQUIRE A LIST OF UPDATED +       /*S01117*/
/************             ACCOUNTS ONLY - Y OR N?') TOPGMQ(*EXT) +    /*S01117*/
/************               MSGTYPE(*INQ)                             /*S01117*/
/************RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*YES) MSG(&RPY)  /*S01117*/
/**/
/**/
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(CHGJOB SWS(1XXXXXXX))
/**/
/************CALL       PGM(MS0030)                                   /*S01117*/
             CALL       PGM(MS0030) PARM(&RSEQ &RLEV &RENT)           /*S01117*/
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
             ENDPGM
