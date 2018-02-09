/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas operators initial menu')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       MIPGM - Midas Initial Program Control.                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAAA02             Date 06Sep03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      213557             Date 02Jan03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      092825             Date 01Sep95              */
/*                      CAAA01             Date 12Apr95              */
/*                      S01463             DATE 20JAN94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAAA02 - Webfacing Enhancement                              */
/*       213557 - Allow the system to be locked out to all users for */
/*                upgrade purposes.                                  */
/*       CSC011 - 24x7 Midas Availability                            */
/*       092825 - Add initialisation status processing.              */
/*       CAAA01 - GUI/400 Development:                               */
/*                - Amended to display the Midas Initial Screen.     */
/*       S01463 - New program to allow the Midas initial program     */
/*                processing to be updated without the need to       */
/*                change the subsystem routing entries. Most of      */
/*                the old MIPGM processing has been moved to new     */
/*                programs SCC0101, SCC0102 and SCC0103.             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&COBAUT) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
                                                                                          /*CSC011*/
/** Define variables for AOSARDR0 */                                                      /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CSC011*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CSC011*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CSC011*/
                                                                                          /*CSC011*/
/** Define variables for AOWMNUR0 */                                                      /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&OPTN2) TYPE(*CHAR) LEN(7)                                    /*CSC011*/
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)                                     /*CSC011*/
             DCL        VAR(&WFMT) TYPE(*CHAR) LEN(400)                                   /*CSC011*/
                                                                                          /*CSC011*/
/** Define work variables for CSC011 */                                                   /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&S3STRT) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCL        VAR(&S4STRT) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                                     /*CSC011*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC011*/
                                                                                          /*CSC011*/
/** Define work variables for job attributes */                                           /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)                                  /*CSC011*/
             DCL        VAR(&JOBUSR) TYPE(*CHAR) LEN(10)                                  /*CSC011*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                                    /*CSC011*/
             DCL        VAR(&ROUTE) TYPE(*CHAR) LEN(1)                                    /*CSC011*/
                                                                                          /*CSC011*/
/** Define and initialise transfer job indicator */                                       /*CSC011*/
             DCL        VAR(&TFRJOB) TYPE(*CHAR) LEN(1) VALUE('Y')                        /*CSC011*/
                                                                                          /*CSC011*/
/* Define work variables for System Values */                                             /*213557*/
                                                                                          /*213557*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*213557*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*213557*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                  /*213557*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*213557*/
                                                                                          /*213557*/
/*/COPY WNCPYSRC,MIPGM004                                            */
 
/* Global monitor */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
                                                                                          /*CSC011*/
/** Create the Midas Information Screen data area and Local Data     */                   /*CSC011*/
/** area at this part since we need to access them when error occurs */                   /*CSC011*/
/** in CSC011 processing.                                            */                   /*CSC011*/
                                                                                          /*CSC011*/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')                                       /*CSC011*/
             MONMSG     MSGID(CPF1023)                                                    /*CSC011*/
                                                                                          /*CSC011*/
/* Check whether the Midas system is locked */                                            /*213557*/
                                                                                          /*213557*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE 'SystemLockStatus' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK0 &SVAL10)                                 /*213557*/
                                                                                          /*213557*/
             IF         COND(%SST(&SVAL1 1 8) *EQ '*UPGRADE') THEN(DO)                    /*213557*/
                                                                                          /*213557*/
/* Call SCC0010 to inform the user that an error has occurred */                          /*213557*/
                                                                                          /*213557*/
                RTVMSG     MSGID(SCM0185) MSGF(GBMIDASMSG) MSG(&MESSAGE)                  /*213557*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*213557*/
                                                                                          /*213557*/
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                      /*213557*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*213557*/
                                                                                          /*213557*/
                RTVMSG     MSGID(SCM0037) MSGF(GBMIDASMSG) MSG(&MESSAGE)                  /*213557*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*213557*/
                                                                                          /*213557*/
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)                      /*213557*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*213557*/
                                                                                          /*213557*/
                CALL       PGM(SCC0010) PARM('MIPGM' 'ENTER' ' ')                         /*213557*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*213557*/
                                                                                          /*213557*/
                SIGNOFF                                                                   /*213557*/
                                                                                          /*213557*/
             ENDDO                                                                        /*213557*/
                                                                                          /*213557*/
