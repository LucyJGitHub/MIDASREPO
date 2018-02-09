/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Delete elegible global journal receivers')   */
/*********************************************************************/
/*                                                                   */
/*          MIDAS SYSTEM CONTROL MODULE                              */
/*                                                                   */
/*          SCC2478 - DELETE ELIGIBLE GLOBAL JOURNAL RECEIVERS       */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260481             Date 28May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020 *CREATE     Date 31Mar04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       260481 - Proceed to do Deletion of journal receiver         */
/*                when Ignore Target Receiver = 'Y'.                 */
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
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&GPGXLIB) TYPE(*CHAR) LEN(10)  */                             /*CSC043*/
             DCL        VAR(&GPGJLIB) TYPE(*CHAR) LEN(10)                                 /*CSC043*/
             DCL        VAR(&RCVRTNA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RCVRTN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CURCMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVNUMA) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RCVNUM) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&JRRETAIN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDESTRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVSAVDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)
/*/COPY GPCPYSRCG,GPSVALDCL                                                                       */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/*                                                                                                */
/* Copyright statement definition at runtime                                                      */
/*                                                                                                */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra +
                          International Limited')
/*                                                                                                */
/*  Determine the 2-character system I.D.                                                         */
/*                                                                                                */
/**********  RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGXLIB)  */                     /*CSC043*/
/**********  CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGXLIB 1 2))      */                     /*CSC043*/
             RTVOBJD    OBJ(GPJRN) OBJTYPE(*JRN) RTNLIB(&GPGJLIB)                         /*CSC043*/
             CHGVAR     VAR(&SYSID) VALUE(%SST(&GPGJLIB 1 2))                             /*CSC043*/
/*                                                                                                */
/*  Determine the name of the current component.                                                  */
/*                                                                                                */
             RTVJOBA    JOB(&CURCMP)
/*                                                                                                */
/*  Get the journaling and high availability system values                                        */
/*                                                                                                */
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'GlobalJrnRcvRetainNo' &SVAL1 +
                          'GlobalRmtJrnActive' &SVAL2 +
                          'GlobalIgnTgtOnDel' &SVAL3 +
                          'GlobalMangBackUpJrn' &SVAL4 +
                          'GlobalDdmFileName' &SVAL5 +
                          'GlobalDdmFileLib' &SVAL6 &SVALK7 &SVAL7 +
                          &SVALK8 &SVAL8 &SVALK9 &SVAL9 &SVALK10 +
                          &SVAL10)
/*                                                                                                */
/* If there is an error finding any system value, then end abnormally                             */
/*                                                                                                */
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/*                                                                                                */
/*  Determine whether remote journaling is being used                                             */
/*                                                                                                */
             CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL2 1 1))
/*                                                                                                */
/*  If remote journaling is used, determine whether to ignore                                     */
/*  target receivers upon deletion.                                                               */
/*                                                                                                */
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)
              CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL3 1 1))
/*                                                                                                */
/*  Calculate the backup machine remote journal library.                                          */
/*                                                                                                */
/**********   CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'GXLIBRMT')  */                  /*CSC043*/
              CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'GJLIBRMT')                      /*CSC043*/
             ENDDO
/*                                                                                                */
/*  Determine whether backup journal management is being used                                     */
/*                                                                                                */
             CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL4 1 1))
/*                                                                                                */
/*  If backup journal management is being used, calculate the                                     */
/*  name of the backup journal library.                                                           */
/*                                                                                                */
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)
/**********   CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'GXLIB   ')  */                  /*CSC043*/
              CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'GJLIB   ')                      /*CSC043*/
             ENDDO
/*                                                                                                */
/*  If remote journaling OR backup journal management are being used,                             */
/*  determine DDM file and library.                                                               */
/*                                                                                                */
             IF         COND((&RMTJR6 *EQ 'Y') *OR (&MNGBJ6 *EQ +
                          'Y')) THEN(DO)
              CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL5 1 10))
              CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL6 1 10))
/*                                                                                                */
/*  If any of these fields are blank, then remote journaling and                                  */
/*  backup receiver management may not be used.                                                   */
/*                                                                                                */
              IF         COND((&DDMRM6 *EQ '          ') *OR (&DDMLI6 +
                          *EQ '          ')) THEN(DO)
               CHGVAR     VAR(&RMTJR6) VALUE('N')
               CHGVAR     VAR(&MNGBJ6) VALUE('N')
              ENDDO
             ENDDO
