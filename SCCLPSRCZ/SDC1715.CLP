/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Save journal receivers')                     */
/********************************************************************/
/*                                                                  */
/*  Midas - System Control Module                                   */
/*                                                                  */
/*  SDC1715 SAVE JOURNAL RECEIVERS                                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CSC039             Date 18Aug08             */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                    207764             Date 23Jul02                */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                    192731             Date 11Jul01                */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    CTI001             Date 01Sep97               */
/*                    S01408             Date 07Aug96               */
/*                    S01408             DATE 11APR96               */
/*                    S01408             DATE 04AUG95               */
/*                    S01495             DATE 01OCT94               */
/*                    E29436             DATE 11OCT91               */
/*                    S01343             DATE 15AUG91               */
/*                    E24015             DATE 16JUL91               */
/*                    RT0138             DATE 07JUN91               */
/*                    RT0165             DATE 07JUN91               */
/*                    S01179             DATE 13/09/88              */
/*                    E10299             DATE 27/06/87              */
/*                    E10752             DATE 02/06/87              */
/*                    E10134             DATE 08/04/87              */
/*                    E10145             DATE 08/04/87              */
/*                    E81178             DATE 04/03/87              */
/*                    E81140             DATE 19/08/86              */
/*                    E80978             DATE 15/08/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       CSC039  - Include parameter DTACPR in save commands to     */
/*                 reduce run time.                                 */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*     207764 - Change all SAV* and RST* commands to print a        */
/*              report of objects saved or restored.                */
/*     192731  -  Change SAVOBJ cmd to have USEOPTBLK *NO           */
/*                instead of *YES                                   */
/*     CTI001  -  Midas / Trade Innovation Interface Phase 1        */
/*     S01408  -  Core hook added, SDC1715011                       */
/*                Core hook added, SDC1715010                       */
/*                Core hook added, SDC1715009                       */
/*                Core hook added, SDC1715008                       */
/*                Core hook added, SDC1715007                       */
/*                Core hook added, SDC1715006                       */
/*     S01408  -  Core hook added, SDC1715INT                       */
/*                Core hook added, SDC1715ERR                       */
/*                Core hook added, SDC1715END                       */
/*                Core hook added, SDC1715005                       */
/*                Core hook added, SDC1715004                       */
/*     S01408  -  Core hook added, SDC1715001                       */
/*                Core hook added, SDC1715002                       */
/*                Core hook added, SDC1715003                       */
/*     S01495  -  COB enhancements.                                 */
/*     E29436  -  MOVE TO SCCLSRC FROM RR.                          */
/*     S01343  -  SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - AUTOBKP RENAMED TO RRAUTOBKP.                   */
/*                - CHKAUTO RENAMED TO RRCHKAUTO.                   */
/*                - SDC1716 RENAMED TO SCC1716.                     */
/*     E24015  -  SAVOBJ COMMAND SPECIFIES *MOUNTED WHICH CAN       */
/*                CAUSE BACKUPS TO BE PERFORMED TO THE WRONG        */
/*                VOLUME ID.                                        */
/*     RT0138  -  Program should allow the user to re-try the save, */
/*                if an error occurs, instead of immediately        */
/*                re-opening input cycle.                           */
/*                (This fix is closely linked with RT0165)          */
/*     RT0165  -  Messages should be sent via new Midas Info Screen.*/
/*     S01179  -  AS400 CONVERSION                                  */
/*     E10299  -  SHOULD NOT SUBMIT THE RRAUTOBKP JOB IF RUNNING IN *  *E10299*/
/*                I/C TERMINATION.                                  *  *E10299*/
/*     E10752  -  AUTOBACKUP JOB SHOULD BE CANCELLED WITH           *  *E10752*/
/*                SPLFILE(*YES)                                     *  *E10752*/
/*     E10134  -  WHEN THE SAVE DEVICE IS NEITHER TAPE NOR DISKETTE *  *E10134*/
/*                THE RESULTING PROGRAM MESSAGE IS NOT SENT TO A    *  *E10134*/
/*                VALID MESSAGE QUEUE CAUSING THE PROGRAM TO END    *  *E10134*/
/*                ABNORMALLY.                                       *  *E10134*/
/*     E10145  -  THE REPLY TO PROGRAM MESSAGES DOES NOT ALLOW FOR  *  *E10145*/
/*                A LOWER CASE LETTER.                              *  *E10145*/
/*     E81178  -  MESSAGES SENT TO PROGRAM MESSAGE QUEUE *EXT ARE   *  *E81178*/
/*                BEING TRUNCATED TO LESS THAN 80 CHARACTERS        *  *E81178*/
/*     E81140  -  PROGRAM LOOPS IF RRAUTOBKP JOB HAS BEEN CANCELLED */
/*                BUT JNSTAT POS 69 IS STILL SET TO 'Y'             */
/*     E80978  -  MONMSG CPF1362 AFTER CANCELLING AUTO BACKUP       */
/*                JOB IN CASE JOB NO LONGER EXISTS IN THE SYSTEM    */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PARM)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715INT                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*  Initial Processing */
/**/
             DCL        VAR(&AUTO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132) **/           /*RT0138*/
             DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)               /*S01495*/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DEVI) TYPE(*CHAR) LEN(10)
/************DCL********VAR(&FSAV)*TYPE(*DEC)*LEN(3)****************************************CSC020*/
             DCL        VAR(&FSAV) TYPE(*DEC) LEN(8)                                      /*CSC020*/
/************DCL********VAR(&CFSAV)*TYPE(*CHAR)*LEN(3)**************************************CSC020*/
             DCL        VAR(&CFSAV) TYPE(*CHAR) LEN(8)                                    /*CSC020*/
