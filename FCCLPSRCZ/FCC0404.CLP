/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Change spool file attributes')               */
/*********************************************************************/
/*                                                                   */
/*   Midas - Report Control Facility Module                          */
/*                                                                   */
/*   FCC0404 - CHANGE ATTRIBUTES OF A SPOOL FILE.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG5019            Date 01Apr05              */
/*                      CFC002             Date 29Apr02              */
/*                      CFC001             Date 15Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       094515           Date 25Oct95               */
/*                       078085           Date 23Oct94               */
/*                       LN0852           DATE 16OCT90               */
/*                       LN0736           DATE 12SEP90               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG5019 - Routing of reports involving big volume of pages  */
/*                 is not working                                    */
/*       CFC002 - Multiple Output Queues In Std Output Instructions  */
/*       CFC001 - Retain to spool files (Copy to Archive)            */
/*       094515 - IF THE TO OUTPUT QUEUE IS MISSING THEN CREATE IT.  */
/*       078085 - SOME SPOOL FILES IN MIDAS MAY BE OPENED EVEN       */
/*                THOUGH THESE IS NO DATA TO OUTPUT. THESE ARE       */
/*                PROCESSED BY THE SYSTEM AS 'NO LONGER IN THE       */
/*                SYSTEM'. THIS IS NOT AN ERROR AND A MESSAGE        */
/*                SHOULD NOT BE SENT TO THE SCREEN. FIX IS TO        */
/*                MONITOR FOR ERROR MESSAGE CPF3344                  */
/*       LN0852 - AMEND ERROR HANDLING.                              */
/*              - CHANGE RELEASE SPOOL FILE TO HOLD SPOOL FILE       */
/*       LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES        */
/*                RE SPOOL FILE HANDLING                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  THIS PROGRAM WILL CHANGE THE SPOOL FILE ATTRIBUTES OF A          */
/*  FILE TO BE DISTRIBUTED.                                          */
/*                                                                   */
/*********************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*/COPY WNCPYSRC,FCC0404001                                          */
             PGM        PARM(&FLNAM &JBNAM &JBUSR &JBNUM &SFNUM +
                             &OUTQ &NCPY &SAVAF &HLDBF &FLNFF +
                             &XOUTQ &MFLG)                                                /*CFC002*/
