/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Save database and jrnrcv savefiles')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2455 - SAVE THE DATABASE AND RECEIVER SAVE FILES         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*       Prev Amend No. 259085             Date 27Jul12              */
/*                      246515             Date 19Mar07              */
/*                      CSC033             Date 21May07              */
/*                      B13662             Date 21May07              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      235616             Date 12Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      103818             Date 25Apr05              */
/*                      235553             Date 14Sep05              */
/*                      BUG6521            Date 03May05              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      200373             Date  2May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                    CSC012             Date 22Oct01                */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                    CCB009             Date 01Jun00                */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 08SEP96              */
/*                      097266             DATE 19AUG96              */
/*                      S01408             DATE 14MAY96              */
/*                      CSC002             DATE 14MAR96              */
/*                      090490             DATE 27SEP95              */
/*                      090488             DATE 27SEP95              */
/*                      087446             DATE 27SEP95              */
/*                      S01408             DATE 10MAY95              */
/*                      084050             DATE 17MAR95              */
/*                      056631             DATE 08DEC93              */
/*                      S01375             DATE 03APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                Amendment of core hook SCC2455008                  */
/*                Amendment of core hook SCC2455009                  */
/*                Amendment of core hook SCC2455010                  */
/*       259085 - COB Performance Improvement in M+.                 */
/*       246515 - Not possible to answer message on MIDAS_SAVE job.  */
/*                Do not save JRNIC. Allow option 7 to be taken when */
/*                on message wait.                                   */
/*       CSC033 - Include global libraries in database saves.        */
/*       B13662 - Error in 235616.  Program attempts to call Trade   */
/*                Innovation program when TI module is not present.  */
/*       235616 - Save the TI libraries earlier in this job.         */
/*                Also, call program TIC1710                         */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       103818 - With switchable feature CSC001 the data base save  */
/*                moved to ICIFINISH, but the RUNDAT MIDAS is already*/
/*                set at I/C initiation so DBDAY is not correct.     */
/*                ex:if run COB FRI system asks DBMON.               */
/*                Fix incorporated by CER001.                        */
/*       235553 - Save incorrect when user forgot to reply to        */
/*                MIDAS_SAVE job before another ICIFINISH launch     */
/*                another MIDAS_SAVE.                                */
/*       BUG6521 - Change Volume ID to be unique for each zone.      */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*     200373 - cannot take option 7 to answer msg.                  */
/*     CSC012 - Addition of a daily DTALIB save.                     */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408  - Core hook SCC2455006 added                        */
/*                 Core hook SCC2455005 added                        */
/*       097266  - Do not prompt for tape if correct tape is already */
/*                 mounted on the device - changed processing to be  */
/*                 same as in TRMSAV program SDC1797.                */
/*       S01408  - Core hook SCC2455004 added                        */
/*                 Core hook SCC2455003 added                        */
/*                 Core hook SCC2455002 added                        */
/*                 Core hook SCC2455001 added                        */
/*       CSC002  - Additional copy sources for complete save to one  */
/*                 tape with no messages                             */
/*               - Addition of core hook SCC2455TP1                  */
/*               - Addition of core hook SCC2455TP2                  */
/*               - Addition of core hook SCC2455TP3                  */
/*               - Addition of core hook SCC2455TP4                  */
/*               - Addition of core hook SCC2455TP5                  */
/*       090490  - DEFINE CORRECTLY DEVICE FOR SAVE                  */
/*       090488  - SEND ALSO MESSAGE TO QSYSOPR                      */
/*       087446  - Wrong parameter is pick up for the journalling.   */
/*       S01408  - Addition of core hook SCC2455MP1                  */
/*               - Addition of core hook SCC2455MP2                  */
/*               - Addition of core hook SCC2455MP3                  */
/*               - Addition of core hook SCC2455MP4                  */
/*               - Addition of core hook SCC2455MP5                  */
/*               - Addition of core hook SCC2455MP6                  */
/*               - Addition of core hook SCC2455MP7                  */
/*               - Addition of core hook SCC2455MP8                  */
/*               - Addition of core hook SCC2455INT                  */
/*       084050  - Should only backup ICRCV* files only if set to    */
/*                 backup ICT JRN to *DISK.                          */
/*               - Should check the device for JRN backup from the   */
/*                 correct position in JNSTAT, should not use the    */
/*                 device for DBXXX.                                 */
/*       056631  - Only picking up first five characters of          */
/*                 the device name.                                  */
/*       S01375  - Auto COB amendments                               */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* File of journal receiver save file object descriptions */
/**/
             DCLF       FILE(QADSPOBJ)
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                                  /*CSC012*/
             DCL        VAR(&MONIND) TYPE(*CHAR) LEN(1)               /*097266*/
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)                                   /*200373*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455INT                                          */
                                                                      /*S01408*/
/**/
/* Flash code                      */
/**/
             DCL        VAR(&FLASH) TYPE(*CHAR) LEN(1) VALUE(X'24')
/**/
/* BOB savfile name                */
/**/
             DCL        VAR(&BOB_SAVF) TYPE(*CHAR) LEN(5)
/**/
/* Device for BOB save             */
/**/
/************DCL        VAR(&SAVE_DEV) TYPE(*CHAR) LEN(5)         */ /*056631*/
             DCL        VAR(&SAVE_DEV) TYPE(*CHAR) LEN(10)           /*056631*/
             DCL        VAR(&SAVE_RCVR) TYPE(*CHAR) LEN(10)          /*084050*/
/**/
/* Dual receiver indicator                   */
/**/
             DCL        VAR(&DUAL) TYPE(*CHAR) LEN(1)
