/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Pay/receive events input cycle')             */
/*********************************************************************/
/*        Midas     - FUNDS TRANSFER MODULE                          */
/*                                                                   */
/*       FTC0630 - PAY/RECEIVE COMPONENT (INPUT CYCLE)               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. CSW220             Date 09Mar20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD037198           Date 26Apr16              */
/*                      AR316373           Date 03Jun15              */
/*                      MD023239           Date 27Mar14              */
/*                      CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207984             Date 31Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CSC014             Date 11Apr02              */
/*                      CCG015             Date 09Aug01              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT006             Date 03Nov99              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPB001             Date 17Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009         Date  09Aug99                 */
/*                      CPL002         Date  08Mar99                 */
/*                      CUT004         Date  08OCT98                 */
/*                      086139         DATE  30MAR95                 */
/*                      S01522         DATE  17JAN95                 */
/*                      085214         DATE  23MAR95                 */
/*                      078314         DATE  24NOV94                 */
/*                      068078         DATE  23DEC93                 */
/*                      E40242         DATE  19JUN92                 */
/*                      E32481         DATE  19AUG91                 */
/*                      E32886         DATE  30MAY91                 */
/*                      S01117         DATE  16AUG90                 */
/*                      S01194         DATE  16AUG90                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSW220 - SWIFT Changes 2020                                 */
/*       MD046248 - Finastra Rebranding                              */
/*       MD037198 - Add OVRDBF for TABFP since FT0640 fails with     */
/*                  DBASE 2 due to format TABTB11F not found.        */
/*       AR316373 - Recompile due to change in /COPY MLCOVRDCL and   */
/*                  MLCOVROVR.                                       */
/*       MD023239 - MT103 should produce 50K tag instead of 50A DUMP */
/*                  after FT0640                                     */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       207984 - Fallover in FTC0630 occurred because of wrong      */
/*                parameter passed to AOSARDR0.  Initialise &SARD    */
/*                before calling AOSARDR0.                           */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CSC014 - Allow support for DBCS (Recompiled)                */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CFT006 - Funds Transfer/Swift Messages MT101/MT102          */
/*       CPB001 - Private Banking Module                             */
/*                Just Recompile                                     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values       */
/*                set to CMTSCOPE(*JOB).                             */
/*       CPL002 - Midas-Plato Interface Enhancement(Recompiled)      */
/*       CUT004 - Allow Core and Non-Core mode of multilanguage      */
/*                compiles of display files                          */
/*       086139 - Prompt immediates                                  */
/*       S01522 - User Defined Correspondence                        */
/*       085214 - 078314 added a message which breaks on the         */
/*                screen if the program ends successfully, thus      */
/*                halting Input Cycle Termination (this fix may      */
/*                not be strictly necessary for R10.6, but can       */
/*                do no harm.                                        */
/*       078314 - Add Global Monitor Message processing              */
/*              - Send warning message if abnormal termination       */
/*       068078 - Allow for message files MEMSG and FTUSRMSG         */
/*       E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF              */
/*                MESSAGES GENERATED                                 */
/*       E32481 - ADDITION OF CALL TO FT0647                         */
/*       E32886 - MULTILANGUAGE INCORPORATION                        */
/*       S01117 - REPORT CONTROL FACILITY (RCF), ADDITIONAL          */
/*                PARAMETERS ADDED.                                  */
/*       S01117 - AUTO PAY/RECEIVE FUNCTIONS AMENDED TO ONLY         */
/*                ALLOW USERS TO GENERATE MESSAGES FOR PAYMENTS      */
/*                THAT THEY HAVE AUTHORIZED, IF AUTO PAY/            */
/*                RECEIVE INDICATOR IN I.C.D. IS SET TO Y.           */
/*       S01194 - NEW DATABASE ERROR HANDLING TO COPE WITH           */
/*                THE NEW STANDING DATA.                             */
/*********************************************************************/
/**/
/*START:      PGM    /*    CL Program for running Pay/Receive     +  /*S01117*/
/*                       Events (Input Cycle) Component         */   /*S01117*/
 START:      PGM        PARM(&RSEQ &RLEV &RENT)              /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/***********DCL     VAR(&DATA)  TYPE(*CHAR) LEN(44)                  /*S01194*/
            DCL     VAR(&DATA)  TYPE(*CHAR) LEN(50)                  /*S01194*/
