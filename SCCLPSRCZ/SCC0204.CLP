/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Submit background jobs')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0204 - Midas Sign On Calls                               */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. HUT104             Date 27Apr20              */
/*       Prev Amend No. MD046248           Date 05Feb18              */
/*                      MD045731           Date 27Sep17              */
/*                      MD031644           Date 08Jan15              */
/*                      CGL155             Date 21Mar14              */
/*                      MD025679A          Date 12May14              */
/*                      MD025679           Date 12May14              */
/*                      AR927362A          Date 05Dec12              */
/*                      CCB020             Date 06Aug12              */
/*                      AR927362           Date 19Apr12              */
/*                      CER059             Date 19Jul10              */
/*                      BUG22568           Date 29Jan09              */
/*                      BUG27831A          Date 03Aug10              */
/*                      CSD083             Date 27May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CAP205             Date 15Feb10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG14349           Date 17Jul07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      240093             Date 08Nov06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP004             Date 23Feb04              */
/*                      CAP084             Date 21Jan04              */
/*                      CAAA02  *CREATE    Date 06Sep03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT104   - UPGRADE HUT010 TO FBM 2.1 SP 22                  */
/*                - Call In-House Program on Input Cycle Re-open     */
/*                  USE /COPY SCC0204MPE                             */
/*       MD046248 - Finastra Rebranding                              */
/*       MD045731 - Restart batch job for MT94x if not active.       */
/*       MD031644 - SP7 Build issue (Rework of CFT158 Return         */
/*                  Status of Interfaced FT Payments). Unable        */
/*                  to compile GP002900 due to zonal access.         */
/*                  Submit background job FTRETS_zz.                 */
/*       CGL155 - Forecast Group Limits                              */
/*                Added hooks: CGL155_007 TO CGL155_009              */
/*       MD025679A - API - OLPOSOA Locking Issue Performance Update  */
/*       MD025679 - API - OLPOSOA Locking Issue.                     */
/*       AR927362A - Job GP_UTU_MGR nor GPUTUMOSC1 were started.     */
/*                   Enhance fix AR927362 to check if GP_UTU_MGR is  */
/*                   running, if not, submit GP_UTU_MGR and start    */
/*                   GPUTUMOSC1. (Child: AR927364)                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       AR927362 - Job GP_UTU_MGR not started automatically, when   */
/*                  restarted is in LCKW status. (Child:AR927364)    */
/*                - Applied for AR955786 (Child:AR955787)            */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22568 - SCKOBJLCOB Failed. Similar to fix 14349          */
/*       BUG27831A - Forward Account Transfer Processing             */
/*       CSD083 - Watch List Compliance Upgrade                      */
/*       CAP205 - Teller Related APIs - Account Balance Check        */
/*       BUG14349 - Component should not submit during COB           */
/*       240093 - Start API background jobs                          */
/*       CGP004 - Audit Reporting                                    */
/*       CAP084 - API Wrapper project - start background updates for */
/*                global layer.                                      */
/*       CAAA02 - Webfacing Enhancement                              */
/*                                                                   */
/*********************************************************************/
             PGM

/*/COPY WNCPYSRC,SCC0204INT                                          */

             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&RETCDE) TYPE(*CHAR) LEN(10) VALUE(' ')                       /*240093*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CLE010) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CGL013) TYPE(*CHAR) LEN(1) VALUE('N' )                     /*MD045731*/
             DCL        VAR(&CSE039) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CGP004) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CGP004*/
             DCL        VAR(&CAP002) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*240093*/
             DCL        VAR(&CAP205) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAP205*/
             DCL        VAR(&CFT158) TYPE(*CHAR) LEN(1) VALUE('N') /*MD031644*/
             DCL        VAR(&CSD083) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD083*/
/*/COPY OFCPYSRCZ,CGL155_007                                         */                   /*CGL155*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                  /*BUG14349*/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)                              /*CAP084*/
             DCL        VAR(&FRSTAT) TYPE(*CHAR) LEN(1)                                /*BUG27831A*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2003')

             DCL        VAR(&DTAQPREF) TYPE(*CHAR) LEN(5)                               /*AR927362*/
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)                                  /*AR927362*/
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)                                  /*AR927362*/
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')                   /*AR927362*/
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)                                /*AR927362*/
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)                                 /*AR927362*/
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)                                /*AR927362*/
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)                                /*AR927362*/
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)                                 /*AR927362*/
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)                                /*AR927362*/
             DCL        VAR(&NJOBS) TYPE(*CHAR) LEN(1)                                  /*AR927362*/
                                                                                        /*AR927362*/
