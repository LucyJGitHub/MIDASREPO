/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Input cycle processing')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas   - MM Module                                         */
/*                                                                   */
/*       DLC02A - Input Cycle Processing                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 247526             Date 03May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL014             Date 20Oct03              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP055             Date 13Mar02              */
/*                      195484             Date 13Dec01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP003  *CREATE    Date 02Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       247526 - Extend 240412 to repair processing.                */
/*       CGL014 - Collaterals Processing                             */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP055 - APIs for FRA/IRS Caps/Collars/Floors               */
/*       195484 - Unable to generate confirmation messages from      */
/*                range authorisation.                               */
/*       CAP003 - Conversion of inputs into modular structure to     */
/*                use as APIs - Phase 2.                             */
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
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
             DCL        VAR(&CGL014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL014*/
 
             DCLF       FILE(SDMGMEPD)
 
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
                                                                                          /*CRE020*/
/** Check if Midas Plus Online Printing of Advices (CRE020)is on.*/                       /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE020*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
               GOTO   CMDLBL(ERR)                                                         /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
                                                                                          /*CRE020*/
/** Check if Collaterals Processing (CGL014) is on **/                                    /*CGL014*/
                                                                                          /*CGL014*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CGL014*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CGL014*/
             CHGVAR     VAR(&PSARD) VALUE('CGL014')                                       /*CGL014*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CGL014*/
                                                                                          /*CGL014*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CGL014*/
               GOTO   CMDLBL(ERR)                                                         /*CGL014*/
             ENDDO                                                                        /*CGL014*/
                                                                                          /*CGL014*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL014) VALUE('Y'))                                        /*CGL014*/
                                                                                          /*CGL014*/
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
             RETURN
 
RUN:
 
/*  Reset job switches */
             CHGJOB     SWS(0XXXXX00)
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/*  Test for retail module  */
 
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) THEN(DO)
                CHGJOB     SWS(11XXXXXX)
             ENDDO
                                                                                          /*CGL014*/
/** Create data area for SIRS and CIRS if CGL014 is on **/                                /*CGL014*/
                                                                                          /*CGL014*/
             IF         COND(&CGL014 *EQ 'Y') THEN(DO)                                    /*CGL014*/
                  CRTDTAARA  DTAARA(QTEMP/DLUFBO) TYPE(*CHAR) LEN(50)                     /*CGL014*/
                  MONMSG     MSGID(CPF1023)                                               /*CGL014*/
             ENDDO                                                                        /*CGL014*/
 
/*  Call program             */
 
                                                                                          /*247526*/
/* Create copy of original file */                                                        /*247526*/
             IF         COND((&PROG = 'IRFRARPR' ) *OR +
                             (&PROG = 'IRSIRSRPR') *OR +
                             (&PROG = 'IRCIRSRPR') *OR +
                             (&PROG = 'IRCACFRPR')) THEN(DO)                              /*247526*/
             DLTF       FILE(QTEMP/DLPCSCRX)                                              /*247526*/
             MONMSG     MSGID(CPF0000 RPG0000)                                            /*247526*/
             CPYF       FROMFILE(DLPCSCPD) TOFILE(QTEMP/DLPCSCRX)   +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*247526*/
             ENDDO                                                                        /*247526*/
                                                                                          /*247526*/
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
 
             RCLRSC
 
/*  IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
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
                CALL       PGM(SCC0010) PARM('DLC02A' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
 /* PROCESSING FOR CONFIRMATIONS */
 
       IF         COND(%SWITCH(XXXXX000)) THEN(DO)
 
 /* DO CONFIRMATIONS IF FRA/IRS DEAL INPUT DONE */
 
 /********IF         COND((&PROG *EQ 'IRFRASIN') +                                        /*195484*/
 /**********          *OR (&PROG *EQ 'IRSIRSSIN') +                                       /*195484*/
 /**********          *OR (&PROG *EQ 'IRCIRSSIN') +                                       /*195484*/
 /**********          *OR (&PROG *EQ 'IRIFRAMNT') +                                       /*195484*/
 /**********          *OR (&PROG *EQ 'IRISIRSMNT') +                                      /*195484*/
 /**********          *OR (&PROG *EQ 'IRICIRSMNT')) THEN(DO)                              /*195484*/
 /********IF         COND((&PROG *EQ 'IRFRASIN') +          */                 /*195484*/ /*CAP055*/
 /**********          *OR (&PROG *EQ 'IRSIRSSIN') +         */                 /*195484*/ /*CAP055*/
 /**********          *OR (&PROG *EQ 'IRCIRSSIN') +         */                 /*195484*/ /*CAP055*/
 /**********          *OR (&PROG *EQ 'IRFRARPR') +          */                 /*195484*/ /*CAP055*/
 /**********          *OR (&PROG *EQ 'IRSIRSRPR') +         */                 /*195484*/ /*CAP055*/
 /**********          *OR (&PROG *EQ 'IRCIRSRPR')) THEN(DO) */                 /*195484*/ /*CAP055*/
          IF         COND((&PROG *EQ 'IRFRASIN') +
                      *OR (&PROG *EQ 'IRSIRSSIN') +
                      *OR (&PROG *EQ 'IRCIRSSIN') +
                      *OR (&PROG *EQ 'IRCACFSIN') +
                      *OR (&PROG *EQ 'IRFRARPR') +
                      *OR (&PROG *EQ 'IRSIRSRPR') +
                      *OR (&PROG *EQ 'IRCIRSRPR') +
                      *OR (&PROG *EQ 'IRCACFRPR')) THEN(DO)                               /*CAP055*/
 
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
 
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
 
                IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
 
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS) /* $µ */
/*/COPY WNCPYSRC,DLC02A001                                           */
 
/************      SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                 /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
                   SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/************      SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                    /*CSC023*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                   /*CSC023*/
/************                   INLLIBL(*JOBD) MSGQ(MOPERQ)                               /*CSC023*/
                   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                                RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                                INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/*/COPY WNCPYSRC,DLC02A002                                           */
 
                   RCVF
 
                ENDDO
             ENDDO
          ENDDO
       ENDDO
                                                                                          /*CRE020*/
 /* If no previous error was encountered, Midas Plus Online Printing*/                    /*CRE020*/
 /* of Advices is switched on and FRA/IRS Deal Maintenance entered,*/                     /*CRE020*/
 /* print Input Cycle Debit/Credit Retail Advice Print.*/                                 /*CRE020*/
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXX000)) +
                     *AND (&CRE020 = 'Y')) THEN(DO)                                       /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PARM) VALUE('          ')                                    /*CRE020*/
                                                                                          /*CRE020*/
          IF         COND((&PROG *EQ 'IRCACFSIN') +
                      *OR (&PROG *EQ 'IRCIRSSIN') +
                      *OR (&PROG *EQ 'IRSIRSSIN') +
                      *OR (&PROG *EQ 'IRCACFRPR') +
                      *OR (&PROG *EQ 'IRSIRSRPR') +
                      *OR (&PROG *EQ 'IRCIRSRPR')) THEN(DO)
             CHGVAR     VAR(&PARM) VALUE(%SST(&PROG 1 6) *CAT 'UPD')                      /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND((&PROG *EQ 'IRFRASIN') *OR +
                             (&PROG *EQ 'IRFRARPR')) THEN(DO)                             /*CRE020*/
             CHGVAR     VAR(&PARM) VALUE('IRFRAUPD')                                      /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PARM *NE '          ') THEN(DO)                             /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(''' +
                        *CAT &PARM *CAT ''' ''DL'')')                                     /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
