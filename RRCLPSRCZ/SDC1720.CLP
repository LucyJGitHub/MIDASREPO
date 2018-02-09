/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Recover w/out restore of jrn info')          */
/*********************************************************************/
/*                                                                   */
/*  Midas - Restart Recovery Module                                  */
/*                                                                   */
/*  SDC1720 RESTORATION OF DATABASE AND FORWARD RECOVERY             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9619            Date 01Feb06              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      085571             DATE 29MAR96              */
/*                      092701             DATE 06SEP95              */
/*                      S01408             DATE 03AUG95              */
/*                      S01408             DATE 10MAY95              */
/*                      060539             DATE 15JUL94              */
/*                      S01463             DATE 11FEB94              */
/*                      S01375             DATE 13JAN92              */
/*                      S01345             DATE 06NOV91              */
/*                      E29436             DATE 11OCT91              */
/*                      S01343             DATE 15AUG91              */
/*                      RT0159             DATE 26JUN91              */
/*                      LN0951             DATE 05NOV90              */
/*                      LN0911             DATE 23OCT90              */
/*                      E19934             DATE 12APR90              */
/*                      E13205             DATE 12APR90              */
/*                      S01192             DATE 12APR90              */
/*                      S01194             DATE 21FEB90              */
/*                      S01117             DATE 18/08/89             */
/*                      E11142             DATE 25/04/88             */
/*                      S01179             DATE 13/09/88             */
/*                      S01127             DATE 02/06/88             */
/*                      E11174             DATE 27/06/87             */
/*                      S01133             DATE 14/05/87             */
/*                      EFIX               DATE 16/03/87             */
/*                      S01118             DATE 16/03/87             */
/*                      E81132             DATE 13/11/86             */
/*                      E81140             DATE 19/08/86             */
/*                      E80978             DATE 15/08/86             */
/*                      S01098             DATE 08/07/86             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       085571 - Call AOBANKR0 with option *FREE to allow input of  */
/*                rundate.                                           */
/*       092701 - Remove access to non-existant SWIFT files.         */
/*       S01408 - Addition of core hook SDC1720001                   */
/*       S01408 - Addition of core hook SDC1720MP1                   */
/*              - Addition of core hook SDC1720MP2                   */
/*              - Addition of core hook SDC1720MP3                   */
/*              - Addition of core hook SDC1720MP4                   */
/*       060539 - Close all open access object files before restore. */
/*       S01463 - Rename FCC0401 job to RCFMONITOR.                  */
/*       S01375 - Changed for Auto Close of Business                 */
/*       S01345 - JOURNALLING SYSTEM RE-WRITE.                       */
/*       E29436 - MOVED TO SOURCE FILE RRCLSRC FROM SDCLSRC.         */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - AUTOBKP RENAMED TO RRAUTOBKP.                    */
/*                - CHKAUTO RENAMED TO RRCHKAUTO.                    */
/*                - SDC01 RENAMED TO SCC01                           */
/*                - SDC1713 RENAMED TO SCC1713                       */
/*       RT0159 - Messages should be sent via new Midas Info Screen. */
/*       LN0951 - CALL FCC0401 WITH PARAMETER 'I'.                   */
/*       LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*       E19934 - CHANGE CRTDUPOBJ OF JRNEX1 TO USE CPYF INSTEAD     */
/*                AS THIS DOES NOT REQUIRE A QUALIFYING LIBRARY      */
/*       E13205 - Correct flow                                       */
/*                (i) Process the restoration request.               */
/*                    Use journal information passed back from       */
/*                    SD1720 to check save parameters on JNSTAT      */
/*                    if these conflict call SDC1740 and tell        */
/*                    user what has happened. Recheck on exit.       */
/*               (ii) Process restoration to current status          */
/*                    for DISK restore                               */
/*              (iii) Allow DRS SDC1771 to function                  */
/*               (iv) Journal files after testing whether            */
/*                    to set up environment for B.O.B. recovery      */
/*                (v) Add status messages to inform user of          */
/*                    progress through SDC1720                       */
/*               (vi) Remove Goto end before SDC1771                 */
/*              (vii) Place delay job 5 when waiting for             */
/*                    RRAUTOBKP to terminate                         */
/*             (viii) Move code to start RRAUTOBKP so that it        */
/*                    always restarts even if CMD 1 from SD1720      */
/*               (ix) Delete copy of JRNEX1 in QTEMP. Will exist     */
/*                    if recovery failed after DSPJRN and FF on.     */
/*                (x) Check whether input cycle initiation was       */
/*                    run by calling SDC1761 pass parameter to       */
/*                    SD1720 which will handle the selection.        */
/*               (xi) Alter parameters to SDC1722, extra parameter   */
/*                    of ' '.                                        */
/*              (xii) Call SDC1774 instead of SDC1724 after restore  */
/*                    of save file DBIC.                             */
/*             (xiii) Begin and end commitment control when calling  */
/*                    MSC4002.                                       */
/*       S01192 - SWIFT 2780 PROTOCOL INCORPORATION                  */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01117 - MULTIBRANCHING                                     */
/*       E11142 - B.O.B RESTORE IS ACCESSING INCORRECT POSITION      */
/*                IN JNSTAT FOR DEVICE.                              */
/*       S01179 - AS400 CONVERSION                                   */
/*       S01127 - ADDITIONALLY PROCESS FUTURES/OPTIONS FILES -       */
/*                INCLUDING MULTIMEMBER FILES                        */
/*                CHANGE JOURNAL CODE 'SR' TO 'IR'                   */
/*       E11174 - AUTOBACKUP JOB SHOULD BE CANCELLED WITH            */
/*                SPLFILE(*YES)                                      */
/*       S01133 - ADDS CALLS TO PROCESSING TO COPE WITH MULTI-       */
/*                MEMBER FILES                                       */
/*       EFIX   - WHEN RESTORE ATTEMPTED FROM A SAVE FILE THE        */
/*                RSTLIB IS DONE WITH BLANK PARAMETERS               */
/*       S01118 - MIDAS/S.W.I.F.T. DIRECT LINK                       */
/*       E81132 - CHECK THAT THE LIBRARY PREFIX IN SDSTAT MATCHES    */
/*                THE ONE IN JNSTAT BEFORE USING IT.                 */
/*       E81140 - PROGRAM LOOPS IF RRAUTOBKP JOB HAS BEEN CANCELLED  */
/*                BUT JNSTAT POS 69 IS STILL SET TO 'Y'              */
/*       E80978 - MONMSG CPF1362 AFTER CANCELLING AUTO BACKUP        */
/*                JOB IN CASE JOB NO LONGER EXISTS IN THE SYSTEM     */
/*       S01098 - USE SAVE FILE FOR DISK SAVE.                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/******      PGM        PARM(&SDC01 &FLAG)                            /*S01343*/
             PGM        PARM(&SCC01 &FLAG)                            /*S01343*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LRECS) TYPE(*DEC) LEN(3)
             DCL        VAR(&NRECS) TYPE(*DEC) LEN(3)
             DCL        VAR(&CRECS) TYPE(*CHAR) LEN(3) VALUE('001')
             DCL        VAR(&SEQN1) TYPE(*DEC) LEN(10)
             DCL        VAR(&SEQN2) TYPE(*DEC) LEN(10)
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BKPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RECSAV) TYPE(*CHAR) LEN(8)
/*           DCL        VAR(&LIB1) TYPE(*CHAR) LEN(6)               *  *E81132*/
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBID1) TYPE(*CHAR) LEN(2)               /*E81132*/
             DCL        VAR(&FRPNT) TYPE(*DEC) LEN(10)
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10)
             DCL        VAR(&FRPNA) TYPE(*CHAR) LEN(10)               /*E13205*/
             DCL        VAR(&TOPNA) TYPE(*CHAR) LEN(10)               /*E13205*/
             DCL        VAR(&JINFO) TYPE(*CHAR) LEN(30)               /*E13205*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)                /*E13205*/
