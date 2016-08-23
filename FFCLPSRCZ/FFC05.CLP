/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Input cycle termination')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas      -  Futures and Options Module                    */
/*                                                                   */
/*       FFC05  -  INPUT CYCLE TERMINATION - FUTURES AND OPTIONS     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB014             Date 25Apr05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CAP067             Date 21Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731             Date 11Jul01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      169827             Date 26Jan01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      079666             Date 01Dec94              */
/*                      061457             Date 16Mar94              */
/*                      RT0117             DATE 23MAY91              */
/*                      FF0026             DATE 18JAN91              */
/*                      E23088             DATE 02AUG90              */
/*                      E22558             DATE 20JUN90              */
/*                      S01117             DATE 23JAN90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*                Use hooks FFC05003,006,009,012,015,018             */
/*       CAP067 - Make PF/FFDEALS and LF/FFDLS1 permanent files.     */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO            */
/*                instead of *YES                                    */
/*       169827 - A database error with blank information was issued */
/*                (i.e. Database Error in file , key, in FF0690, at).*/
/*                Job Switches 7 & 8 was set on by other programs.   */
/*                Fix is to initialise switches 7 & 8 before         */
/*                calling program FF0690.                            */
/*       079666  -  Add ABNOR processing                             */
/*       061457  -  Monitor message when the objects to be renamed   */
/*                  is not available.                                */
/*       RT0117  -  CHANGE DLIB TO DVLIB                             */
/*       FO0026  -  AMENDMENT TO E23088 - DELETION OF FFDLSI AND     */
/*                  FFDEALS SHOULD NOT BE CONDITIONED ON RESTART     */
/*                  SINCE FFC05 MAY COMPLETE SUCCESFULLY BUT MAY BE  */
/*                  RERUN DUE TO ERROR IN A LATER COMPONENT CALLED   */
/*                  BY SDC05.                                        */
/*       E23088  -  PROGRAM SHOULD BE RESTARTABLE - FILE CHANGES     */
/*                  AND RENAMES SHOULD BE REVERSED OUT IF RESTART.   */
/*       E22558  -  TAKE COPY OF FILE DEALSDD FOR USE LATER ON BY    */
/*                  FF0510 (CLIENT COB UPDATES).                     */
/*       S01117  -  MULTIBRANCHING                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/*/COPY WNCPYSRC,FFC05003                                            */
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)                                 /*CCB014*/
             DCL        VAR(&SCHREQ) TYPE(*CHAR) LEN(1)                                   /*CCB014*/
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                                    /*CCB014*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)                                    /*CCB014*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)                                    /*CCB014*/
             DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)                                /*CCB014*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&B) TYPE(*DEC) LEN(2 0) VALUE(1)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MARKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&FFPRP) TYPE(*CHAR) LEN(31)
/**********  DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)                    /*E22558*/ /*CAP067*/
/**********  DCL        VAR(&FFSTAT)  TYPE(*CHAR)  LEN(256)                    /*E23088*/ /*CAP067*/
/**********  DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                           /*E22558*/ /*CAP067*/
/**********  DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)                       /*E22558*/ /*CAP067*/
/**********  DCL        VAR(&TOMLIB)  TYPE(*CHAR) LEN(10)                      /*E22558*/ /*CAP067*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
/**************           CMDLBL(MONMSG))                      /*E23088 079666*/
/**/
             SNDPGMMSG  MSG('Input Cycle Termination - FUTURES') +
                        TOMSGQ(MRUNQ)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*/COPY WNCPYSRC,FFC05006                                            */
/* CHECK TO SEE IF AUTOMATIC SCHEDULING IS ON                     */                      /*CCB014*/
                                                                                          /*CCB014*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&SCHREQ)                              /*CCB014*/
                                                                                          /*CCB014*/
/* CHECK TO SEE IF THE DELAY COB FEATURE IS SET ON (CCB014)       */                      /*CCB014*/
                                                                                          /*CCB014*/
                   CHGVAR     VAR(&SRTCD) VALUE('       ')                                /*CCB014*/
                   CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                /*CCB014*/
                   CHGVAR     VAR(&SSARD) VALUE('CCB014')                                 /*CCB014*/
                                                                                          /*CCB014*/
                   CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                                &SSCSARD)                                                 /*CCB014*/
             IF         COND(&SRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))                                        /*CCB014*/
