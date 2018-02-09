/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Shadow posting of TI postings')              */
/*********************************************************************/
/*                                                                   */
/*       Midas/TI Interface                                          */
/*                                                                   */
/*       TIC0350 - I/C Shadow Posting of TI Postings                 */
/*                                                                   */
/*       Called by TIC0050                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Prev Amend No. 173172             Date 06Jan03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      162541             Date 09Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      156998             Date 11May99              */
/*                      144700             Date 30Oct98              */
/*                      139756             Date 24Aug98              */
/*                      CTI001   *Create   DATE 28Jun97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       173172 - Two TISHDPST jobs running simultaneously caused    */
/*                problems in I/C termination.                       */
/*       162541 - Guarantee to do projections before COB             */
/*       156998 - Close batches at end of day and on request         */
/*       144700 - Change the looping time from seconds to minutes   */
/*       139756 - Job submitted without ML overrides                 */
/*              - Commitment control scope incorrect                 */
/*       CTI001 - Midas/TI Interface (Phase 1)                       */
/*                                                                   */
/*********************************************************************/
/************PGM                                                  */ /*139756*/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)     /*139756*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STOP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&AOTIIN) TYPE(*CHAR) LEN(200)
             DCL        VAR(&TIMNWT) TYPE(*DEC) LEN(4 0)              /*144700*/
 /***********DCL        VAR(&TILOOP) TYPE(*DEC) LEN(4)     /*156998*/ /*162541*/
             DCL        VAR(&TIPRWT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                /*162541*/
             DCL        VAR(&NUMBER) TYPE(*CHAR) LEN(6)               /*162541*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('TIC0350 - TI I/C Shadow Posting of TI +
                          Postings') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
 
/* Lock data area TISHDPST to prevent subsequent submitting */
/* of TISHDPST job.                                         */
/**********  ALCOBJ     OBJ((TISHDPST *DTAARA *EXCL)) */              /*173172*/
             ALCOBJ     OBJ((TISHDPST *DTAARA *EXCL)) WAIT(0)         /*173172*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO +
                        CMDLBL(ENDPGM))                               /*173172*/
                                                                      /*162541*/
/* Retrieve job details and update data area with them */             /*162541*/
                                                                      /*162541*/
             RTVJOBA    USER(&USER) NBR(&NUMBER)                      /*162541*/
             CHGDTAARA  DTAARA(TI0350 (7 17)) VALUE(' ')              /*162541*/
             CHGDTAARA  DTAARA(TI0350 (7 10)) VALUE(&USER)            /*162541*/
             CHGDTAARA  DTAARA(TI0350 (18 6)) VALUE(&NUMBER)          /*162541*/
                                                                      /*162541*/
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area'))
 
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))         */ /*139756*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*139756*/
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))
 
/* Get Processing Wait Time */
             CHGVAR     VAR(&RTCD) VALUE('*MSG   ')
             CALL       PGM(AOTIINR0) PARM(&RTCD &OPTN &AOTIIN)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&TIPRWT) VALUE(%SST(&AOTIIN 41 2))
 
             CHGVAR     VAR(&TIMNWT) VALUE(%SST(&TIPRWT 1 2))         /*156998*/
                                                                      /*156998*/
 
 /*****   LOOP:       RTVDTAARA  DTAARA(TI0350) RTNVAR(&STOP)  */
 LOOP:       RTVDTAARA  DTAARA(TI0350 (1 5)) RTNVAR(&STOP)
             IF         COND(&STOP *EQ 'STOP') THEN(GOTO +
                          CMDLBL(ENDPGM))
 /***********                                              /*156998*/ /*162541*/
 /***********CHGVAR     VAR(&TILOOP) VALUE(&TILOOP + 1)    /*156998*/ /*162541*/
 /***********IF         COND(&TILOOP *LT &TIMNWT) THEN(DO) /*156998*/ /*162541*/
 /***********DLYJOB     DLY(60)                            /*156998*/ /*162541*/
 /***********GOTO       CMDLBL(LOOP)                       /*156998*/ /*162541*/
 /***********ENDDO                                         /*156998*/ /*162541*/
 /***********CHGVAR     VAR(&TILOOP) VALUE(0)              /*156998*/ /*162541*/
 /***********                                              /*156998*/ /*162541*/
             CALL       PGM(TI0350) PARM(&RTNCDE)
             IF         COND(&RTNCDE *EQ 'E') THEN(GOTO CMDLBL(ABNOR))
             IF         COND(&RTNCDE *EQ 'S') THEN(GOTO CMDLBL(ENDPGM))
/* Wait */
/************DLYJOB     DLY(&TIPRWT)  */                              /*144700*/
/************CHGVAR     &TIMNWT  VALUE(%SST(&TIPRWT 1 2))  /*144700*/ /*156998*/
/************CHGVAR     &TIMNWT  VALUE(&TIMNWT * 60)       /*144700*/ /*156998*/
/************DLYJOB     DLY(&TIMNWT)                       /*144700*/ /*156998*/
                                                                      /*162541*/
             CHGVAR     &TIMNWT  VALUE(%SST(&TIPRWT 1 2))             /*162541*/
             CHGVAR     &TIMNWT  VALUE(&TIMNWT * 60)                  /*162541*/
             DLYJOB     DLY(&TIMNWT)                                  /*162541*/
             GOTO       CMDLBL(LOOP)
 
/* Abnormal termination processing */
ABNOR:       ROLLBACK
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('TIC0350 - TI I/C Shadow Posting of TI +
                          Postings ended abnormally') TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:     IF         COND(&CMTCTL *EQ 'N') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/* Deallocate data area TISHDPST  */
             DLCOBJ     OBJ((TISHDPST *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
