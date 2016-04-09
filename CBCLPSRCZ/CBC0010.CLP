/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB scheduler controlling program')          */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0010  COB SCHEDULER CONTROLLING CL                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No.  CGP002            Date 04Jul03              */
/*       Prev Amend No.  CCB012            Date 31May03              */
/*                       CPK016            Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       CPK009            Date 09Jul99              */
/*                       S01408            DATE 17JUN96              */
/*                       S01408            DATE 11JUN96              */
/*                       S01408            DATE 10JUN96              */
/*                       103078            DATE 21APR96              */
/*                       099150            DATE 26JAN96              */
/*                       091688            DATE 10AUG95              */
/*                       083886            DATE 06MAR95              */
/*                       CRT001            DATE 01JUN95              */
/*                       S01420            DATE 11APR95              */
/*                       S01486            DATE 20JUN94              */
/*                       S01498            DATE 20JUN94              */
/*                       S01522            DATE 25NOV94              */
/*                       056287            DATE 11AUG94              */
/*                       S01491            DATE 01OCT94              */
/*                       S01413            DATE 18NOV93              */
/*                       061289            DATE 28SEP93              */
/*                       S01407            DATE 18MAR93              */
/*                       S01379            DATE 23SEP92              */
/*                       E27199            DATE 09AUG91              */
/*                       LN1245            DATE 13MAY91              */
/*                       S01314            DATE 23APR91              */
/*                       LN0459            DATE 29JUN90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     CGP002 - Add call to GOC000100 to update the global           */
/*              dashboard.                                           */
/*     CCB012 - Journaling options for high availability.  Make      */
/*              CBJRN redundant.                                     */
/*     CPK016 - Externalise STRCMTCTL code for ease of later         */
/*              upgrade.                                             */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     S01408 - Core hook CBC0010006 added.                          */
/*     S01408 - Core hook CBC0010005 added.                          */
/*              Core hook CBC0010004 added.                          */
/*     S01408 - Core hook CBC0010003 added.                          */
/*              Core hook CBC0010002 added.                          */
/*              Core hook CBC0010001 added.                          */
/*     103078 - Scheduler ends but Cob batch monitor remains -       */
/*              this is due to Position 45 being set to 'Y' when     */
/*              screen failure occurs, but pgm only checks for 'N'   */
/*     099150 - Deletion of Multi-Language overrides                 */
/*     091688 - Rename the CBC0010 job to COBSCHED for ease          */
/*              of identification.                                   */
/*     083886 - If COB ends normally after restart after machine     */
/*              failure, COB processing should continue instead      */
/*              of hanging - send data queue message to CBDTAQ.      */
/*            - Produce dump if program terminates abnormally        */
/*       CRT001 - Retail Teller System                               */
/*       S01420 - CoB Enhancements (Batch Monitor)                   */
/*       S01486 - Portfolio Management Upgrade                       */
/*       S01498 - Portfolio Lending Upgrade                          */
/*       S01522 - User Defined Correspondence                        */
/*       056287 - &MULT IS NOW PASSED AS A PARAMETER TO CB0010 AND   */
/*                THEN ON TO THE SUBMITTED CBC0050/55 JOBS           */
/*       S01491 - Autocall                                           */
/*       S01413 - Retail 3 Incorporation.                            */
/*       061289 - Add override for message file LERMSGF              */
/*       S01407 - SWITCHABILITY ENHANCEMENTS                         */
/*                ADD MESSAGE FILES FOR CLOSE OF BUSINESS (CB) AND   */
/*                FOR CLIENT MODIFICATIONS (XX)                      */
/*       S01379 - HISTORY AND AUDIT FACILITY                         */
/*                ADD MSGF/HFMSGF TO THE LIST OF MULTIPLE            */
/*                LANGUAGE SUPPORT OVERRIDES.                        */
/*       E27199 - ADD MSGF/MIDASMSG TO THE LIST OF MULTIPLE          */
/*                LANGUAGE SUPPORT OVERRIDES.                        */
/*       LN1245 - ADD IN OVERRIDE FOR NEW MSGF FCUSRMSG              */
/*       S01314 - CHANGES MADE DURING PTF INCORPORATION              */
/*              - ADDITION OF MULTILANGUAGE OVERRIDES.               */
/*       LN0459 - AMENDMENT TO RETRIEVAL OF MESSAGE DATA FOR         */
/*                DATABASE ERROR HANDLING                            */
/*********************************************************************/
             PGM
