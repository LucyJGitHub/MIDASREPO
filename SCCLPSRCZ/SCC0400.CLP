/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Input cycle termination')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0400 - System Control Start                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD046737           Date 15Aug17              */
/*                      MD033971           Date 05Aug15              */
/*                      MD031262           Date 13Feb15              */
/*                      AR1092065A         Date 15Mar13              */
/*                      AR1092065          Date 28Feb13              */
/*                      AR1089839          Date 19Feb13              */
/*                      CCB023             Date 06Aug12              */
/*                      CCB020             Date 06Aug12              */
/*                      AR1005269          Date 30Jul12              */
/*                      AR787620           Date 10Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGL030             Date 18Dec09              */
/*                      CRE401             Date 26Nov09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CCB014             Date 25Apr05              */
/*                      CSD028             Date 22Aug05              */
/*                      CSC020             Date 31Mar04              */
/*                      CPK017             Date 28Oct03              */
/*                      CSD015             Date 03Mar03              */
/*                      CPK016             Date 04Jun03              */
/*                      CSD012             Date 15Oct02              */
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 02Jan02              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CSD006             Date 01Jun01              */
/*                      CAP057             Date 23May01              */
/*                      CAP038             Date 23May01              */
/*                      192605             Date 30Apr01              */
/*                      CAP042             Date 08Jan01              */
/*                      CAP140             Date 17Oct00              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP137             Date 07Feb00              */
/*                      CAP136             Date 15Nov99              */
/*                      180491             Date 20Jun00              */
/*                      CDE001             Date 26May00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP032             Date 26Apr99              */
/*                      CAP033             Date 26Apr99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 18Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      152046             Date 07Jan99              */
/*                      CFT003             Date 18Mar99              */
/*                      CAP004             Date 29Oct98              */
/*                      139764             DATE 29Jul98              */
/*                      136442             Date 04Jun98              */
/*                      S01408             Date 01NOV96              */
/*                      S01408             Date 04JUL96              */
/*                      S01408             Date 26JUN96              */
/*                      S01408             Date 07AUG95              */
/*                      CCB001             DATE 08MAR95              */
/*                      081938             DATE 16JAN95              */
/*                      S01522             DATE 06DEC94              */
/*                      S01496             DATE 10JAN95              */
/*                      S01491             DATE 01OCT94              */
/*                      S01495 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD046737 - User gets kicked back to command line when       */
/*                  starting COB.                                    */
/*       MD033971 - When COB is autoscheduled, unauthorized          */
/*                  transactions are not checked.                    */
/*       MD031262 - CCB014 Autoschedule 'Y'.                         */
/*                - If CCB014 feature is switched ON and it is a     */
/*                  autoscheduled COB, then CB001001 should not be   */
/*                  called.                                          */
/*                - Midas escape error message during batch COB -    */
/*                  Unauthorized Payments.                           */
/*       AR1092065A - COB proceeded and continue running bypassing   */
/*                    the initial error regarding unauthorized       */
/*                    transactions. Also amended to correct message  */
/*                    send when error occurs on FT0809               */
/*       AR1092065 - COB proceeded and continue running bypassing the*/
/*                   initial error regarding unauthorized transaction*/
/*       AR1089839 - COBOP and 2.1 source clashes                    */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       AR1005269 - Global trigger programs not operating under     */
/*                commitment control - ENDCMTCTL fails.              */
/*                SCTRIGJ0 left open, causes SCKOBJLCB to fail.      */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,SCH00004                                */
/*       CGL030 - Sundry Postings                                    */
/*       CRE401 - 4-Eyes Checking Gaps - Sweeps                      */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*       CSD028 - KYC (Standing Data Authorisations)                 */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CPK017 - Midas Plus packaging.                              */
/*                - Comment out the remove of msg from MSTATUS.      */
/*       CSD015 - Midas Compliance Watch - Watch List Checking       */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CSD012 - Standing Data Authorisation                        */
/*       CPK014 - Release 4 Alphasite:                               */
/*                - Re-arrange DLYJOB commands to allow COB to       */
/*                  initiate faster.                                 */
/*                - Remove closedown processing which is replaced by */
/*                  separate COB components.                         */
/*       CSD006 - Market Data Feeds                                  */
/*       CAP057 - Conversion of SPOT Rates into Modular APIs         */
/*       CAP038 - Conversion of SD inputs into modular structure     */
/*       192605 - Midas-Plato Real time - trigger job needed to be   */
/*                ended before FFC05 because of file locking.        */
/*       CAP042 - Conversion of Internal Funding Deal inputs into    */
/*                modular structure to use as APIs.                  */
/*       CAP140 - Conversion of SE Security Diary Event inputs into  */
/*                modular structure to use as APIs.                  */
/*                modular structure to use as APIs.                  */
/*       CDL008 - Continuous Linked Settlement                       */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*       CAP136 - Conversion of FT Incoming Payment inputs into      */
/*                modular structure to use as APIs.                  */
/*       180491 - Add mode parameter to DEC0040 call.                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                Call DEC0040 to end projections drip feed job      */
/*       CAP032 - Conversion of Journal Batch Entry inputs into      */
/*                modular structure to use as APIs.                  */
/*       CAP033 - Conversion of PM inputs into modular structure to  */
/*                use as APIs.                                       */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       152046 - Include call to PGM/EU0650, which in turn calls    */
/*                PGM/SD0028, to ensure that the Spot/Forward Rates  */
/*                for all EMU 'In' currencies are updated before     */
/*                Close of Business processing begins.               */
/*       CFT003 - Straight Through Processing.                       */
/*       CAP004 - End API database updaters.                         */
/*       139764 - The call to AOSARDR0 for CAP002 should specify     */
/*                the option parameter as *VERIFY.                   */
/*       136442 - Shutdown API server at start of I.C.I.             */
/*       S01408 - Addition of Core Hook SCC0400003                   */
/*       S01408 - Core hook SCC0400002 added.                        */
/*       S01408 - Core hook SCC0400001 added.                        */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCC0400INT                                       */
/*                - SCC0400MPS                                       */
/*                - SCC0400MPE                                       */
/*                - SCC0400ERR                                       */
/*                - SCC0400END                                       */
/*       CCB001 - COB Enhancement (Batch Processing)                 */
/*                This program has been split into COB components.   */
/*                The components are:                                */
/*                - ABC8040  (new program)                           */
/*                - ACC0011  (new program)                           */
/*                - CFC0181  (new program)                           */
/*                - CGC5202  (existing program)                      */
/*                - CGC5212  (existing program)                      */
/*                - CGC5272  (existing program)                      */
/*                - DLC0400  (new program)                           */
/*                - EDC0110  (new program)                           */
/*                - EMC0102  (new program)                           */
/*                - FXC8040  (new program)                           */
/*                - FTC0690  (new program)                           */
/*                - GLC0590  (new program)                           */
/*                - GLC24    (existing program)                      */
/*                - HFC0252  (new program)                           */
/*                - LEC0004  (new program)                           */
/*                - MEC0841  (new program)                           */
/*                - MEC1028  (new program)                           */
/*                - MEC1306  (new program)                           */
/*                - MMC8040  (new program)                           */
/*                - MSC0501  (new program)                           */
/*                - MSC4000  (new program)                           */
/*                - MTC4012  (new program)                           */
/*                - RCC2090  (new program)                           */
/*                - SCC0501  (new program)                           */
/*                - SCC0502  (new program)                           */
/*                - SEC05    (existing program)                      */
/*                - SEC6840  (new program)                           */
/*                - TSC8580  (new program)                           */
/*                Some processing has been dropped:                  */
/*                - Syndicated Loans call (CLC04).                   */
/*                - Securities Trading (1) (STC04).                  */
/*              - As this was a large program and 95% of it has      */
/*                been moved to other programs, it has been          */
/*                code-stripped for ease of understanding and        */
/*                maintenance.                                       */
/*       081938 - Call CB0602U *RESET to create correct environment. */
/*       S01522 - User Defined Correspondence.                       */
/*       S01496 - Switchable Feature.                                */
/*                Private Banking Securities Trading Enhancements.   */
/*       S01491 - Autocall.                                          */
/*       S01495 - COB enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC0400INT                                          */
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)                                 /*CCB014*/
             DCL        VAR(&SCHREQ) TYPE(*CHAR) LEN(1)                                   /*CCB014*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE(S)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&STATMSG) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)
             DCL        VAR(&EOCACT) TYPE(*LGL) LEN(1) VALUE('0')
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&FTPARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REOPN) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&NOREPLY) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE(*FIRST)
/************DCL        VAR(&CAP002) TYPE(*CHAR) LEN(1) VALUE('N' )            /*136442*/ /*CPK014*/
/************DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                        /*136442*/ /*CPK014*/
             DCL        VAR(&HCONT) TYPE(*CHAR) LEN(1) VALUE('N')     /*CFT003*/
             DCL        VAR(&UNAUT) TYPE(*CHAR) LEN(1) VALUE('N')     /*CDL008*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*CDL008*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                 /*CDL008*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                  /*CDL008*/
             DCL        VAR(&CSD015) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD015*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CSD015*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSD015*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CSD015*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CSD015*/
