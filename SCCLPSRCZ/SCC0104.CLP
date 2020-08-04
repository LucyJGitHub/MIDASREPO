/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Subsystem startup main processing')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0104 - Autostart Job Entry runs this program             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD055683           Date 21May20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD031644           Date 08Jan15              */
/*                      AR1000912          Date 13Nov14              */
/*                      MD027386           Date 19Aug14              */
/*                      CGL155             Date 21Mar14              */
/*                      CCB020             Date 06Aug12              */
/*                      CRE072             Date 30Jun11              */
/*                      BUG27831A          Date 03Aug10              */
/*                      CSD083             Date 27May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CAP205             Date 15Feb10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BG1726 (Reopen)    Date 29Jul04              */
/*                      CLE024             Date 17May04              */
/*                      CGL014             Date 17May04              */
/*                      CGP004             Date 23Feb04              */
/*                      BG1343             Date 23Feb04              */
/*                      CSC023             Date 02Feb04              */
/*                      CAP084             Date 21Jan04              */
/*                      214363             Date 29Jan03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203561             Date 21Jun02              */
/*                      211819             Date 11Nov02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/*                      193083             Date 21Jun01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      178063             Date 11Jul00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      122661             Date 05SEP97              */
/*                      CTI001             DATE 01SEP97              */
/*                      S01408             Date 07AUG95              */
/*                      S01463             Date 19APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055683 - SWIFT jobs will now run based on configurations  */
/*       MD046248 - Finastra Rebranding                              */
/*       MD031644 - SP7 Build issue (Rework of CFT158 Return         */
/*                  Status of Interfaced FT Payments). Unable        */
/*                  to compile GP002900 due to zonal access.         */
/*                  Submit background job FTRETS_zz.                 */
/*       AR1000912 - CALCMGR_XX jobs not submittted on start of      */
/*                   subsystem or signon of a user.                  */
/*                 - If CLE025 is switched ON, CALCMGR jobs should   */
/*                   be started/submitted.                           */
/*                   (Child: AR1000913)                              */
/*                 - Applied for MD-31183                            */
/*       MD027386 - BFM messages not automatically sent to MMM       */
/*       CGL155 - Forecast Group Limits                              */
/*                Added hooks: CGL155_004 TO CGL155_006              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CRE072 - BankFusion Midas Teller Related Changes            */
/*       BUG27831A - Forward Account Transfer Processing             */
/*       CSD083 - Watch List Compliance Upgrade                      */
/*       CAP205 - Teller Related APIs - Account Balance Check        */
/*       BG1726 - Added parameter to GLC005000 call (reopen).        */
/*       CLE024 - Addition of CALCMGR processing for CLE024.         */
/*       CGL014 - Addition of CALCMGR processing for CGL014.         */
/*       CGP004 - Audit Reporting                                    */
/*       BG1343 - Global job should only be submitted if input cycle */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP084 - API Wrapper project - start background updates for */
/*                global layer.                                      */
/*       214363 - 24x7 change for submitting TI background jobs.     */
/*                Do not submit these in the support subsystem.      */
/*       203561 - Parameters for LEC2010 have changed.               */
/*       211819 - Clear the file REACJBPD at subsystem startup if    */
/*                Cashier is switched on to avoid the REC4490 job    */
/*                looping when trying to find a missing job in COB.  */
/*              - Add missing parameter to CLE010 AOSARDR0 call.     */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       193083 - Ensure Loan Manager Interface jobs submitted if    */
/*                Interface is switched on (CLE010)                  */
/*       178063 - If pgm ends abnormally, no details of the problem  */
/*                produced - add processing to ABNOR to output       */
/*                a joblog and a dump.                               */
/*       122661 - LEC2010 data areas not deleted when subsystem ends */
/*                abnormally                                         */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCC0104INT                                       */
/*                - SCC0104MPS                                       */
/*                - SCC0104MPE                                       */
/*                - SCC0104ERR                                       */
/*                - SCC0104END                                       */
/*       S01463 - New CL program called by SCAUTOS.                  */
/*                This program also contains the processing          */
/*                formerly contained within SCAUTOS.                 */
/*********************************************************************/
             PGM

