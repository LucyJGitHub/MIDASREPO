/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Save jrnrcv to save files')                  */
/********************************************************************/
/*                                                                  */
/*          MIDAS STANDING DATA MODULE                              */
/*                                                                  */
/*          SCC2449 - SAVE JOURNAL RECEIVERS TO SAVE FILES          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27440          Date 21Apr10               */
/*                      260790            Date 19Jun09               */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CRE026            Date 24May06               */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619           Date 01Feb06               */
/*                      CSC020            Date 31Mar04               */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764            Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731            Date 11Jul01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      193382            Date     09May01          */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009            Date     01Jun00           */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408            DATE     10MAY95          */
/*                      S01375            DATE     03APR92          */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG27440 - SCC0401 00001 failed                             */
/*       260790 - COB performance fix                                */
/*                Journal receivers are saved as detached so this    */
/*                pgm should not try to delete all SAVFs and save    */
/*                all receivers if running in batch                  */
/*       CRE026 - Consumer Banking                                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO            */
/*                instead of *YES                                    */
/*       193382 - Stamp the BOB save savefiles with the Midas        */
/*                rundate.                                           */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408  - Addition of core hook SCC2449MP1                 */
/*               - Addition of core hook SCC2449MP2                 */
/*       S01375  - Auto COB amendments                              */
/*                                                                  */
/********************************************************************/
             PGM
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* File of journal receiver save file object descriptions */
/**/
             DCLF       FILE(QADSPOBJ)
/**/
             DCL        VAR(&AUTO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSIP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&COUNT) TYPE(*DEC) LEN(3)                                       CSC020*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(8)                                     /*CSC020*/
/**********  DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(3)                                     CSC020*/
             DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(8)                                   /*CSC020*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVFTEXT) TYPE(*CHAR) LEN(50)                                /*193382*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)                                  /*193382*/
/**/
/* Job name, user id and job number          */
/**/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
/**/
/* user defined journal entry                */
/**/
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
/**/
/* Seq. no of journal rec. currently attached*/
/**/
/********    DCL        VAR(&LSAV) TYPE(*DEC) LEN(3)                                        CSC020*/
             DCL        VAR(&LSAV) TYPE(*DEC) LEN(8)                                      /*CSC020*/
/**********  DCL        VAR(&LSAVA) TYPE(*CHAR) LEN(3)                                      CSC020*/
             DCL        VAR(&LSAVA) TYPE(*CHAR) LEN(8)                                    /*CSC020*/
/**/
/* Seq. no of last journal receiver to be saved */
/* by this program                              */
/**/
/*********   DCL        VAR(&LAST_RECV) TYPE(*DEC) LEN(3)                                   CSC020*/
             DCL        VAR(&LAST_RECV) TYPE(*DEC) LEN(8)                                 /*CSC020*/
/**/
/* Name of journal receiver to be saved         */
/**/
/**********  DCL        VAR(&SAVF_NAME) TYPE(*CHAR) LEN(8)                                  CSC020*/
             DCL        VAR(&SAVF_NAME) TYPE(*CHAR) LEN(10)                               /*CSC020*/
/**/
/**Mode*of*job*-*interactive=*0 / batch*=*1***************************/                   /*260790*/
/* Mode of job - interactive= 1 / batch = 0 */                                            /*260790*/
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/**/
/* ASP for sav files                         */
/**/
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&EQLIB) TYPE(*CHAR) LEN(7)                                    /*CRE026*/
             DCL        VAR(&EQLIB1) TYPE(*CHAR) LEN(7)                                   /*CRE026*/
             DCL        VAR(&CRE026) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CRE026*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                         /*CRE026*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                                      /*CRE026*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CRE026*/
             DCL        VAR(&EJNSTAT) TYPE(*CHAR) LEN(200)                                /*CRE026*/
             DCL        VAR(&ECOUNT) TYPE(*DEC) LEN(4)                                    /*CRE026*/
             DCL        VAR(&ECOUNTA) TYPE(*CHAR) LEN(4)                                  /*CRE026*/
             DCL        VAR(&ELSAV) TYPE(*DEC) LEN(4)                                     /*CRE026*/
             DCL        VAR(&ELSAVA) TYPE(*CHAR) LEN(4)                                   /*CRE026*/
             DCL        VAR(&EQ_RCV_NAM) TYPE(*CHAR) LEN(10)                              /*CRE026*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/**/                                                                                      /*260790*/
