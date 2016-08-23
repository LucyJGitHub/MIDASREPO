/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas TS Trader support MDI controller')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trader Support Module                               */
/*                                                                   */
/*       TSC8550 - Real Time MDI Controller                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC020             Date 31Mar04              */
/*                      CSC018             DATE 31May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      178287             Date 05Jan01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      127317             Date 24Dec97              */
/*                      090949             Date 04JUL96              */
/*                      089491             Date 30JUN95              */
/*                      089023             Date 20JUN95              */
/*                      092168             Date 21OCT94              */
/*                      092240             Date 07JUN94              */
/*                      S01408             Date 04MAY95              */
/*                      C1790              Date 07JAN94              */
/*                      065418             Date 07JAN94              */
/*                      C0562              Date 02AUG93              */
/*                      C1734              Date 20MAY93              */
/*                      C1607              Date 19MAY93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  CCB020 - COB Restructure - Secondary COB Infrastructure          */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*  CSC018 - Journal options for high availability. ICJRN sequence   */
/*           numbers are not necessarily reset every day.            */
/*  178287 - MONMSG CPF7062 for file MKCTLD                          */
/*  CPK009 - Packaging for DBA3 release. STRCMTCTL values set        */
/*                to CMTSCOPE(*JOB).                                 */
/*  127317 - Program should terminate if unable to                   */
/*           allocate TSACTIVE.                                      */
/*  090949 - Addition of Securities to the MDI - add files           */
/*           SEMKCD, TRADSD, SDSECSPD, SDCNLMPD and STDSED.          */
/*  089491 - To prevent this program EVER Starting up before the     */
/*            Input Cycle the program will shut down if the MPHAS is */
/*            not = 'A'.                                             */
/*            Also move the Start Journaling on FF files just in     */
/*            case they have been missed by MIDAS.                   */
/*  089023 - If starting after a close of business and Futures and   */
/*            Options is present skip past the FF file reorganisation*/
/*            which closes all markets, changes all FF deals then    */
/*            opens all market centers oll journeled to ICJRN.       */
/*  092168 - Add files SDEXSTPD and SDCTRYPD to realtime MDI         */
/*  092240 - Ensure Program can run on either R10 or R2.3/3          */
/*  S01408 - Addition of core hook TSC8550MP1                        */
/*   C1790 - Add file for futures & options customers.               */
/*  065418 - This amendment corrects the following four errors:      */
/*           1) The Last Journal Sequence Number is not being reset  */
/*              to 1 (but should be) when the run date changes.      */
/*           2) File MKCTLD should be (but isn't) on the RCVJRNE     */
/*              command.                                             */
/*           3) Three files should be specified to start jounalling  */
/*              but aren't because they are specified incorrectly.   */
/*              They are SDBOOKPD, TRSETD and TRANSD.                */
/*           4) The MDI does not start up correctly if the document  */
/*              STOPJRN.TSM exists at startup. After renaming the    */
/*              document to DOWNJRN.TSM, the program should then go  */
/*              into the loop where it waits for the document to be  */
/*              renamed (by the PC) to STARTJRN.TSM.                 */
/*   C0562 - Add two more files to monitor for changes. This         */
/*           will enable customer limits to be downloaded to         */
/*           Trader Support.                                         */
/*   C1734 - Change folder name from TSM to TSMxx where xx is        */
/*           Midas system prefix                                     */
/*   C1607 - Check for existence of document REFJRN.DOC when         */
/*           starting MDI.                                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RUNDATE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TSDATE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&BLANK100)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILEFLAGS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IDX)       TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&RCVJDEL)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&RCVJDELAY) TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&LOOPA)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&LOOP)      TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&OFFSET)    TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&JRNSQ)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JRNSEQ)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&DOCNAME)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PHASE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRYRCVJRN) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&DOCS) TYPE(*CHAR) LEN(135) +               C0562 */
/************             VALUE(MDIABSDBOKSDBRCSDBRKSDRATSDPTSSDCCYSD+  C0562 */
/************             CUSMDIFRMDIDMSDDRYMDIFXMDILDSDSTPMDINAMDINS+  C0562 */
/************             SDINTSDHL1SDHL2SDINVSDINSSDMKTSDMKCSDNOSSDS+  C0562 */
/************             ECMDIFFMDIFF)                                 C0562 */
/************DCL        VAR(&DOCS) TYPE(*CHAR) LEN(140) +               C1790 */
/************             VALUE(MDIABSDBOKSDBRCSDBRKSDRATSDPTSSDCCYSD+  C1790 */
/************             CUSMDIFRMDIDMSDDRYMDIFXMDILDSDSTPMDINAMDINS+  C1790 */
/************             SDINTSDHL1SDHL2SDINVSDINSSDMKTSDMKCSDNOSSDS+  C1790 */
/************             ECMDIFFMDIFFLIMIT)                C0562       C1790 */
/************DCL        VAR(&DOCS) TYPE(*CHAR) LEN(145) +              092168 */
/************             VALUE(MDIABSDBOKSDBRCSDBRKSDRATSDPTSSDCCYSD+ 092168 */
/************             CUSMDIFRMDIDMSDDRYMDIFXMDILDSDSTPMDINAMDINS+ 092168 */
/************             SDINTSDHL1SDHL2SDINVSDINSSDMKTSDMKCSDNOSSDS+ 092168 */
/************             ECMDIFFMDIFFLIMITSDFFC)             /* C1790 092168 */
/************DCL        VAR(&DOCS) TYPE(*CHAR) LEN(155) +              090949*/
/************             VALUE(MDIABSDBOKSDBRCSDBRKSDRATSDPTSSDCCYSD+ 090949*/
/************             CUSMDIFRMDIDMSDDRYMDIFXMDILDSDSTPMDINAMDINS+ 090949*/
/************             SDINTSDHL1SDHL2SDINVSDINSSDMKTSDMKCSDNOSSDS+ 090949*/
/************             ECMDIFFMDIFFLIMITSDFFCSDSSISDCTY)    092168  090949*/
             DCL        VAR(&DOCS) TYPE(*CHAR) LEN(180) +
                          VALUE(MDIABSDBOKSDBRCSDBRKSDRATSDPTSSDCCYSD+
                          CUSMDIFRMDIDMSDDRYMDIFXMDILDSDSTPMDINAMDINS+
                          SDINTSDHL1SDHL2SDSCCSDINSSDMKTSDMKCSDNOSSDS+
                          ECMDIFFMDIFFLIMITSDFFCSDSSISDCTYSDSEMMDISES+
                          DINVSDCNLSDSED)                            /* 090949*/
             DCL        VAR(&TSM) TYPE(*CHAR) LEN(5)        /* C1734 */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)        /* C1734 */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)       /* C0562 */
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)     /* C0562 */
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)     /* C0562 */
             DCL        VAR(&FF) TYPE(*CHAR) LEN(2)                 /* 089023 */
