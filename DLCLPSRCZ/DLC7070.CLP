/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Outstanding Loans/Deposits Report')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                              */
/*                                                                   */
/*       DLC7070  -  OUTSTANDING LOANS/DEPOSITS BY CUSTOMER          */
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
/*       Prev Amend No. 061431             Date 07Jan94              */
/*                      E47978             Date 01Feb93              */
/*                      S01390             DATE 30AUG92              */
/*                      S01179             DATE 17/01/89             */
/*                      SA001              DATE 07/06/88             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       061431 - OVRDBF with POSITION replaced by OPNQRYF due to    */
/*                a generic problem with the command. If the key     */
/*                argument has trailing blanks the operation fails.  */
/*       E47978 - CLOF MUST BE MONITORED AS OPNDBF MAY FAIL IF NO    */
/*                RECORDS FOUND FOR KEY POSITION.  ALSO, CLOF IN     */
/*                WRONG PLACE.                                       */
/*       S01390 - Release 10 Changes for Australianisation           */
/*       S01179 - AS/400 CONVERSION                                  */
/*       SA001  - AUSTRALIAN RELEASE                                 */
/*                                                                   */
/*********************************************************************/
/**/
/************PGM                                                     * *S01390*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01390*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01390*/
/*           DCLDTAARA  DTAARA(LDA)                                     S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&QRYSEL) TYPE(*CHAR) LEN(80)             /*061431*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             SNDPGMMSG  MSG('Outstanding Loans/Deposits by Customer') +
                                   TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
             CLRPFM     FILE(ODEALAA)
/**/
             CALL       DL7065
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
/************CALL       DL7070                                       * *S01390*/
/**/                                                                  /*S01390*/
/*  SYSTEM LEVEL REPORT */                                            /*S01390*/
/**/                                                                  /*S01390*/
             IF         COND(&RLVL *EQ 'S') THEN(DO)                  /*S01390*/
                CALL       PGM(DL7069) PARM(&RSEQ)                    /*S01390*/
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
                                                                     /*061431*/
             CHGVAR     VAR(&QRYSEL) VALUE('BRCA="' *CAT &RENT +
                             *TCAT '"')                              /*061431*/
             OVRDBF     FILE(ODEAL) SHARE(*YES)                      /*061431*/
             OPNQRYF    FILE((ODEAL)) OPTION(*ALL) QRYSLT(&QRYSEL) +
                             KEYFLD(*FILE)                           /*061431*/
/************OVRDBF     FILE(ODEAL) POSITION(*KEY 1 +      */ /*S01390 061431*/
/************                ODEALAAF &RENT)               */ /*S01390 061431*/
/************OPNDBF     FILE(ODEAL) OPTION(*ALL)           */ /*S01390 061431*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)            */ /*S01390 061431*/
/************DLTOVR     FILE(ODEAL)                        */ /*S01390 061431*/
/************ENDDO                                         */ /*S01390 061431*/
/***************CLOF       OPNID(ODEAL)                    /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
                CALL       PGM(DL7070) PARM(&RSEQ &RENT)              /*S01390*/
                                                                     /*061431*/
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE  +
                             '   ')) THEN(DO)                        /*061431*/
                CLOF       OPNID(ODEAL)                               /*E47978*/
                MONMSG CPF0000                                        /*E47978*/
                DLTOVR     FILE(ODEAL)                               /*061431*/
                ENDDO                                                /*061431*/
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
                                                                     /*061431*/
             CHGVAR     VAR(&QRYSEL) VALUE('CMPYM="' *CAT &RENT +
                             *TCAT '"')                              /*061431*/
             OVRDBF     FILE(ODEALL1) SHARE(*YES)                    /*061431*/
             OPNQRYF    FILE((ODEALL1)) OPTION(*ALL)  +
                             QRYSLT(&QRYSEL) KEYFLD(*FILE)           /*061431*/
/************OVRDBF     FILE(ODEALL1) POSITION(*KEY 1 +    */ /*S01390 061431*/
/************                ODEALAAF &RENT)               */ /*S01390 061431*/
/************OPNDBF     FILE(ODEALL1) OPTION(*ALL)         */ /*S01390 061431*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)            */ /*S01390 061431*/
/************DLTOVR     FILE(ODEALL1)                      */ /*S01390 061431*/
/************ENDDO                                         */ /*S01390 061431*/
/***************CLOF       OPNID(ODEALL1)                  /*S01390*/ /*E47978*/
                ENDDO                                                 /*S01390*/
                CALL       PGM(DL7071) PARM(&RSEQ &RENT)              /*S01390*/
                                                                     /*061431*/
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE  +
                             '   ')) THEN(DO)                        /*061431*/
                CLOF       OPNID(ODEALL1)                             /*E47978*/
                MONMSG CPF0000                                        /*E47978*/
                DLTOVR     FILE(ODEALL1)                             /*061431*/
                ENDDO                                                /*061431*/
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
                CLRPFM     ODEALAA
             DLTOVR     FILE(*ALL)                                    /*S01390*/
             ENDDO
/**/
             CHGJOB     SWS(00000000)
/**/
/************END:         ENDPGM                                     * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01390*/
