/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER Collateral Review Report')               */
/*********************************************************************/
/*                                                                   */
/*       Finastra - European Reporting                               */
/*                                                                   */
/*       ERC0930 - ER Collateral Review Report                       */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX004             Date 06Feb97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX004 - Capital Adequacy                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQ &PLVL &PENT)
 
             DCL        VAR(&PSEQ) TYPE(*CHAR) LEN(5)             /* SEQUENCE */
             DCL        VAR(&PLVL) TYPE(*CHAR) LEN(1)                /* LEVEL */
             DCL        VAR(&PENT) TYPE(*CHAR) LEN(3)               /* ENTITY */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('ERC0930 - Guarantees & Collateral +
                          Review Report') TOMSGQ(MRUNQ)
 
             CALL       PGM(ER0930) PARM(&PSEQ &PLVL &PENT)
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            ERC0930 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
             SNDMSG     MSG('ERC0930 - Collateral Review Report +
                          Terminated Abnormally.') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
 END:        CHGVAR     VAR(&ACTCPY) VALUE('(c) Finastra International +
                           Limited 2005')
             ENDPGM
