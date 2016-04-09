/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Save database to save file')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2454 - SAVE DATABASE TO SAVE FILE                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 259085             Date 12Jul12              */
/*       Prev Amend No. CBF002             Date 04Jul11              */
/*                      CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSC033             Date 21May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      103818             Date 25Apr05              */
/*                      CSC023             Date 02Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/*                      CSC012             Date 22Oct01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                    193382             Date 09May01                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 01NOV96              */
/*                      S01408             DATE 17OCT96              */
/*                      092823             DATE  1APR96              */
/*                      S01408             DATE 10MAY95              */
/*                      081177             DATE 07MAR95              */
/*                      055513             DATE 17JAN94              */
/*                      S01375             DATE 03APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       259085 - COB Performance Improvement in M+.                 */
/*       CBF002 - BF Infrastructure: Backup and Recovery             */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CSC033 - Include global libraries in database saves.        */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       103818 - With switchable feature CSC001 the data base save  */
/*                moved to ICIFINISH, but the RUNDAT MIDAS is already*/
/*                set at I/C initiation so DBDAY is not correct.     */
/*                ex:if run COB FRI system asks DBMON.               */
/*                Fix incorporated by CER001.                        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*     CSC012 - Addition of a daily DTALIB save.                     */
/*       193382 - Stamp the BOB save savefiles with the Midas        */
/*                rundate.                                           */
/*       S01408 - Addition of Core Hook SCC2454MP9                   */
/*       S01408 - Addition of Core Hook SCC2454MP8                   */
/*       092823 - Does not use 'Create Library' default for          */
/*                authorisation when creating savefiles              */
/*       S01408 - Addition of core hook SCC2454MPS                   */
/*              - Addition of core hook SCC2454MP1                   */
/*              - Addition of core hook SCC2454MP2                   */
/*              - Addition of core hook SCC2454MP3                   */
/*              - Addition of core hook SCC2454MP4                   */
/*              - Addition of core hook SCC2454MP5                   */
/*              - Addition of core hook SCC2454MP6                   */
/*              - Addition of core hook SCC2454MP7                   */
/*     081177 - Use Job Description library list instead of current */
/*              library list when submitting job                    */
/*       055513 - Check U7 to indicate abnormal end of save.         */
/*                This ensures correct status sent to calling pgm.   */
/*       S01375 - Auto COB amendments                                */
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
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&XDAT) TYPE(*DEC) LEN(5 0)                                    /*103818*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)                                 /*103818*/
/**/
/* BOB savfile name                */
/**/
             DCL        VAR(&BOB_SAVF) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BOB_SAVF2) TYPE(*CHAR) LEN(10)                               /*CSC012*/
             DCL        VAR(&BOB_SAVF3) TYPE(*CHAR) LEN(10)                               /*CSC033*/
             DCL        VAR(&BOB_SAVF4) TYPE(*CHAR) LEN(10)                               /*CSC033*/
             DCL        VAR(&SAVFTEXT) TYPE(*CHAR) LEN(50)                                /*193382*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)                                  /*193382*/
             DCL        VAR(&CSC001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC033*/
             DCL        VAR(&PRUND) TYPE(*DEC) LEN(6 0)                                   /*CSC033*/
             DCL        VAR(&PARUND) TYPE(*CHAR) LEN(7)                                   /*CSC033*/
             DCL        VAR(&DFIN) TYPE(*CHAR) LEN(1)                                     /*CSC033*/
/**/
/* ASP for sav files                         */
/**/
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)
/**/
/* Dual receiver indicator                   */
/**/
             DCL        VAR(&DUAL) TYPE(*CHAR) LEN(1)
/**/
/* user defined journal entry                */
/**/
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
/**/
/* Submit save batch job                     */
/**/
             DCL        VAR(&SBMJOB) TYPE(*CHAR) LEN(4)
