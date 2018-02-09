/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FC CoB report requests with prompt')            */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module                   */
    /*                                                               */
    /*  FCC0203 - COB REPORT REQUEST WITH MODULE SPECIFIC PROMPT     */
    /*                                                               */
/*       (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG24422           Date 19Jun09              */
/*                      BUG24307           Date 16Jun09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*                      115328           DATE 27JAN98            */
    /*                      099929           DATE 31MAY96            */
    /*                      087482           DATE 03OCT95            */
    /*                      076789           DATE 03OCT94            */
    /*                      049424           DATE 11JAN93            */
    /*                      046778           DATE 06NOV92            */
    /*                      044847           DATE 23SEP92            */
    /*                      E38773           DATE 24APR92            */
    /*                      E36374           DATE 29FEB92            */
    /*                      LN1144           DATE 13MAR91            */
    /*                      LN1085           DATE 13MAR91            */
    /*                      LN0073           DATE 01MAY90            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL CALL PROGRAMS TO DISPLAY THE RELEVANT      */
    /*  PROMPT SCREENS TO REQUEST A CLOSE OF BUSINESS REPORT WITH A  */
    /*  MODULE SPECIFIC PROMPT SCREEN                                */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
    /*    BUG24422 - Threshold Amount Update screen is missing       */
    /*    BUG24307 - Local Tax Office Statement On Request COB       */
    /*               returned an error                               */
    /*    115328 - Remove part of previous fix 087482 in order to    */
    /*             prevent lock on *DTAARA REPSEQ.                   */
    /*    099929 - Allocate dtaara/REPSEQ exclusively, as            */
    /*             sometimes get two jobs updating it with the same  */
    /*             value causing duplicate record on FCRREQL0.       */
    /*    087482 - Repseq is accessed for the the next key by more   */
    /*             than one program and then a record writen         */
    /*             causing an error of duplicate record written.     */
    /*             fix is to allocate obj and dealocate obj of       */
    /*             data area REPSEQ                                  */
    /*    076789 - Overrides moved to MLC0000                        */
    /*    049424 - IBM HAVE RENAMED THE OFFICE FILES AGAIN AT        */
    /*             V2R2. THE PROGRAM HAS BEEN AMENDED TO CALL A      */
    /*             NEW ACCESS OBJECT AOIBMDR0 WHICH RETURNS THE      */
    /*             OBJECT NAME AT THE MACHINE'S PRESENT IBM          */
    /*             RELEASE LEVEL FOR OVERRIDE PURPOSES.              */
    /*    046778 - PROGRAM FELL OVER WHEN TRYING TO DELETE OVERRIDE, */
    /*             BECAUSE MONMSG WAS MISSING                        */
    /*    044847 - OVERRIDE FILES AS THEY HAVEN'T THE SAME NAME ON   */
    /*             DIFFERENT VERSIONS OF QUSRSYS.                    */
    /*    E38773 - TO DISPLAY PROMPT VALUES ON AMEND OR DELETE OF    */
    /*             REPORT REQUESTS                                   */
    /*    E36374 - Meaningless message sent at abnormal end.         */
    /*             Update to send a similar message to FCC0201/2     */
    /*    LN1144 - ADD COMMENTS TO THE PROGRAM                       */
    /*    LN1085 - CORRECT THE PROCESSING FOR TAKING F12 FROM        */
    /*             A PROMPT PROGRAM IN A SINGLE BRANCH SYSTEM        */
    /*    LN0073 - CLEAR COMMAND PARAMETER AFTER EXECUTION.          */
    /*                                                               */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGCL &CLSEQ &PGRPG &REPSEQI &PNAM +
                          &BRANCH &ACTION)
    /*                                                               */
             DCL        VAR(&PGCL) TYPE(*CHAR) LEN(10) /* CL program */
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLSEQ) TYPE(*CHAR) LEN(5)
    /*                                                               */
             DCL        VAR(&PGRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DISTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&REPSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&REPSEQI) TYPE(*CHAR) LEN(5)
             DCL        VAR(&REPSEQN) TYPE(*DEC) LEN(5)
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,FCC0203001                                          */
             DCL        VAR(&PARMX) TYPE(*CHAR) LEN(100)              /*E38773*/
