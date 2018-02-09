/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Statements for time/call deposits')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0767 - Statements for Time/Call Deposits                 */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6474            Date 18Apr05              */
/*                      CDL012  *CREATE    Date 12Aug03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6474 (00041016) - Commitment definition not valid.       */
/*       CDL012 - Interest Statements for Call/Time Deposits.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RDATA) TYPE(*CHAR) LEN(18)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('  DMLIB')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('  DPLIB')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(80)
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
                                                                                         /*BUG6474*/
/** Global monitor message */                                                            /*BUG6474*/
                                                                                         /*BUG6474*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                 /*BUG6474*/
                                                                                         /*BUG6474*/
             SNDPGMMSG  MSG('DLC0767 - Statements for Time/Call +
                          deposits') TOMSGQ(MRUNQ)                                       /*BUG6474*/
                                                                                         /*BUG6474*/
             CHGJOB     SWS(XXXXXX00)                                                    /*BUG6474*/
                                                                                         /*BUG6474*/
/** Start commitment control */                                                          /*BUG6474*/
                                                                                         /*BUG6474*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                 /*BUG6474*/
             MONMSG     MSGID(CPF8351)                                                   /*BUG6474*/
 
/* Access Midas Modules File */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          on access to ICD file SDMMODPD') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
 
/* If either position is blank, this is an error */
             IF         COND(%SST(&SDSTAT 6 2) *EQ ' ') THEN(DO)
 
/* If it is, send message and terminate */
             CHGVAR     VAR(&MESSAGE) VALUE(' ')
             CHGVAR     VAR(&MESSAGE) VALUE('The Midas System Prefix +
                          has not been set up')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Set up the names of the DMLIB using the  +
   system prefix so the file can be overriden  */
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(%SST(&DPLIB 1 2)) VALUE(%SST(&SDSTAT 6 2))
 
             CHKOBJ     OBJ(&DPLIB/DLTCSTPT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
 
             CRTDUPOBJ  OBJ(DLTCSTPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(DLTCSTPT)
             ENDDO
 
/**********  SNDPGMMSG  MSG('Statements for Time/Call deposits') + */                    /*BUG6474*/
/**********               TOMSGQ(MRUNQ)                            */                    /*BUG6474*/
 
/* Reset Job Switches */
             CHGJOB     SWS(00000000)
 
/* If Correspondence Manager is installed */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
/**********     STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +    */                    /*BUG6474*/
/**********                  CMTSCOPE(*JOB)                        */                    /*BUG6474*/
                CLRPFM     FILE(CGTCSTPD)
/* Override the Reference File for Non-Comit Control                 */
                OVRDBF     FILE(EXUDCRPD) TOFILE(CGUDCRPD) SECURE(*YES) +
                             SHARE(*NO)
             ENDDO
 
             CHGVAR     VAR(&RDATA) VALUE(%SST(&RPARM 1 18))
             CALL       PGM(DL0767) PARM(&RSEQ &RLEV &RENT &RDATA)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR     VAR(&MESSAGE) VALUE('Error in printing +
                             statements for Time/Call deposits')
                SNDMSG     MSG(&MESSAGE) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(%SWITCH(1XXXXXXX)) THEN(CHGVAR +
                          VAR(&PARENT) VALUE('Y'))
             ELSE       CMD(CHGVAR VAR(&PARENT) VALUE('N'))
 
/* If Correspondence Manager is installed */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
/** Call Extract File Instance Management */
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')
             CALL       PGM(CGC3605) PARM(&ACTION)
 
/** Call Extract Program                  */
             CALL       PGM(CG4530) PARM(&W0RTN &W0CMT &PARENT &RDATA)
 
/** Reclaim resource                      */
             RCLRSC
 
/** Error in extract program              */
             IF         COND(&W0RTN *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('CG4530-User Defined Correspondence Extract +
                             failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                             MRUNQ) MSGTYPE(*INFO)
                ROLLBACK
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** Call Custom Defined Data Extract pgm */
             CALL       PGM(CGC3604)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Prompt for immediate print */
             CALL       PGM(CGC5217) PARM(' ')
             MONMSG     MSGID(CPF0000)
 
             ENDDO
 
/* SKIP abnormal processing  */
             GOTO       CMDLBL(END)
 
ABNOR:
/* UDC module must be on in order to call a Correspondence Manager program */
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')
                CALL       PGM(CGC3605) PARM(&ACTION)
             ENDDO
 
             DMPCLPGM                                                                    /*BUG6474*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG6474*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                   /*BUG6474*/
 
/* Abnormal termination - batch job */
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0767 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             ROLLBACK                                                                    /*BUG6474*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6474*/
 
 
END:
             ENDCMTCTL                                                                   /*BUG6474*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6474*/
                                                                                         /*BUG6474*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
