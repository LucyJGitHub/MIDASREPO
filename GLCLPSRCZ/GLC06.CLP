/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Customer Account Balances enquiry')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - General Ledger Module                          */
/*                                                                   */
/*       GLC06 - CUSTOMER ACCOUNT BALANCES ENQUIRY                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 247110             Date 25Apr07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      239795             Date 16May06              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      092963             Date  15Sep95             */
/*                      094525             Date  12Oct95             */
/*                      074576            DATE  18AUG94             */
/*                      S01314            DATE  29MAY91             */
/*                      S01131            DATE  07MAR91             */
/*                      E23416            DATE  10SEP90             */
/*                      E19825            DATE  22FEB90             */
/*                      S01194            DATE  16MAR89             */
/*                      S01127            DATE  03/06/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       247110 - Ensure switch U5 is set off before calling enquiry */
/*       239795 - Create data area DLSDS in QTEMP to avoid database  */
/*                error when selecting DL transactions from          */
/*                Account Movements screen.                          */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       092963  -  Clear DTAARA *LDA used in linked enquiries      */
/*       094525  -  CPF0864 in GLC3271 because component shares     */
/*                  ODP with file defined as SHARE(*YES).           */
/*       074576  -  EMSDS not cleared when enquiries exited.        */
/*                  Accounts maint then behaves as account enquiry. */
/*       S01314  -  CHANGES FOR INCORPORATION                       */
/*       S01131  -  REWRITE OF GL0060 TO GL0061 FOR EM              */
/*       E23416  -  CHECK FOR INTEREST ON ACCOUNTS AS WELL AS       *  *E23416*/
/*                  RETAIL2                                         *  *E23416*/
/*       E19825  -  CHECK FOR RETAIL2 RATHER THAN RETAIL1           *  *E19825*/
/*       S01194  -  NEW STANDING DATA                               */
/*       S01127  -  FUTURES AND OPTIONS MODULE PRESENT ( U2 ON)     */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)            /*S01311*/
/**********  DCL        VAR(&EMSDS)  TYPE(*CHAR) LEN(161)                      /*S01311*/ /*CGL029*/
             DCL        VAR(&EMSDS)  TYPE(*CHAR) LEN(167)                                 /*CGL029*/
             DCL        VAR(&PGN1D)  TYPE(*CHAR) LEN(8)              /*S01311*/
             DCL        VAR(&RETND)  TYPE(*CHAR) LEN(1)              /*S01311*/
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)             /*S01311*/
/*/COPY WNCPYSRC,GLC06001                                            */
             OVRDBF     FILE(ACCNT)  TOFILE(ACCNT)  SHARE(*NO)       /*S01314*/
             OVRDBF     FILE(SDMMODPD) TOFILE(SDMMODPD) SHARE(*NO)   /*094525*/
                                                                     /*S01311*/
/*   IF POSITIONS 2 TO 9 ON DTAARA/EMSDS ARE BLANK, THIS IS THE   */ /*S01311*/
/*   FIRST ENQUIRY IN THE STACK, SO CLEAR DTAARA/EMSDS AND SET    */ /*S01311*/
/*   POSITIONS 2 TO 9 TO 'GLC06' TO INDICATE THAT THIS IS FIRST   */ /*S01311*/
/*   ENQUIRY IN STACK                                             */ /*S01311*/
                                                                     /*S01311*/
             RTVDTAARA DTAARA(EMSDS) RTNVAR(&EMSDS)                  /*S01311*/
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))          /*S01311*/
             IF COND(&PGN1D *EQ '        ') THEN(DO)                 /*S01311*/
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')                  /*S01311*/
                CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('GLC06   ')     /*S01311*/
             ENDDO                                                   /*S01311*/
                                                                     /*S01311*/
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')                      /*092963*/
/**/
             CHKOBJ     OBJ(QTEMP/DLSDS) OBJTYPE(*DTAARA)                                 /*239795*/
             MONMSG     MSGID(CPF9800) EXEC(DO)                                           /*239795*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                          /*239795*/
             ENDDO                                                                        /*239795*/
             CHGDTAARA  DTAARA(QTEMP/DLSDS) VALUE(' ')                                    /*239795*/
/**/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/*****       IF         COND(%SUBSTRING(&MMOD 3 1) = Y) THEN(CHGJOB + /*E19825*/
/*****                  SWS('1XXXXXXX'))                              /*E19825*/
/*****       IF         COND(%SUBSTRING(&MMOD 16 1) = Y) THEN(CHGJOB +
                          SWS('1XXXXXXX'))                   /*E19825***E23416*/
             IF         COND((%SUBSTRING(&MMOD 16 1) = Y) *OR +
                          (%SST(&MMOD 23 1) = Y)) THEN(CHGJOB +
                          SWS('1XXXXXXX'))                            /*E23416*/
/**/
             IF         COND(%SUBSTRING(&MMOD 50 1) = Y) THEN(CHGJOB +
                          SWS('X1XXXXXX'))                           /*S01127*/
/* Ensure switch U5 set off for non retail */                                             /*247110*/
             CHGJOB     SWS(XXXX0XXX)                                                     /*247110*/
/*********** OVRDBF     FILE(ACNTD) TOFILE(ACCNT)*/                  /*S01311*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/************OVRDBF     FILE(MEMO)  TOFILE(MEMOS)                 */ /*S01311*/
             OVRDBF     FILE(MEMO) TOFILE(MEMOS) SHARE(*NO)          /*S01311*/
/*********** CALL       PGM(GL0060)*/                                /*S01311*/
             CALL       PGM(GL0061)                                  /*S01311*/
/*********** DLTOVR     FILE(ACNTD)                                  /*S01311*/
/*********** DLTOVR     FILE(TABLE)*/                                 /*S01194*/
             DLTOVR     FILE(MEMO)
                                                                     /*S01311*/
/*   FOR LINKED ENQUIRIES, IF THIS IS FIRST ENQUIRY IN STACK,     */ /*S01311*/
/*   DETERMINE IF RETURN CODE IS 'E' INDICATING DATABASE ERROR    */ /*S01311*/
/*   HAS OCCURRED                                                 */ /*S01311*/
                                                                     /*S01311*/
             RTVDTAARA DTAARA(EMSDS) RTNVAR(&EMSDS)                  /*S01311*/
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))          /*S01311*/
/**********  CHGVAR     VAR(&RETND) VALUE(%SST(&EMSDS 161 1))        */        /*S01311*/ /*CGL029*/
             CHGVAR     VAR(&RETND) VALUE(%SST(&EMSDS 167 1))                             /*CGL029*/
                                                                     /*S01311*/
             IF COND((&PGN1D *EQ 'GLC06   ') *AND (&RETND *EQ 'E')) +
                THEN(DO)                                             /*S01311*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                  /*S01311*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01311*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)                             /*S01311*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)                               /*S01311*/
             ENDDO                                                   /*S01311*/
                                                                     /*S01311*/
/****RESET*POSITIONS 2 TO 9 ON EMSDS TO BLANK***************S01311*/ /*074576*/
                                                                     /*S01311*/
/*CHGDTAARA**DTAARA(EMSDS (2 8)) VALUE('        ')**********S01311*/ /*074576*/
                                                                     /*074576*/
/*   RESET ALL OF EMSDS TO BLANK                                  */ /*074576*/
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')                  /*074576*/
/**/
/*/COPY WNCPYSRC,GLC06002                                            */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
