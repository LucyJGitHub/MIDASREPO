/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Restore next receivers in sequence')         */
/********************************************************************/
/*                                                                  */
/*        Midas - Restart Recovery Module                           */
/*                                                                  */
/*       SDC1726 RESTORE RECEIVERS IN SEQUENCE                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 207764            Date 23Jul02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408            Date  10MAY95              */
/*                      S01343            Date  15AUG91              */
/*                      RT0138            DATE  21JUN91             */
/*                      S01179            DATE  13/09/88            */
/*                      S01173            DATE  30/06/88            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CSC043 - MidasPlus IASP Enablement                         */
/*       207764 - Change all SAV* and RST* commands to print a      */
/*                report of objects saved or restored.              */
/*       S01408 - Addition of core hook SDC1726INT                  */
/*              - Addition of core hook SDC1726MP1                  */
/*              - Addition of core hook SDC1726MP2                  */
/*              - Addition of core hook SDC1726MP3                  */
/*              - Addition of core hook SDC1726MP4                  */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - SDC1716 RENAMED TO SCC1716.                     */
/*       RT0138 - Abnormal termination should prompt re-try screen  */
/*                so that media errors can be dealt with.           */
/*       S01179 - AS400 CONVERSION                                  */
/*       S01173 - USE SPECIFIED ASP FOR JOURNAL/RECEIVERS           */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           DECLARE DATA AREA AND VARIABLES                         */
/**/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
             DCL        VAR(&CAR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CARX) TYPE(*DEC) LEN(10)
             DCL        VAR(&DEVI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1726INT                                          */
                                                                      /*S01408*/
             DCL        VAR(&MONIND) TYPE(*LGL) LEN(1)
             DCL        VAR(&PARM) TYPE(*DEC) LEN(1)
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCV) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1) VALUE(R)         /*RT0138*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/*/COPY WNCPYSRC,SDC1726003                                          */
/**/
/*           GLOBAL MONITOR MESSAGE                                  */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  TOPGMQ(*EXT) MSG('Restore receivers in +
                        sequence executing')
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
/**/
RETRY:                                                                /*RT0138*/
             IF         COND(%SST(&RCV 6 3) = 'ALL') THEN(DO)
                CHGVAR     VAR(&RCV) VALUE(ICRCV999)
             ENDDO
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
             CHGVAR     VAR(&CAR) VALUE(%SST(&JNSTAT 1 10))
/**/
LOOP:        IF         COND(&CAR *GT %SST(&RCV 6 3)) THEN(GOTO END)
/**/
             RTVDTAARA  DTAARA(JNSTAT (21 4)) RTNVAR(&SAVD)
             RTVDTAARA  DTAARA(JNSTAT (25 10)) RTNVAR(&DEVI)
/**/
             IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
 CHECK1:     CHKDKT     DEV(DKT01) VOL(JRNIC)
/**/
             MONMSG     MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Diskette not found. Mount the +
                                             correct diskette and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6164) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to read diskette due to +
                                             surface defect. Mount another +
                                             diskette and retry OR enter "C" +
                                             to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG     MSG(&RMSG) PGMQ(*EXT)