/* Seq. no of last journal rec saved */                                                   /*260790*/
/**/                                                                                      /*260790*/
             DCL        VAR(&JSAV) TYPE(*DEC) LEN(8)                                      /*260790*/
/**/                                                                                      /*260790*/
/* Control sequence number to determine saves and dltfs */                                /*260790*/
/**/                                                                                      /*260790*/
             DCL        VAR(&CONTROL) TYPE(*DEC) LEN(8)                                   /*260790*/
             DCL        VAR(&THISREC) TYPE(*DEC) LEN(8)                                   /*260790*/
             DCL        VAR(&FLEMPTY) TYPE(*CHAR) LEN(1) VALUE('Y')                     /*BUG27440*/
                                                                                          /*260790*/
/*/COPY WNCPYSRC,SCC2449001                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 +
                          'IASPgroup' &SVAL2 &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                         /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                                          /*CRE026*/
/** Check for switchable feature CRE026 - Consumer Banking */                             /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE026*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CRE026*/
             CHGVAR     VAR(&SARD) VALUE('CRE026')                                        /*CRE026*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &OPN &SARD)                             /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                             VAR(&CRE026) VALUE('Y'))                                     /*CRE026*/
                                                                                          /*CRE026*/
/*/COPY WNCPYSRC,SCC2449002                                          */
/**/
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/* Determine if job is interactive or batch  */
/**/
             RTVJOBA    TYPE(&MODE)
/**/
/**************************************************************/
/*                                                            */
/* C A N C E L   A U T O - B A C K U P   J O B                */
/*                                                            */
/**************************************************************/
/**/
/* Check JNSTAT to see if AUTOBKP is running */
/**/
             RTVDTAARA  DTAARA(JNSTAT (111 10)) RTNVAR(&AUTO)
             IF         COND(&AUTO *NE '          ') THEN(DO)
                 CALL PGM(RRCHKAUTO)
                 IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                            CMDLBL(ABNORMAL))
/**/
/* If AUTOBKP is running, wait until the current receiver save has   */
/* finished then cancel it                                           */
/**/
 RTV:            RTVDTAARA  DTAARA(JNSTAT (69 1)) RTNVAR(&RSIP)
                 IF         COND(&RSIP *EQ 'Y') THEN(DO)
                      DLYJOB     DLY(5)
                      GOTO       CMDLBL(RTV)
                 ENDDO
/**/
                 RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/**/
                 CHGVAR     VAR(&JOBN) VALUE(%SST(&JNSTAT 111 10))
                 CHGVAR     VAR(&USRN) VALUE(%SST(&JNSTAT 121 10))
                 CHGVAR     VAR(&JBNB) VALUE(%SST(&JNSTAT 131 6))
/**/
                 ENDJOB     JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED) +
                            SPLFILE(*YES)
                 MONMSG     MSGID(CPF1321 CPF1362)
/**/
                 CHGDTAARA  DTAARA(JNSTAT (111 26)) +
                            VALUE('                          ')
/**/
             ENDDO
/**/
/* Amend position 69 on JNSTAT  to 'Y' to prevent      */
/* futher journal change processing                    */
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE(Y)
/**/
/**************************************************************/
/*                                                            */
/* C H A N G E   J O U R N A L   R E C E I V E R              */
/*                                                            */
/**************************************************************/
/**/
/* Retreive seq no. of current journal receiver attached */
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/*********   CHGVAR     VAR(&LSAV) VALUE(%SST(&JNSTAT 6 3))                                 CSC020*/
             CHGVAR     VAR(&LSAV) VALUE(%SST(&JNSTAT 3 8))                               /*CSC020*/
             CHGVAR     VAR(&LSAVA) VALUE(&LSAV)
