/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Pay/receive events non-input cycle')         */
/*********************************************************************/
/*                                                                   */
/*        Midas     - FUNDS TRANSFER MODULE                          */
/*                                                                   */
/*       FTC0635 - PAY/RECEIVE COMPONENT (END OF DAY)                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. 138077             Date 07Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      E40242         Date 19Jun92                  */
/*                      S01117         DATE   08AUG91                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       138077 - Journal the new PF/MGOEXTPD to resolve the problem */
/*                with several customers having the same SWIFT ID.   */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values       */
/*                set to CMTSCOPE(*JOB).                             */
/*       E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF              */
/*                MESSAGES GENERATED                                 */
/*       S01117 - REWRITTEN FOR RELEASE 10                           */
/*                                                                   */
/*********************************************************************/
 
  START:      PGM   PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
            DCL     VAR(&DATA)  TYPE(*CHAR) LEN(50)
            DCL     VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
            DCL     VAR(&MSG01) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG02) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG03) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG04) TYPE(*CHAR) LEN(1)
            DCL     VAR(&MSG05) TYPE(*CHAR) LEN(1)
            DCL     VAR(&RMODE) TYPE(*CHAR) LEN(1) VALUE(E)
            DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)
            DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5)
            DCL     VAR(&JLIB) TYPE(*CHAR) LEN(6)
            DCL     VAR(&PREFIX) TYPE(*CHAR) LEN(2)
            DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
            DCL     VAR(&MMOD) TYPE(*CHAR) LEN(256)
                                                                      /*E40242*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CCB009*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*/COPY WNCPYSRC,FTC0635002                                          */
 
             DCLF       FILE(SDMGMEPD)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(DBERR))
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/**/
            SNDPGMMSG MSG('FTC0635 - Pay/Receive Events ')  +
                          TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/*   If Restart, Remove Journalled Changes   */                       /*CCB009*/
/**/                                                                  /*CCB009*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                         */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)      /*CCB009*/
/**/                                                                  /*CCB009*/
/* If data area is not blank, calculate the job name, user and no. */ /*CCB009*/
/* of the previous run of this component.                             /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))   /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))  /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))   /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/**/                                                                  /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of job.                                      CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/*/COPY WNCPYSRC,FTC0635028                                          */
             RMVJRNCHG  JRN(ICJRN) FILE((OTPAYDD) (CQPACDD) +
                          (NTRANDD) (MGOREFPD) (MGOMSGPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
/*/COPY WNCPYSRC,FTC0635026                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
/*/COPY WNCPYSRC,FTC0635024                                          */
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*           RMVJRNCHG  JRN(FTTEMPJRN) FILE((OTPAYDD) (CQPACDD) +
                          (NTRANDD) (MGOREFPD) (MGOMSGPD))              CCB009*/
             RMVJRNCHG  JRN(JFTC0635) FILE((OTPAYDD) (CQPACDD) +
                          (NTRANDD) (MGOREFPD) (MGOMSGPD))            /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,FTC0635025                                          */
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,FTC0635003                                          */
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                      /**/
/* Journal transaction and message files */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JFTC0635)                      /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             DLTJRN     JRN(JFTC0635)                                 /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CCB009*/
             DLTJRNRCV  JRNRCV(JRFTC0635)                             /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CCB009*/
                                                                      /*CCB009*/
/*********   CRTJRNRCV  JRNRCV(&JLIB/FTTEMPRCV)                         CCB009*/
/*********   CRTJRN     JRN(&JLIB/FTTEMPJRN) JRNRCV(FTTEMPRCV)          CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRFTC0635)                       /*CCB009*/
             CRTJRN     JRN(&JLIB/JFTC0635) JRNRCV(JRFTC0635)         /*CCB009*/
 
/*/COPY WNCPYSRC,FTC0635013                                          */
/*           STRJRNPF   FILE(OTPAYDD CQPACDD NTRANDD +
                          MGOREFPD MGOMSGPD) JRN(FTTEMPJRN) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)                  CCB009*/
/**********  STRJRNPF   FILE(OTPAYDD CQPACDD NTRANDD +                /*138077*/
/**********               MGOREFPD MGOMSGPD) JRN(JFTC0635) +          /*138077*/
/**********               IMAGES(*BOTH) OMTJRNE(*NONE)     /*CCB009*/ /*138077*/
             STRJRNPF   FILE(OTPAYDD CQPACDD NTRANDD MGOEXTPD +
                          MGOREFPD MGOMSGPD) JRN(JFTC0635) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)                /*138077*/