/*                                                                                                */
/*  Determine number of detached journal receivers to retain.                                     */
/*                                                                                                */
             CHGVAR     VAR(&RCVRTNA) VALUE(%SST(&SVAL1 1 3))
             CHGVAR     VAR(&RCVRTN) VALUE(&RCVRTNA)
/*                                                                                                */
/*  Determine  oldest receiver to retain.                                                         */
/*                                                                                                */
/*  First determine the currently attached receiver.                                              */
/*                                                                                                */
             RTVJRNE    JRN(GPJRN) FROMENT(*LAST) RTNRCV(&CURRCV)
/*                                                                                                */
/*  Calculate the name of the oldest receiver to retain.                                          */
/*                                                                                                */
             CHGVAR     VAR(&RCVNUMA) VALUE(%SST(&CURRCV 3 8))
             CHGVAR     VAR(&RCVNUM) VALUE(&RCVNUMA)
             IF         COND(&RCVNUM *LE &RCVRTN) THEN(GOTO +
                          CMDLBL(ENDER))
             CHGVAR     VAR(&RCVNUM) VALUE(&RCVNUM - &RCVRTN)
             CHGVAR     VAR(&RCVNUMA) VALUE(&RCVNUM)
             CHGVAR     VAR(&JRRETAIN) VALUE('GR' *CAT &RCVNUMA)
/*                                                                                                */
/*  Verify that the journal receiver exists.  If it does not, exit program.                       */
/*                                                                                                */
             CHKOBJ     OBJ(&JRRETAIN) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) CMPDTA(*NONE) EXEC(DO)
             GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  Verify that the journal receiver is part of the current chain of receivers for 'GPJRN'.       */
/*  If if is not, then exit program.                                                              */
/*                                                                                                */
             RTVJRNE    JRN(GPJRN) RCVRNG(&JRRETAIN) TOENT(*FIRST)
             MONMSG     MSGID(CPF7053) CMPDTA(*NONE) EXEC(DO)
             GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  Delete any journal receivers that are 'older' than the last receiver to be retained.          */
/*                                                                                                */
LOOPER:
/*                                                                                                */
/*  Determine the 'oldest' journal receiver in the 'GPJRN' receiver chain.                        */
/*                                                                                                */
             RTVJRNE    JRN(GPJRN) RCVRNG(*CURCHAIN) RTNRCV(&OLDESTRCV)
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
              GOTO       CMDLBL(ENDER)
             ENDDO
/*                                                                                                */
/*  If it is not the receiver to be retained,                                                     */
/*                                                                                                */
             ELSE       CMD(DO)
/*                                                                                                */
/*  delete the receiver.                                                                          */
/*                                                                                                */
/* If remote journaling is being used and if 'Ignore                                              */
/* Target Receiver' is 'Y', then delete receiver with option *IGNTGTRCV                           */
/*                                                                                                */
/**********   IF         COND((&RMTJR6 *EQ 'Y') *AND (&IGNTG6 *EQ +
                          'Y')) THEN(DO) */                                               /*260481*/
              IF         COND(&IGNTG6 *EQ 'Y') THEN(DO)                                   /*260481*/
               DLTJRNRCV  JRNRCV(&OLDESTRCV) DLTOPT(*IGNTGTRCV +
                          *IGNINQMSG)
               MONMSG     MSGID(CPF0000)
/*                                                                                                */
              ENDDO
/*                                                                                                */
              ELSE       CMD(DO)
/*                                                                                                */
               DLTJRNRCV  JRNRCV(&OLDESTRCV) DLTOPT(*IGNINQMSG)
               MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDER))
/*                                                                                                */
              ENDDO
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
/*  Loop to get the next oldest receiver.                                                         */
/*                                                                                                */
             GOTO       CMDLBL(LOOPER)
 
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
/*/COPY WNCPYSRC,SCC2478008                                                                       */
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2478 ended abnormally') +
                          TOMSGQ(GPOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*/COPY WNCPYSRC,SCC2478009                                                                       */
ENDER:
             RETURN
             ENDPGM
