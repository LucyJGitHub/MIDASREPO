/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Extrct Summary/Parents')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0701 - Portfolio Lending Extract Summary Creation        */
/*                               Parents                             */
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
/*       Prev Amend No. S01408             Date 05May95              */
/*                      081333             Date 14Dec94              */
/*                      S01498             DATE 11AUG94              */
/*                      064504     KB      DATE 22DEC93              */
/*                      S01189     GB      DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      35723              DATE 20MAR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook LBC0701MP1                   */
/*       081333 - Temporary Library should be xxDPLIB.               */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*       064504 - SECURITY CPYF IN QTEMP CAUSING RESTART PROBLEMS    */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01355 - RELEASE 3 INCORPORATION                            */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
/*>>S01189>>*/
/**********  PGM                                                    **/
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
 
/* >>> 064504 >>> */
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)  *******/    /*081333*/
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)              /*081333*/
/* <<< 064504 <<< */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* RESET JOB SWITCHES                                                */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('LBC0701 - Lombard Summary Regeneration - +   */
/*                        Parents') TOMSGQ(MRUNQ) MSGTYPE(*INFO)          */
             SNDPGMMSG  MSG('LBC0701 - Portfolio Lending Summary +
                          Regeneration - Parents') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* <<<<< S01355 <<<<< */
 
/* >>> 064504 >>> */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DLIB')****/    /*081333*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DPLIB')        /*081333*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0701MP1                                          */
                                                                      /*S01408*/
/* <<< 064504 <<< */
 
/* CLEAR SECURITY COPY FILE, AND COPY IN DATA FROM LIVE FILE         */
/* >>> 064504 >>> */
/*******     DLTF       FILE(QTEMP/WWEXTSPD)                         */
             DLTF       FILE(&DLIB/WWEXTSPD)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF0000)
 
/* CREATE SECURITY COPY FILE                                         */
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(*LIBL/LBEXTSPD) +                   */
/*******                  TOFILE(QTEMP/WWEXTSPD) MBROPT(*ADD) +      */
/*******                  CRTFILE(*YES)                              */
             CPYF       FROMFILE(*LIBL/LBEXTSPD) +
                          TOFILE(&DLIB/WWEXTSPD) MBROPT(*ADD) +
                          CRTFILE(*YES)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(WWEXTSPD))
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE(' ')
                   CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* EXECUTE PROGRAM                                                   */
             CALL       PGM(*LIBL/LB0701)
 
/* ERROR DURING PROCESSING                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
/*>>35723>>*/
             CHGJOB     SWS(XXXXXX11)
/*<<35723<<*/
             SNDPGMMSG  MSG('LBC0701 - Ended abnormally') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0701 - Ended abnormally') +
                          TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTSPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTSPD) +
                          TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* DATABASE IN ERROR DURING PROCESSING                               */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             SNDPGMMSG  MSG('LBC0701 - Database error') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0701 - Database error') TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTSPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTSPD) +
                          TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE DURING PROCESSING                    */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('LBC0701 - File Controls out of Balance') +
                          TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0701 - File Controls out of Balance') +
                          TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTSPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTSPD) +
                          TOFILE(*LIBL/LBEXTSPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/*>>> 64504 >>>*/
             DLTF       FILE(&DLIB/WWEXTSPD)
             MONMSG     MSGID(CPF0000)
/*<<< 64504 <<<*/
 
/*END:********ENDPGM                                               */ /*S01498*/
 ENDPGM:                                                              /*S01498*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01498*/
