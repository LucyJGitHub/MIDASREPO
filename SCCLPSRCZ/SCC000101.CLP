/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Change of subsystem')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC000101 - Change of Zone Set Up and Checks                */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD027054           Date 04Jun15              */
/*                      MD031644           Date 08Jan15              */
/*                      AR1000912          Date 13Nov14              */
/*                      CGL155             Date 21Mar14              */
/*                      AR687098           Date 04Sep12              */
/*                      BUG27831A          Date 03Aug10              */
/*                      CSD083             Date 27May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CAP205             Date 15Feb10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      245369             Date 14May07              */
/*                      247248             Date 24Apr07              */
/*                      243665A            Date 08Nov06              */
/*                      243665             Date 08Nov06              */
/*                      249977             Date 10Sep07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      238655             Date 08Nov06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG8037            Date 18Jul06              */
/*                      BUG9619            Date 01Feb06              */
/*                      BG5616             Date 11Feb05              */
/*                      BG1726 (Reopen)    Date 29Jul04              */
/*                      CLE024             Date 17May04              */
/*                      CGL014             Date 17May04              */
/*                      TDA035             Date 02Apr04              */
/*                      226108  BUG483     Date 29Mar04              */
/*                      CSC023             Date 02Feb04              */
/*                      CAAA02  *CREATE    Date 17Oct03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD027054 - Impossible to work on HATS during secondary COB  */
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
/*       CGL155 - Forecast Group Limits                              */
/*                Added hooks: CGL155_001 TO CGL155_003              */
/*       AR687098 - Switching off unnecessary job logging of SCC0204.*/
/*                  Change JOBD from MBATCH to MBATCHIC when SCC0204 */
/*                  is submitted. (Child: AR687099)                  */
/*       BUG27831A - Forward Account Transfer Processing             */
/*       CSD083 - Watch List Compliance Upgrade                      */
/*       CAP205 - Teller Related APIs - Account Balance Check        */
/*       245369 - Program should not call retail teller login pgm    */
/*                if retail teller (CRT001) is not switched on       */
/*       247248 - Problem when web-phased menus are accessed by a    */
/*                user and COB is running in the system.  Applied    */
/*                part of core fix 243665.  Also added additional    */
/*                codes to bypass the rest of the processing when    */
/*                system is in Close of Business.                    */
/*       243665A - Rationalisation - this pgm should just check/set  */
/*               up the job environment.  SCC000100 should process   */
/*               the requested menu option, or CoB if appropriate.   */
/*       243665 - &JOB is not initialised; improve error handling    */
/*                and sign off if any error to prevent problems in   */
/*                calling programs.                                  */
/*       249977 - RTS signon should only happen for RTS menu items   */
/*       238655 - MSTATUS not released when RCLACTGRP ended in error.*/
/*       BUG8037 - CAP002 is incorrectly in the conditioning for     */
/*                 CSC001 so the API jobs do not start automatically.*/
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BG5616 - Remove (duplicated) STRCMTCTL calls                */
/*       BG1726 - Added parameter to GLC005000 call (reopen).        */
/*       CLE024 - Addition of CALCMGR processing for CLE024.         */
/*       CGL014 - Addition of CALCMGR processing for CGL014.         */
/*       TDA035 - RTS Signon changes for MidasPlus.                  */
/*                Perform Teller Sign on.                            */
/*       226108 - Unable to switch zone because error when ENDCMTCTL */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAAA02 - Sign On enhancement                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ZONECHG)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&ZONECHG) TYPE(*CHAR) LEN(1)
 
/*/COPY SDCPYSRC,SDSVALDCL                                           */
 
/** Program Call Return Codes               **/
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&RETCDE) TYPE(*CHAR) LEN(10) VALUE(' ')
 
/** Define variables for AOUSERR0 */
 
             DCL        VAR(&JOBUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)
             DCL        VAR(&COBAUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TELLER) TYPE(*CHAR) LEN(3) VALUE('   ')                      /*245369*/
 
