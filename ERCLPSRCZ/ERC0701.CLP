/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Interface to FRS Main Component')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0701 - European Reporting (Switzerland)                  */
/*                 Interface to Frs main component                   */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX046             Date 31Oct02              */
/*                      ULX040             Date 20Feb01              */
/*                      132893             Date 14APR98              */
/*                      CADAG              Date 26AUG98              */
/*                      CAD009 PT          Date 30JUL98              */
/*                      ULX004             Date 28MAR97              */
/*                      ART021 PT          Date 16SEP96              */
/*                      ERL414 PT          Date 26JUL94              */
/*                      VLFIX              Date 23JUN94              */
/*                      68685  PT          Date 04MAR94              */
/*                      ERL371 TLI         Date 15NOV93              */
/*                      50314  ADI         Date 27MAY93              */
/*                      ER0336 TLI         Date 16APR93              */
/*                      ER0126             Date 17NOV92         ThL  */
/*                      ER1004             Date 03NOV92         ThL  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX046 - Circulars 2002/170-174-175 Integration             */
/*       ULX040 - FIRE - RT30 Generation in Midas                    */
/*                Add &PREFIX when CALL ERC0702                      */
/*       132893 - SPF/RCF for IBLC/BNB on DBA2.3                     */
/*       CADAG  - Save data in file 1 and 4 if EOM = 'Y'             */
/*       CAD009 - To delete security copy files                      */
/*       ULX004 - Capital Adequacy                                   */
/*       ART021 - SNB ARTICLE 21 DEVELOPMENT                         */
/*       ERL414 - PGM/ERUNQP INCORRECTLY MONITORED                   */
/*                CRTADTAARA/LDA NOT MONITORED                       */
/*                DIFFERENT ENHANCEMENTS (DUE TO RCLRSC)             */
/*       VLFIX  - MOPERQ BREAK MSG                                   */
/*       68685  - IML 1.2 COLUMN 13 RECORDS GENERATION               */
/*       ERL371 - IML 1.4 DEVELOPMENT                                */
/*       50314  - ADD AUDIT CONTROL LIST                             */
/*       ER0336 - IML 2.3 DEVELOPMENT - Add Sequence number parameter*/
/*       ER0126 - 1. Review Restart processing .                     */
/*                2. Include Audit trail processing.                 */
/*       ER1004 - Clear specific  output files before processing     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&PREFIX)
 
/* >>>> 132893 >>>> */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
/* >>>> 132893 >>>> */
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)     /* MIDAS +
                          subsystem prefix */
             DCL        VAR(&BJMRDT) TYPE(*CHAR) LEN(7) /* MIDAS +
                          report date */
             DCL        VAR(&BJURPT) TYPE(*CHAR) LEN(53) /* Title */
             DCL        VAR(&XXDTALIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS Msg files library */
 /********** DCL        VAR(&XXCADLIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS ER Data base library               */       /*ULX004 CER001*/
             DCL        VAR(&XXDILIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS ER Data base library        CADAG */
             DCL        VAR(&ERPGM) TYPE(*CHAR) LEN(10) +
                          VALUE('ERxx60') /* MIDAS ER Specific +
                          processing pgm by country */
             DCL        VAR(&ERAUD) TYPE(*CHAR) LEN(10) +
                          VALUE('ERxx85') /* MIDAS ER Specific +
                          Audit trail  - ER0126 */
   /*        DCL        VAR(&ERXXTRPD) TYPE(*CHAR) LEN(10) +
                          VALUE('ERxxTRPD') /* MIDAS ER Output +
                          extract file, specific to each ctry       ER1004 */
             DCL        VAR(&SVDATE) TYPE(*CHAR) LEN(7) /* Last save +
                          date */
             DCL        VAR(&SVDEVTYP1) TYPE(*CHAR) LEN(5) /* Save +
                          device type at start of job (1)*/
             DCL        VAR(&SVDEVNAM1) TYPE(*CHAR) LEN(10) /* Device +
                           OR Save file name (1) */
             DCL        VAR(&SVIND1) TYPE(*CHAR) LEN(1) /* Save 1 +
                          Completion indicator */
             DCL        VAR(&SVDEVTYP2) TYPE(*CHAR) LEN(5) /* Save +
                          device type at end of job, before download +
                          to PC (2)*/
             DCL        VAR(&SVDEVNAM2) TYPE(*CHAR) LEN(10) /* Device +
                          name OR Save file name (2) */
             DCL        VAR(&SVIND2) TYPE(*CHAR) LEN(1) /* Save 2 +
                          Completion indicator */
             DCL        VAR(&RPTGLIND) TYPE(*CHAR) LEN(1) /* +
                          Interface Processing Completion Global +
                          Indicator */
             DCL        VAR(&NBRCTRY) TYPE(*DEC) LEN(2 0) VALUE(0) +
                          /* Nbr of ctries defined on ER ICD */
             DCL        VAR(&NBRREPT) TYPE(*DEC) LEN(2 0) VALUE(0) +
                          /* Nbr of REPT'S defined on ER ICD */
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1) /* Reply to +
                          message */
             DCL        VAR(&FLAGPOS) TYPE(*DEC) LEN(2 0) VALUE(41) +
                          /* ER Job control Flag position */
             DCL        VAR(&ERPGMPOS) TYPE(*DEC) LEN(3 0) VALUE(61) +
                          /* ER Pgm corresponding to Flag position */
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(52)  /* Error +
                          Message data */
             DCL        VAR(&LASTSQ) TYPE(*DEC) LEN(6 0) /* Last +
                          Record Sequence number generated - ER0336 */
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1) /* Return code ERL414 */
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1) VALUE('N')      /*ART021*/
             DCL        VAR(&EOY) TYPE(*CHAR) LEN(1) VALUE('N')      /*ART021*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) +
                         VALUE('(c) Finastra International Limited +
                               2005')                                 /*ULX004*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')     /*ULX004*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*ULX046*/
             DCL        VAR(&ULX046)  TYPE(*CHAR) LEN(1) VALUE('N')   /*ULX046*/
             DCL        VAR(&XXDMLIB) TYPE(*CHAR) LEN(10)                                 /*CER001*/
 
