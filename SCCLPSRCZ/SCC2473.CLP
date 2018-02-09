/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Delete elegible journal receivers')          */
/*********************************************************************/
/*                                                                   */
/*          MIDAS SYSTEM CONTROL MODULE                              */
/*                                                                   */
/*          SCC2473 - DELETE ELIGIBLE JOURNAL RECEIVERS              */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB023A            Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260399             Date 21May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG5832           Date 19Apr05               */
/*                      CSC020 *CREATE    Date 31Mar04               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB023A - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       260399 - Take no action if DDM file details missing.        */
/*       BUG5832 - Remove DMPCLPGM                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
             DCLF       FILE(SDBANKPD)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RCVRTNA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RCVRTN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&RCVRTNONE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CURCMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVRTNDAY) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RCVRTNCMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JRRETAIN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JSRETAIN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&OLDESTRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVSAVDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)
/*/COPY SDCPYSRC,SDSVALDCL                                                                        */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/*                                                                                                */
/* Copyright statement definition at runtime                                                      */
/*                                                                                                */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
/*                                                                                                */
/*  Determine the 2-character system I.D.                                                         */
/*                                                                                                */
              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/*                                                                                                */
/*  Determine the run day number.                                                                 */
/*                                                                                                */
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)
             RCVF
/*                                                                                                */
/*  Determine the name of the current component.                                                  */
/*                                                                                                */
             RTVJOBA    JOB(&CURCMP)
/*                                                                                                */
/*  Check for Switchable feature CSC018.                                                          */
/*                                                                                                */
             CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)
/*                                                                                                */
/* If Feature CSC018 is 'on',                                                                     */
/*                                                                                                */
             IF         COND(&CSC018 *EQ '       ') THEN(DO)
/*                                                                                                */
/*  Get the journaling and high availability system values                                        */
/*                                                                                                */
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'ReceiverRetainDays' &SVAL1 +
                          'ReceiverRetainOne' &SVAL2 +
                          'HighAvlRmtJrnActive' &SVAL3 +
                          'HighAvlIgnTgtOnDel' &SVAL4 +
                          'HighAvlMangBackUpJrn' &SVAL5 +
                          'HighAvlDdmFileName' &SVAL6 +
                          'HighAvlDdmFileLib' &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)
/*                                                                                                */
/* If there is an error finding any system value, then end abnormally                             */
/*                                                                                                */
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/*                                                                                                */
/*  Determine whether remote journaling is being used                                             */
/*                                                                                                */
             CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL3 1 1))
/*                                                                                                */
/*  If remote journaling is used, determine whether to ignore                                     */
/*  target receivers upon deletion.                                                               */
/*                                                                                                */
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL4 1 1))
/*                                                                                                */
/*  Calculate the backup machine remote journal library.                                          */
/*                                                                                                */
             CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'JLIBRMT ')
             ENDDO
/*                                                                                                */
/*  Determine whether backup journal management is being used                                     */
/*                                                                                                */
             CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL5 1 1))
/*                                                                                                */
/*  If backup journal management is being used, calculate the                                     */
/*  name of the backup journal library.                                                           */
/*                                                                                                */
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'JLIB    ')
             ENDDO
/*                                                                                                */
/*  If remote journaling OR backup journal management are being used,                             */
/*  determine DDM file and library.                                                               */
/*                                                                                                */
             IF         COND((&RMTJR6 *EQ 'Y') *OR (&MNGBJ6 *EQ +
                          'Y')) THEN(DO)
             CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL6 1 10))
             CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL7 1 10))
/*********************************************************************/                   /*260399*/
/***If*any*of*these*fields*are*blank,*then*remote*journaling*and******/                   /*260399*/
/***backup*receiver*management*may*not*be*used.***********************/                   /*260399*/
/*********************************************************************/                   /*260399*/
/*********   IF         COND((&DDMRM6 *EQ '          ') *OR (&DDMLI6 +                    /*260399*/
/*********                *EQ '          ')) THEN(DO)                                     /*260399*/
/*********   CHGVAR     VAR(&RMTJR6) VALUE('N')                                           /*260399*/
/*********   CHGVAR     VAR(&MNGBJ6) VALUE('N')                                           /*260399*/
/*********   ENDDO                                                                        /*260399*/
             ENDDO
 
             ENDDO
/*                                                                                                */
/* If Feature CSC018 is NOT 'on',                                                                 */
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
/*  Retrieve system values for journaling.                                                        */
/*                                                                                                */
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'ReceiverRetainDays' &SVAL1 +
                          'ReceiverRetainOne' &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)
/*                                                                                                */
/* If there is an error finding any system value then end abnormally                              */
/*                                                                                                */
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNORMAL))
 
             ENDDO
