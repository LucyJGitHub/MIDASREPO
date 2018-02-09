/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Spot Trade Hist. A/c Postings GEN.')            */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC5342 - Spot Trade Historic A/c Postings Generation      */
/*                                                                  */
/*       (c) Finastra International Limited 2005                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CAP204             Date 03Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      132893             Date 21Apr98              */
/*                      FS0001             Date 14Sep95              */
/*                     ER_R10            DATE  08AUG95              */
/*                     ER0307 TLI        DATE  25JAN93              */
/*                     ER0300 TLI        DATE  18JAN93              */
/*                     ER0145 ADs        DATE  08JAN93              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP204  - Retail Account Transfer                           */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*  132893 - RCF DBA2.3                                             */
/*  FS0001 - WRONG LIBRARY USED                                     */
/*  ER-R10 - UPGRADE IML TO RELEASE 10                              */
/*  ER0307 - MODIFIED PROCESSING FOR CPYF ERROR                     */
/*  ER0300 - CHANGE PLACE FOR REVALUATION IN CLOSE OF BUSINESS      */
/*  ER0145 - Call a new program to reset P&L account of new Spot    */
/*           Historic Revaluation                                   */
/*                                                                  */
/********************************************************************/
             PGM
 
/* >>>> 132893 >>>> */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
/* >>>> 132893 >>>> */
 
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&SPTA) TYPE(*CHAR) LEN(4)               /* ER0300 */
/*********** DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)      /* ER0300   FS0001 */
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)              /* FS0001 */
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)           /* ER0300 */
 
