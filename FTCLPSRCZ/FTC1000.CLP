/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Daily reorganisation')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     FUNDS TRANSFER MODULE                             */
/*                                                                   */
/*       FTC1000    FUNDS TRANSFER - DAILY REORGANISATION            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD050391           Date 09Apr18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG25207           Date 28Jul09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT008             Date 04Jan00              */
/*                      CFT006             Date 15Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10Nov95              */
/*                      065746             Date 21Jan94              */
/*                      042167             DATE 15APR93              */
/*                      E36108             DATE 26FEB92              */
/*                      S01117             DATE 10DEC90              */
/*                      S01194             DATE 23NOV90              */
/*                      S01189             DATE 03/04/89             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD050391 - Include purge processing for NTRANDQD            */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG25207 - FTC0100 00001 failed                             */
/*       CFT008 - Funds Transfer/Swift Messages MT102                */
/*       CFT006 - Funds Transfer/Swift Messages MT101                */
/*       S01408 - Addition Of Core Hook FTC1000INT                   */
/*                Addition Of Core Hook FTC1000001                   */
/*                Addition Of Core Hook FTC1000002                   */
/*                Addition Of Core Hook FTC1000003                   */
/*                Addition Of Core Hook FTC1000004                   */
/*       065746 - Delete backup files after successful run.          */
/*                Reorganisation of files removed from FTC1000,      */
/*                now this process is done only once in FTC1010.     */
/*       042167 - CL PROGRAM FOR RECORD LOCKING                      */
/*       E36108 - CHANGE TO USE NEW LIBRARY SUFFIXES                 */
/*       E32894 - TOTAL REWRITE AS ORIGINAL COMPONANT WAS NOT        */
/*                RESTARTABLE.                                       */
/*       S01117 - MULTIBRANCHING CHANGES                             */
/*       S01194 - NEW DATABASE ERROR HANDLING                        */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*                                                                   */
/*********************************************************************/
/*       PGM                                                       */ /*S01189*/
         PGM     PARM(&CNAM &CSEQ)                                    /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
         DCL     VAR(&PRE)  TYPE(*CHAR) LEN(2)
         DCL     VAR(&DLIB) TYPE(*CHAR) LEN(10)
         DCL     VAR(&DMLIB) TYPE(*CHAR) LEN(10)
/*       DCL     VAR(&DATA) TYPE(*CHAR) LEN(44)                    */ /*S01194*/
         DCL     VAR(&DATA) TYPE(*CHAR) LEN(50)                       /*S01194*/
         DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)                       /*S01189*/
         DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5)                         /*S01189*/
         DCL     VAR(&BUSY) TYPE(*CHAR) LEN(1)                        /*S01189*/
/**/
/**/
/*       DCL     VAR(&FTSTAT) TYPE(*CHAR) LEN(256)                 */ /*S01189*/
/**/
         DCL     VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1000INT                                          */
                                                                      /*S01408*/
/**/
/* Global error trap                                                          */
/**/
         MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                       CMDLBL(ABNORMAL))
/*/COPY WNCPYSRC,FTC1000010                                          */
/**/
         SNDPGMMSG MSG('FT1000 - Daily Reorganisation')      +
                       TOMSGQ(MRUNQ)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1000001                                          */
                                                                      /*S01408*/
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*           CHGVAR     VAR(&DLIB) VALUE(&PRE *TCAT 'DLIB')      */   /*E36108*/
             CHGVAR     VAR(&DLIB) VALUE(&PRE *TCAT 'DPLIB')          /*E36108*/
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
/**/
/*           ALCOBJ(OBJ((FTSTAT *DTAARA *EXCLRD))                  */ /*S01189*/
/*           RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&FTSTAT)             */ /*S01189*/
         CHGVAR    VAR(&BUSY) VALUE(' ')                              /*S01189*/
         CALL      CB0160 PARM(&CNAM &CSEQ &BUSY)                     /*S01189*/
/**/
/*       IF COND(%SUBSTRING(&FTSTAT 1 3) = 'OLD') THEN(DO)         */ /*S01189*/
         IF COND(&BUSY = 'N') THEN(DO)                                /*S01189*/
/**/
             DLTF       FILE(&DLIB/OTPAYDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/OTPAYXPDX)                                           /*BUG25207*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG25207*/
             DLTF       FILE(&DLIB/OTPAYZZX)
             MONMSG     MSGID(CPF2105)
