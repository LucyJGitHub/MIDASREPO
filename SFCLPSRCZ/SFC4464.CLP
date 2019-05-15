/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SF Re-route job for CoB')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas Standing Data module                                  */
/*                                                                   */
/*       SFC4464 - REROUTE JOB AFTER ENDING ALL ACTIVE SESSIONS      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD038993           Date 21Nov16              */
/*                      CER059             Date 19Jul10              */
/*                      BUG22246           Date 17Feb09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CRE026             Date 24May06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BG10848R1          Date 04May06              */
/*                      BUG10848R          Date 02May06              */
/*                      BUG10848           Date 15Mar06              */
/*                      CCB014             Date 25Apr05              */
/*                      BUG5705            Date 18Feb05              */
/*                      CSC022             Date 24Feb04              */
/*                      CPK018             Date 22Feb04              */
/*                      CPK017             Date 17Sep03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      208201             Date 06Aug02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      097148             Date 08Apr97              */
/*                      S01408             Date 11Aug95              */
/*                      089614             DATE 26JUN95              */
/*                      056090             DATE 29MAR94              */
/*                      049656             DATE 18JAN93              */
/*                      S01405             DATE 03DEC92              */
/*                      S01390             DATE 20AUG92              */
/*                      AUS025             DATE 13FEB91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD038993 - Missing code functionality on CCB014.            */
/*                  Define 10 jobs. COB will not run if one of the   */
/*                  job is active.                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22246 - Message monitoring for CPF1311                   */
/*       CRE026 - Consumer Banking (Recompile)                       */
/*       BG10848R1 - Condition only for batch jobs                   */
/*       BUG10848R - Retrieved the UserId who runs the schedule      */
/*                   batch for COB                                   */
/*       BUG10848 - Schedule not functioning for Global Processing   */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*       BUG5705 - CoB initiation Text not available for message     */
/*                 XXM0006 file GBMIDASMSG                           */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CPK018 - Change the RRTJOB to a TFRJOB for IPCTERM.         */
/*       CPK017 - Midas Plus Packaging.                              */
/*       208201 - This program should check that the user is         */
/*                authorised to run a COB.                           */
/*       CSC011 - 24x7 Midas Availability                            */
/*       097148 - Call the new program SC1021 to check that the      */
/*                rundate on TABTB10, SDBANKPD and RUNDAT match.     */
/*       S01408 - Addition of hooks:                                 */
/*                - SFC4464INT                                       */
/*                - SFC4464MPS                                       */
/*                - SFC4464MPE                                       */
/*       089614 - Reset SDSTAT and CBSTAT before rerouting job.      */
/*       056090 - Deallocate SCSARDPD before rerouting job.          */
/*       049656 - THE SESSION MANAGER CHANGES SHOULD ONLY BE RUN     */
/*                IF THE SESSION MANAGER IS SET ON IN THE SYSTEM.    */
/*       S01405 - RENAMED FROM RRTJOB (AUSTRALIAN VERSION).          */
/*       S01390 - Release 10 Upgrade                                 */
/*       AUS025 - AUSTRALIAN PRODUCT - SESSION MANAGER           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTGDTA)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC4464INT                                          */
                                                                      /*S01408*/
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)                                 /*CCB014*/
             DCL        VAR(&SCHREQ) TYPE(*CHAR) LEN(1)                                   /*CCB014*/
             DCL        VAR(&WRTGDTA)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&POFFST) TYPE(*CHAR) LEN(5)                                 /*BUG10848*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)                                /*BUG10848*/
             DCL        VAR(&REQSTUSR) TYPE(*CHAR) LEN(10)                             /*BUG10848R*/
             DCL        VAR(&RTGDTA)  TYPE(*CHAR) LEN(80)
             DCL        VAR(&RTGDTA2)  TYPE(*CHAR) LEN(80)                                /*CPK017*/
             DCL        VAR(&GRPJOBL) TYPE(*CHAR) LEN(1056)
             DCL        VAR(&OFFSET)  TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&JOBPTR)  TYPE(*DEC ) LEN(4 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SARRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')   /*049656*/
             DCL        VAR(&SAROPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*FIRST ')                            /*049656*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*049656*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*049656*/
             DCL        VAR(&AUS025) TYPE(*CHAR) LEN(1) VALUE('N')    /*049656*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(1) VALUE(' ')      /*097148*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*097148*/
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)              /*097148*/
             DCL        VAR(&ACDE) TYPE(*CHAR) LEN(1) VALUE(' ')                          /*CSC011*/
             DCL        VAR(&CPGM) TYPE(*CHAR) LEN(10)                                    /*CSC011*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(10)                                    /*CSC011*/
             DCL        VAR(&RPLY) TYPE(*CHAR) LEN(1)                                     /*CSC011*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CSC011*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCL        VAR(&S2PHAS) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCL        VAR(&S3STRT) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCL        VAR(&S4STRT) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCL        VAR(&EPARM) TYPE(*CHAR) LEN(7)                                    /*CSC011*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                                 /*CSC011*/
             DCL        VAR(&CLBP) TYPE(*CHAR) LEN(1) VALUE('N')                          /*CSC011*/
             DCL        VAR(&CURUSER) TYPE(*CHAR) LEN(10)                                 /*208201*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTSKP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCLF       FILE(SFUSERL0)                                                    /*208201*/
                                                                                        /*BUG10848*/
             RTVJOBA    TYPE(&JOBTYPE)                                                  /*BUG10848*/
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE(' ')                                           /*CSC022*/
             CHGVAR     VAR(&SARRTCD) VALUE('       ')                                    /*CSC022*/
             CHGVAR     VAR(&SAROPTN) VALUE('*VERIFY')                                    /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&SARRTCD &SAROPTN &SAR +
                          &SCSARD)                                                        /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&SARRTCD *EQ '       ') THEN(DO)                             /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             RTVJOBA    JOB(&JOBNAME)                                                     /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                                                                                          /*208201*/
