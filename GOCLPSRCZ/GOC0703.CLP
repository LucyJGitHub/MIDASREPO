/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Update BSPL Analysis File')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0703 - Update BSPL Analysis File                         */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG6543            Date 08Apr05              */
/*                      CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG6543 - MRTRAPXPD file is not purged.                     */
/*       CGP010 - Global BSPL                                        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&SWS)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0703 - BSPL Analysis File') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
 
/* GET THE ZONE */
 
                CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                             &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                             &ZONJOB)
/**********     IF         COND(&RTCD**= '       ') THEN(DO)                          */ /*BG18886*/
                IF         COND(&RTCD *NE '       ') THEN(DO)                            /*BG18886*/
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 
/* OVERRIDES */
 
/*********** OVRDBF     FILE(MRTRAPPD) SEQONLY(*YES 1000) ****************/              /*BUG6543*/
             OVRDBF     FILE(MRTRAPXPD) TOFILE(MRTRAPXPD) +
                          MBR(MRTRAPXPD) SEQONLY(*YES 1000)                              /*BUG6543*/
             OVRDBF     FILE(GOBSANEPD) SEQONLY(*YES 1000)
 
/* CLEAR EXTRACT FILE */
 
             CLRPFM     FILE(GOBSANEPD)
 
 
/* BSPL ANALYSIS FILE EXTRACT */
 
             CALL       PGM(GOBSANEXT) PARM(&ZOZONE)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* OVERRIDES */
 
             OVRDBF     FILE(GOBSANEPD) SEQONLY(*YES 1000)
             OVRDBF     FILE(GOBSANSPD) SEQONLY(*YES 1000)
 
/* CLEAR SUMMARY FILE */
 
             CLRPFM     FILE(GOBSANSPD)
 
 
/* BSPL ANALYSIS FILE SUMMARY */
 
             CALL       PGM(GOBSANSUM) PARM(&ZOZONE)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* OPEN DATA PATH TO GPBSANPD FOR CURRENT ZONE */
 
             CLOF       OPNID(GPBSANL0)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(GPBSANL0) SHARE(*YES) OPNSCOPE(*JOB)
 
             OPNQRYF    FILE((GPBSANL0)) OPTION(*ALL) +
                          QRYSLT('A1ZONE     *EQ "' *CAT &ZOZONE +
                          *CAT '"') KEYFLD((A1ZONE) (YR) (PR) (BRCA) (CCY) +
                          (ACOD) (EPBLDC) (ANLYSC)) OPNSCOPE(*JOB)
 
 
/* OPEN DATA PATH TO GOBSANSPD */
 
             CLOF       OPNID(GOBSANSPD)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(GOBSANSPD) SHARE(*YES) OPNSCOPE(*JOB) +
                          SEQONLY(*YES 1000)
 
             OPNQRYF    FILE((GOBSANSPD)) OPTION(*INP) +
                          KEYFLD((YR) (PR) (BRCA) (CCY) +
                          (ACOD) (EPBLDC) (ANLYSC)) OPNSCOPE(*JOB)
 
 
/* OVERRIDE WRITE TO GPBSANPD */
 
             OVRDBF     FILE(GPBSANPD) SEQONLY(*YES 2000)
 
 
/* UPDATE GLOBAL BSPL ANALYSIS FILE */
 
             CALL       PGM(GOBSANUPD) PARM(&ZOZONE)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOC0703 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
             CLOF       OPNID(GPBSANL0)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(GOBSANSPD)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
