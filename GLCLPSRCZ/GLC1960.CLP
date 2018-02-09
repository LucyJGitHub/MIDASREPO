/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generate Settlements from Fee Accruals')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1960 - Customer Service Fees -                           */
/*                 Reversal of Fee Accruals Control                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CSD011             Date 04Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD011 - Performance Incentive Fees                         */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ )
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Accruals Required INDICATOR(S)                                  */
 
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSD011) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSD011*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSD011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSD011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSD011*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CSD011*/
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send start component message.                                   */
 
                   SNDPGMMSG  MSG('GLC1960 - Customer Service Fees/+
                                  Generate Settlements from Fees Accrued.') +
                              TOMSGQ(MRUNQ MOPERQ) MSGTYPE(*INFO)
 
/* Reset job switches.                                             */
 
             CHGJOB SWS(00000000)
 
/* Create LDA if not there.                                        */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Retrieve SDSTAT details.                                        */
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/**/                                                                  /*CSD011*/
/** Check if SAR CSD011 is installed */                               /*CSD011*/
/**/                                                                  /*CSD011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSD011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSD011*/
             CHGVAR     VAR(&SARD) VALUE('CSD011')                    /*CSD011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)  /*CSD011*/
/**/                                                                  /*CSD011*/
/** If CSD011 is installed */                                         /*CSD011*/
/**/                                                                  /*CSD011*/
             IF        COND(&RTCD *EQ '       ') THEN(DO)             /*CSD011*/
               CHGVAR     VAR(&CSD011) VALUE('Y')                     /*CSD011*/
             ENDDO                                                    /*CSD011*/
/**/                                                                  /*CSD011*/
/** If an error ocurred  */                                           /*CSD011*/
/**/                                                                  /*CSD011*/
             IF        COND((&RTCD *NE '       ') *AND (&RTCD +
                          *NE '*NRF    ')) THEN(DO)                   /*CSD011*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)                                        /*CSD011*/
               CHGJOB     SWS('XXXXXX11')                             /*CSD011*/
               GOTO       CMDLBL(END)                                 /*CSD011*/
             ENDDO                                                    /*CSD011*/
/* Check component status.                                         */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* If restart of component, then copy back working file.           */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
/* Use backup files when rerun : Fees Posting for Accruals.        */
 
                  CPYF       FROMFILE(XGEFEPD) TOFILE(GEFEPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFEPD))
                  CPYF       FROMFILE(XGEFEZZ) TOFILE(GEFEZZ) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFEZZ))
                  CPYF       FROMFILE(XGEFE2PD) TOFILE(GEFE2PD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFE2PD))
                  CPYF       FROMFILE(XGEFE2ZZ) TOFILE(GEFE2ZZ) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GEFE2ZZ))
 
/* Outstanding Fees Settlements.                                   */
 
                  CPYF       FROMFILE(XGLOTSTPD) TOFILE(GLOTSTPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLOTSTPD))
 
/* Fees Accrued File.                                              */
 
                  CPYF       FROMFILE(XGLFEACPD) TOFILE(GLFEACPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLFEACPD))
 
/* Today Accruals on Holding Items File                            */
 
                  CPYF       FROMFILE(XGLTAHIPD) TOFILE(GLTAHIPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLTAHIPD))
 
/* Customer Fee Charges                                            */
 
                  CPYF       FROMFILE(XGLCHRGPD) TOFILE(GLCHRGPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLCHRGPD))
 
/* If SAR CSD011 is switched ON                                    */ /*CSD011*/
             IF         COND(&CSD011 = 'Y') THEN(DO)                  /*CSD011*/
                                                                      /*CSD011*/
/* Performance Incentive Fees to be Calculated                     */ /*CSD011*/
                  CPYF       FROMFILE(XGLIFTCPD) TOFILE(GLIFTCPD) +
                             MBROPT(*REPLACE)                         /*CSD011*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(GLIFTCPD))                          /*CSD011*/
                                                                      /*CSD011*/
                  ENDDO                                               /*CSD011*/
 