/*/COPY WNCPYSRC,SCC0104INT                                          */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&TSTATUS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ABNORM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(10) VALUE('MXXSBS')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) VALUE('The +
                          Subsystem - MXXSBS will terminate +
                          immediately')
             DCL        VAR(&AUTOTIME) TYPE(*CHAR) LEN(5)
             DCL        VAR(&EMJOB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*CTI001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*CTI001*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CTI001*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*193083*/
/**********  DCL        VAR(&RTN) TYPE(*CHAR) LEN(7) */                        /*193083*/ /*211819*/
/**********  DCL        VAR(&OPN) TYPE(*CHAR) LEN(7) */                        /*193083*/ /*211819*/
/**********  DCL        VAR(&OPTN2) TYPE(*CHAR) LEN(7) + */
/**********               VALUE('*VERIFY')               */                    /*122661*/ /*211819*/
             DCL        VAR(&VERIFY) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*211819*/
/************DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +                                */ /*193083*/
/************             VALUE('CLE004')                                   */ /*122661*/ /*193083*/
/**********  DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) + */
/**********               VALUE('CLE010')               */                     /*193083*/ /*211819*/
             DCL        VAR(&CLE010) TYPE(*CHAR) LEN(1) VALUE('N')                        /*193083*/
             DCL        VAR(&CGP004) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CGP004*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CGL014*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CGL014*/
             DCL        VAR(&CGL014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL014*/
             DCL        VAR(&CLE024) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE024*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                     /*AR1000912*/
             DCL        VAR(&CFT158) TYPE(*CHAR) LEN(1) VALUE('N') /*MD031644*/
             DCL        VAR(&CAP205) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAP205*/
             DCL        VAR(&CSD083) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD083*/
             DCL        VAR(&CRE072) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CRE072*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD027386*/
/*/COPY OFCPYSRCZ,CGL155_004                                         */                   /*CGL155*/
                                                                                          /*214363*/
/** Define work variables for CSC011 */                                                   /*214363*/
                                                                                          /*214363*/
             DCL        VAR(&BKJOBRUN) TYPE(*CHAR) LEN(1) VALUE('Y')                      /*214363*/
/**********  DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)              */              /*214363 CCB020*/
/**********  DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)              */              /*214363 CCB020*/
             DCL        VAR(&FRSTAT) TYPE(*CHAR) LEN(1)                                /*BUG27831A*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/***Check*if*24x7*Midas*Availability*Feature*is*on**/                              /*214363 CCB020*/
                                                                                          /*214363*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                */              /*214363 CCB020*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSC011' +                     /*CCB020*/
/**********               '&FMT')                                  */              /*214363 CCB020*/
                                                                                          /*214363*/
/***If*CSC011*is*installed,*check*if*current*system*is*support**/                  /*214363 CCB020*/
/***system.*If*yes,*not*all*background*jobs*should*run*in*the***/                  /*214363 CCB020*/
/***support*system.*********************************************/                  /*214363 CCB020*/
                                                                                          /*214363*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO)         */              /*214363 CCB020*/
/**********     RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)      */              /*214363 CCB020*/
/**********     RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)      */              /*214363 CCB020*/
/**********     IF         COND(&CURR *EQ &SUPP) THEN(DO)          */              /*214363 CCB020*/
/**********        CHGVAR     VAR(&BKJOBRUN) VALUE('N')            */              /*214363 CCB020*/
/**********     ENDDO                                              */              /*214363 CCB020*/
/**********  ENDDO                                                 */              /*214363 CCB020*/
                                                                                          /*214363*/
                                                                      /*CTI001*/
/*  Access PF/SDMMODPD to determine which modules are live  */        /*CTI001*/
                                                                      /*CTI001*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                         /*CTI001*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CTI001*/
             CHGVAR     VAR(&FMT) VALUE(' ')                          /*CTI001*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CTI001*/
                                                                      /*CTI001*/
/*/COPY WNCPYSRC,SCC0104MPS                                          */
                                                                      /*122661*/
/**/                                                                  /*122661*/
/**Determine*if*CLE004*installed***/                                           /*122661*/ /*193083*/
/* Determine if CLE010 installed  */                                                      /*193083*/
/**/                                                                  /*122661*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                         /*122661*/
/**********  CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN2 &SARD) */                  /*122661*/ /*211819*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &VERIFY 'CLE010' +
                          &SFMT)                                                          /*211819*/
/**/                                                                  /*122661*/
/* Error */                                                           /*122661*/
/**/                                                                  /*122661*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*122661*/
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)                           /*122661*/
                CHGJOB     JOB(XXXXXX11)                              /*122661*/
                GOTO       CMDLBL(END)                                /*122661*/
             ENDDO                                                    /*122661*/
/**/                                                                  /*122661*/
/**CLE004*installed**/                                                         /*122661*/ /*193083*/
/* CLE010 installed */                                                                    /*193083*/
/**/                                                                  /*122661*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*122661*/
                  CHGVAR     VAR(&CLE010) VALUE('Y')                                      /*193083*/
                  DLTDTAARA  DTAARA(LEC2010*)                         /*122661*/
                  MONMSG     MSGID(CPF0000)                           /*122661*/
             ENDDO                                                    /*122661*/

/* Determine if Cashier is installed */                                                   /*211819*/
                                                                                          /*211819*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                                             /*211819*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &VERIFY 'CRT002' +
                          &SFMT)                                                          /*211819*/
                                                                                          /*211819*/
/* Error */                                                                               /*211819*/
                                                                                          /*211819*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)                                               /*211819*/
                CHGJOB     JOB(XXXXXX11)                                                  /*211819*/
                GOTO       CMDLBL(END)                                                    /*211819*/
             ENDDO                                                                        /*211819*/
                                                                                          /*211819*/
/* Cashier installed */                                                                   /*211819*/
                                                                                          /*211819*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*211819*/
                CLRPFM     FILE(REACJBPD)                                                 /*211819*/
                MONMSG     MSGID(CPF0000)                                                 /*211819*/
             ENDDO                                                                        /*211819*/
                                                                                          /*211819*/
                                                                                          /*CGP004*/
/* Determine if Audit Reporting is installed */                                           /*CGP004*/
                                                                                          /*CGP004*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                                             /*CGP004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &VERIFY 'CGP004' +
                          &SFMT)                                                          /*CGP004*/
                                                                                          /*CGP004*/
/* Error */                                                                               /*CGP004*/
                                                                                          /*CGP004*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CGP004*/
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)                                               /*CGP004*/
                CHGJOB     JOB(XXXXXX11)                                                  /*CGP004*/
                GOTO       CMDLBL(END)                                                    /*CGP004*/
             ENDDO                                                                        /*CGP004*/
                                                                                          /*CGP004*/
/* Audit Reporting installed */                                                           /*CGP004*/
                                                                                          /*CGP004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CGP004*/
             CHGVAR     VAR(&CGP004) VALUE('Y')                                           /*CGP004*/
             ENDDO                                                                        /*CGP004*/
                                                                                          /*CGP004*/
/*/COPY OFCPYSRCZ,CGL155_005                                         */                   /*CGL155*/
/**Start*background updates for global layer. */                              /*CAP084*/  /*BG1343*/
/************CALL       PGM(GOC0101)                                      */  /*CAP084*/  /*BG1343*/
/************                                                             */  /*CAP084*/  /*BG1343*/
                                                                                          /*CAP084*/
/* Read The Database Status                                         */
             RTVDTAARA  DTAARA(TSTATUS) RTNVAR(&TSTATUS)

/* If TSTATUS is empty then read MPHAS                              */

             IF         COND(&TSTATUS *EQ '        ') THEN(DO)

/* Check The Phase of Processing */
                RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)

