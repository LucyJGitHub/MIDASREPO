/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Recovery with restore of jrn info')          */
/********************************************************************/
/*                                                                  */
/*        Midas - Restart Recovery Module                           */
/*                                                                  */
/*      SDC1725 - RESTORE JOURNAL RECEIVERS                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 207764            Date 23Jul02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001            Date  01SEP97              */
/*                      S01408            Date  10MAY95              */
/*                      S01343            DATE  15AUG91             */
/*                      RT0138            DATE  21JUL91             */
/*                      E22987            DATE  26JUL90             */
/*                      E13205            DATE  09/03/89            */
/*                      S01179            DATE  13/09/88            */
/*                      S01173            DATE  30/06/88            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       207764 - Change all SAV* and RST* commands to print a      */
/*                report of objects saved or restored.              */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1        */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - AUTOBKP RENAMED TO RRAUTOBKP.                   */
/*                - CHKAUTO RENAMED TO RRCHKAUTO.                   */
/*                - SDC01 RENAMED TO SCC01                          */
/*       RT0138 - Abnormal termination should prompt re-try screen  */
/*                so that media errors can be dealt with.           */
/*       E22987 - REMOVE OLD HELP PROCESSING                        */
/*       E13205 - Allow only a positive number of tapes             * /*E13205*/
/*                Apply fix E81140 for closedown of RRAUTOBKP       * /*E13205*/
/*                Apply fix E80902 for chgjob to *DFT               * /*E13205*/
/*                                                                  */
/*       S01179 - AS400 CONVERSION                                  */
/*       S01173 - USE SPECIFIED ASP FOR JOURNAL/RECEIVERS           */
/*       S01408 - Addition of core hook SDC1725                     */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/******      PGM        PARM(&SDC01 &FLAG)                            /*S01343*/
             PGM        PARM(&SCC01 &FLAG)                            /*S01343*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   Initial processing                                             */
/**/
             DCL        VAR(&BKPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEVI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLAG1) TYPE(*DEC) LEN(1 0)
/************DCL********VAR(&HBPGM) TYPE(*CHAR) LEN(8) VALUE('RR1725')/*E22987*/
/************DCL********VAR(&HERCD) TYPE(*CHAR) LEN(80)               /*E22987*/
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MONIND) TYPE(*LGL) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUM1) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&NUMA) TYPE(*CHAR) LEN(3) VALUE('001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RCVNUM) TYPE(*DEC) LEN(3 0) VALUE(001)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
/******      DCL        VAR(&SDC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&SCC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCLF       FILE(SD1725FM)
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1) VALUE(R)         /*RT0138*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CTI001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST') /*CTI001*/
             DCL        VAR(&AOMMOD) TYPE(*CHAR) LEN(200)             /*CTI001*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/*/COPY WNCPYSRC,SDC1725007                                          */
/**/
/*   Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Restore Journal Receivers') +
                          TOMSGQ(MRUNQ)
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
/**/                                                                  /*CTI001*/
/* Call AOMMODR0 to retrieve Midas/TI Interface module status */      /*CTI001*/
/**/                                                                  /*CTI001*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &AOMMOD)       /*CTI001*/
                                                                      /*CTI001*/
/*  Database error handling  */                                       /*CTI001*/
                                                                      /*CTI001*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CTI001*/
                SNDPGMMSG  MSG('Database error on Midas modules +
                             file') TOMSGQ(MOPERQ MRUNQ)              /*CTI001*/
                GOTO       CMDLBL(ABNOR)                              /*CTI001*/
             ENDDO                                                    /*CTI001*/
/**/                                                                  /*CTI001*/
RETRY:                                                                /*RT0138*/
/**/
/*   Check JNSTAT to make sure pgm being run on primary machine      */
/**/
             RTVDTAARA  DTAARA(JNSTAT (82 1)) RTNVAR(&BKPS)
             IF         COND(&BKPS *NE 'P') THEN(DO)
                SNDPGMMSG  MSG('This option can only be run on +
                                the primary machine') +
                                MSGTYPE(*INQ) TOPGMQ(*EXT)
                CHGJOB     SWS(XXXXXX1X)
                GOTO       ENDPGM
             ENDDO
/**/
/* If RRAUTOBKP is running then cancel                               */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
             IF         COND(%SST(&JNSTAT 111 10) *NE '          '+
                           ) THEN(DO)
                CALL       PGM(RRCHKAUTO)                             /*E13205*/
                IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)           /*E13205*/
/** RCV: *****  RCVDTAARA  DTAARA(JNSTAT)                           *  *S01179*/
 RCV:           RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)             /*S01179*/
/**/
/* Test if receiver save is in progress                              */
/**/
                IF         COND(%SST(&JNSTAT 69 1) *EQ 'Y') THEN(GOTO +
                          CMDLBL(RCV))
/**/
                ELSE       CMD(DO)
                   CHGVAR     VAR(&JOBN) VALUE(%SST(&JNSTAT 111 10))
                   CHGVAR     VAR(&USRN) VALUE(%SST(&JNSTAT 121 10))
                   CHGVAR     VAR(&JBNB) VALUE(%SST(&JNSTAT 131 6))
                   ENDJOB     JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED)
                   MONMSG     MSGID(CPF1321)
                   CHGDTAARA  DTAARA(JNSTAT (111 26)) +
                                 VALUE('                          ')
                ENDDO