/**/                                                                                      /*260790*/
/* Get number of last receivers saved from JNSTAT */                                      /*260790*/
/**/                                                                                      /*260790*/
             CHGVAR     VAR(&JSAV) VALUE(%SST(&JNSTAT 13 8))                              /*260790*/
/**/
/* Obtain the system library id from SDSTAT                          */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2449MP2                                          */
                                                                      /*S01408*/
/**/
/* Format user defined 'JS' entry for the journal */
/**/
/*********   CHGVAR     VAR(%SST(&JRNE 6 8)) VALUE('ICRCV' *TCAT +
                          %SST(&JNSTAT 16 3))                                               CSC020*/
             CHGVAR     VAR(%SST(&JRNE 6 10)) VALUE('IR' *TCAT +
                          %SST(&JNSTAT 13 8))                                             /*CSC020*/
/*********   CHGVAR     VAR(%SST(&JRNE 16 8)) VALUE('ICRCV' *TCAT +
                        &LSAVA)                                                             CSC020*/
             CHGVAR     VAR(%SST(&JRNE 16 10)) VALUE('IR' *TCAT +
                        &LSAVA)                                                           /*CSC020*/
             CHGVAR     VAR(%SST(&JRNE 26 8)) VALUE('DISK')
/**/
/* Output user defined 'JS' entry to the journal */
/*/COPY WNCPYSRC,SCC2449011                                          */
/**/
/**********  SNDJRNE    JRN(ICJRN) TYPE('JS') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('JS') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/*/COPY WNCPYSRC,SCC2449003                                          */
/**/
/*/COPY WNCPYSRC,SCC2449004                                          */
/* Call SDC1717 to save data areas onto the journal */
/**/
             CALL       PGM(SDC1717)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNORMAL)
/**/
/* Call SCC1716 to change journal receivers   */
/**/
/*********** CALL       PGM(SCC1716) PARM(&MODE)                                            CSC020*/
/*********** IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNORMAL)                         CSC020*/
/**/
/**************************************************************/
/*                                                            */
/* D E L E T E   O L D   S A V E   F I L E S                  */
/*                                                            */
/**************************************************************/
/**/
/**/
/* Attempt to delete work file SAV_IC_RCV           */
/**/
             DLTF       FILE(QTEMP/SAV_IC_RCV)
             MONMSG     MSGID(CPF2105)
/**/
/* Write a list of all journal receivers save files */
/* to SAV_IC_RCV                                    */
/**/
             CHGVAR     VAR(&DILIB) VALUE(&SYSID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2449MP1                                          */
                                                                      /*S01408*/
/*********** DSPOBJD    OBJ(&DILIB/ICRCV*) OBJTYPE(*FILE) +
                        OUTPUT(*OUTFILE) OUTFILE(QTEMP/SAV_IC_RCV)                          CSC020*/
             DSPOBJD    OBJ(&DILIB/IR*) OBJTYPE(*FILE) +
                        OUTPUT(*OUTFILE) OUTFILE(QTEMP/SAV_IC_RCV)                        /*CSC020*/
             MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(END_LOOP))
/**/
/* Delete all journal receiver save files           */
/* Do NOT delete any SAVFs that have been used to save recs as they are */                /*260790*/
/* detached today */                                                                      /*260790*/
/**/
             OVRDBF     FILE(QADSPOBJ) TOFILE(SAV_IC_RCV)
/**/                                                                                      /*260790*/
/* Set to next receiver to be saved */                                                    /*260790*/
/**/                                                                                      /*260790*/
             CHGVAR     VAR(&CONTROL) VALUE(&JSAV)                                        /*260790*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                                    /*260790*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - Save file for Auto COB')                                    /*260790*/
 START_LOOP: RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END_LOOP))
             CHGVAR     VAR(&FLEMPTY) VALUE('N')                                        /*BUG27440*/
