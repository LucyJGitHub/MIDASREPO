/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Create New Temporary Bulk Extract Files')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2060  - Create New Temporary Bulk Extract Files          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 086129             DATE 15MAR95              */
/*       PREV AMEND NO. 083768             DATE 09FEB95              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       086129 - Do receovery irrespective of failure               */
/*       083768 - Clear CGCOBLPD irrespective of restart             */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2060 - Create New Temporary Bulk +
                          Extrat Files') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Format DPLIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&DBPREFIX *CAT 'DPLIB')
/* */
/* Format DMLIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&DBPREFIX *CAT 'DMLIB')
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* If status is active Delete Temporary Extract Files */
/* */
/************IF         COND(&STATUS *NE 'N') THEN(DO)                  086129*/
/* */
             DLTF       FILE(&DPLIB/EXCGUDCRPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDCLPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDTAPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDT1PD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDT2PD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(&DPLIB/EXCGUDT3PD)
             MONMSG     MSGID(CPF2105)
/* */
/* Clear COB Log Member File */
/* */
             CLRPFM     FILE(CGCOBLPD)
/* */
/************ENDDO                                                      086129*/
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Duplicate UDC Extract Files */
/* */
             CRTDUPOBJ  OBJ(CGUDCRPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(EXCGUDCRPD) DATA(*NO)
/* */
             CRTDUPOBJ  OBJ(CGUDCLPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(EXCGUDCLPD) DATA(*NO)
/* */
             CRTDUPOBJ  OBJ(CGUDTAPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(EXCGUDTAPD) DATA(*NO)
/* */
             CRTDUPOBJ  OBJ(CGUDT1PD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(EXCGUDT1PD) DATA(*NO)
/* */
             CRTDUPOBJ  OBJ(CGUDT2PD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(EXCGUDT2PD) DATA(*NO)
/* */
             CRTDUPOBJ  OBJ(CGUDT3PD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(EXCGUDT3PD) DATA(*NO)
/* */
/* Remove only member and allow multiple members */
/* */
             RMVM       FILE(&DPLIB/EXCGUDCRPD) MBR(*ALL)
             RMVM       FILE(&DPLIB/EXCGUDCLPD) MBR(*ALL)
             RMVM       FILE(&DPLIB/EXCGUDTAPD) MBR(*ALL)
             RMVM       FILE(&DPLIB/EXCGUDT1PD) MBR(*ALL)
             RMVM       FILE(&DPLIB/EXCGUDT2PD) MBR(*ALL)
             RMVM       FILE(&DPLIB/EXCGUDT3PD) MBR(*ALL)
/* */
             CHGPF      FILE(&DPLIB/EXCGUDCRPD) MAXMBRS(*NOMAX)
             CHGPF      FILE(&DPLIB/EXCGUDCLPD) MAXMBRS(*NOMAX)
             CHGPF      FILE(&DPLIB/EXCGUDTAPD) MAXMBRS(*NOMAX)
             CHGPF      FILE(&DPLIB/EXCGUDT1PD) MAXMBRS(*NOMAX)
             CHGPF      FILE(&DPLIB/EXCGUDT2PD) MAXMBRS(*NOMAX)
             CHGPF      FILE(&DPLIB/EXCGUDT3PD) MAXMBRS(*NOMAX)
/* */                                                                 /*083768*/
/* Clear COB Log Member File */                                       /*083768*/
/* */                                                                 /*083768*/
             CLRPFM     FILE(CGCOBLPD)                                /*083768*/
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
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
             SNDPGMMSG  MSG('Program CGC2060 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2060 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