/************DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )            /*CDE001*/ /*CPK014*/
/************DCL        VAR(&CPL005) TYPE(*CHAR) LEN(1) VALUE('N' )            /*192605*/ /*CPK014*/
/************DCL        VAR(&MQMSGQ) TYPE(*CHAR) LEN(48)                       /*192605*/ /*CPK014*/
             DCL        VAR(&CLRUNAUTH) TYPE(*CHAR) LEN(1)                                /*CSD012*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&CSD028) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD028*/
             DCL        VAR(&RERTCD) TYPE(*CHAR) LEN(1)                                   /*CRE401*/
             DCL        VAR(&RTNFLD) TYPE(*CHAR) LEN(1)                                   /*CCB023*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)                                    /*CCB023*/
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)                                   /*CCB023*/
             DCL        VAR(&MSGSTAT) TYPE(*CHAR) LEN(5)                                  /*CCB023*/
             DCL        VAR(&LOCK) TYPE(*CHAR) LEN(1) VALUE('N')                          /*CCB023*/
/*/COPY WNCPYSRC,SCH00004                                            */
 
/*/COPY WNCPYSRC,SCC0400011                                          */
             DCLF       FILE(SDAULGPD)                                                    /*CSD012*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC0400MPS                                          */
 
/* Access PF/SDMMODPD to determine which modules are live */
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &MMOD)
 
/*  Database error handling  */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,SCC0400008                                          */
/** Check to see if automatic scheduling is on                     */                     /*CCB014*/
                                                                                          /*CCB014*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&SCHREQ)                              /*CCB014*/
                                                                                          /*CCB014*/
/** Check to see if the delay COB feature is set ON (CCB014)       */                     /*CCB014*/
                                                                                          /*CCB014*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                                      /*CCB014*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                      /*CCB014*/
             CHGVAR     VAR(&SSARD) VALUE('CCB014')                                       /*CCB014*/
                                                                                          /*CCB014*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                                       /*CCB014*/
             IF         COND(&SRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))                                        /*CCB014*/
                                                                                          /*CCB014*/
/** First allocate the message queues                              */                     /*CCB014*/
                                                                                          /*CCB014*/
             IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                          THEN(DO)                                                        /*CCB014*/
               CALL       PGM(CBC0007) PARM('*LIBL' 'MSPECIAL' +
                          '*MSGQ' '180' '3' ' ')                                          /*CCB014*/
             ENDDO                                                                        /*CCB014*/
 
/* First allocate the message queues */
 
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
             SNDPGMMSG  MSG('TERM  ') TOMSGQ(MSPECIAL)
             SNDPGMMSG  MSG('Input cycle termination executing') +
                          TOMSGQ(MRUNQ)
 
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                      */ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS)                                                  */ /*CPK017*/
/*/COPY WNCPYSRC,SCC0400005                                          */
             IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                          THEN(DO)                                                        /*CCB014*/
               CLRMSGQ    MSGQ(MSTATUS)                                                   /*CCB014*/
             CALL       PGM(CBC001002)                                                  /*MD033971*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(EXIT))                                                 /*MD033971*/
             ENDDO                                                                        /*CCB014*/
 
 LOOP1:      CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STATMSG)
 
             IF         COND(&STATMSG *NE '     ') THEN(DO)
 