/**/
/**********  IF         COND(&ODOBAT *EQ 'SAVF') THEN(DLTF + */                           /*260790*/
/**********               FILE(&DILIB/&ODOBNM)) */                                        /*260790*/
             IF         COND(&ODOBAT *EQ 'SAVF') THEN(DO)                                 /*260790*/
                 CHGVAR     VAR(&THISREC) VALUE(%SST(&ODOBNM 3 8))                        /*260790*/
                 IF         COND(&THISREC *GE &CONTROL) THEN(DLTF +
                          FILE(&DILIB/&ODOBNM))                                           /*260790*/
                 IF         COND(&THISREC *LT &CONTROL) THEN(DO)                          /*260790*/
                      CHGVAR     VAR(&COUNTA) VALUE(&THISREC)                             /*260790*/
                      CHGVAR     VAR(&SAVF_NAME) VALUE('IR' *CAT &COUNTA)                 /*260790*/
                      CHGSAVF    FILE(&DILIB/&SAVF_NAME) TEXT(&SAVFTEXT)                  /*260790*/
                 ENDDO                                                                    /*260790*/
             ENDDO                                                                        /*260790*/
             ELSE       CMD(DO)
             SNDPGMMSG  MSG('File' *BCAT &ODOBNM *BCAT 'with +
                          attribute' *BCAT &ODOBAT *BCAT 'found in' +
                          *BCAT &DILIB) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
             GOTO       CMDLBL(START_LOOP)
END_LOOP:
                                                                                          /*CRE026*/
/** Delete old save files */                                                              /*CRE026*/
/** If Switchable feature CRE026 is *on */                                                /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&CRE026 *EQ 'Y') THEN(DO)                                    /*CRE026*/
                                                                                          /*CRE026*/
/** Attempt to delete save file SAV_EQ_RCV */                                             /*CRE026*/
                                                                                          /*CRE026*/
             DLTF       FILE(QTEMP/SAV_EQ_RCV)                                            /*CRE026*/
             MONMSG     MSGID(CPF2105)                                                    /*CRE026*/
                                                                                          /*CRE026*/
/** Write a list of all journal receivers save files */                                   /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&DILIB) VALUE(&SYSID *CAT 'DILIB')                            /*CRE026*/
                                                                                          /*CRE026*/
             DSPOBJD    OBJ(&DILIB/EQ*) OBJTYPE(*FILE) +
                         OUTPUT(*OUTFILE) OUTFILE(QTEMP/SAV_EQ_RCV)                       /*CRE026*/
                                                                                          /*CRE026*/
             MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(END_LOOP1))                       /*CRE026*/
                                                                                          /*CRE026*/
/** Delete all journal receiver save files */                                             /*CRE026*/
                                                                                          /*CRE026*/
             OVRDBF     FILE(QADSPOBJ) TOFILE(SAV_EQ_RCV)                                 /*CRE026*/
                                                                                          /*CRE026*/
 STRT_LOOP1: RCVF                                                                         /*CRE026*/
                                                                                          /*CRE026*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END_LOOP1))                       /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&ODOBAT *EQ 'SAVF') THEN(DLTF +
                          FILE(&DILIB/&ODOBNM))                                           /*CRE026*/
                          ELSE       CMD(DO)                                              /*CRE026*/
                                                                                          /*CRE026*/
             SNDPGMMSG  MSG('File' *BCAT &ODOBNM *BCAT 'with +
                                       attribute' *BCAT &ODOBAT *BCAT 'found in' +
                                       *BCAT &DILIB) TOMSGQ(MOPERQ)                       /*CRE026*/
                                                                                          /*CRE026*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CRE026*/
             ENDDO                                                                        /*CRE026*/
             GOTO       CMDLBL(STRT_LOOP1)                                                /*CRE026*/
                                                                                          /*CRE026*/
/** Enddo for Switchable feature is *on */                                                /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
END_LOOP1:                                                                                /*CRE026*/
/**/
/**************************************************************/
/*                                                            */
/* S A V E   J O U R N A L   R E C E I V E R S                */
/*                                                            */
/**************************************************************/
/**/
/* Obtain the ASP for save files via CB0602X */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))
/**/
/* Initialise sequence no. of journal receiver to be saved */
/**/
/************CHGVAR*****VAR(&COUNT)*VALUE(001)**********************************************CSC020*/
             RTVDTAARA  DTAARA(JNSTAT (13 8)) RTNVAR(&COUNTA)                             /*CSC020*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNTA)                                        /*CSC020*/
