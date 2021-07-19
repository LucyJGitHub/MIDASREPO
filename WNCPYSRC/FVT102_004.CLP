/*********************************************************************/
/*                                                                   */
/*       Midas - /COPY Member (CLP)                                  */
/*                                                                   */
/*       FVT102_004 - MCC0540 - Generate XX0541 report               */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. FVT102CC1          Date 06Jun17              */
/*       Prev Amend No. FVT102   *CREATE   Date 09May17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       FVT102CC1 - Posting of P/L to Mult. Retained Earnings CC1   */
/*       FVT102 - Posting of P/L to Multiple Retained Earnings       */
/*                                                                   */
/*********************************************************************/

/**  If FVT102 is *ON, then loop and read through the Mapped Spot Reval file (XXSRVLL1)   /*FVT102*/
/**  keyed by Foreign Currency and Spot Trade a/c code and select records using:          /*FVT102*/

/**     (1) the Spot Trading a/c code MBSRVL from the Mapped Spot Reval file.             /*FVT102*/
/**     (2) the Base Currency                                                             /*FVT102*/
/**     (3) the Spot Trade Equiv a/c code (MBSPAE) from the Mapped Spot Reval file.       /*FVT102*/

/**  Produce a separate XX0541 report for each Spot Trade a/c code & Foreign Currency.    /*FVT102*/
                                                                                          /*FVT102*/
             IF         COND(&FVT102 *EQ 'Y') THEN(DO)                                    /*FVT102*/

     /*      OVRDBF     FILE(XXSRVLL1) SHARE(*NO)      */                  /*FVT102*/  /*FVT102CC1*/
             OVRDBF     FILE(XXSRVLL7) SHARE(*NO)                                      /*FVT102CC1*/
             DLTOVR     FILE(MCSRRPOQ)                                                 /*FVT102CC1*/

/**Receive*record*from*XXSRVLL1.**************************************/    /*FVT102*/  /*FVT102CC1*/
/* Receive record from XXSRVLL7.                                     */                /*FVT102CC1*/
 LOOP:       RCVF                                                                         /*FVT102*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))                             /*FVT102*/

             IF         COND(&MBSRVL *EQ &MB_SRVL) THEN(GOTO LOOP)                     /*FVT102CC1*/
/**  Convert numeric account codes from XXSRVLPD to alpha fpr OPNQRYF.                    /*FVT102*/
/**  To prevent blank currency/account code if "no details to report",                    /*FVT102*/
/**  pass values to LDA for reporting.                                                    /*FVT102*/

             CHGVAR     VAR(&MB_FCCY) VALUE(&MBFCCY)                                      /*FVT102*/
             CHGVAR     VAR(&MB_SPTA) VALUE(&MBSRVL)                                      /*FVT102*/
             CHGVAR     VAR(&MB_SPAE) VALUE(&MBSPAE)                                      /*FVT102*/
             CHGDTAARA  DTAARA(LDA (204 3))  VALUE(&MB_FCCY)                              /*FVT102*/
             CHGDTAARA  DTAARA(LDA (207 10)) VALUE(&MB_SPTA)                              /*FVT102*/