/**/
                             IF         COND(&RMSG *EQ 'C') THEN(DO)
                               SNDPGMMSG  MSG('Restore Receivers in Sequence +
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
 
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/*/COPY WNCPYSRC,SDC1726001                                          */
CHECK2:                 CHKTAP     DEV(&DEVI) VOL(JRNIC)
/*/COPY WNCPYSRC,SDC1726002                                          */
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6720) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Incorrect volume found on device. +
                                             Mount the correct volume and +
                                             retry OR enter "C" to cancel and +
                                             end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6760) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not ready. Mount volume on +
                                             device, press START and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6772) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Cannot process mounted vol.Clean +
                                             tape path & heads,& retry OR +
                                             enter"C"to cancel program.If +
                                             problem recurs,mount another vol +
                                             & retry.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF9814) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not found. Mount the +
                                             correct device and retry OR enter +
                                             "C" to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/*/COPY WNCPYSRC,SDC1726004                                          */
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG     MSG(&RMSG) PGMQ(*EXT)
/**/
                             IF         COND(&RMSG *EQ 'C') THEN(DO)
                               SNDPGMMSG  MSG('Restore Receivers in Sequence +
                                               - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO END
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
/*/COPY WNCPYSRC,SDC1726005                                          */
                               GOTO CHECK2
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/******      CALL       PGM(SDC1716) PARM(&PARM)                      /*S01343*/
             CALL       PGM(SCC1716) PARM(&PARM)                      /*S01343*/
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
             DLTJRNRCV  JRNRCV(&CAR)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1726MP1                                          */
                                                                      /*S01408*/
/**********  RSTOBJ     OBJ(&CAR) SAVLIB(&LIBID *TCAT 'JLIB') +
/**********               VOL(*MOUNTED) */                            /*S01173*/
/**********  RSTOBJ     OBJ(&CAR) SAVLIB(&LIBID *TCAT 'JLIB') + */             /*S01173*/ /*207764*/
/**********               DEV(TAP01) VOL(*MOUNTED) +            */             /*S01173*/ /*207764*/
/**********               RSTASP(%SST(&JNSTAT 151 2))           */             /*S01173*/ /*207764*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             RSTOBJ     OBJ(&CAR) SAVLIB((&LIBID *TCAT 'JLIB')) +
                          DEV(TAP01) VOL(*MOUNTED) OUTPUT(*PRINT) +
                          RSTASPDEV(&IASP)                                                /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             RSTOBJ     OBJ(&CAR) SAVLIB(&LIBID *TCAT 'JLIB') +
                          DEV(TAP01) VOL(*MOUNTED) +
                          RSTASP(%SST(&JNSTAT 151 2)) OUTPUT(*PRINT)                      /*207764*/
             ENDDO                                                                        /*CSC043*/
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1726MP2                                          */
                                                                      /*S01408*/
             RTVDTAARA  DTAARA(JNSTAT (68 1)) RTNVAR(&DRV)
             IF         COND(&DRV *EQ 'N') THEN(GOTO LOOP)
/**/
             ELSE
/**/
                CHGVAR     VAR(&CAR) VALUE(%SST(&CAR 6 3))
                CHGVAR     VAR(&CARX) VALUE(&CAR)
                CHGVAR     VAR(&CARX) VALUE(&CARX + 1)
                CHGVAR     VAR(&CAR) VALUE(&CARX)
                DLTJRNRCV  JRNRCV(&CAR)
/*           RSTOBJ     OBJ(&CAR) SAVLIB(&LIBID *TCAT 'JLIB') +
                          VOL(*MOUNTED) */                            /*S01173*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1726MP3                                          */
                                                                      /*S01408*/
/**********  RSTOBJ     OBJ(&CAR) SAVLIB(&LIBID *TCAT 'JLIB') + */             /*S01173*/ /*207764*/
/**********               DEV(TAP01) VOL(*MOUNTED) +            */             /*S01173*/ /*207764*/
/**********               RSTASP(%SST(&JNSTAT 151 2))           */             /*S01173*/ /*207764*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             RSTOBJ     OBJ(&CAR) SAVLIB((&LIBID *TCAT 'JLIB')) +
                          DEV(TAP01) VOL(*MOUNTED) OUTPUT(*PRINT) +
                          RSTASPDEV(&IASP)                                                /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             RSTOBJ     OBJ(&CAR) SAVLIB(&LIBID *TCAT 'JLIB') +
                          DEV(TAP01) VOL(*MOUNTED) +
                          RSTASP(%SST(&JNSTAT 151 2)) OUTPUT(*PRINT)                      /*207764*/
             ENDDO                                                                        /*CSC043*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1726MP4                                          */
                                                                      /*S01408*/
                CHGDTAARA  DTAARA(%SST(&JNSTAT 1 10)) VALUE(&CAR)
                GOTO LOOP
/**/
/*           GLOBAL MONITOR MESSAGE PROCESSING                                */
/**/
/***ABNOR:*******SNDPGMMSG  TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT) +       /*RT0138*/
/***********              MSG('PROGRAM - Restore Next Receivers in +  /*RT0138*/
/***********                  SEQUENCE - ENDED ABNORMALLY')           /*RT0138*/
ABNOR:                                                                /*RT0138*/
             SNDPGMMSG  MSG('PROGRAM - Restore Next Receivers in +
                          Sequence - ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*RT0138*/
/* Call program to show restore fail and prompt for joblog */         /*RT0138*/
/**/                                                                  /*RT0138*/
             CALL       PGM(SCC0020) PARM('SDC1726' 'RESTFAILJ')      /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Call program to show abnormal end and prompt for retry */          /*RT0138*/
/**/                                                                  /*RT0138*/
             CHGVAR     VAR(&RPY) VALUE('R')                          /*RT0138*/
             CALL       PGM(RRC0010) PARM('SDC1726' 'RSTNRCVABN' +
                          &RPY)                                       /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Retry save if requested else end program                           /*RT0138*/
/**/                                                                  /*RT0138*/
             IF         COND(&RPY = 'R') THEN(DO)                     /*RT0138*/
                SNDPGMMSG  MSG('Restore next receivers in sequence +
                             RETRY ATTEMPT') TOMSGQ(MOPERQ MRUNQ)     /*RT0138*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*RT0138*/
                GOTO       CMDLBL(RETRY)                              /*RT0138*/
             ENDDO                                                    /*RT0138*/
                                                                      /*RT0138*/
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
