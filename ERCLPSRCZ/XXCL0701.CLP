/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas ABS INTERFACE TO FRS MAIN COMPONENT')          */
/********************************************************************/
/*                                                                  */
/*     MIDAS - EUROPEAN REPORTING                                   */
/*                                                                  */
/*     XXCL0701- EUROPEAN REPORTING                                 */
/*               INTERFACE TO FRS MAIN COMPONENT                    */
/*                                                                  */
/*     COPYRIGHT BIS BANKING SYSTEMS 1992.  COMPANY CONFIDENTIAL    */
/*                                                                  */
/*     Last Amend No. MD058100           Date 20May21               */
/*     Prev Amend No. LUC139 *Update     Date  10May21              */
/*                    LUC139             Date 08Jan21               */
/*                    MMI137             Date  13Jul09              */
/*                    MBV005             Date  10May07              */
/*                    MMI125             Date  09Mar07              */
/*                    MMI124             Date  16Feb07              */
/*                    MMI100             DATE  04Nov02              */
/*                    MMI098             DATE  03Apr02              */
/*                    MMI092             DATE  10Jan02              */
/*                    MMI059             DATE  12Aug99              */
/*                    MMI033             DATE  18JUN99              */
/*                    MMI033             DATE  08OCT94              */
/*                    ERL414 PT          DATE  26JUL94              */
/*                    68685  PT          DATE  04MAR94              */
/*                    ERL371 TLI         DATE  15NOV93              */
/*                    50314  ADI         DATE  27MAY93              */
/*                    ER0336 TLI         DATE  16APR93              */
/*                    ER0126             DATE  17NOV92         ThL  */
/*                    ER1004             DATE  03NOV92         ThL  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  MD058100 - Rollup of additional BoI onsite fixes at FbMidas     */
/*  LUC139 - Remove F7SEVAL1. Delete GPCSECL1 version in xxERDLIB   */
/*  LUC139 - Upgrade UCI Italian Returns                            */
/*  MMI137 - Fidi Plurimi. On first extraction save EREXTRPD        */
/*           and FCLTYFXP, so that they can be restored in case     */
/*           of restart. This would roll back changes made by       */
/*           ERIT57.                                                */
/*  MBV005 - HVB Valutaria Extract File                             */
/*  MMI125 - Voci 4000 replaced by ranges 4nnnn and 8nnnn.          */
/*  MMI124 - Version 6 of MMI059 (Oasi Interface): changes to       */
/*           Guarantees.                                            */
/*  MMI100 - R4.1 Upgrade.                                          */
/*  MMI098 - Remove ERC0701C and make specific for Italy            */
/*  MMI092 - Version 3 of MMI059 (Seceti Interface): report separa- */
/*           tely items in range 04xxx.                             */
/*  MMI059 - SECETI Interface                                       */
/*  MMI033 - Midas Italy Puma/2 NEW CHANGES                         */
/*  MMI033 - Midas Italy Puma/2 Extract Change 3                    */
/*  ERL414 - PGM/ERUNQP INCORRECTLY MONITORED                       */
/*           CRTADTAARA/LDA NOT MONITORED                           */
/*           DIFFERENT ENHANCEMENTS (DUE TO RCLRSC)                 */
/*  68685  - IML 1.2 COLUMN 13 RECORDS GENERATION                   */
/*  ERL371 - IML 1.4 DEVELOPMENT                                    */
/*  50314  - ADD AUDIT CONTROL LIST                                 */
/*  ER0336 - IML 2.3 DEVELOPMENT - Add Sequence number parameter    */
/*  ER0126 - 1. Review Restart processing .                         */
/*           2. Include Audit trail processing.                     */
/*  ER1004 - Clear specific  output files before processing         */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PREFIX)

             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)     /* MIDAS +
                          subsystem prefix */
             DCL        VAR(&BJMRDT) TYPE(*CHAR) LEN(7) /* MIDAS +
                          report date */
             DCL        VAR(&BJURPT) TYPE(*CHAR) LEN(53) /* Title */
             DCL        VAR(&XXDTALIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS Msg files library */
             DCL        VAR(&XXERDLIB) TYPE(*CHAR) LEN(10) +
                              /* MIDAS ER Data base library */
             DCL        VAR(&ERPGM) TYPE(*CHAR) LEN(10) +
                          VALUE('ERxx60') /* MIDAS ER Specific +
                          processing pgm by country */
             DCL        VAR(&ERAUD) TYPE(*CHAR) LEN(10) +
                          VALUE('ERxx85') /* MIDAS ER Specific +
                          Audit trail  - ER0126 */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*MMI033*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*MMI033*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XXDPLIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XXDMLIB ) TYPE(*CHAR) LEN(10)

