/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Restore database libraries in batch')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1061 - Restore database                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      AR886414           Date 05Jan12              */
/*                      CBF012             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 08Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CPK017             Date 05Nov03              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*       AR886414 - Creation of CBS, CBA and BF libraries in SMSETUPD*/
/*                  not catered                                      */
/*       CBF012 - BF Infrastructure: Upgradability                   */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Remove zone handling; move to new program.         */
/*       CPK017 - Midas Plus implementation.                         */
/*                Include the restore of libraries for GP.           */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&DEV &PTFUPG)                                             */ /*CPK017*/
/**********  PGM        PARM(&DEV &PTFUPG &PROCESS)                         */ /*CPK017*/ /*CSM003*/
/**********  PGM        PARM(&DEV &PTFUPG)                                  */ /*CSM003*/ /*CUP033*/
             PGM        PARM(&DEV &BRGSVAL &GPFXSVAL)                                     /*CUP033*/

             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&GPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/

             DCL        VAR(&DEV) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                               */ /*CPK017*/
/**********  DCL        VAR(&PROCESS) TYPE(*CHAR) LEN(7)                    */ /*CPK017*/ /*CSM003*/
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*             */ /*CUP033*/
             DCL        VAR(&GPSBSID) TYPE(*CHAR) LEN(2)                                  /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/

             DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&UPSTATPOS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DMED) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEVID) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&DEVNUM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FMDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMDPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMDTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMDVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMCBSLIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&FMCBALIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&FMBFLIB) TYPE(*CHAR) LEN(10)                                 /*CBF012*/
/**********  DCL        VAR(&FMDZLIB) TYPE(*CHAR) LEN(10)                              */ /*CSM003*/
             DCL        VAR(&TODMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOCBSLIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&TOCBALIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&TOBFLIB) TYPE(*CHAR) LEN(10)                                 /*CBF012*/
/**********  DCL        VAR(&TODZLIB) TYPE(*CHAR) LEN(10)                              */ /*CSM003*/
             DCL        VAR(&RSTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBLIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ENDOPT) TYPE(*CHAR) LEN(7) VALUE('*LEAVE')
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DEVTYPE) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&XXTOXX) TYPE(*CHAR) LEN(4)                                */ /*CSM003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/**********  DCLF       FILE(UPGSVALJ0) */                                     /*CUP033* *MD054605*/
             DCLF       FILE(UPGSVALJ0) ALWNULL(*YES)                                   /*MD054605*/

/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Check what type of device is being used. */
             RTVOBJD    OBJ(&DEV) OBJTYPE(*DEVD) OBJATR(&DEVTYPE)