/**********  DCLF       FILE(ERICDRPD) RCDFMT(ERICDRD0)                    */             /*CER001*/
             DCLF       FILE(ERICDXPD) RCDFMT(ERICDRD0)                                   /*CER001*/
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/*=========================  INIT  ===============================*/
/*           SNDMSG     MSG('ERREPORT Job started') TOMSGQ(MOPERQ +
                          MRUNQ) */                            /* 50314 */
             SNDMSG     MSG('ERREPORT Job started') TOMSGQ(MRUNQ) /* +
                          VLFIX */
             MONMSG     MSGID(CPF0000 MCH0000)                 /* 50314 */
/* Reset External Switches and ER msgq */
             CHGJOB     SWS(00000000)
/************CLRMSGQ    MSGQ(ERMSGQ)                                  /*ULX004*/
/**********  CLRMSGQ    MSGQ(CADMSGQ)                                      */      /*ULX004 CER001*/
             MONMSG CPF0000
 
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Local data area')
/* Create local data area only if it does not exist                  */
             MONMSG     MSGID(CPF1023)                     /* ERL414 */
 
/*                                                                   */
/************CHGVAR     VAR(&XXERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')    ULX004*/
/**********  CHGVAR     VAR(&XXCADLIB) VALUE(&PREFIX *CAT 'CADLIB')       */       /*ULX004 CER001*/
             CHGVAR     VAR(&XXDILIB) VALUE(&PREFIX *CAT 'DILIB')    /*CADAG*/
             CHGVAR     VAR(&XXDTALIB) VALUE(&PREFIX *CAT 'DTALIB')
             CHGVAR     VAR(&XXDMLIB) VALUE(&PREFIX *CAT 'DMLIB')                        /*CER001*/
 
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY'   +
                          'ULX046')                                   /*ULX046*/
             IF         COND(&RETCOD = '      ') THEN(CHGVAR +
                          VAR(&ULX046) VALUE('Y'))                    /*ULX046*/
 
/*=============== CHECK WETHER REPORTING IS REQUIRED =============*/
 
/* Determine number of countries for which reporting has to be made  */
             CALL       PGM(ERC0701A) PARM(&NBRCTRY &NBRREPT) /* +
                          Calculate nbr of Countries defined in ER +
                          ICD and nbr of Required Reportings */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))
 
             IF         COND(&NBRCTRY *EQ 0)      THEN(DO)
             SNDPGMMSG  MSG('REPORTING INTERFACE. No Statutory +
                          Reporting Defined in ER ICD. Job ends.')
             GOTO       CMDLBL(EOJ)
                                                        ENDDO
 
             IF         COND(&NBRREPT *EQ 0)      THEN(DO)
/*OREPT:*****SNDPGMMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') TOMSGQ(ERMSGQ)                 50314 ULX004 */
/***NOREPT:*****SNDPGMMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') TOMSGQ(CADMSGQ)                         */      /* ULX004 CER001*/
 NOREPT:     SNDPGMMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') TOMSGQ(MOPERQ)                                          /*CER001*/
                                                                                          /*CER001*/
/* NOREPT: 50314      SNDUSRMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') MSGTYPE(*INQ) +
                          TOMSGQ(*LIBL/ERMSGQ) MSGRPY(&REPLY)        /*ULX004*/
/*** /**NOREPT:*50314* /   SNDUSRMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') MSGTYPE(*INQ) +
                          TOMSGQ(*LIBL/CADMSGQ) MSGRPY(&REPLY)            */       /*ULX004 CER001*/
                                                                                          /*CER001*/
                          SNDUSRMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') MSGTYPE(*INQ) +
                          TOMSGQ(*LIBL/MOPERQ) MSGRPY(&REPLY)                             /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&REPLY *EQ 'C' *OR &REPLY *EQ 'c') +
                          THEN(GOTO CMDLBL(EOJ))
             IF         COND(&REPLY *EQ 'Y' *OR &REPLY *EQ 'y') +
                          THEN(GOTO CMDLBL(SAV1))
             GOTO       CMDLBL(NOREPT)
                                                        ENDDO
 
/*================== CHECK WETHER IT IS A RESTART =================*/
 
/* Retrieve run date       */
             CALL       PGM(ERC0701B) PARM(&BJMRDT &BJURPT)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))
 
/* Retrieve last reporting/save date, device type, device name      */
/* Update control data area with default values if setup incomplete */
             RTVDTAARA  DTAARA(ERCTLD (1 7)) RTNVAR(&SVDATE)
             RTVDTAARA  DTAARA(ERCTLD (8 5)) RTNVAR(&SVDEVTYP1)
             RTVDTAARA  DTAARA(ERCTLD (13 10)) RTNVAR(&SVDEVNAM1)
             RTVDTAARA  DTAARA(ERCTLD (23 1)) RTNVAR(&SVIND1)
             RTVDTAARA  DTAARA(ERCTLD (24 5)) RTNVAR(&SVDEVTYP2)
             RTVDTAARA  DTAARA(ERCTLD (29 10)) RTNVAR(&SVDEVNAM2)
             RTVDTAARA  DTAARA(ERCTLD (39 1)) RTNVAR(&SVIND2)
 
             RTVDTAARA  DTAARA(ERCTLD (40 1)) RTNVAR(&RPTGLIND)
 
     /*      IF         COND(&SVDEVTYP1 *EQ *BLANK *AND &SVDEVNAM1 *EQ +
                          *BLANK) THEN(DO)                       -- ER0126 */
             IF         COND(&SVDEVTYP1 *EQ *BLANK *OR  &SVDEVNAM1 *EQ +
                          *BLANK) THEN(DO)                       /* ER0126 */
             CHGVAR     VAR(&SVDEVTYP1) VALUE('*SAVF')
/************CHGVAR     VAR(&SVDEVNAM1) VALUE('ERSAVF1')               ULX004*/
             CHGVAR     VAR(&SVDEVNAM1) VALUE('ERSAVF3')             /*ULX004*/
             CHGVAR     VAR(&SVIND1) VALUE('N')                  /* ER0126 */
             CHGDTAARA  DTAARA(ERCTLD (8 5)) VALUE(&SVDEVTYP1)
             CHGDTAARA  DTAARA(ERCTLD (13 10)) VALUE(&SVDEVNAM1)
             CHGDTAARA  DTAARA(ERCTLD (23 1)) VALUE('N')        /* ER0126 */
             CHGDTAARA  DTAARA(ERCTLD (40 1)) VALUE('N')        /* ER0126 */
                                       ENDDO
 
     /*      IF         COND(&SVDEVTYP2 *EQ *BLANK *AND &SVDEVNAM2 *EQ +
                          *BLANK) THEN(DO)                       -- ER0126 */
             IF         COND(&SVDEVTYP2 *EQ *BLANK *OR  &SVDEVNAM2 *EQ +
                          *BLANK) THEN(DO)                       /* ER0126 */
             CHGVAR     VAR(&SVDEVTYP2) VALUE('*SAVF')
