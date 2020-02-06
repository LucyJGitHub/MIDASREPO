/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Accrued interest & charges report')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC0380 - ACCRUED INTEREST AND CHARGES REPORT               */
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
/*       Prev Amend No. S01413             Date 13Apr93              */
/*                                         Date                      */
/*                      S01117                  19MAR90              */
/*                      S01194                  09MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*       LN0316 - Program tries to delete an override that           */
/*                has already been deleted                           */
/*                                                                   */
/*       S01117 - Multibranching                                     */
/*                                                                   */
/*       S01194 - New Standing Data                                  */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01117*/
             PGM     PARM(&RSEQ &RLEV &RENT)                          /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
             DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
             DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
             CLRPFM FILE(REAIXA)
             CLRPFM FILE(REAIXD)
             CLRPFM FILE(REAIXZ)
/**/
             CALL PGM(RE0379)
/**/
/*********** IF COND(%SWITCH(XXXXXX0X)) THEN( +                       /*S01117*/
/***********    CALL PGM(RE0380))                                     /*S01117*/
             IF COND(%SWITCH(XXXXXX0X)) THEN(DO)                      /*S01117*/
/*              IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +               */
/*                 THEN(OVRDBF FILE(SREAI) POSITION(*KEY 2 +                  */
/*                 REAIXDF ('D' *CAT &RENT))                          /*S01117*/
                IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                   THEN(DO)                                           /*S01117*/
                   OVRDBF FILE(SREAI) POSITION(*KEY 2 +
                   REAIXDF ('D' *CAT &RENT))                          /*S01117*/
                   OPNDBF FILE(SREAI) OPTION(*ALL)                    /*S01117*/
                   MONMSG MSGID(CPF0000) EXEC(DO)                     /*S01117*/
                   DLTOVR FILE(SREAI)                                 /*S01117*/
                   ENDDO                                              /*S01117*/
                   ENDDO                                              /*S01117*/
/************** CALL PGM(RE0380) PARM(&RSEQ &RENT)      */ /*S01117*/ /*S01413*/
                CALL PGM(RE3380) PARM(&RSEQ &RENT)                    /*S01413*/
/**/
                IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*LN0316*/
/*                 THEN(DLTOVR FILE(SREAI))             */ /*S01117*/ /*LN0316*/
                     DLTOVR FILE(SREAI)                               /*LN0316*/
                      MONMSG MSGID(CPF9841)                           /*LN0316*/
                ENDDO                                                 /*LN0316*/
             ENDDO                                                    /*S01117*/
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