/**/
/**IF*PROGRAM*IS*RESTARTED*AFTER*ERROR,*RESET*FILE*NAMES*ETC    *E23088*FO0026*/
/************RTVDTAARA*DTAARA(FFSTAT)*RTNVAR(&FFSTAT)           *E23088*FO0026*/
/************IF******COND(%SST(&FFSTAT*33*3)**EQ*'RST') THEN(DO)*E23088*FO0026*/
/**********                                                                    /*E23088*/ /*CAP067*/
/***DELETE*COPIES OF DEALSDD AND DLSDD1 TO ALLOW COMPONENT TO RERUN            /*E23088*/ /*CAP067*/
/**********        DLTF       FILE(FFDLS1)                                     /*E23088*/ /*CAP067*/
/**********        MONMSG     MSGID(CPF2105)                                   /*E23088*/ /*CAP067*/
/**********        DLTF       FILE(FFDEALS)                                    /*E23088*/ /*CAP067*/
/**********        MONMSG     MSGID(CPF2105)                                   /*E23088*/ /*CAP067*/
/**********        DLTF       FILE(XDLSAV)                                     /*E23088*/ /*CAP067*/
/**********        MONMSG     MSGID(CPF2105)                                   /*E23088*/ /*CAP067*/
/**********                                                                               /*CAP067*/
/**IF*PROGRAM IS RESTARTED AFTER ERROR, RESET FILE NAMES ETC                   /*FO0026*/ /*CAP067*/
/**********                                                                    /*FO0026*/ /*CAP067*/
/**********  RTVDTAARA DTAARA(FFSTAT) RTNVAR(&FFSTAT)                          /*FO0026*/ /*CAP067*/
/**********                                                                    /*FO0026*/ /*CAP067*/
/**********  IF         COND(%SST(&FFSTAT 33 3) *EQ 'RST') THEN(DO)            /*FO0026*/ /*CAP067*/
/**********                                                                    /*FO0026*/ /*CAP067*/
/***IF*FILES WERE RENAMED BEFORE ERROR, RENAME BACK TO CORRECT NAMES           /*E23088*/ /*CAP067*/
/**********  CHKOBJ     OBJ(DEALSDD) OBJTYPE(*FILE)                            /*E23088*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF9801) EXEC(RNMOBJ OBJ(XDEALSDD) +                        /*CAP067*/
/**********               OBJTYPE(*FILE) NEWOBJ(DEALSDD))                      /*E23088*/ /*CAP067*/
/**********  CHKOBJ     OBJ(DLSDD1) OBJTYPE(*FILE)                             /*E23088*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF9801) EXEC(RNMOBJ OBJ(XDLSDD1) +                         /*CAP067*/
/**********               OBJTYPE(*FILE) NEWOBJ(DLSDD1))                       /*E23088*/ /*CAP067*/
/**********                                                                    /*E23088*/ /*CAP067*/
/***IF*DEALSDD WAS DUPLICATED BEFORE ERROR, REMOVE DUPLICATE                   /*E23088*/ /*CAP067*/
/**********  CHKOBJ     OBJ(XDLSDD1) OBJTYPE(*FILE)                            /*E23088*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(DEALS))                /*E23088*/ /*CAP067*/
/**********        DLTF       FILE(DLSDD1)                                     /*E23088*/ /*CAP067*/
/**********        MONMSG     MSGID(CPF2105)                                   /*E23088*/ /*CAP067*/
/**********  RNMOBJ     OBJ(XDLSDD1) OBJTYPE(*FILE) NEWOBJ(DLSDD1)             /*E23088*/ /*CAP067*/
/**********                                                                    /*E23088*/ /*CAP067*/
/*DEALS:***  CHKOBJ     OBJ(XDEALSDD) OBJTYPE(*FILE)                           /*E23088*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(DLSDD1))               /*E23088*/ /*CAP067*/
/**********        DLTF       FILE(DEALSDD)                                    /*E23088*/ /*CAP067*/
/**********        MONMSG     MSGID(CPF2105)                                   /*E23088*/ /*CAP067*/
/**********  RNMOBJ     OBJ(XDEALSDD) OBJTYPE(*FILE) NEWOBJ(DEALSDD)           /*E23088*/ /*CAP067*/
/**********                                                                    /*E23088*/ /*CAP067*/
/*DLSDD1:****ENDDO                                                             /*E23088*/ /*CAP067*/
/**********                                                                    /*E23088*/ /*CAP067*/
/**********  CHGDTAARA  DTAARA(FFSTAT (33 3)) VALUE('RST')                     /*E23088*/ /*CAP067*/
/*/COPY WNCPYSRC,FFC05001                                            */
/**/                                                                  /*E23088*/
/*  TAKE COPY OF DEALSDD FOR USE BY FF0510 LATER ON  */               /*E22558*/
/***********                                                                   /*E22558*/ /*CAP067*/
/*********** RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                          /*E22558*/ /*CAP067*/
/*********** CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))                     /*E22558*/ /*CAP067*/
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')*/ /*E22558 RT0117*/
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DVLIB')                  /*RT0117*/ /*CAP067*/
/*********** CHGVAR     VAR(&TOMLIB) VALUE(&PRE *TCAT 'DMLIB')                 /*E22558*/ /*CAP067*/
/**********  CRTSAVF    FILE(&TOLIB/XDLSAV)                                    /*E22558*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF7302 CPF5813) EXEC(CLRSAVF           +                   /*CAP067*/
/**********             FILE(XDLSAV))                                          /*E22558*/ /*CAP067*/
/**********  SAVOBJ     OBJ(DLSDD1 ) LIB(&TOLIB)                      +
/**********             DEV(*SAVF) OBJTYPE(*FILE) SAVF(XDLSAV)        /*E22558 192731*/
/**********  SAVOBJ     OBJ(DLSDD1 ) LIB(&TOLIB)                      +                   /*CAP067*/
/**********             DEV(*SAVF) OBJTYPE(*FILE) SAVF(XDLSAV) +                          /*CAP067*/
/**********             USEOPTBLK(*NO)                                /*192731*/          /*CAP067*/
/**********  RNMOBJ     OBJ(DEALSDD) OBJTYPE(*FILE) NEWOBJ(XDEALSDD)           /*E22558*/ /*CAP067*/
/**********  RNMOBJ     OBJ(DLSDD1 ) OBJTYPE(*FILE) NEWOBJ(XDLSDD1)            /*E22558*/ /*CAP067*/
/**********  CPYF       FROMFILE(&TOMLIB/XDEALSDD)                    +                   /*CAP067*/
/**********               TOFILE(&TOMLIB/DEALSDD) TOMBR(*FROMMBR)     +                   /*CAP067*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES)                       /*E22558*/ /*CAP067*/
/**********  RSTOBJ     OBJ(DLSDD1) SAVLIB(&TOLIB) DEV(*SAVF)         +                   /*CAP067*/
/**********             OBJTYPE(*FILE) SAVF(XDLSAV)                            /*E22558*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF3773 CPF3293 CPF3848)                         /*E22558*/ /*CAP067*/
/************RNMOBJ     OBJ(DEALSDD) OBJTYPE(*FILE) +      */ /*E22558 061457*/
/************                NEWOBJ(FFDEALS)               */ /*E22558 061457*/
/*RETRY1:**  RNMOBJ     OBJ(DEALSDD) OBJTYPE(*FILE) NEWOBJ(FFDEALS)            /*061457*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF3202 CPF1002) EXEC(DO)                        /*061457*/ /*CAP067*/
/**********                  DLYJOB     DLY(10)                                /*061457*/ /*CAP067*/
/**********                  GOTO       CMDLBL(RETRY1)                         /*061457*/ /*CAP067*/
/**********  ENDDO                                                             /*061457*/ /*CAP067*/
/************RNMOBJ     OBJ(DLSDD1 ) OBJTYPE(*FILE) +      */ /*E22558 061457*/
/************                NEWOBJ(FFDLS1)                */ /*E22558 061457*/
/*RETRY2:**  RNMOBJ     OBJ(DLSDD1 ) OBJTYPE(*FILE) NEWOBJ(FFDLS1)             /*061457*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF3202 CPF1002 CPF4126) EXEC(DO)                /*061457*/ /*CAP067*/
/**********                  DLYJOB     DLY(10)                                /*061457*/ /*CAP067*/
/**********                  GOTO       CMDLBL(RETRY2)                         /*061457*/ /*CAP067*/
/**********  ENDDO                                                             /*061457*/ /*CAP067*/
/**********  RNMOBJ     OBJ(XDEALSDD) OBJTYPE(*FILE) NEWOBJ(DEALSDD)           /*E22558*/ /*CAP067*/
/**********  RNMOBJ     OBJ(XDLSDD1 ) OBJTYPE(*FILE) NEWOBJ(DLSDD1)            /*E22558*/ /*CAP067*/
/**********  CHKOBJ     OBJ(FFDEALS) OBJTYPE(*FILE)                            /*E22558*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF9801) EXEC(                          +                   /*CAP067*/
/**********        DO)                                                         /*E22558*/ /*CAP067*/
/**DBERROR*01 */                                                               /*E22558*/ /*CAP067*/
/**********        CHGJOB     SWS(XXXXXX11)                                    /*E22558*/ /*CAP067*/
/**********        CHGDTAARA  DTAARA(LDA (134 5)) VALUE('FFDLS')               /*E22558*/ /*CAP067*/
/**********        CHGDTAARA  DTAARA(LDA (168 10)) VALUE('FFC05   '   +                   /*CAP067*/
/**********        *CAT '01')                                                  /*E22558*/ /*CAP067*/
/**********        GOTO       CMDLBL(ABNOR)                           /*079666*/          /*CAP067*/
/******************GOTO       CMDLBL(ERR)                      /*E22558 079666*/
/**********        ENDDO                                                       /*E22558*/ /*CAP067*/
/**********  CHKOBJ     OBJ(FFDLS1 ) OBJTYPE(*FILE)                            /*E22558*/ /*CAP067*/
/**********  MONMSG     MSGID(CPF9801) EXEC(                          +                   /*CAP067*/
/**********        DO)                                                         /*E22558*/ /*CAP067*/
/**DBERROR*02 */                                                               /*E22558*/ /*CAP067*/
/**********        CHGJOB     SWS(XXXXXX11)                                    /*E22558*/ /*CAP067*/
/**********        CHGDTAARA  DTAARA(LDA (134 5)) VALUE('FFDLS')               /*E22558*/ /*CAP067*/
/**********        CHGDTAARA  DTAARA(LDA (168 10)) VALUE('FFC05   '   +                   /*CAP067*/
/**********        *CAT '02')                                                  /*E22558*/ /*CAP067*/
/**********        GOTO       CMDLBL(ABNOR)                           /*079666*/          /*CAP067*/
/******************GOTO       CMDLBL(ERR)                      /*E22558 079666*/
/**********        ENDDO                                                       /*E22558*/ /*CAP067*/
/**********  DLTF       FILE(XDLSAV)                                           /*E22558*/ /*CAP067*/
             CLRPFM     FILE(FFDEALS)                                                     /*CAP067*/
             CPYF       FROMFILE(DEALSDD) TOFILE(FFDEALS) +
                          MBROPT(*REPLACE)                                                /*CAP067*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CAP067*/
 