/**/
/* clear previous save file flag             */
/**/
             DCL        VAR(&CLEAR_SAVF) TYPE(*CHAR) LEN(4)
/**/
/* user defined journal entry                */
/**/
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
/**/
/* Mode of job - interactive= 0 / batch = 1        */
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/**/
/* Inq msg return variable                   */
/**/
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(1)
/**/
/* Parameters for SCC1767                    */
/**/
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVE_TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE_FILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SAVE_FILE2) TYPE(*CHAR) LEN(20)                              /*CSC012*/
             DCL        VAR(&DEVICE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VOLID) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&SENT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CSC002*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CSC002*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSC002*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CSC002*/
             DCL        VAR(&ONETP) TYPE(*CHAR) LEN(6)                /*CSC002*/
             DCL        VAR(&AUTO_BKP) TYPE(*CHAR) LEN(5)             /*CSC002*/
             DCL        VAR(&XDAT) TYPE(*DEC) LEN(5 0)                                    /*103818*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/************DCL        VAR(&TAPOPT) TYPE(*CHAR) LEN(5)                           /*BUG6521 CSC033*/
             DCL        VAR(&CX_AUTO) TYPE(*CHAR) LEN(111)                                /*235553*/
             DCL        VAR(&CX_RTN_CDE) TYPE(*CHAR) LEN(7)                               /*235553*/
             DCL        VAR(&GMLIB) TYPE(*CHAR) LEN(10)                                   /*CSC033*/
             DCL        VAR(&GTALIB) TYPE(*CHAR) LEN(10)                                  /*CSC033*/
             DCL        VAR(&SAVE_FILE3) TYPE(*CHAR) LEN(20)                              /*CSC033*/
             DCL        VAR(&SAVE_FILE4) TYPE(*CHAR) LEN(20)                              /*CSC033*/
             DCL        VAR(&GLOBAL) TYPE(*CHAR) LEN(1)                                   /*CSC033*/
             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)                                   /*CSC033*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*B13662*/
             DCL        VAR(&TI) TYPE(*CHAR) LEN(1)                                       /*B13662*/
             DCL        VAR(&USESID) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC033*/
/*/COPY SDCPYSRC,SDSVALDCL                                                                /*CSC033*/
/**/
/*/COPY WNCPYSRC,SCC2455009                                          */
/* Global error trap                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNORMAL)
/**/                                                                                      /*235616*/
/* Backup RUNDAT data area  */                                                            /*235616*/
/**/                                                                                      /*235616*/
             CRTDUPOBJ  OBJ(RUNDAT) FROMLIB(*LIBL) OBJTYPE(*DTAARA) +
                          TOLIB(QTEMP) NEWOBJ(RUNDATX)                                    /*235616*/
/**/
/*/COPY WNCPYSRC,SCC2455010                                          */
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/*/COPY WNCPYSRC,SCC2455033                                          */
             SNDPGMMSG  MSG('Save of database and journal receiver +
                          save files') TOMSGQ(MOPERQ MRUNQ)
/*                                                                                          B13662*/
/* Access PF/SDMMODPD to determine which modules are live                                   B13662*/
/*                                                                                          B13662*/
             CALL       PGM(AOMMODR0) PARM(&RTN '*FIRST' &FMT)                            /*B13662*/
/*                                                                                          B13662*/
/* Determine whether Trade Innovation Interface is present.                                 B13662*/
/*                                                                                          B13662*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(DO)                           /*B13662*/
             CHGVAR     VAR(&TI) VALUE('Y')                                               /*B13662*/
             ENDDO                                                                        /*B13662*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/* */                                                                 /*CSC002*/
/* Check if access paths to be saved                               */ /*CSC002*/
/* */                                                                 /*CSC002*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CSC002*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CSC002*/
             CHGVAR     VAR(&SARD) VALUE('CSC002')                    /*CSC002*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CSC002*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CSC002*/
/* Set flag */                                                        /*CSC002*/
             CHGVAR     VAR(&ONETP) VALUE('CSC002')                   /*CSC002*/
             ENDDO                                                    /*CSC002*/
/**/
/* Determine if job is interactive or batch  */
/**/
             RTVJOBA    TYPE(&MODE)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/************RTVDTAARA  DTAARA(TAPOPT) RTNVAR(&TAPOPT)                            /*BUG6521 CSC033*/
             RTVDTAARA  DTAARA(JNSTAT (173 1)) RTNVAR(&USESID)                            /*CSC033*/
/*/COPY WNCPYSRC,SCH00037                                            */
/**/
/* Retrieve tape device for BOB save  */
/**/
/************RTVDTAARA  DTAARA(JNSTAT (39 5)) RTNVAR(&SAVE_DEV)   */ /*056631*/
/************RTVDTAARA  DTAARA(JNSTAT (39 10)) RTNVAR(&SAVE_DEV) 056631 087446*/
             RTVDTAARA  DTAARA(JNSTAT (25 10)) RTNVAR(&SAVE_DEV)      /*087446*/
/**/                                                                 /*084050*/
/* Retrieve tape device for JRN save  */                             /*084050*/
/**/                                                                 /*084050*/
             RTVDTAARA  DTAARA(JNSTAT (25 10)) RTNVAR(&SAVE_RCVR)    /*084050*/
/**/                                                                                      /*235553*/
/* Retrieve COB Info early in the program before any prompts         */                   /*235553*/
/**/                                                                                      /*235553*/
             CHGVAR     VAR(%SST(&CX_AUTO 1 10)) VALUE('          ')                      /*235553*/
             CALL       PGM(CB0602X) PARM(&CX_RTN_CDE &CX_AUTO)                           /*235553*/
/**/                                                                                      /*235616*/
/* Create day name in qtemp  */                                                           /*235616*/
/**/                                                                                      /*235616*/
             CRTDTAARA  DTAARA(QTEMP/&SYSID) TYPE(*CHAR) LEN(3) +
                          VALUE(%SST(&CX_AUTO 109 3))                                     /*235616*/
/**/                                                                                      /*B13662*/
/* If Trade Innovation module is present,                                                 /*B13662*/
/**/                                                                                      /*B13662*/
             IF         COND(&TI *EQ 'Y') THEN(DO)                                        /*B13662*/
/*/COPY WNCPYSRC,SCH00038                                            */
             CALL       PGM(TIC1710) PARM('TIBACKUPS' '*CRTSAV')                          /*235616*/
/*/COPY WNCPYSRC,SCH00039                                            */
             ENDDO                                                                        /*B13662*/
/**/
/*/COPY WNCPYSRC,SCC2455034                                          */
/**************************************************************/
/*                                                            */
/* S A V E   A L L   J O U R N A L    R E C E I V E R         */
/* S A V E   F I L E S                                        */
/* IF ICT JRN IS SET TO SAVE ON *DISK                         */      /*084050*/
/*                                                            */
/**************************************************************/
/* */                                                                 /*CSC002*/
/* If one tape then these receivers have been included in DB001    */ /*CSC002*/
/* */                                                                 /*CSC002*/
             IF         COND(&ONETP *EQ 'CSC002') THEN(DO)            /*CSC002*/
/*/COPY WNCPYSRC,SCC2455035                                          */
             GOTO       CMDLBL(END_LOOP)                              /*CSC002*/
             ENDDO                                                    /*CSC002*/
/* */                                                                 /*084050*/
/* If Auto Cob and save of recievers FOR ICT is to disk               /*084050*/
/* */                                                                 /*084050*/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')  /*084050*/
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)       /*084050*/
/** Check if CSC001 is there */                                                           /*103818*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*103818*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*103818*/
             CHGVAR     VAR(&SARD) VALUE('CSC001')                                        /*103818*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*103818*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*103818*/
