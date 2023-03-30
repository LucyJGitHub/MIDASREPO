/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Input Cycle Bulk Transmission')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0720 - Input Cycle Bulk Transmission                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. AR924225           Date 22Feb23              */
/*       Prev Amend No. MD033134           Date 21Feb23              */
/*                      AR792326           Date 16Feb23              */
/*                      MD056612           Date 12Sep20              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSW034             Date 09Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CMX011             Date 29Dev01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR924225 - Export using flat file download does not create  */
/*                  the table in the IFS folder. Copy DB2 Export     */
/*                  table to a nominated IFS folder if CMX010 is ON  */
/*                  and system value 'EMIFSSubdirectory' is not blank*/
/*                  (Child : AR924227)                               */
/*       MD033134 - File E.HBXFPP02 consuming large space. Amend to  */
/*                  utilize space usage.                             */
/*       AR792326 - FlatFiles for any format and composite           */
/*                  (Child: AR830959)                                */
/*       MD056612 - Deliverable Data Split for MX group              */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW034 - Midas Message Manager Global Processing            */
/*       CMX011 - Enable Meridian Export to use data queue as well   */
/*                as MQ queue.                                       */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMI &EXTT &FMT)

/*/COPY WNCPYSRC,MXC0720INT                                          */

             DCL        VAR(&COMI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&EXTT)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&FMT )  TYPE(*CHAR) LEN(10)

/* Mode = I/C, Function = TRANSMISSION                              */

             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1) VALUE('I')
             DCL        VAR(&FUNC)  TYPE(*CHAR) LEN(1) VALUE('T')
                                                                               /*CMX011*/
             DCL        VAR(&DTAG)   TYPE(*CHAR) LEN(4)                        /*CMX011*/
             DCL        VAR(&MEMBR)  TYPE(*CHAR) LEN(10)                       /*CMX011*/
             DCL        VAR(&DRVACT) TYPE(*CHAR) LEN(3)                        /*CMX011*/
             DCL        VAR(&DRIVFL) TYPE(*CHAR) LEN(10)                       /*CMX011*/
             DCL        VAR(&MODI  ) TYPE(*CHAR) LEN(3)                        /*CMX011*/
                                                                               /*CMX011*/
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(20)                         /*CMX011*/
             DCL        VAR(&KDTAQ) TYPE(*CHAR) LEN(1)                         /*CSW034*/
             DCL        VAR(&FILESIZ) TYPE(*CHAR) LEN(1)                                /*MD033134*/
             DCL        VAR(&FLATFIL) TYPE(*CHAR) LEN(10)                               /*AR792326*/
             DCL        VAR(&FLATLIB) TYPE(*CHAR) LEN(10)                               /*AR792326*/

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CMX011) TYPE(*CHAR) LEN(1) VALUE(' ')             /*CMX011*/
             DCL        VAR(&CMX010) TYPE(*CHAR) LEN(1) VALUE(' ')                      /*AR792326*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&EMIFS) TYPE(*CHAR) LEN(200) +
                          VALUE(*BLANKS)                                                /*AR924225*/
             DCL        VAR(&EMLNK) TYPE(*CHAR) LEN(214) +
                          VALUE(*BLANKS)                                                /*AR924225*/
             DCL        VAR(&ZONEPOS) TYPE(*DEC) LEN(3 0)                               /*AR924225*/
             DCL        VAR(&ZONEPAT) TYPE(*CHAR) LEN(4) VALUE('/xx/')                  /*AR924225*/
             DCL        VAR(&ZONEPRF) TYPE(*CHAR) LEN(4) VALUE('/  /')                  /*AR924225*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                  /*AR924225*/
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(200)                     /*AR924225*/
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)                       /*AR924225*/
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0) VALUE(4)                       /*AR924225*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                 /*AR924225*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                /*AR924225*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                /*AR924225*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                               /*AR924225*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)

             ADDLIBLE   LIB(QMQM) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/*/COPY WNCPYSRC,MXC0720MPS                                          */