/* Retrieve library prefix and create library names. */
             RTVDTAARA  DTAARA(UPSTAT) RTNVAR(&UPSTAT)
             CHGVAR     VAR(&DBLIBID) VALUE(%SST(&UPSTAT 60 2))
             IF         COND(&DBLIBID *EQ '  ') THEN(DO)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE('Unable to +
                             retrieve database prefix.  Check UPSTAT.')
                CALL  PGM(SCC0010) PARM('SMC1061' 'ENTER' ' ')
                GOTO       CMDLBL(ENDPGM)
             ENDDO

/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(DO)                 */ /*CPK017*/ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**If*the*'new'*library*ID*is*blank*then*this*means*that*this*is*an*'XX'*to*'XX'**/ /* */ /*CSM003*/
/**type*upgrade.******************************************************************/ /* */ /*CSM003*/
/**********     CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 62 2))                      */ /*CSM003*/
/**********     IF         COND(&LIBGRP *EQ '  ') THEN(DO)                             */ /*CSM003*/
/**********        CHGVAR     VAR(&LIBGRP) VALUE(&DBLIBID)                             */ /*CSM003*/
/**********        CHGVAR     VAR(&XXTOXX) VALUE('*YES')                               */ /*CSM003*/
/**********     ENDDO                                                                  */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**********     CHGVAR     VAR(&FMDMLIB) VALUE(&DBLIBID *CAT 'DMLIB')                  */ /*CSM003*/
/**********     CHGVAR     VAR(&FMDPLIB) VALUE(&DBLIBID *CAT 'DPLIB')                  */ /*CSM003*/
/**********     CHGVAR     VAR(&FMDTALIB) VALUE(&DBLIBID *CAT 'DTALIB')                */ /*CSM003*/
/**********     CHGVAR     VAR(&FMDVLIB) VALUE(&DBLIBID *CAT 'DVLIB')                  */ /*CSM003*/
/**********     CHGVAR     VAR(&FMDZLIB) VALUE(&DBLIBID *CAT 'DZLIB')                  */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**********     CHGVAR     VAR(&TODMLIB) VALUE(&LIBGRP *CAT 'DMLIB')                   */ /*CSM003*/
/**********     CHGVAR     VAR(&TODPLIB) VALUE(&LIBGRP *CAT 'DPLIB')                   */ /*CSM003*/
/**********     CHGVAR     VAR(&TODTALIB) VALUE(&LIBGRP *CAT 'DTALIB')                 */ /*CSM003*/
/**********     CHGVAR     VAR(&TODVLIB) VALUE(&LIBGRP *CAT 'DVLIB')                   */ /*CSM003*/
/**********     CHGVAR     VAR(&TODZLIB) VALUE(&LIBGRP *CAT 'DZLIB')                   */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**If*it*is*an*'XX'*to*'XX'*type*upgrade*and*an*optical*disk*is*being*used*then**/ /*  */ /*CSM003*/
/***the*libraries*to*be*restored*into*must*be*created*up*front.**/ /*                  */ /*CSM003*/
/**********     IF         COND(&XXTOXX *EQ '*YES' *AND &DEVTYPE *EQ +                 */ /*CSM003*/
/**********                  'OPT') THEN(DO)                                           */ /*CSM003*/
/**********        CRTLIB     LIB(&FMDMLIB) TEXT('Midas master physical +              */ /*CSM003*/
/**********                     files, data areas library')                            */ /*CSM003*/
/**********        MONMSG     MSGID(CPF2111)                                           */ /*CSM003*/
/**********        CRTLIB     LIB(&FMDPLIB) TEXT('Midas non-master phys. +             */ /*CSM003*/
/**********                     files, data areas library')                            */ /*CSM003*/
/**********        MONMSG     MSGID(CPF2111)                                           */ /*CSM003*/
/**********        CRTLIB     LIB(&FMDTALIB) TEXT('Midas delivered data   +            */ /*CSM003*/
/**********                     library')                                              */ /*CSM003*/
/**********        MONMSG     MSGID(CPF2111)                                           */ /*CSM003*/
/**********        CRTLIB     LIB(&FMDVLIB) TEXT('Midas logical files +                */ /*CSM003*/
/**********                     library')                                              */ /*CSM003*/
/**********        MONMSG     MSGID(CPF2111)                                           */ /*CSM003*/
/**********        CRTLIB     LIB(&FMDZLIB) TEXT('Midas 24x7 availability +            */ /*CSM003*/
/**********                     library')                                              */ /*CSM003*/
/**********        MONMSG     MSGID(CPF2111)                                           */ /*CSM003*/
/**********     ENDDO                                                                  */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**********  ENDDO                                                          */ /*CPK017*/ /*CSM003*/

/**********  IF         COND(&PROCESS = '*GLOBAL') THEN(DO)                 */ /*CPK017*/ /*CSM003*/
/* Get Global layer system ID. */                                                         /*CPK017*/
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*  */ /*CPK017*/ /*CUP033*/
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &GPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&GPSBSID) VALUE(&GIVAL)                                 /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

/* Ensure that it is not blank. */                                                        /*CPK017*/
/**********  IF         COND(&GPSBSID *EQ '  ') THEN(DO)                               */ /*CUP033*/
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen. */                                       /*CPK017*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CPK017*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                      /*CPK017*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CPK017*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                      /*CPK017*/
                CALL       PGM(SCC0010) PARM('SMC1061' 'ENTER' ' ')                       /*CPK017*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CPK017*/
             ENDDO                                                                        /*CPK017*/
             ELSE       CMD(DO)                                                           /*CPK017*/
                CHGVAR     VAR(&LIBGRP) VALUE(&GPSBSID)                                   /*CPK017*/

                CHGVAR     VAR(&FMDMLIB) VALUE(&DBLIBID *CAT 'GMLIB')                     /*CPK017*/
                CHGVAR     VAR(&FMDPLIB) VALUE(&DBLIBID *CAT 'GPLIB')                     /*CPK017*/
                CHGVAR     VAR(&FMDTALIB) VALUE(&DBLIBID *CAT 'GTALIB')                   /*CPK017*/
                CHGVAR     VAR(&FMDVLIB) VALUE(&DBLIBID *CAT 'GVLIB')                     /*CPK017*/
                CHGVAR     VAR(&FMCBSLIB) VALUE(&DBLIBID *CAT 'CBSLIB')                   /*CBF012*/
                CHGVAR     VAR(&FMCBALIB) VALUE(&DBLIBID *CAT 'CBALIB')                   /*CBF012*/
                CHGVAR     VAR(&FMBFLIB) VALUE(&DBLIBID *CAT 'BFLIB')                     /*CBF012*/

                CHGVAR     VAR(&TODMLIB) VALUE(&LIBGRP *CAT 'GMLIB')                      /*CPK017*/
                CHGVAR     VAR(&TODPLIB) VALUE(&LIBGRP *CAT 'GPLIB')                      /*CPK017*/
                CHGVAR     VAR(&TODTALIB) VALUE(&LIBGRP *CAT 'GTALIB')                    /*CPK017*/
                CHGVAR     VAR(&TODVLIB) VALUE(&LIBGRP *CAT 'GVLIB')                      /*CPK017*/
                CHGVAR     VAR(&TOCBSLIB) VALUE(&LIBGRP *CAT 'CBSLIB')                    /*CBF012*/
                CHGVAR     VAR(&TOCBALIB) VALUE(&LIBGRP *CAT 'CBALIB')                    /*CBF012*/
                CHGVAR     VAR(&TOBFLIB) VALUE(&LIBGRP *CAT 'BFLIB')                      /*CBF012*/
             ENDDO                                                                        /*CPK017*/