/*  SET UP DATA AREA WITH MARKETS TO HAVE EOC RUN IN COB */
             CHGDTAARA  DTAARA(FFEOC) VALUE(' ')
             CHGDTAARA  DTAARA(FFPRP) VALUE(' ')
/*/COPY WNCPYSRC,FFC05009                                            */
             CHGJOB     SWS(XXXXXX00)                                 /*169827*/
             CALL       PGM(FF0690)
/*/COPY WNCPYSRC,FFC05012                                            */
/**/
/******************GOTO       CMDLBL(ERR)                      /*E22558 079666*/
/**/
/*1  FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
/*NMSG:******CHGJOB     SWS(XXXXXX11)                          /*E23088 079666*/
/*R:***************                                            /*E22558 079666*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
/******************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))   */ /*S01117*/
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))      /*S01117*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)                           /*079666*/
/******************GOTO       CMDLBL(ERR)                      /*E22558 079666*/
             ENDDO
/**/
/* PROCESS OTC PRICES                                               */
/**/
             CHGJOB     SWS(0XXXXX00)
/*/COPY WNCPYSRC,FFC05015                                            */
             OVRDBF     FILE(POSTN4) MBR(OTC)
             OVRDBF     FILE(PRICS)  MBR(OTC)
             OVRDBF     FILE(PRISP)  MBR(OTC)
             OVRDBF     FILE(PRICSA) MBR(OTC)
             OVRDBF     FILE(PRISPA) MBR(OTC)
             CALL       PGM(FF0310)  PARM('  ' ' ' 'Y')
