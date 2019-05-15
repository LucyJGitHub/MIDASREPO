/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Write spool file to disk')                   */
/*********************************************************************/
/*                                                                   */
/*  Midas - Report Control Facility Module                       */
/*                                                                   */
/*  FCC0402 - WRITE SPOOL FILE TO DISK.                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 078085             Date 23Oct94              */
/*                      E26738             Date 10Sep91              */
/*                       LN1051           DATE 06DEC90               */
/*                       LN1065           DATE 05DEC90               */
/*                       LN1006           DATE 26NOV90               */
/*                       LN0852           DATE 15OCT90               */
/*                       LN0736           DATE 12SEP90               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       078085 - SOME SPOOL FILES IN MIDAS MAY BE OPENED EVEN       */
/*                THOUGH THESE IS NO DATA TO OUTPUT. THESE ARE       */
/*                PROCESSED BY THE SYSTEM AS 'NO LONGER IN THE       */
/*                SYSTEM'. THIS IS NOT AN ERROR AND A MESSAGE        */
/*                SHOULD NOT BE SENT TO THE SCREEN. FIX IS TO        */
/*                MONITOR FOR ERROR MESSAGE CPF3344                  */
/*       E26738 - MONITOR FOR SPOOL FILE BEING OPEN AND              */
/*                PREVENT ERROR MESSAGES BEING SENT. THIS IS         */
/*                UNNECESSARY AND RCF WILL RETRY AUTOMATICALLY       */
/*       LN1051 - REMOVE OPEN OF MAAWRKPD AS COMMITMENT              */
/*                CONTROL NOT NOW REQUIRED ON THIS FILE.             */
/*                ALSO REMOVE CLOSE OF FILE.                         */
/*       LN1065 - SET UP NUMBER OF RECORDS FOR                       */
    /*                MICROFICHE CORRECTLY                           */
    /*       LN1006 - PROGRAM FF0491 RENAMED TO SC0491               */
    /*       LN0852 - AMEND ERROR HANDLING.                          */
    /*                CLOSE FILE MAAWRKPD.                           */
    /*       LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES    */
    /*                RE SPOOL FILE HANDLING                         */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL COPY SPOOL FILES TO THE ARCHIVE WORK FILE  */
    /*  AND RETURN THE FIRST/LAST RECORD NUMBERS IN THIS FILE TO     */
    /*  THE CALLING PROGRAM.                                         */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FLNAM &JBNAM &JBUSR &JBNUM &SFNUM +
                             &FLNFF &FRCD &LRCD)
             DCL        VAR(&FLNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFNUM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FLNFF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FRCD) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&LRCD) TYPE(*DEC) LEN(15 0)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(7) VALUE(CPF3485)
             DCL        VAR(&L9) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
             DCLF       FILE(QAFDMBR)
/************MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +   * *LN0736*/
/************             CMDLBL(END))                               * *LN0736*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0736*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
    /* DISPLAY FILE DESCRIPTION OF PF/MAAWRKPD FOR CURRENT NUMBER    */
    /* OF RECORDS.                                                   */
    /*                                                               */
             DSPFD      FILE(MAAWRKPD) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/RCFFD)
    /**/
             OVRDBF     FILE(QAFDMBR) TOFILE(RCFFD)
    /**/
             RCVF
    /**                                                            * */
    /* ADD 1 TO THE NUMBER OF RECORDS TO GIVE FIRST RECORD NUMBER.   */
    /*                                                               */
/************CHGVAR     VAR(&MBNDTR) VALUE(&MBNDTR + 1)                 LN1065*/
/************CHGVAR     VAR(&FRCD) VALUE(&MBNDTR)                       LN1065*/
             CHGVAR     VAR(&FRCD) VALUE(&MBNRCD + 1)                 /*LN1065*/
    /**                                                            * */
    /* COPY THE SPOOL FILE TO PF/MAAWRKPD TO GIVE ANSI PRINT CONTROL */
    /* CHARACTER AS THE FIRST BYTE.                                  */
    /*                                                               */
/************OPNDBF     FILE(MAAWRKPD) OPTION(*ALL) COMMIT(*YES)        LN1051*/
/************MONMSG     MSGID(CPF4174)                          LN0852  LN1051*/
             CPYSPLF    FILE(&FLNAM) TOFILE(MAAWRKPD) +
                          JOB(&JBNUM/&JBUSR/&JBNAM) SPLNBR(&SFNUM) +
                          MBROPT(*ADD) CTLCHAR(*FCFC)