/**/
/**********  DCL        VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)  /*LN1245*/ /*099150*/
             DCL        VAR(&MIDDATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSDATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DTQDLEN)  TYPE(*DEC) LEN(5) VALUE(86)
             DCL        VAR(&MSGD) TYPE(*CHAR) LEN(86)
             DCL        VAR(&LDA)  TYPE(*CHAR) LEN(256)               /*LN0459*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CBSTAT)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**********  DCL        VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)  /*S01407*/ /*099150*/
/**********  DCL       VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10) /*S01314*/ /*099150*/
/**********  DCL       VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10) /*S01314*/ /*099150*/
/**********  DCL       VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10) /*S01407*/ /*099150*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*S01314*/
/**********  DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)    /*S01314*/ /*099150*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(25)     /*S01314*/ /*099150*/
/**********  DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)     /*S01314*/ /*099150*/
/**********  DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)      /*S01314*/ /*099150*/
/**********  DCL   VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0) /*S01314*/ /*099150*/
/**********  DCL        VAR(&MITLG) TYPE(*CHAR) LEN(10)    /*S01314*/ /*099150*/
/**********  DCL        VAR(&MITZLG) TYPE(*CHAR) LEN(10)   /*S01314*/ /*099150*/
/**********  DCL        VAR(&MITCLG) TYPE(*CHAR) LEN(10)   /*S01314*/ /*099150*/
/**********  DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)    /*S01314*/ /*099150*/
/**********  DCL        VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)  /*S01407*/ /*099150*/
/**********  DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&MACLG) TYPE(*CHAR) LEN(10)    /*S01314*/ /*099150*/
/**********  DCL        VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&WNLG) TYPE(*CHAR) LEN(10)     /*S01314*/ /*099150*/
/**********  DCL        VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)  /*S01314*/ /*099150*/
/**********  DCL       VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10) /*S01314*/ /*099150*/
/**********  DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(10) /*E27199*/ /*099150*/
/**********  DCL        VAR(&HFMSGF) TYPE(*CHAR) LEN(10)   /*S01379*/ /*099150*/
/**********  DCL        VAR(&REUSRLG) TYPE(*CHAR) LEN(10)  /*S01413*/ /*099150*/
/**********  DCL        VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)  /*S01407*/ /*099150*/
/**********  DCL        VAR(&LERMSGF) TYPE(*CHAR) LEN(10)  /*061289*/ /*099150*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*S01491*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*S01491*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*S01491*/
             DCL        VAR(&S01491) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01491*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*S01411*/
/**********  DCL        VAR(&CGUSRLG) TYPE(*CHAR) LEN(10)  /*S01522*/ /*099150*/
/**********  DCL        VAR(&PMUSRMSG) TYPE(*CHAR) LEN(10) /*S01486*/ /*099150*/
/**********  DCL        VAR(&LBUSRMSG) TYPE(*CHAR) LEN(10) /*S01498*/ /*099150*/
/**********  DCL        VAR(&RTSMSGF)  TYPE(*CHAR) LEN(10) /*CRT001*/ /*099150*/
             DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01420*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0010001                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0010006                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
