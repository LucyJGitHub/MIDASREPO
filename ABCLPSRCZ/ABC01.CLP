/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AB Internal contracts input')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Internal Contracts (Dealing)                        */
/*                                                                   */
/*       ABC01 - AB Internal Contracts Input                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 28Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAP004  *CREATE    Date 02Sep98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP004 - Conversion of inputs into modular structure to     */
/*                use as APIs - Phase 3.                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
 
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
             RETURN
 
RUN:
 
/*  Reset job switches       */
 
             CHGJOB     SWS(XXXXXX00)
 
 
             OVRDBF     FILE(ABCOMPLL) SHARE(*NO)
 
/*  CALL INTERNAL CONTRACTS INPUT OR REPAIR*/
 
             CALL       PGM(&PROG)
 
             DLTOVR     FILE(ABCOMPLL)
 
/** +
    Destroy the activation group used by the program, and ensure +
    that no files were left open in OPM programs called from it. +
    First retrieve the name of the activation group that the +
    program runs in. +
**/
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
/**  For Database Errors recover Data from LDA   */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN  */
                RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                MONMSG     MSGID(CPF0000 MCH0000)
                CALL       PGM(SCC0010) PARM('SEC021 ' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
                GOTO END
             ENDDO
 
 
 /* PRODUCE CONFIRMATIONS */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
               IF     COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                       (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
                      RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                 IF     COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
 
                    ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                    CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                    DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                    SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/*/COPY WNCPYSRC,ABC01001                                            */
/************       SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                   /*CSC023*/
/************                    RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +                  /*CSC023*/
/************                    INLLIBL(*JOBD) MSGQ(MOPERQ)                              /*CSC023*/
                    SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                 RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +
                                 INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                  /*CSC023*/
 
/************       SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                   /*CSC023*/
/************                    RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                  /*CSC023*/
/************                    INLLIBL(*JOBD) MSGQ(MOPERQ)                              /*CSC023*/
                    SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                 RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                 INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                  /*CSC023*/
/*/COPY WNCPYSRC,ABC01002                                            */
                 ENDDO
               ENDDO
               ELSE   DO
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/*/COPY WNCPYSRC,ABC01003                                            */
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
 
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/*/COPY WNCPYSRC,ABC01004                                            */
                ENDDO
               ENDDO
             ENDDO
 
END:         RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