/*                                                                                        /*CSC018*/
/* Declare variables for switchable feature CSC018,                                       /*CSC018*/
/* Journaling options for high availability                                               /*CSC018*/
/*                                                                                        /*CSC018*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&RCV001SEQ) TYPE(*DEC) LEN(10 0)                              /*CSC018*/
             DCL        VAR(&RCV001SEQA) TYPE(*CHAR) LEN(10)                              /*CSC018*/
             DCL        VAR(&CNTSE6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&STRRCV) TYPE(*CHAR) LEN(10)                                  /*CSC020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Global monitor messages */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) +
                          EXEC(GOTO ERROR)
 
/* Set up the TSM folder */                                 /* C1734 */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)   /* C1734 */
             CHGVAR     VAR(&TSM) VALUE('TSM' *CAT &LIB)    /* C1734 */
 
/* If AS400 is required to start processing but MIDAS is not in input +
cycle, then terminate this program */                               /* 089491 */
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHASE)          /* 089491 */
/**********  IF         COND(&PHASE *NE 'A') THEN(DO)                          */ /* 089491 CCB020*/
             IF         COND((&PHASE *NE 'A') *AND +
                            (&PHASE *NE 'G')) THEN(DO)                                    /*CCB020*/
             CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(QUITJRN.TSM) TOFLR(&TSM)            /* 089491 */
             GOTO       CMDLBL(END)                                 /* 089491 */
             ENDDO                                                  /* 089491 */
 
