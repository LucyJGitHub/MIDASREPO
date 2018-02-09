/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC I/C Init. Rpt reqs. - no prompt')            */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module                   */
    /*                                                               */
    /*  FCC0202A- I/C INIT REPORT REQ.WITHOUT MODULE SPECIFIC PROMPT */
    /*                                                               */
/*       (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 115328             Date 27Jan98              */
/*                      099929             Date 31May96              */
    /*                 087482                DATE 03OCT95            */
    /*                 076789                DATE 03OCT94            */
    /*                 049424                DATE 11JAN93            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
/*       MD046248 - Finastra Rebranding                              */
    /*  115328 - Remove part of previous fix 087482 in order to      */
    /*           prevent lock on *DTAARA REPSEQ.                     */
    /*  099929 - Allocate dtaara/repseq exclusively, as              */
    /*           sometimes get two jobs updating it with the same    */
    /*           value causing duplicate record on fcrreql0.         */
    /*  087482 - Repseq is accessed for the the next key by more     */
    /*           than one program and then a record writen           */
    /*           causing an error of duplicate record written.       */
    /*           fix is to allocate obj and dealocate obj of         */
    /*           data area REPSEQ                                    */
    /*  076789 - Overrides moved to MLC0000                          */
    /*  049424 - IBM HAVE RENAMED THE OFFICE FILES AGAIN AT          */
    /*           V2R2. THE PROGRAM HAS BEEN AMENDED TO CALL A        */
    /*           NEW ACCESS OBJECT AOIBMDR0 WHICH RETURNS THE        */
    /*           OBJECT NAME AT THE MACHINE'S PRESENT IBM            */
    /*           RELEASE LEVEL FOR OVERRIDE PURPOSES.                */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGCL &CLSEQ &PGRPG &REPSEQI &BRANCH +
                          &ACTION)
    /*                                                               */
             DCL        VAR(&PGCL) TYPE(*CHAR) LEN(10) /* CL program */
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLSEQ) TYPE(*CHAR) LEN(5)
    /*                                                               */
             DCL        VAR(&PGRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGCL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DISTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&REPSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&REPSEQN) TYPE(*DEC) LEN(5)
             DCL        VAR(&REPSEQI) TYPE(*CHAR) LEN(5)
/*/COPY WNCPYSRC,FCC0202A01                                          */
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,FCC0202A02                                          */
             DCL        VAR(&NEXSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*087482*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FCC0202A03                                          */
             DCL        VAR(&PARMSTRING) TYPE(*CHAR) LEN(101)
/*/COPY WNCPYSRC,FCC0202A04                                          */
/************DCL        VAR(&OLDNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)        /*049424*076789*/
/************DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&VALUE) TYPE(*CHAR) LEN(50)        /*049424*076789*/
/************DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)        /*049424*076789*/
/**/
/*  GLOBAL MONITOR MESSAGE                                            */
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) +
                        EXEC(GOTO CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/***OBTAIN*THE*NEXT*REPORT*REQUEST*SEQUENCE*NUMBER***              */ /*087482*/
/************RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&REPSEQ)             */ /*087482*/
    /*                                                               */
    /* Change Phase to 'Input Cycle'                                 */
/*       AND SET THE ACTION CODE TO 'I' FOR INSERT                   */
    /*                                                               */
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&PHASE) VALUE('I')
             CHGVAR     VAR(&ACTION) VALUE('I')
/**/
/***LOOP*UNTIL*DATA AREA REPSEQ IS ALLOCATED.          */  /*087482*/ /*115328*/
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
/************                                              /*087482*/ /*115328*/
/***OBTAIN*THE NEXT REPORT REQUEST SEQUENCE NUMBER      */ /*087482*/ /*115328*/
                                                                      /*087482*/
             ALCOBJ     OBJ((REPSEQ *DTAARA *EXCL)) WAIT(60)          /*099929*/
             RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&REPSEQ)                /*087482*/
                                                                      /*087482*/
/*  RESET THE NEXT REPORT REQUEST SEQUENCE NUMBER IN THE DATA AREA    */
/**/
             CHGVAR     VAR(&NEXSEQ) VALUE(&REPSEQ)
             CHGVAR     VAR(&REPSEQN) VALUE(&REPSEQ)
             CHGVAR     VAR(&REPSEQN) VALUE(&REPSEQN + 1)
             CHGVAR     VAR(&REPSEQ) VALUE(&REPSEQN)
             CHGDTAARA  DTAARA(REPSEQ) VALUE(&REPSEQ)
                                                                      /*087482*/
