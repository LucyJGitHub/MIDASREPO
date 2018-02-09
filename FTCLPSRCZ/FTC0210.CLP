/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Account key generation')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0210    ACCOUNT KEYS GENERATION                          */
/*                  =======================                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CFT009             Date 16May01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CFT014             Date 25May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT006             Date 20Dec99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CFT002             Date 20Nov98              */
/*                      096807               DATE  22APR96           */
/*                      S01435               DATE  15SEP93           */
/*                      056031               DATE  07JUN93           */
/*                      E37991               DATE  01APR92           */
/*                      E36108               DATE  26FEB92           */
/*                      S01194               DATE  12DEC90           */
/*                      S01189               DATE  03/04/89          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFT009 - Delete and recreate XOTPAYXPD and XINPAYXPD if     */
/*                the layouts do not match OTPAYXPD and INPAYXPD.    */
/*       CFT014 - Straight-through Processing Phase 2 MT103          */
/*                Messages Generation for FT.                        */
/*       CFT006 - Straight Through Processing Phase II               */
/*       CFT002 - Straight Through Processing Phase 1                */
/*       096807 - Correct restart procedure for run in I/C initiation*/
/*                (eg no update of transaction files)                */
/*       S01435 - Incoming Message Management.                       */
/*       056031 - Add reclaim resources to remove FT0005 from stack  */
/*                (Error fix 041693)                                 */
/*       E37991 - RESET BUSY FLAG TO N AFTER SUCCESSFUL COMPLETION   */
/*       E36108 - CHANGE TO USE NEW LIBRARY SUFFIXES                 */
/*       S01194 - NEW DATABASE ERROR HANDLING                        */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*********************************************************************/
/*          PGM     PARM(&RMODE)                                   */ /*S01189*/
            PGM     PARM(&RMODE &CNAM &CSEQ)                          /*S01189*/
            DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)                    /*S01189*/
            DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5)                      /*S01189*/
            DCL     VAR(&BUSY) TYPE(*CHAR) LEN(1)                     /*S01189*/
/*          DCL     VAR(&DATA) TYPE(*CHAR) LEN(44)                 */ /*S01194*/
            DCL     VAR(&DATA) TYPE(*CHAR) LEN(50)                    /*S01194*/
            DCL     VAR(&RMODE) TYPE(*CHAR) LEN(1)
            DCL     VAR(&LIB)  TYPE(*CHAR) LEN(10)
            DCL     VAR(&PRE)  TYPE(*CHAR) LEN(2)
            DCL     VAR(&CMT_A) TYPE(*CHAR) LEN(1)                    /*S01435*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FTC0210006                                          */
/**/
/* DCL     VAR(&FTSTAT)  TYPE(*CHAR) LEN(256)                      */ /*S01189*/
/**/
            SNDPGMMSG MSG('FT0210 - Account keys Generation') +
                          TOMSGQ(MRUNQ)
/**/
/*          ALCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))                   */ /*S01189*/
/*           RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)             */ /*S01189*/
            IF        COND(&RMODE *NE 'S') THEN(DO)                   /*096807*/
            CHGVAR    VAR(&BUSY) VALUE(' ')                           /*S01189*/
            CALL      CB0160 PARM(&CNAM &CSEQ &BUSY)                  /*S01189*/
            ENDDO                                                     /*096807*/
/**/
                CLRPFM FILE(FPKEYZZ)
                CLRPFM FILE(FPKEYDD)
/* */                                                                 /*S01435*/
/* Start Commit Control */                                            /*S01435*/
/* */                                                                 /*S01435*/
/**********  STRCMTCTL  LCKLVL(*CHG) **/                              /*S01435*/ /*CFT002*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CFT002*/
             MONMSG     MSGID(CPF8351 CPF9257) EXEC(DO)               /*S01435*/
             CHGVAR     VAR(&CMT_A) VALUE('Y')                        /*S01435*/
             ENDDO                                                    /*S01435*/
/* */                                                                 /*S01435*/
/**/
            IF COND(&RMODE *NE 'S') THEN(DO)                          /*096807*/
/*          IF COND(%SUBSTRING(&FTSTAT 4 1) = 'N') THEN(DO)        */ /*S01189*/
            IF COND(&BUSY = 'N') THEN(DO)                             /*S01189*/