/* Must journal each file individually as multiple file journal +
command may not journal all files if more than one are not      +
journalled*/                                                        /* 089491 */
             STRJRNPF   FILE(TRSETD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                          /* 089491 */
             MONMSG     MSGID(CPF0000)                              /* 089491 */
             STRJRNPF   FILE(TRANSD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                          /* 089491 */
             MONMSG     MSGID(CPF0000)                              /* 089491 */
 
/* If program is already active then exit program */        /* C1734 */
/************ALCOBJ     OBJ((TSACTIVE *DTAARA *EXCL))  /*C1734*127317*/
             ALCOBJ     OBJ((TSACTIVE *DTAARA *EXCL))  +
                        WAIT(60)                             /*127317*/
             MONMSG     MSGID(CPF0000) EXEC(DO)             /* C1734 */
             SNDMSG     MSG('TSC8550 - Collect Trader Support +
                          Journal entries already active') +
                          TOMSGQ(MOPERQ)                    /* C1734 */
             GOTO       CMDLBL(END)                         /* C1734 */
             ENDDO                                          /* C1734 */
 
/*  Create TSMCLMPD from the join logical file SDCLLMJ0 */    /* C0562 */
             CHGVAR     VAR(&DPLIB) VALUE(&LIB *CAT 'DPLIB')  /* C0562 */
             CHGVAR     VAR(&DVLIB) VALUE(&LIB *CAT 'DVLIB')  /* C0562 */
 
/* Decide if release 10 libs exist */                       /* 092240 */
             CHKOBJ     OBJ(QSYS/&DVLIB) OBJTYPE(*LIB)      /* 092240 */
             MONMSG     MSGID(CPF0000) EXEC(DO)             /* 092240 */
/* The DVLIB does not exist so assume REL 2.3  => DLIB */   /* 092240 */
             CHGVAR     VAR(&DPLIB) VALUE(&LIB *CAT 'DLIB') /* 092240 */
             CHGVAR     VAR(&DVLIB) VALUE(&LIB *CAT 'DLIB') /* 092240 */
             ENDDO                                          /* 092240 */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,TSC8550MP1                                          */
/*                                                                                        /*CSC018*/
/** Check for Switchable feature CSC018.                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                                /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If feature CSC018 is present,                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
/*                                                                                        /*CSC018*/
                CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'HighAvlContJrnSeqNum' &SVAL1 +
                             &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                             &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                             &SVALK6 &SVAL6 &SVALK7 &SVAL7 +
                             &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                             &SVALK10 &SVAL10)                                            /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding the system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether continuous journal sequence numbers are                             /*CSC018*/
/*  being used.                                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&CNTSE6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
                                                                      /*S01408*/
             DLTF       FILE(&DPLIB/TSMCLMPD)                 /* C0562 */
             MONMSG     MSGID(CPF0000)                        /* C0562 */
             CPYF       FROMFILE(&DVLIB/SDCLLMJ0) +
                          TOFILE(&DPLIB/TSMCLMPD) MBROPT(*NONE) +
                          CRTFILE(*YES)                       /* C0562 */
             MONMSG     MSGID(CPF0000) EXEC(DO)               /* C0562 */
                 CHGVAR     VAR(&MSG) VALUE('Physical file TSMCLMPD +
                              could not be recreated. MDI failed.') /*C0562 */
                 SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ)          /* C0562 */
                 GOTO       CMDLBL(ERROR)                     /* C0562 */
             ENDDO                                            /* C0562 */
 
                                                                     /* C1734 */
/* Check if all elements exist upon start-up of this program. Create +
elements if missing */
/************CHKDLO*****DLO(TSM)*OBJTYPE(*FLR)************************* C1734 */
             CHKDLO     DLO(&TSM) OBJTYPE(*FLR)                      /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**************CRTFLR*****FLR(TSM)************************************* C1734 */
               CRTFLR     FLR(&TSM)                                  /* C1734 */
               MONMSG     MSGID(CPF0000) EXEC(DO)
/****************SNDMSG*****MSG('TSC8550*Collect*Trader*Support*+****** C1734 */
/************************Journal*Entries*cannot*find*or*does*not*have*+ C1734 */
/************************authority*to*folder*TSM.')*TOMSGQ(MOPERQ)***** C1734 */
                 CHGVAR     VAR(&MSG) VALUE('TSC8550 Collect Trader +
                          Support Journal Entries cannot find or +
                          does not have authority to folder' *BCAT +
                          &TSM)                                      /* C1734 */
                 SNDMSG     MSG(&MSG) TOMSGQ(MOPERQ)
                 GOTO       CMDLBL(END)
               ENDDO
             ENDDO
                                                                     /* C1607 */
/************CHKDLO*****DLO(REFJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)********* C1607 */
             CHKDLO     DLO(REFJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)      /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(DO)                      /* C1607 */
/****************SNDMSG*****MSG('TSC8550*Collect*Trader*Support*+****** C1734 */
/*********************Journal*Entries*cannot*find*or*does*not*have*+*** C1734 */
/*********************authority*to*folder*REFJRN.TSM')*TOMSGQ(MOPERQ)/* C1607 */
             SNDMSG     MSG('TSC8550 Collect Trader Support Journal +
                          Entries cannot find or does not have +
                          authority to document REFJRN.TSM') +
                          TOMSGQ(MOPERQ)                             /* C1734 */
                 GOTO       CMDLBL(END)                              /* C1607 */
             ENDDO                                                   /* C1607 */
 
/************CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******** C1734 */
             CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CHECKDOCS))
/************DLTDLO*****DLO(QUITJRN.TSM)*FLR(TSM)********************** C1734 */
             DLTDLO     DLO(QUITJRN.TSM) FLR(&TSM)                   /* C1734 */
/*CHECKDOCS:**CHKDLO*****DLO(STOPJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 CHECKDOCS:  CHKDLO     DLO(STOPJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**************CHKDLO*****DLO(STARTJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)***** C1734 */
               CHKDLO     DLO(STARTJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)  /* C1734 */
               MONMSG     MSGID(CPF0000) EXEC(DO)
/****************CHKDLO*****DLO(DOWNJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)**** C1734 */
                 CHKDLO     DLO(DOWNJRN.TSM) FLR(&TSM) OBJTYPE(*DOC) /* C1734 */
                 MONMSG     MSGID(CPF0000) EXEC(DO)
/******************CHKDLO*****DLO(READJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)** C1734 */
                   CHKDLO     DLO(READJRN.TSM) FLR(&TSM) OBJTYPE(*DOC) /*C1734*/
/******************MONMSG*****MSGID(CPF0000)*EXEC(CPYDOC*+************* C1734 */
/*****************************FROMDOC(REFJRN.TSM)*FROMFLR(TSM)*+******* C1734 */
/*****************************TODOC(STARTJRN.TSM)*TOFLR(TSM))********** C1734 */
                   MONMSG     MSGID(CPF0000) EXEC(CPYDOC +
                              FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                              TODOC(STARTJRN.TSM) TOFLR(&TSM))       /* C1734 */
                 ENDDO
               ENDDO
             ENDDO
 
/********************************************************************** C1734 */
/**If*program*is*already*active*then*exit*program********************** C1734 */
/************ALCOBJ*****OBJ((TSACTIVE**DTAARA**EXCL))****************** C1734 */
/************MONMSG*****MSGID(CPF0000)*EXEC(DO)************************ C1734 */
/************SNDMSG*****MSG('TSC8550*-*Collect*Trader*Support*+******** C1734 */
/*************************Journal*entries*already*active')*+*********** C1734 */
/*************************TOMSGQ(MOPERQ)******************************* C1734 */
/************GOTO*******CMDLBL(END)************************************ C1734 */
/************ENDDO***************************************************** C1734 */
 
/* Perform initialisation for program start or restart */
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))                /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                  /*CPK009*/
             MONMSG     MSGID(CPF0000)
/************CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******** C1734 */
             CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(STARTMSG))
/************DLTDLO*****DLO(QUITJRN.TSM)*FLR(TSM)********************** C1734 */
             DLTDLO     DLO(QUITJRN.TSM) FLR(&TSM)                   /* C1734 */
             MONMSG     MSGID(CPF0000)
 STARTMSG:   SNDMSG     MSG('TSC8550 - Collect Trader Support +
                          Journal entries started') TOMSGQ(MOPERQ)
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNDATE)
             RTVDTAARA  DTAARA(TSSTAT (113 7)) RTNVAR(&TSDATE)
             IF         COND(&RUNDATE *NE &TSDATE) THEN(DO)
                CHGDTAARA  DTAARA(TSSTAT (113 7)) VALUE(&RUNDATE)
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' and continuous journal sequence numbers                      /*CSC018*/
/* are being used,                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND((&CSC018 *EQ '       ') *AND (&CNTSE6 +
                          *EQ 'Y')) THEN(DO)                                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine the first journal sequence number of receiver ICRCV001.                     /*CSC018*/