/***********DCL*****VAR(&USER) TYPE(*CHAR) LEN(10)            /*S01117 CUT004*/
            DCL     VAR(&USER10) TYPE(*CHAR) LEN(10)                 /*CUT004*/
            DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
            DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
            DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
            DCL     VAR(&MSG01) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG02) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG03) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG04) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG05) TYPE(*CHAR) LEN(1)                   /*E32481*/
            DCL     VAR(&MSG06) TYPE(*CHAR) LEN(1)                   /*CFT006*/
            DCL     VAR(&MSG07) TYPE(*CHAR) LEN(1)                   /*CFT006*/
            DCL     VAR(&RMODE) TYPE(*CHAR) LEN(1) VALUE(I)
            DCL     VAR(&DQLEN) TYPE(*DEC) LEN(5 0) VALUE(1)
            DCL     VAR(&CMTSWS) TYPE(*CHAR) LEN(1)
/***********DCL*****VAR(&TELX) TYPE(*CHAR) LEN(1)                     /*E32481*/
/************DCL********VAR(&GROUP) TYPE(*CHAR) LEN(50)        /*E32886 CUT004*/
/************DCL********VAR(&USR) TYPE(*CHAR) LEN(25)          /*E32886 CUT004*/
/************DCL********VAR(&SLEVEL) TYPE(*DEC) LEN(4)         /*E32886 CUT004*/
/************DCL********VAR(&TIMEO) TYPE(*DEC) LEN(5)          /*E32886 CUT004*/
/************DCL********VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)/*E32886 CUT004*/
/************DCL********VAR(&MULT) TYPE(*CHAR) LEN(2)          /*E32886 CUT004*/
             DCL        VAR(&USELG) TYPE(*CHAR) LEN(10)               /*E32886*/
             DCL        VAR(&BASLG) TYPE(*CHAR) LEN(10)               /*E32886*/
             DCL        VAR(&USE) TYPE(*DEC) LEN(4 0) VALUE(11)       /*E32886*/
             DCL        VAR(&BAS) TYPE(*DEC) LEN(4 0) VALUE(1)        /*E32886*/
/************DCL********VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)        /*E32886 CUT004*/
/************DCL********VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&MIDASLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&MACLG) TYPE(*CHAR) LEN(10)        /*E32886 CUT004*/
/************DCL********VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&WNLG) TYPE(*CHAR) LEN(10)         /*E32886 CUT004*/
/************DCL********VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)      /*E32886 CUT004*/
/************DCL********VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)    /*E32886 CUT004*/
/************DCL********VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)      /*E32886 CUT004*/
/************DCL********VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)      /*E32886 CUT004*/
/************DCL********VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)    /*E32886 CUT004*/
/************DCL********VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)    /*E32886 CUT004*/
/************DCL********VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10)     /*068078 CUT004*/
/************DCL********VAR(&MEMSG) TYPE(*CHAR) LEN(10)        /*068078 CUT004*/
/************DCL********VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)     /*S01522 CUT004*/
 
/*/COPY MLCPYSRC,MLCOVRDCL                                         */ /*CUT004*/
 
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&W0UPF) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CFT006')                            /*CFT006*/
/**********  DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ') */              /*CSC011 CCB023*/
/**********  DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2) VALUE(' ') */              /*CSC011 CCB023*/
/**********  DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2) VALUE(' ')   */              /*CSC011 CCB023*/
/**********  DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)          */              /*CSC011 CCB023*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
                                                                                          /*CSC022*/
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSC022*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&CRSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&PSWIFT) TYPE(*CHAR) LEN(6)                                   /*CSW220*/
             DCL        VAR(&PCOB) TYPE(*CHAR) LEN(1) VALUE('N')                          /*CSW220*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                    /*CSW220*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CSW220*/
             DCL        VAR(&ERRCOD) TYPE(*DEC) LEN(1)                                    /*CSW220*/
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
/*/COPY WNCPYSRC,FTC0630002                                          */
 
/* Global message monitor :                                     */    /*078314*/
                                                                      /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*078314*/
                                                                                          /*CSC011*/
/***Check*if*switchable*feature*CSC011*is*on**/                                    /*CSC011 CCB023*/
                                                                                          /*CSC011*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                */              /*CSC011 CCB023*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                */              /*CSC011 CCB023*/
