/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Reset all files and activity indicat.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0501 - Reset all files and activity indicator            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD027054B          Date 07Apr16              */
/*                      CCB023             Date 06Aug12              */
/*                      AR868386           Date 27Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      241469A            Date 20Oct06              */
/*                      241469             Date 18Aug06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      099376  (100437)   Date 14APR97              */
/*                      S01408             Date 07AUG95              */
/*                      CCB001 *CREATE     DATE 08MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD027054B - Impossible to work on HATS during secondary COB */
/*                   System shows an error during open of HATS       */
/*                   screens due to a leftover EOD message on        */
/*                   MSPECIAL.                                       */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       AR868386 - System shows an error during open of web-faced   */
/*                  screens due to a leftover EOD msg on MSPECIAL.   */
/*                  Applied fix 262364 to make sure that only one    */
/*                  'EOD' msg is on MSPECIAL. (Child: AR868387)      */
/*       241469A - If RCFMONITOR is active, send termination message */
/*       241469 - Check RCFMONITOR before sending termination        */
/*                message.                                           */
/*       099376 - Must also reset the confirmation and pay/receive   */
/*                generation active flags in LESTAT.                 */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCC0501INT                                       */
/*                - SCC0501MPS                                       */
/*                - SCC0501MPE                                       */
/*                - SCC0501ERR                                       */
/*                - SCC0501END                                       */
/*       CCB001 - COB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC0501INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)          */                     /*CCB023*/
/**********  DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)          */                     /*CCB023*/
/**********  DCL        VAR(&CLSTAT) TYPE(*CHAR) LEN(256)          */                     /*CCB023*/
/**********  DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)          */                     /*CCB023*/
/**********  DCL        VAR(&CPSTAT) TYPE(*CHAR) LEN(256)          */                     /*CCB023*/
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(1)
             DCL        VAR(&SPECIAL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CONT) TYPE(*LGL) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC0501MPS                                          */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
/*    RESET ALL FILE AND ACTIVITY INDICATORS                       */
/**/
/*/COPY WNCPYSRC,SCC0501001                                          */
/**********  IF         COND((%SUBSTRING(&MMOD 2 1)) *EQ 'Y') THEN(DO)*/                  /*CCB023*/
/**********     RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)          */                     /*CCB023*/
/**********     CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 2)) VALUE('NN')*/                     /*CCB023*/
/**********     CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)           */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  IF         COND(((%SST(&MMOD 16 1)) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1)) *EQ 'Y') THEN(DO)     */                     /*CCB023*/
/**********     ALCOBJ     ((RESTAT *DTAARA *EXCLRD))              */                     /*CCB023*/
/**********     RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)          */                     /*CCB023*/
/**********     CHGVAR     VAR(%SST(&RESTAT 7 10)) +
                           VALUE('NNNNNOLDNN')                     */                     /*CCB023*/
/**********     CHGVAR     VAR(%SST(&RESTAT 22 2)) VALUE('NN')     */                     /*CCB023*/
/**********     CHGDTAARA  DTAARA(RESTAT) VALUE(&RESTAT)           */                     /*CCB023*/
/**********     DLCOBJ     ((RESTAT *DTAARA *EXCLRD))              */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  IF         COND((%SUBSTRING(&MMOD 4 1)) *EQ 'Y') THEN(DO)*/                  /*CCB023*/
/**********     RTVDTAARA  DTAARA(CLSTAT) RTNVAR(&CLSTAT)          */                     /*CCB023*/
/**********     CHGVAR     VAR(%SUBSTRING(&CLSTAT 1 1)) VALUE('N') */                     /*CCB023*/
/**********     CHGDTAARA  DTAARA(CLSTAT) VALUE(&CLSTAT)           */                     /*CCB023*/
/**********     IF         COND(%SST(&MMOD 5 1) = 'Y') THEN(CHGDTAARA +
                             DTAARA(STSTAT (1 5)) VALUE(OLDNN))    */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**********  IF        COND((%SUBSTRING(&MMOD 10 1)) *EQ 'Y') THEN(DO)*/                  /*CCB023*/
