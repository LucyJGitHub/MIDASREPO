/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Balances in one ccy, GL level')              */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC0750 Call GL Balances components which run GL0750,      */
/*               ie. in a single ccy (Base,HO or Local), GL level   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CEU011             Date 11Mar98              */
/*       Prev Ament No. S01408             Date 04Aug95              */
/*                      E42846             Date 16Jul92              */
/*                      E40440         DATE  22MAY92                */
/*                      S01369         DATE 06APR92                 */
/*                      BHF798         DATE 24APR91                 */
/*                      LN0529         DATE 13AUG90                 */
/*                                                                  */
/********************************************************************/
/*       CEU011 - EMU Position/Risk Reporting                        */
/*       S01408 - Core hook added, GLC0750INT                       */
/*                Core hook added, GLC0750001                       */
/*       E42846 - PRODUCE TEXT ON GL0750                            */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       S01369  -  Allow user to request on request GL balance     */
/*                  reports after POST 1,2,4,3, and 5.              */
/*       BHF798  -  FIX TO CLOF INCASE OF MULTIPLE CALL             */
/*       LN0529  -  OVERRIDE TO LOGICAL NOT PHYSICAL                */
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
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)    /*E42846*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/*                                                                   */
             DCL        VAR(&GLEX) TYPE(*DEC) LEN(3 0) VALUE(041)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU011*/
             DCL        VAR(&CEU011) TYPE(*CHAR) LEN(1)               /*CEU011*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0750INT                                           /*S01408*/
                                                                      /*S01408*/
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/**/
             IF         COND(%SUBSTRING(&GLSTAT &GLEX 1) = 'N') +
                          THEN(CALL PGM(GLC50))
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                                                                      /*CEU011*/
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
                                  TOMSGQ(MOPERQ)                      /*CEU011*/
               CHGJOB  SWS(XXXXXX11)                                  /*CEU011*/
               GOTO       CMDLBL(END)                                 /*CEU011*/
             ENDDO                                                    /*CEU011*/
                                                                      /*CEU011*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU011) VALUE('Y'))                    /*CEU011*/
/**/                                                                  /*S01369*/
/*  Reset the flag on GLSTAT so then the GL balance extract is not */ /*S01369*/
/*  run prior to any other GL balance on-req reports between       */ /*S01369*/
/*  GL posting phases 1,2,4,3 or 5                                 */ /*S01369*/
/**/                                                                  /*S01369*/
                   CHGDTAARA  DTAARA(GLSTAT (&GLEX 1)) VALUE('Y')     /*S01369*/
/**/
           IF   COND(&CEU011 *NE 'Y')  THEN(DO)                       /*CEU011*/
             IF         COND(&RLEV *EQ 'C' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
/***********              OVRDBF FILE(GLX14) +*/                     /*LN0529*/
                          OVRDBF FILE(GLX13) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
/***********              OPNDBF FILE(GLX14) OPTION(*ALL)*/          /*LN0529*/
                          OPNDBF FILE(GLX13) OPTION(*ALL)            /*LN0529*/
                          MONMSG MSGID(CPF0000) EXEC(DO)
/***********              DLTOVR FILE(GLX14)*/                       /*LN0529*/
                          DLTOVR FILE(GLX13)                         /*LN0529*/
                          ENDDO
                          ENDDO
             IF         COND(&RLEV *EQ 'B' *AND &RENT *NE 'ALL' *AND +
                          &RENT *NE '   ') THEN(DO)
/************             OVRDBF FILE(GLX16) +*/                     /*LN0529*/
                          OVRDBF FILE(GLX15) +
                          POSITION(*KEY 1 GLEXGCF &RENT)
/************             OPNDBF FILE(GLX16) OPTION(*ALL)*/          /*LN0529*/
                          OPNDBF FILE(GLX15) OPTION(*ALL)            /*LN0529*/
                          MONMSG MSGID(CPF0000) EXEC(DO)
/***********              DLTOVR FILE(GLX16)*/                       /*LN0529*/
                          DLTOVR FILE(GLX15)                         /*LN0529*/
                          ENDDO
                          ENDDO
             ENDDO                                                    /*CEU011*/
/*                                                                   */
/* Call GLC72-74 for Base Ccy reports                                */
/*                                                                   */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0750001                                           /*S01408*/
                                                                      /*S01408*/
             IF  COND(%SST(&RPARM 1 1) *EQ 'B') THEN(DO)
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC72) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC73) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
/************   IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC74) + E40440*/
/************       PARM(&RSEQ &RENT))                         E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
             THEN(CALL PGM(GLC74) PARM(&RUNTYPE &RSEQ &RENT)) /*E42846*/