/***  Access Switchable Features file to see if CMX011 present.                /*CMX011*/
                                                                               /*CMX011*/
             CALL (AOSARDR0) PARM(&RTCD '*VERIFY' 'CMX011')                    /*CMX011*/
             IF (&RTCD *EQ ' ') (CHGVAR (&CMX011) VALUE('Y'))                  /*CMX011*/
                                                                               /*CMX011*/
/** Access Switchable Features file to see if CMX010 present. */                        /*AR792326*/
                                                                                        /*AR792326*/
             CALL (AOSARDR0) PARM(&RTCD '*VERIFY' 'CMX010')                             /*AR792326*/
             IF (&RTCD *EQ ' ') (CHGVAR (&CMX010) VALUE('Y'))                           /*AR792326*/
                                                                                        /*AR924225*/
/** If CMX010 is switched ON, set up the IFS path for IFS download */                   /*AR924225*/
             IF         COND(&CMX010 *EQ 'Y') THEN(DO)                                  /*AR924225*/
                                                                                        /*AR924225*/
/** Retrieve system value */                                                            /*AR924225*/
                 CALL      PGM(AOSVALR0) PARM(&RTNCDE +
                             'EMIFSSubdirectory' &EMIFS &SVALK2 +
                             &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                             &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                             &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                             &SVALK0 &SVAL10)                                           /*AR924225*/
                                                                                        /*AR924225*/
/** Process retrieved System value */                                                   /*AR924225*/
                 IF         ((&EMIFS *NE '*NRF') *AND (&EMIFS *NE +
                             ' ')) THEN(DO)                                             /*AR924225*/
                                                                                        /*AR924225*/
/** Scan for /xx/ pattern.  If existing, replace with Zone ID */                        /*AR924225*/
                     CALL       PGM(QCLSCAN) PARM(&EMIFS &STRLEN +
                                  &STRPOS &ZONEPAT &PATLEN '0' '1' +
                                  ' ' &ZONEPOS)                                         /*AR924225*/
                     IF         COND(&ZONEPOS > 0) THEN(DO)                             /*AR924225*/
                                                                                        /*AR924225*/
                        RTVDTAARA DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                   /*AR924225*/
                        CHGVAR    VAR(%SUBSTRING(&ZONEPRF 2 2)) +
                                    VALUE(&SYSID)                                       /*AR924225*/
                        CHGVAR    VAR(%SUBSTRING(&EMIFS &ZONEPOS 4)) +
                                    VALUE(&ZONEPRF)                                     /*AR924225*/
                                                                                        /*AR924225*/
                     ENDDO                                                              /*AR924225*/
                 ENDDO                                                                  /*AR924225*/
             ENDDO                                                                      /*AR924225*/
                                                                                        /*AR792326*/
/* Get Extract Parameters of Composite or Format */                            /*CMX011*/
                                                                               /*CMX011*/
/**********  IF  (&CMX011 *EQ 'Y') THEN(DO) */                                   /*CMX011 AR792326*/
             IF         COND(&CMX011 *EQ 'Y' *OR &CMX010 *EQ 'Y') +
                          THEN(DO)                                                      /*AR792326*/
/*********** CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +            CSW034*/
/***********              &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI +              CSW034*/
/***********              &DTAQ)                                          CMX011 CSW034*/
/**********  CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT + */                /*AR792326*/
/**********               &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI + */                  /*AR792326*/
/**********               &DTAQ &KDTAQ) */                                       /*CSW034 AR792326*/
             CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +
                          &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI +
                          &DTAQ &KDTAQ &FLATFIL &FLATLIB)                               /*AR792326*/
             ENDDO                                                             /*CMX011*/


/* Clear Performance Data and override */

             CLRPFM     FILE(MXPLOGPD) MBR(IBULK)
             OVRDBF     FILE(MXPLOGPD) MBR(IBULK) SHARE(*NO) +
                          SEQONLY(*YES 100)

