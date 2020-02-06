/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas¦ABS Restricted Accounts Security Control')      */
/*********************************************************************/
/*                                                                   */
/*       Midas¦ABS - SECURITY PROFILE FACILITY                       */
/*       Midas - Security Profile Facility                           */
/*                                                                   */
/*       SFC0932 - RESTRICTED ACCOUNTS SECURITY CONTROL - COB        */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097217          Date 25Mar13              */
/*                      CCB023B            Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CRE024  *CREATE    Date 07Oct05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1097217 - DBICDM in use                                   */
/*       CCB023B - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       CRE024 - COUNTRY LEVEL SWITCHABLE FEATURE :                 */
/*                SECURITY FEATURES FOR RESTRICTED ACCOUNTS          */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
             DCL  VAR(&SEQ)  TYPE(*CHAR)  LEN(5)
             DCL  VAR(&LVL)  TYPE(*CHAR)  LEN(1)
             DCL  VAR(&ENT)  TYPE(*CHAR)  LEN(3)
             DCL  VAR(&RTCD) TYPE(*CHAR)  LEN(7)
             DCL  VAR(&MODE) TYPE(*CHAR)  LEN(1)
             DCL  VAR(&MEM)  TYPE(*CHAR)  LEN(50)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                /*CCB023B*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)                                   /*CCB023B*/
             DCL        VAR(&ZONEID) TYPE(*CHAR) LEN(2)                                  /*CCB023B*/
 
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Set mode to indicate Close of Business                            */
             CHGVAR VAR(&MODE) VALUE('A')
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                                   /*CCB023B*/
             CHGVAR     VAR(&ZONEID) VALUE(%SUBSTRING(&SDSTAT 6 2))                      /*CCB023B*/
             CHGVAR     VAR(&DMLIB) VALUE(&ZONEID *CAT 'DMLIB ')                         /*CCB023B*/
                                                                                         /*CCB023B*/
             RSTOBJ     OBJ(SFRAUAPA) SAVLIB(&DMLIB) DEV(*SAVF) +
                          SAVF(DBICDM) RSTLIB(QTEMP)                                     /*CCB023B*/
/**********  MONMSG     MSGID(CPF0000)                               */        /*CCB023B AR1097217*/
             MONMSG     MSGID(CPF3812) EXEC(DO)                                        /*AR1097217*/
WAIT:          ALCOBJ     OBJ((DBICDM *FILE *EXCL)) WAIT(3)                            /*AR1097217*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO WAIT)                               /*AR1097217*/
               RSTOBJ     OBJ(SFRAUAPA) SAVLIB(&DMLIB) DEV(*SAVF) +
                            SAVF(DBICDM) RSTLIB(QTEMP)                                 /*AR1097217*/
               DLCOBJ     OBJ((DBICDM *FILE *EXCL))                                    /*AR1097217*/
             ENDDO                                                                     /*AR1097217*/
             OVRDBF     FILE(SFRAUAPA) TOFILE(QTEMP/SFRAUAPA) +
                          OVRSCOPE(*JOB)                                                 /*CCB023B*/
                                                                                         /*CCB023B*/
             CALL PGM(SF0932) PARM(&RTCD  &MODE  &SEQ  &LVL  &ENT)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MRUNQ MOPERQ)
                 CHGVAR     VAR(&MEM) VALUE('SFC0932 - JOB TERMINATED, +
                          DATABASE IN ERROR')
                 SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                 GOTO END
             ENDDO
 
/* If report run is successful, clear unauthorised access file       */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                 CLRPFM     FILE(SFRAUAPA)
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             GOTO END
 
 ABNORMAL:   SNDPGMMSG  MSG('Restricted Accounts Security Control +
                  Program SF0932 Ended ABNORMALLY') +
                  TOMSGQ(MOPERQ MRUNQ)
                  MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&MKICPY) VALUE('(c) Finastra International +
                          Limited 2005')
 ENDPGM
