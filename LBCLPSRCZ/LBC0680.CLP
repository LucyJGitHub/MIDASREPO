/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LB Extract Pledges Regeneration.')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0680 - Portfolio Lending Extract                         */
/*                  (Pledges Regeneration)                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01408             DATE 05MAY95              */
/*                      S01498             DATE 11AUG94              */
/*                      064504             DATE 22DEC93              */
/*                      S01189             DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      35723              DATE 20MAR92              */
/*                      33955              DATE 07JAN92              */
/*                      B5955              DATE 07MAY91              */
/*                      R05777             DATE 02APR91              */
/*                      R0987              DATE 28NOV90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408  -  Addition of core hook LBC0680MP1                 */
/*       S01498  -  Portfolio Lending Upgrade to Release 10.         */
/*       064504  -  SECURITY CPYF IN QTEMP CAUSING RESTART PROBLEMS  */
/*       S01189  -  COB RECOVERY PROCESSING                          */
/*       S01355  -  RELEASE 3 INCORPORATION                          */
/*       35723   -  LB PROGRAM CANNOT BE RESTARTABLE                 */
/*       33955   -  FILE LBPLEGL9 REPLACE BY LBPLEGL0 IN LB0680      */
/*       B5955   -  File "LBEXCOPD" Never cleared during update      */
/*       R05777  -  REMOVE CALL TO PM0681                            */
/*       R0987   -  Add call to PM0681 - Update Portfolio Holdings   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*>>S01189>>*/
/**********  PGM                                                    **/
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
 
/* >>> 064504 >>> */
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)                 /*S01498*/
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)                 /*S01498*/
/* <<< 064504 <<< */
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2) VALUE('  ')
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)
/* RESET JOB SWITCHES                                                */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('LBC0680 - Lombard Pledges Regeneration') +   */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                    */
 
             SNDPGMMSG  MSG('LBC0680 - Portfolio Lending Pledges +
                          Regeneration') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* <<<<< S01355 <<<<< */
 
/* >>> 064504 >>> */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DLIB')         /*S01498*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DPLIB')        /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0680MP1                                          */
                                                                      /*S01408*/
/* <<< 064504 <<< */
 
/* CLEAR SECURITY COPY FILES                                         */
 
/* >>> 064504 >>> */
/*******     DLTF       FILE(QTEMP/WWEXTRPD)                         */
             DLTF       FILE(&DLIB/WWEXTRPD)
             MONMSG     MSGID(CPF0000)
/*******     DLTF       FILE(QTEMP/WWEXTSPD)                         */
             DLTF       FILE(&DLIB/WWEXTSPD)
             MONMSG     MSGID(CPF0000)
/*******     DLTF       FILE(QTEMP/WWPLEGPD)                         */
             DLTF       FILE(&DLIB/WWPLEGPD)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF0000)
 
/* CREATE SECURITY COPY FILES                                        */
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(*LIBL/LBEXTRPD) +                    */
/*******                  TOFILE(QTEMP/WWEXTRPD) MBROPT(*ADD) +       */
/*******                  CRTFILE(*YES)                               */
             CPYF       FROMFILE(*LIBL/LBEXTRPD) +
                          TOFILE(&DLIB/WWEXTRPD) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(WWEXTRPD))
/*******     CPYF       FROMFILE(*LIBL/LBEXTSPD) +                    */
/*******                  TOFILE(QTEMP/WWEXTSPD) MBROPT(*ADD) +       */
/*******                  CRTFILE(*YES)                               */
             CPYF       FROMFILE(*LIBL/LBEXTSPD) +
                          TOFILE(&DLIB/WWEXTSPD) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(WWEXTSPD))