/*/COPY WNCPYSRC,FCC0203002                                          */
             DCL        VAR(&NEXSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*LN1085*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*087482*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL        VAR(&OLDNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)        /*049424*076789*/
/************DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&VALUE) TYPE(*CHAR) LEN(50)        /*049424*076789*/
/************DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)        /*049424*076789*/
/**/                                                                  /*LN1144*/
/*  GLOBAL MONITOR MESSAGE                                            /*LN1144*/
/**/                                                                  /*LN1144*/
/************MONMSG     MSGID(RPG0000) EXEC(GOTO CMDLBL(ABNOR))       /*LN1144*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) +
                        EXEC(GOTO CMDLBL(ABNOR))                      /*LN1144*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,FCC0203003                                          */
    /*                                                               */
    /* Change Phase to 'Close of Business'                           */
             CHGVAR     VAR(&PHASE) VALUE('C')
    /*                                                               */
/***OBTAIN*THE*NEXT*REPORT*REQUEST*SEQUENCE*NUMBER***********/ /*LN1144 087482*/
/************RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&REPSEQ)             */ /*087482*/
    /*                                                               */
    /*  If 'Insert', increase request no. by 1 and                   */
    /*  update data area:REPSEQ                                      */
    /*                                                               */
             IF         COND(&ACTION = 'I') THEN(DO)
                                                                      /*087482*/
/***LOOP*UNTIL*DATA AREA REPSEQ IS ALLOCATED.           */ /*087482*/ /*115328*/
/*EPSEQ:                                                   /*087482*/ /*115328*/
/************CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)      /*087482*/ /*115328*/
/************IF         COND(&COUNT *LE 5) THEN(DO)        /*087482*/ /*115328*/
/************  ALCOBJ     OBJ((REPSEQ *DTAARA *EXCL))      /*087482*/ /*115328*/
/************  MONMSG     MSGID(CPF1002) EXEC(DO)          /*087482*/ /*115328*/
/************    DLYJOB     DLY(10)                        /*087482*/ /*115328*/
/************    GOTO       CMDLBL(REPSEQ)                 /*087482*/ /*115328*/
/************  ENDDO                                       /*087482*/ /*115328*/
/************ENDDO                                         /*087482*/ /*115328*/
/************ELSE       CMD(DO)                            /*087482*/ /*115328*/
/************  GOTO       CMDLBL(ABNOR)                    /*087482*/ /*115328*/
/************ENDDO                                         /*087482*/ /*115328*/
                                                                      /*087482*/
/*  OBTAIN THE NEXT REPORT REQUEST SEQUENCE NUMBER                 */ /*087482*/
                                                                      /*087482*/
             ALCOBJ     OBJ((REPSEQ *DTAARA *EXCL)) WAIT(60)          /*099929*/
             RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&REPSEQ)                /*087482*/
                                                                      /*087482*/
             CHGVAR     VAR(&NEXSEQ) VALUE(&REPSEQ)
             CHGVAR     VAR(&REPSEQN) VALUE(&REPSEQ)
             CHGVAR     VAR(&REPSEQN) VALUE(&REPSEQN + 1)
             CHGVAR     VAR(&REPSEQ) VALUE(&REPSEQN)
             CHGDTAARA  DTAARA(REPSEQ) VALUE(&REPSEQ)
                                                                      /*087482*/
/*  DEALLOCATE DATA AREA REPSEQ IMMEDIATELY AFTER UPDATE.          */ /*087482*/
                                                                      /*087482*/
             DLCOBJ     OBJ((REPSEQ *DTAARA *EXCL))                   /*087482*/
             ENDDO
/**/                                                                  /*LN1144*/
/*       ELSE IF ACTION CODE IS NOT 'I' FOR INSERT, USE THE           /*LN1144*/
/*       SEQUENCE NUMBER PASSED INTO THE PROGRAM                      /*LN1144*/
/**/                                                                  /*LN1144*/
/*           ELSE       CMD(CHGVAR VAR(&NEXSEQ) VALUE(&REPSEQI))      /*E38773*/
             ELSE       CMD(DO)                                       /*E38773*/
             CHGVAR     VAR(&NEXSEQ) VALUE(&REPSEQI)                  /*E38773*/
/*                                                                    /*E38773*/
/*      IF AN AMEND OR ENQUIRY,GET ORIGINAL PARAMETERS FROM FCPARPPD  /*E38773*/
/*                                                                    /*E38773*/
             OVRDBF     FILE(FCPARDL0) SHARE(*NO)                     /*E38773*/
/*                                                                    /*E38773*/
             CALL       PGM(FC0212) PARM(&PGRPG &NEXSEQ &PARMX)       /*E38773*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))                           /*E38773*/