/**********  DCLF       FILE(ERICDRPD) RCDFMT(ERICDRD0)                    */             /*CER001*/
             DCLF       FILE(ERICDXPD) RCDFMT(ERICDRD0)                                   /*CER001*/

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/*=========================  INIT  ===============================*/
             SNDMSG     MSG('CADREPORT Job started') TOMSGQ(MOPERQ +
                          MRUNQ)                               /* 50314 */
             MONMSG     MSGID(CPF0000 MCH0000)                 /* 50314 */
/* Reset External Switches and ER msgq */
             CHGJOB     SWS(00000000)
             CLRMSGQ    MSGQ(ERMSGQ)
             MONMSG CPF0000

/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Local data area')
/* Create local data area only if it does not exist                  */
             MONMSG     MSGID(CPF1023)                     /* ERL414 */

/*                                                                   */
             CHGVAR     VAR(&XXDPLIB) VALUE(&PREFIX *CAT 'DPLIB')
             CHGVAR     VAR(&XXDMLIB) VALUE(&PREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&XXERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')
             CHGVAR     VAR(&XXDTALIB) VALUE(&PREFIX *CAT 'DTALIB')
                          /* Warning: Multilangage to be checked if +
                          necessary */

/* Set download library at top of library list                      */
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
 NOREPT:     SNDPGMMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') TOMSGQ(ERMSGQ)              /* 50314 */
/* NOREPT: 50314*/    SNDUSRMSG  MSG('REPORTING INTERFACE. No Reporting +
                          Parameter defined in ER ICD . Is +
                          Reporting Data Library Save necessary ? +
                          Reply "Y" to save.  Reply "C" to cancel +
                          job .') MSGTYPE(*INQ) +
                          TOMSGQ(*LIBL/ERMSGQ) MSGRPY(&REPLY)
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
             CHGVAR     VAR(&SVDEVNAM1) VALUE('ERSAVF1')
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
             CHGVAR     VAR(&SVDEVNAM2) VALUE('ERSAVF2')
             CHGVAR     VAR(&SVIND2) VALUE('N')                  /* ER0126 */
             CHGDTAARA  DTAARA(ERCTLD (24 5)) VALUE(&SVDEVTYP2)
             CHGDTAARA  DTAARA(ERCTLD (29 10)) VALUE(&SVDEVNAM2)
             CHGDTAARA  DTAARA(ERCTLD (39 2)) VALUE('NN')       /* ER0126 */
                                       ENDDO

/* Not a restart :                                       */
             IF         COND(&BJMRDT *NE &SVDATE) THEN(GOTO +
                          CMDLBL(SAV1))

/*====================== RESTART =================================*/

             GOTO       CMDLBL(RESTART) /* 'MMI033' */

/* Restart but ER Data base not saved yet :             */
             IF         COND(&SVIND1 *NE 'Y') THEN(GOTO +
                          CMDLBL(SAV1)) /* Save 1 not done */

/* Restart with ER Data base already saved :            */
 MSG1:       SNDPGMMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') TOMSGQ(ERMSGQ)        /* 50314 */
/* MSG1: 50314*/      SNDUSRMSG  MSG('REPORTING INTERFACE RESTART. Reply "R" +
                          to restart from the beginning (with +
                          reporting data base 1st save).  Reply "C" +
                          to cancel job .  Reply "B" to bypass 1st +
                          save operation, and continue with the +
                          following steps.') MSGTYPE(*INQ) +
                          TOMSGQ(ERMSGQ) MSGRPY(&REPLY)
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
             CPYF       FROMFILE(&XXERDLIB/EREXTRPD) +
                          TOFILE(&XXERDLIB/SVEXTRPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*MMI137*/
             CPYF       FROMFILE(&XXERDLIB/LEFCT1PD) +
                          TOFILE(&XXERDLIB/SVFCLTYX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*MMI137*/

/* Save parameters :  save file OR tape OR diskette  */
             SNDPGMMSG  MSG('First Database Save running') +
                        TOMSGQ(ERMSGQ)                               /* 50314 */
             IF         COND(&SVDEVTYP1 *EQ '*SAVF') THEN(SAVLIB +
                          LIB(&XXERDLIB) DEV(*SAVF) SAVF(&SVDEVNAM1) +
                          CLEAR(*ALL))
             ELSE       CMD(SAVLIB LIB(&XXERDLIB) DEV(&SVDEVNAM1) +
                          VOL(*MOUNTED) ENDOPT(*UNLOAD))

             CHGDTAARA  DTAARA(ERCTLD (23 1)) VALUE('Y')

             IF         COND(&NBRREPT *EQ 0) THEN(GOTO CMDLBL(EOJ)) +
                          /* No reporting Requirement has been +
                          defined. Save has been requested and +
                          executed . Job ends */

/*===================== RESTART CONTROL ======================*/

 RESTART:
                                                                                          /*MMI137*/
/* Restore files saved during first extraction for this reporting                         /*MMI137*/
/* date, to roll back changes made by ERIT57.                                             /*MMI137*/
                                                                                          /*MMI137*/
             CPYF       FROMFILE(&XXERDLIB/SVEXTRPD) +
                          TOFILE(&XXERDLIB/EREXTRPD) +
                          MBROPT(*REPLACE)                                                /*MMI137*/
             CPYF       FROMFILE(&XXERDLIB/SVFCLTYX) +
                          TOFILE(&XXERDLIB/LEFCT1PD) +
                          MBROPT(*REPLACE)                                                /*MMI137*/

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
         MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(SAV2))

/* Only complete for Italy. For all other countries, skip  processing */
             IF         COND(&VDICCD *NE 'IT') THEN(GOTO +
                          CMDLBL(REPTLOOP))

/* ----------------------------------------------------------------- B1 */
             IF         COND(&VDICCD *NE *BLANK *AND &VDUCCD *NE +
                          BLANK) THEN(DO)

             CHGVAR     VAR(%SST(&ERPGM 3 2)) VALUE(&VDICCD)
             CHGVAR     VAR(%SST(&ERAUD 3 2)) VALUE(&VDICCD) /* +
                          ER0126 */
  /*         CHGVAR     VAR(%SST(&ERXXTRPD 3 2)) VALUE(&VDICCD)  ER1004 */
  /*         CLRPFM     FILE(&ERXXTRPD)                          ER1004 */

      /* Clear output files for the corresponding reporting      ER1004 */
/*********** CALL       PGM(ERC0701C) PARM(&VDICCD)        /*ER1004*/ /*MMI098*/
             CLRPFM     ERITTRPD                                      /*MMI098*/
/**********  CLRPFM     F7SEVAL1                           /*MBV005*/ /*LUC139*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))       /*MMI098*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))                      /* ER1004 */

             CHGDTAARA  DTAARA(ERCTLD (&FLAGPOS 1)) VALUE('N')
             CHGDTAARA  DTAARA(ERCTLD (&ERPGMPOS 10)) VALUE(&ERPGM)

             OVRDBF     FILE(EREXTRL0) SEQONLY(*YES)
             CHGVAR     VAR(&RETURN) VALUE('N')                     /* ERL414 */
             CALL       PGM(ERC0702) PARM(&ERPGM &BJMRDT &BJURPT +
                          &VDICNA &RETURN)                          /* ERL414 */
/*                                                                     ERL414 */
             IF         COND(&RETURN *EQ 'Y') THEN(GOTO CMDLBL(EOJ))/* ERL414 */
/*                                                                     ERL414 */
             CHGDTAARA  DTAARA(ERCTLD (&FLAGPOS 1)) VALUE('Y')


      /* Corresponding Audit List                            ER0126   */
             SNDPGMMSG  MSG(&ERAUD *BCAT '- AUDIT LIST')  +
                           TOMSGQ(ERMSGQ) MSGTYPE(*INFO)        /* 50314 */
/**********  CALL       PGM(&ERAUD) PARM(&BJMRDT &BJURPT)        ULX004 *******/
             CALL       PGM(&ERAUD) PARM(&BJMRDT &BJURPT &RSEQ &RLEV)

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO) /* +
                          ER0126 */
             SNDPGMMSG  MSG('Audit List program ' *CAT &ERAUD +
                          *CAT ' for ' *CAT &VDICCD *CAT ' +
                          failed, and will have to be restarted +
                          manually. ') TOMSGQ(ERMSGQ) /* ER0126 */
             ENDDO      /* ER0126 */
/*                                                                 */ /*MMI033*/
/* CALL MINERVA INTERFACE MAIN PROGRAM                             */ /*MMI033*/
/*                                                                 */ /*MMI033*/
             CALL       PGM(IRC1000)                                  /*MMI033*/

             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'MMI033' +
                          &DSFDY)                                     /*MMI033*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*MMI033*/
             CALL       PGM(ERC4110)                                  /*MMI100*/
             CALL       PGM(ERC4130)                                  /*MMI100*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))                              /*MMI033*/
             ENDDO                                                    /*MMI033*/

/*                                                                 */ /*MMI059*/
/* OASI INTERFACE                                                  */ /*MMI059*/
/*                                                                 */ /*MMI059*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'MMI059' +
                          &DSFDY)                                     /*MMI059*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*MMI059*/
             CLRPFM     FILE(IRTABEPD)                                /*MMI059*/
             CALL       PGM(IR1500)                                   /*MMI059*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))                              /*MMI059*/
             CALL       PGM(IR1510)                                   /*MMI124*/
                                                                      /*MMI092*/
/* If December extraction, move Voci 4000 from IRPUMAPD to IR4000PD * /*MMI092*/

             IF         COND(%SST(&BJMRDT 3 3) *EQ 'DEC') THEN(DO)    /*MMI092*/

/**********  DLTF       FILE(&XXERDLIB/IRCOPYPD)                      /*MMI092*/
             DLTF       FILE(IRCOPYPD)
             MONMSG     MSGID(CPF0000)                                /*MMI092*/

/**********  DLTF       FILE(&XXERDLIB/IR4000PD)                      /*MMI092*/
             DLTF       FILE(IR4000PD)
             MONMSG     MSGID(CPF0000)                                /*MMI092*/

             CPYF       FROMFILE(IRPUMAPD) +
                          TOFILE(&XXDPLIB/IRCOPYPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)


             CPYF       FROMFILE(IRCOPYPD) +
                          TOFILE(IRPUMAPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO) INCREL((*IF +
                          MK001 *LT 40000))                           /*MMI125*/

             CPYF       FROMFILE(IRCOPYPD) +
                          TOFILE(IRPUMAPD) MBROPT(*ADD) +
                          CRTFILE(*NO) INCREL((*IF MK001 *GT 49999) +
                          (*AND MK001 *LT 80000))                     /*MMI125*/

             CPYF       FROMFILE(IRCOPYPD) +
                          TOFILE(IRPUMAPD) +
                          MBROPT(*ADD) CRTFILE(*NO) INCREL((*IF +
                          MK001 *GT 89999))                           /*MMI125*/

             CPYF       FROMFILE(IRCOPYPD) TOFILE(&XXDMLIB/IR4000PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MK001 *GE 40000) (*AND MK001 +
                          *LE 49999)) /*MMI125*/

             CPYF       FROMFILE(IRCOPYPD) +
                          TOFILE(IR4000PD) MBROPT(*ADD) +
                          CRTFILE(*YES) INCREL((*IF MK001 *GE +
                          80000) (*AND MK001 *LE 89999))              /*MMI125*/

             DLTF       FILE(IRCOPYPD)
             MONMSG     MSGID(CPF0000)                                /*MMI092*/

             ENDDO                                                    /*MMI092*/

             ENDDO                                                    /*MMI059*/

             CHGVAR     VAR(&FLAGPOS) VALUE(&FLAGPOS + 1)
             CHGVAR     VAR(&ERPGMPOS) VALUE(&ERPGMPOS +10)

                                       ENDDO
/* ----------------------------------------------------------------- E1 */

             GOTO       CMDLBL(REPTLOOP)

/* V. =============== END OF JOB BACK-UP =========================*/

 SAV2:       CHGDTAARA  DTAARA(ERCTLD (40 1)) VALUE('Y')
             CHGDTAARA  DTAARA(ERCTLD (39 1)) VALUE('N')

             SNDPGMMSG  MSG('Second Database Save running') +
                        TOMSGQ(ERMSGQ)                               /* 50314 */
             IF         COND(&SVDEVTYP2 *EQ '*SAVF') THEN(SAVLIB +
                          LIB(&XXERDLIB) DEV(*SAVF) SAVF(&SVDEVNAM2) +
                          CLEAR(*ALL))
             ELSE       CMD(SAVLIB LIB(&XXERDLIB) DEV(&SVDEVNAM2) +
                          VOL(*MOUNTED) ENDOPT(*UNLOAD))

             CHGDTAARA  DTAARA(ERCTLD (39 1)) VALUE('Y')

             SNDPGMMSG  MSG('ERC0701 -  Reporting Interface to FRS +
                          terminates.') TOMSGQ(ERMSGQ) /* ER0126 */

             GOTO       CMDLBL(EOJ) /* Normal Completion */

/* VI. =================== ERROR =================================*/
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) +
                          MSGDTA('ERC0701   001') TOMSGQ(ERMSGQ)      /*MMI100*/
             MONMSG     MSGID(CPF0000)

 EOJ:        CALL       PGM(ERUNQP) PARM('P')                  /* 50314 */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)        /* ERL414 */
             SNDPGMMSG  MSG('REPORTING INTERFACE. Audit list ended +
                          abnormally.')                        /* ERL414 */
             GOTO       CMDLBL(ENDPGM)                         /* ERL414 */
             ENDDO                                             /* ERL414 */
                                                                      /*MMI100*/
/* DELETE LOGICAL FILES CREATED BY ERC0700 */                         /*MMI100*/
                                                                      /*MMI100*/
             DLTF       FILE(&XXERDLIB/MUSER)                         /*MMI100*/
             MONMSG     MSGID(CPF2105)                                /*MMI100*/
             DLTF       FILE(&XXERDLIB/SCCSECL1)                      /*MMI100*/
             MONMSG     MSGID(CPF2105)                                /*MMI100*/
             DLTF       FILE(&XXERDLIB/SCSARDL1)                      /*MMI100*/
             MONMSG     MSGID(CPF2105)                                /*MMI100*/
             DLTF       FILE(&XXERDLIB/SCSARSL1)                      /*MMI100*/
             MONMSG     MSGID(CPF2105)                                /*MMI100*/
             DLTF       FILE(&XXERDLIB/GPCSECL1)                      /*LUC139*/
             MONMSG     MSGID(CPF2105)                                /*LUC139*/
                                                               /* ERL414 */
             SNDMSG     MSG('CADREPORT Job finished') TOMSGQ(MOPERQ +
                          MRUNQ)                               /* 50314 */
             MONMSG     MSGID(CPF0000 MCH0000)                 /* 50314 */
/*           ENDPGM                                         50314 ERL414 */
 ENDPGM:     ENDPGM                                            /* ERL414 */