/* Override MQ Series Data */

             OVRDBF     FILE(MXMQDLL1) MBR(IBULK) SHARE(*NO)
             OVRDBF     FILE(MXMQDML1) MBR(IBULK) SHARE(*NO)
             OVRDBF     FILE(MXMQDSL1) MBR(IBULK) SHARE(*NO)
             OVRDBF     FILE(MXMQDVL1) MBR(IBULK) SHARE(*NO)
             OVRDBF     FILE(MXMQDXL1) MBR(IBULK) SHARE(*NO)

/* Override Export Format */

/**********  OVRDBF     FILE(MXEXFDL2X) TOFILE(MXEXFDL2) SHARE(*NO) */                  /*MD056612*/

/* Call bulk transmission program  */
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
             IF ((&CMX010 *EQ 'Y') *AND (&FLATFIL *NE ' ')) THEN(DO)                    /*AR792326*/
/**/                                                                                    /*MD033134*/
/**********  DLTF       FILE(&FLATLIB/&FLATFIL)                       */       /*AR792326 MD033134*/
             DLTF       FILE(QTEMP/&FLATFIL)                                            /*MD033134*/
             MONMSG     MSGID(CPF0000)                                                  /*AR792326*/
/**********  CPYF       FROMFILE(*LIBL/MXFLFLPD) +                    */                /*MD033134*/
/**********               TOFILE(&FLATLIB/&FLATFIL) CRTFILE(*YES)     */       /*AR792326 MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLFLPD) +
                          TOFILE(QTEMP/&FLATFIL) CRTFILE(*YES)                          /*MD033134*/
/**/                                                                                    /*MD033134*/
/*********** OVRDBF     FILE(MXFLFLPD) TOFILE(&FLATLIB/&FLATFIL) SHARE(*NO)    /*AR792326 MD033134*/
             OVRDBF     FILE(MXFLFLPD) TOFILE(QTEMP/&FLATFIL) +
                          OVRSCOPE(*JOB) SHARE(*NO)                                     /*MD033134*/
/**/                                                                                    /*MD033134*/
/*********** CALL       PGM(MXBULKTRX) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT)                            */            /*AR792326 MD033134*/
             CALL       PGM(MXBULKTRX) PARM(&RTCD &ERMS &MODE &COMI +
                                            &EXTT &FMT &FILESIZ)                        /*MD033134*/
/**/                                                                                    /*MD033134*/
             DLTOVR     FILE(MXFLFLPD) LVL(*JOB)
/**/                                                                                    /*MD033134*/
             IF COND(%SWITCH(XXXXX000)) THEN(DO)                                        /*MD033134*/
/**/                                                                                    /*MD033134*/
             DLTF       FILE(&FLATLIB/&FLATFIL)                                         /*MD033134*/
             MONMSG     MSGID(CPF0000)                                                  /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* CREATE 'GIGANTIC' FILE (32,000 BYTES) */                                /*MD033134*/
             IF         COND(&FILESIZ = 'G') THEN(DO)                                   /*MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLGIPD) TOFILE(&FLATLIB/&FLATFIL) +
                        TOMBR(MXFLFLPD) CRTFILE(*YES)                                   /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* CREATE 'LONG' FILE (4,000 BYTES) */                                     /*MD033134*/
             IF         COND(&FILESIZ = 'L') THEN(DO)                                   /*MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLLOPD) TOFILE(&FLATLIB/&FLATFIL) +
                        TOMBR(MXFLFLPD) CRTFILE(*YES)                                   /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* CREATE 'MEDIUM' FILE (2,000 BYTES) */                                   /*MD033134*/
             IF         COND(&FILESIZ = 'M') THEN(DO)                                   /*MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLMEPD) TOFILE(&FLATLIB/&FLATFIL) +
                        TOMBR(MXFLFLPD) CRTFILE(*YES)                                   /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* CREATE 'SHORT' FILE (1,000 BYTES) */                                    /*MD033134*/
             IF         COND(&FILESIZ = 'S') THEN(DO)                                   /*MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLSHPD) TOFILE(&FLATLIB/&FLATFIL) +
                        TOMBR(MXFLFLPD) CRTFILE(*YES)                                   /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* CREATE 'VERY SHORT' FILE (500 BYTES) */                                 /*MD033134*/
             IF         COND(&FILESIZ = 'V') THEN(DO)                                   /*MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLVEPD) TOFILE(&FLATLIB/&FLATFIL) +
                        TOMBR(MXFLFLPD) CRTFILE(*YES)                                   /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* CREATE 'EXTREMELY SHORT' FILE (100 BYTES) */                            /*MD033134*/
             IF         COND(&FILESIZ = 'X' *OR &FILESIZ = ' ') +
                          THEN(DO)                                                      /*MD033134*/
             CPYF       FROMFILE(*LIBL/MXFLEXPD) TOFILE(&FLATLIB/&FLATFIL) +
                        TOMBR(MXFLFLPD) CRTFILE(*YES)                                   /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
             /* NOW COPY THE DATA */                                                    /*MD033134*/
             CPYF       FROMFILE(QTEMP/&FLATFIL) TOFILE(&FLATLIB/&FLATFIL) +
                        MBROPT(*ADD) FMTOPT(*NOCHK)                                     /*MD033134*/
