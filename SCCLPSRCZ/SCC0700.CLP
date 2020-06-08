/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Reopen input cycle from phase B')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0700 - REOPEN I/C FROM I/C Termination                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. HUT104             Date 27APR20              */
/*       PREV AMEND NO. HUT113             DATE 01APR20              */
/*                      MD046248           Date 27Oct17              */
/*                      MD031644           Date 08Jan15              */
/*                      CGL155             Date 21Mar14              */
/*                      MD022112           Date 05Sep13              */
/*                      CSC048             Date 06Aug12              */
/*                      CCB022             Date 06Aug12              */
/*                      AR544188           Date 01Aug12              */
/*                      CSC054             Date 23Feb12              */
/*                      BUG27831A          Date 03Aug10              */
/*                      BUG27914           Date 22Jul10              */
/*                      CSD083             Date 27May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CAP205             Date 15Feb10              */
/*                      260790             Date 19Jun09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      245533             Date 07Mar07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC023             Date 02Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003             Date 07Sep00              */
/*                      CPB002             Date 01Jun99              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      139764             DATE 29Jul98              */
/*                      CAP002             DATE 05May98              */
/*                      127256             DATE 08DEC97              */
/*                      CTI001             DATE 01SEP97              */
/*                      110242             DATE 07NOV96              */
/*                      092729             Date 11OCT95              */
/*                      S01408             Date 07AUG95              */
/*                      CCB001 *CREATE     DATE 08MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT104 - Call In-House Program on Input Cycle Re-open       */
/*                (Upgrade HUT010 to FM2.1 SP22)                     */
/*                  Amendment of core hook SCC0700002                */
/*                  Addition of hooks HUT104_003 and HUT104_004      */
/*       HUT113 - Full Private Banking Functionality in FM           */
/*                (Upgrade HUT026 to FM2.1 SP22)                     */
/*                Addition of hooks HUT113_045 and HUT113_046        */
/*       MD046248 - Finastra Rebranding                              */
/*       MD031644 - SP7 Build issue (Rework of CFT158 Return         */
/*                  Status of Interfaced FT Payments). Unable        */
/*                  to compile GP002900 due to zonal access.         */
/*                  Submit background job FTRETS_zz.                 */
/*       CGL155 - Forecast Group Limits                              */
/*                Added hooks: CGL155_010 TO CGL155_012              */
/*       MD022112 - SCC1711 performance improvement                  */
/*       CSC048 - Journal Caching                                    */
/*       CCB022 - COB Restructure - COB File Manager                 */
/*       AR544188 - Performance enhancements for LEC07003 component  */
/*                  (Child: AR544186)                                */
/*       CSC054 - Period End Adjustments                             */
/*       BUG27831A - Forward Account Transfer Processing             */
/*       BUG27914 - RAME Design Changes                              */
/*       CSD083 - Watch List Compliance Upgrade                      */
/*       CAP205 - Teller Related APIs - Account Balance Check        */
/*       260790 - COB performance fix                                */
/*                Terminate COBJRNMON if it is running.              */
/*       245533 - Restart SWIFT jobs automaically when reopen in COB.*/
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CTI003 - Midas/TI Interface CoB Changes                     */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*       CCB009 - Journal files throughout close of business         */
/*       139764 - The call to AOSARDR0 for CAP002 should specify     */
/*                the option parameter as *VERIFY.                   */
/*       CAP002 - Conversion of input functions to APIs.             */
/*       127256 - Stop Midas/TI batch jobs when reopening from COB   */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       092729 - Only access switchable feature objects if feature  */
/*                is on.                                             */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCC0700INT                                       */
/*                - SCC0700MPS                                       */
/*                - SCC0700MPE                                       */
/*                - SCC0700ERR                                       */
/*                - SCC0700END                                       */
/*       CCB001 - COB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ERROR)

/*/COPY WNCPYSRC,SCC0700INT                                          */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&JRNSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&SWDR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(7) VALUE('REOPEN +
                          ')
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10) +
                          VALUE('*ALL      ')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEV) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MESG) TYPE(*CHAR) LEN(40)
             DCL        VAR(&ERROR) TYPE(*LGL) LEN(1)

             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*092729*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*092729*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*092729*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*092729*/