/* Check that the user is authorised to run a COB */                                      /*208201*/
                                                                                          /*208201*/
             RTVJOBA    USER(&CURUSER)                                                    /*208201*/
                                                                                          /*208201*/
/*  Check to see if the delay cob feature is set on (CCB014) */                        /*BUG10848R*/
                                                                                       /*BUG10848R*/
             CHGVAR     VAR(&SARRTCD) VALUE('       ')                                 /*BUG10848R*/
             CHGVAR     VAR(&SAROPTN) VALUE('*VERIFY')                                 /*BUG10848R*/
             CHGVAR     VAR(&SAR) VALUE('CCB014')                                      /*BUG10848R*/
             CALL       PGM(AOSARDR0) PARM(&SARRTCD &SAROPTN &SAR +
                          &SCSARD)                                                     /*BUG10848R*/
             IF         COND(&SARRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))                                     /*BUG10848R*/
                                                                                       /*BUG10848R*/
/* Override the userid with the userid of the one who schedule the cob  */             /*BUG10848R*/
                                                                                       /*BUG10848R*/
/**********  IF         COND(&CCB014 = 'Y') THEN(DO)                 */      /*BUG10848R BG10848R1*/
             IF         COND((&CCB014 = 'Y') *AND (&JOBTYPE = '0')) +
                          THEN(DO)                                                     /*BG10848R1*/
             RTVDTAARA  DTAARA(DLYCOB (68 10)) RTNVAR(&REQSTUSR)                       /*BUG10848R*/
             CHGVAR     VAR(&CURUSER) VALUE(&REQSTUSR)                                 /*BUG10848R*/
             ENDDO                                                                     /*BUG10848R*/
                                                                                       /*BUG10848R*/
 RCVF:                                                                                    /*208201*/
             RCVF                                                                         /*208201*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*208201*/
/**********     RTVMSG     MSGID(SFM0030) MSGF(MIDASMSG) +
                             MSG(&MESSAGE)                                      /*208201 BUG10848R*/
                RTVMSG     MSGID(SFM0030) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)                                             /*BUG10848R*/
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                      /*208201*/
                IF         COND(&JOBTYPE = '1') THEN(DO)                                /*BUG10848*/
                CALL       PGM(SCC0010) PARM('SFC4464' 'ENTER' +
                             &NOREPLY)                                                    /*208201*/
                GOTO       CMDLBL(ENDPGM)                                                 /*208201*/
                ENDDO                                                                   /*BUG10848*/
                IF         COND(&JOBTYPE = '0') THEN(DO)                                /*BUG10848*/
                  SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MESSAGE) +
                            TOMSGQ(MOPERQ)                                              /*BUG10848*/
                  MONMSG     MSGID(CPF0000 MCH0000)                                     /*BUG10848*/
                  CHGJOB     SWS(XXXXXX11)                                              /*BUG10848*/
                  GOTO       CMDLBL(ENDPGM)                                             /*BUG10848*/
                ENDDO                                                                   /*BUG10848*/
             ENDDO                                                                        /*208201*/
                                                                                          /*208201*/
