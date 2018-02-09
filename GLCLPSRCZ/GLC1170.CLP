/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Amount Accrual report by Account')           */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC1170 - AMOUNT ACCRUAL REPORT BY ACCOUNT                 */
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
/*                      BHF827             Date 23Nov90              */
/*       PREV AMEND NO. S01194               DATE  16/03/89         */
/*                      S01117               DATE  02/03/89         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BHF798 - FOR OPNDBF ADD CLOF .                             */
/*       BHF827 - SINCE ENTITY IS NOT THE FIRST KEY OF FILE AMAXA   */
/*                NEED TO JOIN IT WITH 'D' FOR OVRDBF COMMAND       */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM*/                                                    /*S01117*/
             PGM  (&RSEQ &RLEV &RENT)                                 /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(75)
/*********** DCL        VAR(&MEM)     TYPE(*CHAR) LEN(44)*/           /*S01194*/
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)             /*S01194*/
             DCL        VAR(&FIL)     TYPE(*CHAR) LEN(5)
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)              /*S01117*/
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)              /*S01117*/
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)              /*S01117*/
/**/
/**/
             CHGJOB   SWS(00000000)
/**/
/*********** OVRDBF     TABLE  TABGL*/                                /*S01194*/
/**/
                   SNDPGMMSG  MSG('Amount Accrual Report By Account') +
                                TOMSGQ(MRUNQ)
/**/
             CLRPFM AMAEXA
             CLRPFM AMAEXD
             CLRPFM AMAEXZ
/**/
/************CALL   GL1160*/                                          /*S01117*/
             CALL   PGM(GL1160) PARM(&RENT)                           /*S01117*/
/**/
           CHGVAR &FIL VALUE(AMACC)
/**/
               IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/***********    CALL GL1170*/                                         /*S01117*/
                IF     COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
/***********            OVRDBF     FILE(AMAXA)  +
                          POSITION(*KEY 1 AMAEXDF &RENT)      *S01117* *BHF827*/
                   OVRDBF     FILE(AMAXA) POSITION(*KEY 2 AMAEXDF +
                          ('D' *CAT &RENT))                           /*BHF827*/
                          OPNDBF FILE(AMAXA) OPTION(*ALL)             /*S01117*/
                          MONMSG MSGID(CPF0000) EXEC(DO)              /*S01117*/
                          DLTOVR FILE(AMAXA)                          /*S01117*/
                        ENDDO                                         /*S01117*/
                        ENDDO                                         /*S01117*/
                CALL       PGM(GL1170) PARM(&RSEQ &RENT)              /*S01117*/
                DLTOVR     FILE(AMAXA)                                /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
/**/
           CHGVAR &FIL VALUE(AMAXA)
/**/
                ENDDO
/**/
             DLTOVR *ALL
/**/                                                                  /*BHF798*/
             CLOF       OPNID(AMAXA)                                  /*BHF798*/
                          MONMSG MSGID(CPF0000)                       /*BHF798*/
/**/
/*  SEND FILE CONTROL MESSAGES  */
/**/
/*********** IF COND(%SWITCH(XXXXXXX1)) THEN(DO)*/                    /*S01194*/
             IF COND(%SWITCH(XXXXXX01)) THEN(DO)                      /*S01194*/
/**/
               CHGVAR &MSG VALUE('FILE CONTROLS OUT OF BALANCE - FILE ' +
                                 *CAT &FIL)
               SNDPGMMSG &MSG TOMSGQ(MOPERQ)
               SNDPGMMSG &MSG TOPGMQ(*EXT)
             ENDDO
/**/
/*  SEND DATABASE MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/**/
                RTVDTAARA DTAARA(LDA)  RTNVAR(&LDA)
/***********    CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 44))*/          /*S01194*/
                CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))            /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
