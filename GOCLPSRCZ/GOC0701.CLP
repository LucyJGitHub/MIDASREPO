/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Update Global Historic Balances')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0701 - Update Global Historic Balances                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
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
                          Misys International Banking Systems Ltd. +
                          2005')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0701 - Update Global Historic +
                          Balances') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
 
/* GET THE ZONE */
 
                CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                             &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                             &ZONJOB)
/**********     IF         COND(&RTCD *= '       ') THEN(DO)                          */ /*BG18886*/
                IF         COND(&RTCD *NE '       ') THEN(DO)                            /*BG18886*/
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 
/* ALLOCATE FILE UPDATED */
 
             ALCOBJ     OBJ((GPHIBLPD *FILE *EXCL)) WAIT(30)
 
 
/* OPEN DATA PATH TO GPHIBLPD FOR CURRENT ZONE */
 
             CLOF       OPNID(GPHIBLL0)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(GPHIBLL0) SHARE(*YES) OPNSCOPE(*JOB)
 
             OPNQRYF    FILE((GPHIBLL0)) OPTION(*ALL) +
                          QRYSLT('HBZONE     *EQ "' *CAT &ZOZONE +
                          *CAT '"') KEYFLD((HBZONE) (YR) (PR) (BRCA) (CCY) +
                          (ACOD) (CNUM) (ACSQ)) OPNSCOPE(*JOB)
 
 
/* OPEN DATA PATH TO MRHIBLPD */
 
             CLOF       OPNID(MRHIBLL5)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(MRHIBLL5) SHARE(*YES) OPNSCOPE(*JOB) +
                          SEQONLY(*YES 1000)
 
             OPNQRYF    FILE((MRHIBLL5)) OPTION(*INP) +
                          QRYSLT('CAFI *EQ "C" *AND PERTYP = "M"') +
                          KEYFLD((YR) (PR) (BRCA) (CCY) +
                          (ACOD) (CNUM) (ACSQ)) OPNSCOPE(*JOB)
 
 
/* OVERRIDE WRITE TO GPHIBLPD */
 
             OVRDBF     FILE(GPHIBLPD) SEQONLY(*YES 2000)
 
 
/* UPDATE GLOBAL HISTORIC BALANCES  */
 
             CALL       PGM(GOUPDHIBL) PARM(&ZOZONE)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOC0701 ended abnormally - see job log') +
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
 
             CLOF       OPNID(GPHIBLL0)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(MRHIBLL5)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