/* Call SCC0010 to inform user that job cannot be run now */
 
 LOOP2:         CHGVAR     VAR(&RPY) VALUE('Y')
 
                RTVMSG     MSGID(SCM0026) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')
                CALL       PGM(SCC0010) PARM('SCC0400' 'RETRY' &RPY)
 
                IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                             THEN(GOTO CMDLBL(LOOP1))
                IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                             THEN(GOTO CMDLBL(EXIT))
 
             ELSE       CMD(GOTO CMDLBL(LOOP2))
 
             ENDDO
/*/COPY WNCPYSRC,SCC0400012                                          */
 
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
                                                                               /*136442*/ /*CPK014*/
/* Check if MIDASSTS job is active */                                                     /*CCB023*/
/* Lock DTAARA/GOMIDASSTS to indicate that this job is active */                          /*CCB023*/
                                                                                          /*CCB023*/
 CHKTRAN:                                                                                 /*CCB023*/
             ALCOBJ     OBJ((GOMIDASSTS *DTAARA *EXCL)) WAIT(1)                           /*CCB023*/
             MONMSG     MSGID(CPF1002) EXEC(CHGVAR VAR(&LOCK) +
                          VALUE('Y'))                                                     /*CCB023*/
                                                                                          /*CCB023*/
/* Update global dashboard */                                                             /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND(&LOCK = 'N')                                                 /*CCB023*/
             CALL       PGM(GOC000100) PARM('*PHASE')                                     /*CCB023*/
                                                                                          /*CCB023*/
/* If error with GOC000100 then use SCC0010 to display message */                         /*CCB023*/
/* 'Unauthorised transaction update failed' and depending on */                           /*CCB023*/
/* reply loop and go to exit */                                                           /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCB023*/
                        CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                        VALUE('Unauthorised transaction update failed')                   /*CCB023*/
                        CALL       PGM(SCC0010) PARM('SCC0400' 'ENTER' +
                        &RETURN)                                                          /*CCB023*/
                        GOTO       CMDLBL(EXIT)                                           /*CCB023*/
                        ENDDO                                                             /*CCB023*/
                                                                                          /*CCB023*/
/* If job is active or no error from calling  GOC000100 */                                /*CCB023*/
/**Change*MPHAS*to*'C'**/                                                      /*CCB023 AR1092065A*/
/* Checking of message in MSTATUS return with *BLANK  */                                  /*CCB023*/
/* proceed with the call to PGM CB001001. */                                              /*CCB023*/
             CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                         /*CCB023*/
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&MSGSTAT)                              /*CCB023*/
             IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                          THEN(GOTO CMDLBL(EXIT2))                                      /*MD031262*/
                                                                                          /*CCB023*/
             IF         COND(&MSGSTAT *EQ '     ') THEN(DO)                               /*CCB023*/
/**********  CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('C')              */         /*CCB023 AR1092065A*/
             CALL       PGM(CB001001) PARM(&REPLY)                                        /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND(&REPLY *EQ 'R') THEN(DO)                                     /*CCB023*/
                                                                                       /*AR1092065*/
 RETRY:                                                                                /*AR1092065*/
                                                                                       /*AR1092065*/
             CHGVAR     VAR(&REPLY) VALUE(' ')                                            /*CCB023*/
             RTVMSG     MSGID(SCM0049) MSGF(MIDASMSG) MSG(&MESSAGE)                       /*CCB023*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE +
                          *BCAT 'Re-try?')                                                /*CCB023*/
                                                                                          /*CCB023*/
/**********  CALL       PGM(SCC0010) PARM('SCC0400' 'OPTION' +      */                 /*AR1089839*/
/**********               &RTNFLD)                                  */          /*CCB023 AR1089839*/
                                                                                          /*CCB023*/
/**********             ENDDO                                       */          /*CCB023 AR1089839*/
                                                                                          /*CCB023*/
/**********  IF         COND(&RTNFLD *EQ 'N') THEN(GOTO CMDLBL(END))*/          /*CCB023 AR1089839*/
                                                                                          /*CCB023*/
/**Checking*of*message*in*MSTATUS*return*with**BLANK***/                        /*CCB023 AR1089839*/
/**proceed*with*the*call*to*PGM*CB001001.**/                                    /*CCB023 AR1089839*/
/**********  CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                   */          /*CCB023 AR1089839*/
/**********  RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&MSGSTAT)        */          /*CCB023 AR1089839*/
                                                                                          /*CCB023*/
/**********  IF         COND(&MSGSTAT *EQ '     ') THEN(DO)         */          /*CCB023 AR1089839*/
/**********  CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('C')              */          /*CCB023 AR1089839*/
/**********  CALL       PGM(CB001001) PARM(&REPLY)                  */          /*CCB023 AR1089839*/
                                                                                          /*CCB023*/
/**********  IF         COND(&REPLY *EQ 'R') THEN(DO)               */          /*CCB023 AR1089839*/
/**********  CHGVAR     VAR(&REPLY) VALUE(' ')                      */          /*CCB023 AR1089839*/
/**********  RTVMSG     MSGID(SCM0049) MSGF(MIDASMSG) MSG(&MESSAGE) */          /*CCB023 AR1089839*/
/**********  CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE +  */                 /*AR1089839*/
/**********               *BCAT 'Re-try?')                          */          /*CCB023 AR1089839*/
                                                                                          /*CCB023*/
             CALL       PGM(SCC0010) PARM('SCC0400' 'OPTION' +
                          &REPLY)                                                         /*CCB023*/
                                                                                          /*CCB023*/
/**********             ENDDO                                       */          /*CCB023 AR1092065*/
                                                                                          /*CCB023*/
/* If*program*return*with*'Y'*then*change*MPHAS*to*'A'**/                      /*CCB023 AR1092065A*/
/* Loop back to check again if MIDASSTS is active */                                      /*CCB023*/
                                                                                          /*CCB023*/
             IF         COND(&REPLY *EQ 'Y') THEN(DO)                                     /*CCB023*/
/**********             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')   */         /*CCB023 AR1092065A*/
                        GOTO CMDLBL(CHKTRAN)                                              /*CCB023*/
                        ENDDO                                                             /*CCB023*/
                                                                                          /*CCB023*/
/**If*program*return*with*'N',*then*change*MPHAS**/                            /*CCB023 AR1092065A*/
/**back*to*'A'**and*then*go*to*exit**/                                         /*CCB023 AR1092065A*/
                                                                                          /*CCB023*/
             IF         COND(&REPLY *EQ 'N') THEN(DO)                                     /*CCB023*/