/**********  DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N')   */            /*092729 CSC048*/
             DCL        VAR(&CAP002) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CAP002*/
             DCL        VAR(&CAP205) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CAP205*/
             DCL        VAR(&CFT158) TYPE(*CHAR) LEN(1) VALUE('N' ) /*MD031644*/
             DCL        VAR(&CSD083) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD083*/
/**********  DCL        VAR(&CAP203) TYPE(*CHAR) LEN(1) VALUE('N' )         */ /*BUG27914 MD022112*/
/*/COPY OFCPYSRCZ,CGL155_010                                         */                   /*CGL155*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*CTI001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*CTI001*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CTI001*/
/*******************************************************************/              /*CCB009 CCB022*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/              /*CCB009 CCB022*/
/*******************************************************************/              /*CCB009 CCB022*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)            */              /*CCB009 CCB022*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(5)                                    /*CTI003*/
             DCL        VAR(&REOPTI) TYPE(*CHAR) LEN(1)                                   /*CTI003*/
/**********  DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N') */              /*CSC011 CCB022*/
/**********  DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&MMODE) TYPE(*CHAR) LEN(1)             */              /*CSC011 CCB022*/
/**********  DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&SOVR) TYPE(*CHAR) LEN(1)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&APIBKJOB) TYPE(*CHAR) LEN(1) VALUE('Y')*/             /*CSC011 CCB022*/
             DCL        VAR(&DATAQN) TYPE(*CHAR) LEN(10) +
                          VALUE('SCC2470MON')                                             /*260790*/
             DCL        VAR(&DATAQL) TYPE(*CHAR) LEN(10)                                  /*260790*/
             DCL        VAR(&DLEN) TYPE(*DEC) LEN(5 0) VALUE(10)                          /*260790*/
             DCL        VAR(&MESS) TYPE(*CHAR) LEN(10)                                    /*260790*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*260790*/
             DCL        VAR(&FRSTAT) TYPE(*CHAR) LEN(1)                                /*BUG27831A*/
             DCL        VAR(&PEAIND) TYPE(*CHAR) LEN(1)                                   /*CSC054*/
             DCL        VAR(&MQMGR) TYPE(*CHAR) LEN(48)                                   /*CSC054*/
             DCL        VAR(&MQOUT) TYPE(*CHAR) LEN(48)                                   /*CSC054*/
             DCL        VAR(&MQMSG) TYPE(*CHAR) LEN(2000) VALUE('PEA +
                          Ready')                                                         /*CSC054*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CSC054*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC054*/
/*/COPY WNCPYSRC,SCC0700002                                          */
                                                                      /*092729*/
/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,HUT104_003                                          */   /*HUT104*/
/*******************************************************************/              /*CCB009 CCB022*/
/***Check*for*Switchable*feature*CCB009.****************************/              /*CCB009 CCB022*/
/*******************************************************************/              /*CCB009 CCB022*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +     */                     /*CCB022*/
/**********               'CCB009' &AOFMT)                         */              /*CCB009 CCB022*/

/*/COPY WNCPYSRC,SCC0700MPS                                          */
/*********************************************************************/            /*092729 CSC048*/
/**********  CHGVAR     VAR(&OPN) VALUE('*VERIFY')                   */            /*092729 CSC048*/
/**********  CHGVAR     VAR(&SARD) VALUE('S01420')                   */            /*092729 CSC048*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)    */            /*092729 CSC048*/
/**********  IF         COND(&RTN *EQ '       ') THEN(DO)            */            /*092729 CSC048*/
/**********  CHGVAR     VAR(&S01420) VALUE('Y')                      */            /*092729 CSC048*/
/**********  ENDDO                                                   */            /*092729 CSC048*/

/*  Check if the API Switchable Feature is on                         /*CAP002*/
             CHGVAR     VAR(&SARD) VALUE('CAP002')                    /*CAP002*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*139764*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)      /*CAP002*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP002) VALUE('Y'))                    /*CAP002*/
                                                                      /*CAP002*/
/** Check if the Retail Teller API is on */                                               /*CAP205*/
             CHGVAR     VAR(&SARD) VALUE('CAP205')                                        /*CAP205*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CAP205*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                          /*CAP205*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP205) VALUE('Y'))                                        /*CAP205*/
                                                                                        /*MD031644*/
/** Check if the FT Return Status feature is on */                                      /*MD031644*/
             CHGVAR     VAR(&SARD) VALUE('CFT158') /*MD031644*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY') /*MD031644*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT) /*MD031644*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR VAR(&CFT158) +
                          VALUE('Y')) /*MD031644*/
                                                                                          /*CAP205*/
/** Check if CSD083 Feature is on */                                                      /*CSD083*/
                                                                                          /*CSD083*/
             CHGVAR     VAR(&SARD) VALUE('CSD083')                                        /*CSD083*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CSD083*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                          /*CSD083*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD083) VALUE('Y'))                                        /*CSD083*/
                                                                                          /*CSD083*/
/*/COPY OFCPYSRCZ,CGL155_011                                         */                   /*CGL155*/
/***Check*if*CAP203*is*on*******************************************/          /*BUG27914 MD022112*/
/**********  CHGVAR     VAR(&SARD) VALUE('CAP203')                 */          /*BUG27914 MD022112*/
/**********  CHGVAR     VAR(&OPN) VALUE('*VERIFY')                 */          /*BUG27914 MD022112*/
/**********  CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)   */          /*BUG27914 MD022112*/
/**********  IF         COND(&RTN *EQ '       ') THEN(CHGVAR +     */          /*BUG27914 MD022112*/
/**********               VAR(&CAP203) VALUE('Y'))                 */          /*BUG27914 MD022112*/
/*******************************************************************/          /*BUG27914 MD022112*/
/***Check*if*24x7*Midas*Availability*Feature*is*on**/                              /*CSC011 CCB022*/
/*******************************************************************/              /*CSC011 CCB022*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                */              /*CSC011 CCB022*/
/**********  CHGVAR     VAR(&SARD) VALUE('CSC011')                 */              /*CSC011 CCB022*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                */              /*CSC011 CCB022*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &AOFMT)*/             /*CSC011 CCB022*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO)         */              /*CSC011 CCB022*/
/**********     CHGVAR     VAR(&CSC011) VALUE('Y')                 */              /*CSC011 CCB022*/
/**********  ENDDO                                                 */              /*CSC011 CCB022*/
                                                                                          /*CSC011*/
/**********  IF         COND(&S01420 *EQ 'Y') THEN(DO)               */            /*092729 CSC048*/
             DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)

             ALCOBJ     OBJ((CBLOCK *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                SNDPGMMSG  MSG('Re-open ended abnormally')
                GOTO       CMDLBL(ABNOR)
             ENDDO

             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)
             RTVMSG     MSGID(CBM0133) MSGF(CBUSRMSG) MSGDTA(&USR) +
                          MSG(&MESG) SEV(&SEV)

             CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PRC)
             CHGVAR     VAR(%SST(&PARM 8 10)) VALUE(&USR)
             CHGVAR     VAR(%SST(&PARM 18 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&PARM 28 6)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEV)
             CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESG)

             CALL       PGM(CBC0525) PARM(&ALL &PARM)