/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/** Retrieve data area MPHAS and check if input cycle */                                /*BUG14349*/
/** else end this job */                                                                /*BUG14349*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                    /*BUG14349*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(GOTO CMDLBL(END))           */ /*BUG14349 CCB020*/
             IF         COND(&MPHAS *NE 'A' *AND &MPHAS *NE 'G') +
                          THEN(GOTO CMDLBL(END))                                          /*CCB020*/

             RTVJOBA    TYPE(&JOBTYPE)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

/*/COPY WNCPYSRC,SCC0204MPS                                          */
                                                                                          /*CAP084*/
/* Start commitment control */                                                            /*CAP084*/
                                                                                          /*CAP084*/
             CALL       PGM(SCCMTCTL) PARM('S' &RETURNCODE)                               /*CAP084*/

/* Submit the Technical Platform background job */

                   CALL       PGM(SCC0103) PARM('TP')

/* Access PF/SDMMODPD to determine which modules are live */

             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &FMT)

/*  Database error handling  */

             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('Database error on Midas modules +
                             file') TOMSGQ(MOPERQ MRUNQ)

/**Call*SCC0010*to*inform*user*that*an*error*has*occurred*************/                /*MD025679A*/
/**********                                                                            /*MD025679A*/
/**********     RTVMSG     MSGID(SCM0074) MSGF(MIDASMSG) +                             /*MD025679A*/
/**********                  MSG(&MESSAGE)                                             /*MD025679A*/
/**********     CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                   /*MD025679A*/
/**********     RTVMSG     MSGID(SCM0075) MSGF(MIDASMSG) +                             /*MD025679A*/
/**********                  MSG(&MESSAGE)                                             /*MD025679A*/
/**********     CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)                   /*MD025679A*/
/**********     CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')                          /*MD025679A*/
/**********     CALL       PGM(SCC0010) PARM('SCC0102' 'ENTER' ' ')                    /*MD025679A*/
                GOTO       CMDLBL(ABNOR)
             ENDDO

/* If the Exposure Management module is present submit the EM jobs */

                   IF         COND(%SST(&FMT 25 1) *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('EM'))

/* If the TI INTERFACE MODULE is present submit the TI job         */

                   IF   COND(%SST(&FMT 103 1) *EQ 'Y') THEN(CALL +
                          PGM(SCC0103) PARM('TI'))

/* If the EXPORT DATA MODULE is present submit the ED job          */

                   IF         COND(%SST(&FMT 99 1) *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('ED'))

/*    Check if Citydealer Interface feature is active.             */

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CCM002')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))

/*    Check if CCRM - Limits is active (CDE001)                     */

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CDE001')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))

/*    Check if Lending PC Interface switched on (CLE010) */

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CLE010')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE010) VALUE('Y'))

/*    Check if Automatic Trade Settlement is on (CSE039) */

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE039')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE039) VALUE('Y'))

/*    Check if Audit Reporting is on (CGP004) */                                          /*CGP004*/
                                                                                          /*CGP004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGP004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGP004*/
             CHGVAR     VAR(&SAR) VALUE('CGP004')                                         /*CGP004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CGP004*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGP004) VALUE('Y'))                                        /*CGP004*/
                                                                                          /*CGP004*/
/** Check if the Retail Teller API is on */                                               /*CAP205*/
                                                                                          /*CAP205*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAP205*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAP205*/
             CHGVAR     VAR(&SAR) VALUE('CAP205')                                         /*CAP205*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CAP205*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP205) VALUE('Y'))                                        /*CAP205*/

/** Check if the FT Return Status feature is on */                                      /*MD031644*/
                                                                                        /*MD031644*/
             CHGVAR     VAR(&RTCD) VALUE('       ') /*MD031644*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY') /*MD031644*/
             CHGVAR     VAR(&SAR) VALUE('CFT158') /*MD031644*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*MD031644*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR VAR(&CFT158) +
                          VALUE('Y')) /*MD031644*/
                                                                                        /*MD031644*/
/*/COPY OFCPYSRCZ,CGL155_008                                         */                   /*CGL155*/
/*  Check if the API Switchable Feature is on                         */                  /*240093*/
             CHGVAR     VAR(&SAR) VALUE('CAP002')                                         /*240093*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*240093*/
             CALL      PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                       /*240093*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP002) VALUE('Y'))                                        /*240093*/
                                                                                          /*240093*/
/* Check if CSD083 is on*/                                                                /*CSD083*/
                                                                                          /*CSD083*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSD083*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSD083*/
             CHGVAR     VAR(&SAR) VALUE('CSD083')                                         /*CSD083*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSD083*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD083) VALUE('Y'))                                        /*CSD083*/
                                                                                          /*CSD083*/
/**/                                                                                    /*MD045731*/
/*    Check if the MT94x Messages Generation is active (CGL013) */                      /*MD045731*/
/**/                                                                                    /*MD045731*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD045731*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD045731*/
             CHGVAR     VAR(&SAR) VALUE('CGL013')                                       /*MD045731*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*MD045731*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL013) VALUE('Y'))                                      /*MD045731*/
/**/                                                                                    /*MD045731*/
/*/COPY WNCPYSRC,SCC0204001                                        */

/*    If Citydealer Interface feature is on, call SCC0103.          */

                   IF         COND(&CITYDLR *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('CD'))

/*    If CCRM - Limits is active, submit Data Export job             */

                   IF         COND(&CDE001 *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('DE'))

/*    If Lending PC Interface switched on (CLE010)                   */

                   IF         COND(&CLE010 *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('LE'))

/*    If Automatic Trade Settlement is on (CSE039) */

                   IF         COND(&CSE039 *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('SE'))
/**/                                                                                    /*MD045731*/
/* If Cash Management is on (CGL013)  *                                                 /*MD045731*/
/**/                                                                                    /*MD045731*/
                   IF         COND(&CGL013 *EQ 'Y') THEN(CALL +
                                PGM(SCC0103) PARM('MT'))                                /*MD045731*/

/* If APIs SF is on, create the API DUMP information data area.    */                     /*240093*/
                                                                                          /*240093*/
             IF        COND(&CAP002 *EQ 'Y') THEN(DO)                                     /*240093*/
                CALL       PGM(APCCRTQTO) PARM(&RETCDE)                                   /*240093*/
                CALL       PGM(APCSTRBKJB)                                                /*240093*/
             ENDDO                                                                        /*240093*/
                                                                                          /*240093*/
             IF        COND(&CAP205 *EQ 'Y') THEN(DO)                                     /*CAP205*/
             CALL       PGM(REC001500)                                                    /*CAP205*/
             RTVDTAARA  DTAARA(GLFRATMSTS (1 1)) RTNVAR(&FRSTAT)                       /*BUG27831A*/
             IF         COND(&FRSTAT *EQ ' ') THEN(CALL PGM(GLC004607))                /*BUG27831A*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*240093*/
/* Start background job for FT Return Status. */                                        /*MD031644*/
             IF         COND(&CFT158 *EQ 'Y') THEN(DO) /*MD031644*/
                CALL       PGM(FTC000987) PARM('START') /*MD031644*/
             ENDDO      /*MD031644*/
/*/COPY OFCPYSRCZ,CGL155_009                                         */                   /*CGL155*/
                                                                                          /*CSD083*/
             IF        COND(&CSD083 *EQ 'Y') THEN(DO)                                     /*CSD083*/
             CALL      PGM(SDC000904)                                                     /*CSD083*/
             ENDDO                                                                        /*CSD083*/
                                                                                          /*240093*/
/* Start background updates for global layer. */                                          /*CAP084*/
             CALL       PGM(GOC0101)                                                      /*CAP084*/
                                                                                          /*CAP084*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*AR927362*/
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)                                                      /*AR927362*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*AR927362*/
               GOTO       CMDLBL(ABNOR)                                                 /*AR927362*/
             ENDDO                                                                      /*AR927362*/
                                                                                        /*AR927362*/
             CHGVAR     VAR(&DTAQPREF) VALUE('GPUTU')                                   /*AR927362*/
             CHGVAR     VAR(&NJOBS) VALUE(&ZONJOB)                                      /*AR927362*/
             CHGVAR     VAR(&DTAQ) VALUE(&DTAQPREF *CAT &ZOSHTC +
                           *CAT &NJOBS)                                                 /*AR927362*/
                                                                                        /*AR927362*/
