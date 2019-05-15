/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Int Type/Sub-Type applied to A/cs')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC6B - INT. SUB-TYPES RATE CHANGES APPLIED TO ACCOUNTS     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE095             Date 25Apr14              */
/*                      CRE083BV           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413             Date 13APR93              */
/*                      S01117                  16MAR90              */
/*                      S01194                  09MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE095 - Rate Fixing for RE Accounts                        */
/*       CRE083BV - COB Restructure - RE COB Optimistation Phase 1   */
/*       S01413  -  Header Box Standardised                          */
/*       S01117  -  Multibranching                                   */
/*       S01194  -  New Standing Data                                */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                          /*CRE095*/
             PGM     PARM(&CNAM &CSEQ)                                                    /*CRE095*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/                                                                                      /*CRE095*/
             DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)                                       /*CRE095*/
             DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                       /*CRE095*/
             DCL     VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                     /*CRE095*/
             DCL     VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                                   /*CRE095*/
             DCL     VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                                   /*CRE095*/
             DCL     VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                       /*CRE095*/
             DCL     VAR(&STEXT) TYPE(*CHAR) LEN(25)                                      /*CRE095*/
             DCL     VAR(&JOB) TYPE(*CHAR) LEN(10)                                        /*CRE095*/
             DCL     VAR(&USR) TYPE(*CHAR) LEN(10)                                        /*CRE095*/
             DCL     VAR(&NBR) TYPE(*CHAR) LEN(6)                                         /*CRE095*/
             DCL     VAR(&START) TYPE(*DEC) LEN(10 0)                                     /*CRE095*/
             DCL     VAR(&FINISH) TYPE(*DEC) LEN(10 0)                                    /*CRE095*/
/**/                                                                                      /*CRE095*/
             SNDPGMMSG MSG('REC6B - Interest Sub-Types Rate Changes Applied +
             To Accounts') TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(XXXXXX00)
/**/                                                                                      /*CRE095*/
/* Write current journal sequence number to file SCJSEQPD */                              /*CRE095*/
/**/                                                                                      /*CRE095*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CRE095*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *TCAT &CNAM +
                          *TCAT &CSEQA)                                                   /*CRE095*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                            /*CRE095*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                          /*CRE095*/
/**/
             CLRPFM FILE(ICHGA)
             CLRPFM FILE(ICHGR1)
             CLRPFM FILE(ICHGR2)
             CLRPFM FILE(ICHGR3)
             CLRPFM FILE(ICHGZ)
/**/
             SCRUNSQL   SQL('declare global temporary table REACCTD0 +
                          as (select * from V_REACCTK0 order by +
                          BRCA, CNUM, CCY, ACOD, ACSQ) with data') +
                                                                                        /*CRE083BV*/
                                                                                        /*CRE083BV*/
             OVRDBF     FILE(REACCTPD) TOFILE(REACCTD0) +
                          NBRRCDS(20000) LVLCHK(*NO) SEQONLY(*YES +
                          20000)                                                        /*CRE083BV*/
                                                                                        /*CRE083BV*/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             OVRDBF FILE(UPRIN) TOFILE(UPRID)
/**/
             CALL PGM(RE0641)
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0641') TOMSGQ(MOPERQ)
               ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/                                                                                      /*CRE095*/
/* Begin recovery from error. */                                                          /*CRE095*/
/**/                                                                                      /*CRE095*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                    /*CRE095*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) JOB(&NBR/&USR/&JOB) +
                          RTNSEQNBR(&START) RTNRCV(&SJRNRCVR)                             /*CRE095*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                   /*CRE095*/
             CHGVAR     VAR(&START) VALUE(0)                                              /*CRE095*/
             ENDDO                                                                        /*CRE095*/
/**/                                                                                      /*CRE095*/
/* Determine starting journal sequence */                                                 /*CRE095*/
/* number of current job. */                                                              /*CRE095*/
/**/                                                                                      /*CRE095*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') +
                          RECEIVER(&FJRNRCVR) SEQ(&FINISH)                                /*CRE095*/
/**/                                                                                      /*CRE095*/
/* Remove journal changes. */                                                             /*CRE095*/
/**/                                                                                      /*CRE095*/
             IF         COND((&START *NE 0) *AND +
                          (&FINISH *NE 0)) THEN(DO)                                       /*CRE095*/
             RMVJRNCHG  JRN(ICJRN) FILE((GLACNTQD)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH) +
                                                                                          /*CRE095*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 +
                          CPF7041)                                                        /*CRE095*/
             ENDDO                                                                        /*CRE095*/
/**/                                                                                      /*CRE095*/
             ENDDO
/**/
/**/                                                                                      /*CRE095*/
/* Write current journal sequence number to file SCJSEQPD */                              /*CRE095*/
/**/                                                                                      /*CRE095*/
WRTJRN:                                                                                   /*CRE095*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CRE095*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *TCAT &CNAM +
                          *TCAT &CSEQA)                                                   /*CRE095*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                          /*CRE095*/
             RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