/*                                                                    /*E38773*/
/*/COPY WNCPYSRC,FCC0203004                                          */
             CHGVAR     VAR(&PARAMETERS) VALUE(&PARMX)                /*E38773*/
/*/COPY WNCPYSRC,FCC0203005                                          */
             DLTOVR     FILE(FCPARDL0)                                /*E38773*/
             MONMSG     MSGID(CPF0000)                                /*044847*/
             ENDDO                                                    /*E38773*/
/*                                                                    /*E38773*/
/*  CALL FC0200 TO SET THE LEVEL OF THE REPORT REQUEST.               /*LN1144*/
/*  IN A SINGLE BRANCH SYSTEM THIS VALUE IS DEFAULTED AND NO SCREEN   /*LN1144*/
/*  WILL BE DISPLAYED.                                                /*LN1144*/
/*  IN A MULTIBRANCHED SYSTEM A REQUEST SCREEN IS DISPLAYED, IF THE   /*LN1144*/
/*  REPORT IS NOT A SYSTEM LEVEL REPORT AND THE USER IS AUTHORISED    /*LN1144*/
/*  TO REQUEST THE REPORT AT OTHER LEVELS.                            /*LN1144*/
    /*                                                               */
 FIRST:      CALL       PGM(FC0200) PARM(&LEVEL &ENTITY &DISTR &CMD +
                          &PGRPG &NEXSEQ &BRANCH &ACTION)
    /*                                                               */
    /* IF DATABASE ERROR OCCURRED                                    */
/*  EXIT PROGRAM USING DATABASE ERROR PROCESSING                      /*LN1144*/
    /*                                                               */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBEND))
    /*                                                               */
    /*                                                               */
    /**If*F3*or*F12*is*taken,*end*processing****************************LN1144*/
/*     IF F3 IS TAKEN                                                 /*LN1144*/
/*     FROM THE LEVEL REQUEST SCREEN, THEN EXIT THE PROGRAM           /*LN1144*/
    /*                                                               */
             IF         COND(&CMD = 'E') THEN(GOTO CMDLBL(THEEND))
    /*                                                               */
             CHGVAR     VAR(&CMD) VALUE(' ')                          /*LN0073*/
    /*                                                               */
/*  CALL THE PROMPT PROGRAM (&PNAM) FOR THIS REPORT                   /*LN1144*/
/**/                                                                  /*LN1144*/
/*/COPY WNCPYSRC,FCC0203006                                          */
                IF      COND(&PNAM = 'SD200205') THEN(DO)                               /*BUG24307*/
                CHGVAR  VAR(&NEXSEQ) VALUE(' ')                                         /*BUG24307*/
                ENDDO                                                                   /*BUG24422*/
                CALL       PGM(&PNAM) PARM(&NEXSEQ &LEVEL &ENTITY +
                                    &PARAMETERS &ACTION &CMD)
/**********     ENDDO                                                */        /*BUG24307 BUG24422*/
/*/COPY WNCPYSRC,FCC0203007                                          */
    /*                                                               */
/*  IF A DATABASE ERROR HAS OCCURRED, EXIT PROGRAM USING DATABASE     /*LN1144*/
/*  ERROR PROCESSING.                                                 /*LN1144*/
/**/                                                                  /*LN1144*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&ACTION) VALUE('T')
             GOTO       CMDLBL(DBEND)
             ENDDO
    /*                                                               */
    /*                                                               */
    /**If*F3*is*taken,*terminate*processing*****************************LN1144*/
/*  IF F3 IS TAKEN FROM THE PROMPT PROGRAM (PARAMETER PASSED BACK IS  /*LN1144*/
/*  'E'), THEN EXIT THE PROGRAM.                                      /*LN1144*/
/**/                                                                  /*LN1144*/
    /*                                                               */
             IF         COND(&CMD = 'E') THEN(DO)
             CHGVAR     VAR(&ACTION) VALUE('T')
             GOTO       CMDLBL(THEEND)
             ENDDO
    /*                                                               */
/**/                                                                  /*LN1085*/
/*  IF F12 IS TAKEN FROM THE PROMPT PROGRAM IN A SINGLE BRANCH SYSTEM /*LN1085*/
/*  (PARAMETER PASSED BACK IS 'F'), THEN EXIT THE PROGRAM             /*LN1085*/
/**/                                                                  /*LN1085*/
                RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)        /*LN1085*/
                IF         COND(&CMD = 'F' *AND &MBIN = 'N') THEN(+
                                GOTO CMDLBL(THEEND))                  /*LN1085*/