/***         DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
/*           DCL        VAR(&RMSG) TYPE(*CHAR) LEN(1)               *  *S01098*/
/*           DCL        VAR(&MONIND) TYPE(*CHAR) LEN(1)             *  *S01098*/
             DCL        VAR(&CURIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEVI) TYPE(*CHAR) LEN(10)
/******      DCL        VAR(&SDC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&SCC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(77)                 /*E81132*/
             DCL        VAR(&SWDR) TYPE(*CHAR) LEN(1)                 /*S01118*/
             DCL        VAR(&FF) TYPE(*CHAR) LEN(1)                   /*S01127*/
             DCL        VAR(&BLK) TYPE(*CHAR) LEN(2) VALUE('  ')      /*S01127*/
/*********** DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) **/ /*S01127*/ /*E19934*/
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(1)      /*S01117*/
             DCL        VAR(&TMG) TYPE(*CHAR) LEN(1) VALUE('T')       /*S01117*/
/**/
             DCLF       FILE(RCVRYL)
/**/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/**********  DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/**/                                                                  /*013755*/
/* clear previous save file flag             */                       /*S01375*/
/**/                                                                  /*S01375*/
             DCL        VAR(&CLEAR_SAVF) TYPE(*CHAR) LEN(4)           /*S01375*/
/**/                                                                  /*S01375*/
/* save file for restoring database          */                       /*S01375*/
/**/                                                                  /*S01375*/
             DCL        VAR(&SAVF) TYPE(*CHAR) LEN(5)                 /*S01375*/
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)           /*S01375*/
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)            /*S01375*/
             DCL        VAR(&RTCD)    TYPE(*CHAR) LEN(7)             /*060539*/
             DCL        VAR(&OPTN)    TYPE(*CHAR) LEN(7)             /*060539*/
             DCL        VAR(&BRCY)    TYPE(*CHAR) LEN(3)             /*060539*/
             DCL        VAR(&FMT)     TYPE(*CHAR) LEN(200)           /*060539*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CSC011*/
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10)                                    /*CSC011*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(10)                                    /*CSC011*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)                                    /*CSC011*/
             DCL        VAR(&SDMLIB) TYPE(*CHAR) LEN(10)                                  /*CSC011*/
             DCL        VAR(&S1MAIN) TYPE(*CHAR) LEN(2)                                   /*CSC011*/
             DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2)                                   /*CSC011*/
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
/*/COPY WNCPYSRC,SDC1720002                                          */
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/*/COPY WNCPYSRC,SDC1720005                                          */
/**/
             SNDPGMMSG  MSG('Restoration of Database and Forward +
                        Recovery') TOMSGQ(MRUNQ)
                                                                                          /*CSC011*/
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&SARD) VALUE('CSC011')                                        /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                VAR(&CSC011) VALUE('Y'))                                                  /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
                                                                                          /*CSC011*/
               RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&S1MAIN)                            /*CSC011*/
               RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&S1SUPP)                            /*CSC011*/
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)                              /*CSC011*/
                                                                                          /*CSC011*/
               IF         COND(&LIBR *NE &S1MAIN) THEN(DO)                                /*CSC011*/
                                                                                          /*CSC011*/
                 CHGVAR     VAR(&CALL) VALUE('SDC1720')                                   /*CSC011*/
                 CHGVAR     VAR(&SFMT) VALUE('SDC0700F10')                                /*CSC011*/
                 CHGVAR     VAR(&REPLY) VALUE(' ')                                        /*CSC011*/
                                                                                          /*CSC011*/
                 CALL PGM(SDC0700) PARM(&CALL &SFMT &REPLY)                               /*CSC011*/
                                                                                          /*CSC011*/
                 GOTO       CMDLBL(END)                                                   /*CSC011*/
               ENDDO                                                                      /*CSC011*/
                                                                                          /*CSC011*/
               ELSE       CMD(DO)                                                         /*CSC011*/
                 CHGVAR     VAR(&SDMLIB) VALUE(&S1SUPP *CAT 'DMLIB')                      /*CSC011*/
               ENDDO                                                                      /*CSC011*/
                                                                                          /*CSC011*/
             ENDDO                                                                        /*CSC011*/
/* */                                                                /*060539*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                  /*060539*/
             CHGVAR     VAR(&OPTN) VALUE('*FREE  ')                  /*060539*/
             CHGVAR     VAR(&BRCY) VALUE('   ')                      /*060539*/
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &BRCY &FMT)   /*060539*/
             CALL       PGM(AOCURRR0) PARM(&RTCD &OPTN &BRCY &FMT)   /*060539*/
/**/
/*   Check JNSTAT to make sure pgm being run on primary machine      */
/**/
             RTVDTAARA  DTAARA(JNSTAT (82 1)) RTNVAR(&BKPS)
             IF         COND(&BKPS *NE 'P') THEN(DO)
/***********    SNDPGMMSG  MSG('This option can only be run on +      /*RT0159*/
/***********                    the primary machine') +               /*RT0159*/
/***********                    MSGTYPE(*INQ) TOPGMQ(*EXT)            /*RT0159*/
                CALL       PGM(SDC0700) PARM('SDC1720' +
                             'OPTPRIMMCH' ' ')                        /*RT0159*/
                CHGJOB     SWS(XXXXXX1X)
                GOTO       END
             ENDDO
/**/
/* If RRAUTOBKP is running then cancel */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/                                                                  /*E81140*/
             IF         COND(%SST(&JNSTAT 111 10) *NE '          '+
                           ) THEN(DO)
                CALL       PGM(RRCHKAUTO)                             /*E81140*/
                IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)           /*E81140*/
/**/                                                                  /*E81140*/
/** RCV: *****  RCVDTAARA  DTAARA(JNSTAT)                           *  *S01179*/
 RCV:           RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)             /*S01179*/
/* TEST IF RECEIVER SAVE IS IN PROGRESS */
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Cancelling Auto Backup of Journal +
                          Receivers') TOPGMQ(*EXT) MSGTYPE(*STATUS)   /*E13205*/
/*              IF         COND(%SST(&JNSTAT 69 1) *EQ 'Y') THEN(GOTO +
/*                        CMDLBL(RCV))                             */ /*E13205*/
                IF         COND(%SST(&JNSTAT 69 1) *EQ 'Y') THEN(DO)  /*E13205*/
                   DLYJOB     DLY(5)                                  /*E13205*/
                   GOTO       CMDLBL(RCV)                             /*E13205*/
                ENDDO                                                 /*E13205*/
                ELSE       CMD(DO)
                   CHGVAR     VAR(&JOBN) VALUE(%SST(&JNSTAT 111 10))
                   CHGVAR     VAR(&USRN) VALUE(%SST(&JNSTAT 121 10))
                   CHGVAR     VAR(&JBNB) VALUE(%SST(&JNSTAT 131 6))
/*                                                                    /*E11174*/
/*                 CNLJOB     JOB(&JOBN.&USRN.&JBNB) OPTION(*IMMED) */
                   ENDJOB     JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED) +
                          SPLFILE(*YES)
