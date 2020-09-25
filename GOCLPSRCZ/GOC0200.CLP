/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Currency Position Generation')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0200 - Currency Position Generation                      */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. AR898898           Date 24Jun14              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      239642             Date 01Jun06              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR898898 - If Duplicate key error was still encountered     */
/*                  after 2 retries, program will just send a        */
/*                  message and end. Amended to fail program if      */
/*                  duplicate key error is still encountered after   */
/*                  2 retries (Child: AR909227)                      */
/*                - Applied fix for MD027668                         */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       239642 - When RNX1021 (duplicate key) is encoutered due to  */
/*                slow machine response, retry execution of GPCCYPGEN*/
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ALLZ)

             DCL        VAR(&ALLZ) TYPE(*CHAR) LEN(1)

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RETRY) TYPE(*DEC) VALUE(0)                                   /*239642*/
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)

/* All zones */
             IF         COND(&ALLZ = 'Y') THEN(GOTO CMDLBL(CALLPGM))

/* Get zone */

             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)

/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                           */ /*BUG18886 */
             IF         COND(&RTCD *NE '       ') THEN(DO)                             /*BUG18886 */
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Generate currency positions */

CALLPGM:     CALL       PGM(GPCCYPGEN) PARM(&RTCD &ERMS &ZOZONE)

             IF COND(%SWITCH(XXXX1XXX)) THEN(DO)
             IF         COND(&RETRY = 2) THEN(DO)                                         /*239642*/
             SNDPGMMSG  MSGID(CPF5009) MSGF(QCPFMSG) +
                          MSGDTA('Duplicate key error. See +
                          joblog.') TOMSGQ(MOPERQ MRUNQ)                                  /*239642*/
             CHGJOB     SWS(XXXXXX11)                                                   /*AR898898*/
                        DMPCLPGM                                                        /*AR898898*/
/**********  GOTO       CMDLBL(END) */                                                  /*AR898898*/
             GOTO       CMDLBL(ERROR)                                                   /*AR898898*/
             ENDDO                                                                        /*239642*/
             DLYJOB     DLY(30)                                                           /*239642*/
             CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)                                     /*239642*/
             CHGJOB     SWS(XXXX0XXX)                                                     /*239642*/
             GOTO       CMDLBL(CALLPGM)                                                   /*239642*/
             ENDDO                                                                        /*239642*/
/* error */
ERROR:                                                                                  /*AR898898*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0200 ended abnormally - see job log') +
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
                          Finastra International Limited')
             ENDPGM