/**********    RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)           */                     /*CCB023*/
/**********    CHGVAR     VAR(%SUBSTRING(&LESTAT 6 2)) VALUE('NN') */              /*099376 CCB023*/
/**********    CHGVAR     VAR(%SUBSTRING(&LESTAT 13 5)) VALUE('NNNNN')*/                  /*CCB023*/
/**********    CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)            */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**/
/****RESET*DTAARA*FOR*CHIPS/MIDAS*ONLINE*INTERFACE******************/                     /*CCB023*/
/**/
/**********  IF         COND((%SST(&MMOD 45 1) = 'Y') *AND +
                          (%SST(&CPSTAT 11 2) = 'YY')) THEN(DO)    */                     /*CCB023*/
/**********     CHGDTAARA  DTAARA(CPSTAT (13 3)) VALUE(NNN)        */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**/
/***CHECK*FOR*CHIPS*DEALING*MSG*FILE*NOT*TRANSMITTED***/                                  /*CCB023*/
/**/
/**********  IF COND((%SST(&MMOD 41 1)) *EQ 'Y') THEN(DO)          */                     /*CCB023*/
/**********     CALL PGM(CHEOD)                                    */                     /*CCB023*/
/**********     IF COND(%SWITCH(XXXXXXX1)) THEN(GOTO ABNOR)        */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**/
/***CHECK*FOR*CHIPS*LENDING*MSG*FILE*NOT*TRANSMITTED****/                                 /*CCB023*/
/**/
/**********  IF COND((%SST(&MMOD 43 1)) *EQ 'Y') THEN(DO)          */                     /*CCB023*/
/**********     CALL       PGM(MCEOD)                              */                     /*CCB023*/
/**********     IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                             CMDLBL(ABNOR))                        */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
 
/**/
/* GL PROCESSING  */
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 41 1)) VALUE('N')
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 43 11)) +
                          VALUE('NNNNNNNNNNN')
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 57 1)) VALUE('N')
             CHGDTAARA  DTAARA(GLSTAT) VALUE(&GLSTAT)
 
/**/
/**IF*FUNDS*TRANSFER*PRESENT***/                                                          /*CCB023*/
/**/
/**********  IF         COND(%SST(&MMOD 57 1) *EQ 'Y') THEN(DO)    */                     /*CCB023*/
/**********     CHGDTAARA  DTAARA(FTSTAT  (1 4)) VALUE('OLDN')     */                     /*CCB023*/
/**********     CHGDTAARA  DTAARA(FTSTAT  (6 1)) VALUE('N')        */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
/**/
/*     SEND MESSAGE TO DTAQ TO TERMINATE REPORT DISTRIBUTION       */
/**/
 LOOP2:                                                                                   /*241469*/
/**********  ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)       */         /*241469*/ /*241469A*/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)                             /*241469A*/
/**********  ALCOBJ     OBJ((FC0100 *DTAARA *EXCL))                */                    /*241469A*/
/**********  MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LOOP2))    */         /*241469*/ /*241469A*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SENDT))                          /*241469A*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                                       /*241469*/
             GOTO       CMDLBL(LOOP3)                                                    /*241469A*/
                                                                                         /*241469A*/
 SENDT:                                                                                  /*241469A*/
             CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' &DTQDLEN +
                          'T')
 
 LOOP3:
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LOOP3))
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
 
/**********  CHGVAR     VAR(&SPECIAL) VALUE('EOD  ') */                                 /*AR868386*/
/**********  SNDMSG     TOMSGQ(MSPECIAL) MSG(&SPECIAL) */                               /*AR868386*/
/**/
/* REMOVE 'TERM' MSG FROM MSPECIAL                                 */
/**/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(*CLS)                         /*MD027054B*/
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             RCVMSG     MSGQ(MSPECIAL) MSG(&SPECIAL)
             CHGVAR     VAR(&SPECIAL) VALUE('EOD  ')                                    /*AR868386*/
             SNDMSG     TOMSGQ(MSPECIAL) MSG(&SPECIAL)                                  /*AR868386*/
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))                                    /*MD027054B*/
             CHGVAR     VAR(&CONT) VALUE('0')
             CALL       PGM(SCRUNQP) PARM(P)
 
/**/
/* Reclaim resources to unlock files                               */
/**/
             RCLRSC
 
/*/COPY WNCPYSRC,SCC0501MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC0501ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0501 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
/*/COPY WNCPYSRC,SCC0501END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
