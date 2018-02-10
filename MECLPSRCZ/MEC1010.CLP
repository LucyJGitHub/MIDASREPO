/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Control Batch Jobs')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1010  - Control batch jobs                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 097252             Date 02Jan97              */
/*                      089180             Date 19Oct95              */
/*                      S01435             DATE 19AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      097252 - COMPLETE 089180 FOR RESTRICTED MODE                 */
/*      089180 - Allocation problem on MSPECIAL.                     */
/*               If origin of this run is linked to the submission   */
/*               of the MSC5030 and if it fails due to allocation,   */
/*               --> MSC5030 not submitted                           */
/*                   MSSTAT pos. 57 never reset to 'N'               */
/*               Retreive the job name in order to know which        */
/*               was the program that initiate this run.             */
/*               If it is MSC5030 --> reset MSSTAT position 57 to 'N'*/
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FT_PROC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SPECMSG) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBNM) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')                       /* 089180 */
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1010 - ME Batch Control') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* Set up default MEMSG file override */
/* */
             OVRMSGF    MSGF(MEMSG) TOMSGF(GBMEMSG)
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
/* */
/* Allocate TSTATUS to show job is active  */
/* */
             ALCOBJ     OBJ((TSTATUS *DTAARA *SHRUPD)) WAIT(60)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('Job cannot start allocation of TSTATUS +
                          failed') TOMSGQ(MOPERQ MRUNQ)
 /* 089180*/
 /* Check initiating program.                                          089180 */
 /* If MSC5030 --> reset MSSTAT pos. 57 to 'N'                         089180 */
 /* 089180 */
             RTVJOBA    JOB(&JOBNM)                                 /* 089180 */
             IF         COND(&JOBNM *EQ 'MSC5030   ') THEN(DO) /* +
                          089180 */
             CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')            /* 089180 */
             SNDPGMMSG  MSG('Allocation problem on TSTATUS, incoming +
                          message index generation won''t be +
                          submitted now.') TOMSGQ(MOPERQ MRUNQ +
                          QSYSOPR)                                  /* 089180 */
             ENDDO                                                  /* 089180 */
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Check MSPECIAL is blank - i.e. input cycle */
/* if not or cannot allocate end processing */
/* */
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF2451 CPF2477) EXEC(DO)
             SNDPGMMSG  MSGID(MIN0228) MSGF(MEMSG) TOMSGQ(MOPERQ MRUNQ)
 /* 089180*/
 /* Check initiating program                                           089180 */
 /* If MSC5030 --> reset MSSTAT pos. 57 to 'N'                         089180 */
 /* 089180 */
             RTVJOBA    JOB(&JOBNM)                                 /* 089180 */
             IF         COND(&JOBNM *EQ 'MSC5030   ') THEN(DO) /* +
                          089180 */
             CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')            /* 089180 */
             SNDPGMMSG  MSG('Allocation problem on MSPECIAL, +
                          incoming message index generation won''t +
                          be submitted now.') TOMSGQ(MOPERQ MRUNQ +
                          QSYSOPR)                                  /* 089180 */
             ENDDO                                                  /* 089180 */
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
             RCVMSG     MSGQ(MSPECIAL) RMV(*NO) MSG(&SPECMSG)
             IF         COND(&SPECMSG *NE '      ') THEN(DO)
             SNDPGMMSG  MSGID(MIN0229) MSGF(MEMSG) TOMSGQ(MOPERQ MRUNQ)
 /* Check initiating program                                            097252*/
 /* If MSC5030 --> reset MSSTAT pos. 57 to 'N'                          097252*/
             RTVJOBA    JOB(&JOBNM)                                   /*097252*/
             IF         COND(&JOBNM *EQ 'MSC5030   ') THEN(DO)        /*097252*/
             CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')              /*097252*/
             SNDPGMMSG  MSG('Midas is restricted state, incoming +
                          message index generation won''t be +
                          submitted now.') TOMSGQ(MOPERQ MRUNQ +
                          QSYSOPR)                                    /*097252*/
             ENDDO                                                    /*097252*/
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Run MLC0020 - Set up overrides  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             CALL       PGM(MLC0020)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
 /* Check initiating program                                            097252*/
 /* If MSC5030 --> reset MSSTAT pos. 57 to 'N'                          097252*/
             RTVJOBA    JOB(&JOBNM)                                   /*097252*/
             IF         COND(&JOBNM *EQ 'MSC5030   ') THEN(DO)        /*097252*/
             CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')              /*097252*/
             SNDPGMMSG  MSG('Program MEC1010 ended abnormally, +
                          incoming message index generation won''t +
                          be submitted now.') TOMSGQ(MOPERQ MRUNQ +
                          QSYSOPR)                                    /*097252*/
             ENDDO                                                    /*097252*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1010 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1010 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