/** Check if Update Manager is active */                                               /*AR927362A*/
             ALCOBJ     OBJ((GPUTJSPD *FILE *EXCL)) WAIT(0)                            /*AR927362A*/
             MONMSG     MSGID(CPF1002 CPF1040 CPF1085) EXEC(DO)                        /*AR927362A*/
                                                                                       /*AR927362A*/
/** Cannot allocate object - Update Manager already active, +
     check the zone updater */                                                         /*AR927362A*/
                                                                                       /*AR927362A*/
             GOTO       CMDLBL(ZONEUPD)                                                /*AR927362A*/
             ENDDO                                                                     /*AR927362A*/
                                                                                       /*AR927362A*/
             DLCOBJ     OBJ((GPUTJSPD *FILE *EXCL))                                    /*AR927362A*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 /*AR927362A*/
                                                                                       /*AR927362A*/
/** Submit the Update Manager */                                                       /*AR927362A*/
             SBMJOB     JOB(GP_UTU_MGR) JOBD(GPBATCH) +
                          JOBQ(GPUTMJOBQ) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GPC0002') INLLIBL(*JOBD) OUTQ(*JOBD)            /*AR927362A*/
                                                                                       /*AR927362A*/
ZONEUPD:                                                                               /*AR927362A*/
             ALCOBJ     OBJ((&DTAQ *DTAQ *EXCL)) WAIT(0)                                /*AR927362*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO) */            /*AR927362 AR927362A*/
             MONMSG     MSGID(CPF1002 CPF1040 CPF1085) EXEC(DO)                        /*AR927362A*/
                                                                                       /*AR927362A*/
