/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Retrv. Cust. Serv. Fees to Process Contrl')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1931 - Retrieve Customer Service Fees to Process Control */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Phase:  Close of Business                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
             SNDPGMMSG  MSG('GLC1931 - Customer Service Fees - +
                          Retrieve Customer Service Fees to +
                          process') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Retrieve library name of working physical files                 */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
 
/* Create GLCSFSTAT if not present                                  */
 
             CHKOBJ     OBJ(&DMLIB/GLCSFSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(&DMLIB/GLCSFSTAT) TYPE(*CHAR) +
                                   LEN(128) VALUE(' ')
                        ENDDO
             CHGDTAARA  DTAARA(&DMLIB/GLCSFSTAT) VALUE(' ')
 
/* Create LDA if not present                                       */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        AUT(*EXCLUDE)
                        ENDDO
 
/* Clear dataarea                                                  */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Reset job switches                                              */
 
             CHGJOB     SWS(00000000)
 
/* Clear files                                                     */
 
             IF  COND(&CSEQ = 1) THEN(DO)
 
/* Daily files                                                     */
 
               CLRPFM     FILE(GLTAHIPD)
               CLRPFM     FILE(GLHOLDPD)
               CLRPFM     FILE(GEFEPD)
               CLRPFM     FILE(GEFEZZ)
 
/* Accrual day followed by a non working day files                 */
 
               CLRPFM     FILE(GEFE2PD)
               CLRPFM     FILE(GEFE2ZZ)
 
             ENDDO
 
/* Check for component restart                                     */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* Restart                                                         */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
/* Restore copy file                                               */
 
               CPYF       FROMFILE(XSDCFTPPD) TOFILE(SDCFTPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDCFTPPD))
 
             ENDDO
 
/* First run                                                       */
 
             ELSE       CMD(DO)
 
/* Save file                                                       */
 
               DLTF       FILE(XSDCFTPPD)
               MONMSG     MSGID(CPF0000)
 
               CPYF       FROMFILE(SDCFTPPD) TOFILE(&TOLIB/XSDCFTPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDCFTPPD))
 
             ENDDO
 
/* Update the component status                                     */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Call program                                                    */
 
             CALL       PGM(GL1931)
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Update the component status                                     */
 
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Delete security copy                                            */
 
             DLTF       FILE(XSDCFTPPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination                                            */
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC1931 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