/************DCL********VAR(&LSAV)*TYPE(*DEC)*LEN(3)****************************************CSC020*/
             DCL        VAR(&LSAV) TYPE(*DEC) LEN(8)                                      /*CSC020*/
/************DCL********VAR(&CLSAV)*TYPE(*CHAR)*LEN(3)**************************************CSC020*/
             DCL        VAR(&CLSAV) TYPE(*CHAR) LEN(8)                                    /*CSC020*/
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PGMQ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MSGQ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CNL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSIP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MONIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CTI001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST') /*CTI001*/
             DCL        VAR(&AOMMOD) TYPE(*CHAR) LEN(200)             /*CTI001*/
/**/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/**********  DCLDTAARA  DTAARA(MPHAS)                               *  *S01179*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01179*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC039*/
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)                                 /*CSC039*/
             DCL        VAR(&CPf3790) TYPE(*CHAR) LEN(1)                                  /*CSC039*/
             DCL        VAR(&CSTAT) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/*/COPY WNCPYSRC,SDC1715029                                          */
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/************SNDPGMMSG  MSG('Save Journal Receivers') +            */ /*S01495*/
/************           TOMSGQ(MRUNQ)                              */ /*S01495*/
/*/COPY WNCPYSRC,SCH00033                                            */
/**/                                                                  /*CTI001*/
/* Call AOMMODR0 to retrieve Midas/TI Interface switch status */      /*CTI001*/
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
/**/
/* Determine Destination of Program Messages */
/**/
             IF         COND(&PARM *EQ '0') THEN(DO)
                CHGVAR     VAR(&PGMQ) VALUE('*EXT')
                CHGVAR     VAR(&MSGQ) VALUE('*TOPGMQ')
             ENDDO
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715004                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/* Check JNSTAT to see if RRAUTOBKP is running */
/**/
             IF         COND(&PARM *EQ '0') THEN(DO)
                RTVDTAARA  DTAARA(JNSTAT (111 10)) RTNVAR(&AUTO)
                IF         COND(&AUTO *NE '          ') THEN(DO)
                   CALL       PGM(RRCHKAUTO)                          /*E81140*/
                   IF COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNOR)        /*E81140*/
/**/
/* If RRAUTOBKP is running, wait until the current receiver save has */
/* finished then cancel it                                           */
/**/
 RTV:              RTVDTAARA  DTAARA(JNSTAT (69 1)) RTNVAR(&RSIP)
                   IF         COND(&RSIP *EQ 'Y') THEN(GOTO RTV)
/****************  RCVDTAARA  DTAARA(JNSTAT)                        *  *S01179*/
                   RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)          /*S01179*/
/**/
                   CHGVAR     VAR(&JOBN) VALUE(%SST(&JNSTAT 111 10))
                   CHGVAR     VAR(&USRN) VALUE(%SST(&JNSTAT 121 10))
                   CHGVAR     VAR(&JBNB) VALUE(%SST(&JNSTAT 131 6))
/*                                                                    /*E10752*/
/*                 CNLJOB     JOB(&JOBN.&USRN.&JBNB) OPTION(*IMMED) */
                   ENDJOB     JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED) +
                              SPLFILE(*YES)
/*                                                                    /*E10752*/
/******************MONMSG*****MSGID(CPF1321)*************************  *E80978*/
                   MONMSG     MSGID(CPF1321 CPF1362)                  /*E80978*/
                   CHGDTAARA  DTAARA(JNSTAT (111 26)) +
                                VALUE('                          ')
                ENDDO
/**/
             ENDDO
/**/
/* If program has been called as part of RRAUTOBKP wait until current*/
/* receiver save has finished before continuing                      */
/**/
/*/COPY WNCPYSRC,SDC1715012                                          */
 RCV:        IF         COND(&PARM *EQ '1') THEN(DO)
/*/COPY WNCPYSRC,SDC1715013                                          */
/*************  RCVDTAARA  DTAARA(JNSTAT)                           *  *S01179*/
                RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)             /*S01179*/
                IF         COND(%SST(&JNSTAT 69 1) *EQ 'Y') +
                           THEN(GOTO RCV)
             ENDDO
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('Y')
/**/
/* If Midas/TI Interface on and MPHAS 'A' then stop SD replication */ /*CTI001*/
/**/                                                                  /*CTI001*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*CTI001*/
/**********  IF         COND((%SST(&AOMMOD 103 1) *EQ 'Y') & (&MPHAS +                 */ /*CCB020*/
/**********               *EQ 'A')) THEN(DO)                                    */ /*CTI001 CCB020*/
             IF         COND((%SST(&AOMMOD 103 1) *EQ 'Y') & (&MPHAS +
                          *EQ 'A') *OR (%SST(&AOMMOD 103 1) *EQ 'Y') +
                          & (&MPHAS *EQ 'G')) THEN(DO)                                    /*CCB020*/
             CALL       PGM(TIC0030) PARM('STOP' 'SDC1715')           /*CTI001*/
             ENDDO                                                    /*CTI001*/
/**/                                                                  /*CTI001*/
/* Check next receiver to be saved. Send warning message and cancel  */
/* RRAUTOBKP if it is 240.                                           */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/************CHGVAR*****VAR(&FSAV)*VALUE(%SST(&JNSTAT*16*3))********************************CSC020*/
             CHGVAR     VAR(&FSAV) VALUE(%SST(&JNSTAT 13 8))                              /*CSC020*/
