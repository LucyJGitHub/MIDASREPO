/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Rest all jrn rec from tape to backup')       */
/********************************************************************/
/*                                                                  */
/*        Midas - Restart Recovery Module                           */
/*                                                                  */
/*      SDC1753 - RESTORE ALL JOURNAL RECEIVERS FROM 1 TAPE         */
/*                OR MAGAZINE OF DISKETTES TO BACKUP MACHINE        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                     095590        Date  29MAR96                   */
/*           AMEND NO. S01408        DATE  10MAY95                   */
/*           AMEND NO. S01343        DATE  15AUG91                  */
/*           AMEND NO. RT0138        DATE  24JUN91                  */
/*           AMEND NO. S01194        DATE  21FEB90                  */
/*           AMEND NO. E13205        DATE  13/03/89                 */
/*           AMEND NO. S01179        DATE  13/09/88                 */
/*           AMEND NO. S01173        DATE  30/06/88                 */
/*           AMEND NO. E80904        DATE  20/03/87                 */
/*           AMEND NO. E80903        DATE  16/03/87                 */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*      CSC043 - MidasPlus IASP Enablement                          */
/*      207764 - Change all SAV* and RST* commands to print a       */
/*               report of objects saved or restored.               */
/*      095590 - Monitor for both 'C' and 'c' reply to cancel.      */
/*      S01408 - Addition of core hook SDC1753MP1                   *  *E80903*/
/*      S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*               - SDC01 RENAMED TO SCC01                           */
/*      RT0138 - Abnormal termination should prompt re-try screen   */
/*               so that media errors can be dealt with.            */
/*      S01194 - NEW STANDING DATA                                  * /*S01194*/
/*      E13205 - ASP has a 2 byte identifier                        * /*E13205*/
/*      S01179 - AS400 CONVERSION                                   */
/*      S01173 - USE SPECIFIED ASP FOR JOURNAL/RECIEVER             *  *S01173*/
/*      E80904 - WHEN COMPONENT ON NON - BACKUP SYSTEM IS CALLED    *  *E80904*/
/*               IT INCORRECTLY LEAVES 'RECOVERY' ON DATA AREA      *  *E80904*/
/*               'TSTATUS' WHEN IT IS CANCELLED.                    *  *E80904*/
/*      E80903 - DATA AREA JNSTAT INCORRECTLY HAS A RECEIVER        *  *E80903*/
/*               NUMBER BLANKED ON TERMINATION.                     *  *E80903*/
/*                                                                  */
/********************************************************************/
/******      PGM        PARM(&SDC01 &FLAG)                            /*S01343*/
             PGM        PARM(&SCC01 &FLAG)                            /*S01343*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   Initial processing                                             */
/**/
/******      DCL        VAR(&SDC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&SCC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BKPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCVASP) TYPE(*CHAR) LEN(2)               /*S01173*/
             DCL        VAR(&DEVJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIRST) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEDJ) TYPE(*CHAR) LEN(4)
/***         DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MONIND) TYPE(*LGL) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUMN) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&NUMA) TYPE(*CHAR) LEN(3)
/**********  DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1) VALUE(R)         /*RT0138*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
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
RETRY:                                                                /*RT0138*/
/**/
/*   Check JNSTAT to make sure pgm being run on backup machine      */
/**/
             RTVDTAARA  DTAARA(JNSTAT (82 1)) RTNVAR(&BKPS)
             IF         COND(&BKPS *NE 'B') THEN(DO)
                SNDPGMMSG  MSG('This option can only be run on +
                                the backup machine') +
                                MSGTYPE(*INQ) TOPGMQ(*EXT)
                CHGJOB     SWS(XXXXXX1X)
                CHGDTAARA  DTAARA(TSTATUS) VALUE('        ')          /*E80904*/
                GOTO       END
             ENDDO
/**/
/*   Call SD1753 to output & validate prompt screen for medium      */
/*   and device for restoration or journal receivers                */
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABICD)
             CALL       PGM(SD1753) PARM(&MEDJ &DEVJ &ENDP)
             IF    COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*           IF    COND(&ENDP *EQ '1') THEN(GOTO END) */              /*E80903*/
             IF    COND(&ENDP *EQ '1') THEN(GOTO ENDPGM)              /*E80903*/
