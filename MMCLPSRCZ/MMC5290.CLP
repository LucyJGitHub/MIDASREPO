/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Penalty Termination Maintenance')            */
/*********************************************************************/
/*                                                                   */
/*       MIDAS DBA - Dealing Money Market Module                     */
/*                                                                   */
/*       MMC5290 - Penalty Termination Maintenance                   */
/*                                                                   */
/*       (C) Copyright Finastra International Limited 2008           */
/*                                                                   */
/*       Last Amend No. MD054161           Date 23Sep19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      256795  *CREATE    Date 25Sep08              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054161 - DL: Penalty termination of time deposit results  */
/*                  in Database error                                */
/*       MD046248 - Finastra Rebranding                              */
/*       256795 - Penalty Termination of Time Deposits (CDL052).     */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&MODE)
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                        Copyright Finastra International Limited 2008')

             DCL        VAR(&MODE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ABNOR)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('CDL052')
             DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)

             DCLF       FILE(SDMGMEPD)

/** Global monitor message **/

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(XXXXXX00)

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSDY)
             IF         COND(&RTCD *NE '       ') +
                           THEN(GOTO CMDLBL(END))

             CALL       PGM(MM5290) PARM(&MODE)

/** Database error processing **/

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO

 /** Processing for Deal Confirmations **/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)

             IF         COND(&MODE *NE 'E') THEN(DO)
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)

 /** Check that confirmation process is not running already **/
                IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                              RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                              INLLIBL(*JOBD) MSGQ(MOPERQ)
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                              RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                              INLLIBL(*JOBD) MSGQ(MOPERQ)

                   RCVF
                   IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
                      CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
                            'DL0308' 'B')
                   ENDDO

                ENDDO
             ENDDO
             ENDDO
             ENDDO
             GOTO       CMDLBL(END)

 ABNOR:      CHGJOB     SWS(XXXXXX11)

             IF         COND(&ABNOR *EQ 'Y') THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&ABNOR) VALUE('Y')

             SNDPGMMSG  MSG('Penalty Termination Maintenance ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

             RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (261 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0088) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (361 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('MMC5290' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

 /**********END:        RCLRSC  */                                                      /*MD054161*/
 END:        RCLACTGRP  ACTGRP(*ELIGIBLE)                                               /*MD054161*/
     CHGVAR &MKICPY '(c) Copyright Finastra International Limited 2008'

 ENDPGM

