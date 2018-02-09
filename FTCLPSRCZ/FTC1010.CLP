/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Accrual reorganisations')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     FUNDS TRANSFER MODULE                             */
/*                                                                   */
/********FTC1010****FUNDS*TRANSFER*-*DAILY*REORGANISATION*           *065746*/
/*       FTC1010    Funds Transfer - Purge Processing                *065746*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR829688           Date 14Nov12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG24691           Date 30Jul09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT008             Date 04Jan00              */
/*                      CFT006             Date 15Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10Nov95              */
/*                      065746             Date 21Jan94              */
/*                          E36108             DATE 26FEB92          */
/*                          E32894             DATE 07JUN91          */
/*                          S01194             DATE 06DEC90          */
/*                          S01189             DATE 03/04/89         */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR829688 - Include PF/OTPAYDQD and PF/INPAYDQD              */
/*                  in the reorganization. (Child: AR829689)         */
/*       BUG24691 - COV details report are missing                   */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CFT008 - Funds Transfer/Swift Messages MT102                */
/*       CFT006 - Funds Transfer/Swift Messages MT101                */
/*       S01408 - Addition Of Core Hook FTC1010INT                   */
/*                Addition Of Core Hook FTC1010001                   */
/*                Addition Of Core Hook FTC1010002                   */
/*                Addition Of Core Hook FTC1010003                   */
/*                Addition Of Core Hook FTC1010004                   */
/*       065746 - Delete backup files after successful run.          */
/*              - COB component FTC1010 seq. 00001 changed to run    */
/*                every day.                                         */
/*              - Purge processing only done if next day is a non-   */
/*                working day.                                       */
/*       E36108 - CHANGE TO USE NEW LIBRARY SUFFIXES                 */
/*       E32894 - TOTAL REWRITE AS ORIGINAL COMPONANT WAS NOT        */
/*                RESTARTABLE.                                       */
/*       S01194 - NEW DATABASE ERROR HANDLING                        */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*                                                                   */
/*********************************************************************/
/*      PGM                                                        */ /*S01189*/
        PGM     PARM(&CNAM &CSEQ)                                     /*S01189*/
         DCL     VAR(&PRE)  TYPE(*CHAR) LEN(2)
         DCL     VAR(&DLIB) TYPE(*CHAR) LEN(10)
         DCL     VAR(&DMLIB) TYPE(*CHAR) LEN(10)
/*      DCL     VAR(&DATA) TYPE(*CHAR) LEN(44)                     */ /*S01194*/
        DCL     VAR(&DATA) TYPE(*CHAR) LEN(50)                        /*S01194*/
        DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)                        /*S01189*/
        DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5)                          /*S01189*/
        DCL     VAR(&BUSY) TYPE(*CHAR) LEN(1)                         /*S01189*/
/**/
/*      DCL     VAR(&FTSTAT) TYPE(*CHAR) LEN(256)                 */  /*S01189*/
         DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*   Start of amendment 065746                          */
        DCL     VAR(&DAYS) TYPE(*DEC) LEN(5 0)                        /*065746*/
/*/COPY WNCPYSRC,FTC1010006                                          */
/* */                                                                 /*065746*/
/* Declare file SDBANKPD  */                                          /*065746*/
/* */                                                                 /*065746*/
             DCLF       FILE(SDBANKPD)                                /*065746*/
/*   End of amendment 065746                            */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1010INT                                          */
                                                                      /*S01408*/
/**/
/* Global error trap                                                          */
/**/
         MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                       CMDLBL(ABNORMAL))
/*/COPY WNCPYSRC,FTC1010010                                          */
/**/
/*   Start of amendment 065746                          */
/**      SNDPGMMSG MSG('FT1010 - Accrual Reorganisation')      +
                       TOMSGQ(MRUNQ)                             **/  /*065746*/
         SNDPGMMSG MSG('FT1010 - FT Transaction Purge')      +
                       TOMSGQ(MRUNQ)                                  /*065746*/
/*/COPY WNCPYSRC,FTC1010011                                          */
/* */                                                                 /*065746*/
/* Get Bank Information and see if non-working days exist */          /*065746*/
/* */                                                                 /*065746*/
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)                     /*065746*/
             RCVF                                                     /*065746*/
             CHGVAR     VAR(&DAYS) VALUE(&BJDNWD - &BJRDNB)           /*065746*/
             IF         COND(&DAYS *LE 1) THEN(DO)                    /*065746*/
             GOTO       CMDLBL(ENDPRC)                                /*065746*/
             ENDDO                                                    /*065746*/