/** Define variables for AOSARDR0 */
 
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CAP002) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CGL014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL014*/
             DCL        VAR(&CLE024) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE024*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                     /*AR1000912*/
             DCL        VAR(&CFT158) TYPE(*CHAR) LEN(1) VALUE('N') /*MD031644*/
             DCL        VAR(&CRT001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*245369*/
             DCL        VAR(&CAP205) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAP205*/
             DCL        VAR(&CSD083) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD083*/
/*/COPY OFCPYSRCZ,CGL155_001                                         */                   /*CGL155*/
 
/** Define work variables for CSC011 */
 
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&S3STRT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&S4STRT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
/** Define variables for AOWMNUR0 */
 
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFMT) TYPE(*CHAR) LEN(400)
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ROUTE) TYPE(*CHAR) LEN(1)
 
/** Define and initialise transfer job indicator */
 
             DCL        VAR(&TFRJOB) TYPE(*CHAR) LEN(1) VALUE('Y')
 
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CBSTS)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SPECMSG) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TSTATUS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSTI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CMTTXT) TYPE(*CHAR) LEN(460)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BLNK338) TYPE(*CHAR) LEN(338) +
                        VALUE(' ')
 
             DCL        VAR(&MMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SOVR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&APIBKJOB) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATMSG) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1)
             DCL        VAR(&FRSTAT) TYPE(*CHAR) LEN(1)                                /*BUG27831A*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                 /*243665*/
/*******                  CMDLBL(ERROR))                                                 /*243665*/
 
             ENDCMTCTL
/*********** MONMSG     MSGID(CPF8350)     */                                            /*226108*/
             MONMSG     MSGID(CPF8350 CPF8355)                                           /*226108*/
 
/* Submit Jobs to check that the subsystems for the zone are running and if not */
/* start them                                                                   */
 
/* Check whether the Midas system is locked */
 
             CALL       PGM(AOSVALR0) PARM(&RTCD 'SystemLockStatus' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)
 
             IF         COND(%SST(&SVAL1 1 8) *EQ '*UPGRADE') THEN(DO)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
                RTVMSG     MSGID(SCM0185) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                RTVMSG     MSGID(SCM0037) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CALL       PGM(SCC0010) PARM('SCC0001001' 'ENTER' ' ')
                MONMSG     MSGID(CPF0000 MCH0000)
 
                SIGNOFF
 
             ENDDO
 
/* Determine whether the user is a COB user */
 
             RTVJOBA    JOB(&WRKSTN) USER(&JOBUSR)
             CHGVAR     VAR(&JOB) VALUE(&WRKSTN)                                          /*243665*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*KEY')
 
             CALL       PGM(AOUSERR0) PARM(&RTCD &OPTN &JOBUSR +
                          &DSSDY)
             IF         COND(&RTCD *EQ '      ') THEN(DO)
               CHGVAR     VAR(&COBAUT) VALUE(%SST(&DSSDY 225 1))
               CHGVAR     VAR(&TELLER) VALUE(%SST(&DSSDY 236 3))                          /*245369*/
             ENDDO
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FREE')
 
             CALL       PGM(AOUSERR0) PARM(&RTCD &OPTN &JOBUSR +
                          &DSSDY)
 
/** Check if 24x7 Midas Availability Feature is on */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&SARD) VALUE('CSC011')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CALL      PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
 
/** If error occured in AOSARDR0, perform abnormal termination */
 
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSC011) VALUE('Y')
             ENDDO
 
/*  Check if the API Switchable Feature is on                         */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&SARD) VALUE('CAP002')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CALL      PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP002) VALUE('Y'))
/*********                                                                               /*243665A*/
/**Check*to see if CoB Enhancement feature is ON */                                      /*243665A*/
/*********                                                                               /*243665A*/
/*********   CHGVAR     VAR(&RTCD) VALUE('       ')                                      /*243665A*/
/*********   CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                      /*243665A*/
/*********   CHGVAR     VAR(&SARD) VALUE('S01420')                                       /*243665A*/
/*********   CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                    /*243665A*/
/*********   IF         COND(&RTCD *EQ '      ') THEN(DO)                                /*243665A*/
/*********      RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                            /*243665A*/
/*********      IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ +                       /*243665A*/
/*********                   'X')) THEN(GOTO CMDLBL(NOTCOB))                             /*243665A*/
/*********      TFRCTL     PGM(CBRUN)                                                    /*243665A*/
/*********   ENDDO                                                                       /*243665A*/
/*********                                                                               /*243665A*/
/**NOTCOB:                                                                               /*243665A*/
                RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                             /*247248*/