/**/
/* Parameters for SCC1767                    */
/**/
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                                  /*CSC012*/
             DCL        VAR(&GMLIB) TYPE(*CHAR) LEN(10)                                   /*CSC033*/
             DCL        VAR(&GTALIB) TYPE(*CHAR) LEN(10)                                  /*CSC033*/
             DCL        VAR(&SAVE_TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE_FILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SAVE_FILE2) TYPE(*CHAR) LEN(20)                              /*CSC012*/
             DCL        VAR(&SAVE_FILE3) TYPE(*CHAR) LEN(20)                              /*CSC033*/
             DCL        VAR(&SAVE_FILE4) TYPE(*CHAR) LEN(20)                              /*CSC033*/
             DCL        VAR(&DEVICE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VOLID) TYPE(*CHAR) LEN(5)
                                                                                          /*CSC011*/
/** Variable for SAR CSC011 */                                                            /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC011*/
                                                                                          /*CSC011*/
/** Parameters for AOSARDR0 */                                                            /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CSC011*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CSC011*/
             DCL        VAR(&GLOBAL) TYPE(*CHAR) LEN(1)                                   /*CSC033*/
             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)                                   /*CSC033*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
             DCL        VAR(&PRFK) TYPE(*CHAR) LEN(3) VALUE('   ')                        /*CBF002*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/*/COPY SDCPYSRC,SDSVALDCL                                                                /*CSC033*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MPS                                          */
                                                                      /*S01408*/
/**/
/* Global error trap                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNORMAL)
                                                                                          /*CSC011*/
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
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&SARD) VALUE('CSC011')                                        /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                       /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTNC *NE '       ' *AND &RTNC *NE +
                          '*NRF   ') THEN(DO)                                             /*CSC011*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in AOSARDR0')                                            /*CSC011*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC011*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC011*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC011) VALUE('Y'))                                        /*CSC011*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SCC2454003                                          */
/**/
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             SNDPGMMSG  MSG('End of Day Backup executing') +
                          TOMSGQ(MOPERQ MRUNQ)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP7                                          */
                                                                      /*S01408*/
/**/
/* Obtain the auto COB information via CB0602X */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
/**                                                                */                     /*103818*/
/** Check if CSC001 is there                                       */                     /*103818*/
/**                                                                */                     /*103818*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*103818*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*103818*/
             CHGVAR     VAR(&SARD) VALUE('CSC001')                                        /*103818*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                       /*103818*/
             IF         COND(&RTNC *EQ '       ') THEN(DO)                                /*103818*/
             CHGVAR     VAR(&CSC001) VALUE('Y')                                           /*CSC033*/
/**                                                                */                     /*103818*/
/** Retrieve previous RUNDAT from JNSTAT and call CB0602W          */                     /*103818*/
/** which is a new program to format the day                       */                     /*103818*/
/**                                                                */                     /*103818*/
             CALL SCJNSTAT PARM(&XDAT)                                                    /*103818*/
             CALL CB0602W PARM(&CB_RTN_CDE &CB_AUTO &XDAT)                                /*103818*/
/**                                                                */                     /*CSC033*/
/** Format the retrieved prev rundate &XDAT into DDMMMYY format.   */                     /*CSC033*/
/** Obtain date format indicator                                   */                     /*CSC033*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                                    /*CSC033*/
             CHGVAR  VAR(&DFIN) VALUE(%SST(&RUNDAT 12 1))                                 /*CSC033*/
             CALL PGM(ZDATE2) PARM(&XDAT &DFIN &PRUND &PARUND)                            /*CSC033*/
/**                                                                */                     /*CSC033*/
             ENDDO                                                                        /*103818*/
/**/                                                                                      /*103818*/
/* Determine BOB savefile name        */
/**/
             CHGVAR     VAR(&BOB_SAVF) VALUE(%SST(&CB_AUTO 61 5))
/**/
/* Determine library containing BOB savefile */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&LIB) VALUE(&SYSID *CAT 'DILIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP1                                          */
                                                                      /*S01408*/
/**/
/* Attempt to delete BOB save savfiles */
/**/
             CHGVAR     VAR(&BOB_SAVF2) VALUE(&BOB_SAVF *CAT 'DTA')                       /*CSC012*/
             DLTF       FILE(&LIB/&BOB_SAVF)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&LIB/&BOB_SAVF2)                                             /*CSC012*/
             MONMSG     MSGID(CPF2105)                                                    /*CSC012*/