/**/
             ENDDO
/**/
/*   Call SDC1715 with &PARM as 1 to save current journal receiver  */
/*   without re-submitting RRAUTOBKP, then reset &PARM              */
/**/
             CHGVAR     VAR(&PARM) VALUE('1')
             CALL       PGM(SDC1715) PARM(&PARM)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
             CHGVAR     VAR(&PARM) VALUE('0')
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
             CHGVAR     VAR(&JLIB) VALUE(&LIBID *TCAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1725MP1                                          */
                                                                      /*S01408*/
/**/
/*   Output and validate prompt screen                              */
/**/
SCREEN:      SNDRCVF    RCDFMT(SD1725FM)
             IF         COND(&IN01 *EQ '1') THEN(GOTO END)
/*           IF         COND(&NUMTAP *EQ 0) THEN(GOTO SCREEN)      */ /*E13205*/
             IF         COND(&NUMTAP *LE 0) THEN(GOTO SCREEN)         /*E13205*/
/**/
/****Processing for HELP                                           */ /*E22987*/
/**/
/************IF         COND(&IN02 *EQ '1') THEN(DO)               */ /*E22987*/
/************   CALL       PGM(MHELP) PARM(&HBPGM &HERCD)          */ /*E22987*/
/************   GOTO       SCREEN                                  */ /*E22987*/
/************ENDDO                                                 */ /*E22987*/
/**/                                                                  /*E13205*/
/*** Add a reply list entry so that "Receiver never had full save" */ /*E13205*/
/*** messages are answered automatically by the program, then      */ /*E13205*/
/*** remove the entry after receivers have been deleted            */ /*E13205*/
/**/                                                                  /*E13205*/
/*           CHGJOB     INQMSGRPY(*SYSRPYL)   */                      /*E13205*/
/*           ADDRPYLE   SEQNBR(3) MSGID(CPA7025) RPY(I)          */   /*E13205*/
/**/                                                                  /*E13205*/
/* CHANGE JOB ATTRIBUTES FOR INQMSGRPY SO THAT "RECEIVER NEVER HAD */ /*E13205*/
/* FULL SAVE" MESSAGES ARE ANSWERED AUTOMATICALLY BY THE PROGRAM,  */ /*E13205*/
/* THEN CHANGE THE JOB AGAIN TO THE ORIGINAL STATE AFTER RECEIVERS */ /*E13205*/
/* HAVE BEEN DELETED                                               */ /*E13205*/
/**/                                                                  /*E13205*/
             CHGJOB     INQMSGRPY(*DFT)                               /*E13205*/
/**/                                                                  /*CTI001*/
/* If Midas/TI Interface on then stop SD replication */               /*CTI001*/
/**/                                                                  /*CTI001*/
             IF         COND(%SST(&AOMMOD 103 1) *EQ 'Y') THEN(DO)    /*CTI001*/
               CALL     PGM(TIC0030) PARM('STOP')                     /*CTI001*/
             ENDDO                                                    /*CTI001*/
/**/                                                                  /*CTI001*/
/*   Delete all journal receivers except current one                */
/**/
             DLTJRNRCV  JRNRCV(&JLIB/ICRCV*)
             MONMSG     MSGID(CPF7022 CPF2117)
/**/
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD)
/**/
/*   Send message to prompt for first tape/diskette                 */
/**/
/*/COPY WNCPYSRC,SDC1725001                                          */
             SNDPGMMSG  MSG('Load first JRNIC tape/diskette magazine +
                          then press ENTER') MSGTYPE(*INQ) TOPGMQ(*EXT)
/*/COPY WNCPYSRC,SDC1725002                                          */
             RCVMSG     MSG(&MSG) PGMQ(*EXT)
/**/
             RTVDTAARA  DTAARA(JNSTAT (21 4)) RTNVAR(&SAVD)
             RTVDTAARA  DTAARA(JNSTAT (25 10)) RTNVAR(&DEVI)
/**/
/*   Check the device is mounted properly                           */
/**/
TAPDKT:      IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
/**/
 CHECK1:     CHKDKT     DEV(DKT01) VOL(JRNIC)
/**/
             MONMSG     MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Diskette with volume ID JRNIC +
                                             not found. Mount the +
                                             correct diskette and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6164) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to read diskette due to +
                                             surface defect. Restore not +
                                             possible. Enter "C" to cancel +
                                             and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG     MSG(&MSG) PGMQ(*EXT)
