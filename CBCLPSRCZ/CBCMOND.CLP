/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Display COB monitor')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBCMOND - MONITOR DISPLAY                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1096378          Date 20Mar13              */
/*       Prev Amend No. CCB020             DATE 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 10JUN96              */
/*                      095122             DATE 26OCT95              */
/*                      091688             Date 10AUG95              */
/*                      S01408             Date 07AUG95              */
/*                      S01420 *CREATE     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1096378 - NWDC issues encountered during link testing.    */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       S01408 - Core hook CBCMOND002 added.                        */
/*                Core hook CBCMOND001 added.                        */
/*       095122 - In some circumstances the attention key stops      */
/*                working.  There is no good reason for this.  Fix   */
/*                is to remove the "SETATNPGM (*OFF)" line.          */
/*       091688 - COBSCHED should run at priority 20.                */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBCMONDINT                                       */
/*                - CBCMONDMPS                                       */
/*                - CBCMONDMPE                                       */
/*                - CBCMONDERR                                       */
/*                - CBCMONDEND                                       */
/*       S01420 - CoB Enhancements (Batch Monitor)                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBCMONDINT                                          */
 
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('S01420')
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BEGIN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10) +
                          VALUE('*ALL      ')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&UNLOCK) TYPE(*CHAR) LEN(7) VALUE('UNLOCK')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CBLOCK) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LOCK) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LOCKUSER) TYPE(*CHAR) LEN(26)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
             OVRMSGF    MSGF(CBUSRMSG) TOMSGF(GBCBUSRMSG)
 
 
/*/COPY WNCPYSRC,CBCMONDMPS                                          */
 
/**********  CHGJOB     RUNPTY(35)                                    /*091688*/
             CHGJOB     RUNPTY(20)                                    /*091688*/
             MONMSG     MSGID(CPF0000)
 
/* Retrieve DTAARA/MPHAS */
 
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
             IF         COND(&MPHAS *EQ 'A') THEN(GOTO CMDLBL(DAYBEG))
 
/* Determine if SAR installed */
 
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
 
/* Error */
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             RTVMSG     MSGID(SCM0100) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
 
/* Check if monitor locked */
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             ALCOBJ     OBJ((CBLOCK *DTAARA *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                CHGVAR     VAR(&LOCK) VALUE('*ACTIVE')
                GOTO       CMDLBL(LOCK)
             ENDDO
 
             CALL QUSRTVUS ('USERLOCK  *LIBL     ' X'00000001' +
             X'00000026' &LOCKUSER)
             MONMSG     MSGID(CPF0000)
 
             IF         COND((%SST(&LOCKUSER 17 10) *NE ' ') *AND +
                          (%SST(&LOCKUSER 17 10) *NE &USER)) THEN(DO)
                CHGVAR     VAR(&LOCK) VALUE('*ACTIVE')
             ENDDO
 
             DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
 
 LOCK:       IF         COND(&LOCK *EQ '*ACTIVE') THEN(DO)
                RTVMSG     MSGID(SCM0103) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0104) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('CBCMOND' 'ENTER' +
                             &NOREPLY)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&MODE) VALUE('CREATE')
 
/* Create data queue for the job */
 
             CALL       PGM(CBC0515) PARM(&USER &JOB &NBR &DTAQ &MODE &ERROR)
 
             IF         COND(&ERROR *NE ' ') THEN(GOTO CMDLBL(ABNOR))
 
             IF         COND(&MPHAS *NE 'N') THEN(DO)                                  /*AR1096378*/
             SETATNPGM  PGM(CBC0015A)
             ENDDO                                                                     /*AR1096378*/
             ELSE       DO                                                             /*AR1096378*/
             SETATNPGM  PGM(CB000003)                                                  /*AR1096378*/
             ENDDO                                                                     /*AR1096378*/
 
/* Call monitor display */
 DISPLAY:
             OVRDBF     FILE(CBUSERL2) TOFILE(CBUSERL2) SHARE(*YES)
 
             CALL       PGM(CBMOND) PARM(&DTAQ &RTRN)
 
             DLTOVR     FILE(*ALL)
 
/************SETATNPGM  PGM(CBC0015A) SET(*OFF)               *095122*/
 
/* Remove user */
 
             CHGVAR     VAR(&MODE) VALUE('DELETE')
 
             CALL       PGM(CBC0515) PARM(&USER &JOB &NBR &DTAQ +
                          &MODE &ERROR)
 
             IF         COND(%SST(&RTRN 1 3) *NE 'END') THEN(GOTO +
                          CMDLBL(ENDP))
 
/* If COB is finished, go through input cycle */
 
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(SIGNOFF (*NOLIST))                   */ /*CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND (&MPHAS *NE 'G')) +
                          THEN(SIGNOFF (*NOLIST))                                         /*CCB020*/
 
             RTVDTAARA  DTAARA(SDSTAT (110 5)) RTNVAR(&BEGIN)
 
             IF         COND(&BEGIN *NE 'BEGIN') THEN(SIGNOFF +
                          LOG(*NOLIST))
 
/*/COPY WNCPYSRC,CBCMONDMPE                                          */
 
 DAYBEG:     RRTJOB     RTGDTA('MIDASIC')
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBCMONDERR                                          */
 
             CHGVAR     VAR(&MODE) VALUE('DELETE')
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(CBC0515) PARM(&USER &JOB &NBR &DTAQ +
                          &MODE &ERROR)
             MONMSG     MSGID(CPF0000)
 
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBCMOND001                                           /*S01408*/
/*                                                                    /*S01408*/
             SNDPGMMSG  MSG('Close of Business display ended +
                          abnormally') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBCMOND002                                           /*S01408*/
/*                                                                    /*S01408*/
             MONMSG     MSGID(CPF0000)
 
             SIGNOFF    LOG(*LIST)
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBCMONDEND                                          */
 
             DLTDTAQ    DTAQ(&DTAQ)
             MONMSG     MSGID(CPF0000)
 
             DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
 
             SIGNOFF    LOG(*NOLIST)
 
             ENDPGM
