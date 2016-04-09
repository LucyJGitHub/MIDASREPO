/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Input cycle report requests no prompt')      */
/*********************************************************************/
/*                                                                   */
/*  Midas - Report Control Facility Module                           */
/*                                                                   */
/*  FCC0202 - I/C REPORT REQUESTS WITHOUT MODULE SPECIFIC PROMPT     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*   Last Amend No. CAAA02             Date 01Dec03                  */
/* Midas Release 4.01.02 --------------------------------------------*/
/*   Prev Amend No. 190072             Date 09Apr02                  */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                  CPK014             Date 14Nov01                  */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  S01408             Date 17SEP96                  */
/*                      S01408           DATE 26JUN96            */
/*                      099929           DATE 31MAY96            */
/*                      076789           DATE 03OCT94            */
/*                      049424           DATE 11JAN93            */
/*                      044847           DATE 23SEP92            */
/*                      RT0032           DATE 14MAY91            */
/*                      S01314           DATE 24APR91            */
/*                      LN1197           DATE 13MAR91            */
/*                      LN1144           DATE 13MAR91            */
/*                      DT0035           DATE 27MAR91            */
/*                      LN0911           DATE 24OCT90            */
/*                      LN0051           DATE 30APR90            */
/*                                                               */
/*****************************************************************/
/*                                                               */
/*   CAAA02 - Webfacing. Change the submit of MIDASRMV to use    */
/*            the *JOBD output queue.                            */
/*   190072 - Re-insert calling of FC0030 to get prompt pgm,     */
/*            call prompt pgm if &PNAM = 'MGC6000' to get        */
/*            Workstation ID, which would be used as passing     */
/*            parameter for FCC0200. Also to be passed onto      */
/*            DLC0211.                                           */
/*       CPK014 - Submit jobs with user *JOBD                    */
/*    S01408 - Core hook FCC0202005 added.                       */
/*    S01408 - Core hook FCC0202004 added.                       */
/*             Core hook FCC0202003 added.                       */
/*             Core hook FCC0202002 added.                       */
/*             Core hook FCC0202001 added.                       */
/*    099929 - Allocate dtaara/REPSEQ exclusively, as            */
/*             sometimes get two jobs updating it with the same  */
/*             value causing duplicate record on FCRREQL0.       */
/*    076789 - Overrides moved to MLC0000                        */
/*    049424 - IBM HAVE RENAMED THE OFFICE FILES AGAIN AT        */
/*             V2R2. THE PROGRAM HAS BEEN AMENDED TO CALL A      */
/*             NEW ACCESS OBJECT AOIBMDR0 WHICH RETURNS THE      */
/*             OBJECT NAME AT THE MACHINE'S PRESENT IBM          */
/*             RELEASE LEVEL FOR OVERRIDE PURPOSES.              */
/*    044847 - OVERRIDE FILES AS THEY HAVEN'T THE SAME NAME ON   */
/*             DIFFERENT VERSIONS OF QUSRSYS.                    */
/*    RT0032 - STRIP OUT ALL EXISTING MULTIPLE LANGUAGE SUPPORT  */
/*             CODE AND REPLACE THE QCMDEXC WITH A SUBMIT OF A   */
/*             NEW PGM FCC0200 WHICH APPLIES THE MULTI-LANGUAGE  */
/*             OVERRIDES. THIS IS NECESSARY BECAUSE AT PRESENT   */
/*             THE OVERRIDES ARE LOST WHEN CALLING QCMDEXC.      */
/*           - REMOVE THE CALL TO FC0030 AS THE INFORMATION      */
/*             OBTAINED IS NEVER USED IN THIS PROGRAM.           */
/*           - AMEND ABNOR PROCESSING MESSAGE TO USE             */
/*             MSGF/GBFCUSRMSG.                                  */
/*    S01314 - CHANGES MADE DURING PTF INCORPORATION             */
/*           - ADDITION OF MULTILANGUAGE OVERRIDES.              */
/*    LN1197 - ADD DEFAULTS FOR OUTQ AND INLLIBL TO SBMJOB CMD   */
/*    LN1144 - ADD COMMENTS TO THE PROGRAM                       */
/*    DT0035 - INLLIBL(*JOBD) ADDED TO ALL SBMJOB CMDS.          */
/*    LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.           */
/*    LN0051 - USE JOB DESCRIPTION MBATCH FOR SUBMITTED JOBS     */
/*                                                               */
/*****************************************************************/
/*                                                               */
/*  THIS PROGRAM WILL CALL PROGRAMS TO DISPLAY THE RELEVANT      */
/*  PROMPT SCREENS TO REQUEST AN INPUT CYCLE REPORT WITH NO      */
/*  MODULE SPECIFIC PROMPT SCREEN AND SUBMIT REQUEST TO BATCH    */
/*                                                               */
/*****************************************************************/
             PGM        PARM(&PGCL &CLSEQ &PGRPG &BRANCH)
    /*                                                               */
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,FCC0202004                                           /*S01408*/
/*                                                                    /*S01408*/
             DCL        VAR(&PGCL) TYPE(*CHAR) LEN(10) /* CL program */
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLSEQ) TYPE(*CHAR) LEN(5)
    /*                                                               */
             DCL        VAR(&PGRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGCL) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10) **/            /*RT0032*/
