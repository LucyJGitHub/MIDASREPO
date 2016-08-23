/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Start replication system')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication Module                                  */
/*                                                                   */
/*       RPC0010 - Start Replication Subsystem.                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 234487             Date 26MAY06              */
/*       Prev Amend No. CSD026             Date 05Apr05              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002             Date 15Mar01              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      173248             Date 06Jan00              */
/*                      CRP006  *CREATE    Date 17Sep99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       234487 - Extend wait time for ending the Replication        */
/*                Subsystem.                                         */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       CSC017 - Change to 250 library list.                        */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*       173248 - Change REPMIDAS subsystem amended to include       */
/*                the Midas System Prefix.                           */
/*       CRP006 - Replication.                                       */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&WAITCOUNT) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&QCMD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*173248*/
             DCL        VAR(&RSBS) TYPE(*CHAR) LEN(10)                                    /*173248*/
/************DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(275)                 */ /*CPB002*/ /*CSC017*/
/************DCL        VAR(&CMD)      TYPE(*CHAR) LEN(289)                 */ /*CPB002*/ /*CSC017*/
             DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(2750)                              /*CSC017*/
             DCL        VAR(&CMD)      TYPE(*CHAR) LEN(2764)                              /*CSC017*/
             DCL        VAR(&CHLNAME)  TYPE(*CHAR) LEN(50)                                /*CSD026*/
             DCL        VAR(&CSD026) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD026*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSD026*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSD026*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSD026*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSD026*/
 
             DCLF       FILE(RPAPSIPD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global Monitor Message                                        **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC0010 Replication - Start Replication +
                          Sub-System') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
                                                                                          /*CSD026*/
/* Check if CSD026 is enabled. */                                                         /*CSD026*/
                                                                                          /*CSD026*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSD026*/
             CHGVAR     VAR(&SAR)  VALUE('CSD026')                                        /*CSD026*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSD026*/
             CHGVAR     VAR(&CSD026) VALUE('N')                                           /*CSD026*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSD026*/
                                                                                          /*CSD026*/
             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE +
                          '*NRF   ') THEN(DO)                                             /*CSD026*/
               GOTO   CMDLBL(TAG998)                                                      /*CSD026*/
             ENDDO                                                                        /*CSD026*/
                                                                                          /*CSD026*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CSD026*/
             CHGVAR     VAR(&CSD026) VALUE('Y')                                           /*CSD026*/
             ENDDO                                                                        /*CSD026*/
                                                                              /*CPB002*/
/* Set TIJOBD libl                                                              CPB002*/
                                                                              /*CPB002*/
             RTVJOBD    JOBD(TIJOBD) INLLIBL(&INLLIBL)                        /*CPB002*/
                                                                              /*CPB002*/
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')                               /*CPB002*/
                                                                              /*CPB002*/
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                         */ /*CPB002*/ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
                                                                              /*CPB002*/
 
             IF         COND(&CSD026 *EQ 'Y') THEN(DO)                                   /*CSD026*/
                                                                                         /*CSD026*/
             CALL       PGM(RPC9999)                                                     /*CSD026*/
             MONMSG     MSGID(CPF0000)                                                   /*CSD026*/
             ENDDO                                                                       /*CSD026*/
                                                                                         /*CSD026*/
/*  Get Midas system prefix and construct the name of the         **/         /*173248*/
/*    Replication sub-system.                                     **/         /*173248*/
                                                                              /*173248*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                    /*173248*/
             CHGVAR     VAR(&RSBS) VALUE('REPMIDAS' *TCAT &PRFX)              /*173248*/
                                                                              /*173248*/
/* Attempt to end the Replication Sub-System                     **/
 
TAG001:
/**********  ENDSBS     SBS(REPMIDAS) OPTION(*IMMED) */                                   /*173248*/
             ENDSBS     SBS(&RSBS) OPTION(*IMMED)                                         /*173248*/
             MONMSG     MSGID(CPF0943)
/****        MONMSG     MSGID(CPF1056) EXEC(DLYJOB DLY(10))          */                   /*234487*/
             MONMSG     MSGID(CPF1056) EXEC(DLYJOB DLY(120))                              /*234487*/
             MONMSG     MSGID(CPF1054) EXEC(GOTO CMDLBL(TAG002))
 
/* Only wait for a maximum of 10 loops.                          **/
 
             CHGVAR     VAR(&WAITCOUNT) VALUE(&WAITCOUNT + 1)
             IF         COND(&WAITCOUNT > 10) THEN(GOTO CMDLBL(TAG998))
 
             GOTO       CMDLBL(TAG001)
 
 
/* Attempt to restart the Replication Sub-System                 **/
 
TAG002:
/* Reset counter.                                                **/
 
             CHGVAR     VAR(&WAITCOUNT) VALUE(0)
 
/**********  STRSBS     SBSD(REPMIDAS) */                                                 /*173248*/
             STRSBS     SBSD(&RSBS)                                                       /*173248*/
             MONMSG     MSGID(CPF0902)
             MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(TAG001))
 
/* Call any interface-specific processing.                       **/
TAG003:
             RCVF       RCDFMT(RPAPSID0)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(TAG004))
 
/* Ignore any interfaces that are not flagged as active.         **/
 
             IF         COND(&RDINFACTI *NE 'Y') THEN(GOTO +
                          CMDLBL(TAG003))
 
/* Call all programs specified.                                  **/
 
             IF         COND(&RDPGMPARM *EQ ' ') THEN(DO)
               CALL       PGM(&RDPGMNAME)
             ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(&QCMD) VALUE('CALL PGM(' *CAT +
                            &RDPGMNAME *TCAT ') PARM(' *CAT +
                            &RDPGMPARM *TCAT ')')
               CALL       PGM(QCMDEXC) PARM(&QCMD 200)
             ENDDO
 
             GOTO       CMDLBL(TAG003)
 
TAG004:
                                                                              /*CPB002*/
/* Set TIJOBD libl                                                              CPB002*/
                                                                              /*CPB002*/
             RTVJOBD    JOBD(MIDASIC) INLLIBL(&INLLIBL)                       /*CPB002*/
                                                                              /*CPB002*/
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')                               /*CPB002*/
                                                                              /*CPB002*/
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                         */ /*CPB002*/ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
                                                                              /*CPB002*/
             IF         COND(&CSD026 *EQ 'Y') THEN(DO)                /*CSD026*/
/**  Start channel if not   ***/                                      /*CSD026*/
             RTVDTAARA  DTAARA(RPTROPXCHL (1 25)) RTNVAR(&CHLNAME)    /*CSD026*/
             MONMSG     MSGID(CPF1015)                                /*CSD026*/
             IF         COND(&CHLNAME *NE '         ') THEN(DO)       /*CSD026*/
             STRMQMCHL  CHLNAME(&CHLNAME)                             /*CSD026*/
             MONMSG     MSGID(CPF0001)                                /*CSD026*/
             DLYJOB     DLY(15)                                       /*CSD026*/
             ENDDO                                                    /*CSD026*/
             ENDDO                                                    /*CSD026*/
CSD026:                                                               /*CSD026*/
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC0010 Replication - +
                          Start Replication Sub-System - Ended in +
                          Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