/**********  THEN(CALL PGM(GLC74) PARM(&RSEQ &RENT))     E40440 E42846*/
             ENDDO
/*/COPY WNCPYSRC,GLC0750002                                          */
/*                                                                   */
/* Call GLC75-77 for Head office ccy reports                         */
/*                                                                   */
             IF  COND(%SST(&RPARM 1 1) *EQ 'H') THEN(DO)
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC75) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC76) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
/************   IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC77) + E40440*/
/************       PARM(&RSEQ &RENT))                         E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
               THEN(CALL PGM(GLC77) PARM(&RUNTYPE &RSEQ &RENT)) /*E42846*/
/**********    THEN(CALL PGM(GLC77) PARM(&RSEQ &RENT))     E40440 E42846*/
             ENDDO
/*                                                                   */
/* Call GLC78-80 for Local ccy reports                               */
/*                                                                   */
             IF  COND(%SST(&RPARM 1 1) *EQ 'L') THEN(DO)
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC78) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC79) +
                    PARM(&RUNTYPE &RSEQ &RENT))              /*E42846*/
/************       PARM(&RSEQ &RENT))                         E42846*/
/************   IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC80) + E40440*/
/************       PARM(&RSEQ &RENT))                         E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                THEN(CALL PGM(GLC80) PARM(&RUNTYPE &RSEQ &RENT))  /*E42846*/
/************   THEN(CALL PGM(GLC80) PARM(&RSEQ &RENT))      E40440 E42846*/
             ENDDO
                                                                      /*CEU011*/
/**Call GLC75E/GLC76E/GLC77E for Consolidated Euro Position Report */ /*CEU011*/
                                                                      /*CEU011*/
           IF   COND(&CEU011 *EQ 'Y')  THEN(DO)                       /*CEU011*/
             IF  COND(%SST(&RPARM 1 1) *EQ 'E') THEN(DO)              /*CEU011*/
                IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(GLC75E) +
                       PARM(&RUNTYPE &RSEQ &RENT))                    /*CEU011*/
                                                                      /*CEU011*/
                IF  COND(&RLEV *EQ 'B') THEN(CALL PGM(GLC76E) +
                    PARM(&RUNTYPE &RSEQ &RENT))                       /*CEU011*/
                                                                      /*CEU011*/
                IF  COND(&RLEV *EQ 'S') THEN(CALL PGM(GLC77E) +
                    PARM(&RUNTYPE &RSEQ &RENT))                       /*CEU011*/
             ENDDO                                                    /*CEU011*/
           ENDDO                                                      /*CEU011*/
/*/COPY WNCPYSRC,GLC0750003                                          */
/*                                                                   */
/************DLTOVR     FILE(GLX14 GLX16)                               LN0529*/
             DLTOVR     FILE(GLX13)                                   /*LN0529*/
             MONMSG     MSGID(CPF9841)                                /*LN0529*/
             DLTOVR     FILE(GLX15)                                   /*LN0529*/
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(GLEXTRL4)                                /*CEU011*/
             MONMSG     MSGID(CPF9841)                                /*CEU011*/
             DLTOVR     FILE(GLEXTRL5)                                /*CEU011*/
             MONMSG     MSGID(CPF9841)                                /*CEU011*/
             CLOF       OPNID(GLX13)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(GLX15)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(GLEXTRL4)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*CEU011*/
             CLOF       OPNID(GLEXTRL5)                               /*CEU011*/
             MONMSG     MSGID(CPF0000)                                /*CEU011*/
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
END:                                                                  /*CEU011*/
             ENDPGM