/* If the record is not the record for the user then read next record */                  /*208201*/
                                                                                          /*208201*/
             IF         COND(&CURUSER *NE &USRP) THEN(GOTO +
                          CMDLBL(RCVF))                                                   /*208201*/
 
/* */                                                                 /*097148*/
/*   Call SC1021 to check the integrity of the run date held on       /*097148*/
/*   PF/SDBANKPD, PF/TABTB10 and DTAARA/RUNDAT                        /*097148*/
/* */                                                                 /*097148*/
             CALL       PGM(SC1021) PARM(&RTNC)                       /*097148*/
             IF         COND(&RTNC *EQ 'E') THEN(DO)                  /*097148*/
/* */                                                                 /*097148*/
/*  Call SCC0010 to inform the User that the run date held on SDBANKPD/*097148*/
/*  TABTB10 and RUNDAT do not match                                   /*097148*/
/* */                                                                 /*097148*/
/**********     RTVMSG     MSGID(XXM0006) MSGF(GBMIDASMSG) +      */                     /*BUG5705*/
/**********                  MSG(&MESSAGE)                        */          /*097148*/ /*BUG5705*/
                RTVMSG     MSGID(SCM0161) MSGF(GBMIDASMSG) +
                          MSG(&MESSAGE)                                                  /*BUG5705*/
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)  /*097148*/
/**********     RTVMSG     MSGID(XXM0007) MSGF(GBMIDASMSG) +      */                     /*BUG5705*/
/**********                  MSG(&MESSAGE)                                    /*097148*/ /*BUG5705*/
                RTVMSG     MSGID(SCM0162) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)                                               /*BUG5705*/
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)  /*097148*/
                CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')         /*097148*/
                IF         COND(&JOBTYPE = '1') THEN(DO)                                /*BUG10848*/
                CALL       PGM(SCC0010) PARM('SFC4464' 'ENTER' +
                             &NOREPLY)                                /*097148*/
                SIGNOFF    LOG(*LIST)                                 /*097148*/
                ENDDO                                                                   /*BUG10848*/
                IF         COND(&JOBTYPE = '0') THEN(DO)                                /*BUG10848*/
                  SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MESSAGE) +
                            TOMSGQ(MOPERQ)                                              /*BUG10848*/
                  MONMSG     MSGID(CPF0000 MCH0000)                                     /*BUG10848*/
                  CHGJOB     SWS(XXXXXX11)                                              /*BUG10848*/
                  GOTO       CMDLBL(ENDPGM)                                             /*BUG10848*/
                ENDDO                                                                   /*BUG10848*/
             ENDDO                                                    /*097148*/
/* */                                                                 /*097148*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC4464MPS                                          */
                                                                      /*S01408*/
                                                                                          /*CCB014*/
/** CHECK TO SEE IF AUTOMATIC SCHEDULING IS ON */                                         /*CCB014*/
                                                                                          /*CCB014*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&SCHREQ)                              /*CCB014*/
             CHGVAR     VAR(&WRTGDTA) VALUE(%SST(&RTGDTA 1 10))                           /*CCB014*/
                                                                                          /*CCB014*/
/***CHECK*TO*SEE*IF*THE*DELAY*COB*FEATURE*IS*SET*ON*(CCB014) */                 /*CCB014 BUG10848R*/
                                                                                /*CCB014 BUG10848R*/
/**********  CHGVAR     VAR(&SARRTCD) VALUE('       ')               */         /*CCB014 BUG10848R*/
/**********  CHGVAR     VAR(&SAROPTN) VALUE('*VERIFY')               */         /*CCB014 BUG10848R*/
/**********  CHGVAR     VAR(&SAR) VALUE('CCB014')                    */         /*CCB014 BUG10848R*/
/**********  CALL       PGM(AOSARDR0) PARM(&SARRTCD &SAROPTN &SAR +  */         /*CCB014 BUG10848R*/
/**********               &SCSARD)                                   */         /*CCB014 BUG10848R*/
/**********  IF         COND(&SARRTCD *EQ '      ') THEN(CHGVAR +    */         /*CCB014 BUG10848R*/
/**********               VAR(&CCB014) VALUE('Y'))                   */         /*CCB014 BUG10848R*/
             IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                          THEN(DO)                                                        /*CCB014*/
             IF         COND(&WRTGDTA *EQ 'IPCTERM') THEN(DO)                             /*CCB014*/