/* If Phase A - Force Recovery                                      */

/**********     IF         COND(&MPHAS *EQ A) THEN(DO)             */                     /*CCB020*/
                IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                           THEN(DO)                                                       /*CCB020*/

                   RTVSYSVAL  SYSVAL(QABNORMSW) RTNVAR(&ABNORM)

                   IF         COND(&ABNORM *EQ '1') THEN(DO)
                      CALL PGM(SDC1796)
                   ENDDO

/* If Futures & Options present in system, set any market in       */
/* end of centre to 'FAILED' status, so that it can be restarted   */
/* by EOC restart procedure, send a warning message and clear any  */
/* requested 'HOLDS'                                               */

                      RTVDTAARA  DTAARA(MMOD (50 1))          +
                                   RTNVAR(&FF)
                      IF         COND(&FF *EQ 'Y')            +
                                   THEN(CALL PGM(SDC1744))
                      GOTO       CMDLBL(SKIP1)

                ENDDO

/* IF Phase B or X - Return to Phase A                              */

/**********     IF         COND((&MPHAS *EQ B) *OR (&MPHAS *EQ X)) THEN(DO)               /*CCB020*/
                IF         COND(&MPHAS *EQ 'X') THEN(DO)                                  /*CCB020*/
                   CHGDTAARA  DTAARA(MPHAS) VALUE(A)
                   GOTO       CMDLBL(SKIP1)
                ENDDO
             ENDDO

