/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX COB Bulk Transmission - All Cmps and Fmts')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0030 - COB Bulk Transmission - All Composites and Formats*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CMX002  *CREATE    Data 26Sep00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMX002 - Meridian Export Enhancements - Phase 1             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE)
 
/*/COPY WNCPYSRC,MXC0030INT                                          */
 
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
 
/* (TYPE is 'C' for composite transmission )                         */
/* (TYPE is 'F' for format transmission    )                         */
 
             DCL        VAR(&COMI)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&EXTT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FMT )   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0030MPS                                          */
 
 
/* Get the next composite/format for transmission */
 
GETNEXT:     CALL       PGM(MXGETNCFT) PARM(&RTCD &ERMS &TYPE &COMI +
                          &EXTT &FMT)
 
 
/* If there was an error getting the next composite/format then end */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
 
/* Call the transmission function for the composite/format */
 
             IF         COND(&COMI *NE '        ') THEN(DO)
             CALL       PGM(MXC0020) PARM(&COMI &EXTT &FMT)
             IF COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
             GOTO       CMDLBL(GETNEXT)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0030MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0030ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0030 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0030END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
