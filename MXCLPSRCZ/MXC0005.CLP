/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX COB Bulk Extract - 'Activty' Cmps')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0005 - COB Bulk Extract - Activity Composites            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSW034             Date 09Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CMX011             Date 29Dev01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX003             Date 05Nov00              */
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW034 - Midas Message Manager Global Processing            */
/*       CMX011 - Enable Meridian Export to use data queue as well   */
/*                as MQ queue.                                       */
/*       CMX003 - Meridian Export Enhancements - Phase 2             */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMI)
 
/*/COPY WNCPYSRC,MXC0005INT                                          */
 
             DCL        VAR(&COMI)  TYPE(*CHAR) LEN(8)
 
/* Mode = COB, Extract Type = ACTIVITY, Function = EXTRACT          */
 
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1) VALUE('C')
             DCL        VAR(&EXTT)  TYPE(*CHAR) LEN(1) VALUE('A')
             DCL        VAR(&FUNC)  TYPE(*CHAR) LEN(1) VALUE('X')
 
             DCL        VAR(&DTAG)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEMBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRVACT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DRIVFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODI  ) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&FMT )  TYPE(*CHAR) LEN(10)
                                                                               /*CMX011*/
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(20)                         /*CMX011*/
             DCL        VAR(&KDTAQ) TYPE(*CHAR) LEN(1)                         /*CSW034*/
 
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
 
/*/COPY WNCPYSRC,MXC0005MPS                                          */
 
 
/* Get Extract Parameters of Composite */
 
/*********** CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +  */      /*CMX011*/
/***********              &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI)     */      /*CMX011*/
/*********** CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +            CSW034*/
/***********              &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI +              CSW034*/
/***********              &DTAQ)                                          CMX011 CSW034*/
             CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +
                          &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI +
                          &DTAQ &KDTAQ)                                        /*CSW034*/
 
 
/* If there was an error getting the extract parameters then end */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
 
 
/* Clear Performance Data and override */
 
             CLRPFM     FILE(MXPLOGPD) MBR(&MEMBR)
             OVRDBF     FILE(MXPLOGPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES 500)
 
/* Clear MQ Series Data and override */
 
             CLRPFM     FILE(MXMQDLPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDMPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDSPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDVPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDXPD) MBR(&MEMBR)
 
 
             OVRDBF     FILE(MXMQDLPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  10)
             OVRDBF     FILE(MXMQDMPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  20)
             OVRDBF     FILE(MXMQDSPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  40)
             OVRDBF     FILE(MXMQDVPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  80)
             OVRDBF     FILE(MXMQDXPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES 400)
 
/* Override to Data Group */
 
/* GEN.LED. */
             IF         COND(&MODI *EQ 'GL ') THEN(DO)
             IF         COND(&DRVACT = 'DEV') THEN(DO)
             OVRDBF     FILE(MXDEGLL1) TOFILE(MXDEGLL1) SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'MEV') THEN(DO)
             OVRDBF     FILE(MXDEGLL1) TOFILE(MXMEGLL1) SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'BAL') THEN(DO)
             OVRDBF     FILE(MXBLGLPD) TOFILE(MXBLGLPD) SHARE(*NO)
             ENDDO
             ENDDO
 
/* DEALING */
             IF         COND(&MODI *EQ 'DL ') THEN(DO)
             IF         COND(&DRVACT = 'DEV') THEN(DO)
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXDEDLL0) MBR(&DTAG) +
                          SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'MEV') THEN(DO)
             OVRDBF     FILE(MXDEDLL0) TOFILE(MXMEDLL0) MBR(&DTAG) +
                          SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'BAL') THEN(DO)
             OVRDBF     FILE(MXBLDLL0) TOFILE(MXBLDLL0) MBR(&DTAG) +
                          SHARE(*NO)
             ENDDO
             ENDDO
 
/* LENDING FACILITIES */
             IF         COND(&MODI *EQ 'LEF') THEN(DO)
             IF         COND(&DRVACT = 'DEV') THEN(DO)
             OVRDBF     FILE(MXDELEFL1) TOFILE(MXDELEFL1) SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'MEV') THEN(DO)
             OVRDBF     FILE(MXDELEFL1) TOFILE(MXMELEFL1) SHARE(*NO)
             ENDDO
             ENDDO
 