/************DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100) **/          /*RT0032*/
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)                /*190072*/
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)              /*190072*/
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DISTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&REPSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&REPSEQN) TYPE(*DEC) LEN(5)
/*/COPY WNCPYSRC,FCC0202008                                          */
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,FCC0202009                                          */
/************DCL        VAR(&SUBMPARMS) TYPE(*CHAR) LEN(112) **/      /*RT0032*/
             DCL        VAR(&NEXSEQ) TYPE(*CHAR) LEN(5)
/*           DCL        VAR(&STRING) TYPE(*CHAR) LEN(165)    */ /*LN0051*/
                                                                      /*LN0911*/
/**********  DCL        VAR(&STRING) TYPE(*CHAR) LEN(177)       /*LN0051*/
/**********  DCL        VAR(&STRING) TYPE(*CHAR) LEN(191)             /*DT0035*/
/**********  DCL        VAR(&STRING) TYPE(*CHAR) LEN(206)    /*DT0035* *LN1197*/
/************DCL        VAR(&STRING) TYPE(*CHAR) LEN(218)  /*LN1197*/ /*RT0032*/
                                                                      /*LN0911*/
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&ASP) TYPE(*CHAR) LEN(1) VALUE('''') */   /*RT0032*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)/*S01314*/ /*RT0032*/
/************DCL        VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)/*S01314*/ /*RT0032*/
/************DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)      /*S01314*/ /*RT0032*/
/************DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)    /*S01314*/ /*RT0032*/
/************DCL        VAR(&USER) TYPE(*CHAR) LEN(25)     /*S01314*/ /*RT0032*/
/************DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)     /*S01314*/ /*RT0032*/
/************DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)      /*S01314*/ /*RT0032*/
/************DCL    VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)/*S01314*/ /*RT0032*/
/************DCL        VAR(&MITLG) TYPE(*CHAR) LEN(10)    /*S01314*/ /*RT0032*/
/************DCL        VAR(&MITZLG) TYPE(*CHAR) LEN(10)   /*S01314*/ /*RT0032*/
/************DCL        VAR(&MITCLG) TYPE(*CHAR) LEN(10)   /*S01314*/ /*RT0032*/
/************DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)    /*S01314*/ /*RT0032*/
/************DCL        VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&MACLG) TYPE(*CHAR) LEN(10)    /*S01314*/ /*RT0032*/
/************DCL        VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&WNLG) TYPE(*CHAR) LEN(10)     /*S01314*/ /*RT0032*/
/************DCL        VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*RT0032*/
/************DCL        VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)/*S01314*/ /*RT0032*/
/*/COPY WNCPYSRC,FCC0202010                                          */
             DCL        VAR(&PARMSTRING) TYPE(*CHAR) LEN(101)         /*RT0032*/
/*/COPY WNCPYSRC,FCC0202011                                          */
/************DCL        VAR(&OLDNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)        /*049424*076789*/
/************DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&VALUE) TYPE(*CHAR) LEN(50)        /*049424*076789*/
/************DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)        /*049424*076789*/
/**/                                                                  /*LN1144*/
/*  GLOBAL MONITOR MESSAGE                                            /*LN1144*/
/**/                                                                  /*LN1144*/
/************MONMSG     MSGID(RPG0000) EXEC(GOTO CMDLBL(ABNOR))       /*LN1144*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) +
                        EXEC(GOTO CMDLBL(ABNOR))                      /*LN1144*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,FCC0202005                                           /*S01408*/
/*                                                                    /*S01408*/
 
/**/
/**CHECK*THAT*PROGRAM*IS*RUNNING*ON*IBM*VERSION*2*****/    /*044847*/ /*049424*/
/**IF*ONE*OF*THE*FILES*EXISTS,*THEN*ALL*OF*THEM*WILL**/    /*044847*/ /*049424*/
/**IF*THEY*DO,*THEN*OVERRIDE*THE*FILES****************/    /*044847*/ /*049424*/
/**/                                                                  /*044847*/
/*********** CHKOBJ     OBJ(QAOKDY01) OBJTYPE(*FILE)       /*044847*/ /*049424*/
/*********** MONMSG  MSGID(CPF9801) EXEC(GOTO CMDLBL(MAIN))/*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDP01) TOFILE(QAOKDY01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKLP02) TOFILE(QAOKLY02)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDL01) TOFILE(QAOKDG01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/* CHECK FOR RENAMED IBM FILES AND SETUP OVERRIDES IF NECCESSARY */   /*049424*/
 
/* DETERMINE THE MACHINE OPERATING SYSTEM LEVEL */                    /*049424*/
                                                                      /*049424*/
/******RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)   /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKDP01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDP01)          /*049424*074789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKLP02 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKLP02)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE LF/QAOKDL01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDL01)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
 
 SKIP:                                                                /*044847*/
/************RTVDTAARA  DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10) /*S01314*/ /*RT0032*/
/************RTVDTAARA  DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10) /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/**CALL*SF0410*TO*DETERMINE*USER'S*PREFERRED*LANGUAGE**/   /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/************CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
/************             &ERRORC &MULT)                   /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/**IF*LANGUAGE*CODE*IS*BLANK*THEN*DEFAULT*TO*GB**/         /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/************IF         COND(&MULT *EQ '  ') THEN(DO)      /*S01314*/ /*RT0032*/
/************  CHGVAR     VAR(&MULT) VALUE('GB')           /*S01314*/ /*RT0032*/
/************ENDDO                                         /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**CREATE*THE*MULTILANGUAGE*OBJECT*NAMES**/                /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/*CHGVAR***VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF') /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ')    /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ')   /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ')   /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))    /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))    /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)     /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)     /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')  /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')    /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')  /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')     /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')  /*S01314*/ /*RT0032*/
/*CHGVAR*****VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*S01314*/ /*RT0032*/
/*CHGVAR****VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ') /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/**APPLY*MULTILANGUAGE*OVERRIDES**/                        /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/************OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)     /*S01314*/ /*RT0032*/
/************OVRDBF     FILE(MITEM) MBR(&MITLG) SHARE(*NO) /*S01314*/ /*RT0032*/
/************OVRDBF     FILE(MITEMZZ) MBR(&MITZLG)         /*S01314*/ /*RT0032*/
/************OVRDBF     FILE(MITMC) MBR(&MITCLG)           /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)  /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)  /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)       /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(DRSMM) TOMSGF(&DRSMMLG)       /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(MACMSG) TOMSGF(&MACLG)        /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)    /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(WNMSGF) TOMSGF(&WNLG)         /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)    /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)    /*S01314*/ /*RT0032*/
/************OVRMSGF    MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)  /*S01314*/ /*RT0032*/
                                                                      /*S01314*/
/**/                                                                  /*LN1144*/
/***OBTAIN*THE*NEXT*REPORT*REQUEST*SEQUENCE*NUMBER**********    *LN1144*099929*/
/************                                                  /*LN1144*099929*/
/************RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&REPSEQ)                /*099929*/
    /*                                                               */
    /*                                                               */
    /* Change Phase to 'Input Cycle'                                 */
/*       AND SET THE ACTION CODE TO 'I' FOR INSERT                    /*LN1144*/
    /*                                                               */
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&PHASE) VALUE('I')
             CHGVAR     VAR(&ACTION) VALUE('I')
/**/                                                                  /*LN1144*/
/*  RESET THE NEXT REPORT REQUEST SEQUENCE NUMBER IN THE DATA AREA    /*LN1144*/
/**/                                                                  /*LN1144*/
             ALCOBJ     OBJ((REPSEQ *DTAARA *EXCL)) WAIT(60)          /*099929*/
             RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&REPSEQ)                /*099929*/
             CHGVAR     VAR(&NEXSEQ) VALUE(&REPSEQ)
             CHGVAR     VAR(&REPSEQN) VALUE(&REPSEQ)
             CHGVAR     VAR(&REPSEQN) VALUE(&REPSEQN + 1)
             CHGVAR     VAR(&REPSEQ) VALUE(&REPSEQN)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,FCC0202002                                           /*S01408*/
/*                                                                    /*S01408*/
             CHGDTAARA  DTAARA(REPSEQ) VALUE(&REPSEQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,FCC0202003                                           /*S01408*/
/*                                                                    /*S01408*/
             DLCOBJ     OBJ((REPSEQ *DTAARA *EXCL))                   /*099929*/
    /*                                                               */
/***CALL*FC0030*TO*ACCESS*THE*REPORT*PARAMETERS**/         /*LN1144*/ /*RT0032*/
/***FROM*THE*REPORT*COMPONENT*FILE**/                      /*LN1144*/ /*RT0032*/
/**/                                                                  /*LN1144*/
/************CALL       PGM(FC0030) PARM(&PGRPG &PGCL &CLSEQ &PARMS +
/************             &PNAM) **/                                  /*RT0032*/
    /*                                                               */
/******IF*DATABASE*ERROR*OCCURRED***/                                 /*RT0032*/
    /*                                                               */
/************IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
/************             CMDLBL(DBEND)) **/                          /*RT0032*/
/**/                                                                  /*190072*/
/*  CALL FC0030 TO ACCESS THE REPORT NAME                             /*190072*/
/**/                                                                  /*190072*/
             CALL       PGM(FC0030) PARM(&PGRPG &PGCL &CLSEQ &PARMS +
                          &PNAM)                                      /*190072*/
/**/                                                                  /*190072*/
/*     IF DATABASE ERROR OCCURRED                                     /*190072*/
/**/                                                                  /*190072*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBEND))                              /*190072*/
/**/                                                                  /*190072*/
/*  CALL FC0200 TO SET THE LEVEL OF THE REPORT REQUEST.               /*LN1144*/
/*  IN A SINGLE BRANCH SYSTEM THIS VALUE IS DEFAULTED AND NO SCREEN   /*LN1144*/
/*  WILL BE DISPLAYED.                                                /*LN1144*/
/*  IN A MULTIBRANCHED SYSTEM A REQUEST SCREEN IS DISPLAYED, IF THE   /*LN1144*/
/*  REPORT IS NOT A SYSTEM LEVEL REPORT AND THE USER IS AUTHORISED    /*LN1144*/
/*  TO REQUEST THE REPORT AT OTHER LEVELS.                            /*LN1144*/
/**/                                                                  /*LN1144*/
    /*                                                               */
 
             CALL       PGM(FC0200) PARM(&LEVEL &ENTITY &DISTR &CMD +
                          &PGRPG &NEXSEQ &BRANCH &ACTION)
/**/                                                                  /*LN1144*/
/*  IF DATABASE ERROR OCCURRED                                        /*LN1144*/
/*  EXIT PROGRAM USING DATABASE ERROR PROCESSING                      /*LN1144*/
/**/                                                                  /*LN1144*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))
/**/                                                                  /*LN1144*/
/*     IF F3 IS TAKEN                                                 /*LN1144*/
/*     FROM THE LEVEL REQUEST SCREEN, THEN EXIT THE PROGRAM           /*LN1144*/
/**/                                                                  /*LN1144*/
             IF         COND(&CMD = 'E') THEN(GOTO CMDLBL(THEEND))
    /*                                                               */
/**/                                                                  /*190072*/
/*  CALL THE PROMPT PROGRAM IF &PNAM = 'MGC6000'                      /*190072*/
/**/                                                                  /*190072*/
             IF         COND(&PNAM = 'MGC6000') THEN(DO)              /*190072*/
                CALL       PGM(&PNAM) PARM(&NEXSEQ &LEVEL &ENTITY +
                             &PARAMETERS &ACTION &CMD)                /*190072*/
             ENDDO                                                    /*190072*/
/**/                                                                  /*190072*/
/*  CALL FC0205 TO SET UP THE REPORT OUTPUT INSRUCTIONS.              /*LN1144*/
/*  IF THE USER IS NOT AUTHORISID TO SET THESE,                       /*LN1144*/
/*  THEN NO SCREEN WILL BE DISPLAYED.                                 /*LN1144*/
/**/                                                                  /*LN1144*/
 
             CALL       PGM(FC0205) PARM(&NEXSEQ &LEVEL &ENTITY +
                          &DISTR &PARAMETERS &CMD &PGRPG &PGCL &CLSEQ +
                          &PHASE &ACTION)
 
/**/                                                                  /*LN1144*/
/*  IF A DATABASE ERROR HAS OCCURRED, EXIT PROGRAM USING DATABASE     /*LN1144*/
/*  ERROR PROCESSING.                                                 /*LN1144*/
/**/                                                                  /*LN1144*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,FCC0202001                                           /*S01408*/
/*                                                                    /*S01408*/
/**/                                                                  /*LN1144*/
/*  IF F3 IS TAKEN FROM THE PROMPT PROGRAM (PARAMETER PASSED BACK IS  /*LN1144*/
/*  'E'), THEN EXIT THE PROGRAM.                                      /*LN1144*/
/**/                                                                  /*LN1144*/
                IF         COND(&CMD = 'E') THEN(GOTO +
                             CMDLBL(THEEND))
    /*                                                               */
/***SET*UP*THE*REPORT*REQUEST*PARAMETERS*FOR*THE*SBMJOB*COMMAND *LN1144*RT0032*/
/**/                                                                  /*LN1144*/
/************CHGVAR    VAR(&SUBMPARMS) VALUE(&PARMS *BCAT &ASP *CAT +
/************            &NEXSEQ *CAT &ASP *BCAT &LEVEL *BCAT &ASP +
/************            *CAT &ENTITY *CAT &ASP)                      /*RT0032*/
/**/                                                                  /*LN1144*/
/*  SEND A 'MIDAS' MESSAGE TO MSTATUS TO INDICATE THAT THE REPORT     /*LN1144*/
/*  REQUEST WILL BE RUN AS A BATCH JOB.                               /*LN1144*/
/**/                                                                  /*LN1144*/
                SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/**/                                                                  /*LN1144*/
/***SET*UP*THE*COMMAND*STRING*FOR*THE*QCMDEXC*COMMAND */   /*LN1144*/ /*RT0032*/
/**/                                                                  /*LN1144*/
/***************CHGVAR     VAR(%SST(&STRING 1 6)) VALUE('SBMJOB')     /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 8 4)) VALUE('JOB(')       /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 12 10)) VALUE(&PGCL)      /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 22 9)) VALUE(') CMD(')    /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 31 5)) VALUE('CALL')      /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 37 10)) VALUE(&PGCL)      /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 48 1)) VALUE('(')         /*RT0032*/
/***************CHGVAR     VAR(%SST(&STRING 49 114)) VALUE(&SUBMPARMS)/*RT0032*/
/*              CHGVAR     VAR(%SST(&STRING 163 3)) VALUE('))')    */ /*LN0051*/
                                                                      /*LN0911*/
/*CHGVAR*****VAR(%SST(&STRING 163 15)) VALUE(')) JOBD(MBATCH)')/*LN0051*RT0032*/
/*CHGVAR*****VAR(%SST(&STRING 178 14)) VALUE(' RTGDTA(*JOBD)')        /*RT0032*/
/*CHGVAR*****VAR(%SST(&STRING 192 12)) VALUE(' OUTQ(*JOBD)')   /*LN1197*RT0032*/
/*CHGVAR*****VAR(%SST(&STRING 204 15)) VALUE(' INLLIBL(*JOBD)')/*LN1197*RT0032*/
/******CALL       PGM(QCMDEXC) PARM(&STRING 165)                 */ /*LN0051*/
/***********    CALL       PGM(QCMDEXC) PARM(&STRING 177)           /*LN0051*/
/***************CALL       PGM(QCMDEXC) PARM(&STRING 191)/*LN0051*/ /*DT0035*/
/***********    CALL       PGM(QCMDEXC) PARM(&STRING 206)    /*DT0035* *LN1197*/
/***************CALL       PGM(QCMDEXC) PARM(&STRING 218)  /*LN1197*/ /*RT0032*/
                                                                      /*LN0911*/
/*/COPY WNCPYSRC,FCC0202012                                          */
/*  ADD REPORT PARAMETERS TO PARAMETER STRING  */                     /*RT0032*/
                                                                      /*RT0032*/
             CHGVAR     VAR(%SST(&PARMSTRING 1 100)) +
                          VALUE(&PARAMETERS)                          /*RT0032*/
                                                                      /*RT0032*/
/*  ADD CONTROL CHARACTER TO PROTECT TRAILING BLANKS  */              /*RT0032*/
                                                                      /*RT0032*/
             CHGVAR     VAR(%SST(&PARMSTRING 101 1)) VALUE('@')       /*RT0032*/
/*/COPY WNCPYSRC,FCC0202013                                          */
 
/*  SUBMIT FCC0200 TO APPLY MULTILANGUAGE OVERRIDES AND  */           /*RT0032*/
/*  TO CALL THE REPORT PROGRAM IN BATCH                  */           /*RT0032*/
                                                                      /*RT0032*/
/*/COPY WNCPYSRC,FCC0202006                                          */
/************SBMJOB     CMD(CALL PGM(FCC0200) PARM(&PGCL &NEXSEQ +                        /*CPK014*/
/************             &LEVEL &ENTITY &PARMSTRING &PGRPG +                             /*CPK014*/
/************             &CLSEQ)) JOB(&PGCL) JOBD(MBATCH) +                              /*CPK014*/
/************             OUTQ(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)    /*RT0032*/          /*CPK014*/
             SBMJOB     CMD(CALL PGM(FCC0200) PARM(&PGCL &NEXSEQ +
                          &LEVEL &ENTITY &PARMSTRING &PGRPG +
                          &CLSEQ)) JOB(&PGCL) JOBD(MBATCH) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
 
/*  SUBMIT THE 'MIDASRMV' JOB TO REMOVE THE MESSAGE                   /*LN1144*/
/*  FROM MSTATUS ONCE THE REPORT JOB HAS COMPLETED                    /*LN1144*/
/**/                                                                  /*LN1144*/
/**********     SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) */ /*LN0051*/
/**********     SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) */ /*LN0051*/
                                                                      /*LN0911*/
/**********  SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH)                              /*LN0051*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +       /*DT0035*/
/*************************JOBD(MBATCH) RTGDTA(*JOBD)                  /*DT0035*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)   /*DT0035*/          /*CPK014*/
/**********  SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +     */
/**********               JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +  */
/**********               INLLIBL(*JOBD)                            */         /*CPK014*/ /*CAAA02*/
 
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) OUTQ(*JOBD) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)                                    /*CAAA02*/
 
/************DLTOVR     FILE(QAOKDP01 QAOKLP02 QAOKDL01)       /*044847*076789*/
/************MONMSG     MSGID(CPF0000)                         /*044847*076789*/
/*/COPY WNCPYSRC,FCC0202007                                          */
    /*                                                               */
/*  EXIT THE PROGRAM IF PROCESSING COMPLETES NORMALLY                 /*LN1144*/
/**/                                                                  /*LN1144*/
             GOTO       CMDLBL(THEEND)
    /*                                                               */
    /*                                                               */
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
/**/
 DBEND:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       ABNOR
             ENDDO
    /*                                                              */
    /*                                                              */
/*  ABNORMAL TERMINATION PROCESSING                                   /*LN1144*/
/**/                                                                  /*LN1144*/
/*BNOR:******SNDPGMMSG  MSG('R.C.F INPUT CYCLE REPORT REQUEST - +
/************             Terminated Abnormally') TOPGMQ(*EXT) +
/************             TOMSGQ(MOPERQ) **/                          /*RT0032*/
 ABNOR:      SNDPGMMSG  MSGID(RCF1088) MSGF(FCUSRMSG) +
                          MSGDTA(&NEXSEQ) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*RT0032*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
/**/                                                                  /*LN1144*/
/*  END OF PROGRAM PROCESSING                                         /*LN1144*/
/**/                                                                  /*LN1144*/
 THEEND:     RCLRSC
             DLCOBJ     OBJ((REPSEQ *DTAARA *EXCL))                   /*099929*/
             MONMSG     CPF0000                                       /*099929*/
             ENDPGM