/*                                                                                        /*CSC018*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(ICRCV001)*+***************************************CSC020*/
/*************************RTNSEQNBR(&RCV001SEQ)*************************************CSC018**CSC020*/
/*                                                                                          CSC020*/
/*  Determine journal receiver and first sequence number of next day set up.                CSC020*/
/*  (Equivalent to beginning of ICRCV001 in previous releases)                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&RCV001SEQ)                   /*CSC020*/
/*                                                                                          CSC020*/
/*  If no value returned, then set receiver and sequence to first available.                CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRRCV *EQ '          ') THEN(DO)                           /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNRCV(&STRRCV)                                                 /*CSC020*/
             ENDDO                                                                        /*CSC020*/
             IF         COND(&RCV001SEQ *EQ 0) THEN(DO)                                   /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNSEQNBR(&RCV001SEQ)                                           /*CSC020*/
             ENDDO                                                                        /*CSC020*/
/*                                                                                          CSC020*/
             CHGVAR     VAR(&RCV001SEQA) VALUE(&RCV001SEQ)                                /*CSC018*/
             CHGDTAARA  DTAARA(TSSTAT (120 10)) VALUE(&RCV001SEQA)                        /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If continuous journal sequence numbers are NOT being used,                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CCB001*/
/***************CHGDTAARA  DTAARA(TSSTAT (120 10)) VALUE(1)*********** 065418 */
                CHGDTAARA  DTAARA(TSSTAT (120 10)) VALUE('0000000001') +
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
                                                                    /* 065418 */
             /* If FF is on skip FF entries in ICJRN. */            /* 089023 */
                RTVDTAARA  DTAARA(MMOD (50 1)) RTNVAR(&FF)          /* 089023 */
/***************IF         COND(&FF *EQ 'Y') +                                            /*178287*/
/***************           THEN(RCVJRNE JRN(ICJRN) +                                      /*178287*/
/***************          EXITPGM(TS8590) FILE((*LIBL/MKCTLD)) +                          /*178287*/
/***************          RCVRNG(*LIBL/ICRCV001 *CURRENT) +                               /*178287*/
/***************          TOENT(*LAST) ENTTYP(DL DR PT PX UP UR))   /* 089023 */          /*178287*/
                IF        COND(&FF *EQ 'Y') THEN(DO)                                      /*178287*/
/******************RCVJRNE*JRN(ICJRN)*+*****************************************************CSC020*/
/******************EXITPGM(TS8590)*FILE((*LIBL/MKCTLD))*+***********************************CSC020*/
/******************RCVRNG(*LIBL/ICRCV001**CURRENT)*+****************************************CSC020*/
/******************TOENT(*LAST)*ENTTYP(DL*DR*PT*PX*UP*UR)**************************178287***CSC020*/
                   RCVJRNE JRN(ICJRN) +
                   EXITPGM(TS8590) FILE((*LIBL/MKCTLD)) +
                   RCVRNG(*LIBL/&STRRCV *CURRENT) +
                   TOENT(*LAST) ENTTYP(DL DR PT PX UP UR)                                 /*CSC020*/
                   MONMSG     MSGID(CPF7062)                                              /*178287*/
                ENDDO                                                                     /*178287*/
 
             ENDDO
 
/* If PC is downloading data then loop until STARTJRN document is +
   found */
/************CHKDLO*****DLO(DOWNJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******** C1734 */
             CHKDLO     DLO(DOWNJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CHECKSTOP)
             GOTO       CMDLBL(GETLOOP)
 
/* If a stop is required, then create a marker document for all the +
files that have been updated. A flag corresponding to each file is +
set on TSSTAT */
/*CHECKSTOP:**CHKDLO*****DLO(STOPJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 CHECKSTOP:  CHKDLO     DLO(STOPJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CHKSTJRN))
             RTVDTAARA  DTAARA(TSSTAT (1 100)) RTNVAR(&FILEFLAGS)
             CHGVAR     VAR(&IDX) VALUE(1)
 LOOP:       IF         COND(%SST(&FILEFLAGS &IDX 1) *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&OFFSET) VALUE((&IDX * 5) - 4)
             CHGVAR     VAR(&DOCNAME) VALUE(%SST(&DOCS &OFFSET 5) +
                          *CAT '.JRN')
/************CPYDOC*****FROMDOC(REFJRN.TSM)*FROMFLR(TSM)*+************* C1734 */
/*************************TODOC(&DOCNAME)*TOFLR(TSM)******************* C1734 */
             CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(&DOCNAME) TOFLR(&TSM)                /* C1734 */
             MONMSG     MSGID(CPF0000)
             ENDDO
             CHGVAR     VAR(&IDX) VALUE(&IDX + 1)
/************IF*********COND(&IDX *LE 27)*THEN(GOTO*CMDLBL(LOOP))****** C0562 */
/************IF*********COND(&IDX *LE 29) THEN(GOTO CMDLBL(LOOP)) C0562 C1790 */
/************IF*********COND(&IDX *LE 30) THEN(GOTO CMDLBL(LOOP))C1790 092168 */
/************IF*********COND(&IDX *LE 31) THEN(GOTO CMDLBL(LOOP))092168 090949*/
             IF         COND(&IDX *LE 36) THEN(GOTO CMDLBL(LOOP))     /*090949*/
/* Indicate to PC that AS400 has finished and ready for PC to +
download data by renaming documents */
/************RNMDLO*****DLO(STOPJRN.TSM)*NEWDLO(DOWNJRN.TSM)*FLR(TSM)** C1734 */
             RNMDLO     DLO(STOPJRN.TSM) NEWDLO(DOWNJRN.TSM) FLR(&TSM) /*C1734*/
             GOTO       CMDLBL(GETLOOP)                             /* 065418 */
 
 
