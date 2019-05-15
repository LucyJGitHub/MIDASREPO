/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG U.D.C. Extract UDC Data')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2050  - U.D.C. Extract UDC Data                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG22564A          Date 13Feb09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      086128             DATE 01MAR95              */
/*                      079860             DATE 07DEC94              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22564A- Component CGC2050 00023 failed.                  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       086128 - Add recovery processing                            */
/*       079860 - STRCMTCTL should be *CHG                           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&COMP_NAME &COMP_SEQ &EXT_COMP &EXTRACT +
                          &COMMIT_OPT &RECOVERY)                      /*086128*/
/*                        &COMMIT_OPT)                                 *086128*/
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&EXT_COMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXTRACT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RECOVERY) TYPE(*CHAR) LEN(10)            /*086128*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                            /*BUG22564A*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')           /*BUG22564A*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2050 - U.D.C. Extract Data for ' +
                          *CAT &EXTRACT) TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Start Commitment Control */
/* */
/************STRCMTCTL  LCKLVL(*ALL)                                    *79860*/
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))       /*79860CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)
/* */                                                                             /*BUG22564A*/
/* Setup system prefix variable from SDSTAT data area. */                         /*BUG22564A*/
                                                                                  /*BUG22564A*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                       /*BUG22564A*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                 /*BUG22564A*/
                                                                                  /*BUG22564A*/
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If status is active - Perform recovery */
/* */
             IF         COND(&STATUS *NE 'N') THEN(DO)
/* */                                                                 /*086128*/
/* Call recovery processing */                                        /*086128*/
/* */                                                                 /*086128*/
             IF         COND(&RECOVERY *NE '*NONE     ') THEN(DO)     /*086128*/
             CALL       PGM(&RECOVERY) PARM('*Recovery ' &COMMIT_OPT) /*086128*/
             ENDDO                                                    /*086128*/
             ELSE       CMD(DO)                                                   /*BUG22564A*/
             IF         COND(&EXT_COMP *EQ 'CGC7410   ') THEN(DO)                 /*BUG22564A*/
               CPYF       FROMFILE(XSDINPHPD) TOFILE(SDINPHPD) +
                          MBROPT(*REPLACE)                                        /*BUG22564A*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*BUG22564A*/
             ENDDO                                                                /*BUG22564A*/
             ENDDO                                                                /*BUG22564A*/
/* */                                                                 /*086128*/
             ENDDO                                                    /*086128*/
/* */                                                                             /*BUG22564A*/
             ELSE       CMD(DO)                                       /*086128*/
/* */                                                                 /*086128*/
/* Call save processing */                                            /*086128*/
/* */                                                                 /*086128*/
             IF         COND(&RECOVERY *NE '*NONE     ') THEN(DO)     /*086128*/
             CALL       PGM(&RECOVERY) PARM('*Save     ' &COMMIT_OPT) /*086128*/
             ENDDO                                                    /*086128*/
             ELSE       CMD(DO)                                                   /*BUG22564A*/
             IF         COND(&EXT_COMP *EQ 'CGC7410   ') THEN(DO)                 /*BUG22564A*/
               DLTF       FILE(XSDINPHPD)                                         /*BUG22564A*/
               MONMSG     MSGID(CPF0000)                                          /*BUG22564A*/
                                                                                  /*BUG22564A*/
               CPYF       FROMFILE(SDINPHPD) TOFILE(&DPLIB/XSDINPHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                          /*BUG22564A*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*BUG22564A*/
             ENDDO                                                                /*BUG22564A*/
             ENDDO
/* */                                                                             /*BUG22564A*/
             ENDDO                                                                /*BUG22564A*/
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If Commitment request call component */
/* */
             IF         COND(&COMMIT_OPT *EQ 'YES') THEN(DO)
/* */
             CALL       PGM(&EXT_COMP) PARM(&COMP_NAME &COMP_SEQ +
                          &EXTRACT &MEMBER &COMMIT_OPT)
/* */
             ENDDO
             ELSE       CMD(DO)
/* */
/* Get Member Name */
/* */
             CHGVAR     VAR(&MEMBER) VALUE(&EXTRACT)
/* */
/* Create New Member */
/* */
             CALL       PGM(CGC2080) PARM(&COMP_NAME &COMP_SEQ &MEMBER)
/* */
/* Override Members */
/* */
             OVRDBF     FILE(EXUDCRPD) TOFILE(EXCGUDCRPD) +
                          MBR(&MEMBER) SEQONLY(*YES 500)
             OVRDBF     FILE(EXUDCLPD) TOFILE(EXCGUDCLPD) +
                          MBR(&MEMBER) SEQONLY(*YES 500)
             OVRDBF     FILE(EXUDTAPD) TOFILE(EXCGUDTAPD) +
                          MBR(&MEMBER) SEQONLY(*YES 500)
             OVRDBF     FILE(EXUDT1PD) TOFILE(EXCGUDT1PD) +
                          MBR(&MEMBER) SEQONLY(*YES 500)
             OVRDBF     FILE(EXUDT2PD) TOFILE(EXCGUDT2PD) +
                          MBR(&MEMBER) SEQONLY(*YES 500)
             OVRDBF     FILE(EXUDT3PD) TOFILE(EXCGUDT3PD) +
                          MBR(&MEMBER) SEQONLY(*YES 500)
/* */
/* Call Extract Component */
/* */
             CALL       PGM(&EXT_COMP) PARM(&COMP_NAME &COMP_SEQ +
                          &EXTRACT &MEMBER &COMMIT_OPT)
/* */
/* Log record for copy */
/* */
             CALL       PGM(CGC2070) PARM(&RTN_CODE &MEMBER)
/* */
/* Remove Overrides */
/* */
             DLTOVR     FILE(*ALL)
/* */
             ENDDO
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */                                                                 /*086128*/
/* Call End  processing */                                            /*086128*/
/* */                                                                 /*086128*/
             IF         COND(&RECOVERY *NE '*NONE     ') THEN(DO)     /*086128*/
             CALL       PGM(&RECOVERY) PARM('*End      ' &COMMIT_OPT) /*086128*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*086128*/
             CHGJOB     SWS(00000000)                                 /*086128*/
             ENDDO                                                    /*086128*/
             ENDDO                                                    /*086128*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2050 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2050 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
