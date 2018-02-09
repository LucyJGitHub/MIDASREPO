/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Input cycle confirmation reprint')           */
/*********************************************************************/
/*                                                                   */
/*  Midas - Securities Trading Module                                */
/*                                                                   */
/*  SEC0309 - INPUT CYCLE TRADE CONFIRMATION REPRINT                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE006             Date 27Jul99             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      095130             DATE 26OCT95              */
/*                      086141             DATE 02MAR95              */
/*                      081938             DATE 30JAN95              */
/*                      S01522             DATE 12JAN95              */
/*                      S01502             DATE 08JUL94              */
/*                      S01401             DATE 16JUN93              */
/*                      S01117             DATE 15AUG91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  205448 - UDC module must be on for Correspondence Manager        */
/*  CCG015 - Correspondence Manager Phase 1                          */
/*  CSE006 - Repurchase agreement (Repo) enhancement.  New program   */
/*           SE4110 (Buy-Sell Backs Confirmation Print) called.      */
/*  CPK009 - Packaging for DBA3 release. STRCMTCTL values set        */
/*                to CMTSCOPE(*JOB).                                 */
/*  095130 - Only call CGC5217 if UDC switched on.                   */
/*  086141 - Set up CGUSRMSG override                                */
/*  081938 - Reclaim resources after CG4200                          */
/*  S01522 - USER DEFINED CORRESPONDENCE                             */
/*  S01502 - BLI Telekurs Processing.  Recompiled due to             */
/*           change in length of SESTAT, 133 long.                   */
/*  S01401 - SE0550 opens new file TRADSDY1 under COMIT and so must  */
/*           run under commitment control.                           */
/*  S01117 - New program created for (multibranching) RCF changes    */
/*                                                                   */
/*********************************************************************/
/* */
             PGM        PARM(&RSEQ &RLEV &RENT)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/* */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/           /*S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(70)               /*S01522*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&FMT)   TYPE(*CHAR) LEN(200)              /*S01522*/
             DCL        VAR(&UDC)   TYPE(*CHAR) LEN(1)                /*S01522*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*086141*/
             DCL        VAR(&CSE006) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CSE006*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
/* */
/** Global MONMSG to trap errors                                   */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
             CHGVAR     VAR(&MSG) VALUE('SEC0309 - Processing error') /*S01522*/
             CHGVAR     VAR(&CGUSRMSG) VALUE('GB'  *CAT 'CGUSRMSG  ') /*086141*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*086141*/
/**/                                                                  /*S01401*/
/** Start Commitment Control                                       */ /*S01401*/
/**/                                                                  /*S01401*/
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      /*S01401 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/* */
             CHGJOB     SWS(00000000)
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&PRTCD '*FIRST ' &FMT)     /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&PRTCD *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('SEC0309 - Error on access to +
                          SDMMODPD')                                  /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/***  Access Switchable Features file to see if CSE006 is present **/ /*CSE006*/
                                                                      /*CSE006*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSE006')          /*CSE006*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSE006) VALUE('Y'))        /*CSE006*/
/**/                                                                  /*CSE006*/
/* */                                                                 /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
             CHGVAR (&UDC) VALUE('Y')                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/* */
/*********** OVRDBF     FILE(TRDCONF) TOFILE(TRDCFR)               */ /*S01522*/
                                                                                          /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                                       /*205448*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
                                                                      /*S01522*/
             OVRDBF     FILE(TRDCONF) TOFILE(TRDCFR) SHARE(*NO)       /*S01522*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                   /*S01522*/
             CALL       PGM(CG4200) PARM(&W0RTN &W0CMT)               /*S01522*/
             RCLRSC                                                   /*081938*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('CG4200 - User Defined +
                          Correspondence Extract failure')            /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
             OVRDBF     FILE(TRDCONF) TOFILE(TRDCONFS) SHARE(*NO)     /*CSE006*/
/************ENDDO                                                    /S01522/*205448*/
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                                 /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
             GOTO       CMDLBL(ERROR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
             ENDDO                                                                        /*205448*/
                                                                      /*S01522*/
/*/COPY WNCPYSRC,SEC0309001                                          */
/* */
             CALL       PGM(SE0550) PARM(&RSEQ &RENT)
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('SE0550 - I/C Trade +
                          Confirmations Reprint failed')              /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*081938*/
/* */                                                                 /*CSE006*/
             IF (&CSE006 *EQ 'Y') THEN(DO)                            /*CSE006*/
               CHGVAR (&RSEQ) VALUE('     ')                          /*CSE006*/
             CALL       PGM(SE4110) PARM(&RSEQ &RENT)                 /*CSE006*/
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*CSE006*/
             CHGVAR     VAR(&MSG) VALUE('SE0550 - I/C Buy-Sell Backs +
                          Confirmations Reprint failed')              /*CSE006*/
             GOTO       CMDLBL(ERROR)                                 /*CSE006*/
             ENDDO                                                    /*CSE006*/
             ENDDO                                                    /*CSE006*/
                                                                      /*CSE006*/
/* Prompt for immediate print */                                      /*081938*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                   /*095130*/
             CALL       PGM(CGC5217) PARM(' ')                        /*081938*/
             MONMSG     MSGID(CPF0000)                                /*081938*/
             ENDDO                                                    /*095130*/
                                                                      /*081938*/
/* */                                                                 /*S01522*/
             GOTO       CMDLBL(NORMAL)                                /*S01522*/
/* */
/***Allocate*SESTAT, indicate confirmation print is finished       */ /*S01522*/
/***and*then*deallocate.                                           */ /*S01522*/
/************                                                      */ /*S01522*/
/************ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))              */ /*S01522*/
/************RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)             */ /*S01522*/
/************CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('N')   */ /*S01522*/
/************CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)              */ /*S01522*/
/************DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))              */ /*S01522*/
/************                                                      */ /*S01522*/
/************GOTO       CMDLBL(ENDPGM)                             */ /*S01522*/
/* */
ERROR:
/* */
/** Error processing                                               */
/* */
/** Abnormal termination message - Database error                  */
/* */
             CHGJOB     SWS(XXXXXXX1)                                 /*S01522*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(&UDC *EQ 'Y') THEN(DO)                                       /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
             ROLLBACK                                                 /*S01522*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
/************SNDPGMMSG  MSG('(SE0550) - Database Error') +
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        */ /*S01522*/
             ENDDO
             SNDPGMMSG MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)    /*S01522*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
/* */
/** Allocate SESTAT, indicate confirmation print is finished       */
/** and then deallocate.                                           */
/* */
NORMAL:                                                               /*S01522*/
 
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('N')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01522*/
/* */
/************GOTO       CMDLBL(ENDPGM)                             */ /*S01522*/
/* */
/*ENDPGM:*** CHGVAR VAR(&BISCPY) VALUE('COPYRIGHT MKI') ********/     /*S01401*/
ENDPGM:                                                               /*S01401*/
/************ENDCMTCTL                                      *S01401*/ /*S01522*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */                                                                 /*S01401*/
             ENDPGM
