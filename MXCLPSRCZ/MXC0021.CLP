/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX COB Bulk Transmission - All Cmps and Fmts')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0021 - COB Bulk Transmission - All Composites and Formats*/
/*                                         to Flat file              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW034             Date 09JAN04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CMX011             Date 29Dev01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX010  *CREATE    Data 18Jan01              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSW034 - Midas Message Manager Global Processing            */
/*       CMX011 - Enable Meridian Export to use data queue as well   */
/*                as MQ queue.                                       */
/*       CMX010 - Flat file export from Midas Export module.         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMI &EXTT &FMT)
 
/*/COPY WNCPYSRC,MXC0021INT                                          */
 
             DCL        VAR(&COMI)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&COMIE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXTT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FMT )   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
 
/* Mode = COB, Function = TRANSMISSION                              */
 
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1) VALUE('C')
             DCL        VAR(&FUNC)  TYPE(*CHAR) LEN(1) VALUE('T')
 
             DCL        VAR(&DTAG)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEMBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRVACT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DRIVFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODI  ) TYPE(*CHAR) LEN(3)
                                                                               /*CMX011*/
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(20)                         /*CMX011*/
             DCL        VAR(&KDTAQ) TYPE(*CHAR) LEN(1)                         /*CSW034*/
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CMX011) TYPE(*CHAR) LEN(1) VALUE(' ')             /*CMX011*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
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
 
/*/COPY WNCPYSRC,MXC0021MPS                                          */
/***  Access Switchable Features file to see if CMX011 present.                /*CMX011*/
                                                                               /*CMX011*/
             CALL (AOSARDR0) PARM(&RTCD '*VERIFY' 'CMX011')                    /*CMX011*/
             IF (&RTCD *EQ ' ') (CHGVAR (&CMX011) VALUE('Y'))                  /*CMX011*/
                                                                               /*CMX011*/
 
 
/* Get Extract Parameters of Composite or Format */
 
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
 
 
/* Setup Flat file name depending on composite */
 
             CHGVAR     VAR(&COMIE) VALUE('E.' *CAT &COMI)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB  ')
 
/* Delete, recreate and override composite file */
 
             DLTF       FILE(&DMLIB/&COMIE)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(&DMLIB/MXFLFLPD) +
                          TOFILE(&DMLIB/&COMIE) CRTFILE(*YES)
 
             OVRDBF     FILE(MXFLFLPD) TOFILE(&DMLIB/&COMIE) SHARE(*NO)
 
/* Clear Performance Data and override */
 
             CLRPFM     FILE(MXPLOGPD) MBR(&MEMBR)
             OVRDBF     FILE(MXPLOGPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES 100)
 
/* Override MQ Series Data */
 
             OVRDBF     FILE(MXMQDLL1) MBR(&MEMBR) SHARE(*NO)
             OVRDBF     FILE(MXMQDML1) MBR(&MEMBR) SHARE(*NO)
             OVRDBF     FILE(MXMQDSL1) MBR(&MEMBR) SHARE(*NO)
             OVRDBF     FILE(MXMQDVL1) MBR(&MEMBR) SHARE(*NO)
             OVRDBF     FILE(MXMQDXL1) MBR(&MEMBR) SHARE(*NO)
 
/* Override Export Format */
 
             OVRDBF     FILE(MXEXFDL2X) TOFILE(MXEXFDL2) SHARE(*NO)
 
/* Call transmission program  */
 
/* If CMX011 is present and &DTAQ contain the name of the dataQ */             /*CMX011*/
/* then send data to DataQ                                      */             /*CMX011*/
 
             IF ((&CMX011 *EQ 'Y') *AND (&DTAQ *NE ' ')) THEN(DO)              /*CMX011*/
             IF (&KDTAQ *NE ' ') THEN(DO)                                      /*CSW034*/
                CALL       PGM(MXBULKTRK) PARM(&RTCD &ERMS &MODE &COMI +
                             &EXTT &FMT)                                       /*CSW034*/
             ENDDO                                                             /*CSW034*/
             ELSE (DO)                                                         /*CSW034*/
             CALL       PGM(MXBULKTRD) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT)                                          /*CMX011*/
             ENDDO                                                             /*CSW034*/
             ENDDO                                                             /*CMX011*/
             ELSE (DO)                                                         /*CMX011*/
             CALL       PGM(MXBULKTRX) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT)
             ENDDO                                                             /*CMX011*/
 
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
                            MXC0021 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0021MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0021ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0021 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0021END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