/**/
/*/COPY WNCPYSRC,SDC1753001                                          */
             SNDPGMMSG  MSG('Load JRNIC tape/diskette magazine +
                          then press ENTER') MSGTYPE(*INQ) TOPGMQ(*EXT)
/*/COPY WNCPYSRC,SDC1753002                                          */
/*********   RCVMSG     MSG(&MSG) PGMQ(*EXT)*************/            /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&MSG)                       /*095590*/
/**/
/*   Obtain library ID from SDSTAT                                            */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&JLIB)
             CHGVAR     VAR(%SST(&JLIB 3 4)) VALUE('JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1753MP1                                          */
                                                                      /*S01408*/
/**/
/*   Obtain number of first receiver to be restored from JNSTAT               */
/**/
             RTVDTAARA  DTAARA(JNSTAT (6 3)) RTNVAR(&FIRST)
             CHGVAR     VAR(&NUMA) VALUE(&FIRST)
/**/
/*   Check the device is mounted properly                           */
/**/
TAPDKT:      IF         COND(&MEDJ *EQ 'DKTE') THEN(DO)
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
/*********   RCVMSG     MSG(&MSG) PGMQ(*EXT)*************/            /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&MSG)                       /*095590*/
/**/
/********                    IF         COND(&MSG *EQ 'C') THEN(DO)     095590*/
                             IF         COND((&MSG *EQ 'C' ) *or   +
                                            (&MSG *EQ 'c' )) THEN(DO) /*095590*/
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
             IF         COND(&MEDJ *EQ 'TAPE') THEN(DO)
/**/
/*/COPY WNCPYSRC,SDC1753003                                          */
CHECK2:                 CHKTAP     DEV(&DEVJ) VOL(JRNIC)
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available and +
                                             mount volume with ID JRNIC OR +
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
/*/COPY WNCPYSRC,SDC1753004                                          */
                        ENDDO
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*********   RCVMSG     MSG(&MSG) PGMQ(*EXT)*************/            /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&MSG)                       /*095590*/
/**/
/********                    IF         COND(&MSG *EQ 'C') THEN(DO)     095590*/
                             IF         COND((&MSG *EQ 'C' ) *or   +
                                            (&MSG *EQ 'c' )) THEN(DO) /*095590*/
                               SNDPGMMSG  MSG('Restore Journal Receivers  +
                                               - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO END
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK2
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/*   Restore all journal receivers from the tape/diskette           */
/**/
/*   RTVDTAARA  DTAARA(JNSTAT (151 1)) RTNVAR(&RCVASP)  */ /*S01173*/ /*E13205*/
             RTVDTAARA  DTAARA(JNSTAT (151 2)) RTNVAR(&RCVASP)        /*E13205*/
 NEXT:       IF         COND(&MEDJ *EQ 'TAPE') THEN(DO)
/**********     RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
/**********                  OBJTYPE(*JRNRCV) DEV(&DEVJ) VOL(*MOU */  /*S01173*/
/**********  RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +       */       /*S01173*/ /*207764*/
/**********               DEV(&DEVJ) OBJTYPE(*JRNRCV) VOL(*MOUNTED) + */       /*S01173*/ /*207764*/
/**********               RSTASP(&RCVASP)                             */       /*S01173*/ /*207764*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                          DEV(&DEVJ) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                          OUTPUT(*PRINT) RSTASPDEV(&IASP)                                 /*CSC043*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                             DEV(&DEVJ) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                             RSTASP(&RCVASP) OUTPUT(*PRINT)                               /*207764*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)
             ENDDO                                                                        /*CSC043*/
                GOTO CHKRECV2
             ENDDO
/**/
             IF         COND(&MEDJ *EQ 'DKTE') THEN(DO)
/**********     RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
/**********                  OBJTYPE(*JRNRCV) DEV(&DEVJ) LOC(*M1 +
/**********                  *SEARCH) VOL(*MOUNTED)  */               /*S01173*/
/**********  RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +       */       /*S01173*/ /*207764*/
/**********               DEV(&DEVJ) OBJTYPE(*JRNRCV) VOL(*MOUNTED) + */       /*S01173*/ /*207764*/
/**********               RSTASP(&RCVASP)                             */       /*S01173*/ /*207764*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                          DEV(&DEVJ) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                          OUTPUT(*PRINT) RSTASPDEV(&IASP)                                 /*CSC043*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTOBJ     OBJ((ICRCV *CAT &NUMA)) SAVLIB(&JLIB) +
                             DEV(&DEVJ) OBJTYPE(*JRNRCV) VOL(*MOUNTED) +
                             RSTASP(&RCVASP) OUTPUT(*PRINT)                               /*207764*/
                MONMSG     MSGID(CPF3780) EXEC(GOTO CHKRECV1)
             ENDDO                                                                        /*CSC043*/
                GOTO CHKRECV2
             ENDDO
/**/
/*   Check that first receiver restored was ICRCV001 and that all the */
/*   subsequent receivers have been restored in the correct sequence  */
/**/
CHKRECV1:    IF         COND(&NUMA *EQ &FIRST) THEN(GOTO ERRMSG)
             ELSE       GOTO END
/**/
             GOTO       NEXT
/**/
/*   If first receiver restored was not ICRCV001 OR if first receiver */
/*   on new tape/dkte did not follow correct sequence, send error msg */
/**/
CHKRECV2:    CHKOBJ     OBJ(&JLIB/(ICRCV *CAT &NUMA)) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) EXEC(GOTO ERRMSG)
/**/
/*   Correct receiver found - restore and check next one             */
/**/
             CHGVAR     VAR(&NUMN) VALUE(&NUMA)
             CHGVAR     VAR(&NUMN) VALUE(&NUMN + 1)
             CHGVAR     VAR(&NUMA) VALUE(&NUMN)
             GOTO       NEXT