/**********             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')   */         /*CCB023 AR1092065A*/
                        GOTO CMDLBL(EXIT)                                                 /*CCB023*/
                        ENDDO                                                             /*CCB023*/
                                                                                       /*AR1092065*/
             ELSE       DO                                                             /*AR1092065*/
                                                                                       /*AR1092065*/
                        GOTO (RETRY)                                                   /*AR1092065*/
                                                                                       /*AR1092065*/
                        ENDDO                                                          /*AR1092065*/
                                                                                          /*CCB023*/
                        ENDDO                                                          /*AR1092065*/
                                                                                       /*AR1092065*/
                        ENDDO                                                             /*CCB023*/
EXIT2:                                                                                  /*MD031262*/
                                                                                        /*MD031262*/
/************************************************************************/                /*CPK014*/
/*                                                                      */                /*CPK014*/
/* The following processing has been replaced by CoB component APC0400. */                /*CPK014*/
/*                                                                      */                /*CPK014*/
/************************************************************************/                /*CPK014*/
 
/***Check*if*the*API*Switchable*Feature*is*on*                                 /*136442*/ /*CPK014*/
/************CHGVAR     VAR(&SSARD) VALUE('CAP002')                            /*136442*/ /*CPK014*/
/************CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                           /*139764*/ /*CPK014*/
/************CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +                         /*CPK014*/
/************                   &SSCSARD)                                      /*136442*/ /*CPK014*/
/************IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +                          /*CPK014*/
/************             VAR(&CAP002) VALUE('Y'))                             /*136442*/ /*CPK014*/
/************                                                                  /*136442*/ /*CPK014*/
/***If*the*SF*is*on....*                                                       /*136442*/ /*CPK014*/
/************IF         COND(&CAP002 *EQ 'Y') THEN(DO)                         /*136442*/ /*CPK014*/
/***...retrieve*the*system*prefix*and*shut*down*the*API*server**/              /*136442*/ /*CPK014*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                   /*136442*/ /*CPK014*/
/************ENDAPISVR  SYSTEM(&PREFIX)                                        /*136442*/ /*CPK014*/
/************                                                                             /*CPK014*/
/* Also end the updaters, and delay to give them time to end.  CAP004*/
/*********** ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +             */
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +            */
/***********          DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) ***/ /*CAP004*/ /*CAP033*/
 
/*********** ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +             */
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +            */
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +           */
/***********              INTR(Y) PFDM(Y)                      /*CAP033 CAP032*/
                                                                      /*CAP033*/
/*********** ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP136*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP136*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP136*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y)   */ /*CAP032 CAP136*/
                                                                      /*CAP032*/
/*********** ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +  */ /*CAP137*/
/***********              NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) + */ /*CAP137*/
/***********              DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +*/ /*CAP137*/
/***********              INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +        */ /*CAP137*/
/***********              IPAY(Y)                           */ /*CAP136 CAP137*/
                                                                      /*CAP136*/
/**********  ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +       */                /*CAP140*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +      */                /*CAP140*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +     */                /*CAP140*/
/**********               INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +             */                /*CAP140*/
/**********               IPAY(Y) SECS(Y)                               */     /*CAP137*/ /*CAP140*/
                                                                                          /*CAP140*/
/**********  ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP057*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP057*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP057*/
/**********               INTR(Y) PFDM(Y) BITH(Y) BITP(Y) +                               /*CAP057*/
/**********               IPAY(Y) SECS(Y) SEDE(Y)                              /*CAP140*/ /*CAP057*/
 
/**********  ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP038*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP038*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP038*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP038*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP038*/
/**********               SECD(Y) SEDE(Y) SPTR(Y)                              /*CAP057*/ /*CAP038*/
 
/**********  ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CAP042*/
/**********               NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CAP042*/
/**********               DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CAP042*/
/**********               INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CAP042*/
/**********               OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CAP042*/
/**********               SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y)                      /*CAP038*/ /*CAP042*/
 
/************ENDAPIDBU  SYSTEM(&PREFIX) LDNI(Y) DEAM(Y) NASP(Y) +                         /*CPK014*/
/************             NASS(Y) FXDL(Y) FRA(Y) SIRS(Y) CIRS(Y) +                        /*CPK014*/
/************             DPMV(Y) TRAD(Y) TRAN(Y) INTC(Y) FWRT(Y) +                       /*CPK014*/
/************             INTR(Y) PRCS(Y) PFDM(Y) BITH(Y) BITP(Y) +                       /*CPK014*/
/************             OPAY(Y) CUSD(Y) AMAD(Y) IPAY(Y) SECS(Y) +                       /*CPK014*/
/************             SECD(Y) SEDE(Y) SPTR(Y) BSRT(Y) FUND(Y)              /*CAP042*/ /*CPK014*/
 
/*/COPY WNCPYSRC,SCC0400015                                          */
/**********  DLYJOB     DLY(30) **/                                            /*CAP004*/ /*CPK014*/
 
/************ENDDO                                                             /*136442*/ /*CPK014*/
                                                                               /*CDE001*/ /*CPK014*/
/************************************************************************/                /*CPK014*/
/*                                                                      */                /*CPK014*/
/* The following processing has been replaced by CoB component DEC0400. */                /*CPK014*/
/*                                                                      */                /*CPK014*/
/************************************************************************/                /*CPK014*/
 
/***Check*if*the*CRM*Limits*Switcahable*Feature*is*On*                         /*CDE001*/ /*CPK014*/
/************CHGVAR     VAR(&SSARD) VALUE('CDE001')                            /*CDE001*/ /*CPK014*/
/************CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                           /*CDE001*/ /*CPK014*/
/************CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +                         /*CPK014*/
/************                   &SSCSARD)                                      /*CDE001*/ /*CPK014*/
/************IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +                          /*CPK014*/
/************             VAR(&CDE001) VALUE('Y'))                             /*CDE001*/ /*CPK014*/
/************                                                                  /*CDE001*/ /*CPK014*/
/***If*the*SF*is*on....*                                                       /*CDE001*/ /*CPK014*/
/************IF         COND(&CDE001 *EQ 'Y') THEN(DO)                         /*CDE001*/ /*CPK014*/
/**********     CALL       PGM(DEC0040) */                                     /*CDE001*/ /*180491*/
/************   CALL       PGM(DEC0040) PARM('C')                              /*180491*/ /*CPK014*/
/**********     DLYJOB     DLY(30) **/                                         /*CDE001*/ /*CPK014*/
/************ENDDO                                                             /*CDE001*/ /*CPK014*/
 
