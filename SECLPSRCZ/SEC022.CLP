/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Depot movements input')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Securities Trading                                */
/*                                                                   */
/*       SEC022 - SE DEPOT MOVEMENTS INPUT                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 236246             Date 27Sep05              */
/*       Prev Amend No. 234440             Date 26Jun05              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 02Feb04              */
/*                      CSE039             Date 12Feb03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      201230             Date 21Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSE028             Date 06Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      187544             Date 20Feb01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      167486             Date 10Apr00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/*                      CSE012             Date 18Aug99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CSE010             Date 21Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP003  *CREATE    Date 02Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       236246 - Add override for TRADSD                           */
/*       234440 - Set Override for new EU Tax Files                  */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSE039 - AUTOMATIC SETTLEMENT OF TRADES                     */
/*       201230 - DPTMVX2 is not being output if F14 is not taken.   */
/*                Force F14 if ISO1522 is 'Y' to prevent db error    */
/*                during message generation.                         */
/*       CSE028 - Standing Settlement Instructions Enhancement       */
/*       187544 - Depot Mvts - WI & WO: Review display of some       */
/*                PM/PB fields                                       */
/*       167486 - Use of DPTMVDZ1 & DPTMVDZ2 in SE1807.              */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       CSE012 - SE Depot Movement Narratives. (Overriding of files */
/*                failed due to incorrect conditions specified for   */
/*                CSE010.  New conditions were added for this fix.)  */
/*       CSE010 - SE Transactions Enhancements.                    */
/*       CAP003 - Conversion of MM inputs into modular structure to  */
/*                use as APIs - Phase 2.                             */
/*                                                                   */
/*********************************************************************/
/*/COPY WNCPYSRC,SEC022004                                           */
             PGM        PARM(&PROG &TYPE)
/*/COPY WNCPYSRC,SEC022005                                           */
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)
 
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
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE010*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE010*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSE010*/
             DCL        VAR(&SETY) TYPE(*CHAR) LEN(10)                /*CSE039*/
             DCL        VAR(&TRNO) TYPE(*CHAR) LEN(6)                 /*CSE039*/
             DCL        VAR(&CALPGM) TYPE(*CHAR) LEN(10)              /*CSE039*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PMOD) TYPE(*CHAR) LEN(10)                                    /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(40)                                    /*CRE020*/
             DCL        VAR(&QUOTE) TYPE(*CHAR) LEN(1) VALUE('''')                        /*CRE020*/
/*/COPY WNCPYSRC,SEC022003                                           */
 
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
 
/**/                                                                  /*CSE010*/
/**  Check if Transaction Enhancements is installed */                /*CSE010*/
/**/                                                                  /*CSE010*/
             CHGVAR     VAR(&SAR) VALUE('CSE010')                     /*CSE010*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE010*/
             CHGVAR     VAR(&CSE010) VALUE('N')                       /*CSE010*/
/**/                                                                  /*CSE010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE010*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE010*/
                CHGVAR     VAR(&CSE010) VALUE('Y')                    /*CSE010*/
             ENDDO                                                    /*CSE010*/
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
/**/                                                                  /*CSE010*/
/*********** IF         COND(&CSE010 *EQ 'Y') THEN(DO) */  /*CSE010*/ /*CSE012*/
/*********** IF         COND((&CSE010 *EQ 'Y') *AND +
/***********                 (&PROG *EQ 'SETRADOIN')) THEN(DO)        /*187544*/
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)                /*187544*/
               OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)      /*CSE010*/
               OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)      /*CSE010*/
             IF         COND(&PROG *EQ 'SETRADOIN') THEN(DO)          /*187544*/
               OVRDBF     FILE(SECTYZ3) TOFILE(SECTY) SHARE(*NO)      /*CSE010*/
               OVRDBF     FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)  /*CSE010*/
/*/COPY WNCPYSRC,SEC022001                                           */
               OVRDBF     FILE(TRADS)    SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(TRADSDY1) SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(SEPCCD)   SHARE(*NO)                   /*CSE010*/
               OVRDBF     FILE(SEPCBD)   SHARE(*NO)                   /*CSE010*/
             ENDDO                                                    /*187544*/
             ENDDO                                                    /*CSE010*/
/** Data area SESDS */
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                        DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37))
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 10)) VALUE(&PROG)
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
 
             IF         COND((&PROG = 'SEDPMVSIN') *OR +
                             (&PROG = 'SEDPMVRPR')) THEN(DO)
             OVRDBF FILE(DPTMV) SHARE(*NO)
             OVRDBF FILE(SEPCCD) SHARE(*NO)
             OVRDBF FILE(DPTMVDY1) SHARE(*NO)                         /*CSE028*/
             OVRDBF FILE(DPTMVDZ1) TOFILE(DPTMVDY1) SHARE(*NO)        /*167486*/
             OVRDBF FILE(DPTMVDZ2) TOFILE(DPTMVDY2) SHARE(*NO)        /*167486*/
             OVRDBF FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)                            /*201230*/
             OVRDBF FILE(ETCPOSL0) SHARE(*NO)                                             /*234440*/
             OVRDBF FILE(ETCPOSL3) SHARE(*NO)                                             /*234440*/
             OVRDBF FILE(TRADS) SHARE(*NO)                                                /*236246*/
             ENDDO
 
/*  CALL PROGRAM             */
/*/COPY WNCPYSRC,SEC022006                                           */
 
/*********** CALL       PGM(&PROG) PARM(&TYPE)                       */                   /*CSE039*/
             CALL       PGM(&PROG) PARM(&TYPE &SETY &TRNO &RTCD &CALPGM)                  /*CSE039*/
/*/COPY WNCPYSRC,SEC022007                                           */
 
             IF         COND((&PROG = 'SEDPMVSIN') *OR +
                             (&PROG = 'SEDPMVRPR')) THEN(DO)
             DLTOVR FILE(DPTMV)
             DLTOVR FILE(SEPCCD)
             DLTOVR FILE(DPTMVDY1)                                    /*CSE028*/
             DLTOVR FILE(DPTMVDZ1)                                    /*167486*/
             DLTOVR FILE(DPTMVDZ2)                                    /*167486*/
             DLTOVR FILE(DPTMVDZ3)                                                        /*201230*/
             DLTOVR FILE(ETCPOSL0)                                                        /*234440*/
             DLTOVR FILE(ETCPOSL3)                                                        /*234440*/
             DLTOVR FILE(TRADS)                                                           /*236246*/
             ENDDO
 
/**/                                                                  /*CSE010*/
/*********** IF         COND(&CSE010 *EQ 'Y') THEN(DO) */  /*CSE010*/ /*CSE012*/
/*********** IF         COND((&CSE010 *EQ 'Y') *AND +
/***********                 (&PROG *EQ 'SETRADOIN')) THEN(DO)        /*187544*/
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)                /*187544*/
               DLTOVR     FILE(SECTYZ1)                               /*CSE010*/
               DLTOVR     FILE(SECTYZ2)                               /*CSE010*/
             IF         COND(&PROG *EQ 'SETRADOIN') THEN(DO)          /*187544*/
               DLTOVR     FILE(SECTYZ3)                               /*CSE010*/
               DLTOVR     FILE(TRADSDZ2)                              /*CSE010*/
/*/COPY WNCPYSRC,SEC022002                                           */
               DLTOVR     FILE(TRADS)                                 /*CSE010*/
               DLTOVR     FILE(TRADSDY1)                              /*CSE010*/
               DLTOVR     FILE(SEPCCD)                                /*CSE010*/
               DLTOVR     FILE(SEPCBD)                                /*CSE010*/
             ENDDO                                                    /*187544*/
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
                CALL       PGM(SCC0010) PARM('SEC022 ' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
                GOTO END
             ENDDO
 
 
 /* PRODUCE CONFIRMATIONS */
 
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
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
                 IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
                 SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                              RTGDTA(*JOBD) RQSDTA('CALL  +
                              PGM(REC000881) PARM(''SEDPMVUPD'' +
                              ''SE'')') INLLIBL(*JOBD) MSGQ(MOPERQ)                       /*CRE020*/
                 ENDDO                                                                    /*CRE020*/
 
END:         RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