/**********  ENDDO                                                          */ /*CPK017*/ /*CSM003*/

RUN:

SUBMIT:
                                                                                        /*AR886414*/
/** Rename BFLIB on machine (as created) to match restore name  */                      /*AR886414*/
             CHKOBJ     OBJ(&TOBFLIB) OBJTYPE(*LIB)                                     /*AR886414*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*AR886414*/
                CHKOBJ     OBJ(&FMBFLIB) OBJTYPE(*LIB)                                  /*AR886414*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                      /*AR886414*/
                   CHGVAR     VAR(&MEM) VALUE('Unable to find BFLIBs on +
                                machine.')                                              /*AR886414*/
                   SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                   /*AR886414*/
                   GOTO       CMDLBL(ABNOR)                                             /*AR886414*/
                ENDDO                                                                   /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             RNMOBJ     OBJ(&TOBFLIB) OBJTYPE(*LIB) NEWOBJ(&FMBFLIB)                    /*AR886414*/
             MONMSG     MSGID(CPF2111) EXEC(DO)                                         /*AR886414*/
                CHGVAR     VAR(&MEM) VALUE(&FMBFLIB *BCAT 'already +
                             exists on machine.')                                       /*AR886414*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                      /*AR886414*/
                GOTO       CMDLBL(ABNOR)                                                /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&RSTLIB) VALUE(&FMBFLIB)                                    /*AR886414*/
                                                                                        /*AR886414*/
/** Submit restore of BFLIB  */                                                         /*AR886414*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(191)                                      /*AR886414*/
                                                                                        /*AR886414*/
             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMBFLIB &TOBFLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TOBFLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)                     /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMBFLIB)                                      /*AR886414*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                         /*AR886414*/
                                                                                        /*AR886414*/
/** Rename CBSLIB on machine (as created) to match restore name  */                     /*AR886414*/
             CHKOBJ     OBJ(&TOCBSLIB) OBJTYPE(*LIB)                                    /*AR886414*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*AR886414*/
                CHKOBJ     OBJ(&FMCBSLIB) OBJTYPE(*LIB)                                 /*AR886414*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                      /*AR886414*/
                   CHGVAR     VAR(&MEM) VALUE('Unable to find CBSLIBs on +
                                machine.')                                              /*AR886414*/
                   SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                   /*AR886414*/
                   GOTO       CMDLBL(ABNOR)                                             /*AR886414*/
                ENDDO                                                                   /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             RNMOBJ     OBJ(&TOCBSLIB) OBJTYPE(*LIB) NEWOBJ(&FMCBSLIB)                  /*AR886414*/
             MONMSG     MSGID(CPF2111) EXEC(DO)                                         /*AR886414*/
                CHGVAR     VAR(&MEM) VALUE(&FMCBSLIB *BCAT 'already +
                             exists on machine.')                                       /*AR886414*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                      /*AR886414*/
                GOTO       CMDLBL(ABNOR)                                                /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&RSTLIB) VALUE(&FMCBSLIB)                                   /*AR886414*/
                                                                                        /*AR886414*/
/** Submit restore of CBSLIB  */                                                        /*AR886414*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(189)                                      /*AR886414*/
                                                                                        /*AR886414*/
             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMCBSLIB &TOCBSLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TOCBSLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)                     /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMCBSLIB)                                     /*AR886414*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                         /*AR886414*/
                                                                                        /*AR886414*/
