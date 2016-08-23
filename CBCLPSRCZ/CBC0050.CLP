/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Std compn for calling COB applcn')           */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0050 - STANDARD COMPONENT FOR CALLING                    */
/*                 CLOSE OF BUSINESS APPLICATIONS                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/*                      CSF002             Date 11Aug03              */
/*                      CGP002             Date 04Jul03              */
/*                      CCB012             Date 20May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014              Date 14Nov01             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      143313              Date 22SEP98             */
/*                      CCB003              DATE 17OCT96             */
/*                      107700              DATE 04SEP96             */
/*                      S01408              DATE 17JUN96             */
/*                      S01408              DATE 11JUN96             */
/*                      099150              DATE 25JAN96             */
/*                      CRT001              DATE 01JUN95             */
/*                      S01420              DATE 12APR95             */
/*                      079396              DATE 30NOV94             */
/*                      S01486              DATE 20JUN94             */
/*                      S01498              DATE 20JUN94             */
/*                      S01522              DATE 25NOV94             */
/*                      056287              DATE 12AUG94             */
/*                      S01491              DATE 01OCT94             */
/*                      S01413              DATE 18NOV93             */
/*                      S01435              DATE 19AUG93             */
/*                      061289              DATE 28SEP93             */
/*                      S01407              DATE 18MAR93             */
/*                      S01379              DATE 23SEP92             */
/*                      E30666              DATE 29OCT91             */
/*                      E27199              DATE 09AUG91             */
/*                      RT0071              DATE 17MAY91             */
/*                      RT0019              DATE 02MAY91             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSF002 - Global layer.                                      */
/*                - Remove MITEM* overrides.                         */
/*       CGP002 - Add call to GOC000100 to update the global         */
/*                dashboard.                                         */
/*       CCB012 - Use up to 70 job streams in close of business.     */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       143313 - Do not send database error details if LDA does     */
/*                contain any error details, i.e. if component has   */
/*                failed with FCOOB instead of database error.       */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Prevent Task Split Jobs appearing on COB monitor.  */
/*       107700 - The COB Stream field DHCBSN is not updated on      */
/*                CBCOMSPD thus it can be problematic to determine   */
/*                where a failed component ran.                      */
/*       S01408 - Core hook CBC0050006 added.                        */
/*       S01408 - Core hook CBC0050005 added.                        */
/*                Core hook CBC0050004 added.                        */
/*                Core hook CBC0050003 added.                        */
/*                Core hook CBC0050002 added.                        */
/*                Core hook CBC0050001 added.                        */
/*       099150 - Deletion of Multi-Language overrides               */
/*       CRT001 - Retail Teller System                               */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*       079396 - DO NOT OUTPUT DB ERROR MESSAGE IF LDA BLANK,       */
/*                AS U7 & U8 MAY BE SET ON BY ABNORMAL TERMINATION   */
/*                PROCESSING RATHER THAN DATABASE ERROR.             */
/*       S01486 - PORTFOLIO MANAGEMENT                               */
/*       S01498 - PORTFOLIO LENDING - LOMBARD CREDITS                */
/*       S01522 - User Defined Correspondence                        */
/*       056287 - CALL TO SD2320 IS NOW DONE IN CBC0010 AND THE      */
/*                MULTILANGUAGE VALUE IS NOW PASSED AS A PARAMETER   */
/*                VIA CB0010 INSTEAD OF BEING RETREIVED IN CBC0050   */
/*       S01491 - Autocall                                           */
/*       S01413 - Retail 3 Incorporation.                            */
/*       S01435 -  Incoming Message Management                       */
/*       061289 - Add override for message file LERMSGF              */
/*       S01407 -  SWITCHABILITY ENHANCEMENTS                        */
/*                 ADD MESSAGE FILES FOR CLOSE OF BUSINESS (CB) AND  */
/*                 FOR CLIENT MODIFICATIONS (XX)                     */
/*       S01379  - HISTORY AND AUDIT FACILITY                        */
/*                 ADD MSGF/HFMSGF TO THE LIST OF MULTIPLE           */
/*                 LANGUAGE SUPPORT OVERRIDES.                       */
/*       E30666  - ENSURE THAT MULTI-LANGUAGE OVERRIDE FOR MITEM     */
/*                 IS REMOVED BEFORE CALLING CB0050 OR CB0055 & THEN */
/*                 REAPPLIED AFTER. THIS WILL PREVENT OVERRIDES      */
/*                 EXISTING AT DIFFERENT LEVELS & CAUSING AN ERROR   */
/*                 WHEN TRYING TO OVERRIDE THE FILE IN SFC0330.      */
/*       E27199  - ADD MSGF/MIDASMSG TO THE LIST OF MULTIPLE         */
/*                 LANGUAGE SUPPORT OVERRIDES.                       */
/*       RT0071  - ENSURE THAT MULTI-LANGUAGE OVERRIDE FOR MITEMZZ   */
/*                 IS REMOVED BEFORE CALLING CB0050 OR CB0055 & THEN */
/*                 REAPPLIED AFTER. THIS WILL PREVENT OVERRIDES      */
/*                 EXISTING AT DIFFERENT LEVELS & CAUSING AN ERROR   */
/*                 WHEN TRYING TO COPY THE FILE IN SFC0300.          */
/*                 ALSO INCLUDE MITEM TO AVOID FOOB IN SF0300        */
/*       RT0019  - ENSURE THAT MULTI-LANGUAGE OVERRIDES ARE APPLIED  */
/*                 TO COB BATCH JOBS.                                */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&POOLNO &COMPNM &COMPSQ &EXPTY +
/**********                  &TIMESL &COMPTX) **/                     /*056287*/
             PGM        PARM(&POOLNO &COMPNM &COMPSQ &EXPTY +
                             &TIMESL &COMPTX &MULT)                   /*056287*/