/************MONMSG     MSGID(CPF3303 CPF3309 CPF3342 CPF3344) +
/***************          EXEC(DO)                             /*LN0852 078085*/
                                                                      /*078085*/
/* IF SPOOL FILE IS NO LONGER IN SYSTEM, OR HAD NO DATA WRITTEN */    /*078085*/
/* TO IT WHEN IT WAS OPENED, DO NOT PROCESS ANY FURTHER         */    /*078085*/
             MONMSG     MSGID(CPF3344) EXEC(GOTO CMDLBL(END))         /*078085*/
                                                                      /*078085*/
/* IF JOB OR FILE WAS NOT FOUND, SEND ERROR MESSAGE             */    /*078085*/
             MONMSG     MSGID(CPF3303 CPF3309 CPF3342) +
                          EXEC(DO)                                    /*078085*/
/***************CLOF       OPNID(MAAWRKPD)                      LN0852  LN1051*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                     /*LN0852*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)            /*LN0852*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*LN0852*/
                SNDPGMMSG  MSG('FCC0402 Write Spool File +
                             to Disk unable to process spool +
                             file.  See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                           /*LN0852*/
                GOTO       CMDLBL(END)                                /*LN0852*/
                ENDDO                                                 /*LN0852*/
                                                                      /*E26738*/
/* IF SPOOL FILE IS OPEN THEN BYPASS ERROR PROCESSING AND SET */      /*E26738*/
/* RETURN FLAG TO 'Y' TO ALLOW RETRY OF WRITE TO FILE         */      /*E26738*/
                                                                      /*E26738*/
             MONMSG     MSGID(CPF3482) EXEC(DO)                       /*E26738*/
                CHGVAR     VAR(&FLNFF) VALUE('Y')                     /*E26738*/
                GOTO       CMDLBL(END)                                /*E26738*/
             ENDDO                                                    /*E26738*/
/************                                                        * *LN0736*/
/**IF*SPOOL*FILE*NOT*FOUND*SET*FILE*NOT*FOUND*FLAG*TO*'Y'            * *LN0736*/
/************                                                        * *LN0736*/
/************MONMSG     MSGID(CPF3303 CPF3344) EXEC(CHGVAR +         * *LN0736*/
/************             VAR(&FLNFF) VALUE('Y'))                    * *LN0736*/
/************GOTO       CMDLBL(END)                                  * *LN0736*/
/************CLOF       OPNID(MAAWRKPD)                        LN0852   LN1051*/
    /**                                                            * */
    /* RECEIVE MESSAGE TO ASCERTAIN HOW MANY RECORDS WERE COPIED     */
    /*                                                               */
/************RCVMSG     MSGTYPE(*ANY) MSGDTA(&DATA) MSGID(&ID)         LN1065*/
 NEXT:       RCVMSG     MSGTYPE(*ANY) RMV(*NO) MSGDTA(&DATA) +
                          MSGID(&ID)                                  /*LN1065*/
             IF         COND(&ID *NE 'CPF3485') +
                                  THEN(GOTO CMDLBL(NEXT))            /*LN1065*/
             CHGVAR     VAR(&L9) VALUE(%SUBSTRING(&DATA 69 4))
    /******* CALL       PGM(FF0491) PARM(&L9 &REC)                     LN1006*/
             CALL       PGM(SC0491) PARM(&L9 &REC)                   /*LN1006*/
    /**                                                            * */
    /* ADD THE NUMBER OF RECORDS COPIED TO THE PREVIOUS NUMBER OF    */
    /* RECORDS ON FILE TO GIVE LAST RECORD NUMBER.                   */
    /*                                                               */
/************CHGVAR     VAR(&LRCD) VALUE(&REC + &MBNDTR)               *LN1065*/
             CHGVAR     VAR(&LRCD) VALUE(&REC + &MBNRCD)              /*LN1065*/
             GOTO       CMDLBL(END)                                   /*LN0736*/
    /*                                                               */
 ABNOR:      CHGVAR     VAR(&FLNFF) VALUE('Y')                        /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)               /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
/************SNDPGMMSG  MSG('FCC0402 Write Spool File to Disk +
/************             terminated abnormally.  See previous +
/************             messages for further information.') +
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           *LN0736*LN0852*/
             SNDPGMMSG  MSG('FCC0402 Write Spool File to Disk +
                          terminated abnormally.  See previous +
                          messages for further information.  RCF +
                          will retry distribution automatically.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*LN0852*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 END:        ENDPGM