/************IF         COND((&CAP002 *EQ 'Y') +                                          /*CPK014*/
/************            *OR (&CDE001 *EQ 'Y')) THEN(DO)                       /*CPK014*/ /*CPK014*/
/************   DLYJOB     DLY(30)                                             /*CPK014*/ /*CPK014*/
/************ENDDO                                                             /*CPK014*/ /*CPK014*/
/*/COPY WNCPYSRC,SCC0400014                                          */
 
/* Access PF/SCSARDPD to determine if CEU002 is switched on. */     /* 152046 */
 
             CHGVAR     VAR(&SRTCD) VALUE('       ')                /* 152046 */
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                /* 152046 */
             CHGVAR     VAR(&SSARD) VALUE('CEU002')                 /* 152046 */
 
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                 /* 152046 */
 
                IF         COND(&SRTCD *EQ '       ') THEN(DO)      /* 152046 */
 
/* Start commitment control */                                                            /*CPK016*/
/************STRCMTCTL  LCKLVL(*CHG)                           /*152046 CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
                CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                /*CPK016*/
                CRTDTAARA  DTAARA(QTEMP/GP_COMSTST) TYPE(*CHAR) LEN(1)                 /*AR1005269*/
                MONMSG     MSGID(CPF0000)                                              /*AR1005269*/
                CALL       PGM(EU0650) PARM(&RTCD)                  /* 152046 */
             ENDCMTCTL                                              /* 152046 */
             RCLRSC                                                                    /*AR1005269*/
             MONMSG     MSGID(CPF0000)                                                 /*AR1005269*/
 
 
                IF         COND(&RTCD *NE '       ') THEN(GOTO +
                             CMDLBL(ABNOR))                         /* 152046 */
 
             ENDDO      /* CEU002 is switched on */                 /* 152046 */
 
/*/COPY WNCPYSRC,SCC0400010                                          */
/**/                                                                  /*CGL009*/
/*    Check if Fontis IAT/TPP Interface (CGL009) is active            /*CGL009*/
/**/                                                                  /*CGL009*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                  /*CGL009*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                  /*CGL009*/
             CHGVAR     VAR(&SSARD) VALUE('CGL009')                   /*CGL009*/
                                                                      /*CGL009*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                   /*CGL009*/
                                                                      /*CGL009*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*CGL009*/
                                                                      /*CGL009*/
/*   Terminate IAT background task                                    /*CGL009*/
                                                                      /*CGL009*/
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')               /*CGL009*/
             CALL       PGM(GLC2822) PARM('*END   ' '*SYNCH ' 'B' +
                          &RTN_CODE)                                  /*CGL009*/
                                                                      /*CGL009*/
             IF         COND(&RTN_CODE *EQ '*MSGREJ') THEN(DO)        /*CGL009*/
                                                                      /*CGL009*/
             SNDPGMMSG  MSG('Fontis IATs have been converted as +
                          Midas Journal Interface batch(es) during +
                          the shutdown process.  Enter ''Y'' to +
                          reopen to Input Cycle or ''N'' to ignore +
                          these payments') TOMSGQ(MOPERQ)             /*CGL009*/
                                                                      /*CGL009*/
             CHGVAR     VAR(&MSGDTA) VALUE(' ')                       /*CGL009*/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')                     /*CGL009*/
             CHGVAR     VAR(&REOPN) VALUE('Y')                        /*CGL009*/
                                                                      /*CGL009*/
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'FTM2606' +
                          'FTUSRMSG  ' &MSGDTA 'OPTION    ' &REOPN +
                          'GLC2822   ' 'N')                           /*CGL009*/
                                                                      /*CGL009*/
             IF         COND(&REOPN *EQ 'Y') THEN(DO)                 /*CGL009*/
             GOTO       CMDLBL(EXIT)                                  /*CGL009*/
             ENDDO                                                    /*CGL009*/
                                                                      /*CGL009*/
             ENDDO                                                    /*CGL009*/
                                                                      /*CGL009*/
/*   Terminate TPP background task if FT is present                   /*CGL009*/
                                                                      /*CGL009*/
             IF         COND((%SUBSTRING(&MMOD 39 1)) *EQ 'Y') THEN(DO)
                                                                      /*CGL009*/
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')               /*CGL009*/
             CALL       PGM(MEC2001) PARM('*END   ' '*SYNCH ' 'B' +
                          &RTN_CODE)                                  /*CGL009*/
                                                                      /*CGL009*/
             IF         COND(&RTN_CODE *EQ '*MSGREJ') THEN(DO)        /*CGL009*/
                                                                      /*CGL009*/
             SNDPGMMSG  MSG('Fontis TPPs have been +
                          processed/rejected during the shutdown +
                          process.  Enter ''Y'' to reopen to Input +
                          Cycle or ''N'' to ignore these payments') +
                          TOMSGQ(MOPERQ)                              /*CGL009*/
                                                                      /*CGL009*/
             CHGVAR     VAR(&MSGDTA) VALUE(' ')                       /*CGL009*/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')                     /*CGL009*/
             CHGVAR     VAR(&REOPN) VALUE('Y')                        /*CGL009*/
                                                                      /*CGL009*/
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'FTM2605' +
                          'FTUSRMSG  ' &MSGDTA 'OPTION    ' &REOPN +
                          'MEC2001   ' 'N')                           /*CGL009*/
                                                                      /*CGL009*/
             IF         COND(&REOPN *EQ 'Y') THEN(DO)                 /*CGL009*/
             GOTO       CMDLBL(EXIT)                                  /*CGL009*/
             ENDDO                                                    /*CGL009*/
                                                                      /*CGL009*/
             ENDDO                                                    /*CGL009*/
             ENDDO                                                    /*CGL009*/
             ENDDO      /* CGL009 is present */                       /*CGL009*/
                                                                      /*CGL009*/
/* Access PF/SCSARDPD to determine if CSD012 is switched on. */                           /*CSD012*/
                                                                                          /*CSD012*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                                      /*CSD012*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                      /*CSD012*/
             CHGVAR     VAR(&SSARD) VALUE('CSD012')                                       /*CSD012*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                                       /*CSD012*/
                                                                                          /*CSD012*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)                               /*CSD012*/
                                                                                          /*CSD012*/