/* LENDING LOANS */
             IF         COND(&MODI *EQ 'LEL') THEN(DO)
             IF         COND(&DRVACT = 'DEV') THEN(DO)
             OVRDBF     FILE(MXDELELL0) TOFILE(MXDELELL0) MBR(&DTAG) +
                          SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'MEV') THEN(DO)
             OVRDBF     FILE(MXDELELL0) TOFILE(MXMELELL0) MBR(&DTAG) +
                          SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'BAL') THEN(DO)
             OVRDBF     FILE(MXBLLELL0) TOFILE(MXBLLELL0) MBR(&DTAG) +
                          SHARE(*NO)
             ENDDO
             ENDDO
 
/* SECURITIES TRADES */
             IF         COND(&MODI *EQ 'SET') THEN(DO)
             IF         COND(&DRVACT = 'DEV') THEN(DO)
             OVRDBF     FILE(MXDESETL1) TOFILE(MXDESETL1) SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'MEV') THEN(DO)
             OVRDBF     FILE(MXDESETL1) TOFILE(MXMESETL1) SHARE(*NO)
             ENDDO
             ENDDO
                                                                               /* Start of CMX003 */
/* SECURITIES BOOK POSITIONS */
             IF         COND(&MODI *EQ 'SEB') THEN(DO)
             IF         COND(&DRVACT = 'DEV') THEN(DO)
             OVRDBF     FILE(MXDESEBL1) TOFILE(MXDESEBL1) SHARE(*NO)
             ENDDO
             IF         COND(&DRVACT = 'MEV') THEN(DO)
             OVRDBF     FILE(MXDESEBL1) TOFILE(MXMESEBL1) SHARE(*NO)
             ENDDO
             ENDDO
                                                                                 /* End of CMX003 */
 
 
/* Call extract program  */
 
/* GEN.LED. */
             IF         COND(&MODI *EQ 'GL ') THEN(DO)
             IF         COND(&DRVACT *NE 'BAL') THEN(DO)
             CALL       PGM(MXEVAXGL) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
             IF         COND(&DRVACT *EQ 'BAL') THEN(DO)
             CALL       PGM(MXBLAXGL) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
             ENDDO
/* DEALING */
             IF         COND(&MODI *EQ 'DL ') THEN(DO)
             IF         COND(&DRVACT *NE 'BAL') THEN(DO)
             CALL       PGM(MXEVAXDL) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
             IF         COND(&DRVACT *EQ 'BAL') THEN(DO)
             CALL       PGM(MXBLAXDL) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
             ENDDO
/* LENDING FACILITIES */
             IF         COND(&MODI *EQ 'LEF') THEN(DO)
             CALL       PGM(MXEVAXLEF) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
/* LENDING LOANS */
             IF         COND(&MODI *EQ 'LEL') THEN(DO)
             IF         COND(&DRVACT *NE 'BAL') THEN(DO)
             CALL       PGM(MXEVAXLEL) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
             IF         COND(&DRVACT *EQ 'BAL') THEN(DO)
             CALL       PGM(MXBLAXLEL) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
             ENDDO
/* SECURITIES TRADES */
             IF         COND(&MODI *EQ 'SET') THEN(DO)
             CALL       PGM(MXEVAXSET) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
/* Start of CMX003 */
/* SECURITIES BOOK POSITIONS */
             IF         COND(&MODI *EQ 'SEB') THEN(DO)
             CALL       PGM(MXEVAXSEB) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT)
             ENDDO
/* End of CMX003 */
 
 
             DLTOVR *ALL
 
             RCLRSC
             RCLRSC     LVL(*CALLER)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
 
/* If the extract is enabled and there was no error in the extract */
 
             IF COND(%SWITCH(XXXXX000)) THEN(DO)
 
/* Override Performance Data */
 
             OVRDBF     FILE(MXPLOGL1) MBR(&MEMBR) SHARE(*NO)
 
/* Call statistics update program  */
 
             CALL       PGM(MXUPDSTAT) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT &FUNC)
 
             ENDDO
 
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0005MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0005ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0005END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