/**/
/*   Incorrect receiver found - send message and end program         */
/**/
 ERRMSG:     SNDPGMMSG  MSG('The wrong tape/diskette has been loaded. +
                          Press ENTER to end the program, then load +
                          the correct tape/diskette') TOPGMQ(*EXT) +
                          MSGTYPE(*INQ)
             RCVMSG     PGMQ(*EXT)
             GOTO       ABNOR
/**/
/*   Database error processing                                       */
/**/
/* DBERR: ** RCVDTAARA  DTAARA(LDA) *********************************  *S01179*/
DBERR:       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/***         CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01194*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ) +
             TOPGMQ(*EXT)
/**/
/***ABNOR:       SNDPGMMSG  MSG('Restore Journal Receivers +          /*RT0138*/
/***********            ENDED ABNORMALLY') TOPGMQ(*EXT) +             /*RT0138*/
/***********            TOMSGQ(MOPERQ MRUNQ)                          /*RT0138*/
ABNOR:                                                                /*RT0138*/
             SNDPGMMSG  MSG('Restore Journal Receivers ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*RT0138*/
/* Call program to show restore fail and prompt for joblog */         /*RT0138*/
/**/                                                                  /*RT0138*/
             CALL       PGM(SCC0020) PARM('SDC1753' 'RESTFAILJ')      /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Call program to show abnormal end and prompt for retry */          /*RT0138*/
/**/                                                                  /*RT0138*/
             CHGVAR     VAR(&RPY) VALUE('R')                          /*RT0138*/
             CALL       PGM(RRC0010) PARM('SDC1753' 'RSTJRCVABN' +
                          &RPY)                                       /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Retry save if requested else end program                           /*RT0138*/
/**/                                                                  /*RT0138*/
             IF         COND(&RPY = 'R') THEN(DO)                     /*RT0138*/
                SNDPGMMSG  MSG('Restore Journal Receivers +
                                RETRY ATTEMPT') TOMSGQ(MOPERQ MRUNQ)  /*RT0138*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*RT0138*/
                GOTO       CMDLBL(RETRY)                              /*RT0138*/
             ENDDO                                                    /*RT0138*/
                                                                      /*RT0138*/
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO       ENDPGM
/**/
 END:        CHGDTAARA  DTAARA(JNSTAT (6 3)) VALUE(&NUMA)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