/**********  CALL       PGM(CB0004)                                          /*CCB014*/ /*BUG10848*/
                                                                                        /*BUG10848*/
/* Retrieve offset value (time difference) */                                           /*BUG10848*/
                                                                                        /*BUG10848*/
             RTVSYSVAL  SYSVAL(QUTCOFFSET) RTNVAR(&POFFST)                              /*BUG10848*/
/**********  CALL       PGM(CB0004) PARM(&POFFST)                              /*BUG10848 MD038993*/
             CALL       PGM(CB000401) PARM(&POFFST)                                     /*MD038993*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&SCHREQ)                              /*CCB014*/
             IF         COND(&SCHREQ *EQ 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))                                                 /*CCB014*/
             ENDDO                                                                        /*CCB014*/
             ENDDO                                                                        /*CCB014*/
             IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC1))                                      /*CCB014*/
/* CHECK TO SEE IF THE SESSION MANAGER FEATURE IS SET ON (AUS025) */  /*049656*/
                                                                      /*049656*/
             CHGVAR     VAR(&SARRTCD) VALUE('       ')                /*049656*/
             CHGVAR     VAR(&SAROPTN) VALUE('*VERIFY')                /*049656*/
             CHGVAR     VAR(&SAR) VALUE('AUS025')                     /*049656*/
             CALL       PGM(AOSARDR0) PARM(&SARRTCD &SAROPTN &SAR +
                          &SCSARD)                                    /*049656*/
             IF         COND(&SARRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&AUS025) VALUE('Y'))                    /*049656*/
                                                                      /*049656*/
/*   END ALL ACTIVE SESSIONS                                     */
 
             IF         COND(&AUS025 *EQ 'Y') THEN(DO)                /*049656*/
               RTVGRPA    GRPJOBL(&GRPJOBL)
               MONMSG     MSGID(CPF1311) EXEC(GOTO CMDLBL(LOOP2))                       /*BUG22246*/
               CHGVAR     VAR(&OFFSET) VALUE(7)
LOOP:          CHGVAR     VAR(&JOBPTR) VALUE((&OFFSET * 66) + 1)
               IF         COND(%SST(&GRPJOBL &JOBPTR 1) *NE ' ') +
                          THEN(ENDGRPJOB GRPJOB(%SST(&GRPJOBL +
                          &JOBPTR 10)))
 
               IF         COND(&OFFSET *GE 2) THEN(DO)
                CHGVAR     VAR(&OFFSET) VALUE(&OFFSET - 1)
                GOTO       CMDLBL(LOOP)
               ENDDO
 
/*   CHANGE TO A NON-GROUP JOB                                   */
 
               CHGGRPA    GRPJOB(*NONE)
             ENDDO                                                    /*049656*/
/** Check if CSC011 *ON */                                                                /*CSC011*/
                                                                                          /*CSC011*/
/**********  CHGVAR     VAR(&SARRTCD) VALUE('       ')  */                       /*CSC011 BUG22246*/
LOOP2:       CHGVAR     VAR(&SARRTCD) VALUE('       ')                                  /*BUG22246*/
             CHGVAR     VAR(&SAROPTN) VALUE('*VERIFY')                                    /*CSC011*/
             CHGVAR     VAR(&SAR) VALUE('CSC011')                                         /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&SARRTCD &SAROPTN &SAR +
                          &SCSARD)                                                        /*CSC011*/
             IF         COND(&SARRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC011) VALUE('Y'))                                        /*CSC011*/
                                                                                          /*CSC011*/
/** If CSC011 is installed */                                                             /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
                CHGVAR     VAR(&EPARM) VALUE(&RTGDTA)                                     /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(&EPARM *EQ 'IPCTERM') THEN(DO)                            /*CSC011*/
                   RTVDTAARA  DTAARA(SCSUPP (1 1)) RTNVAR(&S3STRT)                        /*CSC011*/
                   RTVDTAARA  DTAARA(SCREOP (1 1)) RTNVAR(&S4STRT)                        /*CSC011*/
                   CALL       PGM(SC004317)                                               /*CSC011*/
                   IF      COND(&S3STRT *EQ ' ' *AND &S4STRT *EQ ' ') +
                     THEN(DO)                                                             /*CSC011*/
                                                                                          /*CSC011*/