/**********     IF         COND(&MPHAS *NE 'A') THEN(GOTO CMDLBL(END))*/         /*247248 MD027054*/
                IF         COND(&MPHAS *EQ 'C') THEN(GOTO CMDLBL(END))                  /*MD027054*/
                                                                                          /*CLE024*/
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
                                                                                          /*CAP205*/
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
/*/COPY OFCPYSRCZ,CGL155_002                                         */                   /*CGL155*/
/** Check if the Collaterals Processing Feature is on */                                  /*CGL014*/
                                                                                          /*CGL014*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGL014*/
             CHGVAR     VAR(&SARD) VALUE('CGL014')                                        /*CGL014*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL014*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                          &SCSARD)                                                        /*CGL014*/
                                                                                         /*243665A*/
/** Free SCSARDPD   */                                                                   /*243665A*/
                                                                                         /*243665A*/
             CHGVAR     VAR(&OPTN) VALUE('*FREE')                                        /*243665A*/
             CALL       PGM(AOSARDR0) PARM(' ' &OPTN ' ' ' ')                            /*243665A*/
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
/* Start the calculation manager jobs if required */                                      /*CGL014*/
                                                                                          /*CGL014*/
/**********  IF         COND(&CGL014 *EQ 'Y') THEN(DO) */                      /*CGL014*/ /*CLE024*/
/**********  IF         COND((&CLE024 *EQ 'Y') *OR (&CGL014 *EQ +
                          'Y')) THEN(DO)              */                       /*CLE024 *AR1000912*/
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
             IF         COND(&CAP205 *EQ 'Y') THEN(DO)                                    /*CAP205*/
             CALL       PGM(REC001500)                                                    /*CAP205*/
             RTVDTAARA  DTAARA(GLFRATMSTS (1 1)) RTNVAR(&FRSTAT)                       /*BUG27831A*/
             IF         COND(&FRSTAT *EQ ' ') THEN(CALL PGM(GLC004607))                /*BUG27831A*/
             ENDDO                                                                        /*CAP205*/
                                                                                          /*CAP205*/
             IF         COND(&CFT158 *EQ 'Y') THEN(DO) /*MD031644*/
                CALL       PGM(FTC000987) PARM('START') /*MD031644*/
             ENDDO      /*MD031644*/
                                                                                          /*CGL014*/
/*/COPY OFCPYSRCZ,CGL155_003                                         */                   /*CGL155*/
/** If switchable CSC011 is installed, determine if job needs */
/** to be routed to support system.                           */
 
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)
                RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)
                RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)
                RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&SOVR)
                RTVDTAARA  DTAARA(SC24X7 (11 1)) RTNVAR(&MMODE)
                RTVDTAARA  DTAARA(SCSUPP (1 1)) RTNVAR(&S3STRT)
                RTVDTAARA  DTAARA(SCREOP (1 1)) RTNVAR(&S4STRT)
 
/** When user is in main system and transition is not yet started, */
/** Data Replication should be processed.                          */
 
             IF         COND((&MAIN *EQ &CURR) *AND (&SOVR *EQ +
                          ' ') *AND (&S3STRT *EQ ' ') *AND (&S4STRT *EQ ' ')) +
                          THEN(CALL PGM(SCC000600))
 
/** Verify if the reroute field for this user is set to 'Y' in       */
/** SFWMNUPD file. If 'Y', it means that he is the operator and he   */
/** can sign on to the main system even if switchover mode has       */
/** started.                                                         */
 
                CHGVAR     VAR(&RTCD) VALUE('       ')
                CHGVAR     VAR(&OPTN) VALUE('*KEY   ')
                CHGVAR     VAR(&KEY) VALUE(&WRKSTN)
                CALL       PGM(AOWMNUR0) PARM(&RTCD &OPTN &KEY &WFMT)
                                                                                         /*243665A*/
