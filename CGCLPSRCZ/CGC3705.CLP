/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Initiate FTP Session')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3705  -  Initiate FTP Session                            */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. CSC053             Date 20Aug18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9463            DATE 01Dec05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015  *CREATE    DATE 06Mar02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC053 - FTP Secure Connections to SWIFT and Correspondence */
/*                Manager modules.                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG9463- Rename log spool file, send to CMOUTQ              */
/*       CCG015 - Correspondence Manager (Phase 1)                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&HSTPARM &RTNCODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
       DCL  VAR(&HSTPARM) TYPE(*CHAR) LEN(30)
       DCL  VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,CGH00014                                            */
                                                                                          /*CSC053*/
/**  Shared return code */                                                                /*CSC053*/
             DCL        VAR(&RTNCDE)   TYPE(*CHAR) LEN(7)                                 /*CSC053*/
                                                                                          /*CSC053*/
/**  Parameter for call to AOSARDR0 */                                                    /*CSC053*/
             DCL        VAR(&OPTN)     TYPE(*CHAR) LEN(7)                                 /*CSC053*/
             DCL        VAR(&SAR)      TYPE(*CHAR) LEN(6)                                 /*CSC053*/
             DCL        VAR(&SCSARD)   TYPE(*CHAR) LEN(200)                               /*CSC053*/
                                                                                          /*CSC053*/
/**  Parameter for call to AOSVALR0 */                                                    /*CSC053*/
             DCL        VAR(&SVAL1)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK2)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL2)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK3)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL3)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK4)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL4)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK5)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL5)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK6)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL6)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK7)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL7)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK8)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL8)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK9)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL9)    TYPE(*CHAR) LEN(200)                               /*CSC053*/
             DCL        VAR(&SVALK0)   TYPE(*CHAR) LEN(20)                                /*CSC053*/
             DCL        VAR(&SVAL10)   TYPE(*CHAR) LEN(200)                               /*CSC053*/
                                                                                          /*CSC053*/
/**  Result fields  */                                                                    /*CSC053*/
             DCL        VAR(&CSC053)   TYPE(*CHAR) LEN(1)                                 /*CSC053*/
             DCL        VAR(&FTPS)     TYPE(*CHAR) LEN(1)                                 /*CSC053*/
             DCL        VAR(&PORT)     TYPE(*CHAR) LEN(5)                                 /*CSC053*/
                                                                                          /*CSC053*/
/**/
/* Global Monitor Message */
/**/
       MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
       CHGJOB  SWS(XXXXX000)
/**/
/* Override FTP files */
/**/
             CLRPFM     FILE(QTEMP/CGFTPLPD)
 
             OVRDBF     FILE(INPUT) TOFILE(QTEMP/CGFTPCPD) +
                          MBR(CGFTPCPD) OVRSCOPE(*JOB)
 
             OVRDBF     FILE(OUTPUT) TOFILE(QTEMP/CGFTPLPD) +
                          MBR(CGFTPLPD) OVRSCOPE(*JOB)
 
/**/
/* Initiate FTP session */
/**/
/*/COPY WNCPYSRC,CGH00015                                            */
/**/                                                                                      /*CSC053*/
             CHGVAR     VAR(&SAR) VALUE('CSC053')                                         /*CSC053*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC053*/
             CHGVAR     VAR(&CSC053) VALUE('N')                                           /*CSC053*/
                                                                                          /*CSC053*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC053*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC053*/
                        CHGVAR     VAR(&CSC053) VALUE('Y')                                /*CSC053*/
                                                                                          /*CSC053*/
/** Get 'UseFTPSecureCorrMgr' system value from file SDSVALPD */                          /*CSC053*/
                                                                                          /*CSC053*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                           'UseFTPSecureCorrMgr' &SVAL1 &SVALK2 +
                            &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                            &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                            &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                            &SVALK0 &SVAL10)                                              /*CSC053*/
                                                                                          /*CSC053*/
/** If the 'UseFTPSecureCorrMgr' system value is missing then end abnormally */           /*CSC053*/
                                                                                          /*CSC053*/
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNORMAL))                                         /*CSC053*/
                   ELSE       CMD(DO)                                                     /*CSC053*/
                              CHGVAR     VAR(&FTPS) VALUE(%SST(&SVAL1 1 1))               /*CSC053*/
                   ENDDO                                                                  /*CSC053*/
             ENDDO                                                                        /*CSC053*/
                                                                                          /*CSC053*/
/** Use secure sockets layer for FTP if feature CSC053 switched ON */                     /*CSC053*/
/** and system value UseFTPSecureCorrMgr is set to 'Y' */                                 /*CSC053*/
                                                                                          /*CSC053*/
             IF         COND(&CSC053 *EQ 'Y' *AND &FTPS *EQ 'Y') THEN(DO)                 /*CSC053*/
                                                                                          /*CSC053*/
/** Retrieve the configured secure port number */                                         /*CSC053*/
                                                                                          /*CSC053*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                           'FTPSecurePortNumber' &SVAL1 &SVALK2 +
                            &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                            &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                            &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                            &SVALK0 &SVAL10)                                              /*CSC053*/
                                                                                          /*CSC053*/
/** If the 'FTPSecurePortNumber' system value is missing then end abnormally */           /*CSC053*/
                                                                                          /*CSC053*/
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNORMAL))                                         /*CSC053*/
                   ELSE       CMD(DO)                                                     /*CSC053*/
                              CHGVAR     VAR(&PORT) VALUE(%SST(&SVAL1 1 5))               /*CSC053*/
                   ENDDO                                                                  /*CSC053*/
                                                                                          /*CSC053*/
/** Execute the secure FTP operation */                                                   /*CSC053*/
                                                                                          /*CSC053*/
             FTP        RMTSYS(&HSTPARM) SECCNN(*SSL) PORT(&PORT)                         /*CSC053*/
             ENDDO                                                                        /*CSC053*/
             ELSE       CMD(DO)                                                           /*CSC053*/
             FTP        RMTSYS(&HSTPARM)
             ENDDO                                                                        /*CSC053*/
                                                                                          /*CSC053*/
/*/COPY WNCPYSRC,CGH00016                                            */
/**/
/* Delete overrides  */
/**/
             DLTOVR     FILE(INPUT) LVL(*JOB)
             DLTOVR     FILE(OUTPUT) LVL(*JOB)
 
             OVRPRTF    FILE(QSYSPRT) OUTQ(*LIBL/CMOUTQ) +
                          SPLFNAME(CMFTPLOG)                                /*BUG9463*/
             CPYF       FROMFILE(QTEMP/CGFTPLPD) TOFILE(*PRINT)
             DLTOVR     FILE(QSYSPRT)                                       /*BUG9463*/
 
       GOTO  CMDLBL(END)
/**/
/* Abnormal termination processing */
/**/
ABNORMAL:
 
             CHGVAR     VAR(&RTNCODE) VALUE('*ERROR    ')
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC3705 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