/* Check if there are any unauthorised Standing Data amendments                           /*CSD012*/
                                                                                          /*CSD028*/
/** Check if CSD028 is installed */                                                       /*CSD028*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSD028*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSD028*/
             CHGVAR     VAR(&PSARD) VALUE('CSD028')                                       /*CSD028*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)                   /*CSD028*/
             IF         COND(&PRTCD *EQ '       ') +
                           THEN(CHGVAR VAR(&CSD028) VALUE('Y'))                           /*CSD028*/
LOOP3:                                                                                    /*CSD028*/
             RCVF                                                                         /*CSD012*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(NOUNAUTH))                        /*CSD012*/
                                                                                          /*CSD012*/
             IF         COND((&ALSTAT = ' ' *AND &CSD028 = 'Y') *OR +
                          &CSD028 = 'N') THEN(DO)                                         /*CSD028*/
                                                                                          /*CCB014*/
             IF         COND((&CCB014 *EQ 'Y') *AND (&SCHREQ *EQ +
                          'Y')) THEN(GOTO CMDLBL(EXIT))                                   /*CCB014*/
/* Inform User of Unauthorised amendments                                                 /*CSD012*/
             RTVMSG     MSGID(SCM0201) MSGF(MIDASMSG) MSG(&MESSAGE)                       /*CSD012*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                         /*CSD012*/
             RTVMSG     MSGID(SCM0202) MSGF(MIDASMSG) MSG(&MESSAGE)                       /*CSD012*/
             CHGDTAARA  DTAARA(MIDASMSG (301 70)) VALUE(&MESSAGE)                         /*CSD012*/
             RTVMSG     MSGID(SCM0203) MSGF(MIDASMSG) MSG(&MESSAGE)                       /*CSD012*/
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)                         /*CSD012*/
             CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')                                 /*CSD012*/
             CALL       PGM(SCC0010) PARM('SCC0400' 'OPTION' +
                          &CLRUNAUTH)                                                     /*CSD012*/
                                                                                          /*CSD012*/
             IF         COND(&CLRUNAUTH *EQ 'N') THEN(DO)                                 /*CSD012*/
                  GOTO       CMDLBL(EXIT)                                                 /*CSD012*/
             ENDDO                                                                        /*CSD012*/
                                                                                          /*CSD028*/
             ENDDO                                                                        /*CSD028*/
                                                                                          /*CSD012*/
             IF         COND(&CSD028 = 'Y') THEN(GOTO CMDLBL(LOOP3))                      /*CSD028*/
                                                                                          /*CSD028*/
             ENDDO                                                                        /*CSD012*/
                                                                                          /*CSD028*/
 NOUNAUTH:                                                                                /*CSD012*/
                                                                                          /*CSD012*/
/*/COPY WNCPYSRC,SCC0400013                                          */
/* Check for unauthorised payments (if FT is present) */
 
             IF         COND((%SUBSTRING(&MMOD 39 1)) *EQ 'Y') THEN(DO)
 
/*/COPY WNCPYSRC,SCH00031                                            */
                CALL       PGM(FT0809) PARM(&HCONT)                                       /*CFT003*/
 
                IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                             CMDLBL(ABNOR))                                               /*CFT003*/
 
                IF         COND(&HCONT *EQ 'Y') THEN(DO)                                  /*CFT003*/
 
                  SNDPGMMSG  MSG('(Payments have been reported they +
                          need an authorisation before processing can +
                          continue''') TOMSGQ(MOPERQ)                                     /*CFT003*/
 
/* Call SCC0010 to send outstanding payments require */
/* authorisation screen                              */
 
/**********       RTVMSG     MSGID(SCM0091) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)                     */        /*AR1092065A CFT003*/
                  RTVMSG     MSGID(SCM0042) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)                                       /*AR1092065*/
                  CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                                   VALUE(&MESSAGE)                                        /*CFT003*/
                  RTVMSG     MSGID(SCM0043) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)                                          /*CFT003*/
                  CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                                   VALUE(&MESSAGE)                                        /*CFT003*/
                  CHGDTAARA  DTAARA(MIDASMSG (15 1)) VALUE('1')
                  CALL       PGM(SCC0010) PARM('SCC0400' 'ENTER' +
                                   &NOREPLY)                                              /*CFT003*/
 
                  GOTO       CMDLBL(EXIT)                                                 /*CFT003*/
                ENDDO                                                                     /*CFT003*/
 
                CALL       PGM(FTC0230) PARM(&FTPARM &RSEQ &RLEV &RENT)
 
                IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                             CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC0400009                                          */
                IF         COND(&FTPARM *EQ 'Y') THEN(DO)
/*/COPY WNCPYSRC,SCC0400004                                          */
                   SNDPGMMSG  MSG('(Outstanding payments require +
                                authorisation before processing can +
                                continue''') TOMSGQ(MOPERQ)
                                                                                        /*MD031262*/
             IF         COND((&CCB014 *EQ 'Y') *AND (&SCHREQ *EQ +
                          'Y')) THEN(GOTO CMDLBL(EXIT))                                 /*MD031262*/
 
/* Allow IC termination to continue with un-aut payments? */
 
                   CHGVAR     VAR(&SRTCD) VALUE('       ')
                   CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')
                   CHGVAR     VAR(&SSARD) VALUE('S01480')
 
                   CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)
 
                   IF         COND((&SRTCD *EQ '       ') *AND +
                                (&SRTCD *NE '*NRF   ')) THEN(DO)
                      CHGVAR     VAR(&MSGDTA) VALUE(' ')
                      CHGVAR     VAR(&RTN_CODE) VALUE(' ')
                      CHGVAR     VAR(&REOPN) VALUE('N')
/*/COPY WNCPYSRC,SCC0400006                                          */
                                                                                          /*CCB014*/
                      IF         COND(&CCB014 *EQ 'Y' *AND &SCHREQ *EQ 'Y') +
                                   THEN(DO)                                               /*CCB014*/
                        CHGVAR     VAR(&REOPN) VALUE('Y')                                 /*CCB014*/
                        GOTO       CMDLBL(TAGUSC01)                                       /*CCB014*/
                      ENDDO                                                               /*CCB014*/
 
                      CALL       PGM(MEC1027) PARM(&RTN_CODE +
                                   'FTM2355' 'FTUSRMSG ' &MSGDTA +
                                   'OPTION    ' &REOPN 'FT0230' 'Y')
/*/COPY WNCPYSRC,SCC0400007                                          */
TAGUSC01:                                                                                 /*CCB014*/
 
                      IF         COND(&REOPN *NE 'Y') THEN(DO)
                         GOTO       CMDLBL(EXIT)
                      ENDDO
 
                   ENDDO
                   ELSE       CMD(DO)
 
/* Call SCC0010 to send outstanding payments require */
/* authorisation screen                              */
 
                      RTVMSG     MSGID(SCM0042) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                                   VALUE(&MESSAGE)
                      RTVMSG     MSGID(SCM0043) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                                   VALUE(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (15 1)) VALUE('1')
                      CALL       PGM(SCC0010) PARM('SCC0400' 'ENTER' +
                                   &NOREPLY)
 
                      GOTO       CMDLBL(EXIT)
                   ENDDO
                ENDDO
/*/COPY WNCPYSRC,SCH00030                                            */
             ENDDO
 
/* Check if CRE401 is installed */                                                        /*CRE401*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE401*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE401*/
             CHGVAR     VAR(&PSARD) VALUE('CRE401')                                       /*CRE401*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)                   /*CRE401*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*CRE401*/
 
/* Check if there are unauthorised sweeps */                                              /*CRE401*/
             CALL       PGM(REC000334) PARM(&RERTCD &RSEQ &RLEV &RENT)                    /*CRE401*/
               IF       COND(&RERTCD *EQ 'Y') THEN(DO)                                    /*CRE401*/
 
/* Call SCC0010 to send 'Unauthorised Sweeps Accounts require */                          /*CRE401*/
/* authorisation' screen */                                                               /*CRE401*/
                      RTVMSG     MSGID(SCM0090) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)                                          /*CRE401*/
                      CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                                   VALUE(&MESSAGE)                                        /*CRE401*/
                      RTVMSG     MSGID(SCM0091) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)                                          /*CRE401*/
                      CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                                   VALUE(&MESSAGE)                                        /*CRE401*/
                      CHGDTAARA  DTAARA(MIDASMSG (15 1)) VALUE('1')                       /*CRE401*/
                      CALL       PGM(SCC0010) PARM('SCC0400' 'ENTER' +
                                   &NOREPLY)                                              /*CRE401*/
 
                      GOTO       CMDLBL(EXIT)                                             /*CRE401*/
               ENDDO                                                                      /*CRE401*/
             ENDDO                                                                        /*CRE401*/
/* Check for any incomplete end of centre processing runs */
/* in Futures and Options                                 */
 
             IF         COND((%SUBSTRING(&MMOD 41 1)) *EQ 'Y') THEN(DO)
                CALL       PGM(FF0680) PARM(&EOCACT)
                IF         COND(&EOCACT) THEN(GOTO ABNOR)
                                                                               /*192605*/ /*CPK014*/
/************************************************************************/                /*CPK014*/
/*                                                                      */                /*CPK014*/
/* The following processing has been replaced by CoB component PLC0400. */                /*CPK014*/
/*                                                                      */                /*CPK014*/
/************************************************************************/                /*CPK014*/
 
/***Check*if*Midas-Plato*Real-time*interface*is*On*                            /*192605*/ /*CPK014*/
/************CHGVAR     VAR(&SSARD) VALUE('CPL005')                            /*192605*/ /*CPK014*/
/************CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                           /*192605*/ /*CPK014*/
/************CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +                         /*CPK014*/
/************                   &SSCSARD)                                      /*192605*/ /*CPK014*/
/************IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +                          /*CPK014*/
/************             VAR(&CPL005) VALUE('Y'))                             /*192605*/ /*CPK014*/
/************                                                                  /*192605*/ /*CPK014*/
/***If*Midas-Plato*Real-time*interface*is*On*then*end*trigger*job*             /*192605*/ /*CPK014*/
/************IF         COND(&CPL005 *EQ 'Y') THEN(DO)                         /*192605*/ /*CPK014*/
/************RTVDTAARA  DTAARA(RPTRGMPI (1 48)) RTNVAR(&MQMSGQ)                /*192605*/ /*CPK014*/
/************SNDMSGMQQ  QUEUE(&MQMSGQ) MSG('SHUTDOWN')                         /*192605*/ /*CPK014*/
/************ENDDO                                                             /*192605*/ /*CPK014*/
                                                                               /*192605*/ /*CPK014*/
                CALL       PGM(FFC05)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
             ENDDO
 
/* Access switchable features file to check if CDL008 is on */        /*CDL008*/
                                                                      /*CDL008*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                  /*CDL008*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                  /*CDL008*/
             CHGVAR     VAR(&SSARD) VALUE('CDL008')                   /*CDL008*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                           &SSCSARD)                                  /*CDL008*/
                                                                      /*CDL008*/
/* If CDL008 is on, check for unauthorised Pay-In schedules */        /*CDL008*/
                                                                      /*CDL008*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*CDL008*/
                CALL       PGM(DL0297) PARM(&UNAUT)                   /*CDL008*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))                           /*CDL008*/
                                                                      /*CDL008*/