/* Now clear the other message queues */

 SKIP1:      RMVMSG     MSGQ(MSTATUS) CLEAR(*ALL)
             RMVMSG     MSGQ(MSPECIAL) CLEAR(*ALL)

/* If confirmation matching is present, and the system is in       */
/* Input Cycle, Re-Submit Control Program                          */

                RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********     IF         COND(&MPHAS *EQ A) THEN(DO)             */                     /*CCB020*/
                IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                           THEN(DO)                                                       /*CCB020*/

                   RTVDTAARA  DTAARA(MMOD (60 1)) RTNVAR(&CF)

/************      IF         COND(&CF *EQ 'Y') THEN(SBMJOB CMD(CALL +                    /*CPK014*/
/************                 PGM(CFC0180)) JOB(CFCONTROL) +                              /*CPK014*/
/************                 JOBD(MBATCH) JOBQ(CFJOBQA) +                                /*CPK014*/
/************                 INLLIBL(*JOBD))                                             /*CPK014*/
/************      IF         COND(&CF *EQ 'Y') THEN(SBMJOB CMD(CALL +                    /*CSC023*/
/************             PGM(CFC0180)) JOB(CFCONTROL) JOBD(MBATCH) +                     /*CSC023*/
/************             JOBQ(CFJOBQA) USER(*JOBD) INLLIBL(*JOBD))            /*CPK014*/ /*CSC023*/
                   IF         COND(&CF *EQ 'Y') THEN(SBMJOB CMD(CALL +
                          PGM(CFC0180)) JOB(CFCONTROL) JOBD(MBATCH) +
                          JOBQ(CFJOBQA) USER(*JOBD) INLLIBL(*JOBD) +
                          OUTQ(*JOBD))                                                    /*CSC023*/

/*/COPY WNCPYSRC,SCC0104001                                          */
                ENDDO

/* Reset EMSTAT and JNSTAT */

             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
             RTVDTAARA  DTAARA(EMSTAT (1 2)) RTNVAR(&EMJOB)
             IF         COND(&EMJOB *NE '  ') THEN(CHGDTAARA +
                          DTAARA(EMSTAT (2 1)) VALUE('N'))

/* Resubmit RRAUTOBKP job if appropriate */

             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)              */                     /*CCB020*/
             IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                        THEN(DO)                                                          /*CCB020*/
                RTVDTAARA  DTAARA(JNSTAT (106 5)) RTNVAR(&AUTOTIME)
                IF      COND((&AUTOTIME *NE '00000') *AND (&AUTOTIME +
                        *NE '     ')) THEN(CALL SDC1760)
                IF      COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)
             ENDDO

                                                                      /*CTI001*/
/**********  IF         COND((%SST(&FMT 103 1) *EQ 'Y') *AND (&MPHAS +                 */ /*214363*/
/**********               *EQ 'A')) THEN(DO)                                */ /*CTI001*/ /*214363*/
/**********  IF         COND((%SST(&FMT 103 1) *EQ 'Y') *AND (&MPHAS +                    /*CCB020*/
/**********               *EQ 'A') *AND (&BKJOBRUN *EQ 'Y')) THEN(DO)              /*214363 CCB020*/
             IF         COND((%SST(&FMT 103 1) *EQ 'Y') *AND ((&MPHAS +
                          *EQ 'A') *OR (&MPHAS *EQ 'G')) *AND +
                          (&BKJOBRUN *EQ 'Y')) THEN(DO)                                   /*CCB020*/
                                                                      /*CTI001*/
