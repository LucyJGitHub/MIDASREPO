/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Print Process for single selection')     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5220  - Print process for single selection               */
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
/*       Prev Amend No. CPK009             Date 09Jul99              */
/*                      CCG009             Date 01Jun95              */
/*                      086133             DATE 09MAR95              */
/*                      S01522             DATE 05DEC94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCG009 - Private Banking UDC                                */
/*       086133 - Add MultiLanguage Override                         */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
 
/* Hello                                                             */
             PGM        PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters received from  RCF                                     */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)   /* sequence */
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)   /* level    */
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)   /* branch   */
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100) /* parm     */
             DCL        VAR(&RARCH) TYPE(*CHAR) LEN(1)   /* Archive  */
             DCL        VAR(&TRNO)  TYPE(*CHAR) LEN(6)   /* Trans.No * /CCG009*/
             DCL        VAR(&TRNO2) TYPE(*CHAR) LEN(8)   /* Trans.No * /CCG009*/
             DCL        VAR(&MODI)  TYPE(*CHAR) LEN(2)   /* Module ID* /CCG009*/
             DCL        VAR(&MODI2) TYPE(*CHAR) LEN(4)   /* Module ID* /CCG009*/
 
/* Other declarations                                                */
             DCL        VAR(&DTQE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOB_NO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBR_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CORR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CORR2) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG_PRTY)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECS) TYPE(*CHAR) LEN(1) VALUE('N')
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Start commitment control                                          */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)
 
/* Send message to MRUNQ                                             */
             SNDPGMMSG  MSG('CGC5220 - Print process for single +
                          selection') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches                                  */
             CHGJOB     SWS(XXXXXX00)
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)             /*086133*/
             OVRMSGF    MSGF(MIDAS   ) TOMSGF(GBMIDAS   )             /*086133*/
 
/* Obtain the Job Number and set up the Member Name to add.          */
             RTVJOBA    NBR(&JOB_NO)
             CHGVAR     VAR(&MBR_NAME) VALUE('          ')
             CHGVAR     VAR(&MBR_NAME) VALUE('S' *TCAT &JOB_NO)
 
             CHGVAR     VAR(&RARCH) VALUE(%SST(&RPARM 94 1))
/* Add the new member to the print process extract file and override */
/* to it.                                                            */
             ADDPFM     FILE(CGPGENPD) MBR(&MBR_NAME) +
                          TEXT('Correspondence Items to Print')
             OVRDBF     FILE(CGPGENPD) MBR(&MBR_NAME)
 
/* Build selection for this record only                              */
             CHGVAR     VAR(&ITEM) VALUE(%SST(&RPARM 1 8))
             CHGVAR     VAR(&TRNO)  VALUE(%SST(&RPARM 64 6))          /*CCG009*/
             CHGVAR     VAR(&TRNO2) VALUE('"' *cat &TRNO *cat '"')    /*CCG009*/
             CHGVAR     VAR(&MODI)  VALUE(%SST(&RPARM 70 2))          /*CCG009*/
             CHGVAR     VAR(&MODI2) VALUE('"' *cat &MODI *cat '"')    /*CCG009*/
             CHGVAR     VAR(&CORR) VALUE(%SST(&RPARM 9 10))
             CHGVAR     VAR(&CORR2) VALUE('"' *cat &CORR *cat '"')
             IF         COND(&TRNO *EQ '      ')  THEN(DO)            /*CCG009*/
             CHGVAR     VAR(&SELECT) VALUE('DRITEM *eq ' *cat +
                          &ITEM *cat ' *and ' *cat ' DRDCOR *eq +
                          ' *cat &CORR2)
             ENDDO                                                    /*CCG009*/
             IF         COND(&TRNO *NE '      ')  THEN(DO)            /*CCG009*/
             CHGVAR     VAR(&SELECT) VALUE('DRMTRN *eq ' *CAT &TRNO2 +
                          *CAT ' *and ' *CAT ' DRMODI *eq ' *CAT +
                          &MODI2 *CAT ' *and ' *CAT ' DRDCOR *eq ' +
                          *CAT &CORR2)                                /*CCG009*/
             ENDDO                                                    /*CCG009*/
 
/* Open query file                                                   */
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
 
/* Call the print process extract program                            */
             CALL       PGM(CG5100) PARM(&RSEQ &RLVL &RBCH &RPARM +
                          &RECS &RARCH)
 
             IF         COND(&RARCH *EQ 'A') THEN(DO)
             CLOF      OPNID(CGXDCRPD)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ELSE       CMD(DO)
             CLOF      OPNID(CGUDCRPD)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Check for Database errors trapped by program                      */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
/* If records have been extracted format and send dtaq entry         */
/* otherwise remove member                                           */
             IF         COND(&RECS *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&DTQE) VALUE(&MBR_NAME *CAT 'CGPGENL2  ' +
                          *CAT &RSEQ *CAT &RLVL *CAT &RBCH *CAT &RARCH)
             CHGVAR     VAR(&MSG_PRTY) VALUE('High')
             CALL       PGM(CGC5204) PARM(&RTN_CODE &DTQE &MSG_PRTY)
             ENDDO
             ELSE       CMD(DO)
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)
             ENDDO
 
/* Terminate Program normally                                        */
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination processing                                   */
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC5220 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5220 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Bye                                                               */
             ENDPGM