/**********  ENDDO                                                   */            /*092729 CSC048*/

             CHGVAR     VAR(&MSG) VALUE('INPUT CYCLE IS BEING +
                          RE-OPENED ')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)

/* Call SCC0010 to send i/c being reopened screen */

             RTVMSG     MSGID(SCM0025) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (1 1)) VALUE('1')
             CALL       PGM(SCC0010) PARM('SCC0700' 'BLANK' &NOREPLY)

             CHGJOB     SWS(XXXXXX00)

             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
                                                                      /*CTI001*/
/*  Access PF/SDMMODPD to determine which modules are live  */        /*CTI001*/
                                                                      /*CTI001*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                         /*CTI001*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CTI001*/
             CHGVAR     VAR(&FMT) VALUE(' ')                          /*CTI001*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CTI001*/
/* */                                                                 /*CTI001*/

/* Submit RRAUTOBKP if save interval not 0 and if SWIFT direct */
/* link present start up compression and communication program */

             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
             IF         COND(%SUBSTRING(&JNSTAT 106 5) *NE '00000') +
                          THEN(DO)
                CHGJOB     SWS(XXXXXX0X)
                CALL       PGM(SDC1760)
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
                   MONMSG     MSGID(CPF0000)
                   GOTO       CMDLBL(END)
                 ENDDO
             ENDDO

             IF         COND(&SWDR *EQ 'Y') THEN(CALL PGM(MSC0203))

             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(BYPASS))

             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)

