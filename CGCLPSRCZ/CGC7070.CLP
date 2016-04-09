/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Audit Letter Processing')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7070 - Audit Letter Processing (COB processing)          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. AR737553           Date 06Apr11              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG26660           Date 09Nov09              */
/*                      BUG26178           Date 29Sep09              */
/*                      CER041  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR737553 - CGC7070 00001 (Child: AR737554)                  */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26660 - "Next Processing Date" or Audit Date's           */
/*                  description needs to be updated in the FSD       */
/*       BUG26178 - Audit Letters were not processed/created during  */
/*                  COB                                              */
/*       CER041 - Audit Letters Correspondence                       */
/*                                                                   */
/*********************************************************************/
        PGM        PARM(&COMP_NAME &COMP_SEQ  &EXTRACT &MEMBER +
                     &COMMIT_OPT)
 
       DCLF  FILE(SDBANKPD)  /*PF*/
 
/* Declare variables                                                 */
 
      DCL    VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
      DCL    VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
      DCL    VAR(&EXTRACT) TYPE(*CHAR) LEN(10)
      DCL    VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
      DCL    VAR(&MEMBER) TYPE(*CHAR) LEN(10)
 
      DCL    VAR(&DATA)       TYPE(*CHAR) LEN(50)
      DCL    VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                 Misys International Banking +
                          Systems Ltd. 2008.')
 
      DCL    VAR(&SRTCD) TYPE(*CHAR) LEN(7)
      DCL    VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
      DCL    VAR(&SSARD) TYPE(*CHAR) LEN(6) VALUE('CER041')
 
      DCL    VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
      DCL    VAR(&PDATE) TYPE(*CHAR) LEN(6)
      DCL    VAR(&DATEY) TYPE(*CHAR) LEN(1)
      DCL    VAR(&EMPTY) TYPE(*CHAR) LEN(1)
 
      DCL    VAR(&RECNUM) TYPE(*DEC) LEN(10 0)
      DCL    VAR(&WKDAT2) TYPE(*DEC) LEN(5 0)
      DCL    VAR(&PDATE2) TYPE(*DEC) LEN(6 0)
      DCL    VAR(&RUNDAT) TYPE(*DEC) LEN(6 0)
      DCL    VAR(&ZDATFM) TYPE(*CHAR) LEN(1)
      DCL    VAR(&WQ0004) TYPE(*CHAR) LEN(7)
 
      DCL    VAR(&ACTION) TYPE(*CHAR) LEN(8)
 
 
/* Global Monitor Message                                            */
 
 MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
               EXEC(GOTO ABNORMAL)
 
 
/* Check for SAR CER041 (Audit Letter)                              */
 
  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
 
/* If found, do                                                      */
  IF         COND(&SRTCD *EQ '        ') THEN(DO)
 
/* Retrieve Processing Date from data area CGAUDT                    */
/* At MHCB, by default this is = Midas Rundate)                      */
 
  RTVDTAARA  DTAARA(CGAUDT (1 6)) RTNVAR(&PDATE)
 
/* Validate selection file CGAUSLPD for records                      */
 
             CHGVAR     VAR(&EMPTY) VALUE('N')
 
             RTVMBRD    FILE(CGAUSLL0) NBRCURRCD(&RECNUM)
             IF COND(&RECNUM *EQ 0) THEN(DO)
             CHGVAR     VAR(&EMPTY) VALUE('Y')
             ENDDO
 
/* Retrieve Midas Run Date from File SDBANKPD                        */
 
  RCVF  RCDFMT(SDBANKD0)
 
/* Convert Midas Run Date into DDMMYY                                */
 
  CHGVAR &WKDAT2 &BJRDNB /* 3,0 P ---> 5,0  */
  CALL  PGM(ZDATE2) PARM(&WKDAT2 &ZDATFM &RUNDAT &WQ0004)
 
/** If CGAUDT is empty change PDATE value to Run Date and            */                 /*AR737553*/
/** initialize CGAUDT to PDATE.                                      */                 /*AR737553*/
 
             IF COND(&PDATE *EQ ' ') THEN(DO)                                           /*AR737553*/
             CHGVAR     VAR(&PDATE) VALUE(&RUNDAT)                                      /*AR737553*/
             CHGDTAARA  DTAARA(CGAUDT (1 6)) VALUE(&PDATE)                              /*AR737553*/
             ENDDO                                                                      /*AR737553*/
 
/* Compare Next Processing date with Run Date                        */
 
  CHGVAR VAR(&PDATE2) VALUE(&PDATE)   /*convert alpha to decimal*/
/*IF (&PDATE2 *EQ &RUNDAT) THEN(DO)                                  */                 /*BUG26178*/
/*IF (&PDATE2 *LE &RUNDAT) THEN(DO)                                  */        /*BUG26178 BUG26660*/
  IF (&PDATE2 *EQ &RUNDAT) THEN(DO)                                                     /*BUG26660*/
      CHGVAR &DATEY 'Y'
  ENDDO
 
/* If CGAUSLPD not empty AND Next Processing Date = Midas Run Date   */
/* browse thru the files and collect customer numbers for which a    */
/* "Audit Letter" is required. The results are written to            */
/* trigger file CGAUHDPD.                                            */
 
/* If CGAUSLPD not empty AND Next Processing Date = Midas Run Date   */
 
             IF         COND((&EMPTY *EQ 'N') *AND (&DATEY *EQ 'Y')) +
                          THEN(DO)
 
             CLRPFM CGAUHDPD
/* Write in CGAUHDPD                                                 */
             CALL CG7070
 
/* Call Extract File Instance Management (CCG015=Correp.Mgr.)        */
 
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')
             CALL       PGM(CGC3605) PARM(&ACTION)
 
/* Run Extract component (based on entries in CGAUHDPD)              */
 
             CALL       PGM(CG7110) PARM(' ' &COMMIT_OPT)
 
             ROLLBACK
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)
 
/* Process database errors (LDA:File / Key / Program                 */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
/* Call Custom-Defined Data Extract pgm (CCG015)                     */
 
            CALL       PGM(CGC3604)
 
            IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
            ENDDO
 
             ENDDO
 
             ENDDO
             GOTO CMDLBL(ENDE)
 
/*-------------------------------------------------------------------*/
ABNORMAL:
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')
             CALL       PGM(CGC3605) PARM(&ACTION)
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC7070 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC7070  ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*-------------------------------------------------------------------*/
ENDE:        RCLRSC LVL(*CALLER)
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