/*/COPY WNCPYSRC,FFC05018                                            */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
 /***********  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))       */ /*S01117*/
               CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))          /*S01117*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)                           /*079666*/
/******************GOTO       CMDLBL(ERR)                      /*E22558 079666*/
             ENDDO
/**/
/* PROMPT FOR PRICES FOR ANY MARKET CONTAINED IN DTAARA/FFEOC THAT  */
/* REQUIRES PRICES INPUT                                            */
/**/
             RTVDTAARA  DTAARA(FFEOC *ALL) RTNVAR(&FFEOC)
             RTVDTAARA  DTAARA(FFPRP *ALL) RTNVAR(&FFPRP)
/**/
 PRLOOP:     CHGJOB     SWS(0XXXXX00)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
               CHGVAR     VAR(&MARKT) VALUE(%SST(&FFEOC &A 2))
               OVRDBF     FILE(POSTN4) MBR(&MARKT)
               OVRDBF     FILE(PRICS) MBR(&MARKT)
               OVRDBF     FILE(PRISP) MBR(&MARKT)
               OVRDBF     FILE(PRICSA) MBR(&MARKT)
               OVRDBF     FILE(PRISPA) MBR(&MARKT)
/**/
               IF         COND(%SST(&FFPRP &B 1) *EQ 'Y') THEN(+
                          CALL  PGM(FF0310) PARM(&MARKT ' ' 'Y'))
               ELSE (+
                          CALL  PGM(FF0310) PARM(&MARKT 'Y' 'Y'))
