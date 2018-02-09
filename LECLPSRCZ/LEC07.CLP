/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE END OF DAY PROCESSING')                      */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC07 - END OF DAY PROCESSING                              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1061796          Date 03Dec12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117              Date  09Feb90           */
/*                      S01194              DATE  11DEC89           */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1061796 - Encountered error in component LEC07 sequence  */
/*                   10003, 10004 and 10005                         */
/*       CLE134 - Past Due Call Loan Processing                     */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01179 - AS400 INCORPORATION                               */
/*       S01194 - NEW STANDING DATA                                 */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PARM &FILE1 &FILE2 &FILE3)             * *S01117*/
/**********  PGM        PARM(&PARM &FILE1 &FILE2 &FILE3 &RSEQ &RLEV +
                            &RENT)                              */                 /*S01117 CLE134*/
/**********  PGM        PARM(&PARM &FILE1 &FILE2 &FILE3 &RSEQ &RLEV +
                          &RENT &RERUN) */                                      /*CLE134 AR1061796*/
             PGM        PARM(&PARM &FILE1 &FILE2 &FILE3 &RERUN &RSEQ +
                          &RLEV &RENT)                                                 /*AR1061796*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(10)
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)             */  /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,LEH01022                                            */
             CHGVAR     VAR(&MSG) +
                        VALUE('FILE CONTROLS OUT OF BALANCE ' *CAT +
                        &FILE1 *CAT &FILE2 )
/**/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,LEH01023                                            */
/**/
     IF         COND(&PARM *EQ 'LEC0707' *OR &PARM *EQ 'LEC0708' +
                    *OR &PARM *EQ 'LEC0709' *OR &PARM *EQ +
                    'LEC0710' *OR &PARM *EQ 'LEC0711') +
                    THEN(DO)                                          /*S01117*/
                    CALL       PGM(&PARM) PARM(&RSEQ &RLEV &RENT)     /*S01117*/
     ENDDO                                                            /*S01117*/
     ELSE       CMD(DO)                                               /*S01117*/
/**********  CALL       PGM(&PARM)                                   */                   /*CLE134*/
             IF         COND(&PARM *EQ 'LEC0706' *OR        +
                             &PARM *EQ 'LEC0703' *OR        +
                             &PARM *EQ 'LEC0704') THEN(CALL +
                          PGM(&PARM) PARM(&RERUN))
             ELSE       CMD(CALL PGM(&PARM))                                              /*CLE134*/
     ENDDO                                                            /*S01117*/
/**/
/**/
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA                  */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*       CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44)) */       /*S01194*/
         CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))          /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:         ENDPGM