/*CHKSTJRN:***CHKDLO*****DLO(STARTJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)****** C1734 */
 CHKSTJRN:   CHKDLO     DLO(STARTJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)    /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CHKRDJRN))
/* If AS400 is required to start processing but MIDAS is not in input +
cycle, then terminate this program */
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHASE)
/**********  IF         COND(&PHASE *NE 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND((&PHASE *NE 'A') *AND +
                            (&PHASE *NE 'G')) THEN(DO)                                    /*CCB020*/
/************CPYDOC*****FROMDOC(REFJRN.TSM)*FROMFLR(TSM)*+************* C1734 */
/*************************TODOC(QUITJRN.TSM)*TOFLR(TSM)**************** C1734 */
             CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(QUITJRN.TSM) TOFLR(&TSM)             /* C1734 */
             GOTO       CMDLBL(END)
             ENDDO
 
/* Initialise flags to start reading data from journals */
/************RNMDLO*****DLO(STARTJRN.TSM)*NEWDLO(READJRN.TSM)*FLR(TSM)* C1734 */
             RNMDLO     DLO(STARTJRN.TSM) NEWDLO(READJRN.TSM) +
                          FLR(&TSM) /* C1734 */
             CHGDTAARA  DTAARA(TSSTAT (1 100)) VALUE(&BLANK100)
 
/* Get the delay value and start reading journals */
 CHKRDJRN:   RTVDTAARA  DTAARA(TSSTAT (105 4)) RTNVAR(&RCVJDEL)
             CHGVAR     VAR(&RCVJDELAY) VALUE(&RCVJDEL)
             IF         COND(&RCVJDELAY *LE 0) THEN(CHGVAR +
                          VAR(&RCVJDELAY) VALUE(10))
             RTVDTAARA  DTAARA(TSSTAT (120 10)) RTNVAR(&JRNSQ)
             CHGVAR     VAR(&JRNSEQ) VALUE(&JRNSQ)
/************CHKDLO*****DLO(READJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******** C1734 */
             CHKDLO     DLO(READJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRYWAIT))
 
