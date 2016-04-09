/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Dist spool file via OFC d/list')             */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0403 - DISTRIBUTE SPOOL FILE VIA OFFICE DISTRIBUTION LIST */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND NO. 043702           DATE 21AUG92            */
    /*       PREV AMEND NO. E26738           DATE 10SEP91            */
    /*                      LN0852           DATE 16OCT90            */
    /*                      LN0736           DATE 12SEP90            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*       043702 - MONITOR FOR INVALID DISTRIBUTION LIST, DO NOT  */
    /*                RETRY AS THIS CAUSES FCC0401 TO LOOP           */
    /*       E26738 - MONITOR FOR SPOOL FILE BEING OPEN AND          */
    /*                PREVENT ERROR MESSAGES BEING SENT. THIS IS     */
    /*                UNNECESSARY AND RCF WILL RETRY AUTOMATICALLY.  */
    /*       LN0852 - AMEND ERROR HANDLING.                          */
    /*       LN0736 - CHANGES TO ERROR FLAGS AND MONITOR MESSAGES    */
    /*                RE SPOOL FILE HANDLING                         */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL SEND SPOOL FILE REQUIRED VIA SNDNETSPLF    */
    /*  COMMAND.                                                     */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FLNAM &JBNAM &JBUSR &JBNUM &SFNUM +
                             &FLNFF &DLS1 &DLS2)
             DCL        VAR(&FLNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFNUM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FLNFF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLS1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DLS2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)                /*LN0736*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)                /*LN0736*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*LN0736*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*LN0736*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +   * *LN0736*/
/************             CMDLBL(END))                               * *LN0736*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0736*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
    /* SEND NETWORK SPOOL FILE USING INPUT PARAMETERS.               */
    /*                                                               */
             SNDNETSPLF FILE(&FLNAM) TOUSRID((&DLS1 &DLS2)) +
                          JOB(&JBNUM/&JBUSR/&JBNAM) SPLNBR(&SFNUM)
/************                                                        * *LN0736*/
/**IF*SPOOL*FILE*NOT*FOUND*SET*FILE*NOT*FOUND*FLAG*TO*'Y'            * *LN0736*/
/************                                                        * *LN0736*/
/************MONMSG     MSGID(CPF3303 CPF3344) EXEC(CHGVAR +         * *LN0736*/
/************             VAR(&FLNFF) VALUE('Y'))                    * *LN0736*/
/**/                                                                  /*LN0736*/
/* IF UNABLE TO PROCESS SPOOL FILE, SET FILE NOT FOUND FLAG TO 'R'   * *LN0736*/
/**/                                                                  /*LN0736*/
/************MONMSG     MSGID(CPF8063 CPF9005 CPF9006 CPF9830) +
                          EXEC(DO)                              *LN0736*LN0852*/
             MONMSG     MSGID(CPF3309 CPF3342 CPF3344) EXEC(DO)       /*LN0852*/
/************   CHGVAR     VAR(&FLNFF) VALUE('R')               *LN0736*LN0852*/
                CHGVAR     VAR(&FLNFF) VALUE('P')                     /*LN0852*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)            /*LN0736*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*LN0736*/
                SNDPGMMSG  MSG('FCC0403 Distribute Spool File Via +
                             Office Distribution List was unable to +
                             process the spool file at this time.  +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                           /*LN0736*/
                ENDDO                                                 /*LN0736*/
                                                                      /*E26738*/
/**/                                                                  /*043702*/
/* IF UNABLE TO DISTRIBUTE SPOOL FILE, SET FILE NOT FOUND FLAG TO 'F' /*043702*/
/**/                                                                  /*043702*/
             MONMSG     MSGID(CPF8067) EXEC(DO)                       /*043702*/
                CHGVAR     VAR(&FLNFF) VALUE('F')                     /*043702*/
                RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                             MSGF(&MSGF) MSGFLIB(&MSGFLIB)            /*043702*/
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) /*043702*/
                SNDPGMMSG  MSG('FCC0403 Distribute Spool File Via +
                             Office Distribution List was unable to +
                             distribute the spool file at this time.  +
                             See previous messages for further +
                             information.') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)                           /*043702*/
                ENDDO                                                 /*043702*/
 
/* IF SPOOL FILE IS OPEN THEN BYPASS ERROR PROCESSING AND SET */      /*E26738*/
/* RETURN FLAG TO 'Y' TO ALLOW RETRY OF WRITE TO FILE         */      /*E26738*/
                                                                      /*E26738*/
             MONMSG     MSGID(CPF3482) EXEC(DO)                       /*E26738*/
                CHGVAR     VAR(&FLNFF) VALUE('Y')                     /*E26738*/
             ENDDO                                                    /*E26738*/
/**/                                                                  /*E26738*/
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
/************SNDPGMMSG  MSG('FCC0403 Distribute Spool File Via +
/************             Office Distribution List terminated +
/************             abnormally.  See previous messages for +
/************             further information.') TOPGMQ(*EXT) +
/************             TOMSGQ(MOPERQ)                        *LN0736*LN0852*/
             SNDPGMMSG  MSG('FCC0403 Distribute Spool File Via +
                          Office Distribution List terminated +
                          abnormally.  See previous messages for +
                          further information.  RCF will retry +
                          distribution automatically.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*LN0852*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*LN0736*/
 END:        ENDPGM
