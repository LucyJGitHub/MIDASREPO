/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting I.C.D. report')              */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC9105  - EUROPEAN REPORTING I.C.D. REPORT                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 132893             Date 16Apr98             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       132893 - SPF/RCF for IBLC/BNB on DBA2.3                    */
/*                                                                  */
/*********************************************************************/
/**/
             PGM
                                                                      /*132893*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*132893*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE(' ') +
                          /*132893*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('   ') +
                          /*132893*/
             DCL        VAR(&ERXX95) TYPE(*CHAR) LEN(6)
             DCL        VAR(&XX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(80)
 
             DCLF       FILE(ERICDRL1)
             MONMSG     MSGID(CPF0864) EXEC(GOTO +
                          CMDLBL(FILEND))
 
/* Reset External Switches */
             CHGJOB     SWS(00000000)
 
 
/* Call ER ICD report program */
/********    CALL       PGM(ER9105)                                     132893*/
             CALL       PGM(ER9105) PARM(&RSEQ &RLEV)                 /*132893*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('JOB ER9105 TERMINATED - +
                          DATABASE ERROR')
             GOTO       ABNORMAL
             ENDDO
 
 READ:       RCVF
 
/*  If european reporting not selected (User country code blank) do not  */
/*  call I.C.D. reporting                                                */
 
             IF         COND(&VDUCCD *NE '  ') THEN(DO)
 
             CHGVAR     VAR(&XX) VALUE(&VDICCD)
             CHGVAR     VAR(&ERXX95) VALUE('ER' *cat &XX *cat '95')
 
/* Call ER Country ICD report program */
/******      CALL       PGM(&ERXX95)                                    132893*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*132893*/
             CALL       PGM(&ERXX95) PARM(&RSEQ &RLEV)                /*132893*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('JOB' *BCAT &ERXX95 *BCAT +
                          'TERMINATED - DATABASE ERROR')
             GOTO       ABNORMAL
             ENDDO
 
             ENDDO
 
             GOTO       CMDLBL(READ)
 
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDMSG     MSG(&MSG) +
                        TOMSGQ(MOPERQ MRUNQ)
 
FILEND:      ENDPGM