/**********  CHGVAR     VAR(&SARD) VALUE('CSC011')                 */              /*CSC011 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)*/            /*CSC011 CCB023*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO)         */              /*CSC011 CCB023*/
/**********  CHGVAR     VAR(&CSC011) VALUE('Y')                    */              /*CSC011 CCB023*/
/**********  RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&S1SUPP)       */              /*CSC011 CCB023*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)         */              /*CSC011 CCB023*/
/**********  ENDDO                                                 */              /*CSC011 CCB023*/
/**********                                                                        /*CSC011 CCB023*/
/**********  IF         COND((&CSC011 *EQ 'Y') *AND (&S1SUPP *EQ +
/**********     &LIBR)) THEN(DO)                                   */              /*CSC011 CCB023*/
/**********       SNDPGMMSG  MSG('Input Cycle Pay/Receive requested, +
/**********          but not valid on the support system') +
/**********          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)*/            /*CSC011 CCB023*/
/**********       GOTO       CMDLBL(END)                           */              /*CSC011 CCB023*/
/**********  ENDDO                                                 */              /*CSC011 CCB023*/
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JBNM)) THEN(DO)                                                /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
 
/*/COPY WNCPYSRC,FTC0630004                                          */
 
/************RTVDTAARA**DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)     /*E32886 CUT004*/
/************RTVDTAARA**DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)     /*E32886 CUT004*/
/**/                                                                  /*S01117*/
/*     RETRIEVE JOB ATTRIBUTES TO GET USER PROFILE TO      */         /*S01117*/
/*     BE SENT AS A PARAMETER TO THE CALLED RPG PROGRAMS.  */         /*S01117*/
/**/                                                                  /*S01117*/
/************RTVJOBA*USER(&USER)                               /*S01117 CUT004*/
             RTVJOBA USER(&USER10)                                    /*CUT004*/
/**/
/*/COPY WNCPYSRC,FTC0630009                                          */
 
/*/COPY MLCPYSRC,MLCOVROVR                                         */ /*CUT004*/
 
/************RTVDTAARA**DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)     /*E32886 CUT004*/
/************RTVDTAARA**DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)     /*E32886 CUT004*/
/***********************                                       /*078314 CUT004*/
/************CALL*******PGM(SD2320) PARM(&GROUP &USR &SLEVEL &TIMEO  +        */
/*************************&ERRORC &MULT)                  /*E32886*/  /*S01117*/
/************CALL*******PGM(SF0410) PARM(&GROUP &USR &SLEVEL &TIMEO  +  CUT004*/
/*************************&ERRORC &MULT)                       /*S01117 CUT004*/
/***********************                                              /*CUT004*/
/************IF*********COND(&MULT *EQ '  ') THEN(DO)          /*E32886 CUT004*/
/************CHGVAR*****VAR(&MULT) VALUE('GB')                 /*E32886 CUT004*/
/************ENDDO******                                       /*E32886 CUT004*/
/***********************                                              /*CUT004*/
/*****CHGVAR***VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF') /*E32886 CUT004*/
/***********************                                       /*078314 CUT004*/
/*****CHGVAR*****VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))    /*078314 CUT004*/
/*****CHGVAR*****VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))    /*078314 CUT004*/
/***********************                                              /*CUT004*/
/*****CHGVAR*****VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)     /*E32886 CUT004*/
/*****CHGVAR*****VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)     /*E32886 CUT004*/
/*****CHGVAR*****VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*E32886 CUT004*/
/*****CHGVAR*****VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')  /*E32886 CUT004*/
/*****CHGVAR*****VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')    /*E32886 CUT004*/
/*****CHGVAR*****VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')  /*E32886 CUT004*/
/*****CHGVAR*****VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')     /*E32886 CUT004*/
/*****CHGVAR*****VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')  /*E32886 CUT004*/
/*****CHGVAR*****VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*E32886 CUT004*/
/*****CHGVAR****VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ') /*E32886 CUT004*/
/*****CHGVAR*****VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') /*068078 CUT004*/
/*****CHGVAR*****VAR(&MEMSG) VALUE(&MULT *CAT 'MEMSG  ')       /*068078 CUT004*/
/*****CHGVAR*****VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*S01522 CUT004*/
/***********************                                              /*CUT004*/
/************OVRMSGF****MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)         /*E32886 CUT004*/
/***********************                                              /*CUT004*/
/************OVRMSGF****MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)      /*E32886 CUT004*/
/************OVRMSGF****MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)      /*E32886 CUT004*/
/************OVRMSGF****MSGF(MIDAS) TOMSGF(&MIDASLG)           /*E32886 CUT004*/
/************OVRMSGF****MSGF(DRSMM) TOMSGF(&DRSMMLG)           /*E32886 CUT004*/
/************OVRMSGF****MSGF(MACMSG) TOMSGF(&MACLG)            /*E32886 CUT004*/
/************OVRMSGF****MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)        /*E32886 CUT004*/
/************OVRMSGF****MSGF(WNMSGF) TOMSGF(&WNLG)             /*E32886 CUT004*/
/************OVRMSGF****MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)        /*E32886 CUT004*/
/************OVRMSGF****MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)        /*E32886 CUT004*/
/************OVRMSGF****MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)      /*E32886 CUT004*/
/************OVRMSGF****MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)       /*068078 CUT004*/
/************OVRMSGF****MSGF(MEMSG) TOMSGF(&MEMSG)             /*068078 CUT004*/
/************OVRMSGF****MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)       /*S01522 CUT004*/
 