/*                                                                    /*E11174*/
/******************MONMSG*****MSGID(CPF1321)*************************  *E80978*/
                   MONMSG     MSGID(CPF1321 CPF1362)                  /*E80978*/
                   CHGDTAARA  DTAARA(JNSTAT (111 26)) +
                                 VALUE('                          ')
                ENDDO
/**/
             ENDDO
/**/
/*  RETRIEVE SWIFT DIRECT LINK BYTE FROM DATA AREA MMOD                 S01118*/
/**/                                                                  /*S01118*/
             RTVDTAARA  DTAARA(MMOD (18 1)) RTNVAR(&SWDR)             /*S01118*/
/**/                                                                  /*S01118*/
/*  IF SWIFT DIRECT LINK PRESENT, TERMINATE COMPRESSION AND             S01118*/
/*  COMMUNICATION PROGRAMS                                              S01118*/
/**/                                                                  /*S01118*/
/*           IF         COND(&SWDR *EQ 'Y') THEN(CALL PGM(MSC4002))   /*S01118*/
             IF         COND(&SWDR *EQ 'Y') THEN(DO)                  /*E13205*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      /*E13205CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             CALL       PGM(MSC4002)                                  /*E13205*/
             ENDCMTCTL                                                /*E13205*/
             ENDDO                                                    /*E13205*/
/**/
/*     SEND MESSAGE TO DTAQ TO TERMINATE REPORT DISTRIBUTION          /*S01117*/
/**/                                                                  /*S01117*/
             CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' &DTQDLEN +
                          &TMG)                                       /*S01117*/
 LOOP3:      ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)          /*S01117*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LOOP3))       /*S01117*/
/**/
                                                                      /*S01118*/
/**/
/* SETUP LAST RECEIVER SAVED */
/**/
             CHGVAR     VAR(&LRECS) VALUE(%SST(&JNSTAT 16 3))
             CHGVAR     VAR(&LRECS) VALUE(&LRECS - 1)
             CHGVAR     VAR(&DEVI) VALUE(%SST(&JNSTAT 25 10))
