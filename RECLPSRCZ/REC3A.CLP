/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CUSTOMER EXCHGS - OVERRIDES TODAY')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*        REC3A  CUST. EXCHS. - EXCHANGE RATE OVERRIDE TAKEN TODAY  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD031950           Date 17Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      LN0316             Date 08Jun90              */
/*                      S01117             Date 16Mar90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*        MD031950 - Recompiled due to changed CUSEXZ1.              */
/*        LN0316 - PROGRAM TRIES TO DELETE AN OVERRIDE THAT         */
/*                 HAS ALREADY BEEN DELETED                         */
/*        S01117 - MULTIBRANCHING                                   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01117*/
             PGM     PARM(&STAT &RSEQ &RLEV &RENT)                    /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
             DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
             DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
             DCL     VAR(&STAT) TYPE(*CHAR) LEN(1)                    /*S01117*/
/**/                                                                  /*S01117*/
             SNDPGMMSG MSG('REC3A - Exchange Rate Override Taken Today') +
                       TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/**/                                                                  /*S01117*/
/*    ON-REQUEST MODE  */                                             /*S01117*/
/**/                                                                  /*S01117*/
             IF     COND((&STAT *EQ 'I')) THEN(DO)                    /*S01117*/
/*                  IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +           */
/*                     THEN(OVRDBF FILE(CEIP) POSITION(*KEY 1 +               */
/*                     CUSEXCEF &RENT)                                /*S01117*/
                    IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                       THEN(DO)                                       /*S01117*/
                       OVRDBF FILE(CEIP) POSITION(*KEY 1 +
                       CUSEXCEF &RENT)                                /*S01117*/
                       OPNDBF FILE(CEIP) OPTION(*ALL)                 /*S01117*/
                       MONMSG MSGID(CPF0000) EXEC(DO)                 /*S01117*/
                       DLTOVR FILE(CEIP)                              /*S01117*/
                       ENDDO                                          /*S01117*/
                       ENDDO                                          /*S01117*/
/*********** CALL PGM(RE0783)                                         /*S01117*/
                    CALL PGM(RE0783)   PARM(&RSEQ &RENT)              /*S01117*/
/**/
                    IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                       THEN(DO)                            /*S01117*/ /*LN0316*/
/*                     THEN(DLTOVR FILE(CEIP))             /*S01117*/ /*LN0316*/
                          DLTOVR FILE(CEIP)                           /*LN0316*/
                          MONMSG MSGID(CPF9841)                       /*LN0316*/
                       ENDDO                                          /*LN0316*/
             ENDDO                                                    /*S01117*/
/**/                                                                  /*S01117*/
/*    OTHERWISE, C.O.B. MODE  */                                      /*S01117*/
/**/                                                                  /*S01117*/
             ELSE   CMD(DO)                                           /*S01117*/
                    CALL PGM(RE0783) PARM('     ' 'ALL')              /*S01117*/
             ENDDO                                                    /*S01117*/
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/***********   IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                     *S01117*/
               IF COND(%SWITCH(XXXXXX01)) THEN(DO)                    /*S01117*/
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0783') TOMSGQ(MOPERQ)
               ENDDO
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                  SNDPGMMSG MSG('DATABASE IN ERROR - RE0783') TOMSGQ(MOPERQ)
               ENDDO
             ENDDO
/**/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
