/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Extract file instance management')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3605  -  Extract File Instance Management                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. CPK030             Date 11Apr14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG17817A          Date 15Apr08              */
/*                      BUG17817           Date 09Apr08              */
/*                      248342             Date 11Jun07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG8894            Date 30Nov05              */
/*                      BUG8248            Date 02Sep05              */
/*                      BUG6604            Date 06Aug05              */
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015  *CREATE    DATE 26Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK030 - Clean up of deliverable data library.              */
/*       BUG17817A - Add parameter OPTION(*NOSRC) in CRTLF command   */
/*       BUG17817 - Reverse fix for BUG6604. MOVOBJ command should   */
/*                  not be used as it removes the object from it's   */
/*                  original library. Use CRTLF instead of CRTOBJ    */
/*       248342 - Apply core MP1.3 fix BUG8248.                      */
/*       BUG8894 - DLC210A job ends in MSGW due to CPF3231           */
/*       BUG8248 - Avoid multiple occurence for CGC3605              */
/*       BUG6604 - Avoid using CRTOBJ and removal of RCLRSC          */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ACTION)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
/* */
/* Declare variables */
/* */
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARFMT) TYPE(*CHAR) LEN(200)
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
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                        */ /*BUG6604 CPK030*/
/**********  DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)                        */ /*BUG6604 CPK030*/
             DCL        VAR(&SQLSTR) TYPE(*CHAR) LEN(5000)                              /*  CPK030*/
                                                                                          /*CSC022*/
/**********  CHGVAR     VAR(&CRSKIP) VALUE('N')                                    /*CSC022 CPK030*/
/**********  CHGVAR     VAR(&RTNCDE) VALUE('       ')                              /*CSC022 CPK030*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                             */ /*CSC022 CPK030*/
/**********  CHGVAR     VAR(&SAR) VALUE('CSC022')                               */ /*CSC022 CPK030*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
             CHGJOB     SWS(XXXXX000)
/* */
/* Check if Correspondence manager is switched on                   */
             CHGVAR     VAR(&RETURN) VALUE('       ')
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')
             CHGVAR     VAR(&SARNBR) VALUE('CCG015')
/* */
             CALL       PGM(AOSARDR0) PARM(&RETURN &OPTION &SARNBR +
                          &SARFMT)
/* */
             IF         COND(&RETURN *NE '       ') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CPK030*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CPK030*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CPK030*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CPK030*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CPK030*/
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
/* Override files                                                   */
/* Files are duplicated in library QTEMP                            */
/* An extraction job will handle its own set of data                */
/* CGUXMGPD and CGUXMRPD are temporary files, and are not under     */
/* commitment control                                               */
/**Move*the*logicals*to*the*same*library*as*the*physicals,*so*that***/      /*BUG6604*/ /*BUG17817*/
/**CRTDUPOBJ*wil*recreate*the*access*paths.**Can*then*avoid*using****/      /*BUG6604*/ /*BUG17817*/
/**CRTOBJ.                                                          */      /*BUG6604*/ /*BUG17817*/
             IF         COND(&ACTION *EQ '*PREPARE') THEN(DO)
                                                                                         /*BUG8248*/
