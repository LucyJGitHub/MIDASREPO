/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Statement Driver Control')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                     */
/*                                                                   */
/*       CGC4700  - Statement Driver Control                         */
/*                                                                   */
/*       Function:  This process sets up the environment for and     */
/*                  calls the program to produce the UDC Statement   */
/*                  Driver file and the final Midas Statement Driver */
/*                  file.                                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 087247             DATE 03MAY95              */
/*       PREV AMEND NO. S01522             DATE 09JAN95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       087247 - Correct processing                                 */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&COMP_NAME &COMP_SEQ)
 
/* General                                                           */
 
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&DBPREFIX)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNLIB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO_RECS)     TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ)    TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS)      TYPE(*CHAR) LEN(1)
 
 
/* Copyright Statement                                               */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Global monitor message */
 
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
 
/* Send message to MRUNQ */
 
             SNDPGMMSG  MSG('CGC4700 - Statement Driver Control') +
                          TOMSGQ(MRUNQ)
 
 
/* Set-off Data Base Error Switches. */
 
             CHGJOB     SWS(XXXXXX00)
 
/* Create data LDA in QTEMP  */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
/* Construct DPLIB */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&DBPREFIX *CAT 'DPLIB')
/* */
/* Get run status */
/* */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/************                                                          *087247*/
/**Update*status to Active *                                           *087247*/
/************                                                          *087247*/
/************CHGVAR     VAR(&STATUS) VALUE('Y')                        *087247*/
/************CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS) *087247*/
/* */                                                                 /*087247*/
/* If status is active skip */                                        /*087247*/
/* */                                                                 /*087247*/
             IF         COND(&STATUS *NE 'Y') THEN(DO)                /*087247*/
 
/* Clear the UDC Statement Driver file.                              */
 
             CLRPFM     FILE(CGSTMTPD)
 
/* Delete the Temporary Statement Driver file if it exists.          */
 
             DLTF       FILE(&DPLIB/XXSTMTAH)
             MONMSG     MSGID(CPF2105)
 
 
/* Create the Temporary Statement Driver file exists by duplicating  */
/* the existing Statement Driver file and data.                      */
 
             RTVOBJD    OBJ(STMTAH) OBJTYPE(*FILE) RTNLIB(&RTNLIB)
             CRTDUPOBJ  OBJ(STMTAH) FROMLIB(&RTNLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(XXSTMTAH) DATA(*YES)
 
 
/* Change the Temporary Statement Driver file to allow 2 members and */
/* add one to receive the updated version of the Driver file.        */
 
             CHGPF      FILE(XXSTMTAH) MAXMBRS(2)
             ADDPFM     FILE(XXSTMTAH) MBR(EXTRACT) TEXT('Extracted +
                          Statements to Process')
 
 
/* Override the Temporary Statement Driver to the Extract member     */
/* (The main member will remain as a security copy of the STMAH file)*/
 
             OVRDBF     FILE(XXSTMTAH) MBR(EXTRACT) SEQONLY(*YES 500)
 
 
/* Override the Reference File for Non-Comit Control                 */
             OVRDBF     FILE(EXUDCRPD) TOFILE(CGUDCRPD) SECURE(*YES) +
                          SHARE(*NO)
 
 
/* Call the Statement Driver Program                                 */
 
             CALL    PGM(CG4700) PARM(&RTN_CODE)
 
 
/* */
/* Check for Database errors trapped by program */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
 
             ENDDO                                                    /*087247*/
/* */                                                                 /*087247*/
/* Update status to Active */                                         /*087247*/
                                                                      /*087247*/
             CHGVAR     VAR(&STATUS) VALUE('Y')                       /*087247*/
             CALL      PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS) /*087247*/
/* If no error thus far, overwrite Statement Driver file with new    */
/* Version.                                                          */
 
             RTVMBRD    FILE(XXSTMTAH) MBR(EXTRACT) NBRCURRCD(&NO_RECS)
             IF         COND((&NO_RECS *NE 0)) THEN(DO)
             CPYF       FROMFILE(XXSTMTAH) TOFILE(STMTAH) +
                          FROMMBR(EXTRACT) MBROPT(*REPLACE) +
                          CRTFILE(*NO)
             ENDDO
             ELSE       CMD(DO)
             CLRPFM     FILE(STMTAH)
             ENDDO
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
 
/* Terminate Program normally                                        */
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
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
/**/
             SNDPGMMSG  MSG('Program CGC4700 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC4700 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