/**/
             DCL        VAR(&POOLNO) TYPE(*CHAR) LEN(8)
             DCL        VAR(&COMPNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMPSQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXPTY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TIMESL) TYPE(*DEC) LEN(11)
             DCL        VAR(&COMPTX) TYPE(*CHAR) LEN(60)
             DCL        VAR(&MIDDATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSDATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MEM1) TYPE(*CHAR) LEN(37)                /*143313*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(86)
             DCL        VAR(&JOB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCHMSG)  TYPE(*CHAR) LEN(16)
             DCL        VAR(&DTQALEN) TYPE(*DEC) LEN(5) VALUE(00016)
             DCL        VAR(&DTQBLEN) TYPE(*DEC) LEN(5) VALUE(00008)
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(00086)
/**********  DCL        VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)  /*S01407*/ /*099150*/
/**********  DCL       VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10) /*RT0019*/ /*099150*/
/**********  DCL       VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10) /*RT0019*/ /*099150*/
/**********  DCL       VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10) /*S01407*/ /*099150*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*RT0019*/
             DCL        VAR(&MITLG) TYPE(*CHAR) LEN(10)               /*RT0019*/
             DCL        VAR(&MITZLG) TYPE(*CHAR) LEN(10)              /*RT0019*/
/**********  DCL        VAR(&MITCLG) TYPE(*CHAR) LEN(10)   /*RT0019*/ /*099150*/
/**********  DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)    /*RT0019*/ /*099150*/
/**********  DCL        VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)  /*S01407*/ /*099150*/
/**********  DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&MACLG) TYPE(*CHAR) LEN(10)    /*RT0019*/ /*099150*/
/**********  DCL        VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&WNLG) TYPE(*CHAR) LEN(10)     /*RT0019*/ /*099150*/
/**********  DCL        VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL       VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10) /*RT0019*/ /*099150*/
/**********  DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(10) /*E27199*/ /*099150*/
/**********  DCL        VAR(&HFMSGF) TYPE(*CHAR) LEN(10)   /*S01379*/ /*099150*/
/**********  DCL        VAR(&REUSRLG) TYPE(*CHAR) LEN(10)  /*S01413*/ /*099150*/
/************DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50) */ /*RT0019*/ /*056287*/
/************DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)  */ /*RT0019*/ /*056287*/
/************DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)   */ /*RT0019*/ /*056287*/
/************DCL VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)*/ /*RT0019*/ /*056287*/
/**********  DCL        VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)  /*RT0019*/ /*099150*/
/**********  DCL        VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)  /*S01407*/ /*099150*/
/**********  DCL        VAR(&LERMSGF) TYPE(*CHAR) LEN(10)  /*061289*/ /*099150*/
/**********  DCL        VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10) /*S01435*/ /*099150*/
/**********  DCL        VAR(&MEMSG) TYPE(*CHAR) LEN(10)    /*S01435*/ /*099150*/
/**********  DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10) /*S01522*/ /*099150*/
/**********  DCL        VAR(&PMUSRMSG) TYPE(*CHAR) LEN(10) /*S01486*/ /*099150*/
/**********  DCL        VAR(&LBUSRMSG) TYPE(*CHAR) LEN(10) /*S01498*/ /*099150*/
/**********  DCL        VAR(&RTSMSGF)  TYPE(*CHAR) LEN(10) /*CRT001*/ /*099150*/
             DCL        VAR(&DHEDT) TYPE(*DEC) LEN(6)                 /*S01491*/
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(1)                  /*S01491*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*S01491*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*S01491*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*S01491*/
             DCL        VAR(&S01491) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01491*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*S01411*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(120)            /*S01491*/