/**/
/**/
 
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
/*              CHGVAR     VAR(&LIB) VALUE(&PRE *TCAT 'DLIB')    */   /*E36108*/
                CHGVAR     VAR(&LIB) VALUE(&PRE *TCAT 'DPLIB')        /*E36108*/
 
                CPYF       FROMFILE(OTPAYZZ) TOFILE(&LIB/XOTPAYZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XOTPAYZZ)
                CPYF       FROMFILE(INPAYZZ) TOFILE(&LIB/XINPAYZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XINPAYZZ)
                CPYF       FROMFILE(CQCODZZ) TOFILE(&LIB/XCQCODZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQCODZZ)
                CPYF       FROMFILE(CQCOCZZ) TOFILE(&LIB/XCQCOCZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQCOCZZ)
                CPYF       FROMFILE(CQPACZZ) TOFILE(&LIB/XCQPACZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQPACZZ)
                CPYF       FROMFILE(CQPADZZ) TOFILE(&LIB/XCQPADZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQPADZZ)
                CPYF       FROMFILE(NTRANZZ) TOFILE(&LIB/XNTRANZZ) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XNTRANZZ)
                CPYF       FROMFILE(OTPAYDD) TOFILE(&LIB/XOTPAYDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XOTPAYDD)
                                                                      /*CFT014*/
                CPYF       FROMFILE(OTPAYXPD) TOFILE(&LIB/XOTPAYXPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM FILE(XOTPAYXPD))               /*CFT014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2965) +
                             EXEC(DO)                                                     /*CFT009*/
                   DLTF       FILE(&LIB/XOTPAYXPD)                                        /*CFT009*/
                   CPYF       FROMFILE(OTPAYXPD) TOFILE(&LIB/XOTPAYXPD) +
                                MBROPT(*REPLACE) CRTFILE(*YES)                            /*CFT009*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                EXEC(CLRPFM FILE(XOTPAYXPD))                              /*CFT009*/
                ENDDO                                                                     /*CFT009*/
                                                                      /*CFT014*/
                CPYF       FROMFILE(INPAYDD) TOFILE(&LIB/XINPAYDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XINPAYDD)
                                                                      /*CFT014*/
                CPYF       FROMFILE(INPAYXPD) TOFILE(&LIB/XINPAYXPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM FILE(XINPAYXPD))               /*CFT014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2965) +
                             EXEC(DO)                                                     /*CFT009*/
                   DLTF       FILE(&LIB/XINPAYXPD)                                        /*CFT009*/
                   CPYF       FROMFILE(INPAYXPD) TOFILE(&LIB/XINPAYXPD) +
                                MBROPT(*REPLACE) CRTFILE(*YES)                            /*CFT009*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                EXEC(CLRPFM FILE(XINPAYXPD))                              /*CFT009*/
                ENDDO                                                                     /*CFT009*/
                                                                      /*CFT014*/
                CPYF       FROMFILE(CQCODDD) TOFILE(&LIB/XCQCODDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQCODDD)
                CPYF       FROMFILE(CQCOCDD) TOFILE(&LIB/XCQCOCDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQCOCDD)
                CPYF       FROMFILE(CQPACDD) TOFILE(&LIB/XCQPACDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQPACDD)
                CPYF       FROMFILE(CQPADDD) TOFILE(&LIB/XCQPADDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XCQPADDD)
                CPYF       FROMFILE(NTRANDD) TOFILE(&LIB/XNTRANDD) +
                MBROPT(*REPLACE)  CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XNTRANDD)
                CPYF       FROMFILE(FT101HPD) TOFILE(&LIB/XFT101HPD) +
                             MBROPT(*REPLACE)  CRTFILE(*YES)                              /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFT101HPD))                                             /*CFT006*/
                CPYF       FROMFILE(FT101DPD) TOFILE(&LIB/XFT101DPD) +
                             MBROPT(*REPLACE)  CRTFILE(*YES)                              /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFT101DPD))                                             /*CFT006*/
                CPYF       FROMFILE(FT102HPD) TOFILE(&LIB/XFT102HPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)                               /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFT102HPD))                                             /*CFT006*/
                CPYF       FROMFILE(FT102DPD) TOFILE(&LIB/XFT102DPD) +
                             MBROPT(*REPLACE)  CRTFILE(*YES)                              /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFT102DPD))                                             /*CFT006*/
 
/*/COPY WNCPYSRC,FTC0210001                                          */
/**/
/*              CHGVAR VAR(%SUBSTRING(&FTSTAT 4 1)) VALUE('Y')     */ /*S01189*/
/*           CHGDTAARA  DTAARA(FTSTAT) VALUE(&FTSTAT)              */ /*S01189*/
                CHGVAR    VAR(&BUSY) VALUE('Y')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
/*              DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))               */ /*S01189*/
                ENDDO
/**/
            ELSE CMD(DO)