/*******     CPYF       FROMFILE(*LIBL/LBPLEGPD) +                    */
/*******                  TOFILE(QTEMP/WWPLEGPD) MBROPT(*ADD) +       */
/*******                  CRTFILE(*YES)                               */
             CPYF       FROMFILE(*LIBL/LBPLEGPD) +
                          TOFILE(&DLIB/WWPLEGPD) MBROPT(*ADD) +
                          CRTFILE(*YES)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(WWPLEGPD))
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(*LIBL/LBEXCOPD) +                    */
/*******                  TOFILE(QTEMP/XLBEXCOPD) MBROPT(*REPLACE) +  */
/*******                  CRTFILE(*YES)     */                        /*B5955*/
             CPYF       FROMFILE(*LIBL/LBEXCOPD) +
                          TOFILE(&DLIB/XLBEXCOPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
/* <<< 064504 <<< */
MONMSG CPF2817 CMPDTA(CPF2869) EXEC(CLRPFM XLBEXCOPD)                 /*B5955*/
 
/* >>>>> 33955 >>>>> */
             OVRDBF     FILE(LBPLEGL9) TOFILE(LBPLEGL0)
/* <<<<< 33955 <<<<< */
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE(' ')
                   CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/* EXECUTE PROGRAM                                                   */
             CALL       PGM(*LIBL/LB0680)
 
/* ERROR DURING PROCESSING                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
/*>>35723>>*/
             CHGJOB     SWS(XXXXXX11)
/*<<35723<<*/
             SNDPGMMSG  MSG('LBC0680 - Ended abnormally') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0680 - Ended abnormally') +
                          TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*******     CPYF       FROMFILE(QTEMP/WWEXTSPD) +                    */
/*******                  TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWEXTSPD) +
                          TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*******     CPYF       FROMFILE(QTEMP/WWPLEGPD) +                    */
/*******                  TOFILE(*LIBL/LBPLEGPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWPLEGPD) +
                          TOFILE(*LIBL/LBPLEGPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/XLBEXCOPD) +                */
/*******                  TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)  */ /*B5955*/
             CPYF       FROMFILE(&DLIB/XLBEXCOPD) +
                          TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
 
             MONMSG CPF2817 CMPDTA(CPF2869)                           /*B5955*/
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
/* >>>>> 33955 >>>>> */
             DLTOVR     FILE(LBPLEGL9)
/* <<<<< 33955 <<<<< */
 
/* DATABASE IN ERROR DURING PROCESSING                               */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             SNDPGMMSG  MSG('LBC0680 - Database error') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0680 - Database error') TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*******     CPYF       FROMFILE(QTEMP/WWEXTSPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWEXTSPD) +
                          TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*******     CPYF       FROMFILE(QTEMP/WWPLEGPD) +                    */
/*******                  TOFILE(*LIBL/LBPLEGPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWPLEGPD) +
                          TOFILE(*LIBL/LBPLEGPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/XLBEXCOPD) +               */
/*******                  TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE) */  /*B5955*/
             CPYF       FROMFILE(&DLIB/XLBEXCOPD) +
                          TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
 
             MONMSG CPF2817 CMPDTA(CPF2869)                           /*B5955*/
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE DURING PROCESSING                    */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('LBC0680 - File Controls out of Balance') +
                          TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0680 - File Controls out of Balance') +
                          TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*******     CPYF       FROMFILE(QTEMP/WWEXTSPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTSPD) +
                          TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*******     CPYF       FROMFILE(QTEMP/WWPLEGPD) +                    */
/*******                  TOFILE(*LIBL/LBPLEGPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWPLEGPD) +
                          TOFILE(*LIBL/LBPLEGPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/XLBEXCOPD) +                */
/*******                  TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)  */ /*B5955*/
             CPYF       FROMFILE(&DLIB/XLBEXCOPD) +
                          TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
 
             MONMSG CPF2817 CMPDTA(CPF2869)                           /*B5955*/
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* UPDATE PLEDGES VALUES IN PORTFOLIO HOLDINGS                   R05777R0987  */
/*           CALL       PGM(*LIBL/PM0681)                        R05777R0987  */
/*                                                               R05777R0987  */
/* ERROR DURING PROCESSING                                       R05777R0987  */
/*           MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)  R05777R0987  */
/*           SNDPGMMSG  MSG('LBC0680 - Ended abnormally') +           R05777  */
/*                        TOMSGQ(MRUNQ)                          R05777R0987  */
/*           SNDPGMMSG  MSG('LBC0680 - Ended abnormally') +           R05777  */
/*                        TOMSGQ(MOPERQ)                         R05777R0987  */
/*           ENDDO                                               R05777R0987  */
/*                                                               R05777R0987  */
/* DATABASE IN ERROR DURING PROCESSING                           R05777R0987  */
/*           IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)         R05777R0987  */
/*           SNDPGMMSG  MSG('LBC0680 - Database error') +             R05777  */
/*                        TOMSGQ(MRUNQ)                          R05777R0987  */
/*           SNDPGMMSG  MSG('LBC0680 - Database error') +             R05777  */
/*                        TOMSGQ(MOPERQ)                         R05777R0987  */
/*           ENDDO                                               R05777R0987  */
 
/*>>> 64504 >>>*/
             DLTF       FILE(&DLIB/WWEXTRPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DLIB/WWEXTSPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DLIB/WWPLEGPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DLIB/XLBEXCOPD)
             MONMSG     MSGID(CPF0000)
/*<<< 64504 <<<*/
                                                                      /*S01498*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01498*/
 
/***END:****    ENDPGM                                                /*S01498*/