/************CHGVAR     VAR(&SVDEVNAM2) VALUE('ERSAVF2')              ULX004*/
             CHGVAR     VAR(&SVDEVNAM2) VALUE('ERSAVF4')            /*ULX004*/
             CHGVAR     VAR(&SVIND2) VALUE('N')                  /* ER0126 */
             CHGDTAARA  DTAARA(ERCTLD (24 5)) VALUE(&SVDEVTYP2)
             CHGDTAARA  DTAARA(ERCTLD (29 10)) VALUE(&SVDEVNAM2)
             CHGDTAARA  DTAARA(ERCTLD (39 2)) VALUE('NN')       /* ER0126 */
                                       ENDDO
 
/* Not a restart :                                       */
             IF         COND(&BJMRDT *NE &SVDATE) THEN(GOTO +
                          CMDLBL(SAV1))
 
/*====================== RESTART =================================*/
 
/* Restart but ER Data base not saved yet :             */
             IF         COND(&SVIND1 *NE 'Y') THEN(GOTO +
                          CMDLBL(SAV1)) /* Save 1 not done */
 
/* Restart with ER Data base already saved :            */
/*SG1:*******SNDPGMMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') TOMSGQ(ERMSGQ)    * 50314 ULX004 */
/***MSG1:*******SNDPGMMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') TOMSGQ(CADMSGQ)              */      /* ULX004 CER001*/
 MSG1:       SNDPGMMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') TOMSGQ(MOPERQ)                               /*CER001*/
                                                                                          /*CER001*/
/* MSG1: 50314        SNDUSRMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') MSGTYPE(*INQ) +
                          TOMSGQ(ERMSGQ) MSGRPY(&REPLY)                *ULX004*/
/*** /* MSG1: 50314* /*****SNDUSRMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') MSGTYPE(*INQ) +
                          TOMSGQ(CADMSGQ) MSGRPY(&REPLY)                  */ /*ULX004 CER001*/
             SNDUSRMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') MSGTYPE(*INQ) +
                          TOMSGQ(MOPERQ) MSGRPY(&REPLY)                                   /*CER001*/
             IF         COND(&REPLY *EQ 'R' *OR &REPLY *EQ 'r') +
                          THEN(GOTO CMDLBL(SAV1))
             IF         COND(&REPLY *EQ 'C' *OR &REPLY *EQ 'c') +
                          THEN(GOTO CMDLBL(EOJ))
             IF         COND(&REPLY *EQ 'B' *OR &REPLY *EQ 'b') +
                          THEN(GOTO CMDLBL(RESTART))
             GOTO       CMDLBL(MSG1)
 
 
/*================== START OF JOB BACK-UP (1) ====================*/
 
/* Save UNIQUE European Reporting Data Base Library               */
 SAV1:       CHGDTAARA  DTAARA(ERCTLD (23 1)) VALUE('N')
             CHGDTAARA  DTAARA(ERCTLD (1 7)) VALUE(&BJMRDT)
 
/* Save parameters :  save file OR tape OR diskette  */
/************SNDPGMMSG  MSG('First Database Save running') +
                        TOMSGQ(ERMSGQ)                         /* 50314 ULX004*/
/**********  SNDPGMMSG  MSG('First Database Save running') +
                        TOMSGQ(CADMSGQ)                                   */      /* ULX004 CER001*/
             SNDPGMMSG  MSG('First Database Save running') +
                          TOMSGQ(MOPERQ)                                                  /*CER001*/
                                                                                          /*CER001*/
/*********** IF         COND(&SVDEVTYP1 *EQ '*SAVF') THEN(SAVLIB +
                          LIB(&XXERDLIB) DEV(*SAVF) SAVF(&SVDEVNAM1) +
                          CLEAR(*ALL))                                 ULX004*/
/**********  IF         COND(&SVDEVTYP1 *EQ '*SAVF') THEN(SAVLIB +
                          LIB(&XXCADLIB) DEV(*SAVF) SAVF(&SVDEVNAM1) +
                          CLEAR(*ALL))                                    */       /*ULX004 CER001*/
             IF         COND(&SVDEVTYP1 *EQ '*SAVF') THEN(SAVOBJ +
                          OBJ(DLACOXPD REACX2PD ERBKPXPD +
                          LECLX2PD SEDPX2PD ERBNKXPD +
                          ERBKIXPD ERBCHXPD ERCTYXPD +
                          ERCCYXPD ERDEAXPD EREXTXPD +
                          ERGUCXPD ERICDXPD ERLACXPD +
                          ERLCAXPD ERLCPXPD ERLD1XPD +
                          ERLD2XPD ERLD5XPD ERLD6XPD +
                          ERLICXPD ERLUBXPD ERLTRXPD +
                          ERLTTXPD ERL12XPD ERL28XPD +
                          ERL29XPD ERLVNXPD EROUTXPD +
                          ERPTHXPD ERPCDXPD LEFCX4PD +
                          FDDSX2PD DLFWDXPD DLFWEXPD +
                          LEGUX2PD LEHIMXPD LEHIPXPD +
                          LEHIQXPD FFITX4PD SEINVXPD +
                          SEINX3PD LEACX2PD DLLMX2PD +
                          FFMCX2PD MMDLX2PD MMDBX3PD +
                          MMDBX4PD SDACX4PD SDBKX3PD +
                          SDBKX4PD SDBRX4PD SDCTX4PD +
                          SDCCYXPD SDCUX4PD SDDSX2PD +
                          SDFCX2PD SDFOX2PD SDGELXPD +
                          SDHOLXPD SDINX2PD SDLNX2PD +
                          SESEDXPD SESDX5PD SESDX6PD +
                          SEMKX2PD SETRX2PD FFTRX4PD) +
                          LIB(&XXDMLIB) DEV(*SAVF) OBJTYPE(*FILE) +
                          SAVF(&SVDEVNAM1) CLEAR(*ALL))                                   /*CER001*/
                                                                                          /*CER001*/
/************ELSE       CMD(SAVLIB LIB(&XXERDLIB) DEV(&SVDEVNAM1) +
                          VOL(*MOUNTED) ENDOPT(*UNLOAD))              ULX004*/