/**********  CHGVAR     VAR(&COUNT) VALUE(&CONTROL)        */                /*260790*/ /*BUG27440*/
             IF         COND(&FLEMPTY *EQ 'N') THEN(CHGVAR +
                          VAR(&COUNT) VALUE(&CONTROL))                                  /*BUG27440*/
/**/
/* Set sequence no. of last journal receiver to be saved   */
/* to sequence no.  of journal receiver attached - 1       */
/**/
/************CHGVAR*****VAR(&LAST_RECV) VALUE(&LSAV)****************************************CSC020*/
             CHGVAR     VAR(&LAST_RECV) VALUE(&LSAV - 1)                                  /*CSC020*/
             IF         COND(&LAST_RECV *LT &COUNT) THEN(GOTO +
                          CMDLBL(ENDSAVE))                                                /*CSC020*/
/**/
 SAVE:
/*/COPY WNCPYSRC,SCC2449005                                          */
             CHGVAR     VAR(&COUNTA) VALUE(&COUNT)
/**********  CHGVAR     VAR(&SAVF_NAME) VALUE('ICRCV' *CAT &COUNTA)                         CSC020*/
             CHGVAR     VAR(&SAVF_NAME) VALUE('IR' *CAT &COUNTA)                          /*CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('save file for +
                          Auto COB') ASP(*LIBASP)                                         /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('save file for +
                          Auto COB') ASP(&ASP)
             ENDDO                                                                        /*CSC043*/
/**/
/**********  SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +
/**********               OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME)                        /*192731*/
/**********  SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +      */        /*192731*/ /*207764*/
/**********               OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) + */        /*192731*/ /*207764*/
/**********               USEOPTBLK(*NO)                             */        /*192731*/ /*207764*/
             SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +
                          OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*207764*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                                    /*193382*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - Save file for Auto COB')                                    /*193382*/
             CHGSAVF    FILE(&DILIB/&SAVF_NAME) TEXT(&SAVFTEXT)                           /*193382*/
/**/
/* Continue saving receivers until all except current one saved      */
/**/
             IF         COND(&LAST_RECV *LE &COUNT) THEN(GOTO +
                          CMDLBL(ENDSAVE))
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             GOTO       CMDLBL(SAVE)
/*/COPY WNCPYSRC,SCC2449006                                          */
/**/
ENDSAVE:
/**/
/* Amend position 69 on JNSTAT  to 'N' to allow futher */
/* journal change processing                           */
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/*  Update JNSTAT with next receiver to be saved.                       CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*CCB009*/
             CHGVAR     VAR(&COUNTA) VALUE(&COUNT)                    /*CCB009*/
/**********  CHGDTAARA  DTAARA(JNSTAT (16 3)) VALUE(&COUNTA)            CCB009              CSC020*/
             CHGDTAARA  DTAARA(JNSTAT (13 8)) VALUE(&COUNTA)                              /*CSC020*/
             ENDDO                                                    /*CCB009*/
                                                                                          /*CRE026*/
/** Save journal receivers */                                                             /*CRE026*/
/** If Switchable feature CRE026 is *on */                                                /*CRE026*/
             IF        COND(&CRE026 *EQ 'Y') THEN(DO)                                     /*CRE026*/
                                                                                          /*CRE026*/
/** Initialise sequence no. of journal receiver to be saved */                            /*CRE026*/
                                                                                          /*CRE026*/
             RTVDTAARA  DTAARA(EJNSTAT (17 4)) RTNVAR(&ECOUNTA)                           /*CRE026*/
             CHGVAR     VAR(&ECOUNT) VALUE(&ECOUNTA)                                      /*CRE026*/
                                                                                          /*CRE026*/
