/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Message manager downloads')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC0730 - Message Manager Downloads                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. AR1031152          Date 06Dec12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 237373             Date 07Apr06              */
/*                      227134             Date 18Apr06              */
/*                      BUG5779            Date 17Feb05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025  *CREATE    Date 06Mar02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1031152 - No currency download if MMM4 switched on.       */
/*                   (Child: AR1031154)                              */
/*       237373 - should only download SE transaction if SE ISO15022 */
/*                feature is present                                 */
/*       227134 - Do not extract SE-messages when module SE not on.  */
/*       BUG5779- Suppress branch download                           */
/*       CSW025 - Midas Message Manager                              */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CSW038) TYPE(*CHAR) LEN(1) VALUE(' ')                     /*AR1031152*/
             DCL        VAR(&CSE029) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*237373*/
             DCL        VAR(&MNGSYS) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7) VALUE(' ')                        /*227134*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')                    /*227134*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*227134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERROR)
 
             CHGJOB     SWS(00000000)
 
/**/                                                                                      /*227134*/
/*  Access PF/SDMMODPD to determine which modules are live  */                            /*227134*/
/**/                                                                                      /*227134*/
             CALL       PGM(AOMMODR0) PARM(&RETCOD &OPTN &FMT)                            /*227134*/
/**/                                                                                      /*227134*/
/** Database error handling */                                                            /*227134*/
/**/                                                                                      /*227134*/
             IF         COND(&RETCOD *NE '       ') THEN(DO)                              /*227134*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOMSGQ(MOPERQ)                                                  /*227134*/
             GOTO       CMDLBL(ERROR)                                                     /*227134*/
             ENDDO                                                                        /*227134*/
                                                                                          /*227134*/
             RTVDTAARA  DTAARA(MESTAT (50 1)) RTNVAR(&MNGSYS)
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))
                                                                                       /*AR1031152*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW038')                           /*AR1031152*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW038) VALUE('Y'))                         /*AR1031152*/
/* */                                                                                     /*237373*/
/***  Access Switchable Features file to see if ISO15022 generation                       /*237373*/
/***  present.  */                                                                        /*237373*/
                                                                                          /*237373*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSE029')                              /*237373*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSE029) VALUE('Y'))                            /*237373*/
 
             IF COND((&CSW025 *EQ 'Y') *AND (&MNGSYS *EQ 'Y')) +
                        THEN(DO)
 
/* If Securities module is Switched On.                                                   /*227134*/
/* or */                                                                                  /*237373*/
/*** If CSE029 ISO15022 is present then process data download ***  */                     /*237373*/
/**********  IF         COND(%SST(&FMT 31 1) *EQ 'Y') THEN(DO)       */            /*227134 237373*/
             IF         COND((%SST(&FMT 31 1) *EQ 'Y') *OR          +
                        (&CSE029 *EQ 'Y')) THEN(DO)                                       /*237373*/
             CALL MXC0020 PARM('MSG_TRD' 'C' '*NONE')
             CALL MXC0020 PARM('MSG_DPM' 'C' '*NONE')
             CALL MXC0020 PARM('MSG_PST' 'C' '*NONE')
             ENDDO                                                                        /*227134*/
 
/************CALL MXC0010 PARM('*NONE   ' 'MGBRCHD0')                              BUG5779 */
/************CALL MXC0020 PARM('*NONE   ' ' ' 'MGBRCHD0')                          BUG5779 */
             IF COND(&CSW038 *NE 'Y') THEN(DO)                                         /*AR1031152*/
             CALL       PGM(MXC0010) PARM('*NONE   ' 'MGCURRD0')
             CALL MXC0020 PARM('*NONE   ' ' ' 'MGCURRD0')
             ENDDO                                                                     /*AR1031152*/
 
             IF (%SWITCH(XXXXXX11)) THEN(DO)
                 SNDPGMMSG  MSG('ISO15022 Data Extract failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                 GOTO (ERROR)
             ENDDO
             ENDDO
 
             GOTO END
ERROR:       CHGVAR     VAR(&MSG) VALUE('Message Manager Downloads')
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