/* TERMINATE IF USER NOT FOUND                                      */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*     C O M P O N E N T   A C T I V E  ?                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
            ALCOBJ     OBJ((FTC0630 *DTAARA *EXCLRD)) WAIT(1)
            MONMSG     MSGID(CPF1002) EXEC(DO)
            SNDPGMMSG  MSG('FTC0630 - Procedure already Active') +
                          TOPGMQ(*EXT)
                       GOTO ENDB
            ENDDO
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*    CREATE LDA IF NOT IN LIBRARY LIST - EG SUBMITTED JOB */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */         /*E40242*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
/**/                                                                  /*E40242*/
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*     P R O C E S S   C O M P O N E N T                   */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 3 0  - - -      **/
/*                    - - - - - - - - - - - -        */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTSWS) +
                          VALUE('1'))
/*/COPY WNCPYSRC,FTC0630001                                          */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0630)                                       /*S01117*/
/************CALL*******PGM(FT0630) PARM(&USER)               /*S01117 CUT004*/
             CALL       PGM(FT0630) PARM(&USER10)                    /*CUT004*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
        CHGJOB     SWS(XXXXXXX1)
                   GOTO END
        ENDDO
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*/COPY WNCPYSRC,FTC0630008                                          */
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 6 0  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0660) PARM(&RMODE)                          /*S01117*/
        CALL       PGM(FT0660) PARM(&RMODE &RSEQ)                    /*S01117*/
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 6 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0665) PARM(&RMODE)                          /*S01117*/
        CALL       PGM(FT0665) PARM(&RMODE &RSEQ)                    /*S01117*/
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 7 0  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0670) PARM(&RMODE)                          /*S01117*/
        CALL       PGM(FT0670) PARM(&RMODE &RSEQ)                    /*S01117*/
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 7 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0675)  PARM(&RMODE)                         /*S01117*/
        CALL       PGM(FT0675)  PARM(&RMODE &RSEQ)                   /*S01117*/
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */               /*S01522*/
/**  Call Program    - - -  C G 4 9 5 0  - - -      **/               /*S01522*/
/*                    - - - - - - - - - - - -        */               /*S01522*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*S01522*/
             GOTO       CMDLBL(DBERR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CG4950) PARM(&W0RTN &W0UPF &W0CMT)        /*S01522*/
                                                                      /*S01522*/