/*/COPY WNCPYSRC,FTC1000007                                          */
             DLTF       FILE(&DLIB/INPAYDDX)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DLIB/INPAYXPDX)                                           /*BUG25207*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG25207*/
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
             DLTF       FILE(&DLIB/NTRANDQDX)                                           /*MD050391*/
             MONMSG     MSGID(CPF2105)                                                  /*MD050391*/
             DLTF       FILE(&DLIB/NTRANZZX)
             MONMSG     MSGID(CPF2105)
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
/*/COPY WNCPYSRC,FTC1000002                                          */
                                                                      /*S01408*/
             CPYF       FROMFILE(&DMLIB/OTPAYDD) +
                          TOFILE(&DLIB/OTPAYDDX) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DMLIB/OTPAYXPD) +
                          TOFILE(&DLIB/OTPAYXPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                 /*BUG25207*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG25207*/
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
                          CRTFILE(*YES)                                                 /*BUG25207*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG25207*/
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
             CPYF       FROMFILE(&DMLIB/NTRANDQD) +
                          TOFILE(&DLIB/NTRANDQDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                 /*MD050391*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*MD050391*/
/*                                                                   */
             CPYF       FROMFILE(&DMLIB/FT102DPD) +
                          TOFILE(&DLIB/FT102DPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(&DMLIB/FT102HPD) +
                          TOFILE(&DLIB/FT102HPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(&DMLIB/MEIRFTPD) +
                          TOFILE(&DLIB/MEIRFTPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(&DMLIB/FT101DPD) +
                          TOFILE(&DLIB/FT101DPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(&DMLIB/FT101HPD) +
                          TOFILE(&DLIB/FT101HPDX) MBROPT(*ADD) +
                          CRTFILE(*YES)                               /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
                                                                      /*CFT006*/
/*/COPY WNCPYSRC,FTC1000008                                          */
/**/
             ENDDO
/**/
/*       IF COND(%SUBSTRING(&FTSTAT 1 3) = 'NEW') THEN(DO)         */ /*S01189*/
         IF COND(&BUSY = 'Y') THEN(DO)                                /*S01189*/
/**/
             CPYF       FROMFILE(&DLIB/OTPAYDDX) +
                          TOFILE(&DMLIB/OTPAYDD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DLIB/OTPAYXPDX) +
                          TOFILE(&DMLIB/OTPAYXPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                                  /*BUG25207*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG25207*/
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
                          CRTFILE(*NO)                                                  /*BUG25207*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG25207*/
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
             CPYF       FROMFILE(&DLIB/NTRANDQDX) +
                          TOFILE(&DMLIB/NTRANDQD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                                  /*MD050391*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*MD050391*/
             CPYF       FROMFILE(&DLIB/FT102DPDX) +
                          TOFILE(&DMLIB/FT102DPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(&DLIB/FT102HPDX) +
                          TOFILE(&DMLIB/FT102HPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT008*/
             CPYF       FROMFILE(&DLIB/MEIRFTPDX) +
                          TOFILE(&DMLIB/MEIRFTPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(&DLIB/FT101DPDX) +
                          TOFILE(&DMLIB/FT101DPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
             CPYF       FROMFILE(&DLIB/FT101HPDX) +
                          TOFILE(&DMLIB/FT101HPD) MBROPT(*REPLACE) +
                          CRTFILE(*NO)                                /*CFT006*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CFT006*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FTC1000003                                          */
                                                                      /*S01408*/
/**/
             ENDDO
/**/
/*           CHGDTAARA  DTAARA(FTSTAT (1 3)) VALUE('NEW')          */ /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
         CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)                     /*S01189*/
/* */                                                                 /*042167*/
/* Call AOC8001 to remove all data areas in the DILIB */              /*042167*/
/* */                                                                 /*042167*/
/*/COPY WNCPYSRC,FTC1000005                                          */
             CALL       PGM(AOC8001)                                  /*042167*/
/*/COPY WNCPYSRC,FTC1000006                                          */
/* */                                                                 /*042167*/
             CHGJOB SWS(XXXXXX00)
             CALL PGM(FT1000)
/*/COPY WNCPYSRC,FTC1000011                                          */
/**/
/** .. CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)       */ /*S01194*/
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)          /*S01194*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO     ABNORMAL
             ENDDO
                                                                                        /*MD050391*/
             SCRUNSQL   SQL('Delete from NTRANDQD where not exists +
                    (Select * from NTRANDD where TFRF= NVTFRF)')                        /*MD050391*/
/**/
/** .. CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG MSG('FILE CONTROLS OUT OF BALANCE') +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO     ABNORMAL
             ENDDO
/*/COPY WNCPYSRC,FTC1000009                                          */
/**/
/*   Start of amendment 065746                          */
/**          RGZPFM     FILE(&DMLIB/OTPAYDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/**          RGZPFM     FILE(&DMLIB/INPAYDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/**          RGZPFM     FILE(&DMLIB/CQCODDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/**          RGZPFM     FILE(&DMLIB/CQCOCDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/**          RGZPFM     FILE(&DMLIB/CQPACDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/**          RGZPFM     FILE(&DMLIB/CQPADDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/**          RGZPFM     FILE(&DMLIB/NTRANDD)                         *065746*/
/**          MONMSG     MSGID(CPF2981)                               *065746*/
/*   End of amendment 065746                            */
/**/
/**          DLCOBJ OBJ((FTSTAT *DTAARA *EXCLRD))                  */ /*S01189*/
/**          CHGDTAARA  DTAARA(FTSTAT (1 3)) VALUE('OLD')          */ /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')
/*   Start of amendment 065746                          */
             DLTF       FILE(&DLIB/OTPAYDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/OTPAYXPDX)                                           /*BUG25207*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG25207*/
             DLTF       FILE(&DLIB/OTPAYZZX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/INPAYDDX)                         /*065746*/
             MONMSG     MSGID(CPF2105)                               /*065746*/
             DLTF       FILE(&DLIB/INPAYXPDX)                                           /*BUG25207*/
             MONMSG     MSGID(CPF2105)                                                  /*BUG25207*/
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
             DLTF       FILE(&DLIB/NTRANDQDX)                                           /*MD050391*/
             MONMSG     MSGID(CPF2105)                                                  /*MD050391*/
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
/*/COPY WNCPYSRC,FTC1000004                                          */
                                                                      /*S01408*/
/*   End of amendment 065746                            */
         CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)                     /*S01189*/
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
/*THEEND:ENDPGM                                                       /*S01117*/
THEEND:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
