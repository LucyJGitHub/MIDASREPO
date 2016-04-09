/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MM Deals At Call Report')                    */
/********************************************************************/
/*                                                                  */
/*       Midas     - Dealing Module                             */
/*                                                                  */
/*       DLC7060  -  MM DEALS AT CALL REPORT                        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E47978            DATE:  1FEB93             */
/*       PREV AMEND NO. S01390            DATE: 26JUN92             */
/*                      S01179            DATE: 17/01/89            */
/*                      AUS028            DATE: 01/07/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       E47978 - CLOF MUST BE MONITORED AS OPNDBF MAY FAIL IF NO   */
/*                RECORDS FOUND FOR KEY POSITION.  ALSO, CLOF IN    */
/*                WRONG PLACE.                                      */
/*       S01390 - Release 10 Changes for Australianisation          */
/*       S01179 - AS/400 CONVERSION                                 */
/*                                                                  */
/*       AUS028 - AUSTRALIAN PRODUCT - MONEY AT CALL LISTS          */
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01390*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01390*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01390*/
/*           DCLDTAARA  DTAARA(LDA)                                     S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             SNDPGMMSG  MSG('MM Deals at Call') +
                                   TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
             CLRPFM     FILE(CALLMAA)
/**/
             CALL       DL7055
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*              RCVDTAARA  DTAARA(LDA)                                  S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01390*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01390*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/************CALL       DL7060                                       * *S01390*/
/**/                                                                  /*S01390*/
/*  SYSTEM LEVEL REPORT */                                            /*S01390*/
/**/                                                                  /*S01390*/
             IF         COND(&RLVL *EQ 'S') THEN(DO)                  /*S01390*/
                CALL       PGM(DL7059) PARM(&RSEQ)                    /*S01390*/
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
                OVRDBF  FILE(CALLM) POSITION(*KEY 1 CALLMAAR &RENT)   /*S01390*/
                OPNDBF     FILE(CALLM) OPTION(*ALL)                   /*S01390*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*S01390*/
                   DLTOVR     FILE(CALLM)                             /*S01390*/
                ENDDO                                                 /*S01390*/
/***************CLOF       OPNID(CALLM)                    /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
                CALL       PGM(DL7060) PARM(&RSEQ &RENT)              /*S01390*/
                CLOF       OPNID(CALLM)                               /*E47978*/
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
                OVRDBF  FILE(CALLML1) POSITION(*KEY 1 CALLMAAR &RENT) /*S01390*/
                OPNDBF     FILE(CALLML1) OPTION(*ALL)                 /*S01390*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*S01390*/
                   DLTOVR     FILE(CALLML1)                           /*S01390*/
                ENDDO                                                 /*S01390*/
/***************CLOF       OPNID(CALLML1)                  /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
                CALL       PGM(DL7061) PARM(&RSEQ &RENT)              /*S01390*/
                CLOF       OPNID(CALLML1)                             /*E47978*/
                MONMSG CPF0000                                        /*E47978*/
             ENDDO                                                    /*S01390*/
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*              RCVDTAARA  DTAARA(LDA)                                  S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01390*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01390*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CLRPFM     CALLMAA
                DLTOVR     FILE(*ALL)                                 /*S01390*/
             ENDDO
/**/
             CHGJOB     SWS(00000000)
/**/
/************END:         ENDPGM                                     * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01390*/
