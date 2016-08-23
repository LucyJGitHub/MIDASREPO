/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Charge Codes Audit Report')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       CL/SEC6300 - Safe Custody Fees Charge Codes Audit Report    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. S01464     *CREATE Date 04APR94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01464 - Safe Custody Fees                                  */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)
 
             DCL        VAR(&MRDT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/* */
/* Check Safe Custody Fees flag on Securities Trading ICD            */
/* */
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)
/* */
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)
/* */
/* Create LDA if not present                                         */
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/* */
/* Reset external switches                                           */
/* */
             CHGJOB     SWS(00000000)
/* */
/* If report running in Input Cycle, call SE6300 with parameter '2'  */
/* */
             IF         COND(&MODE *EQ '2') THEN(DO)
                  OVRDBF     FILE(SECGCDPD) SHARE(*YES)
                  OPNQRYF    FILE((SECGCDPD)) +
                               QRYSLT('SFRECI *NE ''*''') KEYFLD(*FILE)
 
                  CALL       PGM(SE6300) PARM('2' &RSEQ)
                  CLOF       OPNID(SECGCDPD)
                  DLTOVR     FILE(SECGCDPD)
             ENDDO
/* */
/* If report running in COB, select records changed today before     */
/* calling SE6300 with parameter of '1'                              */
/* */
             ELSE       CMD(DO)
/* */
/* Send program message */
/* */
                  SNDPGMMSG  MSG('SEC6300 - Safe custody charge codes +
                               audit report') TOMSGQ(MRUNQ) +
                               MSGTYPE(*INFO)
 
                  RTVDTAARA  DTAARA(SDSTAT (117 5)) RTNVAR(&MRDT)
/* */
/* Select records changed today                                      */
/* */
                  OVRDBF     FILE(SECGCDPD) SHARE(*YES)
                  OPNQRYF    FILE((SECGCDPD)) +
                               QRYSLT('RDATE *EQ "' *CAT &MRDT *CAT '"') +
                               KEYFLD(*FILE) MAPFLD((WDATE SFLCD *ZONED +
                               5) (RDATE WDATE *CHAR 5))
 
                  CALL       PGM(SE6300) PARM('1' &RSEQ)
                  CLOF       OPNID(SECGCDPD)
                  DLTOVR     FILE(SECGCDPD)
 
             ENDDO
/* */
/* Process any database error                                        */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                               MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/* */
             ENDDO
/* */
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
          ENDPGM