/*                                                                                                */
/*  Determine number of working days to retain journal receivers.                                 */
/*                                                                                                */
             CHGVAR     VAR(&RCVRTNA) VALUE(%SST(&SVAL1 1 2))
             CHGVAR     VAR(&RCVRTN) VALUE(&RCVRTNA)
/*                                                                                                */
/*  Determine whether to retain one extra receiver.                                               */
/*                                                                                                */
             CHGVAR     VAR(&RCVRTNONE) VALUE(%SST(&SVAL2 1 1))
/*                                                                                                */
/*  Determine  receiver retain date and receiver retain component, where                          */
/*     Receiver retain date, &RCVRTNDAY, is day number when oldest receiver to be                 */
/*      retained was created.                                                                     */
/*     Receiver retain component, &RCVRTNCMP, is the name of the component that created the       */
/*******oldest*receiver*to*be*retained.**(either*SCC0405*or*SCC1711)**/                  /*CCB023A*/
/*      oldest receiver to be retained.  (either SCC0405 or SCC1711001)                  /*CCB023A*/
/*                                                                                                */
/*  If it is NOT required to retain an extra receiver,                                            */
/*                                                                                                */
             IF         COND(&RCVRTNONE *EQ 'N') THEN(DO)
/*                                                                                                */
/***If*this*is*component*SCC1711,*************************************/                  /*CCB023A*/
/* If this is component SCC1711001 */                                                    /*CCB023A*/
/*                                                                                                */
/**********  IF         COND(&CURCMP *EQ 'SCC1711   ') THEN(DO)      */                  /*CCB023A*/
             IF         COND(&CURCMP *EQ 'SCC1711001') THEN(DO)                          /*CCB023A*/
/*                                                                                                */
/*  calculate receiver retain date and component.                                                 */
/*                                                                                                */
             CALL       PGM(SC002476) PARM(&BJRDNB &RCVRTN +
                          &RCVRTNDAY)
             CHGVAR     VAR(&RCVRTNCMP) VALUE('SCC0405   ')
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  If this is component SCC0405,                                                                 */
/*                                                                                                */
             IF         COND(&CURCMP *EQ 'SCC0405   ') THEN(DO)
/*                                                                                                */
/*  calculate receiver retain date and component.                                                 */
/*                                                                                                */
             CHGVAR     VAR(&RCVRTN) VALUE(&RCVRTN - 1)
             CALL       PGM(SC002476) PARM(&BJRDNB &RCVRTN +
                          &RCVRTNDAY)
/**********  CHGVAR     VAR(&RCVRTNCMP) VALUE('SCC1711   ')          */                  /*CCB023A*/
             CHGVAR     VAR(&RCVRTNCMP) VALUE('SCC1711001')                              /*CCB023A*/
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  If it IS required to retain an extra receiver,                                                */
/*                                                                                                */
             IF         COND(&RCVRTNONE *EQ 'Y') THEN(DO)
/*                                                                                                */
/***If*this*is*component*SCC1711,************************************/                   /*CCB023A*/
/*  If this is component SCC1711001,                                                     /*CCB023A*/
/*                                                                                                */
/**********  IF         COND(&CURCMP *EQ 'SCC1711   ') THEN(DO)      */                  /*CCB023A*/
             IF         COND(&CURCMP *EQ 'SCC1711001') THEN(DO)                          /*CCB023A*/
/*                                                                                                */
/*  calculate receiver retain date and component.                                                 */
/*                                                                                                */
             CALL       PGM(SC002476) PARM(&BJRDNB &RCVRTN +
                          &RCVRTNDAY)
/**********  CHGVAR     VAR(&RCVRTNCMP) VALUE('SCC1711   ')          */                  /*CCB023A*/
             CHGVAR     VAR(&RCVRTNCMP) VALUE('SCC1711001')                              /*CCB023A*/
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  If this is component SCC0405,                                                                 */
/*                                                                                                */
             IF         COND(&CURCMP *EQ 'SCC0405   ') THEN(DO)
/*                                                                                                */
/*  calculate receiver retain date and component.                                                 */
/*                                                                                                */
             CALL       PGM(SC002476) PARM(&BJRDNB &RCVRTN +
                          &RCVRTNDAY)
             CHGVAR     VAR(&RCVRTNCMP) VALUE('SCC0405   ')
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Use the command SCRTVJRCV to obtain the name of the last journal receiver to be retained.     */
/*                                                                                                */
             SCRTVJRCV  RUNDAY(&RCVRTNDAY) COMP(&RCVRTNCMP) +
                          CSEQ(00001) RECEIVER(&JRRETAIN) +
                          SEQ(&JSRETAIN)
/*                                                                                                */
/*  If a receiver name was not retrieved, exit program.                                           */
/*                                                                                                */
             IF         COND(&JRRETAIN *EQ '          ') THEN(GOTO +
                          CMDLBL(ENDER))
