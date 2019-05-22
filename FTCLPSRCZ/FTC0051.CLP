/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Funds Transfer Module                             */
/*                                                                   */
/*       FTC0051 - FT Menu Option Control Program                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. CSD102             Date 08Jan19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD021757           Date 14Aug13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CFT014             Date 25May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP136  *CREATE    Date 15Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD102 - Password Length Extension                          */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021757 - CAP211 Override OTXL0                            */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CFT014 - Straight-through Processing Phase 2 MT103          */
/*                Messages Generation for FT.                        */
/*       CAP136 - Conversion of FT Incoming Payment inputs into      */
/*                modular structure to use as APIs.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &ACTION &PREF &RTNCD &LINK &LEVEL)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&EMACT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&EMMOR) TYPE(*CHAR) LEN(28)
             DCL        VAR(&EMMIR) TYPE(*CHAR) LEN(28)
             DCL        VAR(&EMRTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&EMMSGR) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&EMPART) TYPE(*DEC) LEN(3 0)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FRUN) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Return code for call to ZAGETACTGP */
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/** The activation group that the called program runs in */
 
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10)
                                                                                          /*CSC022*/
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSC022*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&CRSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
                                                                                          /*CSC022*/
/*/COPY WNCPYSRC,FTC0051001                                          */
 
/** Monitor for error messages not trapped in the rest of the */
/** program.  If they occur reclaim resources and exit.       */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
 
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
/** Reset job switches. */
 
             CHGJOB     SWS(XXXXXX00)
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JBNM)) THEN(DO)                                                /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
 
/** Override files. */
 
             OVRDBF     FILE(INPAY)    SHARE(*NO)
             OVRDBF     FILE(INPAYXL0)    SHARE(*NO)                  /*CFT014*/
/** If Incoming Payment, then override OTXL0 introduced by CAP211 */                    /*MD021757*/
/*           IF         COND(&PROG *EQ 'FTIPAYSIN') THEN(DO)                     /*MD021757 CSD102*/
             IF         COND((&PROG *EQ 'FTIPAYSIN') *OR (&PROG *EQ +
                          'FTIPAYRPR')) THEN(DO)                                          /*CSD102*/
             OVRDBF     FILE(OTXL0) TOFILE(OTPAYXL0) SHARE(*NO)                         /*MD021757*/
             OVRDBF     FILE(OTPAYOVR) TOFILE(OTPAY) SHARE(*NO)                         /*MD021757*/
             ENDDO                                                                      /*MD021757*/
/*/COPY WNCPYSRC,FTC0051002                                          */
 
/** Call program. */
 
             CALL       PGM(&PROG) PARM(&ACTION &PREF &RTNCD +
                                        &LINK &LEVEL)
 
/** Delete overrides. */
 
             DLTOVR     FILE(INPAY)
             DLTOVR     FILE(INPAYXL0)                                /*CFT014*/
             DLTOVR     FILE(OTXL0)                                                     /*MD021757*/
             DLTOVR     FILE(OTPAYOVR)                                                  /*MD021757*/
 
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
 
/** For Database Errors, recover Data from LDA. */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/** Call SCC0010 to send abnormal termination screen. */
 
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
                CALL       PGM(SCC0010) PARM('FTC0051' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
 
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             GOTO       CMDLBL(END)
 
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
END:
 
/** Call ME1070 to remove any remaining reserved electronic msgs. */
 
             IF         COND(&FRUN = ' ') THEN(DO)
 
                CHGVAR     VAR(&FRUN) VALUE('Y')
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                CHGVAR     VAR(&EMACT) VALUE('*END   ')
                CHGVAR     VAR(&EMMOR) +
                             VALUE('                            ')
                CHGVAR     VAR(&EMMIR) +
                             VALUE('                            ')
                CHGVAR     VAR(&EMRTN) VALUE('       ')
                CHGVAR     VAR(&EMMSGR) VALUE(0)
                CHGVAR     VAR(&EMPART) VALUE(0)
                CALL       PGM(ME1070) PARM(&EMACT &EMMSGR &EMPART +
                             &EMMOR &EMMIR &EMRTN)
 /**/                                                                                     /*CSC022*/
 /** Execute commit if SAR CSC022 is not enrolled or */                                   /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
                COMMIT
             ENDDO                                                                        /*CSC022*/
 
             ENDDO
 
             ENDPGM