/* Rename CBALIB on machine (as created) to match restore name. */                      /*AR886414*/
             CHKOBJ     OBJ(&TOCBALIB) OBJTYPE(*LIB)                                    /*AR886414*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*AR886414*/
                CHKOBJ     OBJ(&FMCBALIB) OBJTYPE(*LIB)                                 /*AR886414*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                      /*AR886414*/
                   CHGVAR     VAR(&MEM) VALUE('Unable to find CBALIBs on +
                                machine.')                                              /*AR886414*/
                   SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                   /*AR886414*/
                   GOTO       CMDLBL(ABNOR)                                             /*AR886414*/
                ENDDO                                                                   /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             RNMOBJ     OBJ(&TOCBALIB) OBJTYPE(*LIB) NEWOBJ(&FMCBALIB)                  /*AR886414*/
             MONMSG     MSGID(CPF2111) EXEC(DO)                                         /*AR886414*/
                CHGVAR     VAR(&MEM) VALUE(&FMCBALIB *BCAT 'already +
                             exists on machine.')                                       /*AR886414*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                      /*AR886414*/
                GOTO       CMDLBL(ABNOR)                                                /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&RSTLIB) VALUE(&FMCBALIB)                                   /*AR886414*/
                                                                                        /*AR886414*/
/* Submit restore of CBALIB. */                                                         /*AR886414*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(190)                                      /*AR886414*/
                                                                                        /*AR886414*/
             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMCBALIB &TOCBALIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TOCBALIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)                     /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMCBALIB)                                     /*AR886414*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                         /*AR886414*/
                                                                                        /*AR886414*/
/* Rename DMLIB on machine (as created) to match restore name. */
/**Only*do*this*if*not*performing*an*'XX'*to*'XX'*type*upgrade.**/ /*                  */ /*CSM003*/
/**********  IF         COND(&DBLIBID *NE &LIBGRP) THEN(DO)                            */ /*CSM003*/
             CHKOBJ     OBJ(&TODMLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHKOBJ     OBJ(&FMDMLIB) OBJTYPE(*LIB)
                MONMSG     MSGID(CPF9801) EXEC(DO)
/**********        CHGVAR     VAR(&MEM) VALUE('Unable to find DMLIBs on +              */ /*CSM003*/
/**********                     machine.')                                             */ /*CSM003*/
                   CHGVAR     VAR(&MEM) VALUE('Unable to find GMLIBs on +
                                machine.')                                                /*CSM003*/
                   SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO

             RNMOBJ     OBJ(&TODMLIB) OBJTYPE(*LIB) NEWOBJ(&FMDMLIB)
             MONMSG     MSGID(CPF2111) EXEC(DO)
                CHGVAR     VAR(&MEM) VALUE(&FMDMLIB *BCAT 'already +
                             exists on machine.')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**********  ENDDO                                                                     */ /*CSM003*/
             CHGVAR     VAR(&RSTLIB) VALUE(&FMDMLIB)

/* Submit restore of DMLIB. */
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(070)                                     */ /*CPK017*/
/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(070))                       */ /*CPK017*/ /*CSM003*/
/**********  IF         COND(&PROCESS = '*GLOBAL') THEN(CHGVAR +
/**********               VAR(&UPSTATPOS) VALUE(170))                                     /*CPK017*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(170)                                        /*CSM003*/

             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMDMLIB &TODMLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TODMLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)

             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMDMLIB)
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)

/* Rename DPLIB on machine to match restore name. */
/**Only*do*this*if*not*performing*an*'XX'*to*'XX'*type*upgrade.**/ /*                  */ /*CSM003*/
/**********  IF         COND(&DBLIBID *NE &LIBGRP) THEN(DO)                            */ /*CSM003*/
             CHKOBJ     OBJ(&TODPLIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHKOBJ     OBJ(&FMDPLIB) OBJTYPE(*LIB)
                MONMSG     MSGID(CPF9801) EXEC(DO)
/**********        CHGVAR     VAR(&MEM) VALUE('Unable to find DPLIBs on +              */ /*CSM003*/
/**********                     machine.')                                             */ /*CSM003*/
                   CHGVAR     VAR(&MEM) VALUE('Unable to find GPLIBs on +
                                machine.')                                                /*CSM003*/
                   SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
             RNMOBJ     OBJ(&TODPLIB) OBJTYPE(*LIB) NEWOBJ(&FMDPLIB)
             MONMSG     MSGID(CPF2111) EXEC(DO)
                CHGVAR     VAR(&MEM) VALUE(&FMDPLIB *BCAT 'already +
                             exists on machine.')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**********  ENDDO                                                                     */ /*CSM003*/
             CHGVAR     VAR(&RSTLIB) VALUE(&FMDPLIB)

/* Submit restore of DPLIB. */
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(071)                                     */ /*CPK017*/
/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(071))                       */ /*CPK017*/ /*CSM003*/
/**********  IF         COND(&PROCESS = '*GLOBAL') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(171))                       */ /*CPK017*/ /*CSM003*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(171)                                        /*CSM003*/

             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMDPLIB &TODPLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TODPLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)

             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMDPLIB)
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)

