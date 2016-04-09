/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI I/c journal entry gen of TI postings')       */
/********************************************************************/
/*                                                                  */
/*       Midas/Trade Innovation Interface Module                    */
/*                                                                  */
/*       TIC0340 - I/C Journal Entry Generation Of TI Postings      */
/*                                                                  */
/*       Function : This is the controlling component for the       */
/*                  function responsible for the journal entry      */
/*                  generation of TI Postings                       */
/*                                                                  */
/*       Submitted by : TIC0050                                     */
/*                                                                  */
/*       Calls :  TI0340 or TI0341                                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 06Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG3604            Date 23Jul04              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      173172             Date 16Jan03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003             Date 06Feb01             */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      162541             Date 09Jul99              */
/*                      162449             Date 01Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      156998             Date 10May99              */
/*                      144700             Date 23Oct98              */
/*                      139756             Date 24Aug98              */
/*                      CTI001  *CREATE    Date 30JUL97              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BG18886 - Replace non-standard codes.                      */
/*       BUG3604 - Send message when F7 fails in TI0505 because     */
/*                 background TIJRNENT is already running.          */
/*       173172 - Two TIJRNENT jobs simultaneously running caused   */
/*                problem in I/C termination.                       */
/*       CTI003 - Transaction Postings Total Enhancements.          */
/*                If TRTOT is populated use new processing else     */
/*                no change.                                        */
/*       162541 - Guarantee to close batch before Close of Business */
/*       162449 - Batch will be submitted from module TI0340M       */
/*       156998 - Close batches at end of day and on request        */
/*       144700 - Change the looping time from seconds to minutes   */
/*       139756 - Job submitted without ML overrides                */
/*              - Commitment control scope incorrect                */
/*       CTI001 - Created for Midas/TI Interface                    */
/*                                                                  */
/********************************************************************/
/************PGM                                                  */ /*139756*/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)     /*139756*/
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(80)
             DCL        VAR(&AOTIIN) TYPE(*CHAR) LEN(200)
             DCL        VAR(&TIMNWT) TYPE(*DEC) LEN(4 0)              /*144700*/
             DCL        VAR(&TILOOP) TYPE(*DEC) LEN(4)                /*156998*/
             DCL        VAR(&TIPRWT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STSCDE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TI0340) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(1)                /*139756*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                /*162541*/
             DCL        VAR(&NUMBER) TYPE(*CHAR) LEN(6)               /*162541*/
             DCL        VAR(&TRFLAG) TYPE(*CHAR) LEN(1)               /*CTI003*/
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Lock data area TIJRNENT to prevent subsequent submitting */
/* of TIJRNENT job.                                         */
/**********  ALCOBJ     OBJ((TIJRNENT *DTAARA *EXCL)) */              /*173172*/
             ALCOBJ     OBJ((TIJRNENT *DTAARA *EXCL)) WAIT(0)         /*173172*/
/**********  MONMSG     MSGID(CPF1002) EXEC(GOTO +
/**********             CMDLBL(END))                                          /*173172*/ /*BUG3604*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                                          /*BUG3604*/
                           CHGVAR     VAR(&PARM2) VALUE('L')                             /*BUG3604*/
                           GOTO CMDLBL(END)                                              /*BUG3604*/
                        ENDDO                                                            /*BUG3604*/
                                                                      /*173172*/
/* Retrieve job details and update data area with them */             /*162541*/
                                                                      /*162541*/
             RTVJOBA    USER(&USER) NBR(&NUMBER)                      /*162541*/
             CHGDTAARA  DTAARA(TI0340 (7 17)) VALUE(' ')              /*162541*/
             CHGDTAARA  DTAARA(TI0340 (7 10)) VALUE(&USER)            /*162541*/
             CHGDTAARA  DTAARA(TI0340 (18 6)) VALUE(&NUMBER)          /*162541*/
                                                                      /*162541*/
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGVAR     VAR(&MSG) VALUE('TIC0340 - TI I/C Journal +
                          Entry Generation of TI Posting')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Commitment Control */
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))         */ /*139756*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*139756*/
             MONMSG     MSGID(CPF8351)
 
