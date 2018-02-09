/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE END OF DAY COMPONENT')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC06 - END OF DAY PROCESSING                              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD024291           Date 14Jan14              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      BHF363              Date 01Aug90            */
/*                      S01117              DATE 08FEB90            */
/*                      S01194              DATE 11DEC89            */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       MD024291 - COB Component LEC06 10001 ends in error         */
/*       CLE134 - Past Due Call Loan Processing                     */
/*       BHF363 - REMOVE CALL TO LEC0608. THIS SHOULD BE DONE VIA   */
/*                LEC06A                                            */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&ACCRA &PARM &FILE1 &FILE2 &POST)         *S01117*/
/*PGM******PARM(&ACCRA &PARM &FILE1 &FILE2 &POST &RSEQ &RLEV &RENT) */             /*S01117 CLE134*/
/*PGM******PARM(&ACCRA &PARM &FILE1 &FILE2 &POST &RSEQ &RLEV &RENT + */                 /*MD024291*/
/**********  &RERUN)                                                 */          /*CLE134 MD024291*/
             PGM        PARM(&RERUN &ACCRA &PARM &FILE1 &FILE2 &POST +
                          &RSEQ &RLEV &RENT)                                            /*MD024291*/
 
                                                                                          /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACCRA) TYPE(*CHAR) LEN(5)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
/**/
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/**/
             CHGJOB     SWS(00000000)
/**/
             IF         COND(&ACCRA *EQ 'ONE  ') THEN(CHGJOB  SWS(100XXXXX))
             IF         COND(&ACCRA *EQ 'TWO  ') THEN(CHGJOB  SWS(010XXXXX))
             IF         COND(&ACCRA *EQ 'THREE') THEN(CHGJOB  SWS(001XXXXX))
/**/
     IF         COND(&PARM *EQ 'LEC0607A  ' *OR &PARM *EQ 'LEC0607B') +
                THEN(DO)                                              /*S01117*/
        CALL       PGM(&PARM)  PARM(&RSEQ &RENT)                      /*S01117*/
     ENDDO                                                            /*S01117*/
                                                                                          /*CLE134*/
     ELSE       IF COND(&PARM *EQ 'LEC0606A') THEN(DO)                                    /*CLE134*/
                  CALL PGM(&PARM) PARM(&RERUN)                                            /*CLE134*/
     ENDDO                                                                                /*CLE134*/
                                                                                          /*CLE134*/
     ELSE       CMD(DO)                                               /*S01117*/
             IF         COND(&PARM *NE 'LEC0608   ') THEN(DO)
                CALL       PGM(&PARM)
             ENDDO
/**/
/************ELSE       CMD(DO)                                       /*BHF363*/
/************   CALL       PGM(&PARM) PARM(&POST)                     /*BHF363*/
/************ENDDO                                                    /*BHF363*/
     ENDDO                                                            /*S01117*/
/**/
             CHGJOB     SWS(000XXXXX)
/**/
/**/
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA                  */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/* CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))             */ /*S01194*/
   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))                /*S01194*/
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
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:         ENDPGM
