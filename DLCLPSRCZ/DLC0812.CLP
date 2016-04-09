/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Short Term Money Market Reporting')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/********DLC0810*-*SHORT*TERM*MONEY*MARKET*REPORTING*****************/
/*       DLC0812 - SHORT TERM MONEY MARKET REPORTING                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  E47978       DATE.   1FEB93                */
/*       PREV AMEND NO.  S01390       DATE.  24JUN92                */
/*                       AUS027       DATE.  11MAR91                */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       E47978  -  CLOF MUST BE MONITORED AS OPNDBF MAY FAIL IF NO */
/*                  RECORDS FOUND FOR KEY POSITION.  ALSO, CLOF IN  */
/*                  WRONG PLACE.                                    */
/*       S01390  -  Release 10 Changes for Australianisation        */
/*       AUS027  -  AUSTRALIAN PRODUCT - SHORT TERM MM REPORT       */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/************PGM                                                     * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01390*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) +
                        VALUE('JOB TERMINATED - DATABASE ERROR')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) +
                        VALUE('FILE CONTROLS OUT OF BALANCE')
/**/
/*      SHORT TERM MONEY MARKET EXTRACT                             */
/**/
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('Short Term Money Market Extract') +
                          TOMSGQ(MRUNQ)
             CLRPFM     FILE(STMMRH)
             CLRPFM     FILE(STMMRD)
             CLRPFM     FILE(STMMRT)
/************OVRDBF     FILE(TABLE)  TOFILE(TABDLEI)                 * *S01390*/
/**/
             CALL       PGM(DL6810)
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
                GOTO       END
             ENDDO
             IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                SNDMSG     MSG(&MSG2) TOMSGQ(MOPERQ)
                GOTO       END
             ENDDO
/**/
             SNDMSG     MSG('Short Term Money Market Report') +
                          TOMSGQ(MRUNQ)
/************CALL       PGM(DL6812)                                  * *S01390*/
/**/                                                                  /*S01390*/
/*  SYSTEM LEVEL REPORT */                                            /*S01390*/
/**/                                                                  /*S01390*/
             IF         COND(&RLVL *EQ 'S') THEN(DO)                  /*S01390*/
                CALL       PGM(DL6812) PARM(&RSEQ)                    /*S01390*/
             ENDDO                                                    /*S01390*/
/**/                                                                  /*S01390*/
/*  BRANCH LEVEL REPORT */                                            /*S01390*/
/**/                                                                  /*S01390*/
             ELSE IF COND(&RLVL *EQ 'B') THEN(DO)                     /*S01390*/
/**/                                                                  /*S01390*/
/*  POSITION FILE IF FOR A SPECIFIC BRANCH */                         /*S01390*/
/**/                                                                  /*S01390*/
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                          '   ')) THEN(DO)                            /*S01390*/
                OVRDBF   FILE(STMMRL1) POSITION(*KEY 1 STMMRDF &RENT) /*S01390*/
                OPNDBF     FILE(STMMRL1) OPTION(*ALL)                 /*S01390*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*S01390*/
                   DLTOVR     FILE(STMMRL1)                           /*S01390*/
                ENDDO                                                 /*S01390*/
/***************CLOF       OPNID(STMMRL1)                  /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
                CALL       PGM(DL6813) PARM(&RSEQ &RENT)              /*S01390*/
                CLOF       OPNID(STMMRL1)                             /*E47978*/
                MONMSG CPF0000                                        /*E47978*/
             ENDDO                                                    /*S01390*/
/**/                                                                  /*S01390*/
/*  COMPANY LEVEL REPORT */                                           /*S01390*/
/**/                                                                  /*S01390*/
             ELSE       CMD(IF COND(&RLVL *EQ 'C') THEN(DO))          /*S01390*/
/**/                                                                  /*S01390*/
/*  POSITION FILE IF FOR A SPECIFIC COMPANY */                        /*S01390*/
/**/                                                                  /*S01390*/
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                          '   ')) THEN(DO)                            /*S01390*/
                OVRDBF   FILE(STMMRL2) POSITION(*KEY 1 STMMRDF &RENT) /*S01390*/
                OPNDBF     FILE(STMMRL2) OPTION(*ALL)                 /*S01390*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*S01390*/
                   DLTOVR     FILE(STMMRL2)                           /*S01390*/
                ENDDO                                                 /*S01390*/
/***************CLOF       OPNID(STMMRL2)                  /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
                CALL       PGM(DL6814) PARM(&RSEQ &RENT)              /*S01390*/
                CLOF       OPNID(STMMRL2)                             /*E47978*/
                MONMSG CPF0000                                        /*E47978*/
             ENDDO                                                    /*S01390*/
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
                GOTO       END
             ENDDO
/**/
             IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                SNDMSG     MSG(&MSG2)  TOMSGQ(MOPERQ)
                GOTO       END
             ENDDO
 
             DLTOVR     FILE(*ALL)
 
END:
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