/** Retrieve previous rundat from JNSTAT and call CB0602W */                              /*103818*/
/** which is a new program to format the day              */                              /*103818*/
             CALL SCJNSTAT PARM(&XDAT)                                                    /*103818*/
             CALL CB0602W PARM(&CB_RTN_CDE &CB_AUTO &XDAT)                                /*103818*/
             ENDDO                                                                        /*103818*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455006                                          */
                                                                      /*S01408*/
             IF         COND((%SST(&CB_AUTO 66 4) *EQ '*YES') *AND +
                             (%SST(&CB_AUTO 31 5) *EQ '*DISK')) +
                        THEN(DO)                                      /*084050*/
/**/
/* Write a list of all journal receivers save files */
/* to SAV_IC_RCV                                    */
/**/
             CHGVAR     VAR(&LIB) VALUE(&SYSID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP8                                          */
                                                                      /*S01408*/
/************DSPOBJD    OBJ(&LIB/ICRCV*) OBJTYPE(*FILE) +
                        OUTPUT(*OUTFILE) OUTFILE(QTEMP/SAV_IC_RCV)**************************CSC020*/
             DSPOBJD    OBJ(&LIB/IR*) OBJTYPE(*FILE) +
                        OUTPUT(*OUTFILE) OUTFILE(QTEMP/SAV_IC_RCV)                        /*CSC020*/
             MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(END_LOOP))
/**/
/* Save all journal receiver save files             */
/**/
             OVRDBF     FILE(QADSPOBJ) TOFILE(SAV_IC_RCV)
/**/
/* Define save parameters                        */
/**/
                CHGVAR     VAR(&library) VALUE(&SYSID *cat 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP1                                          */
                                                                      /*S01408*/
                CHGVAR     VAR(&SAVE_TYPE) VALUE('SAVF')
/**/
/***************CHGVAR     VAR(&SAVE_FILE) VALUE('ICRCVxxx  xxDILIB   ')********************CSC020*/
                CHGVAR     VAR(&SAVE_FILE) VALUE('RxxxxxxxxxxxDILIB   ')                  /*CSC020*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP2                                          */
                                                                      /*S01408*/
                CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)
/**/
/***********    CHGVAR     VAR(&DEVICE) VALUE(&SAVE_DEV)             /*084050*/
                CHGVAR     VAR(&DEVICE) VALUE(&SAVE_RCVR)            /*084050*/
/*/COPY WNCPYSRC,SCC2455017                                          */
                CHGVAR     VAR(&VOLID) VALUE(JRNIC)
/*/COPY WNCPYSRC,SCC2455018                                          */
/**/
             CHGVAR     VAR(&SENT) VALUE('*NO ')
 
/* */                                                                /*CSC002*/
/*/COPY WNCPYSRC,SCC2455TP1                                         */
/* */                                                                /*CSC002*/
 START_LOOP: RCVF
             GOTO CMDLBL(END_LOOP)                                                        /*246515*/
/**********  MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END_LOOP))                        /*246515*/
/**/
/*/COPY WNCPYSRC,SCC2455039                                          */
             IF         COND(&ODOBAT *EQ 'SAVF') THEN(DO)
/**/
/*  Send message to mount tape with vol id JRNIC */
/*  to back up journal receivers                 */
/**/
 RESENDMSG:                                                                               /*200373*/
             IF         COND(&SENT *EQ '*NO ') THEN(DO)