/**/                                                                                    /*MD033134*/
             ENDDO                                                                      /*MD033134*/
/**/                                                                                    /*MD033134*/
                                                                                        /*AR924225*/
/** If EMIFS has a valid path, copy &FLATFIL to the IFS folder. */                      /*AR794225*/
             IF         ((&EMIFS *NE '*NRF') *AND (&EMIFS *NE +
                          ' ')) THEN(DO)                                                /*AR924225*/
                CHGVAR     VAR(&EMLNK) VALUE(&EMIFS *TCAT &FLATFIL +
                             *TCAT '.TXT')                                              /*AR924225*/
                CPYTOIMPF  FROMFILE(&FLATLIB/&FLATFIL) TOSTMF(&EMLNK) +
                             MBROPT(*REPLACE) STMFCCSID(*PCASCII) +
                             STMFAUT(*FILE) RCDDLM(*CRLF) +
                             DTAFMT(*FIXED)                                             /*AR924225*/
                MONMSG     MSGID(CPF2817) EXEC(DO)                                      /*AR924225*/
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(' +
                                Copy to IFS folder ended abnormally.+
                                Either the user is not authorized to +
                                the IFS folder or the IFS folder +
                                itself is not found.See CL Dump.') +
                                TOMSGQ(MOPERQ MRUNQ)                                    /*AR924225*/
                   DMPCLPGM                                                             /*AR924225*/
                   GOTO       CMDLBL(ABNOR)                                             /*AR924225*/
                                                                                        /*AR924225*/
                   ENDDO                                                                /*AR924225*/                                                                  
                ENDDO                                                                   /*AR924225*/
             ENDDO                                                                      /*AR792326*/
             ELSE (DO)                                                                  /*AR792326*/

             CALL       PGM(MXBULKTRM) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT)
             ENDDO                                                                      /*AR792326*/
             ENDDO                                                             /*CMX011*/

             DLTOVR *ALL

             RCLRSC
             RCLRSC     LVL(*CALLER)
             RCLACTGRP  ACTGRP(*ELIGIBLE)

/* If the extract is enabled and there was no error in the extract */

             IF COND(%SWITCH(XXXXX000)) THEN(DO)

/* Override Performance Data */

             OVRDBF     FILE(MXPLOGL1) MBR(IBULK) SHARE(*NO)

/* Call statistics update program  */

             CALL       PGM(MXUPDSTAT) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT &FUNC)

             ENDDO

/* Error */

             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0720 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO

/*/COPY WNCPYSRC,MXC0720MPE                                          */

             GOTO       CMDLBL(END)

 ABNOR:
/*/COPY WNCPYSRC,MXC0720ERR                                          */

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination */

               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0720 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)


END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

/*/COPY WNCPYSRC,MXC0720END                                          */

             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)

             ENDPGM
