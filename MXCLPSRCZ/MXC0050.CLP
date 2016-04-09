/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Branches For Export Definition')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MCX0050 - Branches For Export Definition                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CMX003             Date 05Nov00              */
/*       Prev Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMX003 - Meridian Export Enhancements - Phase 2             */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MCX0050INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&COMI) TYPE(*CHAR) LEN(8)        /*CMX003*/
             DCL        VAR(&INKC) TYPE(*CHAR) LEN(1)        /*CMX003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,MCX0050MPS                                          */
 
 
             OVRDBF     FILE(MXBREXL1) TOFILE(MXBREXL0) SHARE(*NO)
 
                                                  /* Start of CMX003 */
 
             CALL       PGM(MXCOMIPRM) PARM(&RTCD &ERMS &COMI &INKC)
 
/*    Error processing                                               */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&INKC *EQ '1') THEN(DO)
               GOTO       CMDLBL(END)
             ENDDO
 
 
                                                    /* End of CMX003 */
/*    Call input function                                            */
 
                                                  /* Start of CMX003 */
             CALL       PGM(MXBRCADEF) PARM(&RTCD &ERMS ' ' &COMI)
/************CALL       PGM(MXBRCADEF) PARM(&RTCD &ERMS ' ') *****/
                                                    /* End of CMX003 */
 
/*    Error processing                                               */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MCX0050MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MCX0050ERR                                          */
 
/* Abnormal termination */
 
            CHGJOB     SWS(XXXXXX11)
            SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                       TOPGMQ(*EXT) TOMSGQ(MOPERQ)
            MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MCX0050END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM
