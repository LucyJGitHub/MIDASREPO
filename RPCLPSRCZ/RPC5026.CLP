/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - FX Rates Upload Request')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC5026 - Midas TrOpics I/face - FX Rate Upload Request     */
/*                                                                   */
/*       (C) COPYRIGHT Misys International Banking Systems sa. 2001  */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSD026             Date 05Apr05              */
/*                      UTROPX  *Create    Date 11DEC01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TrOpics Interface.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CHLNAME)  TYPE(*CHAR) LEN(50)            /*CSD026*/
             DCL        VAR(&FILE)     TYPE(*CHAR) LEN(10)
/*********** DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(275)                     */        /*CSD026*/
/*********** DCL        VAR(&CMD)      TYPE(*CHAR) LEN(289)                     */        /*CSD026*/
             DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(2750)                              /*CSD026*/
             DCL        VAR(&CMD)      TYPE(*CHAR) LEN(2764)                              /*CSD026*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                           Copyright Misys International Banking +
                           Systems sa. 2001')
 
/* Global Monitor Message:                                         */
/* If an unmonitorred message occurs perform error processing      */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC5026 Midas TrOpics I/face - FX Rates +
                          Upload') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
 
/* Set TIJOBD libl */
 
             RTVJOBD    JOBD(TIJOBD) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                 */                    /*CSD026*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSD026*/
 
/* Stop Commitment Control                                           */
 
/*           ENDCMTCTL                                               */
             MONMSG     MSGID(CPF0000)
 
/* Stop Feeder Job                                                   */
 
/**********  CALL       PGM(KMDJFC)   */
/**  Start channel if not   ***/                                      /*CSD026*/
/***         RTVDTAARA  DTAARA(RPTROPXCHL (1 25)) RTNVAR(&CHLNAME)    /*CSD026*/
/***         MONMSG     MSGID(CPF1015)                                /*CSD026*/
/***         IF         COND(&CHLNAME *NE '         ') THEN(DO)       /*CSD026*/
/***         STRMQMCHL  CHLNAME(&CHLNAME)                             /*CSD026*/
/***         MONMSG     MSGID(CPF0001)                                /*CSD026*/
/***         DLYJOB     DLY(15)                                       /*CSD026*/
/***         ENDDO                                                    /*CSD026*/
LON023:                                                               /*CSD026*/
 
/* Use Replication command to process all records on each table.     */
 
/* 1. Rate */
             CALL       PGM(RP5026)
             KMDDLC     PRODUCT(OPXIN) TYPE(*LIST) TABLES(SDCURRPD +
                          FWDRTFE)
 
/* Set MIDASIC libl */
 
             RTVJOBD    JOBD(MIDASIC) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                       */              /*CSD026*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSD026*/
 
/* Restart Commitment Control */
 
   /*        STRCMTCTL  LCKLVL(*ALL)                            */
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC5025 ' *CAT &FILE +
                          *CAT ' Download - Ended in Error') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             ENDPGM