/** Cannot allocate object - Zone updater already running +
     skip and dont do not send Start Message to the update Manager */                  /*AR927362A*/
/**********  CALL       PGM(GOC0002) PARM('END' '*LIBL' ' ') */               /*AR927362 AR927362A*/
                                                                                       /*AR927362A*/
             GOTO       CMDLBL(NEXT)                                                   /*AR927362A*/
             ENDDO                                                                      /*AR927362*/
                                                                                        /*AR927362*/
/** Start the zone updater */                                                          /*AR927362A*/
             DLCOBJ     OBJ((&DTAQ *DTAQ *EXCL *N))                                    /*AR927362A*/
             CALL       PGM(GOC0002) PARM('START' '*LIBL' ' ')                          /*AR927362*/
                                                                                        /*AR927362*/
NEXT:                                                                                  /*AR927362A*/
                                                                                        /*MD025679*/
/* Submit the background updater */                                                     /*MD025679*/
                                                                                        /*MD025679*/
/**********  SBMJOB     JOB(GLC007001) JOBD(*LIBL/MBATCH) +                            /*MD025679A*/
/**********             JOBQ(*JOBD) PRTDEV(*CURRENT) OUTQ(*JOBD) +                     /*MD025679A*/
/**********             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                       /*MD025679A*/
/**********             GLC007001') INLLIBL(*JOBD)                            /*MD025679 MD025679A*/
                                                                                        /*MD025679*/
             CALL       PGM(GLC007001)                                                 /*MD025679A*/
                                                                                       /*MD025679A*/
/* Start audit reporting batch job */                                                     /*CGP004*/
                                                                                          /*CGP004*/
             IF         COND(&CGP004 *EQ 'Y') THEN(CALL +
                          PGM(GOC0300))                                                   /*CGP004*/
                                                                                          /*CGP004*/

/*/COPY WNCPYSRC,SCC0204MPE                                          */

             GOTO       CMDLBL(END)

ABNOR:
/*/COPY WNCPYSRC,SCC0204ERR                                          */

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            mmCnnnn ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')

/*/COPY WNCPYSRC,SCC0204END                                          */

             ENDPGM