/** Call SCC0010 to request confirmation of COB request */                                /*CSC011*/
                                                                                          /*CSC011*/
                       RTVMSG     MSGID(SCM0012) MSGF(MIDASMSG) MSG(&MESSAGE)             /*CSC011*/
                       CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)               /*CSC011*/
                       RTVMSG     MSGID(SCM0011) MSGF(MIDASMSG) MSG(&MESSAGE)             /*CSC011*/
                       CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)               /*CSC011*/
                       CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')                       /*CSC011*/
                       CALL       PGM(SCC0010) PARM('SFC4464' 'OPTION' &CLBP)             /*CSC011*/
 
                       IF         COND(&CLBP *NE 'Y') THEN(GOTO CMDLBL(ENDPGM))           /*CSC011*/
                                                                                          /*CSC011*/
/** Call program SCC004300 (Main to Support System Transition Proc.) */                   /*CSC011*/
                                                                                          /*CSC011*/
                      CALL       PGM(SCC004300) PARM(&ACDE)                               /*CSC011*/
                                                                                          /*CSC011*/
/** If Action Code is equal to 'C' */                                                     /*CSC011*/
                                                                                          /*CSC011*/
                      IF         COND(&ACDE *EQ 'C') THEN(DO)                             /*CSC011*/
                         RTVDTAARA DTAARA(SCMAIN (2 1)) RTNVAR(&S2PHAS)                   /*CSC011*/
                                                                                          /*CSC011*/
/** Initialiase SCMAIN dataarea except Status field */                                    /*CSC011*/
                                                                                          /*CSC011*/
                         CHGDTAARA DTAARA(SCMAIN (2 255)) VALUE(' ')                      /*CSC011*/
                                                                                          /*CSC011*/
/** If Cutover Phase (S2PHAS) equal to 'A' */                                             /*CSC011*/
                                                                                          /*CSC011*/
                         IF         COND(&S2PHAS *EQ 'A') THEN(DO)                        /*CSC011*/
                            CHGDTAARA DTAARA(SCREOP (1 1)) VALUE('Y')                     /*CSC011*/
                                                                                          /*CSC011*/
/** Call program SC004330 (24x7 Re-open Option Prompt) */                                 /*CSC011*/
                                                                                          /*CSC011*/
                            CALL       PGM(SC004330)                                      /*CSC011*/
                                                                                          /*CSC011*/
/** Database error processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                            IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                   /*CSC011*/
                               RTVDTAARA DTAARA(LDA (134 50)) +
                                 RTNVAR(&MEM)                                             /*CSC011*/
                               IF         COND((&CSC022 *NE 'Y') *OR (&CSC022 *EQ 'Y' +
                                            *AND &CMTSKP *NE 'Y')) THEN(DO)               /*CSC022*/
                               ROLLBACK                                                   /*CSC011*/
                               ENDDO                                                      /*CSC022*/
                               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                 MSGDTA(&MEM) TOPGMQ(*EXT) +
                                 TOMSGQ(MOPERQ)                                           /*CSC011*/
                               GOTO       CMDLBL(ENDPGM)                                  /*CSC011*/
                            ENDDO                                                         /*CSC011*/
                                                                                          /*CSC011*/
/** Call program SCC004340 (Re-open Input Cycle Processing) */                            /*CSC011*/
                                                                                          /*CSC011*/
                            CALL       PGM(SCC004340)                                     /*CSC011*/
                                                                                          /*CSC011*/
/** Database error processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                            IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                   /*CSC011*/
                               RTVDTAARA  DTAARA(LDA (134 50)) +
                                 RTNVAR(&MEM)                                             /*CSC011*/
                               IF         COND((&CSC022 *NE 'Y') *OR (&CSC022 *EQ 'Y' +
                                            *AND &CMTSKP *NE 'Y')) THEN(DO)               /*CSC022*/
                               ROLLBACK                                                   /*CSC011*/
                               ENDDO                                                      /*CSC022*/
                               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                 MSGDTA(&MEM) TOPGMQ(*EXT) +
                                 TOMSGQ(MOPERQ)                                           /*CSC011*/
                               GOTO       CMDLBL(ENDPGM)                                  /*CSC011*/
                            ENDDO                                                         /*CSC011*/
                                                                                          /*CSC011*/
                         ENDDO                                                            /*CSC011*/
                         GOTO       CMDLBL(ENDPGM)                                        /*CSC011*/
                      ENDDO                                                               /*CSC011*/
                                                                                          /*CSC011*/