/**********  ELSE       CMD(SAVLIB LIB(&XXCADLIB) DEV(&SVDEVNAM1) +
                          VOL(*MOUNTED) ENDOPT(*UNLOAD))                  */       /*ULX004 CER001*/
 
             ELSE       CMD(SAVOBJ OBJ(DLACOXPD REACX2PD ERBKPXPD +
                          LECLX2PD SEDPX2PD ERBNKXPD ERBKIXPD +
                          ERBCHXPD ERCTYXPD ERCCYXPD ERDEAXPD +
                          EREXTXPD ERGUCXPD ERICDXPD ERLACXPD +
                          ERLCAXPD ERLCPXPD ERLD1XPD ERLD2XPD +
                          ERLD5XPD ERLD6XPD ERLICXPD ERLUBXPD +
                          ERLTRXPD ERLTTXPD ERL12XPD ERL28XPD +
                          ERL29XPD ERLVNXPD EROUTXPD ERPTHXPD +
                          ERPCDXPD LEFCX4PD FDDSX2PD DLFWDXPD +
                          DLFWEXPD LEGUX2PD LEHIMXPD LEHIPXPD +
                          LEHIQXPD FFITX4PD SEINVXPD SEINX3PD +
                          LEACX2PD DLLMX2PD FFMCX2PD MMDLX2PD +
                          MMDBX3PD MMDBX4PD SDACX4PD SDBKX3PD +
                          SDBKX4PD SDBRX4PD SDCTX4PD SDCCYXPD +
                          SDCUX4PD SDDSX2PD SDFCX2PD SDFOX2PD +
                          SDGELXPD SDHOLXPD SDINX2PD SDLNX2PD +
                          SESEDXPD SESDX5PD SESDX6PD SEMKX2PD +
                          SETRX2PD FFTRX4PD) LIB(&XXDMLIB) +
                          DEV(&SVDEVNAM1) OBJTYPE(*FILE) +
                          ENDOPT(*UNLOAD))                                                /*CER001*/
                                                                                          /*CER001*/
             CHGDTAARA  DTAARA(ERCTLD (23 1)) VALUE('Y')
 
             IF         COND(&NBRREPT *EQ 0) THEN(GOTO CMDLBL(EOJ)) +
                          /* No reporting Requirement has been +
                          defined. Save has been requested and +
                          executed . Job ends */
 
/*===================== RESTART CONTROL ======================*/
 
 RESTART:
 
  /* ER0126 BEGINS -   THE FOLLOWING LINES ARE FLAGGED */
  /*         IF         COND(&RPTGLIND *NE 'Y') THEN(GOTO +
                          CMDLBL(REPT)) -- Interface processing not +
                          executed yet --                                +
                                                                         +
-- Restart when Interface Processing or 2nd back-up already executed --  +
   MSG2:         SNDUSRMSG  MSG('REPORTING INTERFACE EXECUTION ALREADY DONE. +
                          Reply "R" to restart Reporting Interface . +
                          Reply "C" to cancel job . +
                          Reply "B" to bypass Reporting Interface , +
                          and continue with the 2nd save operation.') +
                          MSGTYPE(*INQ) +
                          TOMSGQ(ERMSGQ) MSGRPY(&REPLY)                  +
             IF         COND(&REPLY *EQ 'R' *OR &REPLY *EQ 'r') +
                          THEN(GOTO CMDLBL(REPT))                        +
             IF         COND(&REPLY *EQ 'C' *OR &REPLY *EQ 'c') +
                          THEN(GOTO CMDLBL(EOJ))                         +
             IF         COND(&REPLY *EQ 'B' *OR &REPLY *EQ 'b') +
                          THEN(GOTO CMDLBL(SAV2))                        +
             GOTO       CMDLBL(MSG2)                                  */
  /* ER0126  ENDS  -   THE PRECEDING LINES ARE FLAGGED */
 
/*===================  REPORTING BY COUNTRY ========================*/
 
 REPT:
             CHGDTAARA  DTAARA(ERCTLD (40 1)) VALUE('N') /* +
                          Reporting Interface Completion General +
                          Indicator */
 
/* Execute FRS Interface corresponding to each country            */
 REPTLOOP:   RCVF       RCDFMT(ERICDRD0)
/*****   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(SAV2))             ULX004 */
         MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(CAD))           /* ULX004 */
 
/* ----------------------------------------------------------------- B1 */
             IF         COND(&VDICCD *NE *BLANK *AND &VDUCCD *NE +
                          BLANK) THEN(DO)
 
             CHGVAR     VAR(%SST(&ERPGM 3 2)) VALUE(&VDICCD)
             CHGVAR     VAR(%SST(&ERAUD 3 2)) VALUE(&VDICCD) /* +
                          ER0126 */
  /*         CHGVAR     VAR(%SST(&ERXXTRPD 3 2)) VALUE(&VDICCD)  ER1004 */
  /*         CLRPFM     FILE(&ERXXTRPD)                          ER1004 */
 
      /* Clear output files for the corresponding reporting      ER1004 */
/*           CALL       PGM(ERC0701C) PARM(&VDICCD)       * ER1004 * *ART021*/
             CALL       PGM(ERC0701C) PARM(&VDICCD &PREFIX)         /*ART021*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))                      /* ER1004 */
 
             CHGDTAARA  DTAARA(ERCTLD (&FLAGPOS 1)) VALUE('N')
             CHGDTAARA  DTAARA(ERCTLD (&ERPGMPOS 10)) VALUE(&ERPGM)
 
             OVRDBF     FILE(EREXTRL0) SEQONLY(*YES)
 /*          OVRDBF     FILE(&ERXXTRPD) SEQONLY(*YES)            ER1004 */
