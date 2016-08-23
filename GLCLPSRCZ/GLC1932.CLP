/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Cust. Serv. Fees - Cust/Portf to process')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1932 - Customer Service Fees -                           */
/*                 Retrieve Customer/Portfolio for Fee processing    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 208383             Date 08Feb13              */
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
/*       208383 - Replication subsystem must not be started.         */
/*                Applied for AR1059422                              */
/*       CSD011 - Performance Incentive Fees.                        */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
/* Variables */
 
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CSD011) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSD011*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSD011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSD011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSD011*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CSD011*/
             DCL        VAR(&REPBASLIB) TYPE(*CHAR) LEN(10)           /*CSD011*/
             DCL        VAR(&REPSUBLIB) TYPE(*CHAR) LEN(10)           /*CSD011*/
/**********  DCL        VAR(&REPSBS) TYPE(*CHAR) LEN(10)  */                       /*CSD011 208383*/
                                                                      /*CSD011*/
/* Global monitor message */
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message */
 
             SNDPGMMSG  MSG('GLC1932 - Customer Service Fees - +
                          Retrieve Customers/Portfolio for Fee +
                          Processing') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
 
/* Set off all job switches */
 
             CHGJOB     SWS(00000000)
 
/* Create LDA for job in QTEMP if it does not already exist */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        ENDDO
 
/* Clear LDA */
 
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
 
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
             CLRPFM     FILE(GLCUFEPD)
 
/* Check for component restart */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* Restart */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
/* Restore copy file : Fee types File */
 
               CPYF       FROMFILE(XGLCHRGPD) TOFILE(GLCHRGPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
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
             ENDDO
/* First run */
 
             ELSE       CMD(DO)
 
/* Save file : Fee Types File. */
 
               CPYF       FROMFILE(GLCHRGPD) TOFILE(&TOLIB/XGLCHRGPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XGLCHRGPD))
 
/* If SAR CSD011 is switched ON                                    */ /*CSD011*/
             IF         COND(&CSD011 = 'Y') THEN(DO)                  /*CSD011*/
                                                                      /*CSD011*/
/* Performance Incentive Fees to be Calculated                     */ /*CSD011*/
             CPYF       FROMFILE(GLIFTCPD) TOFILE(&TOLIB/XGLIFTCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*MAP *DROP)                          /*CSD011*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XGLIFTCPD))                         /*CSD011*/
                                                                      /*CSD011*/
                  ENDDO                                               /*CSD011*/
             ENDDO
 
/* Update the component status */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Call program */
 
             CALL       PGM(GL1932)
 
 
/* If SAR CSD011 switched ON and no error from GL1932 then start   */ /*CSD011*/
/* the Replication Subsystem and call GL1933.                      */ /*CSD011*/
                                                                      /*CSD011*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CSD011*/
                                                                      /*CSD011*/
               IF         COND(&CSD011 = 'Y') THEN(DO)                /*CSD011*/
                                                                      /*CSD011*/
/*  Add Replication Subsystem library to library list.             */ /*CSD011*/
                                                                      /*CSD011*/
             RTVDTAARA  DTAARA(KMDSBS (1 10)) RTNVAR(&REPSUBLIB)      /*CSD011*/
                                                                      /*CSD011*/
/*  If library is set to blank do not process                      */ /*CSD011*/
                                                                      /*CSD011*/
                  IF         COND(&REPSUBLIB *NE ' ') THEN(DO)        /*CSD011*/
                                                                      /*CSD011*/
/*  Add replication to library list                                */ /*CSD011*/
                                                                      /*CSD011*/
                  ADDLIBLE   LIB(&REPSUBLIB) POSITION(*FIRST)         /*CSD011*/
                  MONMSG     MSGID(CPF2103)                           /*CSD011*/
                                                                      /*CSD011*/
                                                                      /*CSD011*/
/*  Add Replication Base library to library list                   */ /*CSD011*/
                                                                      /*CSD011*/
                RTVDTAARA  DTAARA(KMDBASE (1 10)) RTNVAR(&REPBASLIB)  /*CSD011*/
                ADDLIBLE   LIB(&REPBASLIB) POSITION(*FIRST)           /*CSD011*/
                MONMSG     MSGID(CPF2103)                             /*CSD011*/
                                                                      /*CSD011*/
                                                                      /*CSD011*/
/*  Start replication subsystem if not yet started                 */ /*CSD011*/
                                                                      /*CSD011*/
/**********       RTVDTAARA  DTAARA(KMDSBS) RTNVAR(&REPSBS) */                     /*CSD011 208383*/
/**********       STRSBS     SBSD(&REPSBS)                  */                     /*CSD011 208383*/
/**********       MONMSG     MSGID(CPF1010)                 */                     /*CSD011 208383*/
                                                                      /*CSD011*/
                  CALL       PGM(GL1933)                              /*CSD011*/
                                                                      /*CSD011*/
/*  Remove Replication Subsystem and Base library                  */ /*CSD011*/
                                                                      /*CSD011*/
                  RMVLIBLE   LIB(&REPSUBLIB)                          /*CSD011*/
                  RMVLIBLE   LIB(&REPBASLIB)                          /*CSD011*/
                                                                      /*CSD011*/
                  ENDDO                                               /*CSD011*/
                ENDDO                                                 /*CSD011*/
             ENDDO                                                    /*CSD011*/
                                                                      /*CSD011*/
/* If no error end processing */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Update the component status */
 
                CHGVAR     VAR(&STATUS) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Delete security copy : Charge Group file.*/
 
                DLTF       FILE(XGLCHRGPD)
                MONMSG     MSGID(CPF0000)
 
/* If SAR CSD011 is switched ON                                    */ /*CSD011*/
             IF         COND(&CSD011 = 'Y') THEN(DO)                  /*CSD011*/
                DLTF       FILE(XGLIFTCPD)                            /*CSD011*/
                MONMSG     MSGID(CPF0000)                             /*CSD011*/
                ENDDO                                                 /*CSD011*/
                GOTO       CMDLBL(END)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) +
                 THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      MONMSG     MSGID(CPF0000)
                      GOTO       CMDLBL(END)
                 ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1932 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
