/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ZA Concatenate Variables to Message')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       ZA1310  -  SUB-PROGRAM TO FORMAT MESSAGE                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Last Amend No. 177440             Date 06Jan03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413 *CREATE     Date 13Apr93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE083 - COB Restructure - RE COB Optimisation Phase 1      */
/*       177440 - Add ABNOR processing                               */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &MSGDTA0 &MSGDTA1 &MSGDTA2 +
                          &MSGDTA3 &MSGDTA4 &MSGDTA5 &MSGDTA6 +
                          &MSGDTA7 &MSGDTA8 &MSGDTA9 &RESULT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   DECLARE INPUT VARIABLES                                         */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA0) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA1) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA2) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA3) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA4) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA5) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA6) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA7) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA8) TYPE(*CHAR) LEN(40)
             DCL        VAR(&MSGDTA9) TYPE(*CHAR) LEN(40)
             DCL        VAR(&RESULT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&WRKDTA) TYPE(*CHAR) LEN(400)
/**********  DCL        VAR(&CPT) TYPE(*DEC) LEN(2 0) VALUE(0)                         */ /*CRE083*/
/**********  DCL        VAR(&CPT1) TYPE(*DEC) LEN(2 0) VALUE(0)                        */ /*CRE083*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*177440*/
/**/
/*  CONCATENATE ALL INPUT VARIABLES INTO ONE VARIABLE TO SEND AS MESSAGE DATA */
             CHGVAR     VAR(&WRKDTA) VALUE(&MSGDTA0 *CAT &MSGDTA1 +
                          *CAT &MSGDTA2 *CAT &MSGDTA3 *CAT &MSGDTA4 +
                          *CAT &MSGDTA5 *CAT &MSGDTA6 *CAT &MSGDTA7 +
                          *CAT &MSGDTA8 *CAT &MSGDTA9)
/**/
/*  SEND MESSAGE TO PROGRAM MESSAGE QUEUE FOR FORMATTING             */
TAG03:
             SNDPGMMSG  MSGID(&MSGID) MSGF(QUSERMSG) MSGDTA(&WRKDTA) +
                          TOPGMQ(*SAME) TOMSGQ(*TOPGMQ)
             MONMSG     MSGID(CPF2477) EXEC(DO)
             DLYJOB     DLY(5)                                                            /*CRE083*/
             GOTO CMDLBL(TAG03)                                                           /*CRE083*/
             ENDDO                                                                        /*CRE083*/
/**/
/**********  IF         COND(&CPT1 *EQ 10) THEN(DO)                                    */ /*CRE083*/
/**********  SNDPGMMSG  MSGID(&MSGID) MSGF(QUSERMSG) MSGDTA(&WRKDTA) +                 */ /*CRE083*/
/**********               TOPGMQ(*SAME) TOMSGQ(*TOPGMQ)                                */ /*CRE083*/
/**********  GOTO       CMDLBL(TAG04)                                                  */ /*CRE083*/
/**********  ENDDO                                                                     */ /*CRE083*/
/**/
/**********  CHGVAR     VAR(&CPT1) VALUE(&CPT1 + 1)                                    */ /*CRE083*/
/**********  DLYJOB     DLY(1)                                                         */ /*CRE083*/
/**********  GOTO       CMDLBL(TAG03)                                                  */ /*CRE083*/
/**********  ENDDO                                                                     */ /*CRE083*/
TAG04:
/**/
/*  RECEIVE FORMATTED MESSAGE                                        */
TAG01:
             RCVMSG     MSG(&RESULT)
/**/
             MONMSG     MSGID(CPF2477) EXEC(DO)
             DLYJOB     DLY(5)                                                            /*CRE083*/
             GOTO       CMDLBL(TAG01)                                                     /*CRE083*/
             ENDDO                                                                        /*CRE083*/
/**/
/**********  IF         COND(&CPT *EQ 10) THEN(DO)                                     */ /*CRE083*/
/**********  RCVMSG     MSG(&RESULT)                                                   */ /*CRE083*/
/**********  GOTO       CMDLBL(END)                                             */ /*177440 CRE083*/
/************GOTO       CMDLBL(TAG02)                                           */ /*177440 CRE083*/
/**********  ENDDO                                                                     */ /*CRE083*/
/**/
/**********  CHGVAR     VAR(&CPT) VALUE(&CPT + 1)                                      */ /*CRE083*/
/**********  DLYJOB     DLY(1)                                                         */ /*CRE083*/
/**********  GOTO       CMDLBL(TAG01)                                                  */ /*CRE083*/
/**********  ENDDO                                                                     */ /*CRE083*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             GOTO       CMDLBL(END)                                   /*177440*/
 
 ABNOR:                                                               /*177440*/
                                                                      /*177440*/
             SNDPGMMSG  MSG('ZA1310 Format Message ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)               /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             DSPJOBLOG  OUTPUT(*PRINT)                                /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             DMPCLPGM                                                 /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             CHGJOB     SWS(XXXXXX11)                                 /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
 END:                                                                 /*177440*/
                                                                      /*177440*/
                                                                      /*177440*/
             ENDPGM                                                   /*177440*/
/*TAG02:*****ENDPGM                                                   /*177440*/
/**/
