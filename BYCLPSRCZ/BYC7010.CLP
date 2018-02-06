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
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN021             Date : 24nOV0             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     LLN021 - BoE Profit and Loss return                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)     /* System Prefix */
             DCL        VAR(&MERIDSVR) TYPE(*CHAR) LEN(10)  /* Meridian Server*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
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
