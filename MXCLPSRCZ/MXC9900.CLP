/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Export Formats Definition')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MCX9900 - Export Formats Definition                         */
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
/*       Prev Amend No. CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MCX9900INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,MCX9900MPS                                          */
 
 
/* Create work file */
 
             CHKOBJ     OBJ(QTEMP/MXEXFFZZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
 
             CPYF       FROMFILE(MXEXFFPD) TOFILE(QTEMP/MXEXFFZZ) +
                          CRTFILE(*YES) FROMRCD(1) TORCD(1)
             MONMSG CPF0000
 
             ENDDO
 
/*    Overrides                                                      */
 
             OVRDBF     FILE(MXEXFDPDX) TOFILE(MXEXFDPD) SHARE(*NO)
 
             OVRDBF     FILE(MXEXFFL1X) TOFILE(MXEXFFL1) SHARE(*NO)
             OVRDBF     FILE(MXEXFFL1Y) TOFILE(MXEXFFL1) SHARE(*NO)
 
             OVRDBF     FILE(MXEXFFZZ) TOFILE(QTEMP/MXEXFFZZ) +
                          SHARE(*NO)
 
/*    Call input function                                            */
 
             CALL       PGM(MXEXFDBRW) PARM(&RTCD &ERMS 'U')
 
/*    Error processing                                               */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MCX9900MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MCX9900ERR                                          */
 
/* Abnormal termination */
 
            CHGJOB     SWS(XXXXXX11)
            SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                       TOPGMQ(*EXT) TOMSGQ(MOPERQ)
            MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MCX9900END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM
