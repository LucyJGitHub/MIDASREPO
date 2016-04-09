/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Alter message queue status')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*          SCC2451 - ALTER MESSAGE QUEUE STATUS                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 260261             Date 15May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01375             Date 03Apr92              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       260261 - Program fills MOPERQ with 8 messages every log in  */
/*                when user is not authorised to MSGQ.               */
/*                Monitor error when user is not authorised to MSGQ. */
/*       S01375  - Auto COB amendments                              */
/*                                                                  */
/********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHASE_CHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEV_MODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
/**/
/* MIPGM_not_in_stack */
/**/
             DCL        VAR(&MIPGM_NIS) TYPE(*CHAR) LEN(1)
/**/
/* EODRST_not_in_stack */
/**/
             DCL        VAR(&EODRST_NIS) TYPE(*CHAR) LEN(1)
/**/
/* CBRUN_not_in_stack */
/**/
             DCL        VAR(&CBRUN_NIS) TYPE(*CHAR) LEN(1)
             MONMSG     MSGID(CPF2451)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**/
/**********  IF         COND((&MPHAS *EQ 'D') *OR (&MPHAS *EQ 'C') +                      /*CCB020*/
/**********             *OR (&MPHAS *EQ 'F')) +                                           /*CCB020*/
/**********             THEN(DO)                                                          /*CCB020*/
             IF         COND(&MPHAS *EQ 'C')  THEN(DO)                                    /*CCB020*/
                             CHGVAR VAR(&PHASE_CHK) VALUE('Y')
                        ENDDO
             ELSE       CMD(DO)
                             CHGVAR VAR(&PHASE_CHK) VALUE('N')
                        ENDDO
/**/
             RTVJOBA JOB(&JOB) USER(&USRID)
/**/
/* Obtain the auto COB information via CB0602X */
/* If not a EOD phase then use blanks to obtain current information */
/**/
             IF         COND(&PHASE_CHK *EQ 'Y') THEN(DO)
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('          ')
             ENDDO
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/* Deallocate Users message queue */
/**/
             DLCOBJ     OBJ((QUSRSYS/&USRID *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000)
/**/
/* Determine if MIPGM is in the program stack */
/**/
             CHGVAR     VAR(&MIPGM_NIS) VALUE('N')
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('SCC2451 +
                          - Alter message queue status') TOPGMQ(*SAME +
                          MIPGM)
             MONMSG     MSGID(CPF2469) EXEC(CHGVAR VAR(&MIPGM_NIS) +
                          VALUE('Y'))
/**/
/* Determine if EODRST is in the program stack */
/**/
             CHGVAR     VAR(&EODRST_NIS) VALUE('N')
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('SCC2451 +
                          - Alter message queue status') TOPGMQ(*SAME +
                          EODRST)
             MONMSG     MSGID(CPF2469) EXEC(CHGVAR VAR(&EODRST_NIS) +
                          VALUE('Y'))
/**/
/* Determine if CBRUN is in the program stack */
/**/
             CHGVAR     VAR(&CBRUN_NIS) VALUE('N')
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('SCC2451 +
                          - Alter message queue status') TOPGMQ(*SAME +
                          CBRUN)
             MONMSG     MSGID(CPF2469) EXEC(CHGVAR VAR(&CBRUN_NIS) +
                          VALUE('Y'))
/**/
/* Set message queues' delivery mode for the case:     */
/* Auto COB off and phase is 'D' or 'C' or 'F'         */
/**/
             IF         COND((%SST(&CB_AUTO 66 4) *EQ '*NO ') *AND +
                             (&PHASE_CHK *EQ 'Y')) +
                        THEN(DO)
/**/
                 IF         COND(&CBRUN_NIS *EQ 'N') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*NOTIFY)
                      GOTO       CMDLBL(ENDCLPGM)
                 ENDDO
/**/
                 IF         COND(&EODRST_NIS *EQ 'N') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*BREAK)
                      CHGMSGQ    MSGQ(MOPERQ) DLVRY(*BREAK)
                      GOTO       CMDLBL(ENDCLPGM)
                 ENDDO
/**/
                 IF         COND(&MIPGM_NIS *EQ 'Y') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*BREAK)
                      GOTO       CMDLBL(ENDCLPGM)
                 ENDDO
             ENDDO
/**/
/* Set message queues' delivery mode for the case:     */
/* Auto COB on  and phase is 'D' or 'C' or 'F'         */
/**/
             IF         COND(&PHASE_CHK *EQ 'Y') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*NOTIFY)
                      CHGMSGQ    MSGQ(*USRPRF) DLVRY(*NOTIFY)
                      CHGMSGQ    MSGQ(MOPERQ) DLVRY(*NOTIFY)
                      GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Set message queues' delivery mode for the case:       */
/* Auto COB on  and phase is not 'D' and not 'C'         */
/* and not 'F'                                           */
/**/
/* Retreive input cycle message queue status via         */
/* data variable &CB_AUTO                                */
/**/
             CHGVAR     VAR(&DEV_MODE) VALUE(%SST(&CB_AUTO 41 10))
/**/
             IF         COND(&DEV_MODE *EQ '*BREAK') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*BREAK)
                      CHGMSGQ    MSGQ(*USRPRF) DLVRY(*BREAK)
             ENDDO
/**/
             IF         COND(&DEV_MODE *EQ '*HOLD') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*HOLD)
                      CHGMSGQ    MSGQ(*USRPRF) DLVRY(*HOLD)
             ENDDO
/**/
             IF         COND(&DEV_MODE *EQ '*NOTIFY') THEN(DO)
                      CHGMSGQ    MSGQ(&JOB) DLVRY(*NOTIFY)
                      MONMSG     MSGID(CPF2408)                                           /*260261*/
                      CHGMSGQ    MSGQ(*USRPRF) DLVRY(*NOTIFY)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2451 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   ENDPGM
