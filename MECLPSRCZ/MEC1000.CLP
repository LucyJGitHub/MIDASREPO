/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Control print of IMM transactions')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1000 - Control call to selection processing              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD055961           Date 08Jun20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT006             Date 06Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      140636             Date 18Aug98              */
/*                      S01435             Date 19Aug93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055961 - Outgoing Payments HATs option and messages to be */
/*                  processed thru FT in error end in error (ERZ248) */
/*       MD046248 - Finastra Rebranding                              */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CFT006 - Addition of RFT and CCT id to SDFTFRPD (recompile) */
/*       140636 - Submit Message Genration if allowed by FT ICD.     */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &BRANCH &FT_PROC)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FT_PROC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCLF       FILE(SDFTFRPD)                               /*140636*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1000 - ME Selection processing') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* If allocation of MEINMRPD allowed then clear */
/* */
             ALCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(MISS_CLEAR)
             ENDDO
             CLRPFM     FILE(MEINMRPD)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
 MISS_CLEAR:
             ALCOBJ     OBJ((MEINMRPD *FILE *SHRUPD)) WAIT(600)
/* */
/* Run ME1000 - Imm Selection  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             OVRDBF     FILE(OTPAYQL0) OVRSCOPE(*JOB) SHARE(*NO)    /*MD055961*/
             CALL       PGM(ME1000) PARM(&RTN_CODE &ACTION &BRANCH +
                          &FT_PROC)
             DLTOVR     FILE(OTPAYQL0) LVL(*JOB)                    /*MD055961*/
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* Automatic call of Pay/Receive Indicator - */                      /*140636*/
/**/                                                                 /*140636*/
             RCVF       RCDFMT(SDFTFRD0)                             /*140636*/
             IF         COND((&BTAFTM = 'Y')) THEN(DO)               /*140636*/
/**/                                                                 /*140636*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                 /*140636*/
/**/                                                                 /*140636*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +                         /*CPK014*/
/************             RQSDTA('CALL PGM(FTC0630) PARM('''' '''' +                      /*CPK014*/
/************             '''' )') INLLIBL(*JOBD)                    /*140636*/           /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)  /*140636*/           /*CPK014*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +                       /*CSC023*/
/************             PARM('''' '''' '''' )') INLLIBL(*JOBD)               /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +
                          PARM('''' '''' '''' )') INLLIBL(*JOBD) OUTQ(*JOBD)              /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO                                                   /*140636*/
/**/
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
             SNDPGMMSG  MSG('Program MEC1000 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1000 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* */
/* CALL ME1070 to remove any remaining reserved electronic msgs*/
/* */
 ENDCLPGM:   ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CALL       PGM(ME1070) PARM('*END    ' X'000000000F' +
                          X'000F' ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             COMMIT
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *SHRUPD))
             MONMSG     MSGID(CPF0000)
/* */
             ENDPGM