/*                                                                                                */
/*  Verify that the journal receiver exists.  If it does not, exit program.                       */
/*                                                                                                */
             CHKOBJ     OBJ(&JRRETAIN) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) CMPDTA(*NONE) EXEC(DO)
             GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  Verify that the journal receiver is part of the current chain of receivers for 'ICJRN'.       */
/*  If if is not, then exit program.                                                              */
/*                                                                                                */
             RTVJRNE    JRN(ICJRN) RCVRNG(&JRRETAIN) TOENT(*FIRST)
             MONMSG     MSGID(CPF7053) CMPDTA(*NONE) EXEC(DO)
             GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  Delete any journal receivers that are 'older' than the last receiver to be retained.          */
/*                                                                                                */
LOOPER:
/*                                                                                                */
/*  Determine the 'oldest' journal receiver in the 'ICJRN' receiver chain.                        */
/*                                                                                                */
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) RTNRCV(&OLDESTRCV)
/*                                                                                                */
/*  If it is the receiver to be retained, exit program.                                           */
/*                                                                                                */
             IF         COND(&OLDESTRCV *EQ &JRRETAIN) THEN(DO)
             GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  Determine whether the receiver has been saved.  If not, exit program.                         */
/*                                                                                                */
             RTVOBJD    OBJ(&OLDESTRCV) OBJTYPE(*JRNRCV) +
                          SAVDATE(&RCVSAVDAT)
             IF         COND(&RCVSAVDAT *EQ '             ') THEN(DO)
             CHGDTAARA  DTAARA(JNSTAT (11 10)) VALUE(&OLDESTRCV)
             GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  If it is not the receiver to be retained,                                                     */
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
/*  delete the receiver.                                                                          */
/*                                                                                                */
/*                                                                                                */
/* If Feature CSC018 is 'on', (journal features for high availability),                           */
/* and if remote journaling is being used and if 'Ignore                                          */
/* Target Receiver' is 'Y', then delete receiver with option *IGNTGTRCV                           */
/*                                                                                                */
             IF         COND((&CSC018 *EQ '       ') *AND (&RMTJR6 +
                          *EQ 'Y') *AND (&IGNTG6 *EQ 'Y')) THEN(DO)
             DLTJRNRCV  JRNRCV(&OLDESTRCV) DLTOPT(*IGNTGTRCV +
                          *IGNINQMSG)
             MONMSG     MSGID(CPF0000)
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
             DLTJRNRCV  JRNRCV(&OLDESTRCV) DLTOPT(*IGNINQMSG)
/*                                                                                                */
             MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                                                */
/* If Feature CSC018 is 'on' (journal options for high availability),                             */
/*                                                                                                */
             IF         COND(&CSC018 *EQ '       ') THEN(DO)
/*                                                                                                */
/* If remote journaling is being used,                                                            */
/*                                                                                                */
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to delete the next receiver.                                          */
/*                                                                                                */
             CHGVAR     VAR(&RMTCM6) VALUE(' ')
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBRMT *TCAT '/' *CAT &OLDESTRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')
/*                                                                                                */
/* Execute the remote command to delete the next receiver in the remote                           */
/* journaling library on the other machine.                                                       */
/*                                                                                                */
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
             ENDDO
/*                                                                                                */
/* If backup journal management is being used,                                                    */
/*                                                                                                */
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/*                                                                                                */
/* Calculate remote command to delete the next receiver.                                          */
/*                                                                                                */
             CHGVAR     VAR(&RMTCM6) VALUE(' ')
/*                                                                                                */
/* If remote journaling is being used and if 'Ignore                                              */
/* Target Receiver' is 'Y', then include the option *IGNTGTRCV.                                   */
/*                                                                                                */
             IF         COND((&RMTJR6 *EQ 'Y') *AND (&IGNTG6 *EQ +
                          'Y')) THEN(DO)
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &OLDESTRCV *TCAT +
                          ' DLTOPT(*IGNINQMSG *IGNTGTRCV)')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                &JLIBBKP *TCAT '/' *CAT &OLDESTRCV *TCAT ' +
                          DLTOPT(*IGNINQMSG)')
             ENDDO
/*                                                                                                */
/* Execute the remote command to delete receiver in the                                           */
/* journaling library on the backup machine.                                                      */
/*                                                                                                */
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
             ENDDO
/*                                                                                                */
/*  Loop to get the next oldest receiver.                                                         */
/*                                                                                                */
             GOTO       CMDLBL(LOOPER)
 
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
/*/COPY WNCPYSRC,SCC2473008                                                                       */
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2473 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*/COPY WNCPYSRC,SCC2473009                                                                       */
ENDER:
                                                                                         /*BUG5832*/
/* Remove DMPCLPGM keyword */                                                            /*BUG5832*/
                                                                                         /*BUG5832*/
/**********  DMPCLPGM */                                                                 /*BUG5832*/
             RETURN
             ENDPGM