/**********  RCLRSC                                        */                    /*S01522 MD023239*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             GOTO       CMDLBL(DBERR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
                GOTO       CMDLBL(DBERR)                                                  /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                                                                                          /*CCG015*/
             ENDDO                                                    /*S01522*/
 
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 4 0  - - -      **/
/*                    - - - - - - - - - - - -        */
/*/COPY WNCPYSRC,FTC0630017                                          */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0640) PARM(&RMODE &MSG01)                    /*S01117*/
/*/COPY WNCPYSRC,FTC0630013                                          */
        OVRDBF     FILE(TABFP) SHARE(*NO)                                               /*MD037198*/
        CALL       PGM(FT0640) PARM(&RMODE &MSG01 &RSEQ)              /*S01117*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
        CHGJOB     SWS(XXXXXXX1)
                   GOTO END
        ENDDO
/*/COPY WNCPYSRC,FTC0630014                                          */
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/**  Call FT000199  **/
/**/
        CHGJOB     SWS(XXXXXX00)                                                          /*CSW220*/
        CHGVAR     VAR(&RTCD) VALUE('       ')                                            /*CSW220*/
        CHGVAR     VAR(&PSWIFT) VALUE('CSW220')                                           /*CSW220*/
        CALL   PGM(SWIFTACTV) PARM(&PSWIFT &RTCD)                                         /*CSW220*/
        IF     COND(&RTCD *EQ 'CSWACTV') THEN(DO)                                         /*CSW220*/
/*  Check that ZMUSER dataarea has been set up in QTEMP, if not   */                      /*CSW220*/
/*  create it here.                                               */                      /*CSW220*/
                                                                                          /*CSW220*/
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)                                /*CSW220*/
                                                                                          /*CSW220*/
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)                                   /*CSW220*/
               CALL       PGM(ZMUSER) PARM(&ERRCOD &ZMUSER)                               /*CSW220*/
               IF         COND(&ERRCOD *NE 0) THEN(DO)                                    /*CSW220*/
                 SNDPGMMSG MSG('Default Branch or Department not valid') +
                       TOPGMQ(*EXT) MSGTYPE(*INFO)                                        /*CSW220*/
               ENDDO       /*CSW220*/
             ENDDO       /*CSW220*/
        CALL       PGM(CBC001001) PARM(&MPHAS)                                            /*CSW220*/
        IF         COND(&MPHAS *EQ '*YES') THEN(DO)                                       /*CSW220*/
        CHGVAR     VAR(&PCOB) VALUE('Y')                                                  /*CSW220*/
        ENDDO       /*CSW220*/
        CALL       PGM(FT000199) PARM(&PCOB &RTCD)                                        /*CSW220*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                                /*CSW220*/
 /**/                                                                                     /*CSW220*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSW220*/
 /**   job is not currently running in batch mode */                                      /*CSW220*/
 /**/                                                                                     /*CSW220*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSW220*/
                   ROLLBACK                                                               /*CSW220*/
             ENDDO       /*CSW220*/
             ELSE       CMD(DO)                                                           /*CSW220*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSW220*/
                        ROLLBACK                                                          /*CSW220*/
             ENDDO       /*CSW220*/
             ELSE       DO                                                                /*CSW220*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSW220*/
             ENDDO       /*CSW220*/
             ENDDO       /*CSW220*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)                                                /*CSW220*/
        CHGJOB     SWS(XXXXXXX1)                                                          /*CSW220*/
                   GOTO END                                                               /*CSW220*/
        ENDDO       /*CSW220*/
        ENDDO       /*CSW220*/
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)                                       /*CSW220*/
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 4 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0645)  PARM(&RMODE &MSG02)                   /*S01117*/
/*/COPY WNCPYSRC,FTC0630015                                          */
        CALL       PGM(FT0645)  PARM(&RMODE &MSG02 &RSEQ)             /*S01117*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
        CHGJOB     SWS(XXXXXXX1)
                   GOTO END
        ENDDO
/*/COPY WNCPYSRC,FTC0630016                                          */
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */              /*E32481*/
/**  Call Program    - - -  F T 0 6 4 7  - - -      **/              /*E32481*/
/*                    - - - - - - - - - - - -        */              /*E32481*/
        CHGJOB     SWS(XXXXXX00)                                     /*E32481*/
        CALL       PGM(FT0647)  PARM(&RMODE &MSG05 &RSEQ)            /*E32481*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)           /*E32481*/
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK                                          /*E32481*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)                           /*E32481*/
        CHGJOB     SWS(XXXXXXX1)                                     /*E32481*/
                   GOTO END                                          /*E32481*/
        ENDDO                                                        /*E32481*/