/* Rename DTALIB on machine to match restore name. */
/**Only*do*this*if*not*performing*an*'XX'*to*'XX'*type*upgrade.**/ /*                  */ /*CSM003*/
/**********  IF         COND(&DBLIBID *NE &LIBGRP) THEN(DO)                            */ /*CSM003*/
             CHKOBJ     OBJ(&TODTALIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHKOBJ     OBJ(&FMDTALIB) OBJTYPE(*LIB)
                MONMSG     MSGID(CPF9801) EXEC(DO)
/**********        CHGVAR     VAR(&MEM) VALUE('Unable to find DTALIBs on +             */ /*CSM003*/
/**********                     machine.')                                             */ /*CSM003*/
                   CHGVAR     VAR(&MEM) VALUE('Unable to find GTALIBs on +
                                machine.')                                                /*CSM003*/
                   SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
             RNMOBJ     OBJ(&TODTALIB) OBJTYPE(*LIB) NEWOBJ(&FMDTALIB)
             MONMSG     MSGID(CPF2111) EXEC(DO)
                CHGVAR     VAR(&MEM) VALUE(&FMDTALIB *BCAT 'already +
                             exists on machine.')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**********  ENDDO                                                                     */ /*CSM003*/
             CHGVAR     VAR(&RSTLIB) VALUE(&FMDTALIB)

/* Submit restore of DTALIB. */
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(072)                                     */ /*CPK017*/
/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(072))                       */ /*CPK017*/ /*CSM003*/
/**********  IF         COND(&PROCESS = '*GLOBAL') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(172))                       */ /*CPK017*/ /*CSM003*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(172)                                        /*CSM003*/

             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMDTALIB +
                          &TODTALIB &RSTLIB &DEV &UPSTATPOS +
                          &ENDOPT)) JOB(&TODTALIB) JOBD(SETUP) +
                          JOBQ(SMJOBQ) OUTQ(*JOBD) RTGDTA(*JOBD) +
                          CURLIB(&PTFUPG)

             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMDTALIB)
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)

/* Submit restore of DVLIB. */
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(073)                                     */ /*CPK017*/
/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(073))                       */ /*CPK017*/ /*CSM003*/
/**********  IF         COND(&PROCESS = '*GLOBAL') THEN(CHGVAR +                       */ /*CSM003*/
/**********               VAR(&UPSTATPOS) VALUE(173))                       */ /*CPK017*/ /*CSM003*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(173)                                        /*CSM003*/

             CHGVAR     VAR(&RSTLIB) VALUE(&TODVLIB)
             SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMDVLIB &TODVLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TODVLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)

             CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMDVLIB)
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
/**********                                                               */ /*CBF012*/ /*AR886414*/
/***Rename*CBSLIB*on*machine*(as*created)*to*match*restore*name**/ /*     */ /*CBF012*/ /*AR886414*/
/**********  CHKOBJ     OBJ(&TOCBSLIB) OBJTYPE(*LIB)                      */ /*CBF012*/ /*AR886414*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                           */ /*CBF012*/ /*AR886414*/
/**********     CHKOBJ     OBJ(&FMCBSLIB) OBJTYPE(*LIB)                   */ /*CBF012*/ /*AR886414*/
/**********     MONMSG     MSGID(CPF9801) EXEC(DO)                        */ /*CBF012*/ /*AR886414*/
/**********        CHGVAR     VAR(&MEM) VALUE('Unable to find CBSLIBs on +
                                machine.')                                */ /*CBF012*/ /*AR886414*/
/**********        SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                     */ /*CBF012*/ /*AR886414*/
/**********        GOTO       CMDLBL(ABNOR)                               */ /*CBF012*/ /*AR886414*/
/**********     ENDDO                                                     */ /*CBF012*/ /*AR886414*/
/**********  ENDDO                                                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  RNMOBJ     OBJ(&TOCBSLIB) OBJTYPE(*LIB) NEWOBJ(&FMCBSLIB)    */ /*CBF012*/ /*AR886414*/
/**********  MONMSG     MSGID(CPF2111) EXEC(DO)                           */ /*CBF012*/ /*AR886414*/
/**********     CHGVAR     VAR(&MEM) VALUE(&FMCBSLIB *BCAT 'already +
                             exists on machine.')                         */ /*CBF012*/ /*AR886414*/
