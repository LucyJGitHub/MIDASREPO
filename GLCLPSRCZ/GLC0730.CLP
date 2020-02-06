/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Balances in Orig.Ccy, GL level')             */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC0730 Call GL Balances components which run GL0730,      */
/*               ie. in Original ccy, GL level                      */
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
/*       Prev Amend No. E42846             Date 16Jul92              */
/*                      E40440             Date 22May92              */
/*                      S01369         DATE 06APR92                 */
/*                      BHF798         DATE 24APR91                 */
/*                      LN0529         DATE  9AUG90                 */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       E42846 - PRODUCE TEXT ON GL0730                            */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       S01369  -  Allow user to request on request GL balance     */
/*                  reports after POST 1,2,4,3, and 5.              */
/*       BHF798 -  FIX TO CLOF INCASE OF MULTIPLE CALL              */
/*       LN0529 - WRONG FILES USED                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********   PGM        PARM(&RSEQ &RLEV &RENT)                E42846*/
             PGM        PARM(&RUNTYPE &RSEQ &RLEV &RENT)     /*E42846*/
/*                                                                   */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)    /*E42846*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*                                                                   */
             DCL        VAR(&GLEX)   TYPE(*DEC) LEN(3 0) VALUE(041)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/**/
             IF         COND(%SUBSTRING(&GLSTAT &GLEX 1) = 'N') +
                          THEN(CALL PGM(GLC50))
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/                                                                  /*S01369*/
/*  Reset the flag on GLSTAT so then the GL balance extract is not */ /*S01369*/
/*  run prior to any other GL balance on-req reports between       */ /*S01369*/
/*  GL posting phases 1,2,4,3 or 5                                 */ /*S01369*/
/**/                                                                  /*S01369*/
                   CHGDTAARA  DTAARA(GLSTAT (&GLEX 1)) VALUE('Y')     /*S01369*/
/**/
             IF         COND(&RLEV *EQ 'C' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
/**********                     OVRDBF FILE(GLX05) +    */  /*LN0529*/
                                OVRDBF FILE(GLX04) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
/**********               OPNDBF FILE(GLX05) OPTION(*ALL)*/ /*LN0529*/
                          OPNDBF FILE(GLX04) OPTION(*ALL)   /*LN0529*/
                          MONMSG MSGID(CPF0000) EXEC(DO)
/**********               DLTOVR FILE(GLX05)            */  /*LN0529*/
                          DLTOVR FILE(GLX04)                /*LN0529*/
                          ENDDO
                          ENDDO
             IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC54) +
                 PARM(&RUNTYPE &RSEQ &RENT))                      /*E42846*/
/**********      PARM(&RSEQ &RENT))                                 E42846*/
             IF         COND(&RLEV *EQ 'B' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
/***********                    OVRDBF FILE(GLX07) +     */ /*LN0529*/
                                OVRDBF FILE(GLX06) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
/***********              OPNDBF FILE(GLX07) OPTION(*ALL)*/ /*LN0529*/
                          OPNDBF FILE(GLX06) OPTION(*ALL)   /*LN0529*/
                          MONMSG MSGID(CPF0000) EXEC(DO)
/***********              DLTOVR FILE(GLX07)             */ /*LN0529*/
                          DLTOVR FILE(GLX06)                /*LN0529*/
                          ENDDO
                          ENDDO
             IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC55) +
                 PARM(&RUNTYPE &RSEQ &RENT))                      /*E42846*/
/**********      PARM(&RSEQ &RENT))                                 E42846*/
/*********** IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC56) +  E40440*/
/***********     PARM(&RSEQ &RENT))                          E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
             THEN(CALL PGM(GLC56) PARM(&RUNTYPE &RSEQ &RENT)) +
/**********  THEN(CALL PGM(GLC56) PARM(&RSEQ &RENT)) +    E42846*/
                          /* E40440 */
/************DLTOVR     FILE(GLX05 GLX07) */                /*LN0529*/
             DLTOVR     FILE(GLX04)                         /*LN0529*/
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(GLX06)                         /*LN0529*/
             MONMSG     MSGID(CPF9841)                      /*LN0529*/
             CLOF       OPNID(GLX04)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(GLX06)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/*                                                                   */
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             ENDPGM
