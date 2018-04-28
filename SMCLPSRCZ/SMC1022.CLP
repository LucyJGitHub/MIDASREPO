/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Initial system setup')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1022 - Initial set up of Midas system                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CBF012             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 12Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 09Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CBF012 - BF Infrastructure: Upgradability                   */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to library list for MidasPlus.             */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &GPFXSVAL)                                          /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&GPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GPSBSID) TYPE(*CHAR) LEN(2)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Create Midas Info Screen data area in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG MSGID(CPF2105)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          TEXT('Midas Info Screen Data Area')
 
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL2*                                         */ /*  */ /*CSM005*/ /*CUP033*/
 
/**Check*that*relevant*System*Values*have*been*entered.**/ /*               */ /*CSM005*/ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &GPSBSID *EQ ' ') +                    */ /*CUP033*/
/**********               THEN(DO)                                          */ /*CSM005*/ /*CUP033*/
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&LIBGRP) VALUE(&GIVAL)                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &GPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&GPSBSID) VALUE(&GIVAL)                                 /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CSM005*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                      /*CSM005*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CSM005*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                      /*CSM005*/
                CALL       PGM(SCC0010) PARM('SMC1022' 'ENTER' ' ')                       /*CSM005*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CSM005*/
             ENDDO                                                                        /*CSM005*/
 
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
 
/**Retrieve*system*prefix.**/ /*                                                       */ /*CSM003*/
/**********  CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 62 2))                         */ /*CSM003*/
/**********  IF         COND(&LIBGRP *EQ '  ') THEN(DO)                                */ /*CSM003*/
/**********  CHGVAR     VAR(&LIBGRP) VALUE(&SBSID)                                     */ /*CUP033*/
/**********  ENDDO                                                                     */ /*CSM003*/
 
/* Call program to change name of shared zone libraries on SMSETUPD. */                   /*CSM005*/
             OVRDBF     FILE(SMSETUPD) TOFILE(SMSETUL1) OVRSCOPE(*JOB)                    /*CSM005*/
             CALL       PGM(SM000110) PARM('##' &GPSBSID)                                 /*CSM005*/
             DLTOVR     FILE(SMSETUPD) LVL(*JOB)                                          /*CSM005*/
 
/* Call program to create libraries for standard Midas library list  */
/*  and owning user profile, etc.                                    */
/**********  CALL       PGM(SMC1023) PARM(&LIBGRP)   */                                   /*CBF012*/
             CALL       PGM(SMC1023) PARM(&LIBGRP &GPSBSID)                               /*CBF012*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Call program to create objects required in the JLIB. */
             CALL       PGM(SMC1024) PARM(&LIBGRP)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Call program to create objects required in the DILIB. */
             CALL       PGM(SMC1027) PARM(&LIBGRP)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set records on SMSETUPD back to original. */                                           /*CSM005*/
             OVRDBF     FILE(SMSETUPD) TOFILE(SMSETUL1) OVRSCOPE(*JOB)                    /*CSM005*/
             CALL       PGM(SM000110) PARM(&GPSBSID '##')                                 /*CSM005*/
             DLTOVR     FILE(SMSETUPD) LVL(*JOB)                                          /*CSM005*/
 
             GOTO       CMDLBL(ENDPGM)
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1022') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1022' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