/*                                                                     ERL414 */
/*       Send 'started' message                                        ERL414 */
/*           SNDPGMMSG  MSG('ERC0701 -' *BCAT &VDICNA *TCAT ' +        ERL414 */
/*                        Reporting Interface to FRS starts') +        ERL414 */
/*                        TOMSGQ(ERMSGQ)                               ERL414 */
/*                                                                     ERL414 */
/*    /* Specific processing:                                          ERL414 */
/*           CALL       PGM(&ERPGM) PARM(&BJMRDT &BJURPT)       ER0336 ERL414 */
/*           SNDPGMMSG  MSG(&ERPGM *BCAT '- MAIN COMPONENT')  +        ERL414 */
/*                         TOMSGQ(ERMSGQ) MSGTYPE(*INFO)        50314  ERL414 */
/*           CALL       PGM(&ERPGM) PARM(&BJMRDT &BJURPT &LASTSQ)    + ERL414 */
/*                        ER0336                                       ERL414 */
/*                                                                     ERL414 */
/* CLOSE ALL FILES AFTER ALLOCATION                             ER0336 ERL414 */
/*           RCLRSC                                             ER0336 ERL414 */
/*                                                                     ERL414 */
/*           MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)        ERL414 */
/*           SNDPGMMSG  MSGID(DBM0004) MSGF(CEUSRMSG) +                ERL414 */
/*                        MSGDTA(&ERPGM *CAT '001') TOMSGQ(ERMSGQ)     ERL414 */
/*           GOTO       CMDLBL(EOJ)                                    ERL414 */
/*                                                  ENDDO              ERL414 */
/*                                                                     ERL414 */
/*        IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                          ERL414 */
/*           RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSGDTA)           ERL414 */
/*           SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +                ERL414 */
/*                        MSGDTA(&MSGDTA) TOMSGQ(ERMSGQ)               ERL414 */
/*           GOTO       CMDLBL(EOJ)                                    ERL414 */
/*                                     ENDDO                           ERL414 */
/*                                                                     ERL414 */
/*       IML 2.3 PROCESSING                                     ER0336 ERL414 */
/*           SNDPGMMSG  MSG('ERC0232 - IML 2.3 Extract') +             ERL414 */
/*                         TOMSGQ(ERMSGQ) MSGTYPE(*INFO)        50314  ERL414 */
/*           CALL       PGM(ERC0232) PARM(&LASTSQ)              ER0336 ERL414 */
/*                                                                     ERL414 */
/*           MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO) ER0336 ERL414 */
/*           SNDPGMMSG  MSGID(DBM0004) MSGF(CEUSRMSG) +                ERL414 */
/*                     MSGDTA(&ERPGM *CAT '001') TOMSGQ(ERMSGQ) ER0336 ERL414 */
/*           GOTO       CMDLBL(EOJ)                             ER0336 ERL414 */
/*                                                  ENDDO       ER0336 ERL414 */
/*                                                                     ERL414 */
/*       IML 1.4 PROCESSING                                     ERL371 ERL414 */
/*           RCLRSC                                             ERL371 ERL414 */
/*           SNDPGMMSG  MSG('ERLU141 - IML 1.4 Processing') +          ERL414 */
/*                         TOMSGQ(ERMSGQ) MSGTYPE(*INFO)        ERL371 ERL414 */
/*           CALL       PGM(ERLU141)                            ERL371 ERL414 */
/*                                                                     ERL414 */
/*           MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO) ERL371 ERL414 */
/*           SNDPGMMSG  MSGID(DBM0004) MSGF(CEUSRMSG) +                ERL414 */
/*                     MSGDTA(&ERPGM *CAT '001') TOMSGQ(ERMSGQ) ERL371 ERL414 */
/*           GOTO       CMDLBL(EOJ)                             ERL371 ERL414 */
/*                                                  ENDDO       ERL371 ERL414 */
/*                                                              68685  ERL414 */
/*       IML 1.2 - COLUMN 13 PROCESSING                         68685  ERL414 */
/*           RCLRSC                                             68685  ERL414 */
/*           SNDPGMMSG  MSG('ERC0121 - IML 1.2 Processing') +          ERL414 */
/*                         TOMSGQ(ERMSGQ) MSGTYPE(*INFO)        68685  ERL414 */
/*           CALL       PGM(ERC0121)                            68685  ERL414 */
/*                                                              68685  ERL414 */
/*           MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO) 68685  ERL414 */
/*           SNDPGMMSG  MSGID(DBM0004) MSGF(CEUSRMSG) +                ERL414 */
/*                    MSGDTA(&ERPGM *CAT '001') TOMSGQ(ERMSGQ)  68685  ERL414 */
/*           GOTO       CMDLBL(EOJ)                             68685  ERL414 */
/*                                                  ENDDO       68685  ERL414 */
/*                                                                     ERL414 */
             CHGVAR     VAR(&RETURN) VALUE('N')                     /* ERL414 */
/***         CALL       PGM(ERC0702) PARM(&ERPGM &BJMRDT &BJURPT +
                          &VDICNA &RETURN)                       ERL414 ULX040*/
             CALL       PGM(ERC0702) PARM(&ERPGM &BJMRDT &BJURPT +
                          &VDICNA &RETURN &PREFIX)                    /*ULX040*/
/*                                                                     ERL414 */
             IF         COND(&RETURN *EQ 'Y') THEN(GOTO CMDLBL(EOJ))/* ERL414 */
/*                                                                     ERL414 */
             CHGDTAARA  DTAARA(ERCTLD (&FLAGPOS 1)) VALUE('Y')
 
 
      /* Corresponding Audit List                            ER0126   */
/************SNDPGMMSG  MSG(&ERAUD *BCAT '- AUDIT LIST')  +
                           TOMSGQ(ERMSGQ) MSGTYPE(*INFO)          50314 ULX004*/
/**********  SNDPGMMSG  MSG(&ERAUD *BCAT '- AUDIT LIST')  +
                           TOMSGQ(CADMSGQ) MSGTYPE(*INFO)                 */       /*ULX004 CER001*/
             SNDPGMMSG  MSG(&ERAUD *BCAT '- AUDIT LIST')  +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)                                  /*CER001*/
 
/* >>>> 132893 >>>> */
 
/**********  CALL       PGM(&ERAUD) PARM(&BJMRDT &BJURPT)        ULX004 *******/
             CALL       PGM(&ERAUD) PARM(&BJMRDT &BJURPT &RSEQ &RLEV)
 
/* >>>> 132893 >>>> */
 
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO) /* +
                          ER0126 */
/******      SNDPGMMSG  MSGID(DBM0004) MSGF(CEUSRMSG) MSGDTA(&ERAUD +
                          *CAT '001') TOMSGQ(ERMSGQ)          /* ER0126 ULX004*/
/**********  SNDPGMMSG  MSGID(DBM0004) MSGF(ERUSRMSG) MSGDTA(&ERAUD +
                          *CAT '001') TOMSGQ(CADMSGQ)               */             /*ULX004 CER001*/
             SNDPGMMSG  MSGID(DBM0004) MSGF(STUSRMSG) MSGDTA(&ERAUD +
                          *CAT '001') TOMSGQ(MOPERQ)                                      /*CER001*/
                                                                                          /*CER001*/