/**/
/************IF*********COND(&FSAV**EQ*240)*THEN(DO)****************************************CSC020*/
/***************SNDPGMMSG**MSG('WARNING*-*Journal*receiver*no.*240*is*+*********************CSC020*/
/****************************being*saved.*You*have*only*16*receivers*+**********************CSC020*/
/****************************left*for*use*today.*RRAUTOBKP*is*being*+***********************CSC020*/
/****************************cancelled.')*TOMSGQ(MOPERQ)************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/**/
/* Check current receiver. If it is 256, then no more saves can be   */
/* done today. Send message and end program                          */
/**/
/************CHGVAR*****VAR(&LSAV)*VALUE(%SST(&JNSTAT*6*3))*********************************CSC020*/
             CHGVAR     VAR(&LSAV) VALUE(%SST(&JNSTAT 3 8))                               /*CSC020*/
/**/
/************IF*********COND(&LSAV**EQ*256)*THEN(DO)****************************************CSC020*/
/***************SNDPGMMSG**MSG('Currently*attached*receiver*is*no.*+************************CSC020*/
/****************************256.*No*more*receiver*saves*can*be*done*+**********************CSC020*/
/****************************today.')*TOMSGQ(MOPERQ)****************************************CSC020*/
/***************GOTO*END********************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
RETRY:                                                                /*RT0138*/
/**/
/* Obtain media and device for receiver save from JNSTAT */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
             CHGVAR     VAR(&SAVD) VALUE(%SST(&JNSTAT 21 4))
             CHGVAR     VAR(&DEVI) VALUE(%SST(&JNSTAT 25 10))
/**/
/* INTERACTIVE PROCESSING - Check required diskette/tape is loaded */
/**/
/*/COPY WNCPYSRC,SDC1715031                                          */
             IF         COND(&PARM *EQ '0') THEN(DO)
             CHGVAR     VAR(&CNL) VALUE('R')                          /*RT0138*/
CHECK:       IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
             CHKDKT     DEV(DKT01) VOL(JRNIC)
/**/
             MONMSG MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
             SNDPGMMSG  MSG('Diskette with volume ID JRNIC not found.') +
                          TOMSGQ(MOPERQ)                              /*S01495*/
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************    CHGVAR     VAR(&MONIND) VALUE('1')                */ /*S01495*/
/*********SNDPGMMSG  MSG('Diskette with volume ID JRNIC not found. +*/
/*************************Mount the correct diskette and retry OR +**/
/*******************enter "C" to cancel request and end program.') +*/
/*************************TOPGMQ(&PGMQ)  TOMSGQ(&MSGQ) MSGTYPE(*INQ)*  *E81178*/
/************SNDPGMMSG  MSG('Diskette vol ID JRNIC not found.Retry OR +
/************             enter "C" to cancel program.') +
/************          TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) MSGTYPE(*INQ) E81178 RT0165*/
/************    CHGVAR     VAR(&CNL) VALUE('R')            */ /*RT0165 S01495*/
/************    CALL   PGM(RRC0010) PARM('SDC1715' 'DKTJNOTFND' + */ /*S01495*/
/************                 &CNL)                         */ /*RT0165 S01495*/
             ENDDO
/**/
                MONMSG     MSGID(CPF6164) EXEC(DO)
             SNDPGMMSG  MSG('Unable to read diskette due to surface  +
                          defect') TOMSGQ(MOPERQ)                     /*S01495*/
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')              */ /*S01495*/
/***********SNDPGMMSG  MSG('Unable to read diskette due to surface +*/
/**********************defect. Mount another diskette and retry OR +*/
/*************************enter "C" to cancel and end program.') +***/
/*************************TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) +**************/
/*************************MSGTYPE(*INQ)******************************  *E81178*/
/************SNDPGMMSG  MSG('Faulty diskette, try another one OR +
/************             enter "C" to cancel and end program.') +
/************          TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) MSGTYPE(*INQ) E81178 RT0165*/
/************     CHGVAR     VAR(&CNL) VALUE('R')           */ /*RT0165 S01495*/
/************     CALL       PGM(RRC0010) PARM('SDC1715' 'CANTREADDK' +
/************                  &CNL)                        */ /*RT0165 S01495*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
                IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715006                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                   CHKTAP     DEV(&DEVI) VOL(JRNIC)
/*/COPY WNCPYSRC,SDC1715018                                          */
/**/
                   MONMSG     MSGID(CPF6718) EXEC(DO)
             SNDPGMMSG  MSG('Unable to allocate device') +
                          TOMSGQ(MOPERQ)                              /*S01495*/
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')              */ /*S01495*/
/************SNDPGMMSG  MSG('Unable to allocate device. Retry if +***/
/*************************device becomes available and mount +*******/
/*************************volume with ID JRNIC OR enter "C" to +*****/
/*************************cancel and end program.') TOPGMQ(&PGMQ) +**/
/*************************TOMSGQ(&MSGQ) MSGTYPE(*INQ)****************  *E81178*/
/************SNDPGMMSG  MSG('Device unavailable, check and retry OR +
/************             enter "C" to cancel and end program.') +
/************    TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) MSGTYPE(*INQ)       E81178 RT0165*/
/************         CHGVAR     VAR(&CNL) VALUE('R')       */ /*RT0165 S01495*/
/************         CALL       PGM(RRC0010) PARM('SDC1715' +     */ /*S01495*/
/************                      'CANTALCDEV' &CNL)       */ /*RT0165 S01495*/
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF6720) EXEC(DO)
/*/COPY WNCPYSRC,SDC1715019                                          */
             SNDPGMMSG  MSG('Tape with volume ID JRNIC not found') +
                          TOMSGQ(MOPERQ)                              /*S01495*/