/**/
/**********  RCVDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
/**/
/**/                                                                  /*E81132*/
/*           CHGVAR     VAR(&LIB1) VALUE(%SST(&SDSTAT 6 2) *CAT 'JLIB')    */
/**/
             CHGVAR     VAR(&LIBID) VALUE(%SST(&SDSTAT 6 2))
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
             CHGVAR     VAR(&LIBID1) VALUE(%SST(&JNSTAT 147 2))
         /**/
             IF  COND((&LIBID) *EQ '  ') THEN(DO)
                 CHGVAR     VAR(&MSG) VALUE('THE LIBRARY PREFIX IS +
                            MISSING FROM SDSTAT - CORRECT AND RETRY')
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
                 GOTO ABNOR
             ENDDO
         /**/
             IF  COND((&LIBID1) *EQ '  ') THEN(DO)
                 CHGVAR     VAR(&MSG) VALUE('THE LIBRARY PREFIX IS +
                            MISSING FROM JNSTAT - CORRECT AND RETRY')
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
                 GOTO ABNOR
             ENDDO
         /**/
             IF  COND((&LIBID) *NE (&LIBID1)) THEN(DO)
                 CHGVAR     VAR(&MSG) VALUE('THE LIBRARY PREFIX IN +
                              SDSTAT IS ' *CAT &LIBID *CAT ' BUT IN +
                              JNSTAT IT IS ' *CAT &LIBID1 *CAT ' - +
                              CORRECT AND RETRY')
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
                 GOTO ABNOR
             ENDDO
/**/                                                                  /*E81132*/
/* CHECK JRN RECEIVERS UP UNTIL LAST RECIEVER SAVED ARE PRESENT.  */
/* IF NOT SEND MESSAGE AND END PROGRAM */
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Checking that all journal receivers +
                          are present') TOPGMQ(*EXT) MSGTYPE(*STATUS) /*E13205*/
 CHECK:      CHGVAR     VAR(&RECSAV) VALUE('ICRCV' *CAT &CRECS)
             CHKOBJ     OBJ(&RECSAV) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/***********    SNDPGMMSG  MSG('Recovery cannot be run as there are + /*RT0159*/
/***********                 journal receivers missing. Run option to+/*RT0159*/
/***********                 restore all journal receivers then +     /*RT0159*/
/***********                 retry') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)/*RT0159*/
                SNDPGMMSG  MSG('Recovery cannot be run as there are +
                             journal receivers missing. Run option to +
                             restore all journal receivers then +
                             retry') TOMSGQ(MOPERQ MRUNQ)             /*RT0159*/
                CALL       PGM(SDC0700) PARM('SDC1720' +
                             'JRNRCVMISS' ' ')                        /*RT0159*/
                GOTO       END
                ENDDO
/**/
             CHGVAR     VAR(&NRECS) VALUE(&CRECS)
/**/
/* ADD 1 TO SEQUENCE OF NEXT RECEIVER TO CHECK AND REPEAT CHECK      */
/* PROCESSING IF NEXT RECEIVER IS GT LAST RECEIVER TO BE SAVED       */
/**/
             IF         COND(&NRECS *LT &LRECS) THEN(DO)
                CHGVAR     VAR(&NRECS) VALUE(&NRECS + 1)
                CHGVAR     VAR(&CRECS) VALUE(&NRECS)
                GOTO       CMDLBL(CHECK)
             ENDDO
                                                                      /*S01127*/
/********************************************************************  *S01127*/
/**SEND*JOURNAL*ENTRY*TYPE*'SR'*TO*JOURNAL***************************  *S01127*/
/************SNDJRNE****JRN(ICJRN)*TYPE('SR')************************  *S01127*/
/********************************************************************  *S01127*/
/**/                                                                  /*S01127*/
/* SEND JOURNAL ENTRY TYPE 'IR' TO JOURNAL */                         /*S01127*/
/**/                                                                  /*S01127*/
/*/COPY WNCPYSRC,SDC1720006                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('IR') */                              /*S01127*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('IR') FORCE(*YES)                                /*BUG9619*/
/*/COPY WNCPYSRC,SDC1720007                                          */
/**/                                                                  /*S01127*/
/* CHECK IF FUTURES AND OPTIONS MODULE IS PRESENT */                  /*S01127*/
/**/                                                                  /*S01127*/
             RTVDTAARA  DTAARA(MMOD (50 1)) RTNVAR(&FF)               /*S01127*/
                                                                      /*S01127*/
/**/
/* JOURNAL INFORMATION OUTPUT INTO FILE JRNEX1 */
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Extracting data from Journal - all +
                          IR, ER, SV, JS, AY, EJ, MR and SA entries') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*E13205*/
                                                                      /*S01127*/
/************DSPJRN*****JRN(ICJRN)*RCVRNG(ICRCV001)*ENTTYP(SR*ER*SV**  *S01127*/
/*/COPY WNCPYSRC,SDC1720008                                          */
             DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001) ENTTYP(IR ER SV +
                          JS AY EJ MR SA) OUTPUT(*OUTFILE) +
                          OUTFILE(JRNEX1)                             /*S01127*/
             MONMSG     MSGID(CPF7062)
/*/COPY WNCPYSRC,SDC1720009                                          */
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS PRESENT, ALSO ADD ENTRIES ADDED DURING EOC  *  *S01127*/
/* (THESE HAVE TO BE ADDED USING CPYF, AS THE DSPJRN COMMAND CAN    *  *S01127*/
/* ONLY HAVE 10 ENTTYP ENTRIES AND THERE IS NO *ADD OPTION)         *  *S01127*/
/**/                                                                  /*S01127*/
             IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
/***********  RCVDTAARA  DTAARA(SDSTAT)                             *  *S01179*/
              RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)               /*S01179*/
/************ CHGVAR  VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2) *CAT 'DLIB') /*E19934*/
                DLTF       FILE(QTEMP/JRNEX1)                         /*E13205*/
                MONMSG     MSGID(CPF2105)                             /*E13205*/
/*************  CRTDUPOBJ  OBJ(JRNEX1) FROMLIB(&LIBR)               +
                            OBJTYPE(*FILE) TOLIB(QTEMP) */ /*S01127*/ /*E19934*/
/*************  MONMSG     MSGID(CPD2104)     ***********/ /*S01127*/ /*E19934*/
             CPYF       FROMFILE(JRNEX1) TOFILE(QTEMP/JRNEX1) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*E19934*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                           MSGDTA('Extracting data from Journal - all +
                           IE, SR, RC and EE entries') TOPGMQ(*EXT) +
                           MSGTYPE(*STATUS)                           /*E13205*/
/*/COPY WNCPYSRC,SDC1720010                                          */
                DSPJRN     JRN(ICJRN) RCVRNG(ICRCV001) ENTTYP(IE SR RC +
                          EE) OUTPUT(*OUTFILE) OUTFILE(QTEMP/JRNEX1) +
                                                                      /*S01127*/
                MONMSG     MSGID(CPF7062) EXEC(GOTO CMDLBL(ENDFF))    /*S01127*/
/*/COPY WNCPYSRC,SDC1720011                                          */
                CPYF       FROMFILE(QTEMP/JRNEX1) TOFILE(JRNEX1) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01127*/
 ENDFF:         DLTF       FILE(QTEMP/JRNEX1)                         /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/* */                                                                 /*E13205*/
/* Clear Status Message information from display                   */ /*E13205*/
/* */                                                                 /*E13205*/
             SNDPGMMSG  MSGID(CPI9801) MSGF(QSYS/QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)                            /*E13205*/
/*           OVRDBF     FILE(TABLE) TOFILE(TABICD)   */               /*E81132*/
/**/                                                                  /*E13205*/
/* Call program to check input cycle initiation */                    /*E13205*/
/**/                                                                  /*E13205*/
             CALL       PGM(SDC1761) PARM(&SEQN1)                     /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
/**/
/* CALL PROGRAM TO PROMPT FOR RECOVERY POINTS  */
/**/
             CALL       PGM(SD1720) PARM(&SEQN1 &SEQN2 &VOL1 &FLAG +
                          &CURIND &JINFO)
/*                        &CURIND)                                 */ /*E13205*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/                                                                  /*085571*/
/*    Call AOBANKR0 with *FREE to close the file and allow user to    /*085571*/
/*    input the same rundate  before I/C Initiation crashed           /*085571*/
/**/                                                                  /*085571*/
             CALL       PGM(AOBANKR0) PARM('       ' '*FREE  ' ' ')   /*085571*/
             RCLRSC     LVL(*CALLER)                                  /*085571*/
/**/                                                                  /*085571*/
/*'IF'was moved to stop Swift marking duplicates when CMD 1 pressed * /*E13205*/
/* END PROCESSING IF &VOL1 IS BLANK */                                /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND(&VOL1 *NE '     ') THEN(DO)              /*E13205*/
/*  Add code from below, precheck before end of journaling to save  * /*E13205*/
/*  time                                                            * /*E13205*/
/*  RESTORE DATABASE FROM APPROPRIATE MEDIUM  */                      /*E13205*/
/**/                                                                  /*E13205*/
/*******        RTVDTAARA  DTAARA(JNSTAT (49 4)) RTNVAR(&SAVD)*/      /*E13205*/
CHK_SAVD:       IF         COND((&FLAG *EQ 'D') *OR (&FLAG *EQ 'A')) +
                   THEN(DO)                                           /*E13205*/
                      RTVDTAARA DTAARA(JNSTAT (35 4)) RTNVAR(&SAVD)   /*E13205*/
                   ENDDO                                              /*E13205*/
                   ELSE DO                                            /*E13205*/
                      RTVDTAARA DTAARA(JNSTAT (49 4)) RTNVAR(&SAVD)   /*E13205*/
                   ENDDO                                              /*E13205*/
/**/                                                                  /*S05745*/
             IF         COND((&FLAG *EQ 'A') *OR (&FLAG *EQ 'D')) +
                        THEN(DO)                                      /*S01375*/
/**/                                                                  /*S01375*/
/* Determine if the save device was tape if not change it */          /*S01375*/
/* to DISK                                                */          /*S01375*/
/**/                                                                  /*S01375*/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('          ')  /*S01375*/
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)       /*S01375*/
/**/                                                                  /*S01375*/
/*  If Savefile not blank and still not saved then use it */          /*S01375*/
/**/                                                                  /*S01375*/
             IF         COND((%SST(&CB_AUTO 107 5) *NE '     ') *AND +
                             (%SST(&JINFO 26 4) *EQ 'DISK')) +
                          THEN(DO)                                    /*S01375*/
             CHGVAR     VAR(&SAVD) VALUE(DISK)                        /*S01375*/
             GOTO CMDLBL(SKIP_VALID)                                  /*S01375*/
             ENDDO                                                    /*S01375*/
/**/                                                                  /*S01375*/
/*  If Savefile not blank then user may use it */                     /*S01375*/
/**/                                                                  /*S01375*/
             IF         COND((%SST(&CB_AUTO 107 5) *NE '     ') *AND +
                             (%SST(&JINFO 26 4) *EQ 'TAPE')) +
                          THEN(DO)                                    /*S01375*/
/**/                                                                  /*S01375*/
/* If the save device is CB_AUTO indicates that   */                  /*S01375*/
/* save file is not empty , ask the user if the wish to      */       /*S01375*/
/* restore from tape or savefile. If savefile is selected */          /*S01375*/
/* then change save device to DISK                        */          /*S01375*/
/**/                                                                  /*S01375*/
                IF      COND(&SAVD *NE 'TAPE') THEN(CHGVAR VAR(&SAVD) +
                        VALUE('DISK'))                                /*S01375*/
/**/                                                                  /*S01375*/
RETRYMSG:         SNDUSRMSG  MSG('Enter ''T'' to restore from Tape or +
                          ''S'' to restore from Savefile. (T,S)') +
                          MSGTYPE(*INQ) MSGRPY(&REPLY)                /*S01375*/
/**/                                                                  /*S01375*/
                  IF    COND((&REPLY *NE 'T') *AND (&REPLY *NE 't') +
                        *AND (&REPLY *NE 'S') *AND (&REPLY *NE 's')) +
                        THEN(GOTO CMDLBL(RETRYMSG))                   /*S01375*/
/**/                                                                  /*S01375*/
                  IF     COND((&REPLY *EQ 'S') *OR (&REPLY *EQ 's')) +
                        THEN(CHGVAR VAR(&SAVD) VALUE('DISK'))         /*S01375*/
                  IF     COND((&REPLY *EQ 'T') *OR (&REPLY *EQ 't')) +
                        THEN(CHGVAR VAR(&SAVD) VALUE('TAPE'))         /*S01375*/
                                                                      /*S01375*/
               ENDDO                                                  /*S01375*/
/**/                                                                  /*S01375*/
/* If &FLAG is 'A' or 'D' and &SAVD is disk skip the      */          /*S01375*/
/* &SAVD validation                                       */          /*S01375*/
/**/                                                                  /*S01375*/
               IF       COND(&SAVD *EQ 'DISK') THEN(GOTO +
                        CMDLBL(SKIP_VALID))                           /*S01375*/
/**/                                                                  /*S01375*/
             ENDDO                                                    /*S01375*/
/* */                                                                 /*E13205*/
/*  Check that save type is compatible with medium contained        * /*E13205*/
/*  in JNSTAT. If it does not tally call SDC1740 and send           * /*E13205*/
/*  status message indicating error.                                * /*E13205*/
/*  On return recheck save type, if still different ask for cancel. * /*E13205*/
/*  This code is to allow for changes through SDC1740 during IC     * /*E13205*/
/* */                                                                 /*E13205*/
                IF         COND(&SAVD *NE %SST(&JINFO 26 4)) THEN(DO) /*E13205*/
/* */                                                                 /*E13205*/
             SNDPGMMSG  MSG('Save device type (' *BCAT &SAVD *BCAT ') +
                          is not consistent with Save Medium to be +
                          restored (' *BCAT %SST(&JINFO 26 4) *BCAT +
                          ')') TOMSGQ(MOPERQ MRUNQ)                   /*E13205*/
             SNDUSRMSG  MSG('Save device type (' *BCAT &SAVD *BCAT ') +
                          is not consistent with Save Medium to be +
                          restored (' *BCAT %SST(&JINFO 26 4) *BCAT +
                          ') - C or c to end recovery  else press to +
                          continue via Save Parameter Maintenance') +
                          MSGTYPE(*INQ) MSGRPY(&REPLY)                /*E13205*/
             IF         COND((&REPLY *EQ 'C') *OR (&REPLY *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))                      /*E13205*/
/* */                                                                 /*E13205*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Medium to restore from (' *CAT +
                          &SAVD *CAT ') is not the same as Save +
                          medium (' *CAT %SST(&JINFO 26 4) *CAT ')') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CALL       PGM(SDC1740)
             IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)              /*E13205*/
             GOTO       CMDLBL(CHK_SAVD)                              /*E13205*/
/* */                                                                 /*E13205*/
                ENDDO                                                 /*E13205*/
/**/                                                                  /*S01375*/
SKIP_VALID:                                                           /*S01375*/
/* */                                                                 /*E13205*/
/**/
/*  IF SWIFT DIRECT LINK PRESENT AND IT IS NOT A SAVE TO CURRENT        S01118*/
/*  STATUS, SET POSSIBLE DUPLICATE ENTRY FLAG ON MSSTAT.                S01118*/
/**/                                                                  /*S01118*/
             IF         COND((&CURIND *NE '1') *AND (&SWDR *EQ 'Y')) +
                          THEN(CHGDTAARA DTAARA(MSSTAT (24 1)) +
                          VALUE('Y'))                                 /*S01118*/
/**/
/* END PROCESSING IF &VOL1 IS BLANK */
/**/
/*           IF         COND(&VOL1 *NE '     ') THEN(DO)           */ /*E13205*/
/**/                                                                  /*085571*/
/*    Call AOBANKR0 with *FREE to close the file and allow user to    /*085571*/
/*    input the same rundate  before I/C Initiation crashed           /*085571*/
/**/                                                                  /*085571*/
             CALL       PGM(AOBANKR0) PARM('       ' '*FREE  ' ' ')   /*085571*/
             RCLRSC     LVL(*CALLER)                                  /*085571*/
/**/                                                                  /*085571*/
/**/
/* END JOURNALLING */
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) MSGDTA('End +
                          Journaling of all files declared in Journal +
                          ICJRN') TOPGMQ(*EXT) MSGTYPE(*STATUS)       /*E13205*/
/*/COPY WNCPYSRC,SDC1720012                                          */
                ENDJRNPF   FILE(*ALL) JRN(ICJRN)
/*/COPY WNCPYSRC,SDC1720013                                          */
/**/                                                                  /*S01133*/
/* CALL PROCESSING TO REMOVE ALL MEMBERS FROM MULTI MEMBER FILES*/    /*S01133*/
                CALL SDC1770                                          /*S01133*/
/**/
/*  RESTORE DATABASE FROM APPROPRIATE MEDIUM  */
/**/
/*******        RTVDTAARA  DTAARA(JNSTAT (49 4)) RTNVAR(&SAVD)*/      /*E11142*/
/*              IF         COND((&FLAG *EQ 'D') *OR (&FLAG *EQ 'A')) +
/*                 THEN(DO)                                   *E11142* *S01375*/
/*                    RTVDTAARA DTAARA(JNSTAT (35 4)) RTNVAR(&SAVD)   /*E11142*/
/*                 ENDDO                                      *E11142* *S01375*/
/*                 ELSE DO                                    *E11142* *S01375*/
/*                    RTVDTAARA DTAARA(JNSTAT (49 4)) RTNVAR(&SAVD)   /*E11142*/
/*                 ENDDO                                      *E11142* *S01375*/
/**/
                IF         COND(&SAVD *EQ 'DISK') THEN(DO)
/**/
/*  PROCESSING FOR RESTORING B.O.B. SAVE IF &SAVD IS 'DISK'            */
/**/
/*                 IF         COND(&FLAG *EQ 'D') THEN(DO)         */ /*E13205*/
/**/
/*                    CHGVAR     VAR(&LIBID) VALUE(%SST(&SDSTAT 6 2)) /*E81132*/
/**/
/* IF RECOVERING TO CURRENT STATUS, CALL SDC1718 TO SAVE DATA AREAS */
/**/
/*                    IF         COND(&CURIND *EQ '1') THEN(CALL SDC1718)     */
/*                    IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END  E13205*/
/**/
/* CALL SDC1721 TO RESTORE DATA MASTER LIBRARY                      */
/**/
/*                    CALL       PGM(SDC1721) PARM(&VOL1 &LIBID)   */ /*E13205*/
/*                    IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END  E13205*/
/**/
/* IF RECOVERING TO CURRENT STATUS, CALL SDC1719 TO RESTORE DATA AREAS */
/**/
/*                 IF         COND(&CURIND *EQ '1') THEN(CALL SDC1719)/*E13205*/
/*                 IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)  /*E13205*/
/**/
/*                 ENDDO                                           */ /*E13205*/
/**/
/*  PROCESSING FOR RESTORING FROM DISK                                 */
/**/
/*                 IF         COND(&FLAG *NE 'D') THEN(DO)              EFIX  */
/**/
                      CHGVAR     VAR(&LIB2) VALUE(%SST(&SDSTAT 6 2) *CAT +
                                   'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1720MP2                                          */
                                                                      /*S01408*/
/**/
/*  CLEAR MASTER FILES */
/**/
/**/                                                                  /*S01098*/
/* FOLLOWING CHANGED FOR DI LIBRARY CHANGE TO SAVE FILE */            /*S01098*/
/**/                                                                  /*S01098*/
/*                    CALL       PGM(SDC1701) PARM(&LIB2)           *  *S01098*/
/*                    IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)  */
/**/                                                                  /*S01098*/
                      CHGVAR     VAR(&LIB3) VALUE(%SST(&SDSTAT 6 2) *CAT +
                                   'DILIB')                           /*S01098*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1720MP1                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01098*/
/**/
/*  COPY MASTER FILES */
/**/
/*                    CALL       PGM(SDC1702) PARM(&LIB3 &LIB2)     *  *S01098*/
/*                    IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)*/
/**/                                                                  /*S01098*/
/*                 ENDDO                                         S01098 EFIX  */
/**/
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Restoring database from save file +
                          ') TOPGMQ(*EXT) MSGTYPE(*STATUS)            /*E13205*/
/**/                                                                  /*E13205*/
/* IF RECOVERING TO CURRENT STATUS, CALL SDC1718 TO SAVE DATA AREAS * /*E13205*/
/**/                                                                  /*E13205*/
                   IF        COND(&CURIND *EQ '1') THEN(CALL SDC1718) /*E13205*/
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)  /*E13205*/
/**/                                                                  /*S01375*/
/* For restoring from a savefile if &FLAG is not equal to 'A' */      /*S01375*/
/* and 'D' restore from DBIC. Otherwise restore from the      */      /*S01375*/
/* savefile specified in the first 5 chars of &JINFO          */      /*S01375*/
/**/                                                                  /*S01375*/
/***************** RSTLIB  SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/DBIC) +/*S01375*/
/*****************            MBROPT(*ALL)                 /*S01098*/ /*S01375*/
                   IF      COND((&FLAG *NE 'D') *AND (&FLAG *NE 'A')) +
                           THEN(DO)                                   /*S01375*/
/**/                                                                  /*S01375*/
/**********           RSTLIB  SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/DBIC) + */   /*S01375*/ /*207764*/
/**********                   MBROPT(*ALL)                                */   /*S01375*/ /*207764*/
                      RSTLIB  SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/DBIC) +
                              MBROPT(*ALL) OUTPUT(*PRINT)                                 /*207764*/
                                                                                          /*CSC011*/
             IF    COND(&CSC011 *EQ 'Y') THEN(DO)                                         /*CSC011*/
/**********    RSTLIB     SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/DBIC) + */       /*CSC011*/ /*207764*/
/**********               MBROPT(*ALL) ALWOBJDIF(*FILELVL) +          */       /*CSC011*/ /*207764*/
/**********               RSTLIB(&SDMLIB)                             */       /*CSC011*/ /*207764*/
               RSTLIB     SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/DBIC) +
                          MBROPT(*ALL) ALWOBJDIF(*FILELVL) +
                          RSTLIB(&SDMLIB) OUTPUT(*PRINT)                                  /*207764*/
               CHGDTAARA  DTAARA(&SDMLIB/SDSTAT (6 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/TIDTA (11 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/CGDTA  (7 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/RPTRG  (1 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/RPTRG (21 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/RPTRG (39 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/RPTRG (49 2)) VALUE(&S1SUPP)                     /*CSC011*/
               CHGDTAARA  DTAARA(&SDMLIB/MPHAS (1 1)) VALUE('A')                          /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SDC1720003                                          */
/**/                                                                  /*S01375*/
                   ENDDO                                              /*S01375*/
                   ELSE       CMD(DO)                                 /*S01375*/
                      CHGVAR     VAR(&SAVF) VALUE(%SST(&JINFO 1 5))   /*S01375*/
/**********           RSTLIB     SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/&SAVF) + /*S01375*/ /*207764*/
/**********                      MBROPT(*ALL)                                  /*S01375*/ /*207764*/
                      RSTLIB     SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/&SAVF) +
                                 MBROPT(*ALL) OUTPUT(*PRINT)                              /*207764*/
                      MONMSG     MSGID(CPF3770) EXEC(DO)              /*S01375*/
                        SNDPGMMSG  MSG('SDC1720 attempted to +
                        restore from an empty save file.') +
                        TOMSGQ(MOPERQQ MRUNQ)
/**/
                        GOTO       CMDLBL(ABNOR)
                      ENDDO
                                                                                          /*CSC011*/
                      IF         COND(&CSC011 *EQ 'Y') THEN(DO)                           /*CSC011*/
/**********             RSTLIB     SAVLIB(&LIB2) DEV(*SAVF) +          */      /*CSC011*/ /*207764*/
/**********                        SAVF(&LIB3/&SAVF) MBROPT(*ALL) +    */      /*CSC011*/ /*207764*/
/**********                        ALWOBJDIF(*FILELVL) RSTLIB(&SDMLIB) */      /*CSC011*/ /*207764*/
                        RSTLIB     SAVLIB(&LIB2) DEV(*SAVF) SAVF(&LIB3/&SAVF) +
                                      MBROPT(*ALL) ALWOBJDIF(*FILELVL) +
                                      RSTLIB(&SDMLIB) OUTPUT(*PRINT)                      /*207764*/
                        MONMSG     MSGID(CPF3770 CPF3707) EXEC(DO)                        /*CSC011*/
                          SNDPGMMSG  MSG('SDC1720 attempted to +
                             restore from an empty save file.') +
                             TOMSGQ(MOPERQQ MRUNQ)                                        /*CSC011*/
                          GOTO       CMDLBL(ABNOR)                                        /*CSC011*/
                        ENDDO                                                             /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/SDSTAT (6 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/TIDTA (11 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/CGDTA  (7 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/RPTRG  (1 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/RPTRG (21 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/RPTRG (39 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                        CHGDTAARA  DTAARA(&SDMLIB/RPTRG (49 2)) +
                                      VALUE(&S1SUPP)                                      /*CSC011*/
                      ENDDO                                                               /*CSC011*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SDC1720004                                          */
                   ENDDO                                              /*S01375*/
/**/                                                                  /*E13205*/
/* IF RECOVERING TO CURRENT STATUS, CALL SDC1719 TO RESTORE DATA AREAS/*E13205*/
/**/                                                                  /*E13205*/
                   IF        COND(&CURIND *EQ '1') THEN(CALL SDC1719) /*E13205*/
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)  /*E13205*/
/*                 CALL SDC1724                                    */ /*S01098*/
                   CALL       PGM(SDC1774)                            /*E13205*/
                   IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)          /*S01098*/
                ENDDO
/**/
/*  PROCESSING FOR RESTORING FROM TAPE/DKTE                            */
/**/
                IF         COND(&SAVD *NE 'DISK') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Restoring database from ' *BCAT +
                          &VOL1) TOPGMQ(*EXT) MSGTYPE(*STATUS)        /*E13205*/
/**/
/*                 CHGVAR     VAR(&LIBID) VALUE(%SST(&SDSTAT 6 2))  *  *E81132*/
/**/
/* IF RECOVERING TO CURRENT STATUS, CALL SDC1718 TO SAVE DATA AREAS */
/**/
                   IF         COND(&CURIND *EQ '1') THEN(CALL SDC1718)
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/* CALL SDC1721 TO RESTORE DATA MASTER LIBRARY                      */
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1720MP3                                          */
                                                                      /*S01408*/
                   CALL       PGM(SDC1721) PARM(&VOL1 &LIBID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1720MP4                                          */
                                                                      /*S01408*/
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/* IF RECOVERING TO CURRENT STATUS, CALL SDC1719 TO RESTORE DATA AREAS */
/**/
                   IF         COND(&CURIND *EQ '1') THEN(CALL SDC1719)
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
                ENDDO
/**/                                                                 /*E13205*/
/**IF*RESTART*DAYS*PROCESSING*REQUESTED,*CALL*SDC1713*TO* /*E13205*/ /*S01343*/
/* IF RESTART DAYS PROCESSING REQUESTED, CALL SCC1713 TO SET UP    * /*S01343*/
/* JOURNAL & RECEIVERS THEN END PROGRAM                            * /*E13205*/
/**/                                                                 /*E13205*/
                IF         COND(&FLAG *EQ 'D') THEN(DO)              /*E13205*/
/**/                                                                 /*E13205*/
/******            CALL       PGM(SDC1713) PARM(&VOL1)    /*E13205*/ /*S01343*/
                   CALL       PGM(SCC1713) PARM(&VOL1)               /*S01343*/
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END) /*E13205*/
/**/                                                                 /*E13205*/
/******            CHGVAR     VAR(&SDC01) VALUE(SDC01)    /*E13205*/ /*S01343*/
                   CHGVAR     VAR(&SCC01) VALUE(SCC01)               /*S01343*/
                   GOTO       END                                    /*E13205*/
/**/                                                                 /*E13205*/
                ENDDO                                                /*E13205*/
/**/
/*  JOURNAL PHYSICAL FILES  */
/**/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Start Journaling files to journal +
                          ICJRN') TOPGMQ(*EXT) MSGTYPE(*STATUS)      /*E13205*/
/***************CALL       PGM(SDC1730) **/                           /*S01345*/
                CALL       PGM(SCJRN)                                 /*S01345*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/**IF*RESTART*DAYS*PROCESSING*REQUESTED,*CALL*SDC1713*TO*SET*UP    * /*S01343*/
/* IF RESTART DAYS PROCESSING REQUESTED, CALL SCC1713 TO SET UP    * /*S01343*/
/* JOURNAL & RECEIVERS THEN END PROGRAM                            */
/**/
/*              IF         COND(&FLAG *EQ 'D') THEN(DO)           */ /*E13205*/
/**/
/******            CALL       PGM(SDC1713) PARM(&VOL1)    /*E13205*/ /*S01343*/
                   CALL       PGM(SCC1713) PARM(&VOL1)               /*S01343*/
/*                 IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END) /*E13205*/
/**/
/*                 CHGVAR     VAR(&SDC01) VALUE(SDC01)            */ /*E13205*/
/*                 GOTO       END                                 */ /*E13205*/
/**/
/*              ENDDO                                             */ /*E13205*/
/**/
/* FORWARD RECOVERY PROCESSING - BYPASS IF F.R. NOT REQUESTED     */
/**/
                IF         COND(&FLAG *EQ 'C') THEN(GOTO ENDFR)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Create recovery points and store in +
                          file RCVRY') TOPGMQ(*EXT) MSGTYPE(*STATUS)  /*E13205*/
/**/
                CLRPFM     FILE(RCVRY)
/**/
                CALL       PGM(SD1721) PARM(&SEQN1 &SEQN2)
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS IS PRESENT IN THE SYSTEM, SET UP PF/JRNFIL  *  *S01127*/
/* TO CONTAIN ONLY SINGLE MEMBER FILES.                             *  *S01127*/
/* ( FF MULTIMEMBER FILES RECOVERED BY SDC1743 )                    *  *S01127*/
/**/                                                                  /*S01127*/
                IF         COND(&FF *EQ 'Y') THEN(DO)                 /*S01127*/
                    CLRPFM     FILE(JRNFIL)                           /*S01127*/
/*******************CALL       PGM(SD1730) PARM('   ') **/ /*S01127*/ /*S01345*/
                    CALL       PGM(RRC1730)                           /*S01345*/
                ENDDO                                                 /*S01127*/
/**/                                                                  /*S01127*/
/**/
/* READ FILE RCVRYL UNTIL END OF FILE */
/**/
 READ:          RCVF
                                                                      /*S01127*/
/***************MONMSG*****MSGID(CPF0864)*EXEC(GOTO*CMDLBL(CLEAR))***  *S01127*/
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(CHKFF))    /*S01127*/
                                                                      /*S01127*/
                CHGVAR     VAR(&FRPNA) VALUE(&FRPNT)                  /*E13205*/
                CHGVAR     VAR(&TOPNA) VALUE(&TOPNT)                  /*E13205*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Apply journal changes from ' *BCAT +
                          &FRPNA *BCAT ' to ' *BCAT &TOPNA) +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*E13205*/
/*              CALL       PGM(SDC1722) PARM(&FRPNT &TOPNT)        */ /*E13205*/
                CALL       PGM(SDC1722) PARM(&FRPNT &TOPNT ' ')       /*E13205*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS IS PRESENT IN THE SYSTEM, FORWARD RECOVER   *  *S01127*/
/* 'OTC' MEMBER OF MULTIMEMBER FILES BETWEEN THE POINTS             *  *S01127*/
/* IDENTIFIED FOR SINGLE MEMBER FILES                               *  *S01127*/
/**/                                                                  /*S01127*/
             IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
                CALL       PGM(SDC1742) PARM(&BLK &FRPNT &TOPNT)      /*S01127*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)     /*S01127*/
             ENDDO                                                    /*S01127*/
/**/                                                                  /*S01127*/
                GOTO       CMDLBL(READ)
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/* IF FUTURES & OPTIONS IS PRESENT IN THE SYSTEM,                   *  *S01127*/
/* NOW THAT ALL NON FF FILES AND FF SINGLE-MEMBER FILES AND THE     *  *S01127*/
/* 'OTC' MEMBER OF FF MULTI-MEMBER FILES HAVE BEEN FORWARD RECOVERED*  *S01127*/
/* RECOVER ALL MEMBERS OF FF MULTI-MEMBER FILES                     *  *S01127*/
/**/                                                                  /*S01127*/
 CHKFF:      IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
/**/                                                                  /*S01127*/
/* FORWARD RECOVER ALL OTHER MARKET MEMBERS FOR POINTS DETERMINED   *  *S01127*/
/* FOR EACH MARKET INDIVIDUALLY                                     *  *S01127*/
/**/                                                                  /*S01127*/
                CHGVAR     VAR(&FRPNA) VALUE(&SEQN1)                  /*E13205*/
                CHGVAR     VAR(&TOPNA) VALUE(&SEQN2)                  /*E13205*/
                SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Recover multimembered Futures and +
                          Options files from ' *BCAT &FRPNA *BCAT ' +
                          to ' *BCAT &TOPNA) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)                            /*E13205*/
                CALL       PGM(SDC1743) PARM(&SEQN1 &SEQN2)           /*S01127*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)     /*S01127*/
/**/                                                                  /*S01127*/
             ENDDO                                                    /*S01127*/
/**/                                                                  /*S01127*/
/*LEAR**********CLRPFM*****FILE(RCVRY)*******************************  *S01127*/
                CLRPFM     FILE(RCVRY)                                /*S01127*/
                                                                      /*S01127*/
/* */                                                                 /*E13205*/
/* Clear Status Message information from display                   */ /*E13205*/
/* */                                                                 /*E13205*/
             SNDPGMMSG  MSGID(CPI9801) MSGF(QSYS/QCPFMSG) +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*E13205*/
/**/
/**/
/* CALL SDC1723 TO RECOVER THE DATAAREAS IF FORWARD RECOVERY WAS REQUESTED */
/* BYPASS IF RECOVERING TO CURRENT STATUS                                  */
/**/
             IF         COND(&CURIND *EQ '1') THEN(GOTO ENDFR)
/**/
/*  IF SWIFT DIRECT LINK PRESENT AND IT IS A SAVE TO A JOURNAL          S01118*/
/*  RECIEVER SAVE i.e. CURIND NE 1 AND FLAG = A OR B, CHANGE            S01118*/
/*  MESSAGE STATUS FORM P OR R TO A.                                    S01118*/
/**/                                                                  /*S01118*/
             IF         COND(&SWDR *EQ 'Y') THEN(CALL PGM(MS1701))    /*S01118*/
/**/                                                                  /*S01118*/
/*           IF         COND(&FLAG *EQ 'A' *OR &FLAG *EQ 'B') +    */ /*E13205*/
/*                        THEN(CALL PGM(SDC1723) PARM(&TOPNT))     */ /*E13205*/
             IF         COND(&FLAG *EQ 'A' *OR &FLAG *EQ 'B') +
                          THEN(CALL PGM(SDC1762) PARM(&TOPNT ' '))    /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
ENDFR:          CHGDTAARA  DTAARA(JNSTAT (74 1)) VALUE('Y')
                CHGVAR     VAR(%SST(&JRNE 1 10)) VALUE(&SEQN2)
/**/
/* SEND USER DEFINED 'ER' ENTRY TO JOURNAL */
/**/
/*/COPY WNCPYSRC,SDC1720014                                          */
/**********     SNDJRNE    JRN(ICJRN) TYPE('ER') ENTDTA(&JRNE) */                        /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE('ER') ENTDTA(&JRNE) FORCE(*YES)               /*BUG9619*/
/*/COPY WNCPYSRC,SDC1720015                                          */
/**/
/*  IF SWIFT DIRECT LINK PRESENT AND NOT RETURNING TO BEGINING          S01118*/
/*  OF BUSINESS, RUN LOST INCOMING MESSAGES REPORT.                     S01118*/
/**/                                                                  /*S01118*/
/**********  IF         COND((&FLAG *NE 'D') *AND (&SWDR *EQ 'Y')) +  /*092701*/
/**********               THEN(DO)                         /*S01118*/ /*092701*/
/**********  DSPJRN     JRN(ICJRN) FILE((MSIMSPF)) RCVRNG(ICRCV001) + /*092701*/
/**********               FROMENT(&SEQN2) PGM(MS4010) +               /*092701*/
/**********               OUTPUT(*OUTFILE) OUTFILE(MSILSPF)/*S01118*/ /*092701*/
/**********        MONMSG     MSGID(CPF7062)               /*S01118*/ /*092701*/
/**********        CALL       PGM(MSC1700)                 /*S01118*/ /*092701*/
/**********        IF   COND(%SWITCH(XXXXXX11)) THEN(GOTO END) /*S01118*092701*/
/**********  ENDDO                                         /*S01118*/ /*092701*/
/**/                                                                  /*S01127*/
             IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
/**/                                                                  /*S01127*/
/* AS ANY MARKET MAY HAVE BEEN RECOVERED TO A POINT WITHIN ITS EOC  *  *S01127*/
/* WHERE IT WAS ACTIVE, SET ANY SUCH MARKET STATUS TO FAILED SO     *  *S01127*/
/* THAT IT CAN BE RESTARTED USING EOC RESTART PROCEDURE             *  *S01127*/
/* AND CLEAR ANY REQUESTED 'HOLDS'                                  *  *S01127*/
/**/                                                                  /*S01127*/
                CALL       PGM(SDC1744)                               /*S01127*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)     /*S01127*/
/**/                                                                  /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/                                                                  /*E13205*/
/* Enddo paired with IF VOL1 *NE to blanks - moved from after AUTO */ /*E13205*/
/**/                                                                  /*E13205*/
             ENDDO                                                    /*E13205*/
/**/                                                                  /*S01127*/
/**/
/* IF 'AUTO RECEIVER SAVE PERIOD' IS NON-ZERO RESUBMIT AUTOBACKUP */
/**/
             IF         COND(%SST(&JNSTAT 106 5) *NE '00000') +
                          THEN(CALL PGM(SDC1760))
                             IF   COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/**/
/* Moved to before Auto receiver backup code */                       /*E13205*/
/*           ENDDO                                                  * /*E13205*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1720001                                           /*S01408*/
                                                                      /*S01408*/
/**/                                                                  /*S01118*/
/*  IF SWIFT DIRECT LINK PRESENT, BEGIN COMPRESSION AND                 S01118*/
/*  COMMUNICATIONS PROGRAMS                                             S01118*/
/**/                                                                  /*S01118*/
/*           IF         COND(&SWDR *EQ 'Y') THEN(CALL PGM(MSC4001))    *S01192*/
             IF         COND(&SWDR *EQ 'Y') THEN(CALL PGM(MSC0203))   /*S01192*/
/**/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                   /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
                                                                      /*LN0911*/
/**********  SBMJOB     CMD(CALL PGM(FCC0401)) JOB(FCC0401) +
                          JOBD(FCJOBD) JOBQ(FCJOBQ) PRTDEV(*JOBD) +
                          OUTQ(*JOBD) PRTTXT(*JOBD) SYSLIBL(*SYSVAL) +
                          CURLIB(*CRTDFT) INLLIBL(*JOBD) MSGQ(MOPERQ) /*S01117*/
                                                                      /*LN0951*/
/**********  SBMJOB     CMD(CALL PGM(FCC0401)) JOB(FCC0401) +
                          JOBD(FCJOBD) JOBQ(FCJOBQ) PRTDEV(*JOBD) +
                          OUTQ(*JOBD) PRTTXT(*JOBD) SYSLIBL(*SYSVAL) +
            CURLIB(*CRTDFT) INLLIBL(*JOBD) MSGQ(MOPERQ) RTGDTA(*JOBD) */
/**********  SBMJOB     CMD(CALL PGM(FCC0401) PARM('I')) +
/**********               JOB(FCC0401) JOBD(FCJOBD) JOBQ(FCJOBQ) +
/**********               PRTDEV(*JOBD) OUTQ(*JOBD) PRTTXT(*JOBD) +
/**********               RTGDTA(*JOBD) SYSLIBL(*SYSVAL) +
/**********               CURLIB(*CRTDFT) INLLIBL(*JOBD) MSGQ(MOPERQ) /*S01463*/
/************SBMJOB     CMD(CALL PGM(FCC0401) PARM('I')) +                                /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +                     /*CPK014*/
/************             PRTDEV(*JOBD) OUTQ(*JOBD) PRTTXT(*JOBD) +                       /*CPK014*/
/************             RTGDTA(*JOBD) SYSLIBL(*SYSVAL) +                                /*CPK014*/
/************             CURLIB(*CRTDFT) INLLIBL(*JOBD) MSGQ(MOPERQ) /*S01463*/          /*CPK014*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM('I')) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          PRTDEV(*JOBD) OUTQ(*JOBD) USER(*JOBD) +
                          PRTTXT(*JOBD) RTGDTA(*JOBD) +
                          SYSLIBL(*SYSVAL) CURLIB(*CRTDFT) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CPK014*/
                                                                      /*LN0951*/
                                                                      /*LN0911*/
/*           GOTO       CMDLBL(END)                                */ /*E13205*/
/**/                                                                  /*S01133*/
/* CALL PROCESSING TO ADD MEMBERS BACK TO FILE*/                      /*S01133*/
             CALL SDC1771                                             /*S01133*/
             GOTO       CMDLBL(END)                                   /*S01133*/
/**/
/* DATABASE ERROR PROCESSING */
/**/
/*** DBERR:      RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01194*/
 DBERR:      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
/***ABNOR:******SNDPGMMSG  MSG('Restoration of Database and Forward + /*RT0159*/
/***********            Recovery ENDED ABNORMALLY') +                 /*RT0159*/
/***********            TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)             /*RT0159*/
 ABNOR:                                                               /*RT0159*/
             SNDPGMMSG  MSG('Restoration of Database and Forward +
                          Recovery ENDED ABNORMALLY') TOMSGQ(MRUNQ +
                          MOPERQ)                                     /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL       PGM(SDC0700) PARM('SDC1720' 'RODBAFRABN' ' +
                          ')                                          /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM                                                 /*EFIX  */
/**/
/*ND:        ENDPGM                                               */  /*S01117*/
 END:        DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                   /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