/* If unauthorised Pay-In schedules exist, halt I/C Termination */    /*CDL008*/
                                                                      /*CDL008*/
                IF         COND(&UNAUT *EQ 'Y') THEN(DO)              /*CDL008*/
                   SNDPGMMSG  MSG('Pay-In Schedules have been +
                             reported they need authorisation +
                             before processing can continue/') +
                             TOMSGQ(MOPERQ)                           /*CDL008*/
                   RTVMSG     MSGID(SCM0092) MSGF(MIDASMSG) +
                             MSG(&MESSAGE)                            /*CDL008*/
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                             VALUE(&MESSAGE)                          /*CDL008*/
                   RTVMSG     MSGID(SCM0043) MSGF(MIDASMSG) +
                             MSG(&MESSAGE)                            /*CDL008*/
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
                             VALUE(&MESSAGE)                          /*CDL008*/
                   CHGDTAARA  DTAARA(MIDASMSG (15 1)) VALUE('1')      /*CDL008*/
                   CALL       PGM(SCC0010) PARM('SCC0400' 'ENTER' +
                             &NOREPLY)                                /*CDL008*/
                   GOTO       CMDLBL(EXIT)                            /*CDL008*/
                ENDDO                                                 /*CDL008*/
                                                                      /*CDL008*/
/* If there are no unauthorised CLS Pay-in schedules, */              /*CDL008*/
/* end job DLC6316 if it is running */                                /*CDL008*/
                                                                      /*CDL008*/
                ALCOBJ     OBJ((FXCLSSTAT *DTAARA *SHRRD))            /*CDL008*/
                MONMSG     MSGID(CPF0000)                             /*CDL008*/
                RTVDTAARA  DTAARA(FXCLSSTAT (8 10)) RTNVAR(&JOB)      /*CDL008*/
                RTVDTAARA  DTAARA(FXCLSSTAT (18 10)) RTNVAR(&USR)     /*CDL008*/
                RTVDTAARA  DTAARA(FXCLSSTAT (28 6)) RTNVAR(&NBR)      /*CDL008*/
                ENDJOB     JOB(&NBR/&USR/&JOB) OPTION(*IMMED) +
                                 LOGLMT(0)                            /*CDL008*/
                MONMSG     MSGID(CPF0000)                             /*CDL008*/
                CHGDTAARA  DTAARA(FXCLSSTAT (8 10)) +
                              VALUE('          ')                     /*CDL008*/
                CHGDTAARA  DTAARA(FXCLSSTAT (18 10)) +
                              VALUE('          ')                     /*CDL008*/
                CHGDTAARA  DTAARA(FXCLSSTAT (28 6)) +
                              VALUE('      ')                         /*CDL008*/
                CHGDTAARA  DTAARA(FXCLSSTAT (7 1)) VALUE('N')         /*CDL008*/
                DLCOBJ     OBJ((FXCLSSTAT *DTAARA *SHRRD))            /*CDL008*/
             ENDDO                                                    /*CDL008*/
                                                                      /*CDL008*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                                      /*CGL030*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                      /*CGL030*/
             CHGVAR     VAR(&SSARD) VALUE('CGL030')                                       /*CGL030*/
                                                                                          /*CGL030*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                                       /*CGL030*/
                                                                                          /*CGL030*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)                               /*CGL030*/
             CALL CBC0042                                                                 /*CGL030*/
             ENDDO                                                                        /*CGL030*/
/************************************************************************/                /*CPK014*/
/*                                                                      */                /*CPK014*/
/* The following processing has been replaced by CoB component SDC1400. */                /*CPK014*/
/*                                                                      */                /*CPK014*/
/************************************************************************/                /*CPK014*/
 
/**Access*switchable*features*file*to*check*if*CSD006*is*on**/                 /*CSD006*/ /*CPK014*/
/************                                                                  /*CSD006*/ /*CPK014*/
/************CHGVAR     VAR(&SRTCD) VALUE('       ')                           /*CSD006*/ /*CPK014*/
/************CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                           /*CSD006*/ /*CPK014*/
/************CHGVAR     VAR(&SSARD) VALUE('CSD006')                            /*CSD006*/ /*CPK014*/
/************CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +                         /*CPK014*/
/************              &SSCSARD)                                           /*CSD006*/ /*CPK014*/
/************                                                                  /*CSD006*/ /*CPK014*/
/**If*CSD006*is*on,*SD*Terminate*Market*Data*Feed**/                           /*CSD006*/ /*CPK014*/
/************                                                                  /*CSD006*/ /*CPK014*/
/************IF         COND(&SRTCD *EQ '       ') THEN(DO)                    /*CSD006*/ /*CPK014*/
/************   CALL       PGM(SDC1470)                                        /*CSD006*/ /*CPK014*/
/************   IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +                            /*CPK014*/
/************                CMDLBL(ABNOR))                                    /*CSD006*/ /*CPK014*/
/************ENDDO                                                             /*CSD006*/ /*CPK014*/
                                                                               /*CSD006*/ /*CPK014*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,SCC0400002                                          /*S01408*/
/*                                                                   /*S01408*/
/** Check if Compliance Watch - Watch List Checking is installed */                       /*CSD015*/
                                                                                          /*CSD015*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSD015*/
             CHGVAR     VAR(&PSARD) VALUE('CSD015')                                       /*CSD015*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSD015*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)                   /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD015) VALUE('Y'))                                        /*CSD015*/
                                                                                          /*CSD015*/
/** If Compliance Watch - Watch List Checking is installed */                             /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&CSD015 *EQ 'Y') THEN(CALL +
                          PGM(SDCENDCW))                                                  /*CSD015*/
                                                                                          /*CSD015*/
/**********  CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('B')                                 */ /*CCB020*/
/**********  SCWRTJREG EVENT(MPHAS) FLAG(B) TEXT('MPHAS changed from A to B')   */ /*CSC020 CCB020*/
/**********  CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('C')               */        /*CCB020 AR1092065A*/
/**********  SCWRTJREG  EVENT(MPHAS) FLAG(C) TEXT('MPHAS changed +   */        /*CCB020 AR1092065A*/
/**********               from A to C')                              */        /*CCB020 AR1092065A*/
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('B')                                  /*MD046737*/
             SCWRTJREG  EVENT(MPHAS) FLAG(B) TEXT('MPHAS changed from A to B')          /*MD046737*/
 
             TFRCTL     PGM(CBRUN)
 
/*/COPY WNCPYSRC,SCC0400MPE                                          */
 
             GOTO       CMDLBL(END)
 
 EXIT:       DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             GOTO       CMDLBL(END)
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,SCC0400001                                          /*S01408*/
/*                                                                   /*S01408*/
 
 ABNOR:
/* An abnormal message has been issued and to prevent */
/* further errors  being  sent to the ABNOR tag by    */
/* the general MONMSG command  in  the  first line of */
/* executable code each of the  following  lines  are */
/* individually  monitored  to  prevent  any  further */
/* errors which may occur from causing a loop.        */
 
/*/COPY WNCPYSRC,SCC0400ERR                                          */
 
             SNDPGMMSG  MSG('Program SCC0400 ended abnormally - job +
                          cancelled') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,SCC0400003                                          /*S01408*/
/*                                                                   /*S01408*/
 
/* Remove message from MSPECIAL */
 
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RCVMSG     MSGQ(MSPECIAL)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
 END:
/*/COPY WNCPYSRC,SCC0400END                                          */
 
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
 
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
 
             RCVMSG     MSGQ(MSPECIAL)
 
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