/** Free SFWMNUPD   */                                                                   /*243665A*/
                                                                                         /*243665A*/
             CHGVAR     VAR(&OPTN) VALUE('*FREE')                                        /*243665A*/
             CALL       PGM(AOWMNUR0) PARM(' ' &OPTN ' ' ' ')                            /*243665A*/
 
/** If error occured in AOWMNUR0, perform abnormal termination */
 
                IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)
                   SNDPGMMSG  MSG('Program error in AOWMNUR0') +
                              TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
                IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&USER) VALUE(%SST(&WFMT 11 10))
                CHGVAR     VAR(&ROUTE) VALUE(%SST(&WFMT 258 1))
                ENDDO
 
/** If current user is same as retrieved user and reroute field is   */
/** 'Y', do not perform transfer job since operator has access to    */
/** main system even if switchover has started.                      */
 
                IF  COND((&RTCD *EQ '       ') *AND (&JOBUSR *EQ +
                        &USER) *AND (&ROUTE *EQ 'Y')) THEN(CHGVAR +
                        VAR(&TFRJOB) VALUE('N'))
 
/** If current user is flagged as a COB User on MUSER then do not    */
/** perform transfer job since operator has access to main system    */
/** even if switchover has started.                                  */
 
                IF         COND(&COBAUT *EQ 'Y') THEN(CHGVAR +
                             VAR(&TFRJOB) VALUE('N'))
 
/** If switchover mode is 'S' and current system is the main  */
/** system, then transfer this job to the support system.     */
 
                IF        COND((&MODE *EQ 'S') *AND (&CURR *NE &SUPP) +
                          *AND (&TFRJOB *EQ 'Y')) THEN(DO)
 
                   CALL       PGM(SCC004316) PARM(&SUPP)
 