/*/COPY WNCPYSRC,SDC1715020                                          */
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')              */ /*S01495*/
/*******SNDPGMMSG  MSG('Tape with volume ID JRNIC not found. Mount +*/
/************************the correct volume and retry OR enter "C" +*/
/***********************to cancel and end program.') TOPGMQ(&PGMQ) +*/
/*************************TOMSGQ(&MSGQ) MSGTYPE(*INQ)****************  *E81178*/
/************SNDPGMMSG  MSG('Tape with volume ID JRNIC not found. +
/************             Retry OR enter "C" to cancel program.') +
/************      TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) MSGTYPE(*INQ)     E81178 RT0165*/
/************         CHGVAR     VAR(&CNL) VALUE('R')       */ /*RT0165 S01495*/
/************         CALL       PGM(RRC0010) PARM('SDC1715' +     */ /*S01495*/
/************                      'TAPJNOTFND' &CNL)       */ /*RT0165 S01495*/
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF6760) EXEC(DO)
/*/COPY WNCPYSRC,SDC1715021                                          */
             SNDPGMMSG  MSG('Device not ready. Mount volume with  +
                          ID JRNIC on the device') TOMSGQ(MOPERQ)     /*S01495*/
/*/COPY WNCPYSRC,SDC1715022                                          */
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')              */ /*S01495*/
/************SNDPGMMSG  MSG('Device not ready. Mount volume +********/
/*************************with ID JRNIC on the +*********************/
/***********************device, press START and retry OR enter "C" +*/
/***********************to cancel and end program.') TOPGMQ(&PGMQ) +*/
/*************************TOMSGQ(&MSGQ) MSGTYPE(*INQ)****************  *E81178*/
/************SNDPGMMSG  MSG('Device not ready.Mount ID JRNIC,press +
/************             START & retry OR enter "C" to cancel.') +
/************          TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) MSGTYPE(*INQ) E81178 RT0165*/
/************         CHGVAR     VAR(&CNL) VALUE('R')       */ /*RT0165 S01495*/
/************         CALL       PGM(RRC0010) PARM('SDC1715' +     */ /*S01495*/
/************                      'DEVNOTREDY' &CNL)       */ /*RT0165 S01495*/
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF6772) EXEC(DO)
             SNDPGMMSG  MSG('Cannot process mounted vol. Clean  +
                          device/try diff.vol') TOMSGQ(MOPERQ)        /*S01495*/
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')              */ /*S01495*/
/************SNDPGMMSG  MSG('Cannot process mounted vol.Clean tape +*/
/************************path & heads,& retry OR enter"C"to cancel +*/
/**********************program.If problem recurs,mount another vol +*/
/*************************& retry.') TOPGMQ(&PGMQ) +*****************/
/*************************TOMSGQ(&MSGQ) MSGTYPE(*INQ)****************  *E81178*/
/************SNDPGMMSG  MSG('Cannot process vol.Clean device/+
/************              try diff.vol & retry OR "C" to cancel.') +
/************             TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) +
/************             MSGTYPE(*INQ)                          E81178 RT0165*/
/************         CHGVAR     VAR(&CNL) VALUE('R')       */ /*RT0165 S01495*/
/************         CALL       PGM(RRC0010) PARM('SDC1715' +     */ /*S01495*/
/************                      'CANTREADTP' &CNL)                 /*RT0165*/
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF9814) EXEC(DO)
/*/COPY WNCPYSRC,SDC1715027                                          */
             SNDPGMMSG  MSG('Device not found. Mount volume with ID JRNIC +
                          on the correct device') TOMSGQ(MOPERQ)      /*S01495*/
/*/COPY WNCPYSRC,SDC1715028                                          */
             GOTO       CMDLBL(ABNOR)                                 /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')              */ /*S01495*/
/************SNDPGMMSG  MSG('Device not found. Mount volume with +***/
/*************************ID JRNIC on the correct +******************/
/**********************device and retry OR enter "C" to cancel and +*/
/*************************end program.') TOPGMQ(&PGMQ) +*************/
/*************************TOMSGQ(&MSGQ) MSGTYPE(*INQ)****************  *E81178*/
/************SNDPGMMSG  MSG('Device not found.Mount ID JRNIC on +
/************         correct device & retry OR "C" to cancel.') +
/************         TOPGMQ(&PGMQ) TOMSGQ(&MSGQ) +
/************             MSGTYPE(*INQ)                          E81178 RT0165*/
/************         CHGVAR     VAR(&CNL) VALUE('R')       */ /*RT0165 S01495*/
/************         CALL       PGM(RRC0010) PARM('SDC1715' +     */ /*S01495*/
/************                      'DEVNOTFND' &CNL)        */ /*RT0165 S01495*/
/**/
                   ENDDO
/*/COPY WNCPYSRC,SDC1715039                                          */
/**/
                ENDDO
/**/
/**If invalid device name entered, send message and end program */
/**/
                ELSE       CMD(DO)
/**/
/******************CHGVAR     VAR(&SMSG) VALUE('Save device for "Save +
/******************     Journal Receivers" is not "TAPE" or "DKTE".') /*RT0138*/
/***************SNDPGMMSG  MSG(&SMSG) TOPGMQ(&PGMQ) TOMSGQ(&MSGQ +***/
/********************************MRUNQ)******************************  *E10134*/
/***************SNDPGMMSG MSG(&SMSG) TOPGMQ(&PGMQ) TOMSGQ(MRUNQ) E10134 RT0138*/
/***********       CHGJOB     SWS(XXXXXX1X)                           /*RT0138*/
/***********       GOTO       CMDLBL(END)                             /*RT0138*/
                   CHGVAR     VAR(&SMSG) VALUE('Save device for "Save +
                        Journal Receivers" is not "TAPE" or "DKTE".') /*S01495*/
                   SNDPGMMSG MSG(&SMSG) TOMSGQ(MOPERQ)                /*S01495*/
                   GOTO       CMDLBL(ABNOR)                           /*S01495*/
/************      CHGVAR     VAR(&MONIND) VALUE('1')       */ /*RT0138 S01495*/
/************      CHGVAR     VAR(&CNL) VALUE('R')          */ /*RT0165 S01495*/
/************      CALL       PGM(RRC0010) PARM('SDC1715' +        */ /*S01495*/
/************                   'NOTTAPDKT' &CNL)           */ /*RT0138 S01495*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             ENDDO
/**/
             ELSE DO
/**/
/* BATCH PROCESSING - Check required diskette/tape is loaded */
/**/
CHECK1:      IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
             CHKDKT     DEV(DKT01) VOL(JRNIC)
/**/
             MONMSG     MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
                 CHGVAR     VAR(&MONIND) VALUE('1')
             SNDPGMMSG  MSG('Diskette with volume ID JRNIC not found. +
                          Enter "C" to cancel program, OR mount JRNIC +
                          and enter any other character to continue.') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)
/**/
                ENDDO
/**/
                MONMSG     MSGID(CPF6164) EXEC(DO)
                   CHGVAR     VAR(&MONIND) VALUE('1')
             SNDPGMMSG  MSG('Unable to read diskette due to surface +
                          defect. Mount another diskette and retry OR +
                          enter "C" to cancel and end program.') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE DO
/**/
                IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/*/COPY WNCPYSRC,SDC1715023                                          */
                   CHKTAP     DEV(&DEVI) VOL(JRNIC)
/*/COPY WNCPYSRC,SDC1715024                                          */
/**/
                   MONMSG     MSGID(CPF6718) EXEC(DO)
                   CHGVAR     VAR(&MONIND) VALUE('1')
/*/COPY WNCPYSRC,SDC1715025                                          */
             SNDPGMMSG  MSG('Unable to allocate device. Retry if +
                          device becomes available and mount volume +
                          with ID JRNIC OR enter "C" to +
                          cancel and end program.') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF6720) EXEC(DO)
                   CHGVAR     VAR(&MONIND) VALUE('1')
             SNDPGMMSG  MSG('Tape with volume ID JRNIC not found. +
                          Enter "C" to cancel program, OR mount JRNIC +
                          and enter any other character to continue.') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF6760) EXEC(DO)
                   CHGVAR     VAR(&MONIND) VALUE('1')
             SNDPGMMSG  MSG('Device not ready. Mount volume with +
                          ID JRNIC on the +
                          device, press START and retry OR enter "C" +
                          to cancel and end program.') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF6772) EXEC(DO)
                   CHGVAR     VAR(&MONIND) VALUE('1')
             SNDPGMMSG  MSG('Cannot process mounted vol.Clean tape +
                          path & heads,& retry OR enter"C"to cancel +
                          program.If problem recurs,mount another vol +
                          & retry.') TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)
/**/
                   ENDDO
/**/
                   MONMSG     MSGID(CPF9814) EXEC(DO)
                   CHGVAR     VAR(&MONIND) VALUE('1')
             SNDPGMMSG  MSG('Device not found. Mount volume with +
                          ID JRNIC on the correct +
                          device and retry OR enter "C" to cancel and +
                          end program.') TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)
/*/COPY WNCPYSRC,SDC1715026                                          */
/**/
                   ENDDO
/**/
/*/COPY WNCPYSRC,SDC1715030                                          */
                ENDDO
/**/
/* If invalid device name entered, send message and end program */
/**/
                ELSE DO
/**/
/******************CHGVAR     VAR(&SMSG) VALUE('Save device for "Save +
/******************      Journal Receivers" is not "TAPE" or "DKTE".')/*RT0138*/
/******************SNDPGMMSG  MSG(&SMSG) TOMSGQ(MOPERQ)               /*RT0138*/
                   CHGVAR     VAR(&MONIND) VALUE('1')                 /*RT0138*/
                   SNDPGMMSG  MSG('Save device for Save Journal +
                                Receivers is not "TAPE" or "DKTE".') +
                                TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                                KEYVAR(&KEYVAR)                       /*RT0138*/
/******************CHGJOB     SWS(XXXXXX1X) **/                       /*RT0138*/
/******************GOTO       CMDLBL(END) **/                         /*RT0138*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             ENDDO
/*/COPY WNCPYSRC,SDC1715032                                          */
/**/
/* If error msg sent, wait for reply                                 */
/**/
             IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*/COPY WNCPYSRC,SDC1715014                                          */
                IF         COND(&PARM *EQ '1') THEN(DO)
/*/COPY WNCPYSRC,SDC1715015                                          */
                RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) KEYVAR(&KEYVAR) +
                           MSG(&CNL)
                ENDDO
/**/
/***********    ELSE DO                                               /*RT0138*/
/***********       RCVMSG     MSG(&CNL) PGMQ(*EXT)                    /*RT0138*/
/***********    ENDDO                                                 /*RT0138*/
/**/
/* If reply is 'C', end program                                      */
/**/
/***************IF         COND(&CNL *EQ 'C') THEN(DO)***************  *E10145*/
                IF ((&CNL *EQ 'C') *OR (&CNL *EQ 'c')) THEN(DO)       /*E10145*/
/**/
                   CHGDTAARA  DTAARA(JNSTAT (111 26)) +
                              VALUE('                          ')
/*/COPY WNCPYSRC,SDC1715016                                          */
                   IF         COND(&PARM *EQ '1') THEN(DO)
/*/COPY WNCPYSRC,SDC1715017                                          */
                   SNDPGMMSG  MSG('Save Journal Receivers - CANCELLED.+
                                  ') TOMSGQ(MOPERQ)                   /*S01495*/
/*                                ') TOMSGQ(MOPERQ MRUNQ)     */      /*S01495*/
                   ENDDO
/**/
                   ELSE DO
/******************SNDPGMMSG  MSG('Save Journal Receivers - CANCELLED.+
/******************               ')  TOPGMQ(*EXT) TOMSGQ(MRUNQ)      /*RT0165*/
                      SNDPGMMSG  MSG('Save Journal Receivers - +
                                 CANCELLED.') TOMSGQ(MOPERQ)          /*S01495*/
/*                               CANCELLED.') TOMSGQ(MRUNQ) */ /*RT0165 S01495*/
/************         CHGVAR     VAR(&CNL) VALUE('R')       */ /*RT0165 S01495*/
/************         CALL       PGM(RRC0010) PARM('SDC1715' +     */ /*S01495*/
/************                      'SAVJRNRCVC' &CNL)       */ /*RT0165 S01495*/
                   ENDDO
/**/
                   CHGJOB SWS(XXXXXX1X)
                   GOTO END
                ENDDO
/**/
/**If*reply*not*'C',*return*to*CHECK/CHECK1*************************/ /*RT0138*/
/* If reply not 'C', return to RETRY (ie before JNSTAT read in)    */ /*RT0138*/
/**/
                ELSE DO
                   CHGVAR     VAR(&MONIND) VALUE('0')
/***********       IF         COND(&PARM *EQ '0') THEN(GOTO CHECK)    /*RT0138*/
/***********       ELSE       GOTO CHECK1                             /*RT0138*/
                   GOTO       CMDLBL(RETRY)                           /*RT0138*/
                ENDDO
/**/
             ENDDO
/**/
/* Obtain library ID from SDSTAT                                     */
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715007                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&LIB) VALUE(&SYSID *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1715003                                           /*S01408*/
                                                                      /*S01408*/
/**/
/* Output user defined 'JS' entry to the journal */
/**/
             CHGVAR     VAR(&CLSAV) VALUE(&LSAV)
/************CHGVAR*****VAR(%SST(&JRNE*6*8))*VALUE('ICRCV'**TCAT*+**************************CSC020*/
/*************************%SST(&JNSTAT*16*3))***********************************************CSC020*/
             CHGVAR     VAR(%SST(&JRNE 6 10)) VALUE('R' *TCAT +
                          %SST(&JNSTAT 12 9))                                             /*CSC020*/
/************CHGVAR*****VAR(%SST(&JRNE*16*8))*VALUE('ICRCV'**TCAT*+*************************CSC020*/
/***********************&CLSAV)*************************************************************CSC020*/
             CHGVAR     VAR(%SST(&JRNE 16 10)) VALUE('IR' *TCAT +
                        &CLSAV)
             CHGVAR     VAR(%SST(&JRNE 26 8)) VALUE(&SAVD)
/*/COPY WNCPYSRC,SDC1715033                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('JS') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('JS') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/*/COPY WNCPYSRC,SDC1715034                                          */
/**/
/* Call SDC1717 to save data areas onto the journal */
/**/
             CALL       SDC1717
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/**Call*SDC1716*to*change*journal*receivers**/                        /*S01343*/
/* Call SCC1716 to change journal receivers */                        /*S01343*/
/**/
/******      CALL       PGM(SDC1716) PARM(&PARM)                      /*S01343*/
/*/COPY WNCPYSRC,SDC1715036                                          */
             CALL       PGM(SCC1716) PARM(&PARM)                      /*S01343*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/*/COPY WNCPYSRC,SDC1715037                                          */
/**/
/* Obtain range of receivers to be saved from JNSTAT                 */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/************CHGVAR*****VAR(&FSAV)*VALUE(%SST(&JNSTAT*16*3))********************************CSC020*/
             CHGVAR     VAR(&FSAV) VALUE(%SST(&JNSTAT 13 8))                              /*CSC020*/
/************CHGVAR*****VAR(&LSAV)*VALUE(%SST(&JNSTAT*6*3))*********************************CSC020*/
             CHGVAR     VAR(&LSAV) VALUE(%SST(&JNSTAT 3 8))                               /*CSC020*/
             CHGVAR     VAR(&LSAV) VALUE(&LSAV - 1)
/**/
/* Save next journal receiver                                        */
/**/
/*  If save device is not tape,                                      */                   /*CSC039*/
/*  get System Value for Data Compression parameter in save commands                      /*CSC039*/
             IF         COND(&SAVD *NE 'TAPE') THEN(DO)                                   /*CSC039*/
                  CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'SavDataCompression' &SVAL1 +
                             ' ' &SVAL2 +
                             ' ' &SVAL3 +
                             ' ' &SVAL4 +
                             ' ' &SVAL5 +
                             ' ' &SVAL6 +
                             ' ' &SVAL7 +
                             ' ' &SVAL8 +
                             ' ' &SVAL9 +
                             ' ' &SVAL10)                                                 /*CSC039*/
                                                                                          /*CSC039*/
/* If there is an error finding any system value then end abnormally */                   /*CSC039*/
                  IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                             CMDLBL(ABNOR))                                               /*CSC039*/
                  CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)                                  /*CSC039*/
             ENDDO                                                                        /*CSC039*/
                                                                                          /*CSC039*/
 SAVE:       CHGVAR     VAR(&CFSAV) VALUE(&FSAV)
/************SAVOBJ     OBJ(('ICRCV' *TCAT &CFSAV)) LIB(&LIB) +
/************             DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(*MOUNTED)   /*E24015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1715001                                           /*S01408*/
                                                                      /*S01408*/
/**********  SAVOBJ     OBJ(('ICRCV' *TCAT &CFSAV)) LIB(&LIB) +
/**********               DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(JRNIC)      /*E24015 192731*/
/**********  SAVOBJ     OBJ(('ICRCV' *TCAT &CFSAV)) LIB(&LIB) +    */          /*192731*/ /*207764*/
/**********               DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(JRNIC) + */          /*192731*/ /*207764*/
/**********               USEOPTBLK(*NO)                           */          /*192731*/ /*207764*/
/************SAVOBJ*****OBJ(('ICRCV'**TCAT*&CFSAV))*LIB(&LIB)*+*****************************CSC020*/
/*************************DEV(&DEVI)*OBJTYPE(*JRNRCV)*VOL(JRNIC)*+**************************CSC020*/
/*************************USEOPTBLK(*NO)*OUTPUT(*PRINT)*****************************207764**CSC020*/
             IF         COND(&SAVD *NE 'TAPE') THEN(DO)                                   /*CSC039*/
                  CHGVAR     VAR(&CPF3790) VALUE(*BLANK)                                  /*CSC039*/
                  SAVOBJ     OBJ(('IR' *TCAT &CFSAV)) LIB(&LIB) +
                             DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(JRNIC) +
                             USEOPTBLK(*NO) DTACPR(&DTACPRV) +
                             OUTPUT(*PRINT)                                               /*CSC039*/
                  MONMSG     MSGID(CPF3790) EXEC(CHGVAR VAR(&CPF3790) +
                             VALUE('Y'))                                                  /*CSC039*/
             ENDDO                                                                        /*CSC039*/
             ELSE (DO)                                                                    /*CSC039*/
                  CHGVAR     VAR(&CPF3790) VALUE(*BLANK)                                  /*CSC039*/
             SAVOBJ     OBJ(('IR' *TCAT &CFSAV)) LIB(&LIB) +
                          DEV(&DEVI) OBJTYPE(*JRNRCV) VOL(JRNIC) +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*CSC020*/
                  MONMSG     MSGID(CPF3790) EXEC(CHGVAR VAR(&CPF3790) +
                             VALUE('Y'))                                                  /*CSC039*/
             ENDDO                                                                        /*CSC039*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1715002                                           /*S01408*/
                                                                      /*S01408*/
/******      MONMSG     MSGID(CPF3790) EXEC(DO)               */                          /*CSC039*/
             IF         COND(&CPF3790 = 'Y') THEN(DO)                                     /*CSC039*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715008                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/***************SNDPGMMSG  MSG('End of diskette(s) reached. Mount new one(s), +
/***************             initialize and press ENTER to continue') +
/***************             TOPGMQ(*EXT) MSGTYPE(*INQ) **/           /*RT0165*/
/***************RCVMSG     PGMQ(*EXT)                                 /*RT0165*/
                IF         COND(&PARM = '0') THEN(DO)
                  SNDPGMMSG  MSG('End of diskette(s) reached. +
                               Mount new one(s), initialize and press +
                               ENTER to continue') TOMSGQ(MOPERQ)     /*S01495*/
                      GOTO       CMDLBL(ABNOR)                        /*S01495*/
/************      CHGVAR     VAR(&CNL) VALUE('R')          */ /*RT0165 S01495*/
/************      CALL    PGM(RRC0010) PARM('SDC1715' 'ENDOFDKT' +*/ /*S01495*/
/************                   &CNL)                       */ /*RT0165 S01495*/
                ENDDO
                                                                      /*RT0165*/
                IF         COND(&PARM = '1') THEN(DO)                 /*RT0165*/
                  SNDPGMMSG  MSG('End of diskette(s) reached. +
                               Mount new one(s), initialize and press +
                               ENTER to continue') TOMSGQ(MOPERQ) +
                               MSGTYPE(*INQ)                          /*RT0165*/
                ENDDO                                                 /*RT0165*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715009                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             ENDDO
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715010                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/* Continue saving receivers until all except current one saved      */
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715011                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             IF         COND(&LSAV *LE &FSAV) THEN(GOTO +
                          CMDLBL(ENDSAVE))
             CHGVAR     VAR(&FSAV) VALUE(&FSAV + 1)
             GOTO SAVE
/**/
/* Amend JNSTAT */
/**/
ENDSAVE:     CHGVAR     VAR(&FSAV) VALUE(&FSAV + 1)
             CHGVAR     VAR(&CFSAV) VALUE(&FSAV)
/*/COPY WNCPYSRC,SDC1715038                                          */
/************CHGDTAARA**DTAARA(JNSTAT*(16*3))*VALUE(&CFSAV)*********************************CSC020*/
             CHGDTAARA  DTAARA(JNSTAT (13 8)) VALUE(&CFSAV)                               /*CSC020*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715005                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/* ONLY submit RRAUTOBKP if pgm is running interactively, if next   */
/* receiver to be saved < 240, & if 'save interval' is non-zero     */
/* and if this program has not been called from I/C termination     *  *E10299*/
/**/
/******  RCVDTAARA  DTAARA(MPHAS)                                   *  *S01179*/
/********RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                */ /*S01179 CCB020*/
/**/                                                                                      /*CCB020*/
/* Check for successful SCC1711 'event' */                                                /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(AOCOMSR0) PARM('SCC1711' '00001' &CSTAT)                      /*CCB020*/
/**/                                                                  /*E10299*/
/********IF         COND(&MPHAS *NE 'B') THEN(DO)                               */ /*E10299 CCB020*/
         IF         COND(&CSTAT *EQ 'C   ') THEN(DO)                                      /*CCB020*/
/**/                                                                  /*E10299*/
             IF         COND(&PARM *EQ '0') THEN(DO)
/**/
/***************IF*********COND(&FSAV**LT*240)*THEN(DO)*************************************CSC020*/
/**/
                   IF         COND(%SST(&JNSTAT 106 5) *NE '00000') THEN(DO)
                       CALL       SDC1760
                       IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
                   ENDDO
/**/
/***************ENDDO***********************************************************************CSC020*/
/**/
             ENDDO
/**/                                                                  /*E10299*/
         ENDDO                                                        /*E10299*/
/**/
/*/COPY WNCPYSRC,SDC1715035                                          */
             GOTO       CMDLBL(END)
/**/
/* Error processing                                                  */
/**/
ABNOR:                                                                /*S01495*/
/*/COPY WNCPYSRC,SDC1715ERR                                        /* /*S01408*/
/*ABNOR:*****IF         COND(&PARM *EQ '1') THEN(DO)               */ /*S01495*/
/***********    SNDPGMMSG  MSG('Save Journal Receivers ENDED +
                                ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)     /*RT0138*/
/*                            ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)  RT0138 S01495*/
/************   SNDPGMMSG  MSG('Save Journal Receivers ENDED +     */ /*S01495*/
/************                   ABNORMALLY') TOMSGQ(MRUNQ)  */ /*RT0138 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          */ /*S01495*/
/************   SNDPGMMSG  MSG('Save Journal Receivers ENDED +     */ /*S01495*/
/************              ABNORMALLY - Retry or Cancel (R/C) ?') +*/ /*S01495*/
/************                TOMSGQ(MOPERQ) MSGTYPE(*INQ) +           /*S01495*/
/************                KEYVAR(&KEYVAR)                */ /*RT0138 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)   */ /*RT0138 S01495*/
/************   RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) +            */ /*S01495*/
/************                KEYVAR(&KEYVAR) MSG(&CNL)      */ /*RT0138 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)   */ /*RT0138 S01495*/
/************ENDDO                                                    /*S01495*/
/*******************************************************************/ /*S01495*/
/************ELSE DO                                               */ /*S01495*/
/***************SNDPGMMSG  MSG('Save Journal Receivers ENDED +
/***************                ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MRUNQ) RT0165*/
/************   SNDPGMMSG  MSG('Save Journal Receivers ENDED +     */ /*S01495*/
/************                   ABNORMALLY') TOMSGQ(MRUNQ)  */ /*RT0165 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          */ /*S01495*/
/************************************************************/ /*RT0138 S01495*/
/**Call*pgm*to*show*'Abnormal*End'*&*optionallydisplayjoblog*/ /*RT0138 S01495*/
/************************************************************/ /*RT0138 S01495*/
/************   CALLPGM(SCC0020) PARM('SDC1715' 'SAVEFAILJ')*/ /*RT0138 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)   */ /*RT0138 S01495*/
/************************************************************/ /*RT0138 S01495*/
/**Call*pgm*to*show*'Abnor*End'*&*prompt*for*retry*or*cancel*/ /*RT0138 S01495*/
/************************************************************/ /*RT0138 S01495*/
/************   CHGVAR     VAR(&CNL) VALUE(R)               */ /*RT0138 S01495*/
/************   CALL       PGM(RRC0010) PARM('SDC1715' +           */ /*S01495*/
/************                'SAVJRCVABN' &CNL)             */ /*RT0138 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)   */ /*RT0138 S01495*/
/************ENDDO                                                 */ /*S01495*/
/************************************************************/ /*RT0138 S01495*/
/**Retry*save*if*requested*else*end*program*and*re-open*I/C**/ /*RT0138 S01495*/
/************************************************************/ /*RT0138 S01495*/
/************IF         COND(&CNL = 'R') THEN(DO)           */ /*RT0138 S01495*/
/************   SNDPGMMSG  MSG('Save Journal Receivers RETRY +     */ /*S01495*/
/************                   ATTEMPT') TOMSGQ(MRUNQ)     */ /*RT0138 S01495*/
/************   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)   */ /*RT0138 S01495*/
/************   GOTO       CMDLBL(RETRY)                    */ /*RT0138 S01495*/
/************ENDDO                                          */ /*RT0138 S01495*/
/**/
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Reset 'Receiver save in progress' */
/**/
 END:        CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
/**/                                                                  /*CTI001*/
/* If Midas/TI Interface on and MPHAS 'A' then start SD replication*/ /*CTI001*/
/**/                                                                  /*CTI001*/
/**********  IF         COND((%SST(&AOMMOD 103 1) *EQ 'Y') & (&MPHAS +                 */ /*CCB020*/
/**********               *EQ 'A')) THEN(DO)                                    */ /*CTI001 CCB020*/
             IF         COND((%SST(&AOMMOD 103 1) *EQ 'Y') & (&MPHAS +
                          *EQ 'A') *OR (%SST(&AOMMOD 103 1) *EQ 'Y') +
                          & (&MPHAS *EQ 'G')) THEN(DO)                                    /*CCB020*/
             CALL       PGM(TIC0030) PARM('START' 'SDC1715')          /*CTI001*/
             ENDDO                                                    /*CTI001*/
/**/                                                                  /*CTI001*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1715END                                        */ /*S01408*/
/**/                                                                  /*S01408*/
             ENDPGM
