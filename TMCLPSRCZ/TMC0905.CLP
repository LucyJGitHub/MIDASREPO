/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX and MM on request reports')                  */
/********************************************************************/
/*                                                                  */
/*       Midas     - Treasury Management Module                 */
/*                                                                  */
/*       TMC0905 - TM ON REQUEST REPORTS                            */
/*                                                                  */
/*       Function: On request reports for MM and FX at COB and I/C. */
/*               - MM Limits by currency file list.                 */
/*               - FX Daylight and overnight limits file list.      */
/*                                                                  */
/*       Called by: Main menu                                       */
/*                                                                  */
/*       Calls:     MM0014 - MM Limits by currency file list.       */
/*                  FX0110 - FX Daylight and overnight limits file  */
/*                           list.                                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
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
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
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
 
             IF         COND(&PROGRAM *EQ 'MM0014') THEN(DO)
                  IF         COND(&RUNTYP *EQ 'IC') THEN(DO)
                       SNDMSG     MSG('MM LIMITS REPORT - +
                            INPUT CYCLE') TOMSGQ(MRUNQ)
                       CALL       PGM(MM0014) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  IF         COND(&RUNTYP *EQ 'ED') THEN(DO)
                       SNDMSG     MSG('MM LIMITS REPORT - +
                            CLOSE OF BUSINESS') TOMSGQ(MRUNQ)
                       CALL       PGM(MM0014) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  ENDDO
 
             IF         COND(&PROGRAM *EQ 'FX0110') THEN(DO)
                  IF         COND(&RUNTYP *EQ 'IC') THEN(DO)
                       SNDMSG     MSG('FX LIMITS REPORT - +
                            INPUT CYCLE') TOMSGQ(MRUNQ)
                       CALL       PGM(FX0110) PARM(&RUNTYP &RSEQ)
                       ENDDO
                  IF         COND(&RUNTYP *EQ 'ED') THEN(DO)
                       SNDMSG     MSG('FX LIMITS REPORT - +
                            CLOSE OF BUSINESS') TOMSGQ(MRUNQ)
                       CALL       PGM(FX0110) PARM(&RUNTYP &RSEQ)
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