/* Start Midas/TI Batch Jobs                                    */    /*CTI001*/
                                                                      /*CTI001*/
             CALL       PGM(TIC0050) PARM('START')                    /*CTI001*/
             ENDDO                                                    /*CTI001*/
                                                                                          /*193083*/
/*  Check if the Loan Manager Interface is switched on */                                 /*193083*/
                                                                                          /*193083*/
             IF         COND(&CLE010 *EQ 'Y') THEN(DO)                                    /*193083*/
                                                                                          /*193083*/
/**  Submit Loan Manager Batch Jobs */                                                    /*193083*/
                                                                                          /*193083*/
/************CALL       PGM(LEC2010) PARM('N')                              */ /*193083*/ /*203561*/
             CALL       PGM(LEC2010) PARM('ALL'  '   ')                                   /*203561*/
             CALL       PGM(LEC2012)                                                      /*203561*/
             ENDDO                                                                        /*193083*/
                                                                                          /*193083*/
/* Start background updates for global layer */                                           /*BG1343*/
                                                                                          /*BG1343*/
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)              */              /*BG1343 CCB020*/
             IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                          THEN(DO)                                                        /*CCB020*/
             CALL       PGM(GOC0101)                                                      /*BG1343*/
             ENDDO                                                                        /*BG1343*/
                                                                                          /*BG1343*/
/* Start audit reporting batch job */                                                     /*CGP004*/
                                                                                          /*CGP004*/
