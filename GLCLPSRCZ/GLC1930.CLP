/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Reconciliation of Cust. Fees Files Ctrl')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1930 - Reconciliation of Customer Fees Files Control     */
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
             PGM PARM(&CNAM &CSEQ &DELET)
 
/* Declare variables                                               */
 
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
 
/* Variables                                                       */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DELET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
             SNDPGMMSG  MSG('GLC1930 - Customer Service Fees - +
                          Reconciliation Customer Fees Files ') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
 
             CHGJOB     SWS(00000000)
 
/* Create LDA for job in QTEMP if it does not already exist        */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        ENDDO
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
 
/* Check for component restart                                     */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* Restart                                                         */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
/* Restore copy file : Fee types File                              */
 
               CPYF       FROMFILE(XSDCFTPPD) TOFILE(SDCFTPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDCFTPPD))
 
/* Restore copy file : VAT Codes File                              */
 
               CPYF       FROMFILE(XSDVATCPD) TOFILE(SDVATCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDVATCPD))
 
/* Restore copy file : Rate Codes File                             */
 
               CPYF       FROMFILE(XSDRTCDPD) TOFILE(SDRTCDPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDRTCDPD))
             ENDDO
 
/* First run                                                       */
 
             ELSE       CMD(DO)
 
/* Save file : Fee Types File.                                     */
 
               CPYF       FROMFILE(SDCFTPPD) TOFILE(&TOLIB/XSDCFTPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDCFTPPD))
 
/* Save file : VAT Codes File.                                     */
 
               CPYF       FROMFILE(SDVATCPD) TOFILE(&TOLIB/XSDVATCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDVATCPD))
 
/* Save file : Rate Codes File.                                    */
 
               CPYF       FROMFILE(SDRTCDPD) TOFILE(&TOLIB/XSDRTCDPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDRTCDPD))
             ENDDO
 
/* Update the component status                                     */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Call program                                                    */
 
             CALL       PGM(GL1930) PARM(&DELET)
 
/* If no error end processing                                      */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Update the component status, if U7 and U8 are off               */
 
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Delete security copy : Fee Types File.                          */
 
             DLTF       FILE(XSDCFTPPD)
             MONMSG     MSGID(CPF0000)
 
/* Delete security copy : VAT Codes File.                          */
 
             DLTF       FILE(XSDVATCPD)
             MONMSG     MSGID(CPF0000)
 
/* Delete security copy : Rate Codes File.                         */
 
             DLTF       FILE(XSDRTCDPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
             ENDDO
 
/* Database error processing                                       */
 
             IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      MONMSG     MSGID(CPF0000)
                      GOTO       CMDLBL(END)
             ENDDO
 
/* Error processing */
 
ABNOR:       CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1930 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