/**/                                                                 /*E32481*/
/**  Check for Database Errors Trapped by Program  **/               /*E32481*/
/**/                                                                 /*E32481*/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)                  /*E32481*/
/*/COPY WNCPYSRC,FTC0630005                                          */
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 5 0  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0650)  PARM(&RMODE &MSG03)                   /*S01117*/
        CALL       PGM(FT0650)  PARM(&RMODE &MSG03 &RSEQ)             /*S01117*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
        CHGJOB     SWS(XXXXXXX1)
                   GOTO END
        ENDDO
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 5 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*******CALL       PGM(FT0655)  PARM(&RMODE &MSG04)                   /*S01117*/
        CALL       PGM(FT0655)  PARM(&RMODE &MSG04 &RSEQ)             /*S01117*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
        CHGJOB     SWS(XXXXXXX1)
                   GOTO END
        ENDDO
/**/                                                                  /*CFT006*/
/**  Check for Database Errors Trapped by Program  **/                /*CFT006*/
/**/                                                                  /*CFT006*/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)                   /*CFT006*/
 
        CHGVAR     VAR(&RTCD) VALUE('       ')                        /*CFT006*/
        CHGVAR     VAR(&SARD) VALUE('CFT006')                                             /*207984*/
        CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                        /*CFT006*/
 
        CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                  /*CFT006*/
 
        IF     COND(&RTCD *EQ '       ') THEN(DO)                     /*CFT006*/
/*                                                   */               /*CFT006*/
/* Call Program FT0657                               */               /*CFT006*/
/*                                                   */               /*CFT006*/
        CHGJOB     SWS(XXXXXX00)                                      /*CFT006*/
        CALL       PGM(FT0657)  PARM(&RMODE &MSG06 &RSEQ)             /*CFT006*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)            /*CFT006*/
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK                                           /*CFT006*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)                            /*CFT006*/
        CHGJOB     SWS(XXXXXXX1)                                      /*CFT006*/
                   GOTO END                                           /*CFT006*/
        ENDDO                                                         /*CFT006*/
        ENDDO                                                         /*CFT006*/
/**/                                                                  /*CFT006*/
/**  Check for Database Errors Trapped by Program  **/                /*CFT006*/
/**/                                                                  /*CFT006*/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)                   /*CFT006*/
                                                                      /*CFT006*/
        CHGVAR     VAR(&RTCD) VALUE('       ')                        /*CFT006*/
        CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                        /*CFT006*/
        CHGVAR     VAR(&SARD) VALUE('CFT008')                         /*CFT006*/
                                                                      /*CFT006*/
        CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                  /*CFT006*/
        IF     COND(&RTCD *EQ '       ') THEN(DO)                     /*CFT006*/
/*                                                   */               /*CFT006*/
/* Call Program FT0658                               */               /*CFT006*/
/*                                                   */               /*CFT006*/
        CHGJOB     SWS(XXXXXX00)                                      /*CFT006*/
        CALL       PGM(FT0658)  PARM(&RMODE &MSG07 &RSEQ)             /*CFT006*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)            /*CFT006*/
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK                                           /*CFT006*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)                            /*CFT006*/
        CHGJOB     SWS(XXXXXXX1)                                      /*CFT006*/
                   GOTO END                                           /*CFT006*/
        ENDDO                                                         /*CFT006*/
        ENDDO                                                         /*CFT006*/
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*/COPY WNCPYSRC,FTC0630012                                          */
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*     A N Y   M E S S A G E   P R O D U C T I O N  ?      */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
   /*   IF        ((&MSG01 = 'Y')   +
              *OR  (&MSG02 = 'Y')   +
              *OR  (&MSG03 = 'Y')   +
              *OR  (&MSG04 = 'Y'))     THEN(DO) */                   /*E32481*/
/**/
/*/COPY WNCPYSRC,FTC0630006                                          */
             IF         COND((&MSG01 = 'Y') *OR (&MSG02 = 'Y') *OR +
                          (&MSG03 = 'Y') *OR (&MSG04 = 'Y') *OR +
                          (&MSG05 = 'Y')) THEN(DO)                   /*E32481*/
/*/COPY WNCPYSRC,FTC0630007                                          */
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*     S E N D   M E S S A G E   ' C '   T O   D T A Q     */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
             CALL       PGM(QSNDDTAQ) PARM(MSDTQA *LIBL &DQLEN 'C')
             ENDDO
        DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))