/**********     SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                        */ /*CBF012*/ /*AR886414*/
/**********     GOTO       CMDLBL(ABNOR)                                  */ /*CBF012*/ /*AR886414*/
/**********  ENDDO                                                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&RSTLIB) VALUE(&FMCBSLIB)                     */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/***Submit*restore*of*CBSLIB***/ /*                                       */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(189)                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMCBSLIB &TOCBSLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TOCBSLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)       */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMCBSLIB)                       */ /*CBF012*/ /*AR886414*/
/**********  SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                           */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**Rename*CBALIB*on*machine*(as*created)*to*match*restore*name.**/ /*     */ /*CBF012*/ /*AR886414*/
/**********  CHKOBJ     OBJ(&TOCBALIB) OBJTYPE(*LIB)                      */ /*CBF012*/ /*AR886414*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                           */ /*CBF012*/ /*AR886414*/
/**********     CHKOBJ     OBJ(&FMCBALIB) OBJTYPE(*LIB)                   */ /*CBF012*/ /*AR886414*/
/**********     MONMSG     MSGID(CPF9801) EXEC(DO)                        */ /*CBF012*/ /*AR886414*/
/**********        CHGVAR     VAR(&MEM) VALUE('Unable to find CBALIBs on +
                                machine.')                                */ /*CBF012*/ /*AR886414*/
/**********        SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                     */ /*CBF012*/ /*AR886414*/
/**********        GOTO       CMDLBL(ABNOR)                               */ /*CBF012*/ /*AR886414*/
/**********     ENDDO                                                     */ /*CBF012*/ /*AR886414*/
/**********  ENDDO                                                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  RNMOBJ     OBJ(&TOCBALIB) OBJTYPE(*LIB) NEWOBJ(&FMCBALIB)    */ /*CBF012*/ /*AR886414*/
/**********  MONMSG     MSGID(CPF2111) EXEC(DO)                           */ /*CBF012*/ /*AR886414*/
/**********     CHGVAR     VAR(&MEM) VALUE(&FMCBALIB *BCAT 'already +
                             exists on machine.')                         */ /*CBF012*/ /*AR886414*/
/**********     SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                        */ /*CBF012*/ /*AR886414*/
/**********     GOTO       CMDLBL(ABNOR)                                  */ /*CBF012*/ /*AR886414*/
/**********  ENDDO                                                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&RSTLIB) VALUE(&FMCBALIB)                     */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**Submit*restore*of*CBALIB.**/ /*                                        */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(190)                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMCBALIB &TOCBALIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TOCBALIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)       */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMCBALIB)                       */ /*CBF012*/ /*AR886414*/
/**********  SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                           */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/***Rename*BFLIB*on*machine*(as*created)*to*match*restore*name***/ /*     */ /*CBF012*/ /*AR886414*/
/**********  CHKOBJ     OBJ(&TOBFLIB) OBJTYPE(*LIB)                       */ /*CBF012*/ /*AR886414*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                           */ /*CBF012*/ /*AR886414*/
/**********     CHKOBJ     OBJ(&FMBFLIB) OBJTYPE(*LIB)                    */ /*CBF012*/ /*AR886414*/
/**********     MONMSG     MSGID(CPF9801) EXEC(DO)                        */ /*CBF012*/ /*AR886414*/
/**********        CHGVAR     VAR(&MEM) VALUE('Unable to find BFLIBs on +
                                machine.')                                */ /*CBF012*/ /*AR886414*/
/**********        SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                     */ /*CBF012*/ /*AR886414*/
/**********        GOTO       CMDLBL(ABNOR)                               */ /*CBF012*/ /*AR886414*/
/**********     ENDDO                                                     */ /*CBF012*/ /*AR886414*/
/**********  ENDDO                                                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  RNMOBJ     OBJ(&TOBFLIB) OBJTYPE(*LIB) NEWOBJ(&FMBFLIB)      */ /*CBF012*/ /*AR886414*/
/**********  MONMSG     MSGID(CPF2111) EXEC(DO)                           */ /*CBF012*/ /*AR886414*/
/**********     CHGVAR     VAR(&MEM) VALUE(&FMBFLIB *BCAT 'already +
                             exists on machine.')                         */ /*CBF012*/ /*AR886414*/
