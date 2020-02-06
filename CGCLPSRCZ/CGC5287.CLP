/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Create bulk requests')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5287  - Create Bulk Requests                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 235570             Date 30Aug05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      089362             Date 14Jun95              */
/*                      S01522             DATE 01MAY95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       235570 - Receiver value too small to hold result problem    */
/*                encountered when positions 112 to 114 of CGDTA     */
/*                equal to 999. Applied fix 229331.                  */
/*       089362 - &MBR_NAME already setup on 10 positions in CG5200  */
/*                and concatenation with &NUMA failed, so member     */
/*                already exists in CGPGENPD. Also reset last three  */
/*                positions to blanks.                               */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ACC_PATH &MBR_NAME &DTQE)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DTQE)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_PRTY)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR_NAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEW_NAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR_TEMP)    TYPE(*CHAR) LEN(10)         /*089362*/
             DCL        VAR(&ACC_PATH)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRV_MSG)     TYPE(*CHAR) LEN(7)                              /*235570*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&NUMA)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&NUM)         TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&NBR_RECS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGJOB     SWS(XXXXX000)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC5287 - Create Bulk Requests') +
                          TOMSGQ(MRUNQ)
/* */
/* Get next number to make member unique                             */
/* */
ADDMBR:
             RTVDTAARA  DTAARA(CGDTA (112 3)) RTNVAR(&NUMA)
             IF         COND(&NUMA *EQ '   ') THEN(DO)
             CHGVAR     VAR(&NUM) VALUE(1)
             ENDDO
             IF         COND(&NUMA *EQ '999') THEN(DO)                                    /*235570*/
             CHGVAR     VAR(&NUM) VALUE(1)                                                /*235570*/
             ENDDO                                                                        /*235570*/
             ELSE       CMD(DO)
             CHGVAR     VAR(&NUM) VALUE(&NUMA)
             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)
             ENDDO
             CHGVAR     VAR(&NUMA) VALUE(&NUM)
             CHGDTAARA  DTAARA(CGDTA (112 3)) VALUE(&NUMA)
/* */
/* Obtain the Job Number and set up the Member Name to add.          */
/* */
 
/************CHGVAR     VAR(&NEW_NAME) VALUE(&MBR_NAME *TCAT &NUMA)     089362*/
             CHGVAR     VAR(&MBR_TEMP) VALUE(%SST(&MBR_NAME 1 7))     /*089362*/
             CHGVAR     VAR(&NEW_NAME) VALUE(&MBR_TEMP *TCAT &NUMA)   /*089362*/
/* */
/* Add the new member to the print process extract file and override */
/* to it.                                                            */
/* */
             ADDPFM     FILE(CGPGENPD) MBR(&NEW_NAME) +
                          TEXT('Correspondence Items to Print')
             MONMSG     MSGID(CPF7306) EXEC(DO)                                           /*235570*/
             RCVMSG     MSGTYPE(*DIAG) MSGID(&PRV_MSG)                                    /*235570*/
             IF         COND(&PRV_MSG *EQ 'CPF5812') THEN(DO)                             /*235570*/
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)                                     /*235570*/
             ADDPFM     FILE(CGPGENPD) MBR(&MBR_NAME) +
                          TEXT('Correspondence Items to Print')                           /*235570*/
             ENDDO                                                                        /*235570*/
             ENDDO                                                                        /*235570*/
             OVRDBF     FILE(CGPGENPD) MBR(&NEW_NAME)
             OVRDBF     FILE(&ACC_PATH) MBR(&MBR_NAME)
/**/
/* Call process to transfer requests                     */
/**/
             CALL       PGM(CG5287) PARM(&RTN_CODE &ACC_PATH)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             DLTOVR     FILE(*ALL)
/**/
/* Prompt Bulk Request Jobs                              */
/**/
             CHGVAR     VAR(%SST(&DTQE 1 10)) VALUE(&NEW_NAME)
             CALL       PGM(CGC5284) PARM(&RTN_CODE &DTQE &MSG_PRTY)
/**/
             RTVMBRD    FILE(CGPGENPD) MBR(&MBR_NAME) +
                          NBRCURRCD(&NBR_RECS)
             IF         COND(&NBR_RECS *NE 0) THEN(DO)
             GOTO       CMDLBL(ADDMBR)
             ENDDO
/* */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5287 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5287 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