/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +                                  /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +                     /*CPK014*/
/************             OUTQ(*JOBD) RTGDTA(MBATCH) INLLIBL(*JOBD)                       /*CPK014*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(MBATCH) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
                                                                      /*CAP002*/
/*  If the SF is on, start API background functions                   /*CAP002*/
             IF         COND(&CAP002 *EQ 'Y') THEN(DO)                /*CAP002*/
                                                                                          /*CSC011*/
/***If*24x7*Midas*Availability*Feature*is*on***/                                   /*CSC011 CCB022*/
/**********           IF         COND(&CSC011 *EQ 'Y') THEN(DO)    */              /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)*/           /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)*/           /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)*/           /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (11 1)) +        */                     /*CCB022*/
/**********                            RTNVAR(&MMODE)              */              /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&SOVR)*/          /*CSC011 CCB022*/
/*******************************************************************/              /*CSC011 CCB022*/
/***If*24x7*Midas*availability*is*on,*API*background*jobs*in********/              /*CSC011 CCB022*/
/***the*support*system*should*not*be*started*unless*the*support*sys*/              /*CSC011 CCB022*/
/***is*ready*to*accept*data*from*Meridian*(i.e.*API*pgms*in*the*****/              /*CSC011 CCB022*/
/***support*sys*are*in*maintenance*mode*already.)*******************/              /*CSC011 CCB022*/
/*******************************************************************/              /*CSC011 CCB022*/
/**********              IF      COND(((&CURR *EQ &SUPP) *AND (&MMODE *EQ +*/             /*CCB022*/
/**********                      'E')) *OR ((&SOVR *EQ 'S')  *AND (&CURR +*/              /*CCB022*/
/**********                      *EQ &MAIN))) +                    */                     /*CCB022*/
/**********                      THEN(CHGVAR VAR(&APIBKJOB) VALUE('N'))*/          /*CSC011 CCB022*/
/**********           ENDDO                                        */              /*CSC011 CCB022*/
/*******************************************************************/              /*CSC011 CCB022*/
/**********           IF         COND(&APIBKJOB *EQ 'Y') THEN(DO)  */              /*CSC011 CCB022*/
                CALL       PGM(APCSTRBKJB)                            /*CAP002*/
/**********           ENDDO                                        */              /*CSC011 CCB022*/
             ENDDO                                                    /*CAP002*/
                                                                                          /*CSD083*/
             IF        COND(&CSD083 *EQ 'Y') THEN(DO)                                     /*CSD083*/
             CALL      PGM(SDC000904)                                                     /*CSD083*/
             ENDDO                                                                        /*CSD083*/
                                                                                          /*CAP205*/
             IF         COND(&CAP205 *EQ 'Y') THEN(DO)                                    /*CAP205*/
             CALL       PGM(REC001502)                                                    /*CAP205*/
             RTVDTAARA  DTAARA(GLFRATMSTS (1 1)) RTNVAR(&FRSTAT)                       /*BUG27831A*/
             IF         COND(&FRSTAT *EQ ' ') THEN(CALL PGM(GLC004607))                /*BUG27831A*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*CAP205*/
/* Start the FT Return Status background job */                                         /*MD031644*/
             IF         COND(&CFT158 *EQ 'Y') THEN(DO) /*MD031644*/
                CALL       PGM(FTC000987) PARM('START') /*MD031644*/
             ENDDO      /*MD031644*/
                                                                                        /*MD031644*/
