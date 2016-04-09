/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Confirmation Matching Generation')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0210 - Confirmation Matching Generation                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. Bug4562 *CREATE    Date 21Sep05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       BUG4562- Confirmation Matching                              */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&ALLZ)                  *****************/
             PGM
 
/************DCL        VAR(&ALLZ) TYPE(*CHAR) LEN(1)     ************/
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* All zones */
/************IF         COND(&ALLZ = 'Y') THEN(GOTO CMDLBL(CALLPGM)) ***/
 
/* Get zone */
 
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                            */ /*BUG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG18886*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Generate nostro balances */
 
CALLPGM:     CALL       PGM(GOCFFEEGEN) PARM(&RTCD &ERMS &ZOZONE)
 
/* error */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0201 ended abnormally - see job log') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