/************SNDPGMMSG  MSG('Audit List program ' *CAT &ERAUD +
                          *CAT ' for ' *CAT &VDICCD *CAT ' +
                          failed, and will have to be restarted +
                          manually. ') TOMSGQ(ERMSGQ)         /* ER0126 ULX004*/
/**********  SNDPGMMSG  MSG('Audit List program ' *CAT &ERAUD +
                          *CAT ' for ' *CAT &VDICCD *CAT ' +
                          failed, and will have to be restarted +
                          manually. ') TOMSGQ(CADMSGQ)                    */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('Audit List program ' *CAT &ERAUD +
                          *CAT ' for ' *CAT &VDICCD *CAT ' +
                          failed, and will have to be restarted +
                          manually. ') TOMSGQ(MOPERQ)                                     /*CER001*/
             ENDDO      /* ER0126 */
 
             CHGVAR     VAR(&FLAGPOS) VALUE(&FLAGPOS + 1)
             CHGVAR     VAR(&ERPGMPOS) VALUE(&ERPGMPOS +10)
 
                                       ENDDO
/* ----------------------------------------------------------------- E1 */
 
             GOTO       CMDLBL(REPTLOOP)
 
      /* ER CAD Report                                                 ULX004 */
 
 CAD:        CALL       PGM(ERC0781) PARM(&BJMRDT &BJURPT)          /* ULX004 */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)     /* ULX004 */
 
/**********  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC0781 ended abnormally - see job log') +
                          TOMSGQ(CADMSGQ)                                 */       /*ULX004 CER001*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC0781 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)                                                  /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                      /* ULX004 */
             ENDDO                                                  /* ULX004 */
 
/* V. =============== END OF JOB BACK-UP =========================*/
 
 SAV2:       CHGDTAARA  DTAARA(ERCTLD (40 1)) VALUE('Y')
             CHGDTAARA  DTAARA(ERCTLD (39 1)) VALUE('N')
 
/************SNDPGMMSG  MSG('Second Database Save running') +
                        TOMSGQ(ERMSGQ)                         /* 50314 ULX004*/
/**********  SNDPGMMSG  MSG('Second Database Save running') +
                        TOMSGQ(CADMSGQ)                                   */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('Second Database Save running') +
                        TOMSGQ(MOPERQ)                                                    /*CER001*/
                                                                                          /*CER001*/
/************IF         COND(&SVDEVTYP2 *EQ '*SAVF') THEN(SAVLIB +
                          LIB(&XXERDLIB) DEV(*SAVF) SAVF(&SVDEVNAM2) +
                          CLEAR(*ALL))                                 ULX004*/
/**********  IF         COND(&SVDEVTYP2 *EQ '*SAVF') THEN(SAVLIB +
                          LIB(&XXCADLIB) DEV(*SAVF) SAVF(&SVDEVNAM2) +
                          CLEAR(*ALL))                                    */       /*ULX004 CER001*/
             IF         COND(&SVDEVTYP2 *EQ '*SAVF') THEN(SAVOBJ +
                          OBJ(DLACOXPD REACX2PD ERBKPXPD +
                          LECLX2PD SEDPX2PD ERBNKXPD +
                          ERBKIXPD ERBCHXPD ERCTYXPD +
                          ERCCYXPD ERDEAXPD EREXTXPD +
                          ERGUCXPD ERICDXPD ERLACXPD +
                          ERLCAXPD ERLCPXPD ERLD1XPD +
                          ERLD2XPD ERLD5XPD ERLD6XPD +
                          ERLICXPD ERLUBXPD ERLTRXPD +
                          ERLTTXPD ERL12XPD ERL28XPD +
                          ERL29XPD ERLVNXPD EROUTXPD +
                          ERPTHXPD ERPCDXPD LEFCX4PD +
                          FDDSX2PD DLFWDXPD DLFWEXPD +
                          LEGUX2PD LEHIMXPD LEHIPXPD +
                          LEHIQXPD FFITX4PD SEINVXPD +
                          SEINX3PD LEACX2PD DLLMX2PD +
                          FFMCX2PD MMDLX2PD MMDBX3PD +
                          MMDBX4PD SDACX4PD SDBKX3PD +
                          SDBKX4PD SDBRX4PD SDCTX4PD +
                          SDCCYXPD SDCUX4PD SDDSX2PD +
                          SDFCX2PD SDFOX2PD SDGELXPD +
                          SDHOLXPD SDINX2PD SDLNX2PD +
                          SESEDXPD SESDX5PD SESDX6PD +
                          SEMKX2PD SETRX2PD FFTRX4PD) +
                          LIB(&XXDMLIB) DEV(*SAVF) OBJTYPE(*FILE) +
                          SAVF(&SVDEVNAM2) CLEAR(*ALL))                                   /*CER001*/
                                                                                          /*CER001*/
/************ELSE       CMD(SAVLIB LIB(&XXERDLIB) DEV(&SVDEVNAM2) +
                          VOL(*MOUNTED) ENDOPT(*UNLOAD))               ULX004*/
/**********  ELSE       CMD(SAVLIB LIB(&XXCADLIB) DEV(&SVDEVNAM2) +
                          VOL(*MOUNTED) ENDOPT(*UNLOAD))                  */       /*ULX004 CER001*/
             ELSE       CMD(SAVOBJ OBJ(DLACOXPD REACX2PD ERBKPXPD +
                          LECLX2PD SEDPX2PD ERBNKXPD ERBKIXPD +
                          ERBCHXPD ERCTYXPD ERCCYXPD ERDEAXPD +
                          EREXTXPD ERGUCXPD ERICDXPD ERLACXPD +
                          ERLCAXPD ERLCPXPD ERLD1XPD ERLD2XPD +
                          ERLD5XPD ERLD6XPD ERLICXPD ERLUBXPD +
                          ERLTRXPD ERLTTXPD ERL12XPD ERL28XPD +
                          ERL29XPD ERLVNXPD EROUTXPD ERPTHXPD +
                          ERPCDXPD LEFCX4PD FDDSX2PD DLFWDXPD +
                          DLFWEXPD LEGUX2PD LEHIMXPD LEHIPXPD +
                          LEHIQXPD FFITX4PD SEINVXPD SEINX3PD +
                          LEACX2PD DLLMX2PD FFMCX2PD MMDLX2PD +
                          MMDBX3PD MMDBX4PD SDACX4PD SDBKX3PD +
                          SDBKX4PD SDBRX4PD SDCTX4PD SDCCYXPD +
                          SDCUX4PD SDDSX2PD SDFCX2PD SDFOX2PD +
                          SDGELXPD SDHOLXPD SDINX2PD SDLNX2PD +
                          SESEDXPD SESDX5PD SESDX6PD SEMKX2PD +
                          SETRX2PD FFTRX4PD) LIB(&XXDMLIB) +
                          DEV(&SVDEVNAM2) OBJTYPE(*FILE) +
                          ENDOPT(*UNLOAD))                                                /*CER001*/
                                                                                          /*CER001*/
             CHGDTAARA  DTAARA(ERCTLD (39 1)) VALUE('Y')
 
