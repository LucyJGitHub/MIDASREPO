/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facility amendments maintenance')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       LEC2150 - Facility Amendments Maintenance                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CAP071             Date 05Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      190017             Date 07Mar01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005             Date 22May97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP071 - Conversion of LE inputs into modular structure to  */
/*                use as APIs.                                       */
/*       190017 - Override LEFCAMSQ to LEFCAML3 SHARE(*NO) to prevent*/
/*                duplication of sequence numbers.                   */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PMODE)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*CAP071*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                           /*CAP071*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CAP171')                            /*CAP071*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Determine if CAP171 installed  */                                 /*CAP071*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)            /*CAP071*/
/**/                                                                 /*CAP071*/
/* Error */                                                          /*CAP071*/
/**/                                                                 /*CAP071*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                        /*CAP071*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                          TOMSGQ(MOPERQ)                             /*CAP071*/
             CHGJOB     JOB(XXXXXX11)                                /*CAP071*/
             GOTO       CMDLBL(END)                                  /*CAP071*/
             ENDDO                                                   /*CAP071*/
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Call program then process any db error */
 
             OVRDBF     FILE(LEFCAMSQ) TOFILE(LEFCAML3) SHARE(*NO)   /*190017*/
 
/* CAP171 installed */                                               /*CAP071*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                          PGM(LEFAMDSIN) PARM(&PMODE '' ''))         /*CAP071*/
             ELSE       CMD(DO)                                      /*CAP071*/
 
/** CAP171 not installed */                                          /*CAP071*/
 
             CALL       PGM(LE2150) PARM(&PMODE '' '')
 
             ENDDO                                                   /*CAP071*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*/COPY WNCPYSRC,LEC2150001                                          */
             GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Inform user of any abnormal error */
 
 ABNOR:      ROLLBACK
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Transaction failed.  Re-input necessary.  +
                          Enter to continue.') TOPGMQ(*EXT)
 
/* End processing */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