/**/
                             IF         COND(&MSG *EQ 'C') THEN(DO)
                               SNDPGMMSG  MSG('Restore Journal Receivers  +
                                               - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO END
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK1
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/**/
/*/COPY WNCPYSRC,SDC1725003                                          */
 CHECK2:     CHKTAP     DEV(&DEVI) VOL(JRNIC)
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available +
                                             and mount volume JRNIC OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6720) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Tape with volume ID JRNIC not +
                                             found. Mount the correct volume +
                                             and retry OR enter "C" to cancel +
                                             and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6760) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not ready. Mount volume +
                                             with ID JRNIC on the +
                                             device, press START and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6772) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Cannot process mounted volume +
                                             due to defect on the tape. Re +
                                             store not possible. Enter "C" +
                                             to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF9814) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not found. Mount the +
                                             volume with ID JRNIC on the +
                                             correct device and retry OR enter +
                                             "C" to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
/*/COPY WNCPYSRC,SDC1725004                                          */
                        ENDDO
/*/COPY WNCPYSRC,SDC1725008                                          */
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG     MSG(&MSG) PGMQ(*EXT)
/**/
                             IF         COND(&MSG *EQ 'C') THEN(DO)
                               SNDPGMMSG  MSG('Restore Journal Receivers  +
                                               - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO END
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
/*/COPY WNCPYSRC,SDC1725009                                          */
                               GOTO CHECK2
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/*   Restore all journal receivers from the tape/diskette           */
/**/
 NEXT:       IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/**********     RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
/**********                  OBJTYPE(*JRNRCV) DEV(&DEVI) VOL(*MOUN */ /*S01173*/
/**********     RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +      */     /*S01173*/ /*207764*/
/**********                 OBJTYPE(*JRNRCV) DEV(&DEVI) VOL(*MOUNTED) + */     /*S01173*/ /*207764*/
/**********                 RSTASP(%SST(&JNSTAT 151 2))                 */     /*S01173*/ /*207764*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                          DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                          OUTPUT(*PRINT) RSTASPDEV(&IASP)                                 /*CSC043*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                            OBJTYPE(*JRNRCV) DEV(&DEVI) VOL(*MOUNTED) +
                            RSTASP(%SST(&JNSTAT 151 2)) OUTPUT(*PRINT)                    /*207764*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)
             ENDDO                                                                        /*CSC043*/
                GOTO CHKRECV2
             ENDDO
/**/
             IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
/**********     RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
/**********                  OBJTYPE(*JRNRCV) DEV(&DEVI) LOC(*M1 +
/**********                  *SEARCH) VOL(*MOUNTED)   */              /*S01173*/
/**********  RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +         */     /*S01173*/ /*207764*/
/**********               DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +   */     /*S01173*/ /*207764*/
/**********                  RSTASP(%SST(&JNSTAT 151 2))                */     /*S01173*/ /*207764*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                          DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                          OUTPUT(*PRINT) RSTASPDEV(&IASP)                                 /*CSC043*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                             DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                             RSTASP(%SST(&JNSTAT 151 2)) OUTPUT(*PRINT)                   /*207764*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)
             ENDDO                                                                        /*CSC043*/
                GOTO CHKRECV2
             ENDDO
/**/
/*   Check that first receiver restored was ICRCV001 and that all the */
/*   subsequent receivers have been restored in the correct sequence  */
/**/
CHKRECV1:    IF         COND(&RCVNUM *EQ 1) THEN(GOTO ERRMSG)
             IF         COND(&FLAG1 *EQ 1) THEN(GOTO ERRMSG)
/**/
             CHGVAR     VAR(&FLAG1) VALUE(1)
             CHGVAR     VAR(&NUM1) VALUE(&NUM1 + 1)
/**/
/*   If no more tapes/dktes to process, end program. Otherwise prompt */
/*   for next tape/dkte to be loaded                                  */
/**/
             IF         COND(&NUM1 *GT &NUMTAP) THEN(GOTO END)
/*/COPY WNCPYSRC,SDC1725005                                          */
             ELSE       SNDPGMMSG MSG('Load next JRNIC tape/diskette   , +
                          then press ENTER, OR enter "C" to cancel')    +
                          TOPGMQ(*EXT) MSGTYPE(*INQ)
/*/COPY WNCPYSRC,SDC1725006                                          */
             RCVMSG     MSG(&MSG) PGMQ(*EXT)
/**/
             IF         COND(&MSG *EQ 'C') THEN(DO)
                SNDPGMMSG  MSG('Restore Journal Receivers  +
                               - CANCELLED')
                CHGJOB SWS(XXXXXX1X)
                GOTO END
             ENDDO
/**/
             GOTO       TAPDKT
/**/
/*   If first receiver restored was not ICRCV001 OR if first receiver */
/*   on new tape/dkte did not follow correct sequence, send error msg */
/**/
CHKRECV2:    CHKOBJ     OBJ(&JLIB/(ICRCV *CAT &NUMA)) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) EXEC(GOTO ERRMSG)
/**/
/*   Correct receiver found - reset error flag and check next one    */
/**/
             CHGVAR     VAR(&RCVNUM) VALUE(&RCVNUM + 1)
             CHGVAR     VAR(&NUMA) VALUE(&RCVNUM)
             CHGVAR     VAR(&FLAG1) VALUE(0)
             GOTO       NEXT
/**/
/*   Incorrect receiver found - send message and end program         */
/**/
ERRMSG:      SNDPGMMSG  MSG('Tapes/diskettes have not been loaded in +
                          the correct order. Press ENTER to end the +
                          program, then reload the first one and +
                          restart') TOPGMQ(*EXT) MSGTYPE(*INQ)
             RCVMSG     PGMQ(*EXT)
/**/
/***ABNOR:*******SNDPGMMSG  MSG('Restore Journal Receivers +          /*RT0138*/
/***********            ENDED ABNORMALLY') TOPGMQ(*EXT) +             /*RT0138*/
/***********            TOMSGQ(MOPERQ MRUNQ)                          /*RT0138*/
ABNOR:                                                                /*RT0138*/
             SNDPGMMSG  MSG('Restore Journal Receivers ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*           RMVRPYLE   SEQNBR(3)                                */   /*E13205*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           */   /*E13205*/
/**/                                                                  /*RT0138*/
/* Call program to show restore fail and prompt for joblog */         /*RT0138*/
/**/                                                                  /*RT0138*/
             CALL       PGM(SCC0020) PARM('SDC1725' 'RESTFAILJ')      /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Call program to show abnormal end and prompt for retry */          /*RT0138*/
/**/                                                                  /*RT0138*/
             CHGVAR     VAR(&RPY) VALUE('R')                          /*RT0138*/
             CALL       PGM(RRC0010) PARM('SDC1725' 'RSTJRCVABN' +
                          &RPY)                                       /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*RT0138*/
/* Retry save if requested else end program                           /*RT0138*/
/**/                                                                  /*RT0138*/
             IF         COND(&RPY = 'R') THEN(DO)                     /*RT0138*/
                SNDPGMMSG  MSG('Restore journal receivers RETRY +
                                ATTEMPT') TOMSGQ(MOPERQ MRUNQ)        /*RT0138*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*RT0138*/
                GOTO       CMDLBL(RETRY)                              /*RT0138*/
             ENDDO                                                    /*RT0138*/
                                                                      /*RT0138*/
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* If 'Auto receiver save period' is non-zero resubmit RRAUTOBKP  */
/**/
END:         IF         COND(%SST(&JNSTAT 106 5) *NE '00000') +
                          THEN(CALL PGM(SDC1760))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
