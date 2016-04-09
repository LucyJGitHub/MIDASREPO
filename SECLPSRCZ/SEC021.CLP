/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Trades input')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas   - MM Module                                         */
/*                                                                   */
/*       SEC021 - SE TRADES INPUT                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. 243774A            Date 16Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 236246             Date 27Sep05              */
/*                      234440             Date 26Jun05              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 02Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      201230             Date 21Jan02              */
/*                      CAP067             Date 24Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSE028             Date 06Jun01              */
/*                      192700             Date 30Apr01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE012             Date 16Aug99              */
/*                      CSE006             Date 03Jun99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CSE010             Date 21Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      140951             Date 26Aug98              */
/*                      CAP003  *CREATE    Date 02Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       243774A- Missing TRADSDX2 record from repair function.      */
/*                Add override for TRADSDY2.                         */
/*       236246 - Add override for TRADSD                            */
/*       234440 - Set Override for new EU Tax Files                  */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       201230 - DPTMVX2 is not being output if F14 is not taken.   */
/*                Force F14 if ISO1522 is 'Y' to prevent db error    */
/*       CAP067 - Repurchase Agreements API.                         */
/*       CSE028 - Standing Settlement Instructions Enhancement       */
/*       192700 - Override deleted twice by mistake.                 */
/*       CSE012 - Incorrect override file name.                      */
/*       CSE006 - Repurchase Agreements (REPOs) enhancement          */
/*       CSE010 - SE Transactions Enhancements.                      */
/*       140951 - Addition of F14 (Ext. Settlements) functionality.  */
/*       CAP003 - Conversion of MM inputs into modular structure to  */
/*                use as APIs - Phase 2.                             */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PROG)                                                       /*CSE028*/
             PGM        PARM(&PROG &ACTCDE &TRADRF)                                       /*CSE028*/
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTCDE) TYPE(*CHAR) LEN(1)                                   /*CSE028*/
             DCL        VAR(&TRADRF) TYPE(*CHAR) LEN(6)                                   /*CSE028*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CRE020*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(40)                                    /*CRE020*/
             DCL        VAR(&QUOTE) TYPE(*CHAR) LEN(1) VALUE('''')                        /*CRE020*/
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
/*/COPY WNCPYSRC,SEC021002                                           */
 
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
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&SAR)  VALUE('CRE020')                                        /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
               GOTO   CMDLBL(ERR)                                                         /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/                                                                                     /*243774A*/
             IF         COND(&PROG = 'SETRADRPR') THEN(DO)                               /*243774A*/
               OVRDBF     FILE(TRADSDY2) TOFILE(TRADSDY2) SHARE(*NO)                     /*243774A*/
             ENDDO                                                                       /*243774A*/
/**/                                                                  /*CSE010*/
             IF         COND(&PROG = 'SETRADOIN') THEN(DO)            /*CSE010*/
               OVRDBF     FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)  /*CSE010*/
               OVRDBF     FILE(TRADSR)   SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(TRADSDL5) SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(TRADSDL6) SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(TRADSDL7) SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(TRADSDL8) SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(TRADSDL9) SHARE(*NO)                   /*CSE010*/
             ENDDO                                                    /*CSE010*/
 
/** Data area SESDS */
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                        DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37))
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 10)) VALUE(&PROG)
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
 
             IF         COND((&PROG = 'SETRADSIN') *OR +
                             (&PROG = 'SETRADRPR') *OR +
                             (&PROG = 'SETRADOIN') *OR +
                             (&PROG = 'SEBYSLRPR')) THEN(DO)                              /*CAP067*/
/***********                 (&PROG = 'SETRADOIN')) THEN(DO)                       /*CSE010 CAP067*/
/***********                 (&PROG = 'SETRADRPR')) THEN(DO)       */ /*CSE010*/
             OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)        /*CSE010*/
             OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)        /*CSE010*/
             OVRDBF     FILE(SECTYZ3) TOFILE(SECTY) SHARE(*NO)        /*CSE010*/
             OVRDBF     FILE(TRADS) SHARE(*NO)
             OVRDBF     FILE(TRADSDY1) SHARE(*NO)
             OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)     /*140951*/
             OVRDBF FILE(TRADSDZ3) TOFILE(TRADSDY2) SHARE(*NO)                            /*201230*/
/*/COPY WNCPYSRC,SEC021001                                           */
             OVRDBF     FILE(SEPCCD) SHARE(*NO)
             OVRDBF     FILE(SEPCBD) SHARE(*NO)
             OVRDBF     FILE(ETCPOSL0) SHARE(*NO)                                         /*234440*/
             OVRDBF     FILE(ETCPOSL3) SHARE(*NO)                                         /*234440*/
             OVRDBF FILE(TRADS) SHARE(*NO)                                                /*236246*/
             ENDDO
                                                                      /*CSE006*/
             IF         COND(&PROG = 'SEBYSLSIN') THEN(DO)            /*CSE006*/
             OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)        /*CSE006*/
             OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)        /*CSE006*/
             OVRDBF     FILE(SECTYZ3) TOFILE(SECTY) SHARE(*NO)        /*CSE006*/
             OVRDBF     FILE(TRADSDZ1) TOFILE(TRADSDY1) SHARE(*NO)    /*CSE006*/
             OVRDBF     FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)    /*CSE006*/
             OVRDBF     FILE(TRADSDZ3) TOFILE(TRADSDY2) SHARE(*NO)                        /*201230*/
             OVRDBF     FILE(TRADSDY1) TOFILE(BULKSDY1) SHARE(*NO)    /*CSE006*/
             OVRDBF     FILE(TRADSDY2) TOFILE(BULKSDY2) SHARE(*NO)    /*CSE006*/
             OVRDBF     FILE(SEBYSLPD) SHARE(*NO)                     /*CSE006*/
             OVRDBF     FILE(SECTY) SHARE(*NO)                        /*CSE006*/
             OVRDBF     FILE(SEPCBD) SHARE(*NO)                       /*CSE006*/
             ENDDO                                                    /*CSE006*/
                                                                      /*CSE006*/
 
/*  CALL PROGRAM             */
 
             IF         COND(&PROG = 'SETRADSIN') THEN(DO)                                /*CSE028*/
             CALL       PGM(&PROG) PARM(&ACTCDE &TRADRF)                                  /*CSE028*/
             ENDDO                                                                        /*CSE028*/
             ELSE       CMD(IF COND(&PROG *NE 'SETRADSIN') THEN(DO))                      /*CSE028*/
             CALL       PGM(&PROG)
             ENDDO                                                                        /*CSE028*/
 
             IF         COND(&PROG = 'SETRADRPR') THEN(DO)                               /*243774A*/
               DLTOVR     FILE(TRADSDY2)                                                 /*243774A*/
             ENDDO                                                                       /*243774A*/
/**/                                                                                     /*243774A*/
             IF         COND((&PROG = 'SETRADSIN') *OR +
                             (&PROG = 'SETRADRPR') *OR +
                             (&PROG = 'SETRADOIN') *OR +
                             (&PROG = 'SEBYSLRPR')) THEN(DO)                              /*CAP067*/
/***********                 (&PROG = 'SETRADOIN')) THEN(DO)                       /*CSE010 CAP067*/
/***********                 (&PROG = 'SETRADRPR')) THEN(DO)       */ /*CSE010*/
             DLTOVR     FILE(SECTYZ1)                                 /*CSE010*/
             DLTOVR     FILE(SECTYZ2)                                 /*CSE010*/
             DLTOVR     FILE(SECTYZ3)                                 /*CSE010*/
             DLTOVR     FILE(TRADS)
             DLTOVR     FILE(TRADSDY1)
             DLTOVR     FILE(SEPCCD)
             DLTOVR     FILE(SEPCBD)
             ENDDO                                                    /*CSE006*/
             IF         COND(&PROG = 'SEBYSLSIN') THEN(DO)            /*CSE006*/
             DLTOVR     FILE(SECTYZ1)                                 /*CSE006*/
             DLTOVR     FILE(SECTYZ2)                                 /*CSE006*/
             DLTOVR     FILE(SECTYZ3)                                 /*CSE006*/
             DLTOVR     FILE(TRADSDZ1)                                /*CSE006*/
             DLTOVR     FILE(TRADSDZ2)                                /*CSE006*/
             DLTOVR     FILE(TRADSDZ3)                                                    /*201230*/
/*********** DLTOVR     FILE(TRADSDY2)                     /*CSE006*/ /*192700*/
             DLTOVR     FILE(TRADSDY1)                                /*192700*/
             DLTOVR     FILE(TRADSDY2)                                /*CSE006*/
             DLTOVR     FILE(SEBYSLPD)                                /*CSE006*/
             DLTOVR     FILE(SECTY)                                   /*CSE006*/
             DLTOVR     FILE(SEPCBD)                                  /*CSE006*/
             ENDDO                                                    /*CSE006*/
 
/**/                                                                  /*CSE010*/
/*  Delete override files for SETRADOIN program */                    /*CSE010*/
/**/                                                                  /*CSE010*/
             IF         COND((&PROG = 'SETRADOIN')) THEN(DO)          /*CSE010*/
/***********   DLTOVR     FILE(TRADSZ1)                    /*CSE010*/ /*CSE012*/
               DLTOVR     FILE(TRADSDZ1)                              /*CSE012*/
               DLTOVR     FILE(TRADSR)                                /*CSE010*/
               DLTOVR     FILE(TRADSDL5)                              /*CSE010*/
               DLTOVR     FILE(TRADSDL6)                              /*CSE010*/
               DLTOVR     FILE(TRADSDL7)                              /*CSE010*/
               DLTOVR     FILE(TRADSDL8)                              /*CSE010*/
               DLTOVR     FILE(TRADSDL9)                              /*CSE010*/
             ENDDO                                                    /*CSE010*/
/**/                                                                  /*CSE010*/
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
                                                                      /*CSE006*/
             IF         COND(&PROG *NE 'SEBYSLSIN') THEN(DO)          /*CSE006*/
 
                 SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/************    SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +                              /*CSC023*/
/************           RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +                            /*CSC023*/
/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CSC023*/
 
/************    SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                             /*CSC023*/
/************           RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                           /*CSC023*/
/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CSC023*/
 
                 SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
 
                 SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
             ENDDO                                                    /*CSE006*/
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
                 IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
                 SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                              RTGDTA(*JOBD) RQSDTA('CALL  +
                              PGM(REC000881) PARM(''SETRADUPD'' +
                              ''SE'')') INLLIBL(*JOBD) MSGQ(MOPERQ)                       /*CRE020*/
                 ENDDO                                                                    /*CRE020*/
 
END:         RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