/** Create local data area */                                                             /*CSC011*/
                                                                                          /*CSC011*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')                                /*CSC011*/
             MONMSG     MSGID(CPF1023)                                                    /*CSC011*/
                                                                                          /*CSC011*/
/* Determine whether the user is a COB user */                                            /*CSC011*/
                                                                                          /*CSC011*/
             RTVJOBA    USER(&JOBUSR)                                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*KEY')                                          /*CSC011*/
                                                                                          /*CSC011*/
             CALL       PGM(AOUSERR0) PARM(&RTCD &OPTN &JOBUSR +
                          &DSSDY)                                                         /*CSC011*/
             IF         COND(&RTCD *EQ '      ') THEN(DO)                                 /*CSC011*/
               CHGVAR     VAR(&COBAUT) VALUE(%SST(&DSSDY 225 1))                          /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*FREE')                                         /*CSC011*/
                                                                                          /*CSC011*/
             CALL       PGM(AOUSERR0) PARM(&RTCD &OPTN &JOBUSR +
                          &DSSDY)                                                         /*CSC011*/
                                                                                          /*CSC011*/
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&SARD) VALUE('CSC011')                                        /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                       /*CSC011*/
                                                                                          /*CSC011*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTNC *NE '       ' *AND &RTNC *NE +
                          '*NRF   ') THEN(DO)                                             /*CSC011*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CSC011*/
                GOTO       CMDLBL(ABNOR)                                                  /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTNC *EQ '       ') THEN(DO)                                /*CSC011*/
                CHGVAR     VAR(&CSC011) VALUE('Y')                                        /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/** If switchable CSC011 is installed, determine if job needs */                          /*CSC011*/
/** to be routed to support system.                           */                          /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)                             /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)                             /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)                             /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&MODE)                            /*CSC011*/
                RTVDTAARA  DTAARA(SCSUPP (1 1)) RTNVAR(&S3STRT)                           /*CSC011*/
                RTVDTAARA  DTAARA(SCREOP (1 1)) RTNVAR(&S4STRT)                           /*CSC011*/
                                                                                          /*CSC011*/
/** When user is in main system and transition is not yet started, */                     /*CSC011*/
/** Data Replication should be processed.                          */                     /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND((&MAIN *EQ &CURR) *AND (&MODE *EQ +
                          ' ') *AND (&S3STRT *EQ ' ') *AND (&S4STRT *EQ ' ')) +
                          THEN(CALL PGM(SCC000600))                                       /*CSC011*/
                                                                                          /*CSC011*/
/** Verify if the reroute field for this user is set to 'Y' in       */                   /*CSC011*/
/** SFWMNUPD file. If 'Y', it means that he is the operator and he   */                   /*CSC011*/
/** can sign on to the main system even if switchover mode has       */                   /*CSC011*/
/** started.                                                         */                   /*CSC011*/
                RTVJOBA    JOB(&WRKSTN) USER(&JOBUSR)                                     /*CSC011*/
                                                                                          /*CSC011*/
                CHGVAR     VAR(&RTCD) VALUE('       ')                                    /*CSC011*/
                CHGVAR     VAR(&OPTN2) VALUE('*KEY   ')                                   /*CSC011*/
                CHGVAR     VAR(&KEY) VALUE(&WRKSTN)                                       /*CSC011*/
                CALL       PGM(AOWMNUR0) PARM(&RTCD &OPTN2 &KEY &WFMT)                    /*CSC011*/
                                                                                          /*CSC011*/
/** If error occured in AOWMNUR0, perform abnormal termination */                         /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CSC011*/
                   SNDPGMMSG  MSG('Program error in AOWMNUR0') +
                              TOMSGQ(MOPERQ)                                              /*CSC011*/
                   GOTO       CMDLBL(ABNOR)                                               /*CSC011*/
                ENDDO                                                                     /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(&RTCD *EQ '       ') THEN(DO)                             /*CSC011*/
                CHGVAR     VAR(&USER) VALUE(%SST(&WFMT 11 10))                            /*CSC011*/
                CHGVAR     VAR(&ROUTE) VALUE(%SST(&WFMT 258 1))                           /*CSC011*/
                ENDDO                                                                     /*CSC011*/
                                                                                          /*CSC011*/