/**/
/* Create BOB save files in ASP defined in data variable &CB_AUTO */
/**/
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))
/********    CRTSAVF    FILE(&LIB/&BOB_SAVF) TEXT('BOB save file for +
                          Auto COB') ASP(&ASP)                        /*092823*/
/**********  CRTSAVF    FILE(&LIB/&BOB_SAVF) TEXT('BOB save file for +         /*092823*/ /*193382*/
/**********               Auto COB') ASP(&ASP) AUT(*LIBCRTAUT)                 /*092823*/ /*193382*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                                    /*193382*/
/**********  CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +                     /*CSC012*/
/**********               ' - BOB save file for Auto COB')                     /*193382*/ /*CSC012*/
/**/                                                                                      /*CSC033*/
             IF         COND(&CSC001 *EQ 'Y') THEN(DO)                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(&PARUND *CAT +
                          ' - BOB DMLIB save file for Auto COB')                          /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE (DO)                                                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - BOB DMLIB save file for Auto COB')                          /*CSC012*/
             ENDDO                                                                        /*CSC033*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF) TEXT(&SAVFTEXT) +
                          ASP(*LIBASP) AUT(*LIBCRTAUT)                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF) TEXT(&SAVFTEXT) +
                          ASP(&ASP) AUT(*LIBCRTAUT)                                       /*193382*/
             ENDDO                                                                        /*CSC043*/
/**/                                                                                      /*CSC033*/
             IF         COND(&CSC001 *EQ 'Y') THEN(DO)                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(&PARUND *CAT +
                          ' - BOB DTALIB save file for Auto COB')                         /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE (DO)                                                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - BOB DTALIB save file for Auto COB')                         /*CSC012*/
             ENDDO                                                                        /*CSC033*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF2) TEXT(&SAVFTEXT) +
                          ASP(*LIBASP) AUT(*LIBCRTAUT)                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF2) TEXT(&SAVFTEXT) +
                          ASP(&ASP) AUT(*LIBCRTAUT)                                       /*CSC012*/
             ENDDO                                                                        /*CSC043*/
/**/
/* Save the database library                     */
/**/
             CHGVAR     VAR(&library) VALUE(&SYSID *CAT 'DMLIB')
             CHGVAR     VAR(&DTALIB) VALUE(&SYSID *CAT 'DTALIB')                          /*CSC012*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP2                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&save_type) VALUE('DISK')
/**/
             CHGVAR     VAR(&SAVE_FILE) VALUE('DBxxx     xxDILIB   ')
             CHGVAR     VAR(%SST(&SAVE_FILE 1 5)) VALUE(&BOB_SAVF)
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)
             CHGVAR     VAR(&SAVE_FILE2) VALUE('DBxxxDTA  xxDILIB   ')                    /*CSC012*/
             CHGVAR     VAR(%SST(&SAVE_FILE2 1 5)) VALUE(&BOB_SAVF)                       /*CSC012*/
             CHGVAR     VAR(%SST(&SAVE_FILE2 11 2)) VALUE(&SYSID)                         /*CSC012*/
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
             CALL       PGM(AOSVALR0) PARM(&RTNC 'BrgMidasGlobalPrefix' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)                                /*CSC033*/
