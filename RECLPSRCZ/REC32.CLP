/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE HELD ITEMS REPORT')                          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*        REC32      HELD ITEMS REPORT                              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD030959           Date 17Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      LN0257             Date 24May90              */
/*                      S01117             Date 16Mar90              */
/*                           S01194           DATE 09MAR90          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       MD030959 - Recompiled due to changed PF/HELDIHC.            */
/*       LN0257  - TO ALLOW COB ON REQUEST REPORT TO BE OVERRIDDEN  */
/*                 TO BRANCH LEVEL REQUEST                          */
/*                                                                  */
/*       S01117  - MULTIBRANCHING                                   */
/*                                                                  */
/*       S01194  - NEW STANDING DATA                                */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM PARM(&STAT)                                          /*S01117*/
             PGM     PARM(&STAT &RSEQ &RLEV &RENT)                    /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL VAR(&STAT) TYPE(*CHAR) LEN(1)
/************DCL VAR(&MEM) TYPE(*CHAR) LEN(44)                       * *S01194*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01194*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
             DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
             DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
/**/
                SNDPGMMSG MSG('REC32 - Held Items Report') TOMSGQ(MRUNQ)
/**/
                IF COND(&STAT *EQ 'I') THEN(CHGJOB SWS(10000000))
                ELSE CMD(CHGJOB SWS(00000000))
/**/
                OVRDBF FILE(TABLE) TOFILE(TABRE2) SHARE(*NO)
                OVRDBF FILE(TABLED) TOFILE(TABRE2) SHARE(*NO)
/**/
/***********    CALL PGM(RE0320)                                      /*S01117*/
/**/                                                                  /*S01117*/
/*    ON-REQUEST MODE  */                                             /*S01117*/
/**/                                                                  /*S01117*/
/*           IF     COND((&STAT *EQ 'I')) THEN(DO)      */ /*S01117*/ /*LN0257*/
             IF     COND((&STAT *EQ 'I' *OR &STAT *EQ 'O')) THEN(DO)  /*LN0257*/
/*                  IF   COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +         */
/*                       THEN(OVRDBF FILE(SHLDI) POSITION(*KEY 1 +            */
/*                            HELDIHBF &RENT)                         /*S01117*/
                    IF   COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                         THEN(DO)                                     /*S01117*/
                         OVRDBF FILE(SHLDI) POSITION(*KEY 1 +
                              HELDIHBF &RENT)                         /*S01117*/
                         OPNDBF FILE(SHLDI) OPTION(*ALL)              /*S01117*/
                         MONMSG MSGID(CPF0000) EXEC(DO)               /*S01117*/
                         DLTOVR FILE(SHLDI)                           /*S01117*/
                         ENDDO                                        /*S01117*/
                         ENDDO                                        /*S01117*/
/**/                                                                  /*S01117*/
                    CALL PGM(RE0320) PARM(&RSEQ &RENT)                /*S01117*/
             ENDDO                                                    /*S01117*/
/**/                                                                  /*S01117*/
/*    OTHERWISE, C.O.B. MODE  */                                      /*S01117*/
/**/                                                                  /*S01117*/
             ELSE   CMD(DO)                                           /*S01117*/
                    CALL PGM(RE0320) PARM('     ' 'ALL')              /*S01117*/
             ENDDO                                                    /*S01117*/
/**/
                DLTOVR FILE(*ALL)
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/******************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))         * *S01194*/
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))          /*S01194*/
/**/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                             TOMSGQ(MOPERQ MRUNQ)
                ENDDO
                ELSE CMD(DO)                                          /*S01117*/
/**/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0320') TOMSGQ(MOPERQ)
                ENDDO
                ENDDO                                                 /*S01117*/
                RCLRSC                                                /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