/** Database error processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                         /*CSC011*/
                         RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                     /*CSC011*/
                         IF         COND((&CSC022 *NE 'Y') *OR (&CSC022 *EQ 'Y' +
                                      *AND &CMTSKP *NE 'Y')) THEN(DO)                     /*CSC022*/
                         ROLLBACK                                                         /*CSC011*/
                         ENDDO                                                            /*CSC022*/
                         SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                           MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)                       /*CSC011*/
                         GOTO       CMDLBL(ENDPGM)                                        /*CSC011*/
                      ENDDO                                                               /*CSC011*/
                   ENDDO                                                                  /*CSC011*/
                                                                                          /*CSC011*/
                   ELSE       CMD(DO)                                                     /*CSC011*/
                      CHGVAR     VAR(&CPGM) VALUE('SFC4464')                              /*CSC011*/
                      CHGVAR     VAR(&SFMT) VALUE('SDC0700F8')                            /*CSC011*/
                      CHGVAR     VAR(&RPLY) VALUE(' ')                                    /*CSC011*/
                      CALL       PGM(SDC0700) PARM(&CPGM &SFMT &RPLY)                     /*CSC011*/
                      GOTO       CMDLBL(ENDPGM)                                           /*CSC011*/
                   ENDDO                                                                  /*CSC011*/
                                                                                          /*CSC011*/
                ENDDO                                                                     /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/* */                                                                /*056090*/
/** Free the SCSARDPD file */                                        /*056090*/
/* */                                                                /*056090*/
/*/COPY WNCPYSRC,SFC4464001                                          */
                                                                                          /*CCB014*/
TAGUSC1:                                                                                  /*CCB014*/
                                                                                          /*CCB014*/
             CHGVAR     VAR(&SAROPTN) VALUE('*FREE')                 /*056090*/
             CALL       PGM(AOSARDR0) PARM(&SARRTCD &SAROPTN &SAR +
                             &SCSARD)                                /*056090*/
                                                                      /*089614*/
/* Reset DTAARA SDSTAT */                                             /*089614*/
                                                                      /*089614*/
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')         /*089614*/
             CHGDTAARA  DTAARA(SDSTAT (115 1)) VALUE('P')             /*089614*/
                                                                      /*089614*/
/* Reset DTAARA CBSTAT */                                             /*089614*/
                                                                      /*089614*/
             CHGDTAARA  DTAARA(CBSTAT (14 3)) VALUE('000')            /*089614*/
             CHGDTAARA  DTAARA(CBSTAT (17 1)) VALUE('N')              /*089614*/
             CHGDTAARA  DTAARA(CBSTAT (18 2)) VALUE('00')             /*089614*/
             CHGDTAARA  DTAARA(CBSTAT (20 1)) VALUE('N')              /*089614*/
             CHGDTAARA  DTAARA(CBSTAT (32 1)) VALUE('N')              /*089614*/
             CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')              /*089614*/
                                                                      /*089614*/
/* */                                                                /*056090*/
/*   NOW REROUTE THE JOB                                         */
 
/*/COPY WNCPYSRC,SFC4464002                                          */
             IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC2))                                      /*CCB014*/
             CHGVAR     VAR(&RTGDTA2) VALUE(%SST(&RTGDTA 1 7))                            /*CPK017*/
             IF         COND(&RTGDTA2 *EQ 'IPCTERM') THEN(DO)                             /*CPK018*/
                TFRJOB     JOBQ(MJOBQ) RTGDTA(IPCTERM)                                    /*CPK018*/
             ENDDO                                                                        /*CPK018*/
/**********  RRTJOB     RTGDTA(&RTGDTA) */                                                /*CPK017*/
             RRTJOB     RTGDTA(&RTGDTA2)                                                  /*CPK017*/
/*/COPY WNCPYSRC,SFC4464003                                          */
                                                                                          /*CCB014*/
TAGUSC2:                                                                                  /*CCB014*/
                                                                                          /*CCB014*/
 
/* */                                                                 /*S01390*/
/** Change value of &BISCPY to avoid error of its declaration.     */ /*S01390*/
/* */                                                                 /*S01390*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/***/                                                         /*049656 056090*/
/***FREE*THE*SCSARDPD*FILE**********************************/ /*049656 056090*/
/***/                                                         /*049656 056090*/
/************CHGVAR     VAR(&SAROPTN) VALUE('*FREE')       */ /*049656 056090*/
/************CALL       PGM(AOSARDR0) PARM(&SARRTCD +      */ /*049656 056090*/
/************                &SAROPTN &SAR &SCSARD)        */ /*049656 056090*/
/***/                                                         /*049656 056090*/
/* */                                                                 /*S01390*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC4464MPE                                          */
                                                                      /*S01408*/
ENDPGM:      ENDPGM