/**/                                                                                      /*CSC033*/
/* If there is an error finding system values, then end abnormally.                       /*CSC033*/
/**/                                                                                      /*CSC033*/
                IF         COND(&RTNC *NE '       ') THEN(GOTO +
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
             CHGVAR     VAR(&BOB_SAVF3) VALUE(%SST(&CB_AUTO 61 5) *TCAT 'GM')             /*CSC033*/
             CHGVAR     VAR(&BOB_SAVF4) VALUE(%SST(&CB_AUTO 61 5) *TCAT 'GTA')            /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Attempt to delete Beginning of Business save file names for global libraries.          /*CSC033*/
/**/                                                                                      /*CSC033*/
             DLTF       FILE(&LIB/&BOB_SAVF3)                                             /*CSC033*/
             MONMSG     MSGID(CPF2105)                                                    /*CSC033*/
             DLTF       FILE(&LIB/&BOB_SAVF4)                                             /*CSC033*/
             MONMSG     MSGID(CPF2105)                                                    /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Create BOB save files in ASP defined in data variable &CB_AUTO                         /*CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&CSC001 *EQ 'Y') THEN(DO)                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(&PARUND *CAT +
                          ' - BOB GMLIB save file for Auto COB')                          /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE (DO)                                                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - BOB GMLIB save file for Auto COB')                          /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF3) TEXT(&SAVFTEXT) +
                          ASP(*LIBASP) AUT(*LIBCRTAUT)                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF3) TEXT(&SAVFTEXT) +
                          ASP(&ASP) AUT(*LIBCRTAUT)                                       /*CSC033*/
             ENDDO                                                                        /*CSC043*/
/**/                                                                                      /*CSC033*/
             IF         COND(&CSC001 *EQ 'Y') THEN(DO)                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(&PARUND *CAT +
                          ' - BOB GTALIB save file for Auto COB')                         /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE (DO)                                                                    /*CSC033*/
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - BOB GTALIB save file for Auto COB')                         /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF4) TEXT(&SAVFTEXT) +
                          ASP(*LIBASP) AUT(*LIBCRTAUT)                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&LIB/&BOB_SAVF4) TEXT(&SAVFTEXT) +
                          ASP(&ASP) AUT(*LIBCRTAUT)                                       /*CSC033*/
             ENDDO                                                                        /*CSC043*/
/**/                                                                                      /*CSC033*/
/*  Calculate names of save files for global libraries.                                   /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&SAVE_FILE3) VALUE('DBxxxGM   xxDILIB   ')                    /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE3 1 10)) VALUE(&BOB_SAVF3)                     /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE3 11 2)) VALUE(&SYSID)                         /*CSC033*/
             CHGVAR     VAR(&SAVE_FILE4) VALUE('DBxxxGTA  xxDILIB   ')                    /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE4 1 10)) VALUE(&BOB_SAVF4)                     /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE4 11 2)) VALUE(&SYSID)                         /*CSC033*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP3                                          */
                                                                      /*S01408*/
/**/
             CHGVAR     VAR(&DEVICE) VALUE('          ')
             CHGVAR     VAR(&VOLID) VALUE(&BOB_SAVF)
/**/
/* Save the DMLIB */                                                                      /*CSC012*/
                                                                                          /*CSC012*/
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)
/**/
/************IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)          */ /*055513*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)             /*055513*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   CHGJOB     SWS(XXXXXX11)
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
/*/COPY WNCPYSRC,SCC2454001                                          */
/**********  ELSE       CMD(SNDPGMMSG MSG('Database save completed + */                   /*CSC012*/
/**********               successfully') TOMSGQ(MOPERQ MRUNQ))       */                   /*CSC012*/
             ELSE       CMD(SNDPGMMSG MSG('DMLIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC012*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
             CHGDTAARA  DTAARA(SCSUPP (3 4)) VALUE(&SAVE_TYPE)                            /*CSC011*/
             CHGDTAARA  DTAARA(SCSUPP (7 10)) VALUE(&BOB_SAVF)                            /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC012*/
/* Save the DTALIB */                                                                     /*CSC012*/
                                                                                          /*CSC012*/
             CALL       PGM(SCC1767) PARM(&DTALIB &SAVE_TYPE +
                          &SAVE_FILE2 &DEVICE &VOLID)                                     /*CSC012*/
                                                                                          /*CSC012*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*CSC012*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                                             /*CSC012*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC012*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC012*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC012*/
             ENDDO                                                                        /*CSC012*/
             ELSE       CMD(SNDPGMMSG MSG('DTALIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC012*/
/**/                                                                                      /*CSC033*/
/** Call SCC000303 to perform BF database backup */                                       /*CBF002*/
/** save BF schemas found in Schemas/Libraries file */                                    /*CBF002*/
                                                                                          /*CBF002*/
/** Changes in parameter values for SAVLIB and SAVSAVFDTA */                              /*CBF002*/
/** commands requires an update in SCSVPRMPD file also */                                 /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVE_TYPE *EQ 'TAPE') THEN(DO)                              /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('011')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVE_TYPE *EQ 'DISK') THEN(DO)                              /*CBF002*/
              CHGVAR     VAR(&PRFK) VALUE('013')                                          /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVE_TYPE *EQ 'SAVF') THEN(DO)                              /*CBF002*/
              CHGVAR     VAR(&PRFK) VALUE('016')                                          /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CBF002*/
             CALL       PGM(SCC000303) PARM(&RTNC &PRFK)                                  /*CBF002*/
                                                                                          /*CBF002*/
/** If error during save, end program */                                                  /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&RTNC *NE '       ') THEN(DO)                                /*CBF002*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CBF002*/
               GOTO       CMDLBL(ENDCLPGM)                                                /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