/**/                                                                 /*084050 */
/*  The message itself is misleading - should use device for JRNIC   /*084050 */
/**/                                                                 /*084050 */
/**/                                                                 /*S01408 */
/*/COPY WNCPYSRC,SCC2455001                                          /*S01408 */
/**/                                                                 /*S01408 */
/*********** CHGVAR     VAR(&MSG) VALUE('Mount tape with volume id + /*084050 */
/***********              JRNIC on ' *BCAT &SAVE_DEV *BCAT &FLASH +  /*084050 */
/***********              *BCAT '- Type any letter and press enter + /*084050 */
/***********              to continue')                              /*084050 */
/**/                                                                 /*084050 */
             CHGVAR     VAR(&MSG) VALUE('Mount tape with volume id +
                          JRNIC on ' *BCAT &SAVE_RCVR *BCAT &FLASH +
                          *BCAT '- Type any letter and press enter +
                          to continue')                              /*084050 */
/**/                                                                 /*S01408 */
/*/COPY WNCPYSRC,SCC2455002                                          /*S01408 */
/**/                                                                 /*S01408 */
/**/
             IF         COND(&MODE *EQ '1') THEN(DO)
/**********  SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)                              /*246515*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)                                                 /*246515*/
             ENDDO
             ELSE       CMD(DO)
/**********  SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ)                            /*200373*/
/**********  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INQ) */             /*090488*/ /*200373*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)                          /*200373*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)            /*200373*/
             ENDDO
/**********  RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*NO) MSG(&RMSG) */                   /*200373*/
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&KEYVAR) WAIT(*MAX) +
                          RMV(*NO) KEYVAR(&KEYVAR) MSG(&RMSG)                             /*200373*/
                                                                                          /*200373*/
/*  If reply is non-blank */                                                              /*200373*/
             IF         COND(&RMSG *EQ ' ') THEN(DO)                                      /*200373*/
                   GOTO       CMDLBL(RESENDMSG)                                           /*200373*/
             ENDDO                                                                        /*200373*/
                                                                                          /*200373*/
/*/COPY WNCPYSRC,SCC2455036                                          */
             CHGVAR     VAR(&SENT) VALUE('*YES')
             ENDDO
/*/COPY WNCPYSRC,SCC2455015                                          */
/**/
/* Save the database library                     */
/**/
                CHGVAR     VAR(%SST(&SAVE_FILE 1 10)) VALUE(&ODOBNM)
/**/
/**/                                                                 /*S01408 */
/*/COPY WNCPYSRC,SCC2455003                                          /*S01408 */
/**/                                                                 /*S01408 */
                CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                           &SAVE_FILE &DEVICE &VOLID)
/**/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')
/**/                                                                 /*S01408 */
/*/COPY WNCPYSRC,SCC2455004                                          /*S01408 */
/**/                                                                 /*S01408 */
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO) /*090488*/
                   CHGJOB     SWS(XXXXXX11)
                   GOTO       CMDLBL(ABNORMAL)
                ENDDO