/**/
/**  Select only records for the current period; only spot trade accounts */
/**  for the first GLHIBLPD and only foreign currency accounts for the second */
/**/
             CHGVAR     VAR(&RUNSQL1) VALUE('insert into mcsrrpoq +
                          (SELECT S.HBBRCD AS SRBRCD, S.HBCYCD AS +
                          SRCYCD, S.HBPCCD as QQACCD, S.HBCUST AS SRCUST, +
                          S.HBACSN AS SRACSN, S.HBPCCD AS SRPCCD, +
                          S.HBBKCD AS SRBKCD, S.HBOTTP AS SROTTP, +
                          S.HBTSTY AS SRTSTY, S.HBACNB AS SRASNB, +
                          S.HBPDCB AS SREPCB, EQ.HBPDCB * -1 AS +
                          SRBCEQ, C.A6SPRT AS SRSPRT, C.A6MDIN AS +
                          SRMDIN, C.A6NBDP AS SRNBDP, C.A6CYNM AS +
                          SRCYNM, S.HBACCD AS SRACCD FROM (SELECT +
                          S.HBPDCT, S.HBPDYR, S.HBPDNY, S.HBCGCD, +
                          S.HBBRCD, S.HBCYCD, S.HBACCD, S.HBCUST, +
                          S.HBACSN, S.HBPCCD, S.HBBKCD, S.HBOTTP, +
                          S.HBTSTY, S.HBACNB, S.HBPDCB, X.MBSPAE +
                          FROM GLHIBLPD AS S INNER JOIN XXSRVLPD AS +
                          X ON S.HBACCD = X.MBSRVL AND S.HBCYCD = +
                          X.MBFCCY WHERE S.HBPDCT = ')                                 /*FVT102CC1*/

             CHGVAR     VAR(&RUNSQL2) VALUE(' ' *CAT &QUOTE *TCAT &PDCT +
                          *TCAT &QUOTE *BCAT 'AND S.HBPDYR = ')                        /*FVT102CC1*/
             CHGVAR     VAR(&RUNSQL3) VALUE(' ' *CAT &QUOTE *TCAT &PDYR +
                          *TCAT &QUOTE *BCAT 'AND S.HBPDNY = ')                        /*FVT102CC1*/
             CHGVAR     VAR(&RUNSQL4) VALUE(' ' *CAT &QUOTE *TCAT &PDNY +
                          *TCAT &QUOTE *BCAT 'AND S.HBACCD = ')                        /*FVT102CC1*/
             CHGVAR     VAR(&RUNSQL5) VALUE(' ' *CAT &QUOTE *TCAT &MB_SPTA +
                          *TCAT &QUOTE)                                                /*FVT102CC1*/
             CHGVAR     VAR(&RUNSQL6) VALUE(') AS S INNER JOIN (SELECT +
                          E.HBPDCT, E.HBPDYR, E.HBPDNY, E.HBCGCD, E.HBBRCD, +
                          E.HBCYCD, E.HBACCD, E.HBCUST, E.HBACSN, +
                          E.HBPCCD, E.HBBKCD, E.HBOTTP, E.HBTSTY, +
                          E.HBACNB, E.HBPDCB FROM GLHIBLPD AS E) AS +
                          EQ ON S.HBPDCT = EQ.HBPDCT AND S.HBPDYR = +
                          EQ.HBPDYR AND S.HBPDNY = EQ.HBPDNY AND +
                          S.HBBRCD = EQ.HBBRCD AND S.HBCUST = +
                          EQ.HBCUST AND S.HBACSN = EQ.HBACSN AND +
                          S.HBPCCD = EQ.HBPCCD AND S.HBBKCD = +
                          EQ.HBBKCD AND S.HBOTTP = EQ.HBOTTP AND +
                          S.HBTSTY = EQ.HBTSTY AND S.HBACNB = +
                          EQ.HBACNB AND S.HBCGCD = EQ.HBCGCD AND +
                          S.MBSPAE = EQ.HBACCD INNER JOIN SDCURRPD +
                          AS C ON S.HBCYCD = C.A6CYCD)')                               /*FVT102CC1*/
               CHGVAR     VAR(&RUNSQL) VALUE(&RUNSQL1 *TCAT &RUNSQL2 +
                          *TCAT &RUNSQL3 *TCAT &RUNSQL4 *TCAT &RUNSQL5 +
                          *TCAT &RUNSQL6)                                              /*FVT102CC1*/
/* The below set-up of &RUNSQL which is commented out is for info ONLY,   */           /*FVT102CC1*/
/* so as to have the whole of the SQL statement in one view.              */           /*FVT102CC1*/
/*             CHGVAR     VAR(&RUNSQL) VALUE('insert into mcsrrpoq +
                          (SELECT S.HBBRCD AS SRBRCD, S.HBCYCD AS +
                          SRCYCD, '' '',  S.HBCUST AS SRCUST, +
                          S.HBACSN AS SRACSN, S.HBPCCD AS SRPCCD, +
                          S.HBBKCD AS SRBKCD, S.HBOTTP AS SROTTP, +
                          S.HBTSTY AS SRTSTY, S.HBACNB AS SRASNB, +
                          S.HBPDCB AS SREPCB, EQ.HBPDCB * -1 AS +
                          SRBCEQ, C.A6SPRT AS SRSPRT, C.A6MDIN AS +
                          SRMDIN, C.A6NBDP AS SRNBDP, C.A6CYNM AS +
                          SRCYNM, S.HBACCD AS SRACCD FROM (SELECT +
                          S.HBPDCT, S.HBPDYR, S.HBPDNY, S.HBCGCD, +
                          S.HBBRCD, S.HBCYCD, S.HBACCD, S.HBCUST, +
                          S.HBACSN, S.HBPCCD, S.HBBKCD, S.HBOTTP, +
                          S.HBTSTY, S.HBACNB, S.HBPDCB, X.MBSPAE +
                          FROM GLHIBLPD AS S INNER JOIN XXSRVLPD AS +
                          X ON S.HBACCD = X.MBSRVL AND S.HBCYCD = +
                          X.MBFCCY WHERE S.HBPDCT = &QUOTE *TCAT +
                          &PDCT *TCAT &QUOTE AND S.HBPDYR = &QUOTE +
                          *TCAT &PDYR *TCAT &QUOTE AND S.HBPDNY = +
                          &QUOTE *TCAT &PDNY *TCAT &QUOTE AND +
                          S.HBACCD = &QUOTE *TCAT &MB_SPTA *TCAT +
                          &QUOTE ) AS S INNER JOIN (SELECT E.HBPDCT, +
                          E.HBPDYR, E.HBPDNY, E.HBCGCD, E.HBBRCD, +
                          E.HBCYCD, E.HBACCD, E.HBCUST, E.HBACSN, +
                          E.HBPCCD, E.HBBKCD, E.HBOTTP, E.HBTSTY, +
                          E.HBACNB, E.HBPDCB FROM GLHIBLPD AS E) AS +
                          EQ ON S.HBPDCT = EQ.HBPDCT AND S.HBPDYR = +
                          EQ.HBPDYR AND S.HBPDNY = EQ.HBPDNY AND +
                          S.HBBRCD = EQ.HBBRCD AND S.HBCUST = +
                          EQ.HBCUST AND S.HBACSN = EQ.HBACSN AND +
                          S.HBPCCD = EQ.HBPCCD AND S.HBBKCD = +
                          EQ.HBBKCD AND S.HBOTTP = EQ.HBOTTP AND +
                          S.HBTSTY = EQ.HBTSTY AND S.HBACNB = +
                          EQ.HBACNB AND S.HBCGCD = EQ.HBCGCD AND +
                          S.MBSPAE = EQ.HBACCD INNER JOIN SDCURRPD +
                          AS C ON S.HBCYCD = C.A6CYCD)')        */                     /*FVT102CC1*/

      /*     CHGVAR     VAR(&QRYSLT) VALUE('1/HBPDCT *EQ ''''' *CAT +
                          &PDCT *CAT ''''' *AND 1/HBPDYR *EQ ''''' +
                          *CAT &PDYR *CAT ''''' *AND 1/HBPDNY *EQ +
                          ''''' *CAT &PDNY *CAT ''''' *AND +
                          1/HBACCD *EQ ''''' *CAT &MB_SPTA *CAT +
                          ''''' *AND 2/HBCYCD *EQ ''''' *CAT +
                          &BCCY *CAT '''''')                           */              /*FVT102CC1*/
/**/
/**  If entity not blank & not 'ALL', select particular branch requested */               /*FVT102*/
/**/
     /*      IF         COND(&RENT *NE '   ' *AND &RENT *NE 'ALL') THEN(DO)*/ /*FVT102 FVT102CC1*/
     /*         CHGVAR     VAR(&QRYSLT) VALUE(&QRYSLT *BCAT  '*AND +
                             1/HBBRCD *EQ ''''' *CAT &RENT *CAT '''''') */ /*FVT102*/  /*FVT102CC1*/
     /*      ENDDO      */ /*FVT102*/                                         /*FVT102CC1*/
/**/
      /*       CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                          *BCAT &PRCG *TCAT ') (GLHIBLPD' *BCAT &PRCG +
                          *TCAT ') (SDCURRPD) (XXSRVLPD)) FORMAT(MCSRRPOQ) +
                          QRYSLT(''' *CAT &QRYSLT *TCAT ''') KEYFLD( +
                          (SRBRCD) (SRCYCD) (SRPCCD))')        */          /*FVT102*/  /*FVT102CC1*/
/**/
     /*       CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'JFLD( +
                          (1/HBPDCT 2/HBPDCT) (1/HBPDYR 2/HBPDYR) +
                          (1/HBPDNY 2/HBPDNY) (1/HBBRCD 2/HBBRCD) +
                          (1/HBCUST 2/HBCUST) (1/HBACSN 2/HBACSN) +
                          (1/HBPCCD 2/HBPCCD) (1/HBBKCD 2/HBBKCD) +
                          (1/HBOTTP 2/HBOTTP) (1/HBTSTY 2/HBTSTY) +
                          (1/HBACNB 2/HBACNB) (1/HBCGCD 2/HBCGCD) +
                          (1/HBCYCD 3/A6CYCD) (2/HBACCD 4/MBSPAE))')   */             /*FVT102CC1*/
/**/
       /*      CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'MAPFLD( +
                          (SRBRCD ''1/HBBRCD'') (SRCYCD ''1/HBCYCD'') +
                          (SRACCD ''2/HBACCD'') (SRCUST ''1/HBCUST'') +
                          (SRACSN ''1/HBACSN'') (SRPCCD ''1/HBPCCD'') +
                          (SRBKCD ''1/HBBKCD'') (SROTTP ''1/HBOTTP'') +
                          (SRTSTY ''1/HBTSTY'') (SRASNB ''1/HBACNB'') +
                          (SREPCB ''1/HBPDCB'') (SRBCEQ ''2/HBPDCB +
                          * -1'') (SRSPRT A6SPRT) (SRMDIN A6MDIN) +
                          (QQACCD ''1/QQACCD'') +
                          (SRNBDP A6NBDP) (SRCYNM A6CYNM))')            */ /*FVT102*/  /*FVT102CC1*/
/**/
/**  Execute OPNQRYF  */
/**/
       /*      CLOF       OPNID(GLHIBLPD)                  */           /*FVT102*/     /*FVT102CC1*/
       /*      MONMSG     MSGID(CPF4520)                   */           /*FVT102*/     /*FVT102CC1*/
       /*      CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000) */           /*FVT102*/     /*FVT102CC1*/
/**/
/**  Perform override on file MCSRRPOQ before calling report program */                   /*FVT102*/
/**  and then check for any database errors                          */                   /*FVT102*/
/**/
       /*    OVRDBF     FILE(MCSRRPOQ) TOFILE(GLHIBLPD) SHARE(*YES)  */ /*FVT102*/     /*FVT102CC1*/

             CLRPFM     FILE(MCSRRPOQ)                                                 /*FVT102CC1*/
             MONMSG     MSGID(CPF0000)                                                 /*FVT102CC1*/
             SCRUNSQL   SQL(&RUNSQL)                                                   /*FVT102CC1*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*FVT102CC1*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                           /*FVT102CC1*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                                      /*FVT102CC1*/
                GOTO       CMDLBL(ABNOR)                                               /*FVT102CC1*/
             ENDDO       /*FVT102CC1*/

             CALL       PGM(XX0541) PARM(&RSEQ &RLEV &RENT)                               /*FVT102*/
       /*    CLOF       OPNID(GLHIBLPD)                              */ /*FVT102*/     /*FVT102CC1*/
       /*    MONMSG     MSGID(CPF4520)                               */ /*FVT102*/     /*FVT102CC1*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*FVT102*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                              /*FVT102*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                                         /*FVT102*/
                GOTO       CMDLBL(ABNOR)                                                  /*FVT102*/
             ENDDO       /*FVT102*/

             CHGVAR     VAR(&MB_SRVL) VALUE(&MBSRVL)                                   /*FVT102CC1*/
             GOTO       CMDLBL(LOOP)                                                      /*FVT102*/
             ENDDO       /*FVT102*/

/*********************************************************************/
/*      End of /COPY FVT102_004                                      */
/*********************************************************************/