/* If save of global libraries is required,                                               /*CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)
/**/                                                                                      /*CSC033*/
/* Save the global GMLIB                                                                  /*CSC033*/
/**/                                                                                      /*CSC033*/
             CALL       PGM(SCC1767) PARM(&GMLIB &SAVE_TYPE +
                          &SAVE_FILE3 &DEVICE &VOLID)                                     /*CSC033*/
                                                                                          /*CSC033*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*CSC033*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                                             /*CSC033*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC033*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC033*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE       CMD(SNDPGMMSG MSG('GMLIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Save the global GTALIB                                                                 /*CSC033*/
/**/                                                                                      /*CSC033*/
             CALL       PGM(SCC1767) PARM(&GTALIB &SAVE_TYPE +
                          &SAVE_FILE4 &DEVICE &VOLID)                                     /*CSC033*/
                                                                                          /*CSC033*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*CSC033*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                                             /*CSC033*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)                     /*CSC033*/
                   CHGJOB     SWS(XXXXXX11)                                               /*CSC033*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CSC033*/
             ENDDO                                                                        /*CSC033*/
             ELSE       CMD(SNDPGMMSG MSG('GTALIB save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))                            /*CSC033*/
                                                                                          /*CBF002*/
/** Call SCC000303 to perform BF database backup                                          /*CBF002*/
/** save global libraries in the Schemas/Libraries File                                   /*CBF002*/
                                                                                          /*CBF002*/
/** Changes in parameter values for SAVLIB and SAVSAVFDTA */                              /*CBF002*/
/** commands requires an update in SCSVPRMPD file also */                                 /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVE_TYPE *EQ 'TAPE') THEN(DO)                              /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('012')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVE_TYPE *EQ 'DISK') THEN(DO)                              /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('014')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVE_TYPE *EQ 'SAVF') THEN(DO)                              /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('017')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CBF002*/
             CALL       PGM(SCC000303) PARM(&RTNC &PRFK)                                  /*CBF002*/
                                                                                          /*CBF002*/
/** If error during save, end program */                                                  /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&RTNC *NE '       ') THEN(DO)                                /*CBF002*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CBF002*/
               GOTO       CMDLBL(ENDCLPGM)                                                /*CBF002*/
             ENDDO                                                                        /*CBF002*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
 
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP9                                    */     /*S01408*/
/**/                                                                  /*S01408*/
/**/
/**************************************************************/
/*                                                            */
/* P E R F O R M   P R O C E S S I N G   S P E C I F I C      */
/* T O   D U A L  R E C E I V E R   S Y S T E M S             */
/*                                                            */
/**************************************************************/
/**/
             RTVDTAARA  DTAARA(JNSTAT (80 1)) RTNVAR(&DUAL)
/**********  IF         COND(&DUAL *EQ 'N') THEN(GOTO CMDLBL(COMMON))  */                 /*259085*/
/**/                                                                                      /*259085*/
/** Process dual save only when DUAL ind is 'Y' */                                        /*259085*/
/**/                                                                                      /*259085*/
             IF         COND(&DUAL *NE 'Y') THEN(GOTO CMDLBL(COMMON))                     /*259085*/