/*********** DCL        VAR(&CAT) TYPE(*DEC) LEN(3 0)                          /*S01420*/ /*CCB012*/
             DCL        VAR(&CAT) TYPE(*DEC) LEN(4 0)                                     /*CCB012*/
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0)                   /*S01420*/
             DCL        VAR(&POS) TYPE(*DEC) LEN(3 0) VALUE(26)       /*S01420*/
/*********** DCL        VAR(&POSNBR) TYPE(*DEC) LEN(3 0)                       /*S01420*/ /*CCB012*/
             DCL        VAR(&POSNBR) TYPE(*DEC) LEN(4 0)                                  /*CCB012*/
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(26)                /*S01420*/
             DCL        VAR(&S01420) TYPE(*CHAR) LEN(1)               /*S01420*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0050001                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0050006                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                       /*RT0019*/ /*099150*/
/**SETUP*AND*APPLY*MULTILANGUAGE*OVERRIDES**/              /*RT0019*/ /*099150*/
/**/                                                       /*RT0019*/ /*099150*/
/**********  RTVDTAARA  DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10) /*RT0019*/ /*099150*/
/**********  RTVDTAARA  DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10) /*RT0019*/ /*099150*/
/**********  RTVDTAARA  DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10) /*S01407*/ /*099150*/
                                                           /*RT0019*/ /*099150*/
/**********  CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
/**********               &ERRORC &MULT) **/               /*RT0019*/ /*056287*/
                                                           /*RT0019*/ /*099150*/
/**********  IF         COND(&MULT *EQ '  ') THEN(DO)      /*RT0019*/ /*099150*/
/**********     CHGVAR     VAR(&MULT) VALUE('GB')          /*RT0019*/ /*099150*/
/**********  ENDDO                                         /*RT0019*/ /*099150*/
                                                           /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT +
/**********               'MSGF')                          /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ') +
/**********  CHGVAR                                        /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ') +
/**********  CHGVAR                                        /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ') +
                                                           /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8)) +
                                                           /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8)) +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8)) +
/**********                                                /*S01407*/ /*099150*/
/**********  CHGVAR     VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)  +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)  +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8)  +
/**********                                                /*S01407*/ /*099150*/
/**********  CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  +
/**********               ')                               /*RT0019*/ /*099150*/
/**********  CHGVAR    VAR(&FCUSRLG)  VALUE(&MULT *CAT 'FCUSRMSG  ') +
/**********                                                /*RT0019*/ /*099150*/
/**********  CHGVAR     VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ') +
/**********                                                /*E27199*/ /*099150*/
/**********  CHGVAR     VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF    ') +
/**********                                                /*S01379*/ /*099150*/
/**********  CHGVAR     VAR(&REUSRLG) VALUE(&MULT *CAT 'REUSRMSG  ') +
/**********                                                /*S01413*/ /*099150*/
/**********  CHGVAR     VAR(&XXUSRLG) VALUE(&MULT *CAT 'XXUSRMSG  ') +
/**********                                                /*S01407*/ /*099150*/
/**********  CHGVAR     VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF   ') +
/**********                                                /*061289*/ /*099150*/
/**********  CHGVAR     VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') +
/**********                                                /*S01435*/ /*099150*/
/**********  CHGVAR     VAR(&MEMSG) VALUE(&MULT *CAT 'MEMSG  ') +
/**********                                                /*S01435*/ /*099150*/
/**********  CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') +
/**********                                                /*S01522*/ /*099150*/
/**********  CHGVAR     VAR(&PMUSRMSG) VALUE(&MULT *CAT 'PMUSRMSG  ') +
/**********                                                /*S01486*/ /*099150*/
/**********  CHGVAR     VAR(&LBUSRMSG) VALUE(&MULT *CAT 'LBUSRMSG  ') +
/**********                                                /*S01498*/ /*099150*/
/**********  CHGVAR     VAR(&RTSMSGF)  VALUE(&MULT *CAT 'RTSMSGF   ') +
/**********                                                /*CRT001*/ /*099150*/
/**********  OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)             +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRDBF     FILE(MITEM) MBR(&MITLG) SHARE(*NO) /*RT0019*/ /*099150*/
/**********  OVRDBF     FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO)   /*S01407*099150*/
/**********  OVRDBF     FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO)   /*S01407*099150*/
/**********  OVRDBF     FILE(MITEMZZ) MBR(&MITZLG)         /*RT0019*/ /*099150*/
/**********  OVRDBF     FILE(MITMC) MBR(&MITCLG)                   +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)          +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)          +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)          +
/**********                                                /*S01407*/ /*099150*/
/**********  OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)               +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(DRSMM) TOMSGF(&DRSMMLG)               +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(MACMSG) TOMSGF(&MACLG)                +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)            +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(WNMSGF) TOMSGF(&WNLG)                 +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)            +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)            +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)          +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)            +
/**********                                                /*RT0019*/ /*099150*/
/**********  OVRMSGF    MSGF(MIDASMSG) TOMSGF(&MIDASMSG)           +
/**********                                                /*E27199*/ /*099150*/
/**********  OVRMSGF    MSGF(HFMSGF)   TOMSGF(&HFMSGF)             +
/**********                                                /*S01379*/ /*099150*/
/**********  OVRMSGF    MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)            +
/**********                                                /*S01407*/ /*099150*/
/**********  OVRMSGF    MSGF(LERMSGF) TOMSGF(&LERMSGF)             +
/**********                                                /*061289*/ /*099150*/
/**********  OVRMSGF    MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)           +
/**********                                                /*S01435*/ /*099150*/
/**********  OVRMSGF    MSGF(MEMSG) TOMSGF(&MEMSG)                 +
/**********                                                /*S01435*/ /*099150*/
/**********  OVRMSGF    MSGF(REUSRMSG) TOMSGF(&REUSRLG)            +
/**********                                                /*S01413*/ /*099150*/
/**********  OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)           +
/**********                                                /*S01522*/ /*099150*/
/**********  OVRMSGF    MSGF(PMUSRMSG) TOMSGF(&PMUSRMSG)           +
/**********                                                /*S01486*/ /*099150*/
/**********  OVRMSGF    MSGF(LBUSRMSG) TOMSGF(&LBUSRMSG)           +
/**********                                                /*S01498*/ /*099150*/
/**********  OVRMSGF    MSGF(RTSMSGF)  TOMSGF(&RTSMSGF)            +
/**********                                                /*CRT001*/ /*099150*/
/**/
             CRTPF      FILE(QTEMP/CBFLAGQT) RCDLEN(1) TEXT('Flag to +
                          indicate that process is running in CoB')                       /*CCB020*/
             MONMSG     MSGID(CPF5813)                                                    /*CCB020*/
                                                                                          /*CCB020*/
             CHGVAR     VAR(&S01420) VALUE('N')                       /*S01420*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*S01420*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*S01420*/
             CHGVAR     VAR(&SARD) VALUE('S01420')                    /*S01420*/
/**/                                                                  /*CCB003*/
/* IF TASK SPLIT JOB DO NOT UPDATE BATCH MONITOR INFO                 /*CCB003*/
/**/                                                                  /*CCB003*/
             IF         COND(&POOLNO *NE 'STREAMXX') THEN(DO)         /*CCB003*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*S01420*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&S01420) VALUE('Y'))                    /*S01420*/
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)               /*S01420*/
             CHGVAR     VAR(&X) VALUE(%SST(&POOLNO 7 2))              /*S01420*/
             CHGVAR     VAR(&QUAL) VALUE(&JOB *CAT &USER *CAT &NBR)   /*S01420*/
             CHGVAR     VAR(&POSNBR) VALUE(&POS * &X)                 /*S01420*/
             CHGVAR     VAR(&CAT) VALUE(53 + &POSNBR)                 /*S01420*/
             CHGDTAARA  DTAARA(CBCTRL (&CAT 26)) VALUE(&QUAL)         /*S01420*/
             ENDDO                                                    /*S01420*/
             ENDDO                                                    /*CCB003*/
