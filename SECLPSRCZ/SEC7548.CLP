/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate action allocation resume report')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/SEC7548 - Corporate Actions Allocation Report           */
/*                                                                   */
/*       Function: To print the Corporate Actions Allocation Report. */
/*                                                                   */
/*       Calls :   SE7548 - Corporate Action Allocation Report Prog. */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 136928  *CREATE    Date 16JUN98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  136928 - New Report created for CEU017, because the existing     */
/*           report SE7534P1 and SE7534P2 is too detail to be        */
/*           used as a quick check list.                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SLAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CARF) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DPRF) TYPE(*CHAR) LEN(6)
 
/* Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
/* Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
             CHGJOB   SWS(00000000)
 
             CHGVAR   VAR(&SLAL)    VALUE(%SST(&PARM 1 1))
             CHGVAR   VAR(&CARF)    VALUE(%SST(&PARM 2 6))
             CHGVAR   VAR(&OPTN)    VALUE(%SST(&PARM 8 2))
             CHGVAR   VAR(&BRCD)    VALUE(%SST(&PARM 10 3))
             CHGVAR   VAR(&DPRF)    VALUE(%SST(&PARM 13 6))
 
             CALL     PGM(SE7548) PARM(&RSEQ &RLEV &RENT &SLAL &CARF +
                                       &OPTN &BRCD &DPRF)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO     CMDLBL(END)
 
ABNOR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
               TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC7548 ENDED ABNORMALLY') +
               TOMSGQ(MOPERQ MRUNQ)
             MONMSG        MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
