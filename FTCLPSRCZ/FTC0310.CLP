/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments Level 1')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0310  - FT General Control component for maintenance     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CFT009             Date 21Aug00              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CFT014             Date 25May00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAC001             Date 01Feb96              */
/*                      S01435             Date 07Oct93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CFT009 - Fees and Charges Development                       */
/*       CFT014 - Straight-through Processing Phase 2 MT103          */
/*                Messages Generation for FT.                        */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                Provide a sixth parameter for margin information   */
/*                to be passed onto pgms FT0345 and FT0355.          */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&RTN_CODE &PROGRAM &ACTION &PREF +
                          &FT_CNTRL) */                               /*CAC001*/
/*/COPY WNCPYSRC,FTC0310003                                          */
/**********  PGM        PARM(&RTN_CODE &PROGRAM &ACTION &PREF +       /*CFT009*/
/**********               &FT_CNTRL &MINFO)                    /*CAC001 CFT009*/
             PGM        PARM(&RTN_CODE &PROGRAM &ACTION &PREF +
                          &FT_CNTRL &MINFO &FLAG12)                   /*CFT009*/
/*/COPY WNCPYSRC,FTC0310005                                          */
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&FT_CNTRL) TYPE(*CHAR) LEN(64)
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MINFO) TYPE(*CHAR) LEN(14)               /*CAC001*/
             DCL        VAR(&FLAG12) TYPE(*CHAR) LEN(1)               /*CFT009*/
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
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
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
/* */
/* Send Message to MRUNQ */
/* */
             IF         COND(%SST(&PROGRAM 1 2) *EQ 'FT') THEN(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('P' *CAT &PROGRAM)
             SNDPGMMSG  MSGID(&MESSAGE) MSGF(FTUSRMSG) TOMSGQ(MRUNQ)
             ENDDO
             CHGJOB     SWS(XXXXX000)
/* */
/* If allocation of MEINMRPD allowed then clear */
/* */
             IF         COND(&PREF *NE ' ') THEN(DO)
             GOTO       CMDLBL(MISS_CLEAR)
             ENDDO
             ALCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(MISS_CLEAR)
             ENDDO
             CLRPFM     FILE(MEINMRPD)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
 MISS_CLEAR:
             ALCOBJ     OBJ((MEINMRPD *FILE *SHRUPD)) WAIT(600)
/* */
/* Run FT Program  */
/* */
/*/COPY WNCPYSRC,FTC0310001                                          */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/*/COPY WNCPYSRC,FTC0310002                                          */
             IF         COND((&PROGRAM *EQ 'FT0340') *OR (&PROGRAM +
                          *EQ 'FT0345')) THEN(DO)
             OVRDBF     FILE(OTPAYL1) TOFILE(OTPAY) SHARE(*NO)
             OVRDBF     FILE(OTPAYL0) TOFILE(OTPAY) SHARE(*NO)
             OVRDBF     FILE(OTPAY) SHARE(*NO)                        /*CFT009*/
                                                                      /*CFT014*/
             OVRDBF     FILE(OTPAYXL0) SHARE(*NO)                     /*CFT014*/
             OVRDBF     FILE(OTPAYXL2) SHARE(*NO)                     /*CFT014*/
                                                                      /*CFT014*/
/*/COPY WNCPYSRC,FTC0310007                                          */
/*/COPY WNCPYSRC,FTC0310004                                          */
             ENDDO
             IF         COND((&PROGRAM *EQ 'FT0350') *OR (&PROGRAM +
                          *EQ 'FT0355')) THEN(DO)
             OVRDBF     FILE(INPAYL1) TOFILE(INPAY) SHARE(*NO)
             OVRDBF     FILE(INPAYL0) TOFILE(INPAY) SHARE(*NO)
             OVRDBF     FILE(INPAY) SHARE(*NO)                        /*CFT009*/
/*/COPY WNCPYSRC,FTC0310008                                          */
/*/COPY WNCPYSRC,FTC0310006                                          */
             ENDDO
/* */
/**********  CALL       PGM(&PROGRAM) PARM(&RTN_CODE &ACTION &PREF +
                          &FT_CNTRL) */                               /*CAC001*/
/* Call FT0345 with extra paramater */                                /*CFT009*/
             IF         COND((&PROGRAM *EQ 'FT0345') *OR (&PROGRAM +
                          *EQ 'FT0355')) THEN(DO)                     /*CFT009*/
             CALL       PGM(&PROGRAM) PARM(&RTN_CODE &ACTION &PREF +
                          &FT_CNTRL &MINFO &FLAG12)                   /*CFT009*/
             ENDDO                                                    /*CFT009*/
/* If not calling FT0345, use original call */                        /*CFT009*/
             IF         COND((&PROGRAM *NE 'FT0345') *AND (&PROGRAM +
                          *NE 'FT0355')) THEN(DO)                     /*CFT009*/
/*/COPY WNCPYSRC,FTC0310009                                          */
             CALL       PGM(&PROGRAM) PARM(&RTN_CODE &ACTION &PREF +
                          &FT_CNTRL &MINFO)                           /*CAC001*/
             ENDDO                                                    /*CFT009*/
/*/COPY WNCPYSRC,FTC0310010                                          */
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/* */
/* CALL ME1070 to remove any remaining reserved electronic msgs*/
/* */
             CALL       PGM(ME1070) PARM('*END    ' X'000000000F' +
                          X'000F' ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 /**/                                                                                     /*CSC022*/
 /** Execute commit if SAR CSC022 is not enrolled or */                                   /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             COMMIT
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
/* */
/* Remove allocation if pref blank */
/* */
             IF         COND(&PREF *EQ ' ') THEN(DO)
             CALL       PGM(AOC8000) PARM(' ' 'FT' ' ' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program ' *CAT &PROGRAM *BCAT ' ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ' *CAT &PROGRAM *BCAT ' ended abnormally') +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/********** ENDCLPGM:   ROLLBACK    */                                                    /*CSC022*/
ENDCLPGM:                                                                                 /*CSC022*/
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
             ROLLBACK                                                                     /*CSC022*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/* */
/* CALL ME1070 to remove any remaining reserved electronic msgs*/
/* */
             IF         COND((&PROGRAM *EQ 'FT0340') *OR (&PROGRAM +
                          *EQ 'FT0350')) THEN(DO)
             CALL       PGM(ME1070) PARM('*END    ' X'000000000F' +
                          X'000F' ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 /**/                                                                                     /*CSC022*/
 /** Execute commit if SAR CSC022 is not enrolled or */                                   /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             COMMIT
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
             ENDDO
/* */
/* Remove allocation if pref blank */
/* */
             IF         COND(&PREF *EQ ' ') THEN(DO)
             CALL       PGM(AOC8000) PARM(' ' 'FT' ' ' ' ')
             ENDDO
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *SHRUPD))
             MONMSG     MSGID(CPF0000)
/* */
             ENDPGM