/** If error occured in SCC004316, perform abnormal termination */
 
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                      SNDPGMMSG  MSG('Program error occurred in +
                                 SCC004316') TOMSGQ(MOPERQ)
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
 
                ENDDO
 
/***If*the*SF*is*on,*start*API*background*functions********************/ /*BUG8037*/
 
/******************IF        COND(&CAP002 *EQ 'Y') THEN(DO)           */ /*BUG8037*/
 
/** If 24x7 Midas availability is on, API background jobs in        */
/** the support system should not be started unless the support sys */
/** is ready to accept data from Meridian (i.e. API pgms in the     */
/** support sys are in maintenance mode already.)                   */
 
                         IF      COND(((&CURR *EQ &SUPP) *AND (&MMODE *EQ +
                                 'E')) *OR ((&SOVR *EQ 'S')  *AND (&CURR +
                                 *EQ &MAIN))) +
                                 THEN(CHGVAR VAR(&APIBKJOB) VALUE('N'))
                      ENDDO
 
/*  If the SF is on, start API background functions                   */ /*BUG8037*/
 
                   IF        COND(&CAP002 *EQ 'Y') THEN(DO)              /*BUG8037*/
 
                      IF         COND(&APIBKJOB *EQ 'Y') THEN(DO)
/************            SBMJOB     CMD(CALL PGM(MLC0000) PARM('APC0410' &PARM1 +         /*CSC023*/
/************                         &PARM2 &PARM3 &PARM4 &PARM5)) +                     /*CSC023*/
/************                         JOB(APSTRDBU) JOBD(MBATCH) +                        /*CSC023*/
/************                         JOBQ(INTERFACE) USER(*JOBD) LOG(4 0 +               /*CSC023*/
/************                         *SECLVL) LOGCLPGM(*YES)                             /*CSC023*/
                         SBMJOB     CMD(CALL PGM(MLC0000) PARM('APC0410' &PARM1 +
                                      &PARM2 &PARM3 &PARM4 &PARM5)) +
                                      JOB(APSTRDBU) JOBD(MBATCH) +
                                      JOBQ(INTERFACE) USER(*JOBD) LOG(4 0 +
                                      *SECLVL) LOGCLPGM(*YES) OUTQ(*JOBD)                 /*CSC023*/
                      ENDDO
                   ENDDO
 
/* Retrieve the multibranch indicator */
 
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
 
/* If multibranching is on then create and initialise SPF data areas  */
 
             IF         COND(&MBIN *EQ 'Y') THEN(CALL PGM(SFC0400))
 
/** Check if Retail Teller feature is on */                                               /*245369*/
                                                                                          /*245369*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*245369*/
             CHGVAR     VAR(&SARD) VALUE('CRT001')                                        /*245369*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*245369*/
             CALL      PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                      /*245369*/
                                                                                          /*245369*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*245369*/
                                                                                          /*245369*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*245369*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*245369*/
                GOTO       CMDLBL(ABNOR)                                                  /*245369*/
             ENDDO                                                                        /*245369*/
                                                                                          /*245369*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*245369*/
                CHGVAR     VAR(&CRT001) VALUE('Y')                                        /*245369*/
             ENDDO                                                                        /*245369*/
                                                                                          /*245369*/
/** Signon to RTS using the Teller-ID from MUSERDD */                                     /*TDA035*/
                                                                                          /*TDA035*/
/*********** CALL       PGM(REC004132) PARM(&RTCD 'Y' 'N' 'N')              */ /*TDA035*/ /*249977*/
/*********** CHGVAR     VAR(&RTCD) VALUE('       ')                         */ /*TDA035*/ /*249977*/
                                                                                          /*TDA035*/
/* Alter message queue status */
 
             CALL       PGM(SCC2451)
 
/* Reset message queue MSPECIAL */
 
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
 
/* If MSPECIAL is allocated to another job then send message and end */
 
             MONMSG     MSGID(CPF2451) EXEC(DO)
 
/***Free*the SCSARDPD file                                        */                     /*243665A*/
/*********      CHGVAR     VAR(&OPTN) VALUE('*FREE')                                     /*243665A*/
/*********                                                                               /*243665A*/
/*********      CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                 /*243665A*/
 
/* Call SCC0010 to inform user that the job cannot be run now */
 
                RTVMSG     MSGID(SCM0026) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
SNDMSG:
                CHGDTAARA  DTAARA(MIDASMSG (10 1)) VALUE('1')
                CALL       PGM(SCC0010) PARM('SCC0102' 'ENTER' ' ')
 
                SIGNOFF    LOG(*LIST)
             ENDDO
 
/* If APIs SF is on, create the API DUMP information data area.    */
 
             IF        COND(&CAP002 *EQ 'Y') THEN(DO)
                CALL       PGM(APCCRTQTO) PARM(&RETCDE)
             ENDDO
 
/* Reset message queue MSTATUS */
 
             CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
 
/* Check if this is a restart after a machine failure */
 
/* If DTAARA/CBSTAT position 45 is 'Y' and 'EOD' is on       */
/* MSGQ/MSPECIAL then there must have been a machine failure */
 
             RTVDTAARA  DTAARA(CBSTAT (45 1)) RTNVAR(&CBSTS)
 
             IF         COND(&CBSTS *NE 'Y') THEN(GOTO CMDLBL(RCVMSG))
             RCVMSG     MSGQ(MSPECIAL) RMV(*NO) MSG(&SPECMSG)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
 
             IF         COND(&SPECMSG *EQ 'EOD') THEN(DO)
                RCVMSG     MSGQ(MSPECIAL) RMV(*YES)
                CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             ENDDO
 
             DLCOBJ     OBJ((CBCHK *DTAARA *EXCL))
 
/* Examine the contents of the message queue MSPECIAL */
 
 RCVMSG:
             RCVMSG     MSGQ(MSPECIAL) RMV(*NO) MSG(&SPECMSG)
 
/* This code assumes that the message is blank */
 
             IF         COND(&SPECMSG *EQ '      ') THEN(DO)
 
                SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/* If the phase is 'A' or 'X' then try to allocate TSTATUS *SHRRD */
/* to see if another job is running one of the recovery functions */
 
                RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
 
                IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ +
                             'X')) THEN(DO)
                   ALCOBJ     OBJ((TSTATUS *DTAARA *SHRRD)) WAIT(10)
                   MONMSG     MSGID(CPF1002) EXEC(DO)
                      SNDBRKMSG  MSG('Job cannot be run at this +
                          time') TOMSGQ(&JOB)
                      MONMSG     MSGID(CPF0000)                                           /*243665*/
                      SIGNOFF    LOG(*LIST)
                   ENDDO
                ENDDO
 
                RTVDTAARA  DTAARA(TSTATUS) RTNVAR(&TSTATUS)
 
                IF         COND(&TSTATUS *EQ 'RECOVERY') THEN(DO)
                   SNDBRKMSG  MSG('Recovery must be run before +
                                normal input can continue') +
                                TOMSGQ(&JOB)
/*************     STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +                        /*BG5616*/
/*************            CMTSCOPE(*JOB)                                                  /*BG5616*/
 
/* Start commitment control */
 
                   CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
                   CALL       PGM(RRMENUN)
                ENDDO
 
                IF         COND((&TSTATUS *NE 'DRSRECOV') *AND +
                             (&TSTATUS *NE 'RECOVERY')) THEN(DO)
 
 
                   CHGDTAARA  DTAARA(TSTATUS) VALUE('        ')
                   RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
 
/* If the phase is Input Cycle */
 
/**********        IF         COND(&MPHAS *EQ 'A') THEN(DO)           */                /*MD027054*/
                   IF         COND(&MPHAS *EQ 'A' *OR &MPHAS = 'G') +
                              THEN(DO)                                                  /*MD027054*/
/*************       STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +                      /*BG5616*/
/*************              CMTSCOPE(*JOB)                                                /*BG5616*/
/**********          SNDJRNE    JRN(ICJRN) TYPE('BJ') */                                 /*BUG9619*/
                     SNDJRNE    JRN(ICJRN) TYPE('BJ') FORCE(*YES)                        /*BUG9619*/
 
/* Start commitment control */
 
                     CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
                     CHGVAR     VAR(&WSID) VALUE(&JOB)
                     CHGVAR     VAR(&WSTI) VALUE(&JOB)
                     RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
                     CHGVAR     VAR(&CMTTXT) VALUE('       +
                                   MIDAS   ' *CAT &WSID *CAT +
                                   &TIME *CAT ' ' *CAT &USRID *CAT +
                                   '               MIDAS Initial +
                                   Program - No committed +
                                   transactions for this job' +
                                   *CAT &BLNK338 *CAT &WSTI)
                     OPNDBF     FILE(SDBANKPD) OPTION(*INP) +
                                  COMMIT(*YES)
                     MONMSG     MSGID(CPF4125) EXEC(DO)
 
/* Call SCC0010 to inform user that an error has occurred */
 
                     RTVMSG     MSGID(SCM0076) MSGF(MIDASMSG) +
                                  MSG(&MESSAGE)
                     CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                                  VALUE(&MESSAGE)
                     RTVMSG     MSGID(SCM0077) MSGF(MIDASMSG) +
                                  MSG(&MESSAGE)
                     CHGDTAARA  DTAARA(MIDASMSG (351 50)) +
                                  VALUE(&MESSAGE)
                     RTVMSG     MSGID(SCM0078) MSGF(MIDASMSG) +
                                  MSG(&MESSAGE)
                     CHGDTAARA  DTAARA(MIDASMSG (451 50)) +
                                  VALUE(&MESSAGE)
                     CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')
                     CALL       PGM(SCC0010) PARM('SCC0102' +
                                  'ENTER' ' ')
                     GOTO       CMDLBL(ABNOR)
                   ENDDO
 
                   COMMIT     CMTID(&CMTTXT)
 
                   CLOF       OPNID(SDBANKPD)
 
/************SBMJOB     JOB(SCC0204) JOBD(MBATCH) JOBQ(INTERFACE) +                       /*CSC023*/
/************             PRTDEV(*CURRENT) USER(*JOBD) +                                  /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SCC0204')                            /*CSC023*/
 
/**********  SBMJOB     JOB(SCC0204) JOBD(MBATCH) JOBQ(INTERFACE) +
                          PRTDEV(*CURRENT) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SCC0204') OUTQ(*JOBD) */    /*CSC023 AR687098*/
             SBMJOB     JOB(SCC0204) JOBD(MBATCHIC) JOBQ(INTERFACE) +
                          PRTDEV(*CURRENT) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL SCC0204') OUTQ(*JOBD)                            /*AR687098*/
 
                  ENDDO
 
/* Add 'EOD' to MSGQ/MSPECIAL, reset MSTATUS and restart COB */
/* by calling CBRUN                                          */
 
/*********      ELSE       CMD(IF COND((&MPHAS *EQ 'B') *OR (&MPHAS *EQ +                /*243665A*/
/*********                   'C') *OR (&MPHAS *EQ 'D') *OR (&MPHAS *EQ +                 /*243665A*/
/*********                   'E') *OR (&MPHAS *EQ 'F')) THEN(DO))                        /*243665A*/
                ELSE       CMD(IF COND((&MPHAS *NE 'A') *AND (&MPHAS +
                          *NE 'X')) THEN(DO))                                            /*243665A*/
                   RRTJOB     RTGDTA(EODRST)
                ENDDO
 
                ELSE       CMD(DO)
                  SNDBRKMSG  MSG('Job cannot be run at this time') +
                               TOMSGQ(&JOB)
                  MONMSG     MSGID(CPF0000)                                               /*243665*/
                  SIGNOFF    LOG(*LIST)
                ENDDO
             ENDDO
 
/* Processing on return from application called */
 
             ALCOBJ     OBJ((MSTATUS *MSGQ *EXCL)) WAIT(9999)
 
             CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
 
             RCVMSG     MSGQ(MSTATUS) RMV(*YES)
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(MCH3402) EXEC(DO)                                           /*238655*/
                DLCOBJ     OBJ((MSTATUS *MSGQ *EXCL))                                     /*238655*/
                GOTO       CMDLBL(ERROR)                                                  /*238655*/
             ENDDO                                                                        /*238655*/
 
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
 
/* If the system is in Input Cycle */
 
             IF         COND(&MPHAS *EQ 'A') THEN(DO)
 
/* Check to see if both queues are empty                          */
/* Allocation MSPECIAL during phase A processing to prevent other */
/* users signing on                                               */
 
                ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
 
                CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
 
                RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STATMSG)
 
                RCVMSG     MSGQ(MSPECIAL) RMV(*NO) MSG(&SPECMSG)
 
                IF         COND((&STATMSG *EQ '     ') *AND +
                             (&SPECMSG *EQ '      ')) THEN(DO)
                   RCLRSC
                      CHGDTAARA  DTAARA(TSTATUS) VALUE('NORMAL  ')
                      DLCOBJ     OBJ((TSTATUS *DTAARA *SHRRD))
                   ENDDO
 
                   DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
                ENDDO
 
                DLCOBJ     OBJ((MSTATUS *MSGQ *EXCL))
 
             ENDDO
 
/**If*the*system is in close of business */                                              /*243665A*/
/*********                                                                               /*243665A*/
/*********   ELSE       CMD(IF COND(&SPECMSG *EQ 'EOD   ') THEN(DO))                     /*243665A*/
/*********      DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))                                   /*243665A*/
/*********      CALL       PGM(CBC0015B)                                                 /*243665A*/
/*********      SIGNOFF    LOG(*NOLIST)                                                  /*243665A*/
/*********   ENDDO                                                                       /*243665A*/
/*********                                                                               /*243665A*/
/**If*the*system is not in close of business */                                          /*243665A*/
/*********                                                                               /*243665A*/
/*********   ELSE       CMD(DO)                                                          /*243665A*/
/*********      DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))                                   /*243665A*/
/*********      SNDBRKMSG  MSG('Job cannot be run at this time') +                       /*243665A*/
/*********                   TOMSGQ(&JOB)                                                /*243665A*/
/*********      SIGNOFF    LOG(*LIST)                                                    /*243665A*/
/*********   ENDDO                                                                       /*243665A*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSG('Entry to Midas system processing +
                          terminated abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SCM0084) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RTVMSG     MSGID(SCM0022) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SCC0010) PARM('SCC0102' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ERROR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             ENDPGM
