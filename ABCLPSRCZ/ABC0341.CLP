/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AB Menu Option Control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Internal Funding Module                             */
/*                                                                   */
/*       ABC0341 - AB Menu Option Control Program                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 28Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CAP042  *CREATE    Date 08Jan01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP042 - Conversion of Internal Funding Deal inputs into    */
/*                modular structure to use as APIs.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &RTCD &ACTN &DLNO &LINK)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Return code for call to ZAGETACTGP */
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/** The activation group that the called program runs in */
 
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10)
 
             DCLF       FILE(SDMGMEPD)
 
/** Monitor for error messages not trapped in the rest of the */
/** program. If they occur reclaim resources and exit.        */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERROR))
 
/** Reset job switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Override files */
 
             OVRDBF     FILE(PRONO) SHARE(*NO)
 
/** Call Internal Funding Deals Maintenance or Repair */
 
             IF         COND(&PROG = 'ABFUNDSIN') THEN(DO)
                CALL       PGM(&PROG) PARM(&RTCD &ACTN &DLNO &LINK)
             ENDDO
 
             ELSE       CMD(DO)
                CALL       PGM(&PROG)
             ENDDO
 
/** Delete overrides. */
 
             DLTOVR     FILE(PRONO)
 
/** Destroy the activation group used by the program, and ensure */
/** that no files were left open in OPM programs called from it. */
/** First, retrieve the name of the activation group that the    */
/** program runs in.                                             */
 
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
 
                 SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.+
                            Press ENTER to Continue.') TOPGMQ(*EXT)
 
                ROLLBACK
 
                GOTO       CMDLBL(END)
 
             ENDDO
 
 /** Produce Confirmations */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* Check that confirmation process is not already running */
 
                IF     COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
 
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                  RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +                    /*CSC023*/
/************                  INLLIBL(*JOBD) MSGQ(MOPERQ)                                /*CSC023*/
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                               RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +
                               INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                    /*CSC023*/
 
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                  RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                    /*CSC023*/
/************                  INLLIBL(*JOBD) MSGQ(MOPERQ)                                /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                               RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                               INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                    /*CSC023*/
 
                     RCVF
                     IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
                     CALL  PGM(FCC0202) PARM('DLC0211' '10001' +
                     'DL0308' 'B')
                     ENDDO
 
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
ERROR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