/** Retrieve seq no. of current Equation journal receiver attached */                     /*CRE026*/
                                                                                          /*CRE026*/
             RTVDTAARA  DTAARA(EJNSTAT) RTNVAR(&EJNSTAT)                                  /*CRE026*/
             CHGVAR     VAR(&ELSAV) VALUE(%SST(&EJNSTAT 7 4))                             /*CRE026*/
             CHGVAR     VAR(&ELSAVA) VALUE(&ELSAV)                                        /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&LAST_RECV) VALUE(&ELSAV - 1)                                 /*CRE026*/
             IF         COND(&LAST_RECV *LT &ECOUNT) THEN(GOTO +
                                     CMDLBL(ENDSAVE1))                                    /*CRE026*/
                                                                                          /*CRE026*/
/** Find the lib where the Equation journal receivers are found */                        /*CRE026*/
                                                                                          /*CRE026*/
             RTVDTAARA  DTAARA(KAPJRN (12 7)) RTNVAR(&EQLIB1)                             /*CRE026*/
             CHGVAR     VAR(&EQLIB)   VALUE(&EQLIB1)                                      /*CRE026*/
             RTVDTAARA  DTAARA(KAPJRN (2 11)) RTNVAR(&EQ_RCV_NAM)                         /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&LAST_RECV *LT &ECOUNT) THEN(GOTO +
                                       CMDLBL(ENDSAVE1))                                  /*CRE026*/
                                                                                          /*CRE026*/
SAVE1:                                                                                    /*CRE026*/
             CHGVAR     VAR(&ECOUNTA) VALUE(&ECOUNT)                                      /*CRE026*/
             CHGVAR     VAR(&COUNTA) VALUE(&ECOUNT)                                       /*CRE026*/
             CHGVAR     VAR(&SAVF_NAME) VALUE('EQ' *CAT &COUNTA)                          /*CRE026*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('save file for +
                                      Auto COB') ASP(*LIBASP)                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('save file for +
                                      Auto COB') ASP(&ASP)                                /*CRE026*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CRE026*/
             SAVOBJ     OBJ(&EQ_RCV_NAM) LIB(&EQLIB) DEV(*SAVF) +
                            OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) +
                             USEOPTBLK(*NO) OUTPUT(*PRINT)                                /*CRE026*/
                                                                                          /*CRE026*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                                    /*CRE026*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                                       ' - Save file for Auto COB')                       /*CRE026*/
                                                                                          /*CRE026*/
             CHGSAVF    FILE(&DILIB/&SAVF_NAME) TEXT(&SAVFTEXT)                           /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&LAST_RECV *LE &ECOUNT) THEN(GOTO +
                             CMDLBL(ENDSAVE1))                                            /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&ECOUNT) VALUE(&ECOUNT + 1)                                   /*CRE026*/
             GOTO       CMDLBL(SAVE1)                                                     /*CRE026*/
                                                                                          /*CRE026*/
ENDSAVE1:                                                                                 /*CRE026*/
             CHGDTAARA  DTAARA(EJNSTAT (69 1)) VALUE('N')                                 /*CRE026*/
                                                                                          /*CRE026*/
/** If Feature CCB009 is 'on' (close of business journaling), */                          /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)                              /*CRE026*/
                                                                                          /*CRE026*/
/** Update EJNSTAT with next receiver to be saved. */                                     /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&ECOUNT) VALUE(&ECOUNT + 1)                                   /*CRE026*/
             CHGVAR     VAR(&ECOUNTA) VALUE(&ECOUNT)                                      /*CRE026*/
             CHGDTAARA  DTAARA(EJNSTAT (17 4)) VALUE(&ECOUNTA)                            /*CRE026*/
                                                                                          /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
/**/
/* Call CB0602U to update COB data fields on CBAICDPD */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETRCV   ')
             CHGVAR     VAR(%SST(&CB_AUTO 83 5)) VALUE('*DISK')
             CHGVAR     VAR(%SST(&CB_AUTO 93 4)) VALUE(%SST(&CB_AUTO +
                          53 56))
             CALL       PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/*/COPY WNCPYSRC,SCC2449007                                          */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
/*/COPY WNCPYSRC,SCC2449008                                          */
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2449 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*/COPY WNCPYSRC,SCC2449009                                          */
 ENDCLPGM:   ENDPGM
/*/COPY WNCPYSRC,SCC2449010                                          */