/*/COPY OFCPYSRCZ,CGL155_012                                         */                   /*CGL155*/
/***Reset*Retail*Account*Movements*Enquiry*flag*********************/          /*BUG27914 MD022112*/
/**********  IF         COND(&CAP203 *EQ 'Y') THEN(DO)             */          /*BUG27914 MD022112*/
/**********  CALL       PGM(CB000130)                              */          /*BUG27914 MD022112*/
/**********  ENDDO                                                 */          /*BUG27914 MD022112*/
                                                                      /*S01463*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(DO)       /*CTI001*/
/* Check which components have failed; this looks for component's module. */              /*CTI003*/
                CALL       PGM(TIC0016) PARM('TI' &REPLY)                                 /*CTI003*/
                IF         COND(&REPLY *EQ '*BOTH' *OR &REPLY *EQ +
                             '*NONE') THEN(DO)                                            /*CTI003*/
                   RTVMSG     MSGID(SCM0165) MSGF(MIDASMSG) +
                                MSG(&MESSAGE)                                             /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                   /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')                          /*CTI003*/
                   CHGVAR     VAR(&NOREPLY) VALUE(' ')                                    /*CTI003*/
                   CALL       PGM(SCC0010) PARM('SCC0700' 'OPTION' +
                                &NOREPLY)                                                 /*CTI003*/
                                                                                          /*CTI003*/
/* If the user wishes to reopen TI as well: */                                            /*CTI003*/
                   IF         COND(&NOREPLY = 'Y') THEN(DO)                               /*CTI003*/
                      CHGVAR     VAR(&REOPTI) VALUE('Y')                                  /*CTI003*/
                   ENDDO                                                                  /*CTI003*/
                ENDDO                                                                     /*CTI003*/
                IF         COND(&REPLY *EQ '*ONLY') THEN(DO)                              /*CTI003*/
                   CHGVAR     VAR(&REOPTI) VALUE('Y')                                     /*CTI003*/
                ENDDO                                                                     /*CTI003*/
                IF         COND(&REOPTI *EQ 'Y') THEN(DO)                                 /*CTI003*/
                   RSTTICOB   STRCOB(*YES)                                                /*CTI003*/
                                                                      /*127256*/
/* Stop Midas/TI Batch Jobs               */                          /*127256*/
                                                                      /*127256*/
                   CALL       PGM(TIC0050) PARM('STOP')                     /*127256*/
                                                                      /*CTI001*/
/**Start*the*SD*Replication*Task in the TI/CSCS                 */             /*CTI001*/ /*CTI003*/
/************                                                                  /*CTI001*/ /*CTI003*/
/************      CALL       PGM(TIC0030) PARM('START' 'SCC0700')             /*CTI001*/ /*CTI003*/
                                                                      /*CTI001*/
/***Send*RELEASE*message to TI */                                              /*CTI001*/ /*CTI003*/
/************CALL       PGM(TIC0013) PARM('RELEASE' '*MODE')                   /*CTI001*/ /*CTI003*/
                                                                      /*CTI001*/
/* Start Midas/TI Batch Jobs                                    */    /*CTI001*/
                                                                      /*CTI001*/
                   CALL       PGM(TIC0050) PARM('START')                    /*CTI001*/
                ENDDO                                                                     /*CTI003*/
                ELSE DO                                                                   /*CTI003*/
                                                                                          /*CTI003*/
/* Stop Midas/TI Batch Jobs */                                                            /*CTI003*/
                   CALL       PGM(TIC0050) PARM('STOP')                                   /*CTI003*/
/* Start Midas/TI Batch Jobs */                                                           /*CTI003*/
                   CALL       PGM(TIC0050) PARM('START')                                  /*CTI003*/
                ENDDO                                                                     /*CTI003*/
                                                                      /*CTI001*/
             ENDDO                                                    /*CTI001*/
                                                                      /*CTI001*/
BYPASS:
/* If confirmation matching is present, re-submit the control */
/* program (if the I/C run is not still on job queue) before  */
/* returning to input cycle                                   */

             IF         COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&CFSTAT)
/*************  IF         COND(%SST(&CFSTAT 49 6) *EQ '      ') +    /*110242*/
/*************               THEN(SBMJOB CMD(CALL PGM(CFC0180)) +     /*110242*/
/*************            JOB(CFCONTROL) JOBD(MBATCH) JOBQ(CFJOBQA))  /*110242*/
                                                                      /*110242*/
                IF     COND(%SST(&CFSTAT 49 6) *EQ '      ') THEN(DO) /*110242*/
