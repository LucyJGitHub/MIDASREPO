/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE END OF DAY COMPONENT')                       */
/********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       LEC06A - END OF DAY PROCESSING                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE025             Date 20Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      BHF694             Date 21Sep90              */
/*                      S01117             Date 13Dec90              */
/*                                                                  */
/********************************************************************/
/*      CLE134 - Past Due Call Loan Processing                      */
/*      CLE025 - Credit Lines                                       */
/*      BHF694 - LEC0608 NEEDS PARAMETER &POST AS WELL AS           */
/*             - COMPONENT NAME AND SEQUENCE NUMBER                 */
/*      S01117 - MULTIBRANCHING REL.10                              */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&ACCRA &PARM &FILE1 &FILE2 &POST &CNAM +
                          &CSEQ) */                                                       /*CLE134*/
             PGM        PARM(&ACCRA &PARM &FILE1 &FILE2 &POST &CNAM +
                           &CSEQ &RERUN)                                                  /*CLE134*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACCRA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE025*/
             DCL        VAR(&SARO) TYPE(*CHAR) LEN(6)                                     /*CLE025*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE025*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CLE025*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CLE025*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
/**/
             CHGJOB     SWS(00000000)
/**/                                                                                      /*CLE025*/
/* Check if CLE025 is installed */                                                        /*CLE025*/
/**/                                                                                      /*CLE025*/
             CHGVAR     VAR(&SARO) VALUE('CLE025')                                        /*CLE025*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARO &FMT)                        /*CLE025*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&CLE025) VALUE('Y'))                                     /*CLE025*/
             ELSE       CMD(CHGVAR VAR(&CLE025) VALUE('N'))                               /*CLE025*/
/**/
             IF         COND(&ACCRA *EQ 'ONE  ') THEN(CHGJOB  SWS(100XXXXX))
             IF         COND(&ACCRA *EQ 'TWO  ') THEN(CHGJOB  SWS(010XXXXX))
             IF         COND(&ACCRA *EQ 'THREE') THEN(CHGJOB  SWS(001XXXXX))
/**/
/*           IF         COND(&PARM *EQ 'LEC0608') THEN(CALL +  S01270*/
/*                        PGM(&PARM) PARM(&POST &CNAM &CSEQ))  BHF694 S01270*/
/*****IF***      COND((&PARM *EQ 'LEC0608') *OR (&PARM *EQ +                              /*CLE134*/
/**********               'LEC0608A')) THEN(CALL PGM(&PARM) +                             /*CLE134*/
/**********               PARM(&POST &CNAM &CSEQ))                              */ /*BHF694 CLE134*/
             IF         COND(&PARM *EQ 'LEC0608') THEN(CALL +
                          PGM(&PARM) PARM(&POST &CNAM &CSEQ))                             /*CLE134*/
             ELSE       IF COND(&PARM *EQ 'LEC0608A') THEN(CALL +
                          PGM(&PARM) PARM(&POST &CNAM &CSEQ &RERUN))                      /*CLE134*/
             ELSE       IF COND( (&PARM *EQ 'LEC0603A') +
                           *OR (&PARM *EQ 'LEC0604') +
                           *OR (&PARM *EQ 'LEC0609A') +
                           *OR (&PARM *EQ 'LEC0605')) THEN(DO)
                           CALL PGM(&PARM) PARM(&CNAM &CSEQ &RERUN)                       /*CLE134*/
             ENDDO                                                                        /*CLE134*/
                                                                                          /*CLE134*/
             ELSE       CMD(CALL PGM(&PARM) PARM(&CNAM &CSEQ))        /*S01270*/
/************CALL       PGM(&PARM) PARM(&CNAM &CSEQ)                   *BHF694*/
/**/
             CHGJOB     SWS(000XXXXX)
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA                  */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***********  CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))*/   /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             CHGVAR     VAR(&MSG) +
                        VALUE('FILE CONTROLS OUT OF BALANCE ' *CAT +
                        &FILE1 *CAT &FILE2 )
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
             ENDDO
/**/                                                                                      /*CLE025*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CLE025*/
               IF         COND(&CLE025 = 'Y') THEN(DO)                                    /*CLE025*/
                DLTF       FILE(XLEFCLTQD)                                                /*CLE025*/
                MONMSG     MSGID(CPF2105)                                                 /*CLE025*/
               ENDDO                                                                      /*CLE025*/
             ENDDO                                                                        /*CLE025*/
/**/                                                                                      /*CLE025*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:         ENDPGM
