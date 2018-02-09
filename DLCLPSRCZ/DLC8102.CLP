/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Domestic MM brokerage accrual Report')       */
/********************************************************************/
/*                                                                  */
/*       Midas     - Dealing Module                             */
/*                                                                  */
/*       DLC8102 - BROKERAGE ACCRUAL REPORT                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 048654             Date 31Dec92              */
/*                      047978             Date 02Dec92              */
/*                      S01390             DATE  13JUL92            */
/*                      SA002              DATE  27/02/89           */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       048654 - DL8101 AND DL8103 DO NOT EXIST                    */
/*       047978 - CLOF MUST BE MONITORED AS OPNDBF MAY FAIL IF NO   */
/*                RECORDS FOUND FOR KEY POSITION.  ALSO, CLOF IN    */
/*                WRONG PLACE.                                      */
/*       S01390 - Release 10 Changes for Australianisation          */
/*       SA002  - AUSTRALIAN BROKERAGE                              */
/*                                                                  */
/********************************************************************/
/*****PGM                                                            * *S01390*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01390*/
/**********  PGM        PARM(&RSEQ &RLVL &RENT)               *S01390* *048654*/
             PGM        PARM(&RSEQ &RENT)                             /*048654*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01390*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
/*********   DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)       *S01390*  *048654*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01390*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01390*/
/**/                                                                  /*S01390*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01390*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01390*/
             CHGVAR     VAR(&SAR) VALUE('AUS007')                     /*S01390*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01390*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))                                /*S01390*/
 
             SNDPGMMSG  MSG('DLC8102 - Domestic money market +
                          brokerage accrual report') TOMSGQ(MRUNQ)
 
/**********                                                  *S01390* *048654*/
/*  SYSTEM LEVEL REPORT *                                    *S01390* *048654*/
/**********                                                  *S01390* *048654*/
/**********  IF         COND(&RLVL *EQ 'S') THEN(DO)         *S01390* *048654*/
/**********     CALL       PGM(DL8101) PARM(&RSEQ)           *S01390* *048654*/
/**********     MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO + *048654*/
/**********                CMDLBL(ABNOR))                    *S01390* *048654*/
/**********  ENDDO                                           *S01390* *048654*/
/**********                                                  *S01390* *048654*/
/*  BRANCH LEVEL REPORT *                                    *S01390* *048654*/
/**********                                                  *S01390* *048654*/
/**********  ELSE IF COND(&RLVL *EQ 'B') THEN(DO)            *S01390* *048654*/
/**                                                          *S01390* *048654*/
/*  POSITION FILE IF FOR A SPECIFIC BRANCH *                 *S01390* *048654*/
/**/                                                                  /*S01390*/
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                          '   ')) THEN(DO)                            /*S01390*/
                OVRDBF     FILE(BRKDL) POSITION(*KEY 1 BRKDLF &RENT)  /*S01390*/
                OPNDBF     FILE(BRKDL) OPTION(*ALL)                   /*S01390*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*S01390*/
                   DLTOVR     FILE(BRKDL)                             /*S01390*/
                ENDDO                                                 /*S01390*/
/***************CLOF       OPNID(BRKDL)                    /*S01390*/ /*047978*/
                ENDDO                                                 /*S01390*/
/************CALL       PGM(DL8102)                                  * *S01390*/
                CALL       PGM(DL8102) PARM(&RSEQ &RENT)              /*S01390*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
                CLOF       OPNID(BRKDL)                               /*047978*/
                MONMSG CPF0000                                        /*047978*/
/**********  ENDDO                                            *S01390* *048654*/
/**********                                                   *S01390* *048654*/
/*  COMPANY LEVEL REPORT */                                           /*S01390*/
/**********                                                   *S01390* *048654*/
/**********  ELSE       CMD(IF COND(&RLVL *EQ 'C') THEN(DO))  *S01390* *048654*/
/**********                                                   *S01390* *048654*/
/*  POSITION FILE IF FOR A SPECIFIC COMPANY *                 *S01390* *048654*/
/**********                                                   *S01390* *048654*/
/**********     IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
/**********               '   ')) THEN(DO)                    *S01390* *048654*/
/**********OVRDBF FILE(BRKDLL1) POSITION(*KEY 1 BRKDLF &RENT) *S01390* *048654*/
/**********     OPNDBF     FILE(BRKDLL1) OPTION(*ALL)         *S01390* *048654*/
/**********     MONMSG     MSGID(CPF0000) EXEC(DO)            *S01390* *048654*/
/**********        DLTOVR     FILE(BRKDLL1)                   *S01390* *048654*/
/**********     ENDDO                                         *S01390* *048654*/
/***************CLOF       OPNID(BRKDLL1)                  /*S01390*/ /*047978*/
/**********     ENDDO                                         *S01390* *048654*/
/**********     CALL       PGM(DL8103) PARM(&RSEQ &RENT)      *S01390* *048654*/
/**********     MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
/**********                CMDLBL(ABNOR))                     *S01390* *048654*/
/**********     CLOF       OPNID(BRKDLL1)                     *047978* *048654*/
/**********     MONMSG CPF0000                                *047978* *048654*/
/**********  ENDDO                                            *S01390* *048654*/
 
/*   UNSUCCESSFUL COMPLETION - SEND ERROR MESSAGE   */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (129 44)) RTNVAR(&MEM)         * *S01390*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01390*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MOPERQ)
             ENDDO
             GOTO END
 
 ABNOR:      SNDPGMMSG  MSG('DL8102 DID NOT COMPLETE') TOMSGQ(MOPERQ +
                          MRUNQ)
 
/************END:         ENDPGM                                     * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01390*/
