/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Start replication system - COB')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC0015 - Start Replication Subsystem - COB                 */
/*                                                                   */
/*       (C) COPYRIGHT Finastra International Limited 2001           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD026             Date 05Apr05              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CRP006  *CREATE    Date 12Oct99              */
/*                      ------             Date --------             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD026 - OPICS/MIDAS Interface submit Rates Upload request  */
/*       CRP006 - Replication.                                       */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CSD026) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD026*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSD026*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSD026*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSD026*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSD026*/
/* Define work variables for System Values */                                             /*CSD026*/
                                                                                          /*CSD026*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSD026*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*CSD026*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                  /*CSD026*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*CSD026*/
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(8)                                     /*CSD026*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                           Copyright Finastra International Limited +
                           2001')
 
/* Global Monitor Message                                        **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC0015 Replication - Start Replication +
                          Sub-System - COB') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
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
/*Set status of component for start of processing.               **/
 
             CHGVAR     VAR(&CSTS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
 
/* Call the program to start the Replication Sub-System          **/
 
             CALL       PGM(RPC0010)
 
/* If any errors are reported, perform error processing.          **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(TAG998)
             ENDDO
 
/* Begin CSD026 */
             IF COND(&CSD026 *EQ 'Y') THEN(DO)                                           /*CSD026*/
/* Check whether the 'RatesDownloadTime' system value has been entered  */               /*CSD026*/
             CHGVAR     VAR(&TIME) VALUE(%SST(&SVAL1 1 8))                                /*CSD026*/
                                                                                          /*CSD026*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE 'RatesDownloadTime' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK0 &SVAL10)                                 /*CSD026*/
                                                                                          /*CSD026*/
             CHGVAR     VAR(&TIME) VALUE(%SST(&SVAL1 1 8))                                /*CSD026*/
                                                                                          /*CSD026*/
             IF         COND(%SST(&SVAL1 1 8) *NE '        ') THEN(DO)                    /*CSD026*/
/* Submit job to request rate from TrOPICS at time specified       */                     /*CSD026*/
/* by the bank.                                                    */                     /*CSD026*/
/*                                                                 */                     /*CSD026*/
             SBMJOB     CMD(CALL PGM(RPC5026)) JOB(FXRATERQS) +
                          JOBD(TIJOBD) JOBQ(TIJOBQ) SCDTIME(&TIME)
 
                                                                                          /*CSD026*/
             ENDDO                                                                        /*CSD026*/
             ENDDO                                                                        /*CSD026*/
/*                                                                 */
/* End CSD026 */
/* Set status of component for successful completion.             **/
 
             CHGVAR     VAR(&CSTS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &CSTS)
 
             GOTO       CMDLBL(TAG999)
 
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC0015 Replication - +
                          Start Replication Sub-System - COB - +
                          Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             ENDPGM