/**********  PGM        PARM(&FLNAM &JBNAM &JBUSR &JBNUM &SFNUM +                         /*CFC002*/
/**********                  &OUTQ &NCPY &SAVAF &HLDBF &FLNFF)                            /*CFC002*/
             DCL        VAR(&FLNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFNUM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SAVAF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HLDBF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLNFF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NOCPY) TYPE(*DEC) LEN(2)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
             DCL        VAR(&OBJTEXT) TYPE(*CHAR) LEN(50) +
                          VALUE('Midas FC Default output queue +
                          created by RCF      ')                      /*094515*/
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(1)              /*094515*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)                                     /*CFC001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CFC001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE(*VERIFY)                      /*CFC001*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE(CFC001)                       /*CFC001*/
             DCL        VAR(&USRDTA) TYPE(*CHAR) LEN(10)                                  /*CFC001*/
             DCL        VAR(&SFNUMDEC) TYPE(*DEC) LEN(4 0)                                /*CFC001*/
             DCL        VAR(&SFNUMBIN) TYPE(*CHAR) LEN(4)                                 /*CFC001*/
             DCL        VAR(&JOBALL) TYPE(*CHAR) LEN(26)                                  /*CFC001*/
             DCL        VAR(&RCV) TYPE(*CHAR) LEN(1024)                                   /*CFC001*/
/**********  DCL        VAR(&STILLOPEN) TYPE(*CHAR) LEN(1) */                 /*CFC001*/ /*BUG5019*/
             DCL        VAR(&CPI) TYPE(*CHAR) LEN(4)                                      /*CFC001*/
             DCL        VAR(&PAGEWIDE) TYPE(*CHAR) LEN(3)                                 /*CFC001*/
             DCL        VAR(&LPI) TYPE(*CHAR) LEN(4)                                      /*CFC001*/
             DCL        VAR(&PAGELEN) TYPE(*CHAR) LEN(3)                                  /*CFC001*/
             DCL        VAR(&XOUTQ) TYPE(*CHAR) LEN(30)                                   /*CFC002*/
             DCL        VAR(&MFLG) TYPE(*CHAR) LEN(1)                                     /*CFC002*/
             DCL        VAR(&CFC001) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CFC002*/
             DCL        VAR(&CFC002) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CFC002*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CFC002*/
             DCL        VAR(&RCOUNT) TYPE(*DEC) LEN(2)                                   /*BUG5019*/
/*/COPY WNCPYSRC,FCC0404002                                          */
/************MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +   * *LN0736*/
/************             CMDLBL(END))                               * *LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0736*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(&NOCPY) VALUE(&NCPY)
    /**                                                            * */
    /**IF*HOLD*BEFORE*PRINTING*=*'N'*THEN*RELEASE*SPOOL*FILE.********* *LN0852*/
    /* IF HOLD BEFORE PRINTING = 'Y' THEN HOLD SPOOL FILE.             *LN0852*/
    /*                                                               */
/************IF         COND(&HLDBF = 'N') THEN(DO)                    *LN0852*/
/************RLSSPLF    FILE(&FLNAM) JOB(&JBNUM/&JBUSR/&JBNAM) +
/************             SPLNBR(&SFNUM)                               *LN0852*/
/**/                                                                                      /*CFC001*/
/** Check if CFC001 is on */                                                              /*CFC001*/
/**/                                                                                      /*CFC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                             /*CFC001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CFC001*/
                CHGVAR     VAR(&CFC001) VALUE('Y')                                        /*CFC001*/
             ENDDO                                                                        /*CFC001*/
/**/                                                                                      /*CFC002*/
/** Check if CFC002 is on */                                                              /*CFC002*/
/**/                                                                                      /*CFC002*/
             CHGVAR     VAR(&CFC002) VALUE(' ')                                           /*CFC002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CFC002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CFC002*/
             CHGVAR     VAR(&SARD) VALUE('CFC002')                                        /*CFC002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SFMT)                       /*CFC002*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CFC002*/
                CHGVAR     VAR(&CFC002) VALUE('Y')                                        /*CFC002*/
             ENDDO                                                                        /*CFC002*/
/**/                                                                                      /*CFC002*/
             IF         COND((&CFC001 *NE 'Y') *OR (&OUTQ *EQ +
                          'MPRINT')) THEN(DO)                                             /*CFC001*/
/*/COPY WNCPYSRC,FCC0404005                                          */
             IF         COND(&HLDBF = 'Y') THEN(DO)                   /*LN0852*/
             HLDSPLF    FILE(&FLNAM) JOB(&JBNUM/&JBUSR/&JBNAM) +
                          SPLNBR(&SFNUM)                              /*LN0852*/
/************MONMSG     MSGID(CPF3322 CPF3344)                       * *LN0736*/
/************MONMSG     MSGID(CPF3322)                          *LN0736*LN0852*/
/************MONMSG     MSGID(CPF3337)                         /*LN0852 078085*/
/************MONMSG     MSGID(CPF3303 CPF3309 CPF3342 CPF3344 +
/************             CPF34A4) EXEC(DO)                    /*LN0852 078085*/
             MONMSG     MSGID(CPF3337 CPF3344)                        /*078085*/
             MONMSG     MSGID(CPF3303 CPF3309 CPF3342 CPF34A4) +
                          EXEC(DO)                                    /*078085*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                     /*LN0852*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)            /*LN0852*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*LN0852*/
                SNDPGMMSG  MSG('FCC0404 Change Attributes of a +
                             Spool File was unable to +
                             process a spool file.  +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                           /*LN0852*/
                GOTO       CMDLBL(END)                                /*LN0852*/
                ENDDO                                                 /*LN0852*/
             ENDDO
    /**                                                            * */
    /* CHANGE SAVE AFTER FIELD TO BE CORRECT LENGTH FOR CHGSPLFA     */
    /*                                                               */
             IF         COND(&SAVAF = 'Y') THEN(DO)
             CHGVAR     VAR(&SAVE) VALUE('*YES')
             ENDDO
             IF         COND(&SAVAF = 'N') THEN(DO)
             CHGVAR     VAR(&SAVE) VALUE('*NO')
             ENDDO
             IF         COND(&CFC002 *NE 'Y') THEN(DO)                                    /*CFC002*/
/*/COPY WNCPYSRC,FCC0404003                                          */
    /**                                                            * */
    /* CHANGE SPOOL FILE ATTRIBUTES USING INPUT PARAMETERS.          */
    /*                                                               */
             CHKOBJ     OBJ(&OUTQ) OBJTYPE(*OUTQ)                     /*094515*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                       /*094515*/
                CALL       PGM(SCC0025) PARM(&OUTQ 'OUTQ' 'XLIB' +
                             &OBJTEXT '*FIFO' '*USE' &RTNCODE)        /*094515*/
             ENDDO                                                    /*094515*/
                                                                      /*094515*/
/* Get current attributes of spool file before change */                                  /*CFC001*/
             CHGVAR     VAR(&JOBALL) VALUE(&JBNAM *CAT &JBUSR *CAT +
                          &JBNUM)                                                         /*CFC001*/
             CHGVAR     VAR(&SFNUMDEC) VALUE(&SFNUM)                                      /*CFC001*/
             CHGVAR     VAR(%BIN(&SFNUMBIN)) VALUE(&SFNUMDEC)                             /*CFC001*/
/**/                                                                                      /*CFC001*/
             CALL       PGM(QUSRSPLA) PARM(&RCV X'00000400' +
                          'SPLA0200' &JOBALL '                ' +
                          '                ' &FLNAM &SFNUMBIN)                            /*CFC001*/
/**/                                                                                      /*CFC001*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&RCV) +
                        VALUE(' '))                                                       /*CFC001*/
/**********  CHGVAR     VAR(&STILLOPEN) VALUE(%SST(&RCV 1019 1)) */           /*CFC001*/ /*BUG5019*/
/**********  IF         COND(&STILLOPEN *EQ 'Y') THEN(DO)        */           /*CFC001*/ /*BUG5019*/
/**********  CHGVAR     VAR(&FLNFF) VALUE('Y')                   */           /*CFC001*/ /*BUG5019*/
/**********  GOTO       CMDLBL(END)                              */           /*CFC001*/ /*BUG5019*/
/**********  ENDDO                                               */           /*CFC001*/ /*BUG5019*/
/*/COPY WNCPYSRC,FCC0404006                                          */
             CHGVAR     VAR(&RCOUNT) VALUE(0)                                            /*BUG5019*/
RETRY:                                                                                   /*BUG5019*/
             CHGSPLFA   FILE(&FLNAM) JOB(&JBNUM/&JBUSR/&JBNAM) +
                          SPLNBR(&SFNUM) OUTQ(&OUTQ) COPIES(&NOCPY) +
                          SAVE(&SAVE)
/************                                                        * *LN0736*/
/**IF*SPOOL*FILE*NOT*FOUND*SET*FILE*NOT*FOUND*FLAG*TO*'Y'            * *LN0736*/
/************                                                        * *LN0736*/
/************MONMSG     MSGID(CPF3303 CPF3344) EXEC(CHGVAR +         * *LN0736*/
/************             VAR(&FLNFF) VALUE('Y'))                    * *LN0736*/
/**/                                                                  /*LN0736*/
/* IF UNABLE TO PROCESS SPOOL FILE SET ERROR FLAG TO 'R' OR 'P'      * *LN0736*/
/* DEPENDING ON TYPE OF MESSAGE SENT                                 * *LN0736*/
/**/                                                                  /*LN0736*/
/************MONMSG     MSGID(CPF2207 CPF3330 CPF3492) EXEC(DO) *LN0736*LN0852*/
/************   CHGVAR     VAR(&FLNFF) VALUE('R')               *LN0736*LN0852*/
/************   RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
/************                MSGF(&MSGF) MSGFLIB(&MSGFLIB)      *LN0736*LN0852*/
/************   SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
/************                MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)  *LN0736*/
/*                                                                     *LN0852*/
/************   SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
/************                File was unable to process the spool +
/************                file at this time.  See previous +
/************                messages for further information.') +
/************                TOPGMQ(*EXT) TOMSGQ(MOPERQ)        *LN0736*LN0852*/
/************   ENDDO                                           *LN0736*LN0852*/
/************MONMSG     MSGID(CPF3309 CPF3341 CPF3342 CPF3344) +
/************             EXEC(DO)                         /*LN0736*/ /*078085*/
             MONMSG     MSGID(CPF3344)                                /*078085*/
/**********  MONMSG     MSGID(CPF3309 CPF3341 CPF3342) EXEC(DO) */            /*078085*/ /*BUG5019*/
             MONMSG     MSGID(CPF3341) EXEC(DO)                                          /*BUG5019*/
             CHGVAR     VAR(&RCOUNT) VALUE(&RCOUNT + 1)                                  /*BUG5019*/
             IF         COND(&RCOUNT *LE 10) THEN(DO)                                    /*BUG5019*/
             DLYJOB     DLY(30)                                                          /*BUG5019*/
             GOTO       CMDLBL(RETRY)                                                    /*BUG5019*/
             ENDDO                                                                       /*BUG5019*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                                        /*BUG5019*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)                               /*BUG5019*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)                    /*BUG5019*/
                SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
                             File unable to process spool file.   +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                                              /*BUG5019*/
             ENDDO                                                                       /*BUG5019*/
             MONMSG     MSGID(CPF3309 CPF3342) EXEC(DO)                                  /*BUG5019*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                     /*LN0736*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)            /*LN0736*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*LN0736*/
                SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
                             File unable to process spool file.   +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                           /*LN0736*/
                ENDDO                                                 /*LN0736*/
             ENDDO                                                                        /*CFC002*/
             ENDDO                                                                        /*CFC001*/
             ELSE (DO)                                                                    /*CFC001*/
/**/                                                                                      /*CFC001*/
/* Get current attributes of spool file before change */                                  /*CFC001*/
/**/                                                                                      /*CFC001*/
             CHGVAR     VAR(&JOBALL) VALUE(&JBNAM *CAT &JBUSR *CAT +
                          &JBNUM)                                                         /*CFC001*/
             CHGVAR     VAR(&SFNUMDEC) VALUE(&SFNUM)                                      /*CFC001*/
             CHGVAR     VAR(%BIN(&SFNUMBIN)) VALUE(&SFNUMDEC)                             /*CFC001*/
             CALL       PGM(QUSRSPLA) PARM(&RCV X'00000400' +
                          'SPLA0200' &JOBALL '                ' +
                          '                ' &FLNAM &SFNUMBIN)                            /*CFC001*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&RCV) +
                        VALUE(' '))                                                       /*CFC001*/
/**********  CHGVAR     VAR(&STILLOPEN) VALUE(%SST(&RCV 1019 1)) */           /*CFC001*/ /*BUG5019*/
/**********  IF         COND(&STILLOPEN *EQ 'Y') THEN(DO)        */           /*CFC001*/ /*BUG5019*/
/**********  CHGVAR     VAR(&FLNFF) VALUE('Y')                   */           /*CFC001*/ /*BUG5019*/
/**********  GOTO       CMDLBL(END)                              */           /*CFC001*/ /*BUG5019*/
/**********  ENDDO                                               */           /*CFC001*/ /*BUG5019*/
/**/                                                                                      /*CFC001*/
/* Get further attributes of original spool file                                       */ /*CFC001*/
             CHGVAR     VAR(&JOBALL) VALUE(&JBNAM *CAT &JBUSR *CAT +
                          &JBNUM)                                                         /*CFC001*/
             CHGVAR     VAR(&SFNUMDEC) VALUE(&SFNUM)                                      /*CFC001*/
             CHGVAR     VAR(%BIN(&SFNUMBIN)) VALUE(&SFNUMDEC)                             /*CFC001*/
             CALL       PGM(QUSRSPLA) PARM(&RCV X'00000100' +
                          'SPLA0100' &JOBALL '                ' +
                          '                ' &FLNAM &SFNUMBIN)                            /*CFC001*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&RCV) +
                        VALUE(' '))                                                       /*CFC001*/
             CHGVAR     VAR(&USRDTA) VALUE(%SST(&RCV 91 10))                              /*CFC001*/
                                                                                          /*CFC001*/
/*    Convert save and hold parameters to *YES or *NO                                     /*CFC001*/
                                                                                          /*CFC001*/
                IF         COND(&SAVAF = 'Y') THEN(DO)                                    /*CFC001*/
                   CHGVAR     VAR(&SAVE) VALUE('*YES')                                    /*CFC001*/
                ENDDO                                                                     /*CFC001*/
                IF         COND(&SAVAF = 'N') THEN(DO)                                    /*CFC001*/
                   CHGVAR     VAR(&SAVE) VALUE('*NO')                                     /*CFC001*/
                ENDDO                                                                     /*CFC001*/
                IF         COND(&HLDBF = 'Y') THEN(DO)                                    /*CFC001*/
                   CHGVAR     VAR(&HOLD) VALUE('*YES')                                    /*CFC001*/
                ENDDO                                                                     /*CFC001*/
                IF         COND(&HLDBF = 'N') THEN(DO)                                    /*CFC001*/
                   CHGVAR     VAR(&HOLD) VALUE('*NO')                                     /*CFC001*/
                ENDDO                                                                     /*CFC001*/
                                                                                          /*CFC001*/
             CRTPF      FILE(QTEMP/DUPSPLF) RCDLEN(200) SIZE(*NOMAX) +
                          LVLCHK(*NO)                                                     /*CFC001*/
             MONMSG     MSGID(CPF7302)                                                    /*CFC001*/
             CPYSPLF    FILE(&FLNAM) TOFILE(QTEMP/DUPSPLF) +
                          JOB(&JBNUM/&JBUSR/&JBNAM) SPLNBR(&SFNUM) +
                          CTLCHAR(*FCFC)                                                  /*CFC001*/
             CALL       PGM(FCC000011) PARM(&FLNAM &JBNAM &JBUSR +
                          &JBNUM &SFNUM &CPI &PAGEWIDE &LPI &PAGELEN)                     /*CFC001*/
 
             IF         COND(&CPI = ' ') THEN(DO)                                         /*CFC001*/
                CHGVAR     VAR(&CPI) VALUE('10')                                          /*CFC001*/
             ENDDO                                                                        /*CFC001*/
 
             IF         COND(&LPI = ' ') THEN(DO)                                         /*CFC001*/
                CHGVAR     VAR(&LPI) VALUE('6')                                           /*CFC001*/
             ENDDO                                                                        /*CFC001*/
 
             IF         COND(&PAGELEN = ' ') THEN(DO)                                     /*CFC001*/
                CHGVAR     VAR(&PAGELEN) VALUE('66')                                      /*CFC001*/
             ENDDO                                                                        /*CFC001*/
 
             IF         COND(&PAGEWIDE = ' ') THEN(DO)                                    /*CFC001*/
                CHGVAR     VAR(&PAGEWIDE) VALUE('132')                                    /*CFC001*/
             ENDDO                                                                        /*CFC001*/
 
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(&PAGELEN &PAGEWIDE) +
                          LPI(&LPI) CPI(&CPI) CTLCHAR(*FCFC) +
                          OUTQ(&OUTQ) COPIES(&NOCPY) HOLD(&HOLD) +
                          SAVE(&SAVE) USRDTA(&USRDTA) SPLFNAME(&FLNAM)                    /*CFC001*/
             OVRPRTF    FILE(QSYSPRT) CTLCHAR(*FCFC) OUTQ(&OUTQ) +
                          COPIES(&NOCPY) HOLD(&HOLD) SAVE(&SAVE) +
                          USRDTA(&USRDTA) SPLFNAME(&FLNAM)                                /*CFC001*/
                CPYF       FROMFILE(QTEMP/DUPSPLF) TOFILE(QSYSPRT)                        /*CFC001*/
                DLTOVR     FILE(QSYSPRT)                                                  /*CFC001*/
             ENDDO                                                                        /*CFC001*/
/*/COPY WNCPYSRC,FCC0404004                                          */
/**/                                                                                      /*CFC002*/
/** If SAR CFC002 is on */                                                                /*CFC002*/
/**/                                                                                      /*CFC002*/
             IF         COND((&CFC002 *EQ 'Y') *AND (&XOUTQ *NE ' +
                          ')) THEN(DO)                                                    /*CFC002*/
/**/                                                                                      /*CFC002*/
/** Call program */                                                                       /*CFC002*/
/**/                                                                                      /*CFC002*/
             CALL       PGM(FCC000010) PARM(&FLNAM &JBNAM +
                          &JBUSR &JBNUM &SFNUM &XOUTQ &MFLG  +
                          &NOCPY &SAVE)                                                   /*CFC002*/
/**/                                                                                      /*CFC002*/
             IF         COND(&CFC001 *NE 'Y') THEN(DO)                                    /*CFC002*/
/**/                                                                                      /*CFC002*/
/** Change spool file attributes using input parameters           */                      /*CFC002*/
/**/                                                                                      /*CFC002*/
             CHKOBJ     OBJ(&OUTQ) OBJTYPE(*OUTQ)                                         /*CFC002*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CFC002*/
                CALL       PGM(SCC0025) PARM(&OUTQ 'OUTQ' 'XLIB' +
                             &OBJTEXT '*FIFO' '*USE' &RTNCODE)                            /*CFC002*/
             ENDDO                                                                        /*CFC002*/
/**/                                                                                      /*CFC002*/
/** Get current attributes of spool file before change */                                 /*CFC002*/
/**/                                                                                      /*CFC002*/
             CHGVAR     VAR(&JOBALL) VALUE(&JBNAM *CAT &JBUSR *CAT +
                          &JBNUM)                                                         /*CFC002*/
             CHGVAR     VAR(&SFNUMDEC) VALUE(&SFNUM)                                      /*CFC002*/
             CHGVAR     VAR(%BIN(&SFNUMBIN)) VALUE(&SFNUMDEC)                             /*CFC002*/
/**/                                                                                      /*CFC002*/
             CALL       PGM(QUSRSPLA) PARM(&RCV X'00000400' +
                          'SPLA0200' &JOBALL '                ' +
                          '                ' &FLNAM &SFNUMBIN)                            /*CFC002*/
/**/                                                                                      /*CFC002*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&RCV) +
                        VALUE(' '))                                                       /*CFC002*/
/**********  CHGVAR     VAR(&STILLOPEN) VALUE(%SST(&RCV 1019 1)) */           /*CFC002*/ /*BUG5019*/
/**********  IF         COND(&STILLOPEN *EQ 'Y') THEN(DO)        */           /*CFC002*/ /*BUG5019*/
/**********     CHGVAR     VAR(&FLNFF) VALUE('Y')                */           /*CFC002*/ /*BUG5019*/
/**********     GOTO       CMDLBL(END)                           */           /*CFC002*/ /*BUG5019*/
/**********  ENDDO                                               */           /*CFC002*/ /*BUG5019*/
/**/                                                                                      /*CFC002*/
             CHGVAR     VAR(&RCOUNT) VALUE(0)                                            /*BUG5019*/
 RETRY2:                                                                                 /*BUG5019*/
             CHGSPLFA   FILE(&FLNAM) JOB(&JBNUM/&JBUSR/&JBNAM) +
                          SPLNBR(&SFNUM) OUTQ(&OUTQ) COPIES(&NOCPY) +
                          SAVE(&SAVE)                                                     /*CFC002*/
             MONMSG     MSGID(CPF3344)                                                    /*CFC002*/
/**********  MONMSG     MSGID(CPF3309 CPF3341 CPF3342) EXEC(DO) */            /*CFC002*/ /*BUG5019*/
             MONMSG     MSGID(CPF3341) EXEC(DO)                                          /*BUG5019*/
             CHGVAR     VAR(&RCOUNT) VALUE(&RCOUNT + 1)                                  /*BUG5019*/
             IF         COND(&RCOUNT *LE 10) THEN(DO)                                    /*BUG5019*/
             DLYJOB     DLY(30)                                                          /*BUG5019*/
             GOTO       CMDLBL(RETRY2)                                                   /*BUG5019*/
             ENDDO                                                                       /*BUG5019*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                                        /*BUG5019*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)                               /*BUG5019*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)                    /*BUG5019*/
                SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
                             File unable to process spool file.   +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                                              /*BUG5019*/
             ENDDO                                                                       /*BUG5019*/
             MONMSG     MSGID(CPF3309 CPF3342) EXEC(DO)                                  /*BUG5019*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                                         /*CFC002*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)                                /*CFC002*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)                     /*CFC002*/
                SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
                             File unable to process spool file.   +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                                               /*CFC002*/
                ENDDO                                                                     /*CFC002*/
/**/                                                                                      /*CFC002*/
             ENDDO                                                                        /*CFC002*/
             ENDDO                                                                        /*CFC002*/
             GOTO       CMDLBL(END)                                   /*LN0736*/
/**/                                                                  /*LN0736*/
 ABNOR:      CHGVAR     VAR(&FLNFF) VALUE('Y')                        /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)               /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*LN0736*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
/************SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
/************             File terminated abnormally.  See previous +
/************             messages for further information.') +
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           *LN0736*LN0852*/
             SNDPGMMSG  MSG('FCC0404 Change Attributes of a Spool +
                          File terminated abnormally.  See previous +
                          messages for further information.  RCF +
                          will retry distribution automatically.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*LN0852*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 END:        ENDPGM