/* Get Processing Wait Time */
             CHGVAR     VAR(&RTCD) VALUE('*MSG   ')
             CALL       PGM(AOTIINR0) PARM(&RTCD &OPTN &AOTIIN)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&TIPRWT) VALUE(%SST(&AOTIIN 41 2))
 
/* Process Batches */
 
/************CHGVAR     &TIMNWT  VALUE(%SST(&TIPRWT 1 2))  /*156998*/ /*162541*/
/************CHGVAR     VAR(&TIMNWT) VALUE(&TIMNWT -1)     /*156998*/ /*162541*/
NEXTBATCH:
/* Removed by 162541 */                                               /*156998*/
 
/* Check Status Code */                                               /*156998*/
/************RTVDTAARA  DTAARA(TI0340 (1 5)) RTNVAR(&TI0340)          /*156998*/
/************CHGVAR     VAR(&STSCDE) VALUE(' ')                       /*156998*/
/************IF         COND((%SST(&TI0340 1 5)) *EQ 'STOP') THEN(DO) /*156998*/
/************  CHGVAR     VAR(&STSCDE) VALUE('S')                     /*156998*/
/************ENDDO                                                    /*156998*/
/* End of 162541 */                                                   /*156998*/
                                                                      /*156998*/
/* Journal Entry Generation of TI Postings */                         /*156998*/
/* Removed by 162541 */                                               /*156998*/
/************CALL       PGM(TI0340) PARM(&STSCDE &BATCH)              /*156998*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*156998*/
/************    RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*156998*/
/************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
/************             TOMSGQ(MOPERQ MRUNQ)                        /*156998*/
/************    MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*156998*/
/************    GOTO       CMDLBL(ABNOR)                             /*156998*/
/************ENDDO                                                    /*156998*/
/* End of 162541 */                                                   /*156998*/
                                                                      /*156998*/
/* Removed by 162541 */                                               /*156998*/
/*LOOP1:      CHGVAR     VAR(&TILOOP) VALUE(&TILOOP + 1)              /*156998*/
/************IF         COND(&TILOOP *LE &TIMNWT) THEN(DO)            /*156998*/
/************                                                         /*156998*/
/************RTVDTAARA  DTAARA(TI0340 (1 5)) RTNVAR(&TI0340)          /*156998*/
/************CHGVAR     VAR(&STSCDE) VALUE(' ')                       /*156998*/
/************IF         COND((%SST(&TI0340 1 5)) *EQ 'STOP') THEN(DO) /*156998*/
/************  CHGVAR     VAR(&STSCDE) VALUE('S')                     /*156998*/
/************                                                         /*156998*/
/************CALL       PGM(TI0340) PARM(&STSCDE &BATCH)              /*156998*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*156998*/
/************    RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*156998*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
/************           TOMSGQ(MOPERQ MRUNQ)                          /*156998*/
/************    MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*156998*/
/************    GOTO       CMDLBL(ABNOR)                             /*156998*/
/************ENDDO                                                    /*156998*/
/************                                                         /*156998*/
/************GOTO       CMDLBL(CLOSE)                                 /*156998*/
/************                                                         /*156998*/
/************ENDDO                                                    /*156998*/
/************                                                         /*156998*/
/************DLYJOB     DLY(60)                                       /*156998*/
/************GOTO       CMDLBL(LOOP1)                                 /*156998*/
/************                                                         /*156998*/
/************ENDDO                                                    /*156998*/
/************CHGVAR     VAR(&TILOOP) VALUE(0)                         /*156998*/
/************                                                         /*156998*/
/* End of 162541 */                                                   /*156998*/
/* Check Status Code */
             RTVDTAARA  DTAARA(TI0340 (1 5)) RTNVAR(&TI0340)
             CHGVAR     VAR(&STSCDE) VALUE(' ')
             IF         COND((%SST(&TI0340 1 5)) *EQ 'STOP') THEN(DO)
               CHGVAR     VAR(&STSCDE) VALUE('S')
             ENDDO
