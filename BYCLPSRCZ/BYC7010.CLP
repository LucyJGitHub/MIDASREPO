/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE End Meridian Server')                       */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC7010 - End Meridian Server                                 */
/*                                                                   */
/*     (c) Finastra International Limited 2003                       */
/*                                                                   */
/*       Last Amend No. MD050952           Date 16May18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      LLN021             Date : 24nOV0             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD050952 - Component fails when MidasFiRE is setup in       */
/*                  Windows                                          */
/*       MD046248 - Finastra Rebranding                              */
/*     LLN021 - BoE Profit and Loss return                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)     /* System Prefix */
             DCL        VAR(&MERIDSVR) TYPE(*CHAR) LEN(10)  /* Meridian Server*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
             DCL        VAR(&RTCDE)     TYPE(*CHAR) LEN(7)                              /*MD050952*/
             DCL        VAR(&MIDASFIRE) TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK2)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL2)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK3)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL3)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK4)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL4)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK5)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL5)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK6)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL6)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK7)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL7)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK8)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL8)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK9)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL9)     TYPE(*CHAR) LEN(200)                            /*MD050952*/
             DCL        VAR(&SVALK0)    TYPE(*CHAR) LEN(20)                             /*MD050952*/
             DCL        VAR(&SVAL10)    TYPE(*CHAR) LEN(200)                            /*MD050952*/                        
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/* Get 'MidasFiREInWindows' system value from file SDSVALPD */                          /*MD050952*/
                                                                                        /*MD050952*/
             CALL       PGM(AOSVALR0) PARM(&RTCDE +
                          'MidasFiREInWindows' &MIDASFIRE &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK0 &SVAL10)                                              /*MD050952*/
                                                                                        /*MD050952*/
/* If the 'MidasFiREInWindows' system value is missing then end abnormally */           /*MD050952*/
                                                                                        /*MD050952*/
             IF         COND(%SST(&MIDASFIRE 1 4) *EQ '*NRF') THEN(GOTO +
                         CMDLBL(ABNORM))                                                /*MD050952*/
                                                                                        /*MD050952*/
/* If MidasFiRE is setup in Windows, exit program */                                    /*MD050952*/
                                                                                        /*MD050952*/
             IF         COND(&MIDASFIRE *EQ 'Y') THEN(GOTO +
                         CMDLBL(EXIT))                                                  /*MD050952*/

/* Add Meridian management library */
             ADDLIBLE   LIB(MERIDMGMT)
             MONMSG     MSGID(CPF2103)
 
/* Retrieve system prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYS)
             CHGVAR     VAR(&MERIDSVR) VALUE('FIRE_' *CAT &SYS)
 
/* End Meridian Server */
             ENDMRDSVR  SERVERNAME(&MERIDSVR)
             MONMSG     MSGID(CPF0001 CPF0002 CPD0006)
             DLYJOB     DLY(60)
 
/* Remove Meridian management library */
             RMVLIBLE   LIB(MERIDMGMT)
             MONMSG     MSGID(CPF2104)
 
/* End program normally  */
             RCLRSC
             GOTO EXIT
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC7010 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 EXIT:       ENDPGM