/**/
/* SET UP JOB DATE FORMAT TO BE SAME AS MIDAS DATE FORMAT */
/**/
             RTVDTAARA  DTAARA(RUNDAT (12 1)) RTNVAR(&MIDDATFMT)
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)
             CHGVAR     VAR(&SYSDATFMT) VALUE(%SST(&DATFMT 1 1))
             IF         COND(&SYSDATFMT *NE &MIDDATFMT) THEN(DO)
                    IF         COND(&MIDDATFMT *EQ 'M') THEN(CHGJOB +
                               DATFMT(*MDY))
                    ELSE       CMD(CHGJOB DATFMT(*DMY))
             ENDDO
/**/
/* CHANGE THE PRIORITY & TIMESLICE OF THE JOB */
/**/
             CHGJOB     RUNPTY(&EXPTY) TIMESLICE(&TIMESL)
/**/
/* CREATE DATA AREA LDA IN QTEMP - REQUIRED FOR BATCH JOBS */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('LOCAL DATA AREA FOR CBC0050') AUT(*USE)
/**/
/* SET UP MESSAGE FOR COMPONENT STARTED */
/**/
             CHGVAR     VAR(&MSG) VALUE(&COMPNM *CAT &COMPTX *CAT +
                          'STARTED ' *CAT &POOLNO)
/**/
/* SEND INITIAL MESSAGE TO MONITOR DATA QUEUE */
/**/
             CALL       PGM(QSNDDTAQ) PARM('CBDTQD' '*LIBL' &DTQDLEN +
                          &MSG)
/**/
/*********   IF COND(&COMPNM *EQ 'SFC0300') THEN(DO) **/  /*RT0071*/  /*E30666*/
             IF         COND((&COMPNM *EQ 'SFC0300') *OR (&COMPNM +
                          *EQ 'SFC0330')) THEN(DO)                    /*E30666*/
/**********                            */                                          /*RT0071 CSF002*/
/**********  DLTOVR     FILE(MITEMZZ)  */                                          /*RT0071 CSF002*/
/**********  MONMSG     MSGID(CPF9841) */                                          /*RT0071 CSF002*/
/**********  DLTOVR     FILE(MITEM)    */                                          /*RT0071 CSF002*/
/**********  MONMSG     MSGID(CPF9841) */                                          /*RT0071 CSF002*/
/**********  DLTOVR     FILE(MITEMJ0)  */                                          /*S01407 CSF002*/
/**********  MONMSG     MSGID(CPF9841) */                                          /*S01407 CSF002*/
/**********  DLTOVR     FILE(MITEMJ1)  */                                          /*S01407 CSF002*/
/**********  MONMSG     MSGID(CPF9841) */                                          /*S01407 CSF002*/
             ENDDO                                                    /*RT0071*/
/**/                                                                  /*S01491*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*S01491*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*S01491*/
             CHGVAR     VAR(&SARD) VALUE('S01491')                    /*S01491*/
/**/
/**    IF AUTOCALL IS SWITCHED ON                             */      /*S01491*/
/**/                                                                  /*S01491*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*S01491*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&S01491) VALUE('Y'))                    /*S01491*/
             IF         COND(&S01491 *EQ 'Y') THEN(DO)                /*S01491*/
             ALCOBJ     OBJ((AC002 *DTAARA *EXCL)) WAIT(5)            /*S01491*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC1))        /*S01491*/
/**/                                                                  /*S01491*/
/*  IF DTAARA CAN BE ALLOCATED, PGM ACC0002 IS NOT RUNNING,           /*S01491*/
/*  ERROR MESSAGE NEEDS TO BE SENT TO ERROR MESSAGE QUEUE ACMSGQ      /*S01491*/
/*                                                                    /*S01491*/
             RTVMSG     MSGID(ACM0002) MSGF(GBACMSGF) MSG(&MESSAGE)   /*S01491*/
             SNDPGMMSG  MSG(&MESSAGE) TOMSGQ(ACMSGQ)                  /*S01491*/
