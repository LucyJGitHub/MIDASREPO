/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Print Process Extract Control')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC5230  - Print Process Extract Control                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. 245055             Date 15Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 241824             Date 06Oct06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      CCG009             DATE 01JUN95              */
/*                      087933             DATE 18MAY95              */
/*                      086133             DATE 09MAR95              */
/*                      S01522             DATE 05DEC94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       245055 - Reverse 241824.                                    */
/*       241824 - Allow print process request by Module Id and       */
/*                by Extract Date.                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCG009 - Private Banking UDC                                */
/*       087933 - Add CGPGENL4 member                                */
/*       086133 - Add MultiLanguage Override                         */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
 
             PGM        PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Parameters received for RCF                                       */
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
/*           DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)*/                          /*241824*/
/*           DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(115)*/                   /*241824*245055*/
             DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)                            /*245055*/
             DCL        VAR(&OPTIONS)     TYPE(*CHAR) LEN(256)
 
/* General                                                           */
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&DTQE)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_PRTY)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB_NO)      TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBR_NAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECS)        TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&LAST_CNF)    TYPE(*CHAR) LEN(1)          /*087933*/
 
 
/* Used for query selection criteria */
             DCL        VAR(&SELECT)      TYPE(*CHAR) LEN(512)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&USER)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACC_PTH)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACC_PTHEND)  TYPE(*CHAR) LEN(2)          /*CCG009*/
             DCL        VAR(&RARCH)       TYPE(*CHAR) LEN(1)
/*           DCL        VAR(&EXDT)       TYPE(*CHAR) LEN(7)*/                      /*241824*245055*/
/*           DCL        VAR(&MODI)       TYPE(*CHAR) LEN(2)*/                      /*241824*245055*/
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Copyright Statement                                               */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('CGC5230 - Print Process Extract') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)             /*086133*/
             OVRMSGF    MSGF(MIDAS   ) TOMSGF(GBMIDAS   )             /*086133*/
 
/* Start Commitment Control */
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)
 
 
/* Retrieve constituent data from &RPARM                             */
             CHGVAR     VAR(&USER    ) VALUE(%SST(&RPARM 1 10))
/*********** CHGVAR     VAR(&ACC_PTH ) VALUE(%SST(&RPARM 62 10)) **** /*CCG009*/
             CHGVAR     VAR(&ACC_PTHEND) VALUE(%SST(&RPARM 62 2))     /*CCG009*/
             CHGVAR     VAR(&ACC_PTH) VALUE('CGPGEN' *CAT +
                          &ACC_PTHEND)                                /*CCG009*/
             CHGVAR     VAR(&RARCH   ) VALUE(%SST(&RPARM 94 1))
             CHGVAR     VAR(&LAST_CNF) VALUE(%SST(&RPARM 97 1))       /*087933*/
/*           CHGVAR     VAR(&EXDT    ) VALUE(%SST(&RPARM 98 7))*/                  /*241824*245055*/
/*           CHGVAR     VAR(&MODI    ) VALUE(%SST(&RPARM 105 2))*/                 /*241824*245055*/
 
 
/* Obtain the Job Number and set up the Member Name to add.          */
             RTVJOBA    NBR(&JOB_NO)
             CHGVAR     VAR(&MBR_NAME) VALUE('          ')
             CHGVAR     VAR(&MBR_NAME) VALUE('G' *TCAT &JOB_NO)
 
 
/* Add the new member to the Print Process Extract file and override */
/* to it.                                                            */
             ADDPFM     FILE(CGPGENPD) MBR(&MBR_NAME) +
                          TEXT('Correspondence Items to Print')
             OVRDBF     FILE(CGPGENPD) MBR(&MBR_NAME)
 
 
/* Set up Selection strings for OPNQRYF over UDC Correspondence      */
/* Reference Record.                                                 */
             CALL    PGM(CGC5420) PARM(&RPARM &RBCH &SELECT &OPTIONS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNORMAL)
                ENDDO
 
 
/* Override database file CGUDCRPD/CGXDCRPD and open query file */
 
             IF         COND(&SELECT *EQ ' ') THEN(DO)
                CHGVAR VAR(&SELECT) VALUE('*ALL')
                ENDDO
 
             IF         COND(&RARCH *EQ 'A') THEN(DO)
             OVRDBF     FILE(CGXDCRL0) SHARE(*NO)
             OVRDBF     FILE(CGXDCRPD) SHARE(*YES)
             OPNQRYF    FILE((CGXDCRPD)) OPTION(*ALL) QRYSLT(&SELECT)
             ENDDO
 
             ELSE       CMD(DO)
             OVRDBF     FILE(CGUDCRL0) SHARE(*NO)
             OVRDBF     FILE(CGUDCRPD) SHARE(*YES)
             OPNQRYF    FILE((CGUDCRPD)) OPTION(*ALL) QRYSLT(&SELECT)
             ENDDO
 
 
/* Call the Print Process Extract Program                            */
 
             CALL    PGM(CG5100) PARM(&RSEQ &RLVL &RBCH &RPARM &RECS +
                                      &RARCH)
 
             IF         COND(&RARCH *EQ 'A') THEN(DO)
             CLOF      OPNID(CGXDCRPD)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ELSE       CMD(DO)
             CLOF      OPNID(CGUDCRPD)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNORMAL)
                ENDDO
 
 
/* If Records have been extracted...                                 */
/* ... Format and Send Data Queue entry use prompt program           */
 
             IF         COND(&RECS *EQ 'Y') THEN(DO)
 
/**********  CHGVAR     VAR(&DTQE) VALUE(&MBR_NAME *CAT &ACC_PTH +     *087933*/
/**********               *CAT &RSEQ *CAT &RLVL *CAT &RBCH *CAT &RARCH) 087933*/
             CHGVAR     VAR(&DTQE) VALUE(&MBR_NAME *CAT &ACC_PTH +
                          *CAT &RSEQ *CAT &RLVL *CAT &RBCH *CAT +
                          &RARCH *CAT &LAST_CNF)                      /*087933*/
             CHGVAR     VAR(&MSG_PRTY) VALUE('Normal')
             CALL       PGM(CGC5204) PARM(&RTN_CODE &DTQE &MSG_PRTY)
                         ENDDO
 
             ELSE       CMD(DO)
 
                 RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)
                         ENDDO
 
 
/* Terminate Program normally                                        */
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5230 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5230 ended abnormally') MSGTYPE(*ESCAPE)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