/**/
/****IF*TELEX*PRESENT*CALL*MT0010*TO*CONVERT*MESSAGES***/            /*E32481*/
/****                                                                /*E32481*/
/****        RTVDTAARA  DTAARA(MMOD (53 1)) RTNVAR(&TELX)            /*E32481*/
/****        IF         COND(&TELX *EQ 'Y') THEN(DO)                 /*E32481*/
/****           CALL PGM(MTC0010)                                    /*E32481*/
/****   MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)           /*E32481*/
/****              ROLLBACK                                          /*E32481*/
/****              SNDPGMMSG  MSG('Transaction Failed.               /*E32481*/
/****                              Re-input Necessary.               /*E32481*/
/****                            Press Enter to Continue.')          /*E32481*/
/****                         TOPGMQ(*EXT)                           /*E32481*/
/****   CHGJOB     SWS(XXXXXXX1)                                     /*E32481*/
/****              GOTO END                                          /*E32481*/
/****   ENDDO                                                        /*E32481*/
/****                                                                /*E32481*/
/****Check for Database Errors Trapped by Program  **/               /*E32481*/
/****                                                                /*E32481*/
/****   IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)                  /*E32481*/
/****   ENDDO                                                        /*E32481*/
/**/
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 8 0  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0680)
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                   ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
        CHGJOB     SWS(XXXXXXX1)
                   GOTO END
        ENDDO
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*/COPY WNCPYSRC,FTC0630003                                          */
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**       S U C C E S S F U L   C O M P L E T I O N       **/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*  */                                                                /*086139*/
/*  If phase A and UDC then prompt */                                 /*086139*/
/*  */                                                                /*086139*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*086139*/
                                                                      /*086139*/
/* Prompt for immediate print */                                      /*086139*/
             CALL       PGM(CGC5217) PARM(' ')                        /*086139*/
             MONMSG     MSGID(CPF0000)                                /*086139*/
             ENDDO                                                    /*086139*/
/**/                                                                  /*078314*/
/************SNDPGMMSG  MSG('Funds Transfer Pay/Receive run +         /*085214*/
/************             completed - SUCCESFULLY') TOPGMQ(*EXT) +    /*085214*/
/************             TOMSGQ(MOPERQ MRUNQ)             /*078314*/ /*085214*/
             SNDPGMMSG  MSG('Funds Transfer Pay/Receive run +
                          completed successfully') TOMSGQ(MRUNQ)      /*085214*/
                                                                      /*086139*/
        GOTO END
/**/
/**  Report  Database  Errors Trapped by Program  **/
/**/
/**DBERR:*****RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)          /*S01194*/
DBERR:     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)             /*S01194*/
           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                      TOMSGQ(MOPERQ MRUNQ)  TOPGMQ(*EXT)              /*078314*/
/*********************TOMSGQ(MOPERQ)  TOPGMQ(*EXT)                    /*078314*/
/**/
/**/
/*  Abnormal termination processing  */                               /*078314*/
ABNOR:                                                                /*078314*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
             ROLLBACK                                                 /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
             SNDPGMMSG  MSG('Request has terminated abnormally. +
                          Please contact your system supervisor') +
                          TOPGMQ(*EXT)                                /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
             SNDPGMMSG  MSG('Funds Transfer Pay/Receive run +
                          completed - ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
             DMPCLPGM                                                 /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
             CHGJOB     SWS(XXXXXXX1)                                 /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/**/                                                                  /*078314*/
/*  Normal termination processing  */                                 /*078314*/
 END:        DLCOBJ     OBJ((FTC0630 *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
                                                                      /*E40242*/
/*/COPY WNCPYSRC,FTC0630010                                          */
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('FT' 'P' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
/*/COPY WNCPYSRC,FTC0630011                                          */
                                                                      /*E40242*/
 /**/
/*************IF         COND(&CMTSWS *NE '1') THEN(ENDCMTCTL)     */ /*078314*/
             IF         COND(&CMTSWS *NE '1') THEN(DO)                /*078314*/
             ENDCMTCTL                                                /*078314*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*078314*/
             ENDDO                                                    /*078314*/
/**/                                                                  /*078314*/
ENDB:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
               ENDPGM                                                /*S01117*/
/**ENDB:*******ENDPGM                                                /*S01117*/
/******CHGVAR*&BISCPY*'(C)*COPYRIGHT*ACT*INTERNATIONAL*LIMITED*1994'   *078314*/