/**********  RTVDTAARA  DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10) /*S01314*/ /*099150*/
/**********  RTVDTAARA  DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10) /*S01314*/ /*099150*/
/**********  RTVDTAARA  DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10) /*S01407*/ /*099150*/
/**********                                                /*S01314*/ /*099150*/
/**CALL*SF0410*TO*DETERMINE*USER'S*PREFERRED*LANGUAGE**/   /*S01314*/ /*099150*/
/**********                                                /*S01314*/ /*099150*/
/**********  CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
/**********               &ERRORC &MULT)                   /*S01314*/ /*099150*/
/**********                                                /*S01314*/ /*099150*/
/**IF*LANGUAGE*CODE*IS*BLANK*THEN*DEFAULT*TO*GB**/         /*S01314*/ /*099150*/
/**********                                                /*S01314*/ /*099150*/
/**********  IF         COND(&MULT *EQ '  ') THEN(DO)      /*S01314*/ /*099150*/
/**********    CHGVAR     VAR(&MULT) VALUE('GB')           /*S01314*/ /*099150*/
/**********  ENDDO                                         /*S01314*/ /*099150*/
/**********                                                /*S01314*/ /*099150*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*S01314*/
/**CREATE*THE*MULTILANGUAGE*OBJECT*NAMES**/                /*S01314*/ /*099150*/
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&FCUSRLG) VALUE(&MULT *CAT 'FCUSRMSG  ') +
/**********                                                /*LN1245*/ /*099150*/
/**********  CHGVAR   VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF')  +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ')     +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ')    +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ')    +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))     +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))     +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8))     +
/**********                                                /*S01407*/ /*099150*/
/**********  CHGVAR     VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)      +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)      +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8)      +
/**********                                                /*S01407*/ /*099150*/
/**********  CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')   +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')   +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')     +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')   +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')      +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')   +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')   +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR    VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ')  +
/**********                                                /*S01314*/ /*099150*/
/**********  CHGVAR     VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ')  +
/**********                                                /*E27199*/ /*099150*/
/**********  CHGVAR     VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF    ')  +
/**********                                                /*S01379*/ /*099150*/
/**********  CHGVAR     VAR(&REUSRLG) VALUE(&MULT *CAT 'REUSRMSG  ')   +
/**********                                                /*S01413*/ /*099150*/
/**********  CHGVAR     VAR(&XXUSRLG) VALUE(&MULT *CAT 'XXUSRMSG  ')   +
/**********                                                /*S01407*/ /*099150*/
/**********  CHGVAR     VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF   ')   +
/**********                                                /*061289*/ /*099150*/
/**********  CHGVAR     VAR(&CGUSRLG) VALUE(&MULT *CAT 'CGUSRMSG  ')   +
/**********                                                /*S01522*/ /*099150*/
/**********  CHGVAR     VAR(&PMUSRMSG) VALUE(&MULT *CAT 'PMUSRMSG  ')  +
/**********                                                /*S01486*/ /*099150*/
/**********  CHGVAR     VAR(&LBUSRMSG) VALUE(&MULT *CAT 'LBUSRMSG  ')  +
/**********                                                /*S01498*/ /*099150*/
/**********  CHGVAR     VAR(&RTSMSGF)  VALUE(&MULT *CAT 'RTSMSGF   ')  +
/**********                                                /*CRT001*/ /*099150*/
                                                           /*S01314*/ /*099150*/
/**APPLY*MULTILANGUAGE*OVERRIDES**/                        /*S01314*/ /*099150*/
                                                           /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)    /*LN1245*/ /*099150*/
/**********  OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)     /*S01314*/ /*099150*/
/**********  OVRDBF     FILE(MITEM) MBR(&MITLG) SHARE(*NO) /*S01314*/ /*099150*/
/**********  OVRDBF   FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO) /*S01407*/ /*099150*/
/**********  OVRDBF   FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO) /*S01407*/ /*099150*/
/**********  OVRDBF     FILE(MITEMZZ) MBR(&MITZLG)         /*S01314*/ /*099150*/
/**********  OVRDBF     FILE(MITMC) MBR(&MITCLG)           /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)  /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)  /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)  /*S01407*/ /*099150*/
/**********  OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)       /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(DRSMM) TOMSGF(&DRSMMLG)       /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(MACMSG) TOMSGF(&MACLG)        /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)    /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(WNMSGF) TOMSGF(&WNLG)         /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)    /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)    /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)  /*S01314*/ /*099150*/
/**********  OVRMSGF    MSGF(MIDASMSG) TOMSGF(&MIDASMSG)   /*E27199*/ /*099150*/
/**********  OVRMSGF    MSGF(HFMSGF) TOMSGF(&HFMSGF)       /*S01379*/ /*099150*/
/**********  OVRMSGF    MSGF(REUSRMSG) TOMSGF(&REUSRLG)    /*S01413*/ /*099150*/
/**********  OVRMSGF    MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)    /*S01407*/ /*099150*/
/**********  OVRMSGF    MSGF(LERMSGF) TOMSGF(&LERMSGF)     /*061289*/ /*099150*/
/**********  OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRLG)    /*S01522*/ /*099150*/
/**********  OVRMSGF    MSGF(PMUSRMSG) TOMSGF(&PMUSRMSG)   /*S01486*/ /*099150*/
/**********  OVRMSGF    MSGF(LBUSRMSG) TOMSGF(&LBUSRMSG)   /*S01498*/ /*099150*/
/**********  OVRMSGF    MSGF(RTSMSGF)  TOMSGF(&RTSMSGF)    /*CRT001*/ /*099150*/
/**/
/* ALLOCATE DTAARA/CBCHK FOR RESTART AFTER MACHINE FAILURE PROCESSING */
/**/
             ALCOBJ     OBJ((CBCHK *DTAARA *EXCL)) WAIT(1)