/**********  DCLF       FILE(SDDEALX4) RCDFMT(SDDEALF4)                      /* ER0300 */ /*CER001*/
             DCLF       FILE(SDDLX1PD) RCDFMT(SDDEALF4)                                   /*CER001*/
 
             CHGJOB     SWS(00000000)
 
             SNDMSG     MSG('ERC5342 - Spot Trade Historic Account +
                          Postings Generation') TOMSGQ(MRUNQ)
 
             CLRPFM     FILE(GESTHEPD)
             CLRPFM     FILE(GESTHEZZ)
 
/**Take*a*security*copy*of*PF/EODPO2PD************************ER0300**/                   /*CER001*/
/* Take a security copy of PF/GLPSX1PD                               */                   /*CER001*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*ER0300*/
/* CHGVAR   VAR(&DLIB) VALUE(%SST(&SDSTAT 6 2) *CAT 'DLIB')   /*ER0300  FS0001*/
            CHGVAR   VAR(&DLIB) VALUE(%SST(&SDSTAT 6 2) *CAT 'DPLIB') /*FS0001*/
/**********  CPYF       FROMFILE(EODPO2PD) TOFILE(&DLIB/XEODPO2PD) +
                          CRTFILE(*YES)                                      /* ER0300 */ /*CER001*/
             CPYF       FROMFILE(GLPSX1PD) TOFILE(&DLIB/XGLPSX1PD) +
                          CRTFILE(*YES)                                                   /*CER001*/
             MONMSG     MSGID(CPF2817)                     /* ER0300 */
 
/* Call CLP/ERCSPTA to retrieve value of BLSPTA               ER0300 */
             CALL       PGM(ERC5342A) PARM(&SPTA)          /* ER0300 */
 
/**Copy*postings*in*file*EODPO2PD*for*Revaluation*********************/                   /*CER001*/
/* Copy postings in file GLPSX1PD for Revaluation                    */                   /*CER001*/
             RCVF       RCDFMT(SDDEALF4)                   /* ER0300 */
 
/**********  CPYF       FROMFILE(ACPO1) TOFILE(EODPO2PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                     /* ER0300 */ /*CER001*/
             CPYF       FROMFILE(ACPO1) TOFILE(GLPSX1PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CER001*/
/************MONMSG     MSGID(CPF2817)            ER0300      ER0307 */
/* ER0307 */
             MONMSG     MSGID(CPF2817) EXEC(CHGJOB SWS(00000011))
                                                                                          /*CAP204*/
/* Include additional posting details from GLACPOL0 */                                    /*CAP204*/
                                                                                          /*CAP204*/
             CPYF       FROMFILE(GLACPOL0) TOFILE(GLPSX1PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CAP204*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CAP204*/
                                                                                          /*CAP204*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(BKUP))
/* ER0307 */
 
/**********  CPYF       FROMFILE(ACPO2) TOFILE(EODPO2PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                     /* ER0300 */ /*CER001*/
             CPYF       FROMFILE(ACPO2) TOFILE(GLPSX1PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CER001*/
/************MONMSG     MSGID(CPF2817)            ER0300      ER0307 */
/* ER0307 */
             MONMSG     MSGID(CPF2817) EXEC(CHGJOB SWS(00000011))
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(BKUP))
/* ER0307 */
 
/**********  CPYF       FROMFILE(ACPO3) TOFILE(EODPO2PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                     /* ER0300 */ /*CER001*/
             CPYF       FROMFILE(ACPO3) TOFILE(GLPSX1PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CER001*/
/************MONMSG     MSGID(CPF2817)            ER0300      ER0307 */
/* ER0307 */
             MONMSG     MSGID(CPF2817) EXEC(CHGJOB SWS(00000011))
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(BKUP))
/* ER0307 */
 
/**********  CPYF       FROMFILE(ACPO4) TOFILE(EODPO2PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                     /* ER0300 */ /*CER001*/
             CPYF       FROMFILE(ACPO4) TOFILE(GLPSX1PD) MBROPT(*ADD) +
                          RCDFMT(APOSTPDF) INCREL((*IF ACOD *EQ +
                          &WAIFTA) (*OR ACOD *EQ &SPTA))                                  /*CER001*/
/************MONMSG     MSGID(CPF2817)            ER0300      ER0307 */
/* ER0307 */
             MONMSG     MSGID(CPF2817) EXEC(CHGJOB SWS(00000011))
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(BKUP))
/* ER0307 */
 
/* Call Spot Trade Historic Account Posting Generation program       */
 
             CALL       PGM(ER5342)
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/************   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                ER_R10*/
/************   SNDPGMMSG  MSGID(DBM0001) MSGF(ERUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                  */              /*CER001*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(STUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                  /*CER001*/
                CHGVAR VAR(&MEM) VALUE('ERC5342 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* Call Spot Trade Historic Equiv. Account Posting Generation program*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                CALL       PGM(ER5343)
 
                IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/******************  SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)      ER_R10*/
/******************  SNDPGMMSG  MSGID(DBM0001) MSGF(ERUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)        */              /*CER001*/
                     SNDPGMMSG  MSGID(DBM0001) MSGF(STUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)                        /*CER001*/
                    CHGVAR VAR(&MEM) VALUE('ERC5343 - JOB TERMINATED, +
                                          DATABASE IN ERROR')
                  SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                ENDDO
 
             ENDDO
 
/* ER0145 Begin */
/* Call Spot Trade Historic Revaluation - Reset P & L accounts       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* >>>> 132893 >>>> */
 
/******         CALL       PGM(ER5348A)                                 *******/
             CALL       PGM(ER5348A) PARM(&RSEQ &RLEV)
 
/* >>>> 132893 >>>> */
 
                IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/******************* SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)      ER_R10*/
/******************* SNDPGMMSG  MSGID(DBM0001) MSGF(ERUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)        */              /*CER001*/
                     SNDPGMMSG  MSGID(DBM0001) MSGF(STUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)                        /*CER001*/
                    CHGVAR VAR(&MEM) VALUE('ERC5342 - JOB TERMINATED, +
                                          DATABASE IN ERROR')
                  SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                ENDDO
 
             ENDDO
/* ER0145 End   */
 
/**Clear*file*EODPO2PD**/                                                    /* ER0300 */ /*CER001*/
/* Clear file GLPSX1PD */                                                                 /*CER001*/
 BKUP:                                                            /* ER0307 */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)          /* ER0300 */
/**********  CLRPFM     FILE(EODPO2PD)                                       /* ER0300 */ /*CER001*/
/**********  DLTF       FILE(&DLIB/XEODPO2PD)                                /* ER0300 */ /*CER001*/
             CLRPFM     FILE(GLPSX1PD)                                                    /*CER001*/
             DLTF       FILE(&DLIB/XGLPSX1PD)                                             /*CER001*/
             ENDDO                                                /* ER0300 */
             ELSE       CMD(DO)                                   /* ER0300 */
/**********  CPYF       FROMFILE(&DLIB/XEODPO2PD) TOFILE(EODPO2PD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                      /* ER0300 */ /*CER001*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM EODPO2PD)                                /* ER0300 */ /*CER001*/
/**********  DLTF       FILE(&DLIB/XEODPO2PD)                                /* ER0300 */ /*CER001*/
             CPYF       FROMFILE(&DLIB/XGLPSX1PD) TOFILE(GLPSX1PD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM GLPSX1PD)                                             /*CER001*/
             DLTF       FILE(&DLIB/XGLPSX1PD)                                             /*CER001*/
             ENDDO                                                /* ER0300 */
 
             ENDPGM