/************      SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                     /*CPK014*/
/************                   JOBD(MBATCH) JOBQ(CFJOBQA) RTGDTA(*JOBD) +                /*CPK014*/
/************                   INLLIBL(*JOBD)                        /*110242*/          /*CPK014*/
/************      SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                     /*CSC023*/
/************             JOBD(MBATCH) JOBQ(CFJOBQA) USER(*JOBD) +                        /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                         /*CPK014*/ /*CSC023*/
                   SBMJOB     CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +
                          JOBD(MBATCH) JOBQ(CFJOBQA) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
                ENDDO                                                 /*110242*/
             ENDDO
/*/COPY WNCPYSRC,SCC0700001                                          */

             RTVDTAARA  DTAARA(SDSTAT (33 1)) RTNVAR(&JRNSTS)

/* Set journal caching off irrespective of */                                             /*CSC048*/
/* 'UseIBMJournalCache?' System Value. */                                                 /*CSC048*/
                                                                                          /*CSC048*/
             CHGJRN     JRN(ICJRN) JRNCACHE(*NO)                                          /*CSC048*/
                                                                                          /*CSC048*/
/*******************************************************************/              /*CCB009 CCB022*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/              /*CCB009 CCB022*/
/*******************************************************************/              /*CCB009 CCB022*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */              /*CCB009 CCB022*/
/**********  IF         COND(&JRNSTS *EQ 'N') THEN(DO)             */                     /*CSC048*/
/***COPY*WNCPYSRC,SCC0700003                                       */                     /*CSC048*/
/**********     ENDJRNPF   FILE(*ALL) JRN(ICJRN)                   */                     /*CSC048*/
/***COPY*WNCPYSRC,SCC0700004                                       */                     /*CSC048*/
/**********     CALL       PGM(SCJRN)                              */                     /*CSC048*/
/**********  ENDDO                                                 */                     /*CSC048*/
/**********  ENDDO                                                                 /*CCB009 CCB022*/

/* Reset ICT reopen flag */

             CHGDTAARA  DTAARA(CBPROMPT (256 1)) VALUE(' ')

/*/COPY WNCPYSRC,SCC0700MPE                                          */
/*********************************************************************/          /*AR544188 CCB022*/
/***Call*CBCFMGR005*to*shut*down*background*jobs*if*active************/          /*AR544188 CCB022*/
/*********************************************************************/          /*AR544188 CCB022*/
/**********  CALL       PGM(CBCFMGR005)                      */                  /*AR544188 CCB022*/
                                                                                          /*CCB022*/
/* Call SC001006 to return members that were removed during CoB */                        /*CCB022*/
                                                                                          /*CCB022*/
             CALL       PGM(SC001006)                                                     /*CCB022*/
                                                                                          /*CCB022*/
/**/                                                                                      /*260790*/
/* Stop the SCC2470MON journal save process */                                            /*260790*/
/**/                                                                                      /*260790*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*260790*/
             CHGVAR     VAR(&DATAQL) VALUE(&SYSID *CAT 'XLIB')                            /*260790*/
             CHGVAR     VAR(&MESS) VALUE('STOP      ')                                    /*260790*/
             CALL       PGM(QSNDDTAQ) PARM(&DATAQN &DATAQL &DLEN &MESS)                   /*260790*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*260790*/
                                                                      /*CPB002*/
/**********  IF         COND(%SST(&FMT 104 1) *EQ 'Y') THEN(DO)    */              /*CPB002 CCB022*/
/**********    RMVPFTRG   FILE(FWDRTFE)                            */              /*CPB002 CCB022*/
/**********    MONMSG     MSGID(CPF0000)                           */              /*CPB002 CCB022*/
/**********                                                        */              /*CPB002 CCB022*/
/**********    ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +          */                     /*CCB022*/
/**********               TRGEVENT(*INSERT) PGM(PB6602)            */              /*CPB002 CCB022*/
/**********                                                        */              /*CPB002 CCB022*/
/**********    ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +          */                     /*CCB022*/
/**********               TRGEVENT(*UPDATE) PGM(PB6602) +          */                     /*CCB022*/
/**********               TRGUPDCND(*CHANGE)                       */              /*CPB002 CCB022*/
/**********  ENDDO                                                 */              /*CPB002 CCB022*/
                                                                      /*CPB002*/