/************SNDPGMMSG  MSG('ERC0701 -  Reporting Interface to FRS +
                          terminates.') TOMSGQ(ERMSGQ)         /*ER0126 ULX004*/
/**********  SNDPGMMSG  MSG('ERC0701 -  Reporting Interface to FRS +
                          terminates.') TOMSGQ(CADMSGQ)                   */       /*ULX004 CER001*/
             SNDPGMMSG  MSG('ERC0701 -  Reporting Interface to FRS +
                          terminates.') TOMSGQ(MOPERQ)                             /*ULX004 CER001*/
 
             GOTO       CMDLBL(EOJ) /* Normal Completion */
 
/***EOJ:********OVRDBF     FILE(SDBANKL1) TOFILE(ERBANKL1)               */        /*ULX004 CER001*/
 EOJ:        OVRDBF     FILE(SDBANKL1) TOFILE(ERBNKXL0)                                   /*CER001*/
             CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR)           /*ART021*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)              /*ART021*/
             SNDPGMMSG  MSG('REPORTING INTERFACE. Copy files ended +
                          abnormally.')                              /*ART021*/
/*****       GOTO       CMDLBL(ENDPGM)                        /*ART021*ULX004*/
             GOTO       CMDLBL(ERROR)                                /*ULX004*/
             ENDDO                                                   /*ART021*/
             IF         COND(&EOM *EQ 'Y') THEN(DO)                  /*CADAG*/
             DLTF       FILE(&XXDILIB/ERSAVF1)
             MONMSG     MSGID(CPF2105)
             CRTDUPOBJ  OBJ(ERSAVF3) FROMLIB(&XXDILIB) +
                          OBJTYPE(*FILE) TOLIB(&XXDILIB) +
                          NEWOBJ(ERSAVF1) DATA(*YES)
             DLTF       FILE(&XXDILIB/ERSAVF2)
             MONMSG     MSGID(CPF2105)
             CRTDUPOBJ  OBJ(ERSAVF4) FROMLIB(&XXDILIB) +
                          OBJTYPE(*FILE) TOLIB(&XXDILIB) +
                          NEWOBJ(ERSAVF2) DATA(*YES)
             ENDDO                                                   /*CADAG*/
                                                                     /*ART021*/
             IF         COND(&EOM *NE 'Y') THEN(DO)                  /*ART021*/
/*           CPYF       FROMFILE(&XXERDLIB/ERCHTRPD) +
                          TOFILE(&XXERDLIB/ERCHDYPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)         ART021 ULX004*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLUTRPD) +
                          TOFILE(&XXCADLIB/ERLUD1PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX004 CER001*/
             CPYF       FROMFILE(ERLTRXPD) TOFILE(ERLD1XPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXERDLIB/ERCHDYPD))              ART021 ULX004*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUD1PD))                       */       /*ULX004 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLD1XPD))                                                 /*CER001*/
/*           CPYF       FROMFILE(&XXERDLIB/XERCHTRPD) +
                          TOFILE(&XXERDLIB/ERCHTRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)         ART021 ULX004*/
/**********  CPYF       FROMFILE(&XXCADLIB/XERLUTRPD) +
                          TOFILE(&XXCADLIB/ERLUTRPD) +
                          MBROPT(*REPLACE)                                */       /*ULX004 CER001*/
             CPYF       FROMFILE(XERLTRXPD) TOFILE(ERLTRXPD) +
                          MBROPT(*REPLACE)                                                /*CER001*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXERDLIB/ERCHTRPD))              ART021 ULX004*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUTRPD))                       */       /*ULX004 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLTRXPD))                                                 /*CER001*/
/*           DLTF       FILE(&XXERDLIB/XERCHTRPD)                ART021 ULX004*/
/*********   DLTF       FILE(&XXCADLIB/XERLUTRPD)                         */       /*ULX004 CER001*/
             DLTF       FILE(XERLTRXPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                       /*ART021*/
 
/* CAD */                                                             /*ULX004*/
 
/**********  CPYF       FROMFILE(&XXCADLIB/ERLUCAPD) +
                          TOFILE(&XXCADLIB/ERLUD2PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX004 CER001*/
             CPYF       FROMFILE(ERLCAXPD) TOFILE(ERLD2XPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUD2PD))                       */       /*ULX004 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLD2XPD))                                                 /*CER001*/
/**********  CPYF       FROMFILE(&XXCADLIB/XERLUCAPD) +
                          TOFILE(&XXCADLIB/ERLUCAPD) +
                          MBROPT(*REPLACE)                                */       /*ULX004 CER001*/
             CPYF       FROMFILE(XERLCAXPD) TOFILE(ERLCAXPD) +
                          MBROPT(*REPLACE)                                                /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUCAPD))                       */       /*ULX004 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLCAXPD))                                                 /*CER001*/
/**********  DLTF       FILE(&XXCADLIB/XERLUCAPD)                         */       /*ULX004 CER001*/
             DLTF       FILE(XERLCAXPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*ULX004*/
                                                                                    /*ULX046*/
             IF         COND(&ULX046 = 'Y') THEN(DO)                                /*ULX046*/
                                                                                    /*ULX046*/
/* Save the daily in D5 file */                                                     /*ULX046*/
                                                                                    /*ULX046*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLU28PP) +
                          TOFILE(&XXCADLIB/ERLUD5PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX046 CER001*/
             CPYF       FROMFILE(ERL28XPD) TOFILE(ERLD5XPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUD5PD))                       */       /*ULX046 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLD5XPD))                                                 /*CER001*/
                                                                                    /*ULX046*/
/* Restore monthly (save before the processing by ERC0701C) */                      /*ULX046*/
                                                                                    /*ULX046*/