/**/
/* RESET SWITCHES U7 & U8  */
/**/
             CHGJOB     SWS(XXXXXX00)
                                                                                          /*CGP002*/
/* Update global dashboard */                                                             /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*PHASE')                                     /*CGP002*/
                                                                                          /*CGP002*/
/**/
/* CREATE LOCAL DATA FOR JOB IN QTEMP */
/**/
/**********  CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +      /*099150*/
/**********              TEXT('Local data area for CBC0010') AUT(*USE)/*099150*/
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
/*/COPY WNCPYSRC,CBC0010007                                          */
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*S01420*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*S01420*/
             CHGVAR     VAR(&SARD) VALUE('S01420')                    /*S01420*/
/**/                                                                  /*S01420*/
/** If COB batch monitor is switched ON */                            /*S01420*/
/**/                                                                  /*S01420*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*S01420*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*S01420*/
                CHGVAR     VAR(&S01420) VALUE('Y')                    /*S01420*/
                RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)             /*S01420*/
                CHGDTAARA  DTAARA(CBCTRL (27 10)) VALUE(&JOB)         /*S01420*/
                CHGDTAARA  DTAARA(CBCTRL (37 10)) VALUE(&USR)         /*S01420*/
                CHGDTAARA  DTAARA(CBCTRL (47 6)) VALUE(&NBR)          /*S01420*/
             ENDDO                                                    /*S01420*/
/**/
/* BEGIN COMMITMENT CONTROL AND CALL PROGRAM */
/**/
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG)                                    CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                            /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
/**/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*S01491*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*S01491*/
             CHGVAR     VAR(&SARD) VALUE('S01491')                    /*S01491*/
/**/                                                                  /*S01491*/
/**    If Autocall is switched ON                             */      /*S01491*/
/**/                                                                  /*S01491*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*S01491*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&S01491) VALUE('Y'))                    /*S01491*/
/**/                                                                  /*S01491*/
             IF         COND(&S01491 *EQ 'Y') THEN(DO)                /*S01491*/
/**/                                                                  /*S01491*/
/*   Set 'Active flag on ACDTAFPD to 'Y'                 */           /*S01491*/
/**/                                                                  /*S01491*/
/**********  CALL       PGM(AC0007) PARM('CBC0010   ' 'Y') /*S01491*/ /*091688*/
             CALL       PGM(AC0007) PARM('COBSCHED  ' 'Y')            /*091688*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*S01491*/
             ENDDO                                                    /*S01491*/
/**********  CALL       PGM(CB0010) **/                               /*056287*/
             CALL       PGM(CB0010) PARM(&MULT)                       /*056287*/
/**/
/* IF DATABASE ERROR THEN SEND ERROR MESSAGE */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         * *LN0459*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*LN0459*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*LN0459*/
/***************IF   COND(%SST(&MEM 1 5) *NE '     ') THEN(+         * *LN0459*/
/***************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +              * *LN0459*/
/***************     MSGDTA(&MEM) TOMSGQ(MOPERQ))                    * *LN0459*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                     MSGDTA(&MEM) TOMSGQ(MOPERQ)                      /*LN0459*/
             ENDDO
/**/
             ENDCMTCTL
/**/
/**END*JOURNALLING*ON*FILES*CBCOMSPD*&*CBDEPSPD**/                                        /*CCB012*/
/**/
/**********  ENDJRNPF   FILE(CBCOMSPD CBDEPSPD) JRN(CBJRN)                                /*CCB012*/
/**/
/** IF NO ERRORS THEN DO */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/* IF COB NOT BEEN HALTED THEN MUST HAVE COMPLETED */
/**/
                RTVDTAARA  DTAARA(CBSTAT) RTNVAR(&CBSTAT)
/***************IF COND(%SST(&CBSTAT 45 1) *EQ 'N') THEN(DO)           *103078*/
                IF COND((%SST(&CBSTAT 45 1) *EQ 'N') *OR +
                        (%SST(&CBSTAT 45 1) *EQ 'Y')) THEN(DO)        /*103078*/
