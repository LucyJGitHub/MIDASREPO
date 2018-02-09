/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Amount Accruals report by Ref No')           */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger module                        */
/*                                                                  */
/*       GLC1180 - AMOUNT ACCRUAL REPORT BY REFERENCE NUMBER        */
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
/*                      S01194             Date 16/03/89             */
/*       PREV AMEND NO. S01117               DATE  02/03/89         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BHF798 - FOR OPNDBF ADD CLOF .                             */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - MULTIBRANCHING                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM*/                                                    /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(75)
/*********** DCL        VAR(&MEM)     TYPE(*CHAR) LEN(44)*/           /*S01194*/
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)             /*S01194*/
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
/**/
             DCL        VAR(&RSEQ)   TYPE(*CHAR) LEN(5)               /*S01117*/
             DCL        VAR(&RLEV)   TYPE(*CHAR) LEN(1)               /*S01117*/
             DCL        VAR(&RENT)   TYPE(*CHAR) LEN(3)               /*S01117*/
/**/
/**/
/**/
             CHGJOB   SWS(00000000)
/**/
/*********** OVRDBF     TABLE  TABGL*/                                /*S01194*/
/**/
                   SNDPGMMSG  MSG('Amount Accrual By Reference +
                                  Number Report')  TOMSGQ(MRUNQ)
/**/
/**************CALL GL1180*/                                          /*S01117*/
                IF     COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
             OVRDBF     FILE(AMAXR) POSITION(*KEY 1 AMACCDF &RENT)    /*S01117*/
             OPNDBF FILE(AMAXR) OPTION(*ALL)                          /*S01117*/
             MONMSG MSGID(CPF0000) EXEC(DO)                           /*S01117*/
             DLTOVR FILE(AMAXR)                                       /*S01117*/
             ENDDO                                                    /*S01117*/
                        ENDDO                                         /*S01117*/
               CALL GL1180  PARM(&RSEQ &RENT)                         /*S01117*/
/**/
             DLTOVR *ALL                                              /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
/**/
/*  SEND FILE CONTROL MESSAGES  */
/**/
/*********** IF COND(%SWITCH(XXXXXXX1)) THEN(DO)*/                    /*S01194*/
             IF COND(%SWITCH(XXXXXX01)) THEN(DO)                      /*S01194*/
/**/
            CHGVAR &MSG VALUE('FILE CONTROLS OUT OF BALANCE - FILE +
                               AMAXR')
               SNDPGMMSG &MSG TOMSGQ(MOPERQ)
               SNDPGMMSG &MSG TOPGMQ(*EXT)
             ENDDO
/**/                                                                  /*BHF798*/
             CLOF       OPNID(AMAXR)                                  /*BHF798*/
                          MONMSG MSGID(CPF0000)                       /*BHF798*/
/**/
/*  SEND DATABASE MESSAGES  */
/**/
/*********** IF COND(%SWITCH(XXXXXX1X)) THEN(DO)  */                  /*S01194*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                      /*S01194*/
/**/
                RTVDTAARA DTAARA(LDA) RTNVAR(&LDA)
/***********    CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 44))*/          /*S01194*/
                CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))            /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