/*  Check if the REPLICATION Feature is on   */                       /*CPB002*/
             CHGVAR     VAR(&SARD) VALUE('CRP006')                    /*CPB002*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CPB002*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)      /*CPB002*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CPB002*/
                                                                      /*CPB002*/
/**  Start System Replication  **/                                    /*CPB002*/
/*/COPY WNCPYSRC,HUT113_045                                          */   /*HUT113*/
               CALL       PGM(RPC0010)                                /*CPB002*/
/*/COPY WNCPYSRC,HUT113_046                                          */   /*HUT113*/
             ENDDO                                                    /*CPB002*/

/* Start SWIFT jobs (process includes MS_ENABLED data area check)                         /*245533*/
             CALL       PGM(MSC0203)                                                      /*245533*/
                                                                                          /*245533*/
/* Check if the CSW025 Feature is on */                                                   /*245533*/
             CHGVAR     VAR(&SARD) VALUE('CSW025')                                        /*245533*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*245533*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                          /*245533*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*245533*/
                                                                                          /*245533*/
/* Start MMM jobs */                                                                      /*245533*/
               CALL       PGM(MEC0720)                                                    /*245533*/
             ENDDO                                                                        /*245533*/
                                                                                          /*245533*/
                                                                                          /*CSC054*/
/** Start Listener Port */                                                                /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(LSNPORCTL) PARM('START')                                      /*CSC054*/
                                                                                          /*CSC054*/
/** Check for PEA Switchable feature CSC054 */                                            /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(AOSARDR0) PARM(&RTN '*VERIFY' +
                          'CSC054' &AOFMT)                                                /*CSC054*/
                                                                                          /*CSC054*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*CSC054*/
                                                                                          /*CSC054*/
/** Get PEA system values */                                                              /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'PEAIndicator' &SVAL1 +
                          'PEAHandShakingQM' &SVAL2 +
                          'PEAHandShakingOQ' &SVAL3 +
                          'PEALiveSystemPrefix' &SVAL4 +
                          &SVALK5 &SVAL5  &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)                                /*CSC054*/
                                                                                          /*CSC054*/
             CHGVAR     VAR(&PEAIND) VALUE(%SST(&SVAL1 1 1))                              /*CSC054*/
                                                                                          /*CSC054*/
             IF         COND(&PEAIND *EQ 'Y') THEN(DO)                                    /*CSC054*/
             CHGVAR     VAR(&MQMGR) VALUE(&SVAL2)                                         /*CSC054*/
             CHGVAR     VAR(&MQOUT) VALUE(&SVAL3)                                         /*CSC054*/
             CHGVAR     VAR(&PRFX) VALUE(%SST(&SVAL4 1 2))                                /*CSC054*/
                                                                                          /*CSC054*/
/** Send PEA Ready message to Live */                                                     /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(ZAMSGTOMQ) PARM(&RSVALRTNC &PRFX +
                          &MQMGR &MQOUT &MQMSG)                                           /*CSC054*/
              ENDDO                                                                       /*CSC054*/
                                                                                          /*CSC054*/
              ENDDO                                                                       /*CSC054*/
                                                                                          /*CSC054*/
/*/COPY WNCPYSRC,HUT104_004                                          */   /*HUT104*/
             GOTO       CMDLBL(END)

 ABNOR:
/*/COPY WNCPYSRC,SCC0700ERR                                          */

             SNDPGMMSG  MSG('SCC0700 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(&ERROR) VALUE('1')
             MONMSG     MSGID(CPF0000 MCH0000)

 END:
/*/COPY WNCPYSRC,SCC0700END                                          */

/**********  IF         COND(&S01420 *EQ 'Y') THEN(DO)               */            /*092729 CSC048*/
             DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
/**********  ENDDO                                                   */            /*092729 CSC048*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