/**RETRYRCVJ:**RCVJRNE****JRN(ICJRN) EXITPGM(TS8550) FILE((ABDEALPP) +  C0562 */
/*************************(SDBOOKPD) (SDBRCHPD) (SDBROKPD) +            C0562 */
/*************************(SDBSRTPD) (FDCCYPPP) (SDCURRPD) +            C0562 */
/*************************(SDCUSTPD) (DEALSDG) (MMDEAMPP) (SEDEVD) +    C0562 */
/*************************(FXDEALPP) (MMDELDPP) (SDDLSTPD) +            C0562 */
/*************************(MMDENBPP) (MMDENSPP) (FDINTRPP) +            C0562 */
/*************************(SDHOLPD) (INVTPD) (INTYPD) (MARKTD) +        C0562 */
/*************************(SDNOSTPD) (SECTYD) (TRSETD *ALL) (TRANSD +   C0562 */
/************************ *ALL)) RCVRNG(ICRCV001 *CURRENT) +            C0562 */
/*************************FROMENT(&JRNSEQ) ENTTYP(DL DR PT PX UP +      C0562 */
/*************************UR) DELAY(&RCVJDELAY)                         C0562 */
/* C0562 START BLOCK */
/**RETRYRCVJ:**RCVJRNE****JRN(ICJRN) EXITPGM(TS8550) FILE((ABDEALPP) + 065418 */
/*************************(SDBOOKPD) (SDBRCHPD) (SDBROKPD) +           065418 */
/*************************(SDBSRTPD) (FDCCYPPP) (SDCURRPD) +           065418 */
/*************************(SDCUSTPD) (DEALSDG) (MMDEAMPP) (SEDEVD) +   065418 */
/*************************(FXDEALPP) (MMDELDPP) (SDDLSTPD) +           065418 */
/*************************(MMDENBPP) (MMDENSPP) (FDINTRPP) +           065418 */
/*************************(SDHOLPD) (INVTPD) (INTYPD) (MARKTD) +       065418 */
/*************************(SDNOSTPD) (SECTYD) (TRSETD *ALL) (TRANSD +  065418 */
/************************ *ALL) (SDCLLMPD) (SDLIMTPD)) +               065418 */
/*************************RCVRNG(ICRCV001 *CURRENT) +                  065418 */
/*************************FROMENT(&JRNSEQ) ENTTYP(DL DR PT PX UP +     065418 */
/*************************UR) DELAY(&RCVJDELAY)                 C0562  065418 */
/* C0562 END BLOCK */
/* 065418 START BLOCK */
/**RETRYRCVJ:**RCVJRNE****JRN(ICJRN) EXITPGM(TS8550) FILE((ABDEALPP) +  C1790 */
/*************************(SDBOOKPD) (SDBRCHPD) (SDBROKPD) +            C1790 */
/*************************(SDBSRTPD) (FDCCYPPP) (SDCURRPD) +            C1790 */
/*************************(SDCUSTPD) (DEALSDG) (MMDEAMPP) (SEDEVD) +    C1790 */
/*************************(FXDEALPP) (MMDELDPP) (SDDLSTPD) +            C1790 */
/*************************(MMDENBPP) (MMDENSPP) (FDINTRPP) +            C1790 */
/*************************(SDHOLPD) (INVTPD) (INTYPD) (MARKTD) +        C1790 */
/*************************(SDNOSTPD) (SECTYD) (TRSETD *ALL) (TRANSD +   C1790 */
/**************************ALL) (SDCLLMPD) (SDLIMTPD) (MKCTLD)) +       C1790 */
/*************************RCVRNG(ICRCV001 *CURRENT) +                   C1790 */
/*************************FROMENT(&JRNSEQ) ENTTYP(DL DR PT PX UP +      C1790 */
/*************************UR) DELAY(&RCVJDELAY)    C0562                C1790 */
/* 065418 END BLOCK */
/* C1790 START BLOCK */
/*RETRYRCVJ:**RCVJRNE****JRN(ICJRN) EXITPGM(TS8550) FILE((ABDEALPP) +  092168 */
/*************************(SDBOOKPD) (SDBRCHPD) (SDBROKPD) +           092168 */
/*************************(SDBSRTPD) (FDCCYPPP) (SDCURRPD) +           092168 */
/*************************(SDCUSTPD) (DEALSDG) (MMDEAMPP) (SEDEVD) +   092168 */
/*************************(FXDEALPP) (MMDELDPP) (SDDLSTPD) +           092168 */
/*************************(MMDENBPP) (MMDENSPP) (FDINTRPP) +           092168 */
/*************************(SDHOLPD) (INVTPD) (INTYPD) (MARKTD) +       092168 */
/*************************(SDNOSTPD) (SECTYD) (TRSETD *ALL) (TRANSD +  092168 */
/**************************ALL) (SDCLLMPD) (SDLIMTPD) (MKCTLD) +       092168 */
/*************************(SDFOCSPD)) RCVRNG(ICRCV001 *CURRENT) +      092168 */
/*************************FROMENT(&JRNSEQ) ENTTYP(DL DR PT PX UP +     092168 */
/*************************UR) DELAY(&RCVJDELAY)    C1790               092168 */
/*RETRYRCVJ:**RCVJRNE****JRN(ICJRN) EXITPGM(TS8550) FILE((ABDEALPP) +   090949*/
/*************************(SDBOOKPD) (SDBRCHPD) (SDBROKPD) +            090949*/
/*************************(SDBSRTPD) (FDCCYPPP) (SDCURRPD) +            090949*/
/*************************(SDCUSTPD) (DEALSDG) (MMDEAMPP) (SEDEVD) +    090949*/
/*************************(FXDEALPP) (MMDELDPP) (SDDLSTPD) +            090949*/
/*************************(MMDENBPP) (MMDENSPP) (FDINTRPP) +            090949*/
/*************************(SDHOLPD) (INVTPD) (INTYPD) (MARKTD) +        090949*/
/*************************(SDNOSTPD) (SECTYD) (TRSETD *ALL) (TRANSD +   090949*/
/**************************ALL) (SDCLLMPD) (SDLIMTPD) (MKCTLD) +        090949*/
/*************************(SDFOCSPD) (SDEXSTPD) (SDCTRYPD)) +           090949*/
/*************************RCVRNG(ICRCV001 *CURRENT) +                   090949*/
/*************************FROMENT(&JRNSEQ) ENTTYP(DL DR PT PX UP +      090949*/
/*************************UR) DELAY(&RCVJDELAY)                   092168090949*/
/**092168*END*BLOCK**/                                                /*090949*/
/*/COPY WNCPYSRC,TSC8550003                                          */
/*RETRYRCVJ:**RCVJRNE****JRN(ICJRN)*EXITPGM(TS8550)*FILE((ABDEALPP)*+***********************CSC020*/
/*************************(SDBOOKPD)*(SDBRCHPD)*(SDBROKPD)*+********************************CSC020*/
/*************************(SDBSRTPD)*(FDCCYPPP)*(SDCURRPD)*+********************************CSC020*/
/*************************(SDCUSTPD)*(DEALSDG)*(MMDEAMPP)*(SEDEVD)*+************************CSC020*/
/*************************(FXDEALPP)*(MMDELDPP)*(SDDLSTPD)*+********************************CSC020*/
/*************************(MMDENBPP)*(MMDENSPP)*(FDINTRPP)*+********************************CSC020*/
/*************************(SDHOLPD)*(INTYPD)*(MARKTD)*(SDNOSTPD)*+**************************CSC020*/
/*************************(TRSETD**ALL)*(TRANSD**ALL)*(SDCLLMPD)*+**************************CSC020*/
/*************************(SDLIMTPD)*(MKCTLD)*(SDFOCSPD)*(SDEXSTPD)*+***********************CSC020*/
/*************************(SDCTRYPD)*(SECTYD)*(SDSECSPD)*(SEMKCD)*+*************************CSC020*/
/*************************(TRADSD)*(INVTPD)*(SDCNLMPD)*(STDSED))*+**************************CSC020*/
/*************************RCVRNG(ICRCV001**CURRENT)*+***************************************CSC020*/
/*************************FROMENT(&JRNSEQ)*ENTTYP(DL*DR*PT*PX*UP*+**************************CSC020*/
/*************************UR)*DELAY(&RCVJDELAY)*************************090949**************CSC020*/
 RETRYRCVJ:  RCVJRNE    JRN(ICJRN) EXITPGM(TS8550) FILE((ABDEALPP) +
                          (SDBOOKPD) (SDBRCHPD) (SDBROKPD) +
                          (SDBSRTPD) (FDCCYPPP) (SDCURRPD) +
                          (SDCUSTPD) (DEALSDG) (MMDEAMPP) (SEDEVD) +
                          (FXDEALPP) (MMDELDPP) (SDDLSTPD) +
                          (MMDENBPP) (MMDENSPP) (FDINTRPP) +
                          (SDHOLPD) (INTYPD) (MARKTD) (SDNOSTPD) +
                          (TRSETD *ALL) (TRANSD *ALL) (SDCLLMPD) +
                          (SDLIMTPD) (MKCTLD) (SDFOCSPD) (SDEXSTPD) +
                          (SDCTRYPD) (SECTYD) (SDSECSPD) (SEMKCD) +
                          (TRADSD) (INVTPD) (SDCNLMPD) (STDSED)) +
                          RCVRNG(&STRRCV *CURRENT) +
                          FROMENT(&JRNSEQ) ENTTYP(DL DR PT PX UP +
                          UR) DELAY(&RCVJDELAY)                                           /*CSC020*/