/* Journal Entry Generation of TI Postings */
/************CALL       PGM(TI0340) PARM(&STSCDE &BATCH)                                  /*CTI003*/
/* Check Transaction Flag To Indicate Valid TRTOT Field                                   /*CTI003*/
             RTVDTAARA  DTAARA(TIDTA (32 1)) RTNVAR(&TRFLAG)                              /*CTI003*/
             IF         COND(&TRFLAG *EQ 'Y') THEN(DO)                                    /*CTI003*/
                CALL       PGM(TI0341) PARM(&STSCDE &BATCH)                               /*CTI003*/
             ENDDO                                                                        /*CTI003*/
             ELSE       CMD(DO)                                                           /*CTI003*/
                CALL PGM(TI0340) PARM(&STSCDE &BATCH)                                     /*CTI003*/
             ENDDO                                                                        /*CTI003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                 GOTO       CMDLBL(ABNOR)
             ENDDO
 
 /*          IF         COND(&STSCDE *EQ 'A') THEN(DO)                /*156998*/
 CLOSE: /****IF         COND(&STSCDE *EQ 'A') THEN(DO)       /* 156998 162449 */
 /***********CALL       PGM(GLSBMBCH) PARM('       ' &BATCH)        /* 162449 */
 /***********ENDDO                                                  /* 162449 */
 
             IF         COND(&STSCDE *EQ 'H') THEN(DO)
 /***********  SNDPGMMSG  MSG('The batch ' ** &BATCH ** ' is held') +
                          TOMSGQ(MOPERQ)                                                   BG18886*/
               SNDPGMMSG  MSG('The batch ' *CAT &BATCH *CAT ' is held') +
                          TOMSGQ(MOPERQ)                                                 /*BG18886*/
             ENDDO
 
             IF         COND(&STSCDE *EQ 'S') THEN(DO)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Only call TI0341 once if this component called interactively from TI0505 enquiry.     /*BUG3604*/
             IF         COND(&PARM3 *EQ 'I') THEN(DO)                                    /*BUG3604*/
               GOTO       CMDLBL(END)                                                    /*BUG3604*/
             ENDDO                                                                       /*BUG3604*/
                                                                                         /*BUG3604*/
             IF         COND(&STSCDE *EQ 'F') THEN(DO)
/**********    SNDPGMMSG  MSG('The batch ' ** &BATCH ** ' is held') +
                          TOMSGQ(MOPERQ)                                                   BG18886*/
               SNDPGMMSG  MSG('The batch ' *CAT &BATCH *CAT ' is held') +
                          TOMSGQ(MOPERQ)                                                 /*BG18886*/
               GOTO       CMDLBL(END)
             ENDDO
 
/* Wait */
/************DLYJOB     DLY(&TIPRWT                                */ /*144700*/
/************CHGVAR     &TIMNWT  VALUE(%SST(&TIPRWT 1 2))  /*144700*/ /*156998*/
/************CHGVAR     &TIMNWT  VALUE(&TIMNWT * 60)       /*144700*/ /*156998*/
/************DLYJOB     DLY(&TIMNWT)                       /*144700*/ /*156998*/
             CHGVAR     &TIMNWT  VALUE(%SST(&TIPRWT 1 2))             /*162541*/
             CHGVAR     &TIMNWT  VALUE(&TIMNWT * 60)                  /*162541*/
             DLYJOB     DLY(&TIMNWT)                                  /*162541*/
 
/* Process the Next Batch */
             GOTO       CMDLBL(NEXTBATCH)
 
/* Normal termination */
             GOTO       CMDLBL(END)
 
 
ABNOR:
 
/* Abnormal termination */
 
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&MSGID *NE '       ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             SNDPGMMSG  MSG('TIC0340 Midas TI I/C Journal Entry +
                          Generation of TI Postings ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000)
/* Deallocate data area TIJRNENT  */
             DLCOBJ     OBJ((TIJRNENT *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
