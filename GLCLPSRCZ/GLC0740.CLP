/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Bal in one ccy, Indiv a/c level')            */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC0740 Call GL Balances components which run GL0740,      */
/*               ie. in a single ccy (Base,HO or Local), indiv.     */
/*                   a/c level                                      */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU011             Date 11Mar98              */
/*                      S01408             Date 04Aug95              */
/*                      E42846             Date 16Jul92              */
/*                      E40440         DATE  22MAY92                */
/*                      S01369         DATE  06APR92                */
/*                      BHF798         DATE  24APR91                */
/*                      LN0529         DATE  10AUG90                */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CEU011 - EMU Position/Risk Reporting                        */
/*       S01408 - Core hook added, GLC0740INT                       */
/*                Core hook added, GLC0750001                       */
/*       E42846 - PRODUCE TEXT ON GL0740                            */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       S01369  -  Allow user to request on request GL balance     */
/*                  reports after POST 1,2,4,3, and 5.              */
/*       BHF798  -  FIX TO CLOF INCASE OF MULTIPLE CALL             */
/*       LN0529  -  IF ONE OVERRIDE NOT FOUND OTHER IS NOT DONE     */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********** PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                E42846*/
             PGM        PARM(&RUNTYPE &RSEQ &RLEV &RENT &RPARM)     /*E42846*/
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
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/*                                                                   */
             DCL        VAR(&GLEX)   TYPE(*DEC) LEN(3 0) VALUE(041)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU011*/
             DCL        VAR(&CEU011) TYPE(*CHAR) LEN(1)               /*CEU011*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0740INT                                           /*S01408*/
                                                                      /*S01408*/
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/**/
             IF         COND(%SUBSTRING(&GLSTAT &GLEX 1) = 'N') +
                          THEN(CALL PGM(GLC50))
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/                                                                  /*S01369*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU011*/
             CHGVAR     VAR(&SARD) VALUE('CEU011')                    /*CEU011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*CEU011*/
                                                                      /*CEU011*/
/** Error occur on AOSARDR0                                        */ /*CEU011*/
                                                                      /*CEU011*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*CEU011*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                        /*CEU011*/
               CHGJOB  SWS(XXXXXX11)                                  /*CEU011*/
               GOTO       CMDLBL(END)                                 /*CEU011*/
             ENDDO                                                    /*CEU011*/
                                                                      /*CEU011*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU011) VALUE('Y'))                    /*CEU011*/
                                                                      /*CEU011*/
/*  Reset the flag on GLSTAT so then the GL balance extract is not */ /*S01369*/
/*  run prior to any other GL balance on-req reports between       */ /*S01369*/
/*  GL posting phases 1,2,4,3 or 5                                 */ /*S01369*/
/**/                                                                  /*S01369*/
                   CHGDTAARA  DTAARA(GLSTAT (&GLEX 1)) VALUE('Y')     /*S01369*/
/**/
             IF         COND(%SST(&RPARM 1 1) *NE 'E') THEN(DO)       /*CEU011*/
             IF         COND(&RLEV *EQ 'C' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
                          OVRDBF FILE(GLX10) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
                          OPNDBF FILE(GLX10) OPTION(*ALL)
                          MONMSG MSGID(CPF0000) EXEC(DO)
                          DLTOVR FILE(GLX10)
                          ENDDO
                          ENDDO
             IF         COND(&RLEV *EQ 'B' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
                          OVRDBF FILE(GLX11) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
                          OPNDBF FILE(GLX11) OPTION(*ALL)
                          MONMSG MSGID(CPF0000) EXEC(DO)
                          DLTOVR FILE(GLX11)
                          ENDDO
                          ENDDO
             ENDDO                                                    /*CEU011*/
/*                                                                   */
/* Call GLC57-59 for Base Ccy reports                                */
/*                                                                   */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0740001                                           /*S01408*/
                                                                      /*S01408*/
             IF  COND(%SST(&RPARM 1 1) *EQ 'B') THEN(DO)
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC57) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC58) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
/************** IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC59) +         E42846*/
/*************      PARM(&RSEQ &RENT))                                 E42846*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                     THEN(CALL PGM(GLC59) PARM(&RUNTYPE &RSEQ &RENT)) /*E42846*/
/*************       THEN(CALL PGM(GLC59) PARM(&RSEQ &RENT))     E40440 E42846*/
             ENDDO
/*/COPY WNCPYSRC,GLC0740002                                          */
/*                                                                   */
/* Call GLC66-68 for Head office ccy reports                         */
/*                                                                   */
             IF  COND(%SST(&RPARM 1 1) *EQ 'H') THEN(DO)
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC66) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/**********         PARM(&RSEQ &RENT))                         E42846*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC67) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/**********         PARM(&RSEQ &RENT))                         E42846*/
/**********     IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC68) + E40440*/
/**********         PARM(&RSEQ &RENT))                         E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                 THEN(CALL PGM(GLC68) PARM(&RUNTYPE &RSEQ &RENT))   /*E42846*/
/**********      THEN(CALL PGM(GLC68) PARM(&RSEQ &RENT))       E40440 E42846*/
             ENDDO
/*                                                                   */
/* Call GLC69-71 for Local ccy reports                               */
/*                                                                   */
             IF  COND(%SST(&RPARM 1 1) *EQ 'L') THEN(DO)
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC69) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/**********         PARM(&RSEQ &RENT))                         E42846*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC70) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/**********         PARM(&RSEQ &RENT))                         E42846*/
/**********     IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC71) + E40440*/
/**********         PARM(&RSEQ &RENT))                         E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
            THEN(CALL PGM(GLC71) PARM(&RUNTYPE &RSEQ &RENT)) /*E42846*/
/********** THEN(CALL PGM(GLC71) PARM(&RSEQ &RENT))     E40440 E42846*/
             ENDDO
                                                                      /*CEU011*/
/** Call GLC66E/GLC67E/GLC62 for Consolidated Euro Position Report */ /*CEU011*/
                                                                      /*CEU011*/
             IF         COND((&CEU011 *EQ 'Y') *AND (%SST(&RPARM +
                         1 1) *EQ 'E')) THEN(DO)                      /*CEU011*/
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC66E) +
                    PARM(&RUNTYPE &RSEQ &RENT))                       /*CEU011*/
                                                                      /*CEU011*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC67E) +
                    PARM(&RUNTYPE &RSEQ &RENT))                       /*CEU011*/
                                                                      /*CEU011*/
                IF  COND(&RLEV *EQ 'S' *OR (&RLEV *EQ ' ')) THEN(+
                    CALL PGM(GLC62) PARM(&RUNTYPE &RSEQ &RENT))       /*CEU011*/
             ENDDO                                                    /*CEU011*/
/*/COPY WNCPYSRC,GLC0740003                                          */
/*                                                                   */
/************DLTOVR     FILE(GLX10 GLX11)*/                          /*LN0529*/
             DLTOVR     FILE(GLX10)                                  /*LN0529*/
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(GLX11)                                  /*LN0529*/
             MONMSG     MSGID(CPF9841)                               /*LN0529*/
             CLOF       OPNID(GLX10)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(GLX11)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             DLTOVR     FILE(GLEXTRL1)                                /*CEU011*/
             MONMSG     MSGID(CPF9841)                                /*CEU011*/
             DLTOVR     FILE(GLEXTRL2)                                /*CEU011*/
             MONMSG     MSGID(CPF9841)                                /*CEU011*/
             CLOF       OPNID(GLEXTRL1)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*CEU011*/
             CLOF       OPNID(GLEXTRL2)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*CEU011*/
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:                                                                  /*CEU011*/
             ENDPGM