/*/COPY WNCPYSRC,TSC8550004                                          */
/* C1790 END BLOCK */
 
/* If no entries found then pass control to PC and go into loop  +
   until PC passes control back again */
             MONMSG     MSGID(CPF7062) EXEC(GOTO CMDLBL(PASSCTL))
/* If specified journal sequence number is not found on journal then +
   retry attemp to get another entry */
             MONMSG     MSGID(CPF7054) EXEC(GOTO CMDLBL(RETRYWAIT))
 
/* If the file is never journalled, then try to journal the file +
once. On the second attempt to journal, abort the program as there +
must be something fatally wrong */
             MONMSG     MSGID(CPF7060) EXEC(DO)
             IF         COND(&TRYRCVJRN *EQ 'Y') THEN(DO)
             SNDMSG     MSG('TSC8550 - Collect Trader Support +
                          Journal entries ended abnormally') +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
/* Must journal each file individually as multiple file journal +
command may not journal all files if more than one are not journalled*/
             STRJRNPF   FILE(ABDEALPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
/*****       STRJRNPF   FILE(SDBBOKPD) JRN(ICJRN) IMAGES(*BOTH) +      065418 */
             STRJRNPF   FILE(SDBOOKPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                          /* 065418 */
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDBRCHPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDBROKPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDBSRTPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(FDCCYPPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDCURRPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDCUSTPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(DEALSDG) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(MMDEAMPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SEDEVD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(FXDEALPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(MMDELDPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDDLSTPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(MMDENBPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(MMDENSPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(FDINTRPP) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDHOLPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(INVTPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(INTYPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(MARKTD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(MKCTLD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SDNOSTPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(SECTYD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
/*********** STRJRNPF   FILE(TRSET1) JRN(ICJRN) IMAGES(*BOTH) +        065418 */
             STRJRNPF   FILE(TRSETD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                          /* 065418 */
             MONMSG     MSGID(CPF0000)
/*********** STRJRNPF   FILE(TRSET2) JRN(ICJRN) IMAGES(*BOTH) +        065418 */
             STRJRNPF   FILE(TRANSD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                          /* 065418 */
             MONMSG     MSGID(CPF0000)
/* C0562 START BLOCK */
             STRJRNPF   FILE(SDCLLMPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                           /* C0562 */
             MONMSG     MSGID(CPF0000)                               /* C0562 */
             STRJRNPF   FILE(SDLIMTPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                           /* C0562 */
             MONMSG     MSGID(CPF0000)                               /* C0562 */
/* C0562 END BLOCK */
/* C1790 START BLOCK */
             STRJRNPF   FILE(SDFOCSPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                           /* C1790 */
             MONMSG     MSGID(CPF0000)                               /* C1790 */
/* C1790 END BLOCK */
             STRJRNPF   FILE(SDEXTSPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                           /* 092168*/
             MONMSG     MSGID(CPF0000)                               /* 092168*/
             STRJRNPF   FILE(SDCTRYPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                           /* 092168*/
             MONMSG     MSGID(CPF0000)                               /* 092168*/
             STRJRNPF   FILE(SDSECSPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                            /*090949*/
             MONMSG     MSGID(CPF0000)                                /*090949*/
             STRJRNPF   FILE(SEMKCD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                            /*090949*/
             MONMSG     MSGID(CPF0000)                                /*090949*/
             STRJRNPF   FILE(TRADSD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                            /*090949*/
             MONMSG     MSGID(CPF0000)                                /*090949*/
             STRJRNPF   FILE(SDCNLMPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                            /*090949*/
             MONMSG     MSGID(CPF0000)                                /*090949*/
             STRJRNPF   FILE(STDSED) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                            /*090949*/
             MONMSG     MSGID(CPF0000)                                /*090949*/
             CHGVAR     VAR(&TRYRCVJRN) VALUE('Y')
             GOTO       CMDLBL(RETRYRCVJ)
             ENDDO
 
 
/* If no errors encountered then check if program is required to stop*/
             GOTO       CMDLBL(CHECKQUIT)
 
/* If no entries found then check if program is requested to stop +
   or terminate by PC. If program is to continue then perform delay +
   and attempt to get more journal entries. */
/*RETRYWAIT:**CHKDLO*****DLO(STOPJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 RETRYWAIT:  CHKDLO     DLO(STOPJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(QUITCHECK))
             GOTO       CMDLBL(CRTMARKERS)
/*QUITCHECK:**CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 QUITCHECK:  CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(WAITABIT))
             GOTO       CMDLBL(END)
 WAITABIT:   DLYJOB     DLY(&RCVJDELAY)
             GOTO       CMDLBL(RETRYRCVJ)
 
/* If this program is required to stop by PC then check for QUITJRN +
created by PC and treminate if found */
/*CHECKQUIT:***CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)****** C1734 */
CHECKQUIT:   CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CRTMARKERS))
             GOTO       CMDLBL(END)
 
/* After delay has elapsed within RCVJRNE, create marker documents for+
all files that have been updated. Rename STOPJRN document to inform +
PC that it can take extracted data now. */
 CRTMARKERS: RTVDTAARA  DTAARA(TSSTAT (1 100)) RTNVAR(&FILEFLAGS)
             CHGVAR     VAR(&IDX) VALUE(1)
 LOOP1:      IF         COND(%SST(&FILEFLAGS &IDX 1) *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&OFFSET) VALUE((&IDX * 5) - 4)
             CHGVAR     VAR(&DOCNAME) VALUE(%SST(&DOCS &OFFSET 5) +
                          *CAT '.JRN')
/************CPYDOC*****FROMDOC(REFJRN.TSM)*FROMFLR(TSM)*+************* C1734 */
/*************************TODOC(&DOCNAME)*TOFLR(TSM)******************* C1734 */
             CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(&DOCNAME) TOFLR(&TSM)                /* C1734 */
             MONMSG     MSGID(CPF0000)
             ENDDO
             CHGVAR     VAR(&IDX) VALUE(&IDX + 1)
/*           IF         COND(&IDX *LE 27) THEN(GOTO CMDLBL(LOOP1))      C0562 */
/*           IF         COND(&IDX *LE 29) THEN(GOTO CMDLBL(LOOP1))C0562 C1790 */
/**********  IF         COND(&IDX *LE 30) THEN(GOTO CMDLBL(LOOP1))C1790092168 */
/************IF*********COND(&IDX *LE 31) THEN(GOTO CMDLBL(LOOP1))092168090949*/
             IF         COND(&IDX *LE 36) THEN(GOTO CMDLBL(LOOP1))    /*090949*/
 
/* If STOPJRN is found, then pass control to PC by renaming STOPJRN  +
   to DOWNJRN and continue proccesing. If QUITJRN is found, then +
   jump to end of program ELSE assume error has occured within TS8550 +
   which is not monitored for and so create QUITJRN and terminate pgm*/
/*PASSCTL:****CHKDLO*****DLO(STOPJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 PASSCTL:    CHKDLO     DLO(STOPJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(QUITNOW))
/************RNMDLO*****DLO(STOPJRN.TSM)*NEWDLO(DOWNJRN.TSM)*FLR(TSM)** C1734 */
             RNMDLO     DLO(STOPJRN.TSM) NEWDLO(DOWNJRN.TSM) +
                          FLR(&TSM) /* C1734 */
             GOTO       CMDLBL(GETLOOP)
/*QUITNOW:****CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******* C1734 */
 QUITNOW:    CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
             GOTO       CMDLBL(END)
 
/* Loop until PC has finished download */
 GETLOOP:    RTVDTAARA  DTAARA(TSSTAT (109 4)) RTNVAR(&LOOPA)
             CHGVAR     VAR(&LOOP) VALUE(&LOOPA)
             IF         COND(&LOOP *LE 0) THEN(CHGVAR VAR(&LOOP) +
                          VALUE(10))
 DELAY:      DLYJOB     DLY(&LOOP)
/************CHKDLO*****DLO(QUITJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)******** C1734 */
             CHKDLO     DLO(QUITJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)     /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CHKSTJRN1))
             GOTO       CMDLBL(END)
/*CHKSTJRN1:**CHKDLO*****DLO(STARTJRN.TSM)*FLR(TSM)*OBJTYPE(*DOC)****** C1734 */
 CHKSTJRN1:  CHKDLO     DLO(STARTJRN.TSM) FLR(&TSM) OBJTYPE(*DOC)    /* C1734 */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DELAY))
             CLRPFM     FILE(TSMABDPD)
             CLRPFM     FILE(TSMBOKPD)
             CLRPFM     FILE(TSMBRCPD)
             CLRPFM     FILE(TSMBRKPD)
             CLRPFM     FILE(TSMBRTPD)
             CLRPFM     FILE(TSMCCYPD)
             CLRPFM     FILE(TSMCURPD)
             CLRPFM     FILE(TSMCUSPD)
             CLRPFM     FILE(TSMDDGPD)
             CLRPFM     FILE(TSMDEMPD)
             CLRPFM     FILE(TSMDEVPD)
             CLRPFM     FILE(TSMDFXPD)
             CLRPFM     FILE(TSMDLDPD)
             CLRPFM     FILE(TSMDLSPD)
             CLRPFM     FILE(TSMDNBPD)
             CLRPFM     FILE(TSMDNSPD)
             CLRPFM     FILE(TSMFDIPD)
             CLRPFM     FILE(TSMHOLPD)
             CLRPFM     FILE(TSMINVPD)
             CLRPFM     FILE(TSMINYPD)
             CLRPFM     FILE(TSMMARPD)
             CLRPFM     FILE(TSMMKCPD)
             CLRPFM     FILE(TSMNOSPD)
/************CLRPFM     FILE(TSMSCTPD)                                /*090949*/
             CLRPFM     FILE(TSMTR1PD)
             CLRPFM     FILE(TSMTR2PD)
             CLRPFM     FILE(TSMCLMPD)                               /* C0562 */
             CLRPFM     FILE(TSMFFCPD)                               /* C1790 */
             CLRPFM     FILE(TSMSSIPD)                               /* 092168*/
             CLRPFM     FILE(TSMCTYPD)                               /* 092168*/
             CLRPFM     FILE(TSMSE1PD)                                /*090949*/
             CLRPFM     FILE(TSMSECPD)                                /*090949*/
             CLRPFM     FILE(TSMSEMPD)                                /*090949*/
             CLRPFM     FILE(TSMDSEPD)                                /*090949*/
             CLRPFM     FILE(TSMCNLPD)                                /*090949*/
             CLRPFM     FILE(TSMLIMPD)                                /*090949*/
             CLRPFM     FILE(TSMSEDPD)                                /*090949*/
             GOTO       CMDLBL(CHKSTJRN)
 
/* Global error handling */
/*ERROR:******CPYDOC*****FROMDOC(REFJRN.TSM)*FROMFLR(TSM)*+************ C1734 */
/*************************TODOC(QUITJRN.TSM)*TOFLR(TSM)**************** C1734 */
 ERROR:      CPYDOC     FROMDOC(REFJRN.TSM) FROMFLR(&TSM) +
                          TODOC(QUITJRN.TSM) TOFLR(&TSM)             /* C1734 */
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
 
 END:        ENDCMTCTL
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
