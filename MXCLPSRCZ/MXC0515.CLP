/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Daily Events Extract - SECURITIES Module')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0515 - Daily Events Extract - SECURITIES Module          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX003             Date 05Nov00              */
/*                              *CREATE    Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*       MD046248 - Finastra Rebranding                              */
/*       CMX003 - Meridian Export Enhancements - Phase 2             */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                   */                   /*MD049139*/
             PGM        PARM(&RUNCOND)                                                  /*MD049139*/

/*/COPY WNCPYSRC,MXC0515INT                                          */

             DCL        VAR(&RUNCOND) TYPE(*CHAR) LEN(6)                                /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD049139*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)

/** Determine if switchable feature CLE025 is switched ON then     */                   /*MD049139*/
/** check if program should run based on feature and parameter     */                   /*MD049139*/
                                                                                        /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              (&RUNCOND *EQ 'CLE025')) *OR +
                             ((&CLE025 *NE 'Y') *AND +
                              (&RUNCOND *NE 'CLE025'))) THEN(GOTO +
                        CMDLBL(END))                                                    /*MD049139*/
                                                                                        /*MD049139*/
/*/COPY WNCPYSRC,MXC0515MPS                                          */

             OVRDBF     FILE(MXDESETPD) SEQONLY(*YES 100)
             OVRDBF     FILE(MXDESEBPD) SEQONLY(*YES 100)    /*CMX003*/

             CLRPFM     FILE(MXDESETPD)
             CLRPFM     FILE(MXDESEBPD)                      /*CMX003*/

             CALL       PGM(MXDEEXSE) PARM(&RTCD &ERMS)

             DLTOVR *ALL

             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0515 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO

/*/COPY WNCPYSRC,MXC0515MPE                                          */

             GOTO       CMDLBL(END)

 ABNOR:
/*/COPY WNCPYSRC,MXC0515ERR                                          */

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination */

               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0515 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)


END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

/*/COPY WNCPYSRC,MXC0515END                                          */

             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)

             ENDPGM