/* */                                                                 /*065746*/
/*   End of amendment 065746                            */
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1010001                                          */
                                                                      /*S01408*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*           CHGVAR     VAR(&DLIB) VALUE(&PRE *TCAT 'DLIB')      */   /*E36108*/
             CHGVAR     VAR(&DLIB) VALUE(&PRE *TCAT 'DPLIB')          /*E36108*/
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
/**/
/*           ALCOBJ(OBJ((FTSTAT *DTAARA *EXCLRD))                  */ /*S01189*/
/*           RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)             */ /*S01189*/
        CHGVAR    VAR(&BUSY) VALUE(' ')                               /*S01189*/
        CALL      CB0160 PARM(&CNAM &CSEQ &BUSY)                      /*S01189*/
/**/
/*       IF COND(%SUBSTRING(&FTSTAT 1 3) = 'OLD') THEN(DO)         */ /*S01189*/
        IF COND(&BUSY = 'N') THEN(DO)                                 /*S01189*/
/**/
             DLTF       FILE(&DLIB/OTPAYDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/OTPAYXPDX)                                           /*BUG24691*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG24691*/
             DLTF       FILE(&DLIB/OTPAYDQDX)                                           /*AR829688*/
             MONMSG     MSGID(CPF2105)                                                  /*AR829688*/
             DLTF       FILE(&DLIB/OTPAYZZX)
             MONMSG     MSGID(CPF2105)
/*/COPY WNCPYSRC,FTC1010005                                          */
             DLTF       FILE(&DLIB/INPAYDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/INPAYXPDX)                                           /*BUG24691*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG24691*/
             DLTF       FILE(&DLIB/INPAYDQDX)                                           /*AR829688*/
             MONMSG     MSGID(CPF2105)                                                  /*AR829688*/
             DLTF       FILE(&DLIB/INPAYZZX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQCODDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQCODZZX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQCOCDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQCOCZZX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQPACDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQPACZZX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQPADDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQPADZZX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/NTRANDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/NTRANZZX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQREGDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/CQREGZZX)
             MONMSG     MSGID(CPF2105)
