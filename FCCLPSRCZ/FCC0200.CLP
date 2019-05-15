/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FC I/c report requests batch program')          */
/*********************************************************************/
/*                                                                   */
/*      Midas - Report Control Facility Module                       */
/*                                                                   */
/*      FCC0200 - APPLY OVERRIDES FOR I/C REPORTS.                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR316373           Date 03Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      256873             Date 26Sep08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      235634             Date 27Jul06              */
/*                      240891             Date 04Aug06              */
/*                      CSF002             Date 11Aug03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC014             Date 11Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPB001             Date 17Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                     CPL002                DATE 08MAR99            */
/*                     CUT004                Date 08OCT98            */
/*                     091591                DATE 19OCT95            */
/*                     S01486                DATE 20JUN94            */
/*                     S01498                DATE 20JUN93            */
/*                     S01522                DATE 25NOV94            */
/*                     S01435                DATE 16SEP93            */
/*                     S01463                DATE 21JAN94            */
/*                     061289                DATE 28SEP93            */
/*                     S01401                DATE 15MAR93            */
/*                     S01407                DATE 18MAR93            */
/*                     S01379                DATE 23SEP92            */
/*                     E30666                DATE 29OCT91            */
/*                     S01343                DATE 15AUG91            */
/*                     E27199                DATE 09AUG91            */
/*                     RT0032                DATE 14MAY91            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR316373 - Recompile due to change in /COPY MLCOVRDCL and   */
/*                  MLCOVROVR.                                       */
/*       256873 - Recompiled to resolve the authority problem.       */
/*       235634 - Same as 240891.                                    */
/*       240891 - Apply fix 240478.                                  */
/*       CSF002 - Global layer.                                      */
/*              - Remove MITEM* overrides.                           */
/*      CSC014  -  Allow support for DBCS (Recompiled)               */
/*      CPB001  -  Private Banking Module (Recompiled)               */
/*       CPL002 - Midas / Plato Interface Enhancement (Recompiled)   */
/*      CUT004  -  Allow Core and Non-Core mode of multilanguage     */
/*                 compiles of display files                         */
/*      091591  -  OVRMSGF REUSRMSG MISSING                          */
/*      S01486  -  PORTFOLIO MANAGEMENT                              */
/*      S01498  -  PORTFOLIO LENDING - LOMBARD CREDITS               */
/*      S01522  -  User Defined Correspondence                       */
/*      S01435  -  Incoming Message Management                       */
/*      S01463  -  Add new parameters on call to MLC0000 to match    */
/*                 those added to MLC0000.                           */
/*      061289  -  Add override for message file LERMSGF             */
/*      S01401  -  SWIFT Messages MT5xxs : Add SEUSRMSG to the list  */
/*                 of multiple language support overrides.           */
/*      S01407  -  SWITCHABILITY ENHANCEMENTS                        */
/*                 ADD MESSAGE FILES FOR CLOSE OF BUSINESS (CB) AND  */
/*                 FOR CLIENT MODIFICATIONS (XX)                     */
/*      S01379  -  HISTORY AND AUDIT FACILITY                        */
/*                 ADD MSGF/HFMSGF TO THE LIST OF MULTIPLE           */
/*                 LANGUAGE SUPPORT OVERRIDES.                       */
/*      E30666  -  ENSURE THAT MULTI-LANGUAGE OVERRIDE FOR MITEM     */
/*                 IS NOT DONE BEFORE CALLING SFC0330.               */
/*                 THIS WILL PREVENT OVERRIDES EXISTING AT DIFFERENT */
/*                 & CAUSING AN ERROR WHEN TRYING TO OVERRIDE IN     */
/*                 SFC0330.                                          */
/*      S01343  -  SC/RR/SD MODULE RENAME PROJECT.                   */
/*                 - MLC0000 RENAMED FROM SCC0000                    */
/*      E27199  -  ADD MSGF/MIDASMSG TO THE LIST OF MULTIPLE         */
/*                 LANGUAGE SUPPORT OVERRIDES.                       */
/*      RT0032  -  NEW PROGRAM TO APPLY MULTI-LANGUAGE OVERRIDES     */
/*                 TO I/C REPORT BATCH JOBS.                         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      THIS PROGRAM WILL APPLY THE MULTI-LANGUAGE OVERRIDES BY      */
/*******CALLING*CLP/SCC0000*VIA*QCMDEXC.*THIS*ACTION*WILL*LEAVE****** /*S01343*/
/*      CALLING CLP/MLC0000 VIA QCMDEXC. THIS ACTION WILL LEAVE       /*S01343*/
/*      THE OVERRIDES IN PLACE WHEN THE I/C REPORT PROGRAM IS        */
/*      CALLED VIA QCMDEXC LATER IN THIS PROGRAM.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROGRAM &CHNEXSEQ &LEVEL &ENTITY +
                          &LONGPARMS &PGRPG &CLSEQ)
 
/*  REPORT PROGRAM PROCESSING VARIABLES  */
 
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHNEXSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CSET) TYPE(*CHAR) LEN(1)                                     /*240891*/
/*/COPY WNCPYSRC,FCC0200001                                          */
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PARACOMP) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,FCC0200002                                          */
             DCL        VAR(&PGRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CLSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,FCC0200003                                          */
             DCL        VAR(&LONGPARMS) TYPE(*CHAR) LEN(101)
/*/COPY WNCPYSRC,FCC0200004                                          */
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(260)
             DCL        VAR(&APOST) TYPE(*CHAR) LEN(1) VALUE('''')
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(200)                /*S01463*/
             DCL        VAR(&JOBSWITCH) TYPE(*CHAR) LEN(8)            /*S01463*/
 
/*  MULTIPLE LANGUAGE SUPPORT VARIABLES  */
 
 /***********DCL********VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)             /*CUT004*/
 /***********DCL********VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)             /*CUT004*/
 /***********DCL********VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)      /*S01407 CUT004*/
 /***********DCL********VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)           /*CUT004*/
 /***********DCL********VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)           /*CUT004*/
 /***********DCL********VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10)    /*S01407 CUT004*/
 /***********DCL********VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*CUT004*/
 /***********DCL********VAR(&MITLG) TYPE(*CHAR) LEN(10)               /*CUT004*/
 /***********DCL********VAR(&MITZLG) TYPE(*CHAR) LEN(10)              /*CUT004*/
 /***********DCL********VAR(&MITCLG) TYPE(*CHAR) LEN(10)              /*CUT004*/
 /***********DCL********VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)               /*CUT004*/
 /***********DCL********VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)      /*S01407 CUT004*/
 /***********DCL********VAR(&MIDASLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&MACLG) TYPE(*CHAR) LEN(10)               /*CUT004*/
 /***********DCL********VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&WNLG) TYPE(*CHAR) LEN(10)                /*CUT004*/
 /***********DCL********VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)           /*CUT004*/
 /***********DCL********VAR(&MIDASMSG) TYPE(*CHAR) LEN(10)     /*E27199 CUT004*/
 /***********DCL********VAR(&HFMSGF) TYPE(*CHAR) LEN(10)       /*S01379 CUT004*/
 /***********DCL********VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)      /*S01407 CUT004*/
 /***********DCL********VAR(&GROUP) TYPE(*CHAR) LEN(50)        /*CUT004 CUT004*/
 /***********DCL********VAR(&USER) TYPE(*CHAR) LEN(25)         /*CUT004 CUT004*/
 /***********DCL********VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*CUT004*/
 /***********DCL********VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*CUT004*/
 /***********DCL********VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*CUT004*/
 /***********DCL********VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)             /*CUT004*/
 /***********DCL********VAR(&SEUSRMSG) TYPE(*CHAR) LEN(10)     /*S01401 CUT004*/
 /***********DCL********VAR(&LERMSGF) TYPE(*CHAR) LEN(10)      /*061289 CUT004*/
 /***********DCL********VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10)     /*S01435 CUT004*/
 /***********DCL********VAR(&MEMSG) TYPE(*CHAR) LEN(10)        /*S01435 CUT004*/
 /***********DCL********VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)     /*S01522 CUT004*/
 /***********DCL********VAR(&PMUSRMSG) TYPE(*CHAR) LEN(10)     /*S01486 CUT004*/
 /***********DCL********VAR(&LBUSRMSG) TYPE(*CHAR) LEN(10)     /*S01498 CUT004*/
 /***********DCL********VAR(&REUSRMSG) TYPE(*CHAR) LEN(10)     /*091591 CUT004*/
 
/*/COPY MLCPYSRC,MLCOVRDCL                                         */ /*CUT004*/
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*  GLOBAL MONITOR MESSAGE  */
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*  CREATE DTAARA/LDA  */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('LOCAL DATA AREA FOR FCC0200') AUT(*USE)
             MONMSG     MSGID(CPF1023)
 
/*  RETRIEVE DTAARAS FOR MULTIPLE LANGUAGE SUPPORT  */
 
/************RTVDTAARA**DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)                       /*CUT004*/
/************RTVDTAARA**DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)                       /*CUT004*/
/************RTVDTAARA**DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10)     /*S01407*/        /*CUT004*/
/***********************                                                         /*CUT004*/
/***MULTIPLE*LANGUAGE*SUPPORT -                  */                              /*CUT004*/
/***INITIAL*PROCESSING*FOR USER DEFINED MENUS    */                              /*CUT004*/
/***********************                                                         /*CUT004*/
/************CALL*******PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +          /*CUT004*/
/***********************  &ERRORC &MULT)                                         /*CUT004*/
/***********************                                                         /*CUT004*/
/************IF*********COND(&MULT *EQ '  ') THEN(DO)                            /*CUT004*/
/***************CHGVAR**   VAR(&MULT) VALUE('GB')                                /*CUT004*/
/************ENDDO******                                                         /*CUT004*/
/***********************                                                         /*CUT004*/
/***BUILD*MULTIPLE*LANGUAGE SUPPORT OBJECT NAMES  */                             /*CUT004*/
/***********************                                                         /*CUT004*/
/************CHGVAR*****VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF')          /*CUT004*/
/************CHGVAR*****VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ')               /*CUT004*/
/************CHGVAR*****VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ')              /*CUT004*/
/************CHGVAR*****VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ')              /*CUT004*/
/************CHGVAR*****VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))               /*CUT004*/
/************CHGVAR*****VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))               /*CUT004*/
/************CHGVAR*****VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8)) /*S01407*/    /*CUT004*/
/************CHGVAR*****VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)                /*CUT004*/
/************CHGVAR*****VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)                /*CUT004*/
/************CHGVAR*****VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8) /*S01407*/     /*CUT004*/
/************CHGVAR*****VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')             /*CUT004*/
/************CHGVAR*****VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')             /*CUT004*/
/************CHGVAR*****VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')               /*CUT004*/
/************CHGVAR*****VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')             /*CUT004*/
/************CHGVAR*****VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')                /*CUT004*/
/************CHGVAR*****VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')             /*CUT004*/
/************CHGVAR*****VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')             /*CUT004*/
/************CHGVAR*****VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ')           /*CUT004*/
/************CHGVAR*****VAR(&FCUSRLG)  VALUE(&MULT *CAT 'FCUSRMSG  ')            /*CUT004*/
/************CHGVAR*****VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ') /*E27199*/ /*CUT004*/
/************CHGVAR*****VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF    ') /*S01379*/ /*CUT004*/
/************CHGVAR*****VAR(&XXUSRLG)  VALUE(&MULT *CAT 'XXUSRMSG  ') /*S01407*/ /*CUT004*/
/************CHGVAR*****VAR(&SEUSRMSG) VALUE(&MULT *CAT 'SEUSRMSG  ') /*S01401*/ /*CUT004*/
/************CHGVAR*****VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF   ')  /*061289*/ /*CUT004*/
/************CHGVAR*****VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') /*S01435*/ /*CUT004*/
/************CHGVAR*****VAR(&MEMSG) VALUE(&MULT *CAT 'MEMSG  ')       /*S01435*/ /*CUT004*/
/************CHGVAR*****VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*S01522*/ /*CUT004*/
/************CHGVAR*****VAR(&PMUSRMSG) VALUE(&MULT *CAT 'PMUSRMSG  ') /*S01486*/ /*CUT004*/
/************CHGVAR*****VAR(&LBUSRMSG) VALUE(&MULT *CAT 'LBUSRMSG  ') /*S01498*/ /*CUT004*/
/************CHGVAR*****VAR(&REUSRMSG) VALUE(&MULT *CAT 'REUSRMSG  ') /*091591*/ /*CUT004*/
                                                                                 /*CUT004*/
/***APPLY*MULTIPLE*LANGUAGE SUPPORT OVERRIDES  */                                /*CUT004*/
/***********************                                                         /*CUT004*/
/************IF********COND(&PROGRAM *NE 'SFC0330') THEN(DO)          /*E30666*/ /*CUT004*/
/************OVRDBF*****FILE(MITEM) MBR(&MITLG) SHARE(*NO)                       /*CUT004*/
/************OVRDBF*****FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO)          /*S01407*/ /*CUT004*/
/************OVRDBF*****FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO)          /*S01407*/ /*CUT004*/
/************OVRDBF*****FILE(MITEMZZ) MBR(&MITZLG)                               /*CUT004*/
/************OVRDBF*****FILE(MITMC) MBR(&MITCLG)                                 /*CUT004*/
/************ENDDO******                                              /*E30666*/ /*CUT004*/
/***********************                                              /*E30666*/ /*CUT004*/
/************OVRMSGF****MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)                           /*CUT004*/
/************OVRMSGF****MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)                        /*CUT004*/
/************OVRMSGF****MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)                        /*CUT004*/
/************OVRMSGF****MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)             /*S01407*/ /*CUT004*/
/************OVRMSGF****MSGF(MIDAS) TOMSGF(&MIDASLG)                             /*CUT004*/
/************OVRMSGF****MSGF(DRSMM) TOMSGF(&DRSMMLG)                             /*CUT004*/
/************OVRMSGF****MSGF(MACMSG) TOMSGF(&MACLG)                              /*CUT004*/
/************OVRMSGF****MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)                          /*CUT004*/
/************OVRMSGF****MSGF(WNMSGF) TOMSGF(&WNLG)                               /*CUT004*/
/************OVRMSGF****MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)                          /*CUT004*/
/************OVRMSGF****MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)                          /*CUT004*/
/************OVRMSGF****MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)                        /*CUT004*/
/************OVRMSGF****MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)                          /*CUT004*/
/************OVRMSGF****MSGF(MIDASMSG) TOMSGF(&MIDASMSG)       /*E27199*/        /*CUT004*/
/************OVRMSGF****MSGF(HFMSGF)   TOMSGF(&HFMSGF)         /*S01379*/        /*CUT004*/
/************OVRMSGF****MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)        /*S01407*/        /*CUT004*/
/************OVRMSGF****MSGF(SEUSRMSG) TOMSGF(&SEUSRMSG)       /*S01401*/        /*CUT004*/
/************OVRMSGF****MSGF(LERMSGF) TOMSGF(&LERMSGF)         /*061289*/        /*CUT004*/
/************OVRMSGF****MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)       /*S01435*/        /*CUT004*/
/************OVRMSGF****MSGF(MEMSG) TOMSGF(&MEMSG)             /*S01435*/        /*CUT004*/
/************OVRMSGF****MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)       /*S01522*/        /*CUT004*/
/************OVRMSGF****MSGF(PMUSRMSG) TOMSGF(&PMUSRMSG)       /*S01486*/        /*CUT004*/
/************OVRMSGF****MSGF(LBUSRMSG) TOMSGF(&LBUSRMSG)       /*S01498*/        /*CUT004*/
/************OVRMSGF****MSGF(REUSRMSG) TOMSGF(&REUSRMSG)       /*091591*/        /*CUT004*/
 
/*/COPY MLCPYSRC,MLCOVROVR                                         */            /*CUT004*/
 
/**********  IF        COND(&PROGRAM *NE 'SFC0330') THEN(DO) */                    /*CUT004 CSF002*/
/**********  DLTOVR     FILE(MITEM)   */                                           /*CUT004 CSF002*/
/**********  DLTOVR     FILE(MITEMJ0) */                                           /*CUT004 CSF002*/
/**********  DLTOVR     FILE(MITEMJ1) */                                           /*CUT004 CSF002*/
/**********  DLTOVR     FILE(MITEMZZ) */                                           /*CUT004 CSF002*/
/**********  DLTOVR     FILE(MITMC)   */                                           /*CUT004 CSF002*/
/**********  ENDDO                    */                                           /*CUT004 CSF002*/
 
/***CALL*SCC0000*TO*SET*UP*MULTIPLE*LANGUAGE*OVERRIDES*FOR*THE***/    /*S01343*/
/*  CALL MLC0000 TO SET UP MULTIPLE LANGUAGE OVERRIDES FOR THE  */    /*S01343*/
/*  QCMDEXC REPORT CALL. BECAUSE THE OVERRIDES ARE BEING SET UP */
/*  BY A PROGRAM CALLED VIA QCMDEXC THEY WILL REMAIN IN PLACE   */
/*  EVEN WHEN CONTROL RETURNS TO FCC0200. THUS WHEN THE REPORT  */
/*  PROGRAM IS CALLED VIA QCMDEXC LATER IN THIS PROGRAM, THE    */
/*  OVERRIDES ARE ALREADY IN PLACE.                             */
 
/*****       CALL       PGM(QCMDEXC) PARM('CALL SCC0000' 12)          /*S01343*/
 
             IF        COND(&PROGRAM *NE 'SFC0330') THEN(DO)          /*E30666*/
/**********  CALL       PGM(QCMDEXC) PARM('CALL MLC0000' 12)   /*S01343*S01463*/
                                                                      /*S01463*/
                CHGVAR     VAR(&CMD) VALUE('CALL MLC0000 +
                             PARM(''RETURN'' '' '' '' '' '' '' '' '' +
                             '' '')')                                 /*S01463*/
                                                                      /*S01463*/
                CALL       PGM(QCMDEXC) PARM(&CMD 60)                 /*S01463*/
                                                                      /*S01463*/
                RTVJOBA    SWS(&JOBSWITCH)                            /*S01463*/
                                                                      /*S01463*/
                IF         COND(%SST(&JOBSWITCH 7 2) *EQ '11') +
                             THEN(GOTO CMDLBL(ABNOR))                 /*S01463*/
                                                                      /*S01463*/
             ENDDO                                                    /*E30666*/
 
/*  CALL FC0030 TO ACCESS THE REPORT PARAMETERS  */
 
             CALL       PGM(FC0030) PARM(&PGRPG &PROGRAM &CLSEQ +
                          &PARMS &PNAM)
 
/*  OBTAIN THE REPORT PROMPT PARAMETER STRING  */
 
/*/COPY WNCPYSRC,FCC0200005                                          */
             CHGVAR     VAR(&PARAMETERS) VALUE(%SST(&LONGPARMS 1 100))
/*/COPY WNCPYSRC,FCC0200006                                          */
 
/*  SETUP CALL COMMAND FOR QCMDEXC  */
 
/*  IF THE REPORT HAS A PROMPT THEN ADD THE PROMPTS TO THE CMD  */
 
             IF         COND(&PARAMETERS *NE &PARACOMP) THEN(DO)
 
                CHGVAR     VAR(&STRING) VALUE('CALL PGM(' *CAT +
                             &PROGRAM *CAT ')' *BCAT 'PARM(' *CAT +
                             &PARMS *BCAT &APOST *CAT &CHNEXSEQ *CAT +
                             &APOST *BCAT &LEVEL *BCAT &APOST *CAT +
                             &ENTITY *CAT &APOST *BCAT &APOST *CAT +
                             &PARAMETERS *CAT &APOST *CAT ')')
 
             ENDDO
 
/*  IF THE REPORT HAS NO PROMPT THEN IGNORE &PARAMETERS  */
 
             IF         COND(&PARAMETERS *EQ &PARACOMP) THEN(DO)
 
                CHGVAR     VAR(&STRING) VALUE('CALL PGM(' *CAT +
                             &PROGRAM *CAT ')' *BCAT 'PARM(' *CAT +
                             &PARMS *BCAT &APOST *CAT &CHNEXSEQ *CAT +
                             &APOST *BCAT &LEVEL *BCAT &APOST *CAT +
                             &ENTITY *CAT &APOST *CAT ')')
 
             IF        COND(&PROGRAM *EQ 'SFC000350') THEN(DO)                            /*240891*/
                CHGVAR     VAR(&STRING) VALUE('CALL PGM(' *CAT +
                             &PROGRAM *CAT ')' *BCAT 'PARM(' *CAT +
                             &PARMS *BCAT &APOST *CAT &CHNEXSEQ *CAT +
                             &APOST *BCAT &APOST *CAT &LEVEL *CAT    +
                             &APOST *BCAT &APOST *CAT &ENTITY *CAT   +
                             &APOST *BCAT &APOST *CAT +
                             &CSET *CAT &APOST *CAT ')')                                  /*240891*/
               ENDDO                                                                      /*240891*/
             ENDDO
 
/*  CALL REPORT PROGRAM VIA QCMDEXC  */
 
             CALL       PGM(QCMDEXC) PARM(&STRING 260)
 
/*  IF THERE HAVE BEEN NO ERRORS UP TO THIS POINT THEN SKIP ABNOR  */
 
             GOTO       CMDLBL(ENDPGM)
 
/*  ABNOR PROCESSING  */
 
/*  SEND ABNORMAL TERMINATION MESSAGE  */
 
 ABNOR:      SNDPGMMSG  MSGID(RCF1088) MSGF(FCUSRMSG) +
                          MSGDTA(&CHNEXSEQ) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGJOB     SWS(XXXXXX00)                                 /*S01463*/
             DMPCLPGM                                                 /*S01435*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01435*/
                                                                      /*S01463*/
/*  END OF PROGRAM PROCESSING  */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
 
             ENDPGM