/**/                                                                  /*LN1085*/
/*  IF F12 IS TAKEN FROM THE PROMPT PROGRAM IN A MULTIBRANCHED SYSTEM /*LN1085*/
/*  (PARAMETER PASSED BACK IS 'F'), THEN REDISPLAY THE LEVEL SCREEN   /*LN1085*/
/**/                                                                  /*LN1085*/
    /*                                                               */
                IF         COND(&CMD = 'F') THEN(GOTO +
                             CMDLBL(FIRST))
/**/                                                                  /*LN1085*/
/**CHECK*THAT*PROGRAM*IS*RUNNING*ON*IBM*VERSION*2*****/    /*044847*/ /*049424*/
/**IF*ONE*OF*THE*FILES*EXISTS,*THEN*ALL*OF*THEM*WILL**/    /*044847*/ /*049424*/
/**IF*THEY*DO,*THEN*OVERRIDE*THE*FILES****************/    /*044847*/ /*049424*/
/**/                                                                  /*044847*/
/*********** CHKOBJ     OBJ(QAOKDY01) OBJTYPE(*FILE)       /*044847*/ /*049424*/
/*********** MONMSG  MSGID(CPF9801) EXEC(GOTO CMDLBL(MAIN))/*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDP01) TOFILE(QAOKDY01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
/*********** OVRDBF     FILE(QAOKLP02) TOFILE(QAOKLY02)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
/*********** OVRDBF     FILE(QAOKDL01) TOFILE(QAOKDG01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/* CHECK FOR RENAMED IBM FILES AND SETUP OVERRIDES IF NECCESSARY */   /*049424*/
 
/* DETERMINE THE MACHINE OPERATING SYSTEM LEVEL */                    /*049424*/
                                                                      /*049424*/
/******RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)   /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKDP01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDP01)          /*049424*074789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKLP02 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKLP02)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE LF/QAOKDL01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDL01)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*049424*/
 
 SKIP:                                                                /*044847*/
/**/                                                                  /*LN1085*/
/*  CALL FC0205 TO SET UP THE REPORT OUTPUT INSRUCTIONS.              /*LN1144*/
/*  IF THE USER IS NOT AUTHORISID TO SET THESE,                       /*LN1144*/
/*  THEN NO SCREEN WILL BE DISPLAYED.                                 /*LN1144*/
/**/                                                                  /*LN1144*/
/*/COPY WNCPYSRC,FCC0203008                                          */
             CALL       PGM(FC0205) PARM(&NEXSEQ &LEVEL &ENTITY +
                          &DISTR &PARAMETERS &CMD &PGRPG &PGCL &CLSEQ +
                          &PHASE &ACTION)
/*/COPY WNCPYSRC,FCC0203009                                          */
 
/************DLTOVR     FILE(QAOKDP01 QAOKLP02 QAOKDL01)     /*044847 /*076789*/
/************MONMSG     MSGID(CPF0000)                       /*044847 /*076789*/
/**/                                                                  /*LN1144*/
/*  IF A DATABASE ERROR HAS OCCURRED, EXIT PROGRAM USING DATABASE     /*LN1144*/
/*  ERROR PROCESSING.                                                 /*LN1144*/
/**/                                                                  /*LN1144*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))
    /*                                                               */
    /*                                                               */
/*  EXIT THE PROGRAM IF PROCESSING COMPLETES NORMALLY                 /*LN1144*/
/**/                                                                  /*LN1144*/
             GOTO       CMDLBL(THEEND)
    /*                                                               */
    /*                                                               */
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
/**/
 DBEND:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       ABNOR
             ENDDO
    /*                                                              */
/*  ABNORMAL TERMINATION PROCESSING                                   /*LN1144*/
/**/                                                                  /*LN1144*/
    /*                                                              */
/*BNOR:******SNDPGMMSG  MSG('R.C.F Input cycle initiation - +
/************             Terminated Abnormally') TOPGMQ(*EXT) +
/************             TOMSGQ(MOPERQ MRUNQ)                        /*E36374*/
 ABNOR:      SNDPGMMSG  MSGID(RCF1088) MSGF(FCUSRMSG) +
                          MSGDTA(&NEXSEQ) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*E36374*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
/**/                                                                  /*LN1144*/
/*  END OF PROGRAM PROCESSING                                         /*LN1144*/
/**/                                                                  /*LN1144*/
 THEEND:     RCLRSC
             DLCOBJ     OBJ((REPSEQ *DTAARA *EXCL))                   /*099929*/
             MONMSG     CPF0000                                       /*099929*/
             ENDPGM
