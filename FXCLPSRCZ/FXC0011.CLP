/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas   - FX Module                                         */
/*                                                                   */
/*       FXC0011 - FX MENU OPTION CONTROL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL038             Date 10May05              */
/*       Prev Amend No. CRE020             Date 20Jan04              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      208051             Date 07Nov02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      195484             Date 13Dec01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180276             Date 20Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP002  *CREATE    Date 02Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDL038 - Extended Deal Sub Type                             */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       208051 - Confirmations and pay receives not generated       */
/*                from all options using this input.                 */
/*       195484 - Unable to generate confirmation messages from      */
/*                range authorisation.                               */
/*       180276 - Extend 103997 to this program.                     */
/*                Change of DLSTAT position 6 ='Y' is now done       */
/*                at the start of DLC0210A to prevent non-submission */
/*                of pay/receive job.                                */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
/*/COPY WNCPYSRC,FXC0011006                                          */
 
             DCLF       FILE(SDMGMEPD)
 
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
/*********** RCLRSC  *********************/                                               /*CDL038*/
             RETURN
 
RUN:
/*/COPY WNCPYSRC,FXC0011007                                          */
 
/* RESET THE JOB SWITHCHES */
             CHGJOB     SWS(XXXXXX00)
 
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE020*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&PRTCD *EQ '       ') THEN(DO)                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&PRTCD *NE '*NRF   ' *AND +
                     &PRTCD *NE '       ') THEN(DO)                                       /*CRE020*/
             DMPCLPGM                                                                     /*CRE020*/
             GOTO       CMDLBL(ERR)                                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/*/COPY WNCPYSRC,FXC0011001                                          */
/* CALL PROGRAM  */
 
             CALL       PGM(&PROG)
 
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
 
/*********** RCLRSC  *********************/                                               /*CDL038*/
 
 /* IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN */
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
                CALL       PGM(SCC0010) PARM('FXC0011' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
 /* PROCESSING FOR CONFIRMATIONS */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
       IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
 /* DO CONFIRMATIONS IF BACK OFFICE DEAL INPUT DONE */
 
 /********IF         COND((&PROG *EQ 'FXFXDLSIN ') *OR +                                  /*195484*/
 /*********               (&PROG *EQ 'FXIFXDLMNT')) THEN(DO)                              /*195484*/
 /*********IF         COND((&PROG *EQ 'FXFXDLSIN ') *OR +                                 /*208051*/
 /**********               (&PROG *EQ 'FXDEALRAT ') *OR +                                 /*208051*/
 /**********               (&PROG *EQ 'FXFXDLRPR ')) THEN(DO)                  /*195484*/ /*208051*/
           IF         COND((&PROG *EQ 'FXFXDLSIN ') *OR +
                           (&PROG *EQ 'FXDEALRAT ') *OR +
                           (&PROG *EQ 'FXFXDLRPR ') *OR +
                           (&PROG *EQ 'FXPBDLRAT ')) THEN(DO)                             /*208051*/
 
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
 
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
/************      ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
/************      CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *180276*/
/************      DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/*/COPY WNCPYSRC,FXC0011002                                          */
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                 /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/*/COPY WNCPYSRC,FXC0011003                                          */
 
                   RCVF
 
                   IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
                      CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
                      'DL0308' 'B')
                   ENDDO
 
                ENDDO
             ENDDO
 
             ELSE   DO
 
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
/***********       ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
/***********       CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *180276*/
/***********       DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *180276*/
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/*/COPY WNCPYSRC,FXC0011004                                          */
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                 /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/*/COPY WNCPYSRC,FXC0011005                                          */
 
                   RCVF
 
                   IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
                      CALL  PGM(FCC0202) PARM('DLC0211' '10001' +
                      'DL0308' 'B')
                   ENDDO
 
                ENDDO
             ENDDO
          ENDDO
       ENDDO
/*/COPY WNCPYSRC,FXC0011008                                          */
 
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('          ')                                    /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND((&PROG *EQ 'FXFXDLSIN') *OR +
                             (&PROG *EQ 'FXFXDLRPR') *OR +
                             (&PROG *EQ 'FXDEALRAT') *OR +
                             (&PROG *EQ 'FXPBDLRAT')) THEN(DO)                            /*CRE020*/
             CHGVAR     VAR(&PMOD) VALUE('FXFXDLUPD')                                     /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PMOD *NE '          ') THEN(DO)                             /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(''' +
                        *CAT &PMOD *CAT ''' ''DL'')')                                     /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/*********** RCLRSC  *********************/                                               /*CDL038*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
