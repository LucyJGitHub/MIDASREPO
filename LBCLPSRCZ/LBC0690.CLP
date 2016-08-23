/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Extract Pledges Regen.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0690 - Portfolio Lending Extract Interest                */
/*                 Accruals Regeneration                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 05MAY95              */
/*       PREV AMEND NO. S01498             DATE 11AUG94              */
/*                      064504             DATE 22DEC93              */
/*                      S01355             DATE 10JUL92              */
/*                      35723              DATE 20MAR92              */
/*                      B8754              DATE 21JUN91              */
/*-------------------------------------------------------------------*/
/*       S01408  -  Addition of core hook LBC0690MP1                 */
/*       S01498  -  Portfolio Lending Upgrade to Release 10.         */
/*       064504  -  SECURITY CPYF IN QTEMP CAUSING RESTART PROBLEMS  */
/*       S01355  -  RELEASE 3 INCORPORATION                          */
/*       35723   -  LB PROGRAM CANNOT BE RESTARTABLE                 */
/*       B8754   -  CLEAR WORK FILE CONTAINING MATURED LOANS         */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* >>> 064504 >>> */
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)                /*S01498*/
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)                /*S01498*/
/* <<< 064504 <<< */
 
/* RESET JOB SWITCHES                                                */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('LBC0690 - Lombard Interest Accruals +        */
/*                        Regeneration') TOMSGQ(MRUNQ) MSGTYPE(*INFO)     */
             SNDPGMMSG  MSG('LBC0690 - Portfolio Lending  +
                          Interest Accruals Regeneration') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* <<<<< S01355 <<<<< */
 
/* >>> 064504 >>> */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DLIB')        /*S01498*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DPLIB')       /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0690MP1                                          */
                                                                      /*S01408*/
/* <<< 064504 <<< */
 
/* CLEAR SECURITY COPY FILE, AND COPY IN DATA FROM LIVE FILE         */
/* >>> 064504 >>> */
/*******     DLTF       FILE(QTEMP/WWEXTRPD)                         */
             DLTF       FILE(&DLIB/WWEXTRPD)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF0000)
 
/* CREATE SECURITY COPY FILE                                         */
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(*LIBL/LBEXTRPD) +                   */
/*******                  TOFILE(QTEMP/WWEXTRPD) MBROPT(*ADD) +      */
/*******                  CRTFILE(*YES)                              */
             CPYF       FROMFILE(*LIBL/LBEXTRPD) +
                          TOFILE(&DLIB/WWEXTRPD) MBROPT(*ADD) +
                          CRTFILE(*YES)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(WWEXTRPD))
 
/* EXECUTE PROGRAM                                                   */
             CALL       PGM(*LIBL/LB0690)
 
/* ERROR DURING PROCESSING                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
/*>>35723>>*/
             CHGJOB     SWS(XXXXXX11)
/*<<35723<<*/
             SNDPGMMSG  MSG('LBC0690 - Ended abnormally') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0690 - Ended abnormally') +
                          TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
/* B8754 BEGIN */
/* IF NO ERROR CLEAR WORK FILE                                       */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CLRPFM     FILE(MATLBCR)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* B8754 END */
 
/* DATABASE IN ERROR DURING PROCESSING                               */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             SNDPGMMSG  MSG('LBC0690 - Database error') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0690 - Database error') TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE DURING PROCESSING                    */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('LBC0690 - File Controls out of Balance') +
                          TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0690 - File Controls out of Balance') +
                          TOMSGQ(MOPERQ)
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                   */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)    */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/*>>> 64504 >>>*/
             DLTF       FILE(&DLIB/WWEXTRPD)
             MONMSG     MSGID(CPF0000)
/*<<< 64504 <<<*/
                                                                      /*S01498*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01498*/
 
/***END:****    ENDPGM                                                /*S01498*/