/*/COPY WNCPYSRC,SCC2455022                                          */
/**/
             ENDDO
             ELSE       CMD(DO)
                   SNDPGMMSG  MSG('File' *bcat &ODOBNM *bcat 'with +
                              attribute' *bcat &ODOBAT *bcat 'found +
                              in' *bcat &lib) TOMSGQ(MOPERQ)
                   SNDPGMMSG  MSG('File' *bcat &ODOBNM *bcat 'with +
                              attribute' *bcat &ODOBAT *bcat 'found +
                              in' *bcat &lib) TOMSGQ(QSYSOPR)       /*090488*/
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
             GOTO       CMDLBL(START_LOOP)
END_LOOP:
/*/COPY WNCPYSRC,SCC2455011                                          */
               ENDDO                                                  /*084050*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455007                                          */
                                                                      /*S01408*/
/**/
/* Retrieve day of of BOB save        */
/**/
/**********  CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('          ')                      /*235553*/
/**********  CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)                           /*235553*/
             CHGVAR     VAR(&CB_AUTO) VALUE(&CX_AUTO)                                     /*235553*/
             CHGVAR     VAR(&CB_RTN_CDE) VALUE(&CX_RTN_CDE)                               /*235553*/
/** Check if CSC001 is there */                                                           /*103818*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*103818*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*103818*/
             CHGVAR     VAR(&SARD) VALUE('CSC001')                                        /*103818*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*103818*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*103818*/
/** Retrieve previous rundat from JNSTAT and call CB0602W */                              /*103818*/
/** which is a new program to format the day              */                              /*103818*/
             CALL SCJNSTAT PARM(&XDAT)                                                    /*103818*/
             CALL CB0602W PARM(&CB_RTN_CDE &CB_AUTO &XDAT)                                /*103818*/
             ENDDO                                                                        /*103818*/
/**/
/* Determine BOB savefile name        */
/**/
             CHGVAR     VAR(&BOB_SAVF) VALUE(%SST(&CB_AUTO 107 5))
/**/
/* If no file defined skip */
/**/
             IF         COND(&BOB_SAVF *EQ '     ') THEN(GOTO +
                          CMDLBL(NO_DB_SAVE))
/**/
/* Save the database library                     */
/**/
             CHGVAR     VAR(&LIBRARY) VALUE(&SYSID *CAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP3                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&SAVE_TYPE) VALUE('SAVF')
/**/
             CHGVAR     VAR(&SAVE_FILE) VALUE('DBxxx     xxDILIB   ')
             CHGVAR     VAR(%SST(&SAVE_FILE 1 5)) VALUE(&BOB_SAVF)
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)
             CHGVAR     VAR(&SAVE_FILE2) VALUE('DBxxxDTA  xxDILIB   ')                    /*CSC012*/
             CHGVAR     VAR(%SST(&SAVE_FILE2 1 5)) VALUE(&BOB_SAVF)                       /*CSC012*/
             CHGVAR     VAR(%SST(&SAVE_FILE2 11 2)) VALUE(&SYSID)                         /*CSC012*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP4                                          */
                                                                      /*S01408*/
/**/
             RTVDTAARA  DTAARA(JNSTAT (39 10)) RTNVAR(&SAVE_DEV)      /*090490*/
             CHGVAR     VAR(&DEVICE) VALUE(&SAVE_DEV)
             CHGVAR     VAR(&VOLID) VALUE(&BOB_SAVF)
/* */                                                                /*CSC002*/
/*/COPY WNCPYSRC,SCC2455TP2                                         */
/* */                                                                /*CSC002*/
/**/
/*  Check that tape DBxxx has been loaded correctly, to back up        *097266*/
/*   journal receivers                                                 *097266*/
/**/                                                                  /*097266*/
/********** CHECK3:     CHKTAP     DEV(&DEVICE) VOL(&VOLID)                       /*097266 BUG6521*/
 CHECK3:
/************IF         COND((&TAPOPT *EQ 'SYSID') *AND (%SST(&VOLID +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOLID) +
                          VALUE(&SYSID *TCAT %SST(&VOLID 3 3)))                   /*BUG6521 CSC033*/
             IF         COND((&USESID *EQ 'Y') *AND (%SST(&VOLID +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOLID) +
                          VALUE(&SYSID *TCAT %SST(&VOLID 3 3)))                           /*CSC033*/
             CHKTAP     DEV(&DEVICE) VOL(&VOLID)                                         /*BUG6521*/
/*/COPY WNCPYSRC,SCC2455032                                          */
/**/                                                                  /*097266*/
             MONMSG     MSGID(CPF6718) EXEC(DO)                       /*097266*/
                CHGVAR     VAR(&MONIND) VALUE('1')                    /*097266*/
                CHGVAR     VAR(&MSG) VALUE('Unable to allocate device ' +
                             *BCAT &DEVICE *BCAT '. Retry if device +
                             becomes available and mount volume ' +
                             *BCAT &VOLID *BCAT ' OR enter "C" to +
                             cancel and end program.')                /*097266*/
             ENDDO                                                    /*097266*/
/**/                                                                  /*097266*/
             MONMSG     MSGID(CPF6720) EXEC(DO)                       /*097266*/
                CHGVAR     VAR(&MONIND) VALUE('1')                    /*097266*/
                CHGVAR     VAR(&MSG) VALUE('Tape with volume ID ' *BCAT +
                             &VOLID *BCAT ' not found on device ' *BCAT +
                             &DEVICE *BCAT '. Mount the correct tape +
                             and retry OR enter "C" to cancel and end +
                             program.')                               /*097266*/
             ENDDO                                                    /*097266*/
/**/                                                                  /*097266*/
             MONMSG     MSGID(CPF6760) EXEC(DO)                       /*097266*/
                CHGVAR     VAR(&MONIND) VALUE('1')                    /*097266*/
                CHGVAR     VAR(&MSG) VALUE('Device ' *BCAT &DEVICE +
                             *BCAT ' not ready. Mount volume with ID ' +
                             *BCAT &VOLID *BCAT ' on device, press +
                             START and retry OR enter "C" to cancel +
                             and end program.')                       /*097266*/
             ENDDO                                                    /*097266*/
/**/                                                                  /*097266*/
             MONMSG     MSGID(CPF6772) EXEC(DO)                       /*097266*/
                CHGVAR     VAR(&MONIND) VALUE('1')                    /*097266*/
                CHGVAR     VAR(&MSG) VALUE('Cannot process mounted vol +
                             on device ' *BCAT &DEVICE *BCAT '.Clean +
                             tape path & heads,& retry OR enter"C"to +
                             cancel program. If problem recurs,mount +
                             another volume & retry.')                /*097266*/
             ENDDO                                                    /*097266*/
/**/                                                                  /*097266*/
             MONMSG     MSGID(CPF9814) EXEC(DO)                       /*097266*/
                CHGVAR     VAR(&MONIND) VALUE('1')                    /*097266*/
                CHGVAR     VAR(&MSG) VALUE('Device ' *BCAT &DEVICE +
                             *BCAT ' not found. Mount volume with ID ' +
                             *BCAT &VOLID *BCAT ' on device and retry +
                             OR enter "C" to cancel and end program.')
             ENDDO                                                    /*097266*/
/*/COPY WNCPYSRC,SCC2455020                                          */
/**/                                                                  /*097266*/
/*  Send message, monitor for reply                                */ /*097266*/
/**/                                                                  /*097266*/
             IF         COND(&MONIND *EQ '1') THEN(DO)                /*097266*/
/**/                                                                  /*097266*/
                IF         COND(&MODE *EQ '1') THEN(DO)               /*097266*/
/**********      SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)               /*097266*/ /*246515*/
                 SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)                                                 /*246515*/
                ENDDO                                                 /*097266*/
                ELSE       CMD(DO)                                    /*097266*/
/**********      SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ)   */        /*097266*/ /*200373*/
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)           /*097266*/
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                              KEYVAR(&KEYVAR)                                             /*200373*/
                ENDDO                                                 /*097266*/
/**/                                                                  /*097266*/
/**********     RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*NO) MSG(&RMSG)                   /*200373*/
                RCVMSG     MSGTYPE(*RPY) MSGKEY(&KEYVAR) WAIT(*MAX) +
                               RMV(*NO) KEYVAR(&KEYVAR) MSG(&RMSG)                        /*200373*/
/**/                                                                  /*097266*/
/*  If reply is 'C',  End program                                     /*097266*/
                IF         COND((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) +
                                THEN(DO)                              /*097266*/
                   SNDPGMMSG  MSG('Pgm SCC2455 - Save of database save +
                             files cancelled by user')                /*097266*/
                   GOTO       CMDLBL(ABNORMAL)                        /*097266*/
                ENDDO                                                 /*097266*/
/**/                                                                  /*097266*/
/* ... else return to CHECK3                                          /*097266*/
                ELSE       CMD(DO)                                    /*097266*/
/*/COPY WNCPYSRC,SCC2455021                                          */
                   CHGVAR     VAR(&MONIND) VALUE('0')                 /*097266*/
                   GOTO       CMDLBL(CHECK3)                          /*097266*/
                ENDDO                                                 /*097266*/
/**/                                                                  /*097266*/
             ENDDO                                                    /*097266*/
/**/                                                                  /*097266*/
/***Send*message*to*mount*tape*with*vol*id*DBXXX**/                   /*097266*/
/***to*back*up*journal*receivers******************/                   /*097266*/
/************                                                      */ /*097266*/
/************CHGVAR     VAR(&MSG) VALUE('Mount new tape with volume*+ /*097266*/
/************             id ' *BCAT &BOB_SAVF *BCAT ' on ' *BCAT +*/ /*097266*/
/************             &SAVE_DEV *BCAT &FLASH *BCAT '- Type any +/ /*097266*/
/************             letter and press enter to continue')     */ /*097266*/
/************IF         COND(&MODE *EQ '1') THEN(DO)               */ /*097266*/
/************SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)       */ /*097266*/
/************ENDDO                                                 */ /*097266*/
/************ELSE       CMD(DO)                                    */ /*097266*/
/************SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ)     */ /*097266*/
/************SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)   */ /*090488*/
/************ENDDO                                                 */ /*097266*/
/************RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*NO) MSG(&RMSG)/ /*097266*/
/* */                                                                /*CSC002*/
/*/COPY WNCPYSRC,SCC2455TP3                                         */
/* */                                                                /*CSC002*/
/**/
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)
/*/COPY WNCPYSRC,SCC2455012                                          */
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO) /*090488*/
                   CHGJOB     SWS(XXXXXX11)
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
/*/COPY WNCPYSRC,SCC2455005                                          */
/**********  ELSE       CMD(SNDPGMMSG MSG('Database save completed + */                   /*CSC012*/
/**********               successfully') TOMSGQ(MOPERQ MRUNQ))       */                   /*CSC012*/
             ELSE       CMD(SNDPGMMSG MSG('DMLIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC012*/
/*/COPY WNCPYSRC,SCC2455008                                          */
                                                                                          /*CSC012*/
/* Save the DTALIB */                                                                     /*CSC012*/
                                                                                          /*CSC012*/
             CHGVAR     VAR(&DTALIB) VALUE(&SYSID *CAT 'DTALIB')                          /*CSC012*/
                                                                                          /*CSC012*/
             CALL       PGM(SCC1767) PARM(&DTALIB &SAVE_TYPE +
                          &SAVE_FILE2 &DEVICE &VOLID)                                     /*CSC012*/
                                                                                          /*CSC012*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*CSC012*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                                             /*CSC012*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC012*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)                    /*CSC012*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC012*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC012*/
             ENDDO                                                                        /*CSC012*/
             ELSE       CMD(SNDPGMMSG MSG('DTALIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC012*/
 
/*                                                                      CCB009*/
/**/                                                                                      /*CSC033*/
/** Check whether global library save is required.                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
             RTVDTAARA  DTAARA(JNSTAT (172 1)) RTNVAR(&GLOBAL)                            /*CSC033*/
/**/                                                                                      /*CSC033*/
/* If save of global libraries is required,                                               /*CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)                                    /*CSC033*/
/**/                                                                                      /*CSC033*/
/*  determine global system ID.                                                           /*CSC033*/
/**/                                                                                      /*CSC033*/
             CALL       PGM(AOSVALR0) PARM(&RTN 'BrgMidasGlobalPrefix' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)                                /*CSC033*/
/**/                                                                                      /*CSC033*/
/* If there is an error finding system values, then end abnormally.                       /*CSC033*/
/**/                                                                                      /*CSC033*/
                IF         COND(&RTN *NE '       ') THEN(GOTO +
                             CMDLBL(ABNORMAL))                                            /*CSC033*/
/**/                                                                                      /*CSC033*/
/*  Calculate names of global libraries.                                                  /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&GLOBID) VALUE(&SVAL1)                                        /*CSC033*/
             CHGVAR     VAR(&GMLIB) VALUE(&GLOBID *CAT 'GMLIB   ')                        /*CSC033*/
             CHGVAR     VAR(&GTALIB) VALUE(&GLOBID *CAT 'GTALIB  ')                       /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Determine Beginning of Business save file names for global libraries.                  /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&SAVE_FILE3) VALUE('DBxxxGM   xxDILIB   ')                    /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE3 1 5)) VALUE(&BOB_SAVF)                       /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE3 11 2)) VALUE(&SYSID)                         /*CSC033*/
             CHGVAR     VAR(&SAVE_FILE4) VALUE(&SAVE_FILE3)                               /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE4 6 3)) VALUE('GTA')                           /*CSC033*/
                                                                                          /*CSC033*/
/* Save the global GMLIB.                                                                 /*CSC033*/
                                                                                          /*CSC033*/
             CALL       PGM(SCC1767) PARM(&GMLIB &SAVE_TYPE +
                          &SAVE_FILE3 &DEVICE &VOLID)                                     /*CSC033*/
                                                                                          /*CSC033*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*CSC033*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                                             /*CSC033*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC033*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)                    /*CSC033*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC033*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE       CMD(SNDPGMMSG MSG('GMLIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC033*/
                                                                                          /*CSC033*/
/* Save the global GTALIB.                                                                /*CSC033*/
                                                                                          /*CSC033*/
             CALL       PGM(SCC1767) PARM(&GTALIB &SAVE_TYPE +
                          &SAVE_FILE4 &DEVICE &VOLID)                                     /*CSC033*/
                                                                                          /*CSC033*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*CSC033*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                                             /*CSC033*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC033*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)                    /*CSC033*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC033*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE       CMD(SNDPGMMSG MSG('GTALIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC033*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
/*/COPY WNCPYSRC,SCC2455040                                          */
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* If feature CSC002 (save receivers on database tape) is 'on',         CCB009*/
/*                                                                      CCB009*/
             IF         COND(&ONETP *EQ 'CSC002') THEN(DO)            /*CCB009*/
/*                                                                      CCB009*/
/* Call SCC2458 now to save the receiver save files to tape.  This      CCB009*/
/* would have been called in TRMSAV by SDC1797 if CCB009 (close         CCB009*/
/* of business journaling) were 'off'.                                  CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(SCC2458) PARM(&DEVICE &VOLID)             /*CCB009*/
/*                                                                      CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                      CCB009*/
             ENDDO                                                    /*CCB009*/
/**/
/**************************************************************/
/*                                                            */
/* P E R F O R M   P R O C E S S I N G   S P E C I F I C      */
/* T O   D U A L  R E C E I V E R   S Y S T E M S             */
/*                                                            */
/**************************************************************/
/**/
             RTVDTAARA  DTAARA(JNSTAT (80 1)) RTNVAR(&DUAL)
/**********  IF         COND(&DUAL *EQ 'N') THEN(GOTO CMDLBL(END_DUAL)) */                /*259085*/
/**/                                                                                      /*259085*/
/** Process dual save only when DUAL ind is 'Y' */                                        /*259085*/
/**/                                                                                      /*259085*/
             IF         COND(&DUAL *NE 'Y') THEN(GOTO CMDLBL(END_DUAL))                   /*259085*/
/**/
/* Save the database library                     */
/**/
             CHGVAR     VAR(&library) VALUE(&SYSID *cat 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP5                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&SAVE_TYPE) VALUE('SAVF')
/**/
             CHGVAR     VAR(&SAVE_FILE) VALUE('JNSAV     xxDILIB   ')
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP6                                          */
                                                                      /*S01408*/
/* */                                                                 /*CSC002*/
/* If one tape then include on present tape */                        /*CSC002*/
/* */                                                                 /*CSC002*/
             IF         COND(&ONETP *EQ 'CSC002') THEN(DO)            /*CSC002*/
             GOTO       CMDLBL(SAVE_DUAL)                             /*CSC002*/
             ENDDO                                                    /*CSC002*/
/* */                                                                 /*CSC002*/
             RTVDTAARA  DTAARA(JNSTAT (25 10)) RTNVAR(&SAVE_DEV)      /*090490*/
             CHGVAR     VAR(&DEVICE) VALUE(&SAVE_DEV)
             CHGVAR     VAR(&VOLID) VALUE(JNSAV)
/*/COPY WNCPYSRC,SCC2455014                                          */
/**/
/*  Send message to mount tape with vol id JNSAV */
/*  to back up journal receivers                 */
/**/
             CHGVAR     VAR(&MSG) VALUE('Mount new tape with volume +
                          id JNSAV on ' *BCAT &SAVE_DEV *BCAT +
                          &FLASH *BCAT '- Type any letter and press +
                          enter to continue')
/*/COPY WNCPYSRC,SCC2455037                                          */
             IF         COND(&MODE *EQ '1') THEN(DO)
/**********  SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)                              /*246515*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)                                                 /*246515*/
             ENDDO
             ELSE       CMD(DO)
/**********  SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ)                            /*246515*/
/**********  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INQ)                /*090488*/ /*246515*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INQ) KEYVAR(&KEYVAR)                                   /*246515*/
             ENDDO
/**********  RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*NO) MSG(&RMSG)                      /*246515*/
             RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) RMV(*NO) +
                          KEYVAR(&KEYVAR) MSG(&RMSG)                                      /*246515*/
/*/COPY WNCPYSRC,SCC2455038                                          */
/* */                                                                 /*CSC002*/
/* Save JLIB to tape */                                               /*CSC002*/
/* */                                                                 /*CSC002*/
 SAVE_DUAL:                                                           /*CSC002*/
/**/
             CALL       PGM(SCC1767) PARM(&library &save_type &SAVE_FILE +
                          &DEVICE &VOLID)
/*/COPY WNCPYSRC,SCC2455013                                          */
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO) /*090488*/
                   CHGJOB     SWS(XXXXXX11)
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ELSE       CMD(SNDPGMMSG MSG('Journal library save +
                          completed successfully') TOMSGQ(MOPERQ +
                          MRUNQ))
END_DUAL:
/**/
/* Format user defined 'SV' entry for the journal */
/**/
COMMON:
             CHGVAR     VAR(%SST(&JRNE 1 5)) VALUE(&BOB_SAVF)
             CHGVAR     VAR(%SST(&JRNE 6 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SST(&JRNE 8 5)) VALUE('DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2455MP7                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(%SST(&JRNE 26 4)) VALUE('TAPE')
/**/
/* Output user defined 'SV' entry to the journal */
/*/COPY WNCPYSRC,SCC2455023                                          */
/**/
/*/COPY WNCPYSRC,SCC2455024                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/*/COPY WNCPYSRC,SCC2455029                                          */
NO_DB_SAVE:
             GOTO CMDLBL(CLEARS)                                                          /*246515*/
/**/
/**************************************************************/
/*                                                            */
/* S A V E   N E W   J O U R N A L    R E C E I V E R S       */
/*                                                            */
/**************************************************************/
/* */                                                                 /*CSC002*/
/* Only change journals if Auto backup needed */                      /*CSC002*/
/* */                                                                 /*CSC002*/
             IF         COND(&ONETP *EQ 'CSC002') THEN(DO)            /*CSC002*/
             RTVDTAARA  DTAARA(JNSTAT (106 5)) RTNVAR(&AUTO_BKP)      /*CSC002*/
             IF         COND(&AUTO_BKP *EQ '00000') THEN(DO)          /*CSC002*/
             GOTO       CMDLBL(CLEARS)                                /*CSC002*/
             ENDDO                                                    /*CSC002*/
             ENDDO                                                    /*CSC002*/
/* */                                                                /*CSC002*/
/*/COPY WNCPYSRC,SCC2455TP4                                         */
/* */                                                                /*CSC002*/
/**/
/*  Send message to mount tape with vol id JRNIC */
/*  to back up journal receivers                 */
/**/
/*  The message itself is misleading - should use device for JRNIC   /*084050 */
/**/                                                                 /*084050 */
/*********** CHGVAR     VAR(&MSG) VALUE('Mount new tape with volume +/*084050 */
/***********              id JRNIC on ' *BCAT &SAVE_DEV *BCAT +      /*084050 */
/***********              &FLASH *BCAT '- Do not load yesterdays +   /*084050 */
/***********              JRNIC tape')                               /*084050 */
             CHGVAR     VAR(&MSG) VALUE('Mount new tape with volume +
                          id JRNIC on ' *BCAT &SAVE_RCVR *BCAT +
                          &FLASH *BCAT '- Do not load yesterdays +
                          JRNIC tape')                               /*084050 */
/*/COPY WNCPYSRC,SCC2455019                                          */
 
             IF         COND(&MODE *EQ '1') THEN(DO)
/**********  SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)                              /*246515*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)                                                 /*246515*/
             ENDDO
             ELSE       CMD(DO)
/**********  SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ)                            /*246515*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INQ) KEYVAR(&KEYVAR)                                   /*246515*/
             ENDDO
/**********  RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*NO) MSG(&RMSG)                      /*246515*/
             RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) RMV(*NO) +
                          KEYVAR(&KEYVAR) MSG(&RMSG)                                      /*246515*/
/*/COPY WNCPYSRC,SCC2455016                                          */
/**/
/*  Back up journal receivers                 */
/**/
             IF         COND(&MODE *EQ '1') THEN(DO)
             CALL       PGM(SDC1715) PARM('0')
             ENDDO
             ELSE       CMD(DO)
             CALL       PGM(SDC1715) PARM('1')
             ENDDO
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
 CLEARS:                                                              /*CSC002*/
/* */                                                                /*CSC002*/
/*/COPY WNCPYSRC,SCC2455TP5                                         */
/* */                                                                /*CSC002*/
/**/
/*  If clear all save files flag on CB_AUTO is yes call SCC2457 */
/**/
             CHGVAR     VAR(&CLEAR_SAVF) VALUE(%SST(&CB_AUTO 93 4))
             IF         COND(&CLEAR_SAVF *EQ '*YES') THEN(CALL +
                          PGM(SCC2457))
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/*  Clear save file data on CBAICDPD if clear save files yes */
/**/
             IF         COND((&CLEAR_SAVF *EQ '*YES') *AND +
                             (&BOB_SAVF *NE '     ')) THEN(DO)
/**/
/* Call CB0602U to update COB data fields on CBAICDPD */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETDB    ')
             CHGVAR     VAR(%SST(&CB_AUTO 88 5)) VALUE('*DISK')
             CHGVAR     VAR(%SST(&CB_AUTO 93 4)) VALUE('*YES')
             CHGVAR     VAR(%SST(&CB_AUTO 107 5)) VALUE('     ')
             CALL       PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)
             ENDDO
/*/COPY WNCPYSRC,SCC2455025                                          */
/**/
/**/                                                                                      /*B13662*/
/* If Trade Innovation module is present,                                                 /*B13662*/
/**/                                                                                      /*B13662*/
             IF         COND(&TI *EQ 'Y') THEN(DO)                                        /*B13662*/
/*/COPY WNCPYSRC,SCH00040                                            */
             CALL       PGM(TIC1710) PARM('TIBACKUPS' '*TAPSAV')                          /*235616*/
/*/COPY WNCPYSRC,SCH00041                                            */
             ENDDO                                                                        /*B13662*/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
/*/COPY WNCPYSRC,SCC2455026                                          */
ABNORMAL:
/*/COPY WNCPYSRC,SCC2455030                                          */
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2454 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*/COPY WNCPYSRC,SCC2455027                                          */
/**/
/*/COPY WNCPYSRC,SCC2455028                                          */
 ENDCLPGM:   ENDPGM
/*/COPY WNCPYSRC,SCC2455031                                          */