/**********  IF         COND(&MPHAS *EQ 'A' *AND &CGP004 *EQ 'Y') THEN(DO)         /*CGP004 CCB020*/
             IF         COND(((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                          *AND (&CGP004 *EQ 'Y')) THEN(DO)                                /*CCB020*/
             CALL       PGM(GOC0300)                                                      /*CGP004*/
             ENDDO                                                                        /*CGP004*/
                                                                                          /*CGP004*/
/** Check if the Collateralised Lending Feature is on */                                  /*CLE024*/
                                                                                          /*CLE024*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE024*/
             CHGVAR     VAR(&SARD) VALUE('CLE024')                                        /*CLE024*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE024*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                        /*CLE024*/
                                                                                          /*CLE024*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CLE024*/
                                                                                          /*CLE024*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CLE024*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CLE024*/
                GOTO       CMDLBL(ABNOR)                                                  /*CLE024*/
             ENDDO                                                                        /*CLE024*/
                                                                                          /*CLE024*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE024*/
                CHGVAR     VAR(&CLE024) VALUE('Y')                                        /*CLE024*/
             ENDDO                                                                        /*CLE024*/
                                                                                          /*CLE024*/
/** Check if Credit Lines Feature is on */                                             /*AR1000912*/
                                                                                       /*AR1000912*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                    /*AR1000912*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                     /*AR1000912*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                    /*AR1000912*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                     /*AR1000912*/
                                                                                       /*AR1000912*/
/** If error occured in AOSARDR0, perform abnormal termination */                      /*AR1000912*/
                                                                                       /*AR1000912*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                          /*AR1000912*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                              /*AR1000912*/
                GOTO       CMDLBL(ABNOR)                                               /*AR1000912*/
             ENDDO                                                                     /*AR1000912*/
                                                                                       /*AR1000912*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                             /*AR1000912*/
                CHGVAR     VAR(&CLE025) VALUE('Y')                                     /*AR1000912*/
             ENDDO                                                                     /*AR1000912*/
                                                                                       /*AR1000912*/
/** Check if FT Return Status Feature is on */                                         /*MD031644*/
                                                                                       /*MD031644*/
             CHGVAR     VAR(&RTCD) VALUE('       ') /*MD031644*/
             CHGVAR     VAR(&SARD) VALUE('CFT158') /*MD031644*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY') /*MD031644*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD) /*MD031644*/
                                                                                       /*MD031644*/
/** If error occured in AOSARDR0, perform abnormal termination */                      /*MD031644*/
                                                                                       /*MD031644*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE '*NRF   ') +
                          THEN(DO) /*MD031644*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') TOMSGQ(MOPERQ) +
                             /*MD031644*/
                GOTO       CMDLBL(ABNOR) /*MD031644*/
             ENDDO      /*MD031644*/
                                                                                       /*MD031644*/
             IF         COND(&RTCD *EQ '       ') THEN(DO) /*MD031644*/
                CHGVAR     VAR(&CFT158) VALUE('Y') /*MD031644*/
             ENDDO      /*MD031644*/
                                                                                       /*MD031644*/
/** Check if the Retail Teller API is on */                                               /*CAP205*/
                                                                                          /*CAP205*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAP205*/
             CHGVAR     VAR(&SARD) VALUE('CAP205')                                        /*CAP205*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAP205*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                        /*CAP205*/
                                                                                          /*CAP205*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CAP205*/
                                                                                          /*CAP205*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CAP205*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CAP205*/
                GOTO       CMDLBL(ABNOR)                                                  /*CAP205*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*CAP205*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CAP205*/
                CHGVAR     VAR(&CAP205) VALUE('Y')                                        /*CAP205*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*CAP205*/
/** Check if CSD083 Feature is on */                                                      /*CSD083*/
                                                                                          /*CSD083*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSD083*/
             CHGVAR     VAR(&SARD) VALUE('CSD083')                                        /*CSD083*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSD083*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                        /*CSD083*/
                                                                                          /*CSD083*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CSD083*/
                                                                                          /*CSD083*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CSD083*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CSD083*/
                GOTO       CMDLBL(ABNOR)                                                  /*CSD083*/
             ENDDO                                                                        /*CSD083*/
                                                                                          /*CSD083*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSD083*/
                CHGVAR     VAR(&CSD083) VALUE('Y')                                        /*CSD083*/
             ENDDO                                                                        /*CSD083*/
                                                                                          /*CSD083*/
/** Check if the Collaterals Processing Feature is on */                                  /*CGL014*/
                                                                                          /*CGL014*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGL014*/
             CHGVAR     VAR(&SARD) VALUE('CGL014')                                        /*CGL014*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL014*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                        /*CGL014*/
                                                                                          /*CGL014*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CGL014*/
                                                                                          /*CGL014*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CGL014*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CGL014*/
                GOTO       CMDLBL(ABNOR)                                                  /*CGL014*/
             ENDDO                                                                        /*CGL014*/
                                                                                          /*CGL014*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CGL014*/
                CHGVAR     VAR(&CGL014) VALUE('Y')                                        /*CGL014*/
             ENDDO                                                                        /*CGL014*/
                                                                                          /*CGL014*/
/** Check if the CRE072 feature is on */                                                  /*CRE072*/
                                                                                          /*CRE072*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE072*/
             CHGVAR     VAR(&SARD) VALUE('CRE072')                                        /*CRE072*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE072*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                        /*CRE072*/
                                                                                          /*CRE072*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CRE072*/
                                                                                          /*CRE072*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE072*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CRE072*/
                GOTO       CMDLBL(ABNOR)                                                  /*CRE072*/
             ENDDO                                                                        /*CRE072*/
                                                                                          /*CRE072*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CRE072*/
                CHGVAR     VAR(&CRE072) VALUE('Y')                                        /*CRE072*/
             ENDDO                                                                        /*CRE072*/
                                                                                          /*CRE072*/
/** Check if the CSW025 feature is on */                                                /*MD027386*/
                                                                                        /*MD027386*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD027386*/
             CHGVAR     VAR(&SARD) VALUE('CSW025')                                      /*MD027386*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD027386*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                      /*MD027386*/
                                                                                        /*MD027386*/
/** If error occured in AOSARDR0, perform abnormal termination */                       /*MD027386*/
                                                                                        /*MD027386*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                           /*MD027386*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                               /*MD027386*/
                GOTO       CMDLBL(ABNOR)                                                /*MD027386*/
             ENDDO                                                                      /*MD027386*/
                                                                                        /*MD027386*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                              /*MD027386*/
                CHGVAR     VAR(&CSW025) VALUE('Y')                                      /*MD027386*/
             ENDDO                                                                      /*MD027386*/
                                                                                        /*MD027386*/
/* Start the calculation manager jobs if required */                                      /*CGL014*/
                                                                                          /*CGL014*/
/**********  IF         COND(&CGL014 *EQ 'Y') THEN(DO) */                      /*CGL014*/ /*CLE024*/
/**********  IF         COND((&CLE024 *EQ 'Y') *OR (&CGL014 *EQ +
                          'Y')) THEN(DO)               */                /*CGL014 CLE024 AR1000912*/
             IF         COND((&CLE024 *EQ 'Y') *OR (&CGL014 *EQ 'Y') +
                          *OR (&CLE025 *EQ 'Y')) THEN(DO)                              /*AR1000912*/
/**********     CALL       PGM(GLC005000)  */                                  /*CGL014*/ /*BG1726*/
                CALL       PGM(GLC005000)  PARM('ALL')                                    /*BG1726*/
             ENDDO                                                                        /*CGL014*/
                                                                                          /*CSD083*/
             IF        COND(&CSD083 *EQ 'Y') THEN(DO)                                     /*CSD083*/
             CALL      PGM(SDC000904)                                                     /*CSD083*/
             ENDDO                                                                        /*CSD083*/
                                                                                          /*CGL014*/
             IF         COND(&CFT158 *EQ 'Y') THEN(DO) /*MD031644*/
                CALL       PGM(FTC000987) PARM('START') /*MD031644*/
             ENDDO      /*MD031644*/
                                                                                          /*CGL014*/
             IF         COND(&CAP205 *EQ 'Y') THEN(DO)                                    /*CAP205*/
             CALL       PGM(REC001500)                                                    /*CAP205*/
             RTVDTAARA  DTAARA(GLFRATMSTS (1 1)) RTNVAR(&FRSTAT)                       /*BUG27831A*/
             IF         COND(&FRSTAT *EQ ' ') THEN(CALL PGM(GLC004607))                /*BUG27831A*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*CAP205*/
/*/COPY OFCPYSRCZ,CGL155_006                                         */                   /*CGL155*/
             IF        COND(&CRE072 *EQ 'Y') THEN(DO)                                     /*CRE072*/
             CALL      PGM(REC004000)                                                     /*CRE072*/
             ENDDO                                                                        /*CRE072*/
                                                                                          /*CRE072*/
/* Start the Midas/Swift Meridian interface */                                          /*MD027386*/
                                                                                        /*MD027386*/
             IF         COND(&CSW025 *EQ 'Y' *AND +
                             (&MPHAS *EQ 'A' *OR +
                              &MPHAS *EQ 'G')) THEN(DO)                                 /*MD027386*/
/**********  WRKMSMIF   OPERATION(*STARTUP)                                    /*MD027386 MD055683*/
             WRKMSMIF   OPERATION(*STARTUP) MCID(*ALL) MODE(*AUTO)                      /*MD055683*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*MD027386*/
             ENDDO                                                                      /*MD027386*/
                                                                                        /*MD027386*/
/*/COPY WNCPYSRC,SCC0104MPE                                          */

             GOTO       CMDLBL(END)

 ABNOR:
/*/COPY WNCPYSRC,SCC0104ERR                                          */
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)               /*178063*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*178063*/
             DSPJOBLOG  OUTPUT(*PRINT)                                /*178063*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*178063*/
             DMPCLPGM                                                 /*178063*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*178063*/

             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

/* Abnormal termination */

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('** +
                          Error - unable to start Midas **') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(%SUBSTRING(&MSG 18 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
             MONMSG     MSGID(CPF0000 MCH0000)

             SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(%SUBSTRING(&SBS 2 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
             MONMSG     MSGID(CPF0000 MCH0000)

             ENDSBS     SBS(&SBS) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,SCC0104END                                          */

             ENDPGM