/*  DEALLOCATE DATA AREA REPSEQ IMMEDIATELY AFTER UPDATE.          */ /*087482*/
                                                                      /*087482*/
             DLCOBJ     OBJ((REPSEQ *DTAARA *EXCL))                   /*087482*/
    /*                                                               */
/*  CALL FC0200 TO SET THE LEVEL OF THE REPORT REQUEST.              */
/*  IN A SINGLE BRANCH SYSTEM THIS VALUE IS DEFAULTED AND NO SCREEN  */
/*  WILL BE DISPLAYED.                                               */
/*  IN A MULTIBRANCHED SYSTEM A REQUEST SCREEN IS DISPLAYED, IF THE  */
/*  REPORT IS NOT A SYSTEM LEVEL REPORT AND THE USER IS AUTHORISED   */
/*  TO REQUEST THE REPORT AT OTHER LEVELS.                           */
/**/
 
             CALL       PGM(FC0200) PARM(&LEVEL &ENTITY &DISTR &CMD +
                          &PGRPG &NEXSEQ &BRANCH &ACTION)
/**/
/*  IF DATABASE ERROR OCCURRED                                       */
/*  EXIT PROGRAM USING DATABASE ERROR PROCESSING                     */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))
/**/
/*     IF F3 IS TAKEN                                                */
/*     FROM THE LEVEL REQUEST SCREEN, THEN EXIT THE PROGRAM          */
/**/
             IF         COND(&CMD = 'E') THEN(GOTO CMDLBL(THEEND))
                                                                      /*049424*/
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
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
 SKIP:                                                                /*049424*/
    /*                                                               */
/*  CALL FC0205 TO SET UP THE REPORT OUTPUT INSRUCTIONS.             */
/*  IF THE USER IS NOT AUTHORISID TO SET THESE,                      */
/*  THEN NO SCREEN WILL BE DISPLAYED.                                */
/**/
             CALL       PGM(FC0205) PARM(&NEXSEQ &LEVEL &ENTITY +
                          &DISTR &PARAMETERS &CMD &PGRPG &PGCL &CLSEQ +
                          &PHASE &ACTION)
/**/
/*  IF A DATABASE ERROR HAS OCCURRED, EXIT PROGRAM USING DATABASE    */
/*  ERROR PROCESSING.                                                */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))
/**/
/*  IF F3 IS TAKEN FROM THE PROMPT PROGRAM (PARAMETER PASSED BACK IS */
/*  'E'), THEN EXIT THE PROGRAM.                                     */
/**/
                IF         COND(&CMD = 'E') THEN(GOTO +
                             CMDLBL(THEEND))
 
/*/COPY WNCPYSRC,FCC0202A05                                          */
/*  ADD REPORT PARAMETERS TO PARAMETER STRING  */
 
             CHGVAR     VAR(%SST(&PARMSTRING 1 100)) +
                          VALUE(&PARAMETERS)
 
/*  ADD CONTROL CHARACTER TO PROTECT TRAILING BLANKS  */
 
             CHGVAR     VAR(%SST(&PARMSTRING 101 1)) VALUE('@')
/*/COPY WNCPYSRC,FCC0202A06                                          */
 
/*  CALL  FCC0200A TO APPLY MULTILANGUAGE OVERRIDES AND  */
/*  TO CALL THE REPORT PROGRAM                           */
 
                          CALL PGM(FCC0200A) PARM(&PGCL &NEXSEQ +
                          &LEVEL &ENTITY &PARMSTRING &PGRPG +
                          &CLSEQ)
    /*                                                               */
/*  EXIT THE PROGRAM IF PROCESSING COMPLETES NORMALLY                */
/**/
             GOTO       CMDLBL(THEEND)
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
    /*                                                               */
/*  ABNORMAL TERMINATION PROCESSING                                  */
/**/
 ABNOR:      SNDPGMMSG  MSGID(RCF1088) MSGF(FCUSRMSG) +
                          MSGDTA(&NEXSEQ) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
/**/
/*  END OF PROGRAM PROCESSING                                        */
/**/
 THEEND:     RCLRSC
             DLCOBJ     OBJ((REPSEQ *DTAARA *EXCL))                   /*099929*/
             MONMSG     CPF0000                                       /*099929*/
             ENDPGM
