/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Fwd Reval by NPV Method On Request Ctl')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0420 - Forward Revaluation by NPV Method (On-Request)    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CAS001  *CREATE    Date 23Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*                                                                   */
/*********************************************************************/
 
             PGM    PARM(&RSEQN &RLEVL &RENTY &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENTY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&BGNOST) TYPE(*CHAR) LEN(200)
             DCL        VAR(&METHOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)
 
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDMSG     MSG('DLC0420 - Fwd Revaluation by NPV Method'  ) +
                        TOMSGQ(MRUNQ)
 
/* Check if Analytical Accounting Module is Present */
 
             CHGVAR     VAR(&PRTCD) VALUE(*BLANKS)
             CHGVAR     VAR(&POPTN) VALUE('*FIRST')
             CALL       PGM(AOMMODR0) PARM(&PRTCD &POPTN &BGNOST)
               IF         COND(&PRTCD *NE '       ') THEN(GOTO +
                            CMDLBL(ABNOR))
 
             CHGVAR     VAR(&METHOD) VALUE(%SUBSTRING(&RPARM 1 1))
 
             IF         COND(&METHOD *NE '*') THEN(DO)
 
               IF         COND(%SST(&BGNOST 100 1) *EQ 'Y') THEN(DO)
                          CALL PGM(DL0421) PARM(&RSEQN &RENTY &METHOD)
               ENDDO
 
               IF         COND(%SST(&BGNOST 100 1) *NE 'Y') THEN(DO)
                          CALL PGM(DL0420) PARM(&RSEQN &RENTY &METHOD)
               ENDDO
 
             ENDDO
 
             ELSE       CMD(DO)
 
               IF         COND(%SST(&BGNOST 100 1) *EQ 'Y') THEN(DO)
 
                 CALL       PGM(DL0421) PARM(&RSEQN &RENTY 'N')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
                 CALL       PGM(DL0421) PARM(&RSEQN &RENTY 'F')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
                 CALL       PGM(DL0421) PARM(&RSEQN &RENTY 'B')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
                 CALL       PGM(DL0421) PARM(&RSEQN &RENTY 'D')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
               ENDDO
 
               ELSE       CMD(DO)
 
                 CALL       PGM(DL0420) PARM(&RSEQN &RENTY 'N')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
                 CALL       PGM(DL0420) PARM(&RSEQN &RENTY 'F')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
                 CALL       PGM(DL0420) PARM(&RSEQN &RENTY 'B')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
                 CALL       PGM(DL0420) PARM(&RSEQN &RENTY 'D')
                 RTVJOBA    SWS(&SWITCH)
                 IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                 ENDDO
 
               ENDDO
 
             ENDDO
 
             RTVJOBA SWS(&SWITCH)
 
             IF         COND(%SUBSTRING(&SWITCH 7 2) *EQ '00') THEN(DO)
               SNDPGMMSG  MSG('DLC0420 - Forward Revaluation by +
                             NPV Method report completed normally') +
                               TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             IF         COND(%SUBSTRING(&SWITCH 7 2) *NE '00') THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESAGE)
               SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MESAGE) +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGJOB SWS(00000000)
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('DLC0420 - Forward Revaluation by +
                           NPV Method Report ended abnormally') +
                             TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2001')
             ENDPGM