/* Set Status component to 'N'.                                    */
 
                  CHGVAR     VAR(&STATUS) VALUE('N')
                  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/* Else backup files : Outstanding Fees Settlements.               */
 
                  CPYF       FROMFILE(GLOTSTPD) TOFILE(&TOLIB/XGLOTSTPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLOTSTPD))
 
/* Fees Accrued File.                                              */
 
                  CPYF       FROMFILE(GLFEACPD) TOFILE(&TOLIB/XGLFEACPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLFEACPD))
 
/* Today Accruals on Holdings Items File.                          */
 
                  CPYF       FROMFILE(GLTAHIPD) TOFILE(&TOLIB/XGLTAHIPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLTAHIPD))
 
/* Fees posting for accruals.                                      */
 
                  CPYF       FROMFILE(GEFEPD) TOFILE(&TOLIB/XGEFEPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFEPD))
                  CPYF       FROMFILE(GEFEZZ) TOFILE(&TOLIB/XGEFEZZ) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFEZZ))
                  CPYF       FROMFILE(GEFE2PD) TOFILE(&TOLIB/XGEFE2PD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFE2PD))
                  CPYF       FROMFILE(GEFE2ZZ) TOFILE(&TOLIB/XGEFE2ZZ) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGEFE2ZZ))
 
/* Customer Fee Charges                                            */
 
                  CPYF       FROMFILE(GLCHRGPD) TOFILE(&TOLIB/XGLCHRGPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLCHRGPD))
 
/* If SAR CSD011 is switched ON                                    */ /*CSD011*/
             IF         COND(&CSD011 = 'Y') THEN(DO)                  /*CSD011*/
                                                                      /*CSD011*/
/* Performance Incentive Fees to be Calculated                     */ /*CSD011*/
                  CPYF       FROMFILE(GLIFTCPD) TOFILE(&TOLIB/XGLIFTCPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)           /*CSD011*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLIFTCPD))                         /*CSD011*/
                                                                      /*CSD011*/
                  ENDDO                                               /*CSD011*/
 
             ENDDO
 
/* Change Component Status to "started".                           */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Override Files.                                                 */
 
             IF         COND(&CSEQ *NE 1) THEN(DO)
             OVRDBF     FILE(GEFEPD) TOFILE(GEFE2PD)
             OVRDBF     FILE(GEFEZZ) TOFILE(GEFE2ZZ)
             ENDDO
 
/* Call program.                                                   */
 
            CALL       PGM(GL1960)
/* If SAR CSD011 switched on and no error from GL1960 then call       /*CSD011*/
/* GL1960B                                                            /*CSD011*/
                                                                      /*CSD011*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CSD011*/
             IF         COND(&CSD011 = 'Y') THEN(DO)                  /*CSD011*/
             CALL       PGM(GL1960B)                                  /*CSD011*/
             ENDDO                                                    /*CSD011*/
             ENDDO                                                    /*CSD011*/
                                                                      /*CSD011*/
 
/* If No database error, Component is terminated.                  */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                CHGVAR     VAR(&STATUS) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Send normal end component message.                              */
 
                SNDPGMMSG  MSG('GLC1960 - Customer Service Fees/+
                                Generate Settlements From Fees +
                                Accrued successfully terminated') +
                           TOMSGQ(MRUNQ MOPERQ) MSGTYPE(*INFO)
 
/* Delete files image.                                             */
 
                DLTF       FILE(XGLOTSTPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGLFEACPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGLTAHIPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFEPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFEZZ)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFE2PD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGEFE2ZZ)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XGLCHRGPD)
                MONMSG     MSGID(CPF0000)
 
/* If SAR CSD011 is switched ON                                    */ /*CSD011*/
             IF         COND(&CSD011 = 'Y') THEN(DO)                  /*CSD011*/
                DLTF       FILE(XGLIFTCPD)                            /*CSD011*/
                MONMSG     MSGID(CPF0000)                             /*CSD011*/
                ENDDO                                                 /*CSD011*/
                                                                      /*CSD011*/
 
             ENDDO
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/* Send Abnormal end component message.                            */
 
                SNDPGMMSG  MSG('GLC1960 - Customer Service Fee         s/+
                                    Generate Settlements From Fees +
                                    Accrued Abnormally Terminated') +
                                    TOMSGQ(MRUNQ)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1960 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
