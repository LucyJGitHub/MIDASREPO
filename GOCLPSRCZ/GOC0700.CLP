/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Update Current Global Historic Balances')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0700 - Update Current Global Historic Balances           */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGP010 - Global BSPL                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SUBMIT)
 
             DCL        VAR(&SUBMIT) TYPE(*CHAR) LEN(1)
 
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
             DCL        VAR(&O#YEAR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&O#MONTH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0700 - Update Current Global Historic +
                          Balances') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
 
/* SUBMIT (IF REQUIRED) */
 
             IF         COND(&SUBMIT = 'Y') THEN(DO)
             SBMJOB JOB(UPDATGHIBL) CMD( +
             CALL PGM(GOC0700) PARM('N') ) +
             JOBD(MBATCH) RTGDTA(*JOBD) OUTQ(*JOBD) INLLIBL(*JOBD) USER(*JOBD)
             RETURN
             ENDDO
 
 
/* GET THE ZONE */
 
                CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                             &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                             &ZONJOB)
/**********     IF         COND(&RTCD**= '       ') THEN(DO)                          */ /*BG18886*/
                IF         COND(&RTCD *NE '       ') THEN(DO)                            /*BG18886*/
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 
/* ALLOCATE FILE UPDATED */
 
             ALCOBJ     OBJ((GPHIBLPD *FILE *EXCL)) WAIT(30)
 
 
             CLRPFM     FILE(GPWHIBLPD)
 
 
/* SET CURRENT GLOBAL HISTORIC BALANCES */
 
             OVRDBF     FILE(GZACCNTAB) SEQONLY(*YES 1000)
             OVRDBF     FILE(GPWHIBLPD) SEQONLY(*YES 5000)
 
             CALL       PGM(GOSETCHIB) PARM(&RTCD &ERMS &ZOZONE &O#YEAR &O#MONTH)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* OPEN DATA PATH TO GPHIBLPD FOR CURRENT ZONE, YEAR AND MONTH */
 
             CLOF       OPNID(GPHIBLL1)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(GPHIBLL1) SHARE(*YES) OPNSCOPE(*JOB)
 
             OPNQRYF    FILE((GPHIBLL1)) OPTION(*ALL) +
                          QRYSLT('HBZONE     *EQ "' *CAT &ZOZONE +
                          *CAT '"  *AND YR *EQ ' *CAT &O#YEAR *CAT +
                          ' *AND PR *EQ ' *CAT &O#MONTH) +
                          KEYFLD((YR) (PR) (BRCA) (CCY) (ACOD) +
                          (CNUM) (ACSQ)) OPNSCOPE(*JOB)
 
 
/* OVERRIDE READ OF GPWHIBKPD */
 
             OVRDBF     FILE(GPWHIBLPD) SEQONLY(*YES 2000)
 
/* OVERRIDE WRITE TO GPHIBLPD */
 
             OVRDBF     FILE(GPHIBLPD) SEQONLY(*YES 2000)
 
 
/*  UPDATE CURRENT GLOBAL HISTORIC BALANCES */
 
             CALL       PGM(GOUPDCHIB)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOC0700 ended abnormally - see job log') +
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
             DLCOBJ     OBJ((GPHIBLPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CLOF       OPNID(GPHIBLL1)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(GZACCNTAB)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(GPWHIBLPD)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(GPHIBLL1)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(GPHIBLPD)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