/*/COPY WNCPYSRC,FTC0635022                                          */
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,FTC0635012                                          */
 
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/* Begin commitment control */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*    CREATE LDA IF NOT IN LIBRARY LIST - EG SUBMITTED JOB */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */         /*E40242*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
/**/                                                                  /*E40242*/
/*/COPY WNCPYSRC,FTC0635001                                          */
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 3 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0635)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*/COPY WNCPYSRC,FTC0635023                                          */
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 6 0  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0660) PARM(&RMODE &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 6 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0665) PARM(&RMODE &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 7 0  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0670) PARM(&RMODE &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 7 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0675)  PARM(&RMODE &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 4 1  - - -      **/
/*                    - - - - - - - - - - - -        */
/*/COPY WNCPYSRC,FTC0635018                                          */
        CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,FTC0635014                                          */
        CALL       PGM(FT0641)  PARM(&RMODE &MSG01 &RSEQ)
/*/COPY WNCPYSRC,FTC0635015                                          */
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 4 6  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
/*/COPY WNCPYSRC,FTC0635016                                          */
        CALL       PGM(FT0646)  PARM(&RMODE &MSG02 &RSEQ)
/*/COPY WNCPYSRC,FTC0635017                                          */
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 648   - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0648)  PARM(&RMODE &MSG05 &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
/*/COPY WNCPYSRC,FTC0635006                                          */
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 5 1  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0651)  PARM(&RMODE &MSG03 &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 5 6  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0656)  PARM(&RMODE &MSG04 &RSEQ)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*/COPY WNCPYSRC,FTC0635011                                          */
/* If ISO advices required (PF/SDMGMEPD, ENFFAR='N') print messages */
             RCVF
             IF         COND(&ENFFAR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             CALL PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG MSG('ISO print failure') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(DBERR)
             ENDDO
             ENDDO
/*/COPY WNCPYSRC,FTC0635010                                          */
 
/* Generate C.H.I.P.S. messages if interface present */
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(CALL PGM(CHC01))
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG MSG('C.H.I.P.S. message +
                          generation failure') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(DBERR)
             ENDDO
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*     A N Y   M E S S A G E   P R O D U C T I O N  ?      */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
/**/
/*/COPY WNCPYSRC,FTC0635007                                          */
             IF         COND((&MSG01 = 'Y') *OR (&MSG02 = 'Y') *OR +
                          (&MSG03 = 'Y') *OR (&MSG04 = 'Y') +
                          *OR (&MSG05 = 'Y')) THEN(DO)
/*/COPY WNCPYSRC,FTC0635008                                          */
/**/
             CHGDTAARA  DTAARA(FTSTAT (6 1)) VALUE('Y')
             ENDDO
/**/
        ELSE DO
/**/
             CHGDTAARA  DTAARA(FTSTAT (6 1)) VALUE('N')
             ENDDO
/**/
/**/
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 8 5  - - -      **/
/*                    - - - - - - - - - - - -        */
        CHGJOB     SWS(XXXXXX00)
        CALL       PGM(FT0685)
/**/
/**  Check for Database Errors Trapped by Program  **/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*/COPY WNCPYSRC,FTC0635004                                          */
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**       S U C C E S S F U L   C O M P L E T I O N       **/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
/**********  CALL       PGM(MEC0890) PARM('FT' 'P' 'FTTEMPJRN ' +  */                     /*CCB009*/
/**********               &SDATE &STIME)                                       /*E40242*/ /*CCB009*/
             CALL       PGM(MEC0890) PARM('FT' 'P' 'JFTC0635' +
                          &SDATE &STIME)                                                  /*CCB009*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)      /*E40242*/
/*/COPY WNCPYSRC,FTC0635009                                          */
                                                                      /*E40242*/
        GOTO END
/**/
/**  Report  Database  Errors Trapped by Program  **/
/**/
/*   IF SWITCHES OFF MUST BE A CPF MESSAGE SWITCH ON U7 U8  FOR  */
/*   RETURN TO COB CALLING PROGRAM TO HANDLE AS ERROR  */
/**/
 DBERR:      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(MCH0000 CPF0000 RPG0000)
/**/
             SNDPGMMSG  MSG('FUNDS TRANSFER PAY/RECEIVE COMPONENT +
                          FTC0635 FAILED') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(MCH0000 CPF0000 RPG0000)
/**/
             ENDDO
/**/
     ELSE DO
           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             MONMSG     MSGID(MCH0000 CPF0000 RPG0000)
           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                      TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(MCH0000 CPF0000 RPG0000)
             ENDDO
 
/* Recover message and transaction files */
 
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve attributes of current job.                                 CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/*/COPY WNCPYSRC,FTC0635029                                          */
             RMVJRNCHG  JRN(ICJRN) FILE((OTPAYDD) (CQPACDD) +
                          (NTRANDD) (MGOREFPD) (MGOMSGPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
/*/COPY WNCPYSRC,FTC0635027                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
/*/COPY WNCPYSRC,FTC0635021                                          */
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/**********  RMVJRNCHG  JRN(FTTEMPJRN) FILE((OTPAYDD) (CQPACDD) +     /*CCB009*/
/**********               (NTRANDD) (MGOREFPD) (MGOMSGPD))            /*CCB009*/
/*/COPY WNCPYSRC,FTC0635019                                          */
             RMVJRNCHG  JRN(JFTC0635) FILE((OTPAYDD) (CQPACDD) +
                          (NTRANDD) (MGOREFPD) (MGOMSGPD) (MGOEXTPD)) /*138077*/
/***********              (NTRANDD) (MGOREFPD) (MGOMSGPD)) **/ /*CCB009 138077*/
/*/COPY WNCPYSRC,FTC0635020                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                    /*CCB009*/
 
END:         ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/*           ENDJRNPF   FILE(*ALL) JRN(&JLIB/FTTEMPJRN)                 CCB009*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                  CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JFTC0635)                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
 
/*           DLTJRN     JRN(&JLIB/FTTEMPJRN)                            CCB009*/
             DLTJRN     JRN(&JLIB/JFTC0635)                           /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGJOB     INQMSGRPY(*DFT)
/*           DLTJRNRCV  JRNRCV(&JLIB/FTTEMPRCV)                         CCB009*/
             DLTJRNRCV  JRNRCV(&JLIB/JRFTC0635)                       /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/*/COPY WNCPYSRC,FTC0635005                                          */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
 ENDPGM