/** If current user is same as retrieved user and reroute field is   */                   /*CSC011*/
/** 'Y', do not perform transfer job since operator has access to    */                   /*CSC011*/
/** main system even if switchover has started.                      */                   /*CSC011*/
                                                                                          /*CSC011*/
                IF  COND((&RTCD *EQ '       ') *AND (&JOBUSR *EQ +
                        &USER) *AND (&ROUTE *EQ 'Y')) THEN(CHGVAR +
                        VAR(&TFRJOB) VALUE('N'))                                          /*CSC011*/
                                                                                          /*CSC011*/
/** If current user is flagged as a COB User on MUSER then do not    */                   /*CSC011*/
/** perform transfer job since operator has access to main system    */                   /*CSC011*/
/** even if switchover has started.                                  */                   /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(&COBAUT *EQ 'Y') THEN(CHGVAR +
                             VAR(&TFRJOB) VALUE('N'))                                     /*CSC011*/
                                                                                          /*CSC011*/
/** If switchover mode is 'S' and current system is the main  */                          /*CSC011*/
/** system, then transfer this job to the support system.     */                          /*CSC011*/
                                                                                          /*CSC011*/
                IF        COND((&MODE *EQ 'S') *AND (&CURR *NE &SUPP) +
                          *AND (&TFRJOB *EQ 'Y')) THEN(DO)                                /*CSC011*/
                                                                                          /*CSC011*/
                   CALL       PGM(SCC004316) PARM(&SUPP)                                  /*CSC011*/
                                                                                          /*CSC011*/
/** If error occured in SCC004316, perform abnormal termination */                        /*CSC011*/
                                                                                          /*CSC011*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                            /*CSC011*/
                      SNDPGMMSG  MSG('Program error occurred in +
                                 SCC004316') TOMSGQ(MOPERQ)                               /*CSC011*/
                      GOTO       CMDLBL(ABNOR)                                            /*CSC011*/
                   ENDDO                                                                  /*CSC011*/
                                                                                          /*CSC011*/
                ENDDO                                                                     /*CSC011*/
             ENDDO                                                                        /*CSC011*/
 
/*/COPY WNCPYSRC,MIPGM001                                            */
/* Display the Midas Initial Screen */                                /*CAAA01*/
                                                                      /*CAAA01*/
/**********  CALL       PGM(SCC0001)                       /*CAAA01*/ /*092825*/
             CALL       PGM(SCC0001) PARM('01')                       /*092825*/
                                                                      /*CAAA01*/
/** No need to create Midas Information Screen and LDA dta areas     */                   /*CSC011*/
/** again since we have created them already at start of program     */                   /*CSC011*/
                                                                                          /*CSC011*/
/**Create*the*Midas*Information*Screen*data*area**********************/                   /*CSC011*/
/*********************************************************************/                   /*CSC011*/
/**********  CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +*/                   /*CSC011*/
/**********               VALUE(' ') TEXT('Midas SC Midas +          */                   /*CSC011*/
/**********               information screen data')                  */                   /*CSC011*/
/**********  MONMSG     MSGID(CPF1023)                               */                   /*CSC011*/
/*********************************************************************/                   /*CSC011*/
/**Create*local*data*area*********************************************/                   /*CSC011*/
/*********************************************************************/                   /*CSC011*/
/**********  CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +     */                   /*CSC011*/
/**********               TEXT('Midas SD Local data area')           */                   /*CSC011*/
/**********  MONMSG     MSGID(CPF1023)                               */                   /*CSC011*/
 
/* Call the Midas initial program */
 
/*/COPY WNCPYSRC,MIPGM002                                            */
/**********  CALL       PGM(SCC0101)                                 */                   /*CAAA02*/
             CALL       PGM(SCC0201)                                                      /*CAAA02*/
/*/COPY WNCPYSRC,MIPGM003                                            */
 
 ABNOR:
 
             SNDPGMMSG  MSG('Midas initial program terminated +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SCM0072) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SCC0010) PARM('MIPGM' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
/*/COPY WNCPYSRC,MIPGM005                                            */
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
/*/COPY WNCPYSRC,MIPGM006                                            */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
