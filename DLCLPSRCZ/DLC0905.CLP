/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FX and MM on request reports')               */
/********************************************************************/
/*                                                                  */
/*       Midas     - Dealing Module                             */
/*                                                                  */
/*       DLC0905 - On request reports for MM and FX at COB and I/C. */
/*               - MM Complete deals amendable fields file list.    */
/*               - MM Complete deals mandatory fields file list.    */
/*               - FX Complete deals amendable fields file list.    */
/*               - FX Complete deals mandatory fields file list.    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. XXXXXX            DATE  00XXX00             */
/*                                        DATE                      */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&PROGRAM &RUNTYP &RSEQ &RLEV &RENT)
 
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RUNTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Create local data area                                           */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
 
             CHGJOB     SWS(00000000)
 
             IF         COND(&PROGRAM *EQ 'MM0010') THEN(DO)
                  IF         COND(&RUNTYP *EQ 'IC') THEN(DO)
                       SNDMSG     MSG('MM MANDATORY FIELDS REPORT - +
                            INPUT CYCLE') TOMSGQ(MRUNQ)
                       CALL       PGM(MM0010) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  IF         COND(&RUNTYP *EQ 'ED') THEN(DO)
                       SNDMSG     MSG('MM MANDATORY FIELDS REPORT - +
                            CLOSE OF BUSINESS') TOMSGQ(MRUNQ)
                       CALL       PGM(MM0010) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  ENDDO
 
             IF         COND(&PROGRAM *EQ 'MM0012') THEN(DO)
                  IF         COND(&RUNTYP *EQ 'IC') THEN(DO)
                       SNDMSG     MSG('MM AMENDABLE FIELDS REPORT - +
                            INPUT CYCLE') TOMSGQ(MRUNQ)
                       CALL       PGM(MM0012) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  IF         COND(&RUNTYP *EQ 'ED') THEN(DO)
                       SNDMSG     MSG('MM AMENDABLE FIELDS REPORT - +
                            CLOSE OF BUSINESS') TOMSGQ(MRUNQ)
                       CALL       PGM(MM0012) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  ENDDO
 
             IF         COND(&PROGRAM *EQ 'FX0150') THEN(DO)
                  IF         COND(&RUNTYP *EQ 'IC') THEN(DO)
                       SNDMSG     MSG('FX MANDATORY FIELDS REPORT - +
                            INPUT CYCLE') TOMSGQ(MRUNQ)
                       CALL       PGM(FX0150) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  IF         COND(&RUNTYP *EQ 'ED') THEN(DO)
                       SNDMSG     MSG('FX MANDATORY FIELDS REPORT - +
                            CLOSE OF BUSINESS') TOMSGQ(MRUNQ)
                       CALL       PGM(FX0150) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  ENDDO
 
             IF         COND(&PROGRAM *EQ 'FX0130') THEN(DO)
                  IF         COND(&RUNTYP *EQ 'IC') THEN(DO)
                       SNDMSG     MSG('FX AMENDABLE FIELDS REPORT - +
                            INPUT CYCLE') TOMSGQ(MRUNQ)
                       CALL       PGM(FX0130) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  IF         COND(&RUNTYP *EQ 'ED') THEN(DO)
                       SNDMSG     MSG('FX AMENDABLE FIELDS REPORT - +
                            CLOSE OF BUSINESS') TOMSGQ(MRUNQ)
                       CALL       PGM(FX0130) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDPGM))
             ELSE       CMD(DO)
 
/* For database errors recover data from LDA                         */
 
ERROR:            IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                      CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                      SNDPGMMSG MSGID(MEM0011) MSGF(MIDAS) +
                         MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      ENDDO
 
             ENDDO
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RETURN
             ENDPGM
