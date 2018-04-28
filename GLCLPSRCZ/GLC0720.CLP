/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Bal in Orig.Ccy, Indiv a/c level')           */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC0720 Call GL Balances components which run GL0720,      */
/*               ie. in Original ccy, individual a/c level          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E42846         DATE  16JUL92                */
/*       PREV AMEND NO. E40440         DATE  22MAY92                */
/*                      S01369         DATE  06APR92                */
/*                      BHF798         DATE  24APR91                */
/*                      LN0529         DATE  10AUG90                */
/*                                                                  */
/********************************************************************/
/*       E42846 - PRODUCE TEXT ON GL0720                            */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       S01369  -  Allow user to request on request GL balance     */
/*                  reports after POST 1,2,4,3, and 5.              */
/*       BHF798  -  FIX TO CLOF INCASE OF MULTIPLE CALL             */
/*       LN0529  -  IF ONE OVERRIDE NOT FOUND OTHER IS NOT DONE     */
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
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)    /*E42846*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*                                                                   */
             DCL        VAR(&GLEX) TYPE(*DEC) LEN(3 0) VALUE(041)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
/*                                                                   */
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
                          OVRDBF FILE(GLX01) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
                          OPNDBF FILE(GLX01) OPTION(*ALL)
                          MONMSG MSGID(CPF0000) EXEC(DO)
                          DLTOVR FILE(GLX01)
                          ENDDO
                          ENDDO
             IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC51) +
                 PARM(&RUNTYPE &RSEQ &RENT))                      /*E42846*/
/**********      PARM(&RSEQ &RENT))                                 E42846*/
             IF         COND(&RLEV *EQ 'B' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
                          OVRDBF FILE(GLX02) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
                          OPNDBF FILE(GLX02) OPTION(*ALL)
                          MONMSG MSGID(CPF0000) EXEC(DO)
                          DLTOVR FILE(GLX02)
                          ENDDO
                          ENDDO
             IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC52) +
                 PARM(&RUNTYPE &RSEQ &RENT))                      /*E42846*/
/**********      PARM(&RSEQ &RENT))                                 E42846*/
 /***********IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC53) +            E40440*/
 /***********             THEN(CALL PGM(GLC53) PARM(&RSEQ &RENT))      E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                    THEN(CALL PGM(GLC53) PARM(&RUNTYPE &RSEQ &RENT)) /*E42846*/
/**********         THEN(CALL PGM(GLC53) PARM(&RSEQ &RENT))  *E40440* *E42846*/
/************DLTOVR     FILE(GLX01 GLX02)*/                           /*LN0529*/
             DLTOVR     FILE(GLX01)                                   /*LN0529*/
             MONMSG     MSGID(CPF9841)                                /*LN0529*/
             DLTOVR     FILE(GLX02)                                   /*LN0529*/
             MONMSG     MSGID(CPF9841)
             /*BHF798*/
             CLOF       OPNID(GLX01)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(GLX02)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             /*BHF798*/
/*                                                                   */
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             ENDPGM