/**/
/**/
                CPYF       FROMFILE(XOTPAYZZ) TOFILE(OTPAYZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM OTPAYZZ)
                CPYF       FROMFILE(XINPAYZZ) TOFILE(INPAYZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM INPAYZZ)
                CPYF       FROMFILE(XCQCODZZ) TOFILE(CQCODZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQCODZZ)
                CPYF       FROMFILE(XCQCOCZZ) TOFILE(CQCOCZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQCOCZZ)
                CPYF       FROMFILE(XCQPACZZ) TOFILE(CQPACZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQPACZZ)
                CPYF       FROMFILE(XCQPADZZ) TOFILE(CQPADZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQPADZZ)
                CPYF       FROMFILE(XNTRANZZ) TOFILE(NTRANZZ) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM NTRANZZ)
                CPYF       FROMFILE(XOTPAYDD) TOFILE(OTPAYDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM OTPAYDD)
                                                                      /*CFT014*/
                CPYF       FROMFILE(XOTPAYXPD) TOFILE(OTPAYXPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM FILE(OTPAYXPD))                /*CFT014*/
                                                                      /*CFT014*/
                CPYF       FROMFILE(XINPAYDD) TOFILE(INPAYDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM INPAYDD)
                                                                      /*CFT014*/
                CPYF       FROMFILE(XINPAYXPD) TOFILE(INPAYXPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM FILE(INPAYXPD))                /*CFT014*/
                                                                      /*CFT014*/
                CPYF       FROMFILE(XCQCODDD) TOFILE(CQCODDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQCODDD)
                CPYF       FROMFILE(XCQCOCDD) TOFILE(CQCOCDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQCOCDD)
                CPYF       FROMFILE(XCQPACDD) TOFILE(CQPACDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQPACDD)
                CPYF       FROMFILE(XCQPADDD) TOFILE(CQPADDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM CQPADDD)
                CPYF       FROMFILE(XNTRANDD) TOFILE(NTRANDD) +
                MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM NTRANDD)
                CPYF       FROMFILE(XFT101HPD) TOFILE(FT101HPD) +
                             MBROPT(*REPLACE)                                             /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FT101HPD))                                              /*CFT006*/
                CPYF       FROMFILE(XFT101DPD) TOFILE(FT101DPD) +
                             MBROPT(*REPLACE)                                             /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FT101DPD))                                              /*CFT006*/
                CPYF       FROMFILE(XFT102HPD) TOFILE(FT102HPD) +
                             MBROPT(*REPLACE)                                             /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FT102HPD))                                              /*CFT006*/
                CPYF       FROMFILE(XFT102DPD) TOFILE(FT102DPD) +
                             MBROPT(*REPLACE)                                             /*CFT006*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FT102DPD))                                              /*CFT006*/
 
            ENDDO
            ENDDO                                                     /*096807*/
/*/COPY WNCPYSRC,FTC0210002                                          */
/**/
            CHGJOB SWS(XXXXXX00)
            CALL PGM(FT0210) PARM(&RMODE)
/**/
/*/COPY WNCPYSRC,FTC0210007                                          */
            IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/*                ALCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))             */ /*S01189*/
/*           RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)             */ /*S01189*/
/*                CHGVAR VAR(%SST(&FTSTAT 4 1)) VALUE('N')         */ /*S01189*/
/*           CHGDTAARA  DTAARA(FTSTAT) VALUE(&FTSTAT)              */ /*S01189*/
            IF COND(&RMODE *NE 'S') THEN(DO)                          /*096807*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*E37991*/
             CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)                 /*S01189*/
/*                DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))             */ /*S01189*/
         DLTF       FILE(XOTPAYZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XINPAYZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQCODZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQCOCZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQPACZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQPADZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XNTRANZZ)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XOTPAYDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XINPAYDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQCODDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQCOCDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQPACDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XCQPADDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XNTRANDD)
         MONMSG MSGID(CPF0000)
         DLTF       FILE(XFT101HPD)                                                       /*CFT006*/
         MONMSG     MSGID(CPF0000)                                                        /*CFT006*/
         DLTF       FILE(XFT101DPD)                                                       /*CFT006*/
         MONMSG     MSGID(CPF0000)                                                        /*CFT006*/
         DLTF       FILE(XFT102HPD)                                                       /*CFT006*/
         MONMSG     MSGID(CPF0000)                                                        /*CFT006*/
         DLTF       FILE(XFT102DPD)                                                       /*CFT006*/
         MONMSG     MSGID(CPF0000)                                                        /*CFT006*/
 
            ENDDO                                                     /*096807*/
 
/*/COPY WNCPYSRC,FTC0210003                                          */
            ENDDO
/**/
/** .. CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*                RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)    */ /*S01194*/
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)       /*S01194*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
/** .. CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                  SNDPGMMSG MSG('FILE CONTROLS OUT OF BALANCE') +
                            TOMSGQ(MRUNQ MOPERQ)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/* Reclaim Resources to remove FT0005 from stack */                   /*056031*/
/* */                                                                 /*056031*/
             RCLRSC     LVL(*CALLER)                                  /*056031*/
/* */                                                                 /*S01435*/
/* End Commit Control */                                              /*S01435*/
/* */                                                                 /*S01435*/
             IF         COND(&CMT_A *NE 'Y') THEN(DO)
             RCLACTGRP  ACTGRP(*ELIGIBLE)                             /*CFT002*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*CFT002*/
             ENDCMTCTL                                                /*S01435*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                /*S01435*/
             ENDDO                                                    /*S01435*/
/**/
            ENDPGM