/**/
/* SEND MESSAGE TO DTAQ/CBDTQD TO SHOW ALL COMPONENTS HAVE COMPLETED */
/* NORMALLY */
/**/
                   CHGVAR   VAR(&MSGD) VALUE('COB COMPLETED NORMALLY')
                   CHGVAR   VAR(%SST(&MSGD 71 8)) VALUE('END     ')
                   CALL QSNDDTAQ PARM('CBDTQD    ' '*LIBL     ' +
                            &DTQDLEN &MSGD)
                   IF         COND(&S01420 *EQ 'Y') THEN(CALL +
                                PGM(QSNDDTAQ) PARM('MONBCHQ' '*LIBL' +
                                X'00001F' 'T'))                       /*S01420*/
/*/COPY WNCPYSRC,CBC0010008                                          */
                ENDDO
/**/                                                                  /*S01491*/
                IF COND(%SST(&CBSTAT 45 1) *EQ 'M') THEN(DO)          /*083886*/
                   CHGVAR   VAR(&MSGD) VALUE('COB COMPLETED NORMALLY +
                             AFTER SYSTEM FAILURE')                   /*083886*/
                   CHGVAR   VAR(%SST(&MSGD 71 8)) VALUE('END     ')   /*083886*/
                   CALL     QSNDDTAQ PARM('CBDTQD    ' '*LIBL     ' +
                             &DTQDLEN &MSGD)                          /*083886*/
                ENDDO                                                 /*083886*/
/**/                                                                  /*083886*/
/* If SAR S01491 is switched ON, setup dataarea ACCOBT */             /*S01491*/
/**/                                                                  /*S01491*/
                IF         COND(&S01491 *EQ 'Y') THEN(DO)             /*S01491*/
                  CHGDTAARA  DTAARA(ACCOBT (2 1)) VALUE('C')          /*S01491*/
/**/                                                                  /*S01491*/
/*  Set 'Active flag' on ACDTAFPD to 'N'               */             /*S01491*/
/**/                                                                  /*S01491*/
/**********       CALL       PGM(AC0007) PARM('CBC0010   ' 'N')/*S01491*091688*/
                  CALL       PGM(AC0007) PARM('COBSCHED  ' 'N')       /*091688*/
                  IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                               CMDLBL(ABNOR))                         /*S01491*/
                ENDDO                                                 /*S01491*/
/**/
/* DEALLOCATE DTAARA/CBCHK FOR RESTART AFTER MACHINE FAILURE CHECK */
/**/
                DLCOBJ     OBJ((CBCHK *DTAARA *EXCL))
             ENDDO
             ELSE DO
/**/
/* CHECK FOR DATABASE ERRORS OR ABNORMAL TERMINATION */
/**/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0010002                                           /*S01408*/
/*                                                                    /*S01408*/
ABNOR:          SNDPGMMSG  MSG('CBC0010 - COB SCHEDULER +
                     CONTROLLING CL TERMINATED ABNORMALLY') +
                     TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0010003                                           /*S01408*/
/*                                                                    /*S01408*/
                MONMSG     MSGID(CPF0000 MCH0000)
/**/
                CHGDTAARA DTAARA(CBSTAT (17 1)) VALUE('E')
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA DTAARA(CBSTAT (45 1)) VALUE('S')
                MONMSG     MSGID(CPF0000 MCH0000)
/**/
                CHGVAR   VAR(%SST(&MSGD 11 32)) VALUE('SCHEDULER +
                         TERMINATED ABNORMALLY')
                CHGVAR   VAR(%SST(&MSGD 71 8)) VALUE('ERROR   ')
                CALL QSNDDTAQ PARM('CBDTQD    ' '*LIBL     ' +
                         &DTQDLEN &MSGD)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGJOB SWS(XXXXXX11)
/* CALL CB0170 TO SEND MESSAGE TO PF/CBHALTPD TO SHOW COB HALTED */
                CALL       PGM(CB0170) PARM('S' &ERROR)
                MONMSG     MSGID(CPF0000 MCH0000)
                IF         COND(&ERROR *EQ 'Y') THEN(DO)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0010004                                           /*S01408*/
/*                                                                    /*S01408*/
                       SNDPGMMSG  MSG('CB0170 - ERROR PROCESSING FOR +
                           SCHEDULER TERMINATED ABNORMALLY') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBC0010005                                           /*S01408*/
/*                                                                    /*S01408*/
                       MONMSG     MSGID(CPF0000 MCH0000)
                ENDDO
/**/
                DMPCLPGM                                              /*083886*/
/**/                                                                  /*083886*/
/* DEALLOCATE DTAARA/CBCHK FOR RESTART AFTER MACHINE FAILURE CHECK */
/**/
                DLCOBJ     OBJ((CBCHK *DTAARA *EXCL))
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
             ENDPGM