/**********     SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                        */ /*CBF012*/ /*AR886414*/
/**********     GOTO       CMDLBL(ABNOR)                                  */ /*CBF012*/ /*AR886414*/
/**********  ENDDO                                                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&RSTLIB) VALUE(&FMBFLIB)                      */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/***Submit*restore*of*BFLIB***/ /*                                        */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&UPSTATPOS) VALUE(191)                        */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMBFLIB &TOBFLIB +
                          &RSTLIB &DEV &UPSTATPOS &ENDOPT)) +
                          JOB(&TOBFLIB) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)       */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**********  CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +
                          library ' *CAT &FMBFLIB)                        */ /*CBF012*/ /*AR886414*/
/**********  SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                           */ /*CBF012*/ /*AR886414*/
/**********                                                               */ /*CBF012*/ /*AR886414*/
/**Restore*DZLIB*only*if**ZONE.**/ /*                                       */ /*CPK017*/ /*CSM003*/
/**********  IF         COND(&PROCESS = '*ZONE  ')  THEN(DO)                */ /*CPK017*/ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**Rename*DZLIB*on*machine*to*match*restore*name.**/ /*                                */ /*CSM003*/
/**Only*do*this*if*not*performing*an*'XX'*to*'XX'*type*upgrade.**/ /*                  */ /*CSM003*/
/**********     IF         COND(&DBLIBID *NE &LIBGRP) THEN(DO)                         */ /*CSM003*/
/**********        CHKOBJ     OBJ(&TODZLIB) OBJTYPE(*LIB)                              */ /*CSM003*/
/**********        MONMSG     MSGID(CPF9801) EXEC(DO)                                  */ /*CSM003*/
/**********           CHKOBJ     OBJ(&FMDZLIB) OBJTYPE(*LIB)                           */ /*CSM003*/
/**********           MONMSG     MSGID(CPF9801) EXEC(DO)                               */ /*CSM003*/
/**********              CHGVAR     VAR(&MEM) VALUE('Unable to find DZLIBs on +        */ /*CSM003*/
/**********                           machine.')                                       */ /*CSM003*/
/**********              SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                            */ /*CSM003*/
/**********              GOTO       CMDLBL(ABNOR)                                      */ /*CSM003*/
/**********           ENDDO                                                            */ /*CSM003*/
/**********        ENDDO                                                               */ /*CSM003*/
/**********        RNMOBJ     OBJ(&TODZLIB) OBJTYPE(*LIB) NEWOBJ(&FMDZLIB)             */ /*CSM003*/
/**********        MONMSG     MSGID(CPF2111) EXEC(DO)                                  */ /*CSM003*/
/**********           CHGVAR     VAR(&MEM) VALUE(&FMDZLIB *BCAT 'already +             */ /*CSM003*/
/**********                        exists on machine.')                                */ /*CSM003*/
/**********           SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                               */ /*CSM003*/
/**********           GOTO       CMDLBL(ABNOR)                                         */ /*CSM003*/
/**********        ENDDO                                                               */ /*CSM003*/
/**********     ENDDO                                                                  */ /*CSM003*/
/**********     CHGVAR     VAR(&RSTLIB) VALUE(&FMDZLIB)                                */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**Submit*restore*of*DZLIB.**/ /*                                                      */ /*CSM003*/
/**********     CHGVAR     VAR(&UPSTATPOS) VALUE(074)                                  */ /*CSM003*/
/**********     CHGVAR     VAR(&ENDOPT) VALUE('*REWIND')                               */ /*CSM003*/
/**********     SBMJOB     CMD(CALL PGM(SMC1062) PARM(&FMDZLIB +                       */ /*CSM003*/
/**********                  &TODZLIB &RSTLIB &DEV &UPSTATPOS +                        */ /*CSM003*/
/**********                  &ENDOPT)) JOB(&TODZLIB) JOBD(SETUP) +                     */ /*CSM003*/
/**********                  JOBQ(SMJOBQ) OUTQ(*JOBD) RTGDTA(*JOBD) +                  */ /*CSM003*/
/**********                  CURLIB(&PTFUPG)                                           */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**********     CHGVAR     VAR(&MEM) VALUE('Job submitted to restore +                 */ /*CSM003*/
/**********                  library ' *CAT &FMDZLIB)                                  */ /*CSM003*/
/**********     SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)                                     */ /*CSM003*/
/**********                                                                            */ /*CSM003*/
/**********  ENDDO                                                          */ /*CPK017*/ /*CSM003*/

/**Submit*job*to*rename*libraries*after*removing*them*from*library*list;*only**/ /*    */ /*CSM003*/
/**do*this*if*not*performing*an*'XX'*to*'XX'*type*upgrade.*********************/ /*    */ /*CSM003*/
/* Submit job to rename libraries after removing them from library list. */               /*CSM003*/
/**********  IF         COND(&DBLIBID *NE &LIBGRP) THEN(DO)                            */ /*CSM003*/
             RMVLIBLE   LIB(&FMDMLIB)
             MONMSG     MSGID(CPF2104)
             RMVLIBLE   LIB(&FMDPLIB)
             MONMSG     MSGID(CPF2104)
             RMVLIBLE   LIB(&FMDTALIB)
             MONMSG     MSGID(CPF2104)
             RMVLIBLE   LIB(&FMCBSLIB)                                                    /*CBF012*/
             MONMSG     MSGID(CPF2104)                                                    /*CBF012*/
             RMVLIBLE   LIB(&FMCBALIB)                                                    /*CBF012*/
             MONMSG     MSGID(CPF2104)                                                    /*CBF012*/
             RMVLIBLE   LIB(&FMBFLIB)                                                     /*CBF012*/
             MONMSG     MSGID(CPF2104)                                                    /*CBF012*/
/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(DO)                 */ /*CPK017*/ /*CSM003*/
/**********     RMVLIBLE   LIB(&FMDZLIB)                                               */ /*CSM003*/
/**********     MONMSG     MSGID(CPF2104)                                              */ /*CSM003*/
/**********  ENDDO                                                          */ /*CPK017*/ /*CSM003*/

/**********     CHGVAR     VAR(&UPSTATPOS) VALUE(075)                                  */ /*CPK017*/
/**********     SBMJOB     CMD(CALL PGM(SMC1063) PARM(&FMDMLIB &TODMLIB +              */ /*CPK017*/
/**********                  &FMDPLIB &TODPLIB &FMDTALIB &TODTALIB +                   */ /*CPK017*/
/**********                  &FMDZLIB &TODZLIB &UPSTATPOS)) +                          */ /*CPK017*/
/**********                  JOB(RENAME) JOBD(SETUP) JOBQ(SMJOBQ) +                    */ /*CPK017*/
/**********                  OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)                 */ /*CPK017*/

/**********     IF         COND(&PROCESS = '*ZONE  ') THEN(CHGVAR +                    */ /*CSM003*/
/**********                  VAR(&UPSTATPOS) VALUE(075))                    */ /*CPK017*/ /*CSM003*/
/**********     IF         COND(&PROCESS = '*GLOBAL') THEN(CHGVAR +                    */ /*CSM003*/
/**********                  VAR(&UPSTATPOS) VALUE(175))                    */ /*CPK017*/ /*CSM003*/
             CHGVAR     VAR(&UPSTATPOS) VALUE(175)
/**********  SBMJOB     CMD(CALL PGM(SMC1063) PARM(&FMDMLIB &TODMLIB +                 */ /*CSM003*/
/**********               &FMDPLIB &TODPLIB &FMDTALIB &TODTALIB +                      */ /*CSM003*/
/**********               &FMDZLIB &TODZLIB &UPSTATPOS &PROCESS)) +                    */ /*CSM003*/
/**********               JOB(RENAME) JOBD(SETUP) JOBQ(SMJOBQ) +                       */ /*CSM003*/
/**********               OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)         */ /*CPK017*/ /*CSM003*/
/**********  SBMJOB     CMD(CALL PGM(SMC1063) PARM(&FMDMLIB &TODMLIB +
                          &FMDPLIB &TODPLIB &FMDTALIB &TODTALIB +
                          &UPSTATPOS)) JOB(RENAME) JOBD(SETUP) +
                          JOBQ(SMJOBQ) OUTQ(*JOBD) RTGDTA(*JOBD) +
                          CURLIB(&PTFUPG)                                   */ /*CSM003*/ /*CBF012*/
             SBMJOB     CMD(CALL PGM(SMC1063) PARM(&FMDMLIB &TODMLIB +
                          &FMDPLIB &TODPLIB &FMDTALIB &TODTALIB +
                          &FMCBSLIB &TOCBSLIB &FMCBALIB &TOCBALIB +
                          &FMBFLIB &TOBFLIB &UPSTATPOS)) +
                          JOB(RENAME) JOBD(SETUP) JOBQ(SMJOBQ) +
                          OUTQ(*JOBD) RTGDTA(*JOBD) CURLIB(&PTFUPG)                       /*CBF012*/

/**********  ENDDO                                                                     */ /*CSM003*/

             GOTO       CMDLBL(ENDPGM)

/* Abnormal end. */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
