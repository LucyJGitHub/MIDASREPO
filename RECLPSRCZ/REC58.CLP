/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Adjs to Acc'd Int Input Today')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC58 - ADJS. TO ACCRUED INT. INPUT TODAY                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413             DATE 13APR93              */
/*       PREV AMEND NO. BHF982                  19FEB91              */
/*                      BHF798                  09OCT90              */
/*                      LN0316                  28JUN90              */
/*                      HK0000                  16FEB90              */
/*                      S01117                  16MAR90              */
/*                      E20078                  21NOV89              */
/*                      S01098                  08JUL86              */
/*                      E0227                   29AUG84              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413  -  Header Box Standardised                          */
/*       BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                     */
/*       BHF798  -  FIX TO CLOF INCASE OF MULTIPLE CALL              */
/*       LN0316  -  PROGRAM TRIES TO DELETE AN OVERRIDE THAT         */
/*                  HAS ALREADY BEEN DELETED                         */
/*       HK0000  -  (ERROR RAISED BY CPS AS PECO E20078) REPORT      */
/*                  SEQUENCE INCORRECT IN RE0580. AMENDED TO INPUT   */
/*                  FROM LF/MADJ INSTEAD OF LF/MADJRE. I.E. REMOVE   */
/*                  OVERRIDE TO FILE.                                */
/*       S01117  -  MULTIBRANCHING.                                  */
/*       E20078  -  ADJUSTMENTS TO ACCRUED INTEREST REPORT BEING     */
/*                  PRINTED IN WRONG SEQUENCE.                       */
/*       S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,         */
/*                  INSTEAD OF CLEARING AND ADDING                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM PARM(&STAT)                                          /*S01117*/
             PGM PARM(&STAT &RSEQ &RLEV &RENT)                        /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
             DCL VAR(&RLEV) TYPE(*CHAR) LEN(1)                        /*S01117*/
             DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
             DCL VAR(&STAT) TYPE(*CHAR) LEN(1)
/**/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/**/
             SNDPGMMSG MSG('REC58 - Adjustments to Accrued Interest Input +
                       Today') TOMSGQ(MRUNQ)
/**/
             IF COND(&STAT *EQ 'I') THEN(CHGJOB SWS(1XXXXXXX))
             ELSE CMD(CHGJOB SWS(00000000))
/**/
/*********   CLRPFM FILE(MADJPF)                           **********  *S01098*/
/**/                                                                  /*S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILE OVER PHYSICAL BEFORE COPYING       */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
/*********   RMVM       FILE(MADJRE) MBR(MADJRE)   ************* E20078 S01098*/
             RMVM       FILE(MADJ) MBR(MADJ)                   /*E20078 S01098*/
             MONMSG     MSGID(CPF0000)                                /*S01098*/
/**/                                                                  /*S01098*/
/*********   CPYF FROMFILE(STRAN) TOFILE(MADJPF) MBROPT(*ADD) +******  *S01098*/
/*********        INCCHAR(*RCD 1 *EQ 'D') FMTOPT(*NOCHK)       ******  *S01098*/
             CPYF FROMFILE(STRAN) TOFILE(MADJPF) MBROPT(*REPLACE) +
                  INCCHAR(*RCD 1 *EQ 'D') FMTOPT(*NOCHK)              /*S01098*/
             MONMSG (CPF2817) CMPDTA(CPF2869) +
                    EXEC(CLRPFM MADJPF)                               /*S01098*/
/**/
/*********   ADDLFM     FILE(MADJRE) MBR(MADJRE)  ************** E20078 S01098*/
/*           ADDLFM     FILE(MADJ) MBR(MADJ)  */   /*E20078  S01098*/ /*BHF982*/
             ADDLFM     FILE(MADJ) MBR(MADJ) SHARE(*YES)              /*BHF982*/
             MONMSG     MSGID(CPF0000)                                /*S01098*/
/**/                                                                  /*S01098*/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/*********   OVRDBF FILE(MADJ)  TOFILE(MADJRE)    *************** E20078 E0227*/
/**/
/*********** CALL PGM(RE0580)                                         /*S01117*/
/**/                                                                  /*S01117*/
/*    ON-REQUEST MODE  */                                             /*S01117*/
/**/                                                                  /*S01117*/
             IF     COND((&STAT *EQ 'I')) THEN(DO)                    /*S01117*/
/*                  IF   COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +         */
/*                       THEN(OVRDBF FILE(MADJ) POSITION(*KEY 1 +             */
/*                            MADJPFF &RENT)                          /*S01117*/
                    IF   COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                         THEN(DO)                                     /*S01117*/
                         OVRDBF FILE(MADJ) POSITION(*KEY 1 +
                              MADJPFF &RENT)                          /*S01117*/
                         OPNDBF FILE(MADJ) OPTION(*ALL)               /*S01117*/
                         MONMSG MSGID(CPF0000) EXEC(DO)               /*S01117*/
                         DLTOVR FILE(MADJ)                            /*S01117*/
                         ENDDO                                        /*S01117*/
                         ENDDO                                        /*S01117*/
/**/                                                                  /*S01117*/
                    CALL PGM(RE0580) PARM(&RSEQ &RENT)                /*S01117*/
             ENDDO                                                    /*S01117*/
/**/                                                                  /*S01117*/
/*    OTHERWISE, C.O.B. MODE  */                                      /*S01117*/
/**/                                                                  /*S01117*/
             ELSE   CMD(DO)                                           /*S01117*/
                    CALL PGM(RE0580) PARM('     ' 'ALL')              /*S01117*/
             ENDDO                                                    /*S01117*/
/**/
             DLTOVR FILE(TABLE)
/**/                                                                  /*S01117*/
             IF     COND((&STAT *EQ 'I')) THEN(DO)                    /*S01117*/
                    IF   COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*LN0316*/
/*                       THEN(DLTOVR FILE(MADJ))        */ /*S01117*/ /*LN0316*/
                           DLTOVR FILE(MADJ)                          /*LN0316*/
                           MONMSG MSGID(CPF9841)                      /*LN0316*/
                      ENDDO                                           /*LN0316*/
             ENDDO                                                    /*S01117*/
/**/                                                                  /*BHF798*/
             CLOF       OPNID(MADJ)                                   /*BHF798*/
                          MONMSG MSGID(CPF0000)                       /*BHF798*/
/**/
/*********** IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                      /*S01117*/
             IF     COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)             /*S01117*/
                    IF COND(%SWITCH(XXXXXX1X)) THEN(DO)               /*S01117*/
                       RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)        /*S01117*/
                       CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))      /*S01117*/
                       SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                                 MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)    /*S01117*/
                    ENDDO                                             /*S01117*/
                    ELSE CMD(DO)                                      /*S01117*/
                SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0580') TOMSGQ(MOPERQ)
                    ENDDO                                             /*S01117*/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