/**********  CPYF       FROMFILE(&XXCADLIB/XERLU28PP) +
                          TOFILE(&XXCADLIB/ERLU28PP) +
                          MBROPT(*REPLACE)                                */       /*ULX046 CER001*/
             CPYF       FROMFILE(XERL28XPD) TOFILE(ERL28XPD) +
                          MBROPT(*REPLACE)                                                /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLU28PP))                       */       /*ULX046 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERL28XPD))                                                 /*CER001*/
                                                                                    /*ULX046*/
/* Delete working file */                                                           /*ULX046*/
                                                                                    /*ULX046*/
/**********  DLTF       FILE(&XXCADLIB/XERLU28PP)                         */       /*ULX046 CER001*/
             DLTF       FILE(XERL28XPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                                      /*ULX046*/
                                                                                    /*ULX046*/
/* Save the daily in D6 file */                                                     /*ULX046*/
                                                                                    /*ULX046*/
/**********  CPYF       FROMFILE(&XXCADLIB/ERLU29PP) +
                          TOFILE(&XXCADLIB/ERLUD6PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */       /*ULX046 CER001*/
             CPYF       FROMFILE(ERL29XPD) TOFILE(ERLD6XPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLUD6PD))                       */       /*ULX046*CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERLD6XPD))                                                 /*CER001*/
                                                                                    /*ULX046*/
/* Restore monthly (save before the processing by ERC0701C) */                      /*ULX046*/
                                                                                    /*ULX046*/
/**********  CPYF       FROMFILE(&XXCADLIB/XERLU29PP) +
                          TOFILE(&XXCADLIB/ERLU29PP) +
                          MBROPT(*REPLACE)                                */       /*ULX046 CER001*/
             CPYF       FROMFILE(XERL29XPD) TOFILE(ERL29XPD) +
                          MBROPT(*REPLACE)                                                /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&XXCADLIB/ERLU29PP))                       */       /*ULX046 CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERL29XPD))                                                 /*CER001*/
                                                                                    /*ULX046*/
/* Delete working file */                                                           /*ULX046*/
                                                                                    /*ULX046*/
/**********  DLTF       FILE(&XXCADLIB/XERLU29PP)                         */       /*ULX046 CER001*/
             DLTF       FILE(XERL29XPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                                      /*ULX046*/
                                                                                    /*ULX046*/
             ENDDO                                                                  /*ULX046*/
                                                                                    /*ULX046*/
             ENDDO                                                   /*ART021*/
                                                                     /*ART021*/
             IF         COND(&EOM *EQ 'Y') THEN(DO)                  /*ART021*/
/*           DLTF       FILE(&XXERDLIB/XERCHTRPD)                ART021 ULX004*/
/**********  DLTF       FILE(&XXCADLIB/XERLUTRPD)                         */       /*ULX004 CER001*/
             DLTF       FILE(XERLTRXPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                       /*ART021*/
/**********  DLTF       FILE(&XXCADLIB/XERLUCAPD)                         */       /*ULX004 CER001*/
             DLTF       FILE(XERLCAXPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*ULX004*/
                                                                                    /*ULX046*/
             IF         COND(&ULX046 = 'Y') THEN(DO)                                /*ULX046*/
                                                                                    /*ULX046*/
/* Delete working file */                                                           /*ULX046*/
                                                                                    /*ULX046*/
/**********  DLTF       FILE(&XXCADLIB/XERLU28PP)                         */       /*ULX046 CER001*/
             DLTF       FILE(XERL28XPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                                      /*ULX046*/
                                                                                    /*ULX046*/
/**********  DLTF       FILE(&XXCADLIB/XERLU29PP)                         */       /*ULX046 CER001*/
             DLTF       FILE(XERL29XPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000 MCH0000)                                      /*ULX046*/
                                                                                    /*ULX046*/
             ENDDO                                                                  /*ULX046*/
                                                                                    /*ULX046*/
             ENDDO                                                   /*ART021*/
                                                                     /*ART021*/
/*           SNDMSG     MSG('ERREPORT Job finished') TOMSGQ(MOPERQ +
                          MRUNQ) */                            /* 50314 */
             SNDMSG     MSG('ERREPORT Job finished') TOMSGQ(MRUNQ) +
                          /* VLFIX */
             MONMSG     MSGID(CPF0000 MCH0000)                 /* 50314 */
/*           ENDPGM                                         50314 ERL414 */
                                                                      /*ULX004*/
             GOTO       CMDLBL(ENDPGM)                                /*ULX004*/
                                                                      /*ULX004*/
/* VI. =================== ERROR =================================*/  /*ULX004*/
                                                                      /*ULX004*/
 ERROR:      CHGJOB     SWS(XXXXXX11)                                 /*ULX004*/
             MONMSG     MSGID(CPF0000)                                /*ULX004*/
             DMPCLPGM                                                 /*ULX004*/
             MONMSG     MSGID(CPF0000)                                /*ULX004*/
/**********  SNDPGMMSG  MSGID(DBM0004) MSGF(ERUSRMSG) +
                          MSGDTA('ERC0701   001') TOMSGQ(CADMSGQ)  */              /*ULX004 CER001*/
             SNDPGMMSG  MSGID(DBM0004) MSGF(STUSRMSG) +
                          MSGDTA('ERC0701   001') TOMSGQ(MOPERQ)                          /*CER001*/
             MONMSG     MSGID(CPF0000)                                /*ULX004*/
                                                                      /*ULX004*/
/*================================================================*/  /*ULX004*/
                                                                      /*ULX004*/
 ENDPGM:     CALL       PGM(ERUNQP) PARM('P')                         /*ULX004*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*ULX004*/
             SNDPGMMSG  MSG('REPORTING INTERFACE. Audit list ended +
                          abnormally.')                               /*ULX004*/
             MONMSG     MSGID(CPF0000)                                /*ULX004*/
             ENDDO                                                    /*ULX004*/
                                                                      /*ULX004*/
 /* CAD009 START */
/**********  DLTF       FILE(XERLUTRPD)                                                   /*CER001*/
             DLTF       FILE(XERLTRXPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000)
/**********  DLTF       FILE(XERLUCAPD)                                                   /*CER001*/
             DLTF       FILE(XERLCAXPD)                                                   /*CER001*/
             MONMSG     MSGID(CPF0000)
 /* CAD009 END */
 
             CHGVAR     VAR(&CPYFLD) +
                         VALUE('(c) Finastra International Limited +
                                 2005')                               /*ULX004*/
             ENDPGM                                                   /*ULX004*/