ALLOC:       ALCOBJ     OBJ((CGC3605DTA *DTAARA *EXCLRD)) WAIT(3)                        /*BUG8248*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALLOC))                          /*BUG8248*/
                                                                                         /*BUG8248*/
             CHKOBJ     OBJ(QTEMP/CGUXMGPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************  CPYF       FROMFILE(CGUXMGPD) TOFILE(QTEMP/CGUXMGPD) +                    /*BUG6604*/
/************             CRTFILE(*YES)                                                  /*BUG6604*/
               CPYF       FROMFILE(CGUXMGPD) TOFILE(QTEMP/CGUXMGPD) +
                          CRTFILE(*YES)                                                 /*BUG17817*/
/**********     RTVOBJD    OBJ(CGUXMGPD) OBJTYPE(*FILE) RTNLIB(&DPLIB)      /*BUG6604*/ /*BUG17817*/
/**********     CHGVAR     VAR(&DVLIB) VALUE(%SST(&DPLIB 1 2) *CAT +                    /*BUG17817*/
/**********                  'DVLIB')                                       /*BUG6604*/ /*BUG17817*/
/**********     MOVOBJ     OBJ(CGUXMGL1) OBJTYPE(*FILE) TOLIB(&DPLIB)       /*BUG6604*/ /*BUG17817*/
/**********     MONMSG     MSGID(CPF0602)                                        /*BUG6604 BUG8894*/
/**********     MONMSG     MSGID(CPF0602 CPF2135)                           /*BUG8894*/ /*BUG17817*/
/**********     MOVOBJ     OBJ(CGUXMGL2) OBJTYPE(*FILE) TOLIB(&DPLIB)       /*BUG6604*/ /*BUG17817*/
/**********     MONMSG     MSGID(CPF0602)                                        /*BUG6604 BUG8894*/
/**********     MONMSG     MSGID(CPF0602 CPF2135)                           /*BUG8894*/ /*BUG17817*/
/**********     CRTDUPOBJ  OBJ(CGUXMG*) FROMLIB(&DPLIB) OBJTYPE(*FILE) +                /*BUG17817*/
/**********                  TOLIB(QTEMP)                                   /*BUG6604*/ /*BUG17817*/
/**********     MOVOBJ     OBJ(CGUXMGL1) OBJTYPE(*FILE) TOLIB(&DVLIB)        /*BUG6604*/ /*BUG8894*/
/**********     MOVOBJ     OBJ(CGUXMGL2) OBJTYPE(*FILE) TOLIB(&DVLIB)        /*BUG6604*/ /*BUG8894*/
/**********     MOVOBJ     OBJ(&DPLIB/CGUXMGL1) OBJTYPE(*FILE) +                        /*BUG17817*/
/**********                TOLIB(&DVLIB)                                    /*BUG8894*/ /*BUG17817*/
/**********     MOVOBJ     OBJ(&DPLIB/CGUXMGL2) OBJTYPE(*FILE) +                        /*BUG17817*/
/**********                TOLIB(&DVLIB)                                    /*BUG8894*/ /*BUG17817*/
             ENDDO
             CLRPFM QTEMP/CGUXMGPD
 
             CHKOBJ     OBJ(QTEMP/CGUXMRPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************  CPYF       FROMFILE(CGUXMRPD) TOFILE(QTEMP/CGUXMRPD) +                    /*BUG6604*/
/************             CRTFILE(*YES)                                                  /*BUG6604*/
               CPYF       FROMFILE(CGUXMRPD) TOFILE(QTEMP/CGUXMRPD) +
                          CRTFILE(*YES)                                                 /*BUG17817*/
/**********     RTVOBJD    OBJ(CGUXMRPD) OBJTYPE(*FILE) RTNLIB(&DPLIB)      /*BUG6604*/ /*BUG17817*/
/**********     CHGVAR     VAR(&DVLIB) VALUE(%SST(&DPLIB 1 2) *CAT +                    /*BUG17817*/
/**********                  'DVLIB')                                       /*BUG6604*/ /*BUG17817*/
/**********     MOVOBJ     OBJ(CGUXMRL1) OBJTYPE(*FILE) TOLIB(&DPLIB)       /*BUG6604*/ /*BUG17817*/
/**********     MONMSG     MSGID(CPF0602)                                        /*BUG6604 BUG8894*/
/**********     MONMSG     MSGID(CPF0602 CPF2135)                           /*BUG8894*/ /*BUG17817*/
/**********     CRTDUPOBJ  OBJ(CGUXMR*) FROMLIB(&DPLIB) OBJTYPE(*FILE) +                /*BUG17817*/
/**********                  TOLIB(QTEMP)                                   /*BUG6604*/ /*BUG17817*/
/**********     MOVOBJ     OBJ(CGUXMRL1) OBJTYPE(*FILE) TOLIB(&DVLIB)        /*BUG6604*/ /*BUG8894*/
/**********     MOVOBJ     OBJ(&DPLIB/CGUXMRL1) OBJTYPE(*FILE) +                        /*BUG17817*/
/**********                TOLIB(&DVLIB)                                    /*BUG8894*/ /*BUG17817*/
             ENDDO
             CLRPFM QTEMP/CGUXMRPD
 
/************CHKOBJ     OBJ(QTEMP/CGUXMGL1) OBJTYPE(*FILE)                               /*BUG6604*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                                          /*BUG6604*/
/************  CRTOBJ     SRCMBR(CGUXMGL1) SRCFILE(CGDDSSRCQT) +                         /*BUG6604*/
/************             PLIB(QTEMP)                                                    /*BUG6604*/
/************ENDDO                                                                       /*BUG6604*/
/************CHKOBJ     OBJ(QTEMP/CGUXMGL2) OBJTYPE(*FILE)                               /*BUG6604*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                                          /*BUG6604*/
/************  CRTOBJ     SRCMBR(CGUXMGL2) SRCFILE(CGDDSSRCQT) +                         /*BUG6604*/
/************             PLIB(QTEMP)                                                    /*BUG6604*/
/************ENDDO                                                                       /*BUG6604*/
/************CHKOBJ     OBJ(QTEMP/CGUXMRL1) OBJTYPE(*FILE)                               /*BUG6604*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                                          /*BUG6604*/
/************  CRTOBJ     SRCMBR(CGUXMRL1) SRCFILE(CGDDSSRCQT) +                         /*BUG6604*/
/************             PLIB(QTEMP)                                                    /*BUG6604*/
/************ENDDO                                                                       /*BUG6604*/
             CHKOBJ     OBJ(QTEMP/CGUXMGL1) OBJTYPE(*FILE)                              /*BUG17817*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*BUG17817*/
/**********    CRTLF      FILE(QTEMP/CGUXMGL1) SRCFILE(CGDDSSRCQT) +                   */ /*CPK030*/
/**********               SRCMBR(CGUXMGL1) OPTION(*NOSRC) MAINT(*IMMED) +              */ /*CPK030*/
/**********               SHARE(*NO)                                         */ /*BUG17817A CPK030*/
/**********               SRCMBR(CGUXMGL1) MAINT(*IMMED) SHARE(*NO)       /*BUG17817*/ /*BUG17817A*/
                CHGVAR     VAR(&SQLSTR) VALUE('create index +
                             QTEMP/CGUXMGL1 on QTEMP/CGUXMGPD (DGITEM, +
                             DGINCR, DGNWGS)')                                            /*CPK030*/
                RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                     /*CPK030*/
             ENDDO                                                                      /*BUG17817*/
             CHKOBJ     OBJ(QTEMP/CGUXMGL2) OBJTYPE(*FILE)                              /*BUG17817*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*BUG17817*/
/**********    CRTLF      FILE(QTEMP/CGUXMGL2) SRCFILE(CGDDSSRCQT) +                   */ /*CPK030*/
/**********               SRCMBR(CGUXMGL2) OPTION(*NOSRC) MAINT(*IMMED) +              */ /*CPK030*/
/**********               SHARE(*NO)                                         */ /*BUG17817A CPK030*/
/**********               SRCMBR(CGUXMGL2) MAINT(*IMMED) SHARE(*NO)       /*BUG17817*/ /*BUG17817A*/
                CHGVAR     VAR(&SQLSTR) VALUE('create index +
                             QTEMP/CGUXMGL2 on QTEMP/CGUXMGPD (DGSHNM, +
                             DGITEM)')                                                    /*CPK030*/
                RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                     /*CPK030*/
             ENDDO                                                                      /*BUG17817*/
             CHKOBJ     OBJ(QTEMP/CGUXMRL1) OBJTYPE(*FILE)                              /*BUG17817*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*BUG17817*/
/**********    CRTLF      FILE(QTEMP/CGUXMRL1) SRCFILE(CGDDSSRCQT) +                   */ /*CPK030*/
/**********               SRCMBR(CGUXMRL1) OPTION(*NOSRC) MAINT(*IMMED) +              */ /*CPK030*/
/**********               SHARE(*NO)                                         */ /*BUG17817A CPK030*/
/**********               SRCMBR(CGUXMRL1) MAINT(*IMMED) SHARE(*NO)       /*BUG17817*/ /*BUG17817A*/
                CHGVAR     VAR(&SQLSTR) VALUE('create index +
                             QTEMP/CGUXMRL1 on QTEMP/CGUXMRPD (DEITEM, +
                             DEINCR, DENWRD)')                                            /*CPK030*/
                RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                     /*CPK030*/
             ENDDO                                                                      /*BUG17817*/
             OVRDBF     FILE(CGUXMGPD) TOFILE(QTEMP/CGUXMGPD) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(CGUXMRPD) TOFILE(QTEMP/CGUXMRPD) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(CGUXMGL1) TOFILE(QTEMP/CGUXMGL1) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(CGUXMGL2) TOFILE(QTEMP/CGUXMGL2) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(CGUXMRL1) TOFILE(QTEMP/CGUXMRL1) +
                          OVRSCOPE(*JOB)
                                                                                         /*BUG8248*/
             DLCOBJ     OBJ((CGC3605DTA *DTAARA *EXCLRD))                                /*BUG8248*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG8248*/
                                                                                         /*BUG8248*/
             ENDDO
/* */
/* Delete overrides                                                 */
/* The errors are trapped, as this program can be called several    */
/* times in mode *CLEAR                                             */
             IF         COND(&ACTION *EQ '*CLEAR  ') THEN(DO)
             DLTOVR     FILE(CGUXMGPD) LVL(*JOB)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(CGUXMRPD) LVL(*JOB)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(CGUXMGL1) LVL(*JOB)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(CGUXMGL2) LVL(*JOB)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(CGUXMRL1) LVL(*JOB)
             MONMSG     MSGID(CPF9841)
             ENDDO
 
             GOTO       CMDLBL(ENDCLPGM)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC3605 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDDO                                                                        /*CSC022*/
/**/
 ENDCLPGM:                                                                               /*BUG6604*/
/***** ENDCLPGM:   RCLRSC     LVL(*CALLER)  *******/                                     /*BUG6604*/
/*******     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6604*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