/**/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
/***********     CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))     */ /*S01117*/
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))        /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)                           /*079666*/
/******************GOTO       CMDLBL(END)                             /*079666*/
               ENDDO
             CHGVAR     VAR(&A) VALUE(&A + 2)
             CHGVAR     VAR(&B) VALUE(&B + 1)
             GOTO CMDLBL(PRLOOP)
/**/
/*  ON SUCCESFUL COMPLETION OF COMPONENT, REMOVE 'RST' FROM FFSTAT     *E23088*/
/**/
             CHGDTAARA  DTAARA(FFSTAT (33 3)) VALUE('   ')            /*E23088*/
/**/
             GOTO       CMDLBL(END)                                   /*079666*/
ABNOR:                                                                /*079666*/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
                                                                      /*079666*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*079666*/
                   RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)           /*079666*/
                   MONMSG  MSGID(CPF0000 RPG0000 MCH0000)             /*079666*/
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))      /*079666*/
                   MONMSG  MSGID(CPF0000 RPG0000 MCH0000)             /*079666*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)             /*079666*/
                   MONMSG  MSGID(CPF0000 RPG0000 MCH0000)             /*079666*/
             ENDDO                                                    /*079666*/
             SNDPGMMSG  MSG('FFC05 - FF Input Cycle Termination +
                          ended abnormally') TOMSGQ(MOPERQ MRUNQ)     /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
