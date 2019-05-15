/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Rename database libraries')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1063 - Rename database libraries                         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR886414           Date 05Jan12              */
/*                      CBF012             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM003             Date 13Jun05              */
/*                      CPK017             Date 06Nov03              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR886414 - Creation of CBS, CBA and BF libraries in SMSETUPD*/
/*                  not catered                                      */
/*       CBF012 - BF Infrastructure: Upgradability                   */
/*       CSM003 - Use system values rather than UPSTAT.              */
/*       CPK017 - Midas Plus implementation.                         */
/*                Rename DZLIB for '*ZONE  ' Processing only.        */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&FMDMLIB &TODMLIB &FMDPLIB &TODPLIB +                     */ /*CPK017*/
/**********               &FMDTALIB &TODTALIB &FMDZLIB &TODZLIB +                      */ /*CPK017*/
/**********               &UPSTATPOS)                                                  */ /*CPK017*/
/**********  PGM        PARM(&FMDMLIB &TODMLIB &FMDPLIB &TODPLIB +                     */ /*CSM003*/
/**********               &FMDTALIB &TODTALIB &FMDZLIB &TODZLIB +                      */ /*CSM003*/
/**********               &UPSTATPOS &PROCESS)                              */ /*CPK017*/ /*CSM003*/
/**********  PGM        PARM(&FMDMLIB &TODMLIB &FMDPLIB &TODPLIB +
                          &FMDTALIB &TODTALIB &UPSTATPOS)                   */ /*CSM003*/ /*CBF012*/
             PGM        PARM(&FMDMLIB &TODMLIB &FMDPLIB &TODPLIB +
                          &FMDTALIB &TODTALIB &FMCBSLIB &TOCBSLIB +
                          &FMCBALIB &TOCBALIB &FMBFLIB &TOBFLIB +
                          &UPSTATPOS)                                                     /*CBF012*/
 
             DCL        VAR(&FMDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMDPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMDTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FMCBSLIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&TOCBSLIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&FMCBALIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&TOCBALIB) TYPE(*CHAR) LEN(10)                                /*CBF012*/
             DCL        VAR(&FMBFLIB) TYPE(*CHAR) LEN(10)                                 /*CBF012*/
             DCL        VAR(&TOBFLIB) TYPE(*CHAR) LEN(10)                                 /*CBF012*/
/**********  DCL        VAR(&FMDZLIB) TYPE(*CHAR) LEN(10)                              */ /*CSM003*/
/**********  DCL        VAR(&TODZLIB) TYPE(*CHAR) LEN(10)                              */ /*CSM003*/
             DCL        VAR(&UPSTATPOS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PROCESS) TYPE(*CHAR) LEN(7)                                  /*CPK017*/
 
             DCL        VAR(&UPSTATPOSN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(132)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&UPSTATPOSN) VALUE(&UPSTATPOS)
             CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOSN 1)) VALUE('A')
 
/* Rename libraries. */
RENAME:
             RNMOBJ     OBJ(&FMDMLIB) OBJTYPE(*LIB) NEWOBJ(&TODMLIB)
 
             RNMOBJ     OBJ(&FMDPLIB) OBJTYPE(*LIB) NEWOBJ(&TODPLIB)
 
             RNMOBJ     OBJ(&FMDTALIB) OBJTYPE(*LIB) NEWOBJ(&TODTALIB)
 
             IF         COND(&FMCBSLIB *NE ' ') THEN(DO)                                /*AR886414*/
                                                                                        /*AR886414*/
             RNMOBJ     OBJ(&FMCBSLIB) OBJTYPE(*LIB) NEWOBJ(&TOCBSLIB)                    /*CBF012*/
                                                                                          /*CBF012*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             IF         COND(&FMCBALIB *NE ' ') THEN(DO)                                /*AR886414*/
                                                                                        /*AR886414*/
             RNMOBJ     OBJ(&FMCBALIB) OBJTYPE(*LIB) NEWOBJ(&TOCBALIB)                    /*CBF012*/
                                                                                          /*CBF012*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             RNMOBJ     OBJ(&FMBFLIB) OBJTYPE(*LIB) NEWOBJ(&TOBFLIB)                      /*CBF012*/
                                                                                          /*CBF012*/
/**********  IF         COND(&PROCESS = '*ZONE  ') THEN(DO)                 */ /*CPK017*/ /*CSM003*/
/**********     RNMOBJ     OBJ(&FMDZLIB) OBJTYPE(*LIB) NEWOBJ(&TODZLIB)                */ /*CSM003*/
/**********  ENDDO                                                          */ /*CPK017*/ /*CSM003*/
 
             CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOS 1)) VALUE('C')
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal end. */
ABNOR:
             CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOSN 1)) VALUE('F')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MEM) VALUE('SMC1063 - Job has ended +
                          abnormally')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
