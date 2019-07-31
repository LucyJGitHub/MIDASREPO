/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Selection Criterion Generation I/C')         */
/*********************************************************************/
/*                                                                   */
/*  Midas - Customer Lending Module                                  */
/*                                                                   */
/*  LEC3520 -  Selection Criterion Generation I/C - Control          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU021  *CREATE    Date 05May98              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU021 - EMU LE Facility Currency Conversion                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&REFR &BRCA &CNUM &FCCY &FACT &FCNO +
                          &ACTN &RTCD)
 
/* ---------------------------------------------------------------------------*/
/* Define variables.                                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(01)   /* Action Code       */
             DCL        VAR(&BRCA) TYPE(*CHAR) LEN(03)   /* Branch            */
             DCL        VAR(&CNUM) TYPE(*CHAR) LEN(06)   /* Customer          */
             DCL        VAR(&FACT) TYPE(*CHAR) LEN(03)   /* Facility Type     */
             DCL        VAR(&FCCY) TYPE(*CHAR) LEN(03)   /* Facility Currency */
             DCL        VAR(&FCNO) TYPE(*CHAR) LEN(02)   /* Facility Number   */
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)   /* Message           */
             DCL        VAR(&QRSL) TYPE(*CHAR) LEN(256)  /* Query String      */
             DCL        VAR(&REFR) TYPE(*CHAR) LEN(10)   /* Reference         */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(2)    /* Return Code       */
/*----------------------------------------------------------------------------*/
/* Initialisation.                                                            */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA DTAARA(LDA) +
                          TYPE(*CHAR) LEN(256) VALUE(' '))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*----------------------------------------------------------------------------*/
/* Process Insert.                                                            */
 
             IF         COND(&ACTN *EQ 'I') THEN(DO)
              CALL       PGM(LE3530) PARM(&BRCA &CNUM &FCCY &FACT +
                           &FCNO &QRSL)
 
              IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR9000)
 
              OVRDBF     FILE(FCLTY1) SHARE(*YES)
              OPNQRYF    FILE((FCLTY1)) OPTION(*INP) QRYSLT(&QRSL)
 
              CALL       PGM(LE3540) PARM(&REFR)
 
              CLOF       OPNID(FCLTY1)
 
              IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR9000)
 
              GOTO       CMDLBL(END)
             ENDDO
/*----------------------------------------------------------------------------*/
/* Process Delete.                                                            */
 
             IF         COND(&ACTN *EQ 'D')     THEN(DO)
              OVRDBF     FILE(LEFCUPL0) SHARE(*YES)
              OPNQRYF    FILE((LEFCUPL0)) OPTION(*INP *DLT) +
                         QRYSLT('FSREFR *EQ "' *CAT &REFR  +
                         *CAT '"')
 
              CALL       PGM(LE3550)
 
              CLOF       OPNID(LEFCUPL0)
 
              IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERR9000)
 
              GOTO       CMDLBL(END)
             ENDDO
/*----------------------------------------------------------------------------*/
/* Send Error Message and Exit Program.                                       */
 
 ERR9000:    RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
/*----------------------------------------------------------------------------*/
/* Process Error.                                                             */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        LEC3520 ended abnormally - see job log') +
                        TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/*----------------------------------------------------------------------------*/
/* Exit Program.                                                              */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
/*============================================================================*/