/*                                                                    /*S01491*/
ALC1:                                                                 /*S01491*/
             ALCOBJ     OBJ((AC001 *DTAARA *EXCL)) WAIT(0)            /*S01491*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC2))        /*S01491*/
             DLCOBJ     OBJ((AC001 *DTAARA *EXCL))                    /*S01491*/
/************SBMJOB     CMD(CALL PGM(ACC0001)) +                                          /*CPK014*/
/************             JOB(ACC0001) JOBD(MEODD) JOBQ(*JOBD) +                          /*CPK014*/
/************             INLLIBL(*JOBD) RTGDTA(*JOBD)                /*S01491*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(ACC0001)) JOB(ACC0001) +                             /*CSC023*/
/************             JOBD(MEODD) JOBQ(*JOBD) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                         /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(ACC0001)) JOB(ACC0001) +
                          JOBD(MEODD) JOBQ(*JOBD) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
 ALC2:       ENDDO                                                    /*S01491*/
/**/                                                                  /*S01491*/
/* CALL CB0050 AND RETRY IF RECORD IS LOCKED */
/**/
/* RETRY:    CALL       PGM(CB0050) PARM(&COMPNM &COMPSQ &CSTS)  */   /*S01491*/
/**RETRY:****CALL       PGM(CB0050) PARM(&COMPNM &COMPSQ &CSTS +      /*107700*/
/************                            &DHEDT)           /*S01491*/ /*107700*/
 RETRY:      CALL       PGM(CB0050) PARM(&COMPNM &COMPSQ &CSTS +
                                         &DHEDT &POOLNO)              /*107700*/
             MONMSG     MSGID(CPF5027) EXEC(GOTO CMDLBL(RETRY))
/**/
/*********   IF COND(&COMPNM *EQ 'SFC0300') THEN(DO) **/  /*RT0071*/  /*E30666*/
/**********                                                           /*099150*/
/**********  IF         COND((&COMPNM *EQ 'SFC0300') *OR (&COMPNM +   /*099150*/
/**********               *EQ 'SFC0330')) THEN(DO)         /*E30666*/ /*099150*/
/**********  OVRDBF     FILE(MITEMZZ) MBR(&MITZLG)         /*RT0071*/ /*099150*/
/**********  OVRDBF     FILE(MITEM) MBR(&MITLG) SHARE(*NO) /*RT0071*/ /*099150*/
/**********  OVRDBF     FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO)   /*S01407*099150*/
/**********  OVRDBF     FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO)   /*S01407*099150*/
/**********  ENDDO                                                    /*099150*/
/**/
/* IF COMPONENT COMPLETES NORMALLY CHANGE MESSAGE TO COMPLETED */
/**/
             IF         COND(&CSTS *EQ 'C') THEN(DO)
                        CHGVAR     VAR(&MSG) VALUE(&COMPNM *CAT +
                           &COMPTX *CAT 'COMPLETE' *CAT &POOLNO)
/**/
/**    IF AUTOCALL IS SWITCHED ON                             */      /*S01491*/
/**/                                                                  /*S01491*/
             IF         COND(&S01491 *EQ 'Y') THEN(DO)                /*S01491*/
/**/                                                                  /*S01491*/
/**    Remove record from PF/ACFINTPD                         */      /*S01491*/
/**/
             CHGVAR     VAR(&MOD) VALUE('D')                          /*S01491*/
             CALL       PGM(AC0001) PARM(&COMPNM &COMPSQ &DHEDT +
                             &MOD)                                    /*S01491*/
             ENDDO                                                    /*S01491*/
/**/                                                                  /*S01491*/
/*/COPY WNCPYSRC,CBC0050007                                  */
             ENDDO
/**/
/* ELSE IF COMPONENT FAILS CHANGE MESSAGE TO FAILED */
/**/
             ELSE       DO
/* If Autocall is ON, an error has occured in a component */          /*S01491*/
/*  write the error message from GBACMSGF to the error    */          /*S01491*/
/*    message queue ACMSGQ                                */          /*S01491*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*S01491*/
             SNDPGMMSG  MSGID(ACM0001) MSGF(GBACMSGF) MSGDTA(&COMPNM +
                          *CAT &COMPSQ) TOMSGQ(ACMSGQ)                /*S01491*/