/*                                                                   */
             DLTF       FILE(&DLIB/FT102DPDX)                         /*CFT008*/
             MONMSG     MSGID(CPF2105)                                /*CFT008*/
             DLTF       FILE(&DLIB/FT102HPDX)                         /*CFT008*/
             MONMSG     MSGID(CPF2105)                                /*CFT008*/
             DLTF       FILE(&DLIB/MEIRFTPDX)                         /*CFT006*/
             MONMSG     MSGID(CPF2105)                                /*CFT006*/
             DLTF       FILE(&DLIB/FT101DPDX)                         /*CFT006*/
             MONMSG     MSGID(CPF2105)                                /*CFT006*/
             DLTF       FILE(&DLIB/FT101HPDX)                         /*CFT006*/
             MONMSG     MSGID(CPF2105)                                /*CFT006*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1010002                                          */
                                                                      /*S01408*/
             CPYF       FROMFILE(&DMLIB/OTPAYDD) +
                          TOFILE(&DLIB/OTPAYDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/OTPAYXPD) +
                          TOFILE(&DLIB/OTPAYXPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                 /*BUG24691*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG24691*/
             CPYF       FROMFILE(&DMLIB/OTPAYDQD) +
                          TOFILE(&DLIB/OTPAYDQDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                 /*AR829688*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*AR829688*/
             CPYF       FROMFILE(&DMLIB/OTPAYZZ) +
                          TOFILE(&DLIB/OTPAYZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/INPAYDD) +
                          TOFILE(&DLIB/INPAYDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/INPAYXPD) +
                          TOFILE(&DLIB/INPAYXPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                 /*BUG24691*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG24691*/
             CPYF       FROMFILE(&DMLIB/INPAYDQD) +
                          TOFILE(&DLIB/INPAYDQDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                 /*AR829688*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*AR829688*/
             CPYF       FROMFILE(&DMLIB/INPAYZZ) +
                          TOFILE(&DLIB/INPAYZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQCODDD) +
                          TOFILE(&DLIB/CQCODDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQCODZZ) +
                          TOFILE(&DLIB/CQCODZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQCOCDD) +
                          TOFILE(&DLIB/CQCOCDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQCOCZZ) +
                          TOFILE(&DLIB/CQCOCZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQPACDD) +
                          TOFILE(&DLIB/CQPACDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQPACZZ) +
                          TOFILE(&DLIB/CQPACZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQPADDD) +
                          TOFILE(&DLIB/CQPADDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQPADZZ) +
                          TOFILE(&DLIB/CQPADZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/NTRANDD) +
                          TOFILE(&DLIB/NTRANDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/NTRANZZ) +
                          TOFILE(&DLIB/NTRANZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQREGDD) +
                          TOFILE(&DLIB/CQREGDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/CQREGZZ) +
                          TOFILE(&DLIB/CQREGZZX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(FT102DPD) +
                          TOFILE(&DLIB/FT102DPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(FT102HPD) +
                          TOFILE(&DLIB/FT102HPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(MEIRFTPD) +
                          TOFILE(&DLIB/MEIRFTPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(FT101DPD) +
                          TOFILE(&DLIB/FT101DPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(FT101HPD) +
                          TOFILE(&DLIB/FT101HPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
                                                                      /*CFT006*/
/*/COPY WNCPYSRC,FTC1010007                                          */
/**/
             ENDDO
/**/
/*       IF COND(%SUBSTRING(&FTSTAT 1 3) = 'NEW') THEN(DO)         */ /*S01189*/
        IF COND(&BUSY = 'Y') THEN(DO)                                 /*S01189*/
/**/
             CPYF       FROMFILE(&DLIB/OTPAYDDX) +
                          TOFILE(&DMLIB/OTPAYDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/OTPAYXPDX) +
                          TOFILE(&DMLIB/OTPAYXPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                                  /*BUG24691*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG24691*/
             CPYF       FROMFILE(&DLIB/OTPAYDQDX) +
                          TOFILE(&DMLIB/OTPAYDQD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                                  /*AR829688*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*AR829688*/
             CPYF       FROMFILE(&DLIB/OTPAYZZX) +
                          TOFILE(&DMLIB/OTPAYZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/INPAYDDX) +
                          TOFILE(&DMLIB/INPAYDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/INPAYXPDX) +
                          TOFILE(&DMLIB/INPAYXPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                                  /*BUG24691*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG24691*/
             CPYF       FROMFILE(&DLIB/INPAYDQDX) +
                          TOFILE(&DMLIB/INPAYDQD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                                  /*AR829688*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*AR829688*/
             CPYF       FROMFILE(&DLIB/INPAYZZX) +
                          TOFILE(&DMLIB/INPAYZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQCODDDX) +
                          TOFILE(&DMLIB/CQCODDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQCODZZX) +
                          TOFILE(&DMLIB/CQCODZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQCOCDDX) +
                          TOFILE(&DMLIB/CQCOCDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQCOCZZX) +
                          TOFILE(&DMLIB/CQCOCZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQPACDDX) +
                          TOFILE(&DMLIB/CQPACDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQPACZZX) +
                          TOFILE(&DMLIB/CQPACZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQPADDDX) +
                          TOFILE(&DMLIB/CQPADDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQPADZZX) +
                          TOFILE(&DMLIB/CQPADZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/NTRANDDX) +
                          TOFILE(&DMLIB/NTRANDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/NTRANZZX) +
                          TOFILE(&DMLIB/NTRANZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQREGDDX) +
                          TOFILE(&DMLIB/CQREGDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/CQREGZZX) +
                          TOFILE(&DMLIB/CQREGZZ) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/FT102DPDX) +
                          TOFILE(FT102DPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(&DLIB/FT102HPDX) +
                          TOFILE(FT102HPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(&DLIB/MEIRFTPDX) +
                          TOFILE(MEIRFTPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(&DLIB/FT101DPDX) +
                          TOFILE(FT101DPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(&DLIB/FT101HPDX) +
                          TOFILE(FT101HPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1010003                                          */
                                                                      /*S01408*/
/**/
             ENDDO
/**/
/*           CHGDTAARA  DTAARA(FTSTAT (1 3)) VALUE('NEW')          */ /*S01189*/
                CHGVAR    VAR(&BUSY) VALUE('Y')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
             CHGJOB SWS(XXXXXX00)
             CALL PGM(FT1010)
/**/
/** .. CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*            RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)        */ /*S01194*/
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)           /*S01194*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO     ABNORMAL
             ENDDO
/**/
/** .. CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG MSG('FILE CONTROLS OUT OF BALANCE') +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO     ABNORMAL
             ENDDO
/**/
/**********  RGZPFM     FILE(&DMLIB/OTPAYDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('OTPAYDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                        /*BUG24691*/
             CALL       PGM(SCC000060) PARM('OTPAYXPD' '*FIRST')                        /*BUG24691*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                             /*BUG24691*/
                                                                                          /*228542*/
             CALL       PGM(SCC000060) PARM('OTPAYDQD' '*FIRST')                        /*AR829688*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                             /*AR829688*/
                                                                                        /*AR829688*/
/**********  RGZPFM     FILE(&DMLIB/INPAYDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('INPAYDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                        /*BUG24691*/
             CALL       PGM(SCC000060) PARM('INPAYXPD' '*FIRST')                        /*BUG24691*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                             /*BUG24691*/
                                                                                          /*228542*/
             CALL       PGM(SCC000060) PARM('INPAYDQD' '*FIRST')                        /*AR829688*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                             /*AR829688*/
                                                                                        /*AR829688*/
/**********  RGZPFM     FILE(&DMLIB/CQCODDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('CQCODDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/CQCOCDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('CQCOCDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/CQPACDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('CQPACDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/CQPADDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('CQPADDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/NTRANDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('NTRANDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/CQREGDD)                                              /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('CQREGDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/FT102DPD)                        /*CFT008*/           /*228542*/
/**********  MONMSG     MSGID(CPF2981)                               /*CFT008*/           /*228542*/
             CALL       PGM(SCC000060) PARM('FT102DPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/FT102HPD)                        /*CFT008*/           /*228542*/
/**********  MONMSG     MSGID(CPF2981)                               /*CFT008*/           /*228542*/
             CALL       PGM(SCC000060) PARM('FT102HPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/MEIRFTPD)                        /*CFT006*/           /*228542*/
/**********  MONMSG     MSGID(CPF2981)                               /*CFT006*/           /*228542*/
             CALL       PGM(SCC000060) PARM('MEIRFTPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/FT101DPD)                        /*CFT006*/           /*228542*/
/**********  MONMSG     MSGID(CPF2981)                               /*CFT006*/           /*228542*/
             CALL       PGM(SCC000060) PARM('FT101DPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(&DMLIB/FT101HPD)                        /*CFT006*/           /*228542*/
/**********  MONMSG     MSGID(CPF2981)                               /*CFT006*/           /*228542*/
             CALL       PGM(SCC000060) PARM('FT101HPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*228542*/
                                                                                          /*228542*/
/*/COPY WNCPYSRC,FTC1010008                                          */
/**/
/*           DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))                  */ /*S01189*/
/*           CHGDTAARA  DTAARA(FTSTAT (1 3)) VALUE('OLD')          */ /*S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
/*   Start of amendment 065746                          */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1010004                                          */
                                                                      /*S01408*/
             DLTF       FILE(&DLIB/OTPAYDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/OTPAYXPDX)                                           /*BUG24691*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG24691*/
             DLTF       FILE(&DLIB/OTPAYDQDX)                                           /*AR829688*/
             MONMSG     MSGID(CPF2105)                                                  /*AR829688*/
             DLTF       FILE(&DLIB/OTPAYZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/INPAYDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/INPAYXPDX)                                           /*BUG24691*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG24691*/
             DLTF       FILE(&DLIB/INPAYDQDX)                                           /*AR829688*/
             MONMSG     MSGID(CPF2105)                                                  /*AR829688*/
             DLTF       FILE(&DLIB/INPAYZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQCODDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQCODZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQCOCDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQCOCZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQPACDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQPACZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQPADDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQPADZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/NTRANDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/NTRANZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQREGDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/CQREGZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/FT102DPDX)                         /*CFT008*/
             MONMSG     MSGID(CPF2105)                                /*CFT008*/
             DLTF       FILE(&DLIB/FT102HPDX)                         /*CFT008*/
             MONMSG     MSGID(CPF2105)                                /*CFT008*/
             DLTF       FILE(&DLIB/MEIRFTPDX)                         /*CFT006*/
             MONMSG     MSGID(CPF2105)                                /*CFT006*/
             DLTF       FILE(&DLIB/FT101DPDX)                         /*CFT006*/
             MONMSG     MSGID(CPF2105)                                /*CFT006*/
             DLTF       FILE(&DLIB/FT101HPDX)                         /*CFT006*/
             MONMSG     MSGID(CPF2105)                                /*CFT006*/
/*/COPY WNCPYSRC,FTC1010009                                          */
/* */                                                                /*065746*/
/* Mark as component finished */                                     /*065746*/
/* */                                                                /*065746*/
 ENDPRC:                                                             /*065746*/
             CHGVAR     VAR(&BUSY) VALUE('N')                        /*065746*/
/*   End of amendment 065746                            */
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
/**/
/*  Normal completion - sidestep error routine.                               */
/**/
         GOTO       CMDLBL(THEEND)
/**/
/*  Error trap - send message if any abnormality.                             */
/**/
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
/*           DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))                  */ /*S01189*/
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDMSG     MSG('Program terminated abnormally.') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/* THEEND:  ENDPGM                                                 */ /*S01189*/
THEEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
            ENDPGM                                                    /*S01189*/
