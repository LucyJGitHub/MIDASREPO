/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Default Retail Accounts Listing')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC56 - DEFAULT RETAIL ACCOUNTS LISTING                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            DATE 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01413             DATE 13APR93              */
/*                      LN0413                  21JUN90              */
/*                      LN0316                  08JUN90              */
/*                      S01117                  16MAR90              */
/*                      E12890                  12APR88              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       S01413 - Retail 3 Incorporation                             */
/*       LN0413 - PROGRAM SENDS MESSAGE TO WRONG MESSAGE Q           */
/*       LN0316 - PROGRAM TRIES TO DELETE AN OVERRIDE THAT           */
/*                HAS ALREADY BEEN DELETED                           */
/*       S01117 - MULTIBRANCHING                                     */
/*       E12890 - EXTRACT FILES REDEXAA, REDEXAB, & REDEXAC          */
/*                ARE NOT BEING CLEARED BEFORE 'DEFAULT RETAIL       */
/*                ACCOUNTS' REPORT IS RUN OFF.                       */
/*                                                                   */
/*********************************************************************/
/************PGM */
             PGM  PARM(&RSEQ &RLEV &RENT)                             /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(6)
/*/COPY WNCPYSRC,REC56001                                            */
/**/
                SNDPGMMSG MSG('REC56 - Default Retail Accounts Listing') +
                                                   TOMSGQ(MRUNQ)      /*LN0413*/
/*                                                 TOMSGQ(MOPERQ)*/   /*LN0413*/
                OVRDBF FILE(TABLE) TOFILE(TABRE2)
                CHGJOB SWS(00000000)
/**/
             CLRPFM     FILE(REDEXAA)                                 /*E12890*/
             CLRPFM     FILE(REDEXAB)                                 /*E12890*/
             CLRPFM     FILE(REDEXAC)                                 /*E12890*/
/**/
/*/COPY WNCPYSRC,REC56002                                            */
                CALL PGM(RE0560)
/*/COPY WNCPYSRC,REC56003                                            */
/**/
/***********    IF COND(%SWITCH(XXXXXX00)) THEN(CALL PGM(RE0562))     /*S01117*/
                IF COND(%SWITCH(XXXXXX00)) THEN(DO)                   /*S01117*/
                   IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*S01117*/
                      OVRDBF FILE(REDES) POSITION(*KEY 1 +
                      REDEXABF &RENT)                                 /*S01117*/
                      OPNDBF FILE(REDES) OPTION(*ALL)                 /*S01117*/
                      MONMSG MSGID(CPF0000) EXEC(DO)                  /*S01117*/
                      DLTOVR FILE(REDES)                              /*S01117*/
                      ENDDO                                           /*S01117*/
                      ENDDO                                           /*S01117*/
                   CALL PGM(RE0562) PARM(&RSEQ &RENT)                 /*S01117*/
                   IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*LN0316*/
/*                    THEN(DLTOVR FILE(REDES)) */          /*S01117*/ /*LN0316*/
                           DLTOVR FILE(REDES)                         /*LN0316*/
                           MONMSG MSGID(CPF9841)                      /*LN0316*/
                      ENDDO                                           /*LN0316*/
                ENDDO                                                 /*S01117*/
                ELSE CMD(DO)
                CHGVAR VAR(&PGM) VALUE('RE0560')
                GOTO CMDLBL(ERROR)
                ENDDO
/**/
                IF COND(*NOT %SWITCH(XXXXXX00)) THEN(CHGVAR VAR(&PGM) +
                                  VALUE('RE0562'))
/**/
                DLTOVR FILE(TABLE)
/**/
 ERROR:      IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/***********    IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                   /*S01117*/
                IF COND(%SWITCH(XXXXXX01)) THEN(DO)                   /*S01117*/
/**********        CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - '****&PGM)      */ /*BG18886*/
             CHGVAR     VAR(&MSG) VALUE('FILES OUT OF BALANCE - ' +
                          *CAT &PGM)                                                     /*BG18886*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                /*S01117*/
                ENDDO
/**/
/**/
/***********    SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                   /*S01117*/
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