/**/                                                                  /*S01491*/
/**    Remove record from PF/ACFINTPD if program in error.    */      /*S01491*/
/**/                                                                  /*S01491*/
             CHGVAR     VAR(&MOD) VALUE('D')                          /*S01491*/
             CALL       PGM(AC0001) PARM(&COMPNM &COMPSQ &DHEDT +
                          &MOD)                                       /*S01491*/
             ENDDO                                                    /*S01491*/
/**/                                                                  /*S01491*/
                        CHGVAR     VAR(&MSG) VALUE(&COMPNM *CAT +
                           &COMPTX *CAT 'FAILED  ' *CAT &POOLNO)
/*/COPY WNCPYSRC,CBH00011                                            */
             ENDDO
/**/
/* SEND MESSAGE TO DATA QUEUE */
/**/
             CALL       PGM(QSNDDTAQ) PARM('CBDTQD' '*LIBL' &DTQDLEN +
                          &MSG)
/**/
/* SET UP MESSAGE FOR COMPONENT STATUS  */
/* AND SEND TO SCHEDULER DATA QUEUE */
/**/
             CHGVAR     VAR(&SCHMSG) VALUE(&COMPNM *CAT &COMPSQ *CAT +
                          &CSTS)
             CALL       PGM(QSNDDTAQ) PARM('CBDTQA' '*LIBL' &DTQALEN +
                          &SCHMSG)
/**/
/* SEND AVAILABLE STREAM NUMBER TO STREAM CONTROLLER DATA QUEUE */
/**/
/**/                                                                  /*CCB003*/
/* IF TASK SPLIT JOB DO NOT UPDATE AVAILABLE STREAM DATA QUEUE        /*CCB003*/
/**/                                                                  /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(&POOLNO *NE 'STREAMXX') THEN(DO)         /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM('CBDTQB' '*LIBL' &DTQBLEN +
                          &POOLNO)
                                                                      /*CCB003*/
             ENDDO                                                    /*CCB003*/
/**/
             IF         COND(&CSTS *EQ 'C') THEN(GOTO ENDPGM)
/**/
/* DATABASE ERROR HANDLING */
/**/
             IF         COND(&CSTS *EQ 'A') THEN(DO)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0050002                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
                        SNDPGMMSG  MSG('COMPONENT' *BCAT &COMPNM +
                          *BCAT &COMPSQ *BCAT 'TERMINATED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0050003                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
                        IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
/**************************IF COND(&MEM *NE *BLANKS) THEN(DO)  /*079396 143313*/
                           CHGVAR   VAR(&MEM1) VALUE(%SST(&MEM 1 37)) /*143313*/
                           IF         COND(&MEM1 *NE ' ') THEN(DO)    /*143313*/
                           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                      MSGDTA(&MEM) TOMSGQ(MOPERQ)
                           ENDDO                                      /*079396*/
                        ENDDO
/**/
             ENDDO
/**/
             ELSE       DO
 ABNOR:                 CHGJOB     LOG(4 10) LOGCLPGM(*YES)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
                        MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0050004                                           /*S01408*/
/*                                                                    /*S01408*/
             SNDPGMMSG  MSG('COMPONENT CBC0050 TERMINATED ABNORMALLY +
                          WHILE CALLING' *BCAT &COMPNM *BCAT &COMPSQ +
                          *BCAT 'SEE JOB LOG FOR JOB ' *BCAT &NBR +
                          *TCAT '/' *TCAT &USER *TCAT '/' *TCAT &JOB +
                          *TCAT '.') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0050005                                           /*S01408*/
/*                                                                    /*S01408*/
                        MONMSG     MSGID(CPF0000 MCH0000)
/**/
             ENDDO
/**/
/**** ENDPGM:     ENDPGM    ******/                                   /*S01420*/
 ENDPGM:                                                              /*S01420*/
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
             CHGVAR     VAR(%SST(&QUAL 1 26)) VALUE(' ')              /*S01420*/
             CHGDTAARA  DTAARA(CBCTRL (&CAT 26)) VALUE(&QUAL)         /*S01420*/
             MONMSG     MSGID(CPF0000)                                /*S01420*/
             ENDDO                                                    /*S01420*/
 
/* Update global dashboard */                                                             /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*PHASE')                                     /*CGP002*/
             MONMSG     MSGID(CPF0000)                                                    /*CGP002*/
                                                                                          /*CGP002*/
             ENDPGM                                                   /*S01420*/
