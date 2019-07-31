/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Amount Accrual Listing report')              */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC1190 - AMOUNT ACCRUAL LISTING REPORT                    */
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
/*       Prev Amend No. BHF798             Date 24Apr91              */
/*                      BHF207             Date 10Jul90              */
/*       PREV AMEND NO.  S01194              DATE  16/03/89         */
/*                       S01117              DATE  02/03/89         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BHF798 - FOR OPNDBF ADD CLOF .                             */
/*       BHF207 - OVRDBF TO AMACCL1 BRANCH REQUIRED BY REPORT       */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM*/                                                    /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(75)
/*********** DCL        VAR(&MEM)     TYPE(*CHAR) LEN(44) */          /*S01194*/
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)             /*S01194*/
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)              /*S01117*/
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)              /*S01117*/
/************DCL        VAR(&RENT)    TYPE(*CHAR) LEN(1) **/  /*S01117**BHF207*/
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)              /*BHF207*/
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)  +
                        TEXT('Midas SD Local Data Area')          /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
/**/
             CHGJOB   SWS(00000000)
/**/
/*********** OVRDBF     TABLE  TABGL*/                                /*S01194*/
/*********** OVRDBF     TABLED TABGL SHARE(*NO)*/                     /*S01194*/
             OVRDBF     MASTU  AMACC SHARE(*NO)
/**/
                   SNDPGMMSG  MSG('Amount Accrual Listing Report') +
                                TOMSGQ(MRUNQ)
/**/                                                                  /*BHF207*/
             IF (&RLEV *EQ 'B') THEN(DO)                              /*BHF207*/
             IF (&RENT *NE 'ALL' *AND &RENT *NE '   ') THEN(DO)       /*BHF207*/
             OVRDBF     FILE(AMACCL1) TOFILE(*FILE) POSITION(*KEY 1 +
                          AMACCDF &RENT) SEQONLY(*NO)                 /*BHF207*/
             OPNDBF     FILE(AMACCL1) OPTION(*INP)                    /*BHF798*/
                          MONMSG MSGID(CPF0000) EXEC(DO)              /*BHF798*/
                          DLTOVR FILE(AMACCL1)                        /*BHF798*/
                          ENDDO                                       /*BHF798*/
             ENDDO                                                    /*BHF207*/
             ENDDO                                                    /*BHF207*/
/**/                                                                  /*BHF207*/
/**********  CALL   GL1130*/                                          /*S01117*/
             CALL       PGM(GL1130) PARM(&RSEQ &RENT)                 /*S01117*/
/**/
                DLTOVR *ALL
/**/                                                                  /*BHF798*/
             CLOF       OPNID(AMACCL1)                                /*BHF798*/
                          MONMSG MSGID(CPF0000)                       /*BHF798*/
/**/
/*  SEND FILE CONTROL MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
               CHGVAR &MSG VALUE('FILE CONTROLS OUT OF BALANCE - FILE +
                                 AMACC')
               SNDPGMMSG &MSG TOMSGQ(MOPERQ)
               SNDPGMMSG &MSG TOPGMQ(*EXT)
             ENDDO
/**/
/*  SEND DATABASE MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/**/
                RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
/***********    CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 44)) */         /*S01194*/
                CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))            /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