/**/
/**/
/* Attempt to delete savfile JNSAV */
/**/
             DLTF       FILE(&LIB/JNSAV)
             MONMSG     MSGID(CPF2105)
/**/
/* Create save file JNSAV in ASP defined in data variable &CB_AUTO */
/**/
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))
/********    CRTSAVF    FILE(&LIB/JNSAV) TEXT('Journal Library Save +
                          for recovery purposes') ASP(&ASP)           /*092823*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&LIB/JNSAV) TEXT('Journal Library Save +
                          for recovery purposes') ASP(*LIBASP) +
                          AUT(*LIBCRTAUT)                                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&LIB/JNSAV) TEXT('Journal Library Save +
                          for recovery purposes') ASP(&ASP) +
                          AUT(*LIBCRTAUT)                             /*092823*/
             ENDDO                                                                        /*CSC043*/
/**/
/* Save the database library                     */
/**/
             CHGVAR     VAR(&library) VALUE(&SYSID *cat 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP4                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&save_type) VALUE('DISK')
/**/
             CHGVAR     VAR(&SAVE_FILE) VALUE('JNSAV     xxDILIB   ')
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP5                                          */
                                                                      /*S01408*/
/**/
             CHGVAR     VAR(&DEVICE) VALUE('          ')
             CHGVAR     VAR(&VOLID) VALUE(JNSAV)
/**/
             CALL       PGM(SCC1767) PARM(&library &save_type &SAVE_FILE +
                          &DEVICE &VOLID)
/**/
/************IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)          */ /*055513*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)             /*055513*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   CHGJOB     SWS(XXXXXX11)
                   GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ELSE       CMD(SNDPGMMSG MSG('Journal library save +
                          completed successfully') TOMSGQ(MOPERQ +
                          MRUNQ))
/**/
/**************************************************************/
/*                                                            */
/* C O M M O N   P R O C E S S I N G                          */
/*                                                            */
/**************************************************************/
/**/
/* Format user defined 'SV' entry for the journal */
/**/
COMMON:
             CHGVAR     VAR(%SST(&JRNE 1 5)) VALUE(&BOB_SAVF)
             CHGVAR     VAR(%SST(&JRNE 6 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SST(&JRNE 8 5)) VALUE('DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP6                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(%SST(&JRNE 26 4)) VALUE('DISK')
/**/
/* Output user defined 'SV' entry to the journal */
/**/
/*/COPY WNCPYSRC,SCC2454004                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/*/COPY WNCPYSRC,SCC2454005                                          */
/**/
/* Call CB0602U to update COB data fields on CBAICDPD */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETDB    ')
             CHGVAR     VAR(%SST(&CB_AUTO 88 5)) VALUE('*DISK')
             CHGVAR     VAR(%SST(&CB_AUTO 93 4)) VALUE(%SST(&CB_AUTO +
                          53 56))
             CHGVAR     VAR(%SST(&CB_AUTO 107 5)) VALUE(&BOB_SAVF)
             CALL       PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/**/
/**************************************************************/
/*                                                            */
/* S U B M I T  S A V E  L I B R A R Y   J O B                */
/*                                                            */
/**************************************************************/
/**/
/* Check &CB_AUTO for submit batch job flag         */
/**/
             CHGVAR     VAR(&SBMJOB) VALUE(%SST(&CB_AUTO 57 4))
/**/
             IF         COND(&SBMJOB *EQ '*YES') THEN(DO)
/*/COPY WNCPYSRC,SCC2454002                                          */
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +
/************             JOBD(SAVEJOBD) RTGDTA(*JOBD)                /*081177*/
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CPK014*/
/************             JOBD(SAVEJOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) /*081177*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CSC023*/
/************             JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +                      /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +
                          JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO
 
/*/COPY WNCPYSRC,SCC2454006                                          */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SCC2454MP8                                          */
/*                                                                    /*S01408*/
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
/*/COPY WNCPYSRC,SCC2454007                                          */
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
/**/
/*/COPY WNCPYSRC,SCC2454008                                          */
 ENDCLPGM:   ENDPGM
/*/COPY WNCPYSRC,SCC2454009                                          */
