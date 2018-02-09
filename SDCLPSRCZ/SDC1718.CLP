/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Save DTAARA for Rec.to Current Stat')           */
/*********************************************************************/
/*                                                                   */
/*     Midas - Standing Data Module                                  */
/*                                                                   */
/*     SDC1718 - SAVE DATA AREAS FOR RECOVERY TO CURRENT STATUS      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     Prev Amend No. CCM002             DATE 04SEP95                */
/*                    092583             DATE 04SEP95                */
/*                    S01427             DATE:27JAN93                */
/*                    E40283             DATE 23JUN92                */
/*                    S01319             DATE 20SEP91                */
/*                    RT0159             DATE 25JUN91                */
/*                    S01184             DATE 13OCT89                */
/*                    E23394             DATE 26SEP90                */
/*                    S01117             DATE 17/08/89               */
/*                    S01127             DATE 10/06/88               */
/*                    S03220             DATE 12/05/88               */
/*                    S05452             DATE 20/08/87               */
/*                    S01133             DATE 31/03/87               */
/*                    S01118             DATE 13/03/87               */
/*                    E81119             DATE 14/09/86               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     MD046248 - Finastra Rebranding                                */
/*     CCM002  -  Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, save the details in DLCDSTAT     */
/*                to DLCDTEMP.                                       */
/*     092583  -  Remove redundant Data Area MSFCTL                  */
/*     S01427  -  R10 CHIPS INCORPORATION                            */
/*     E40283  -  Remove redundant Data Areas SWSTAT/SWTMPR          */
/*             -  Move CHGVAR to before ENDPGM statement            */
/*     S01319  -  Remove redundant processing                       */
/*     RT0159  -  Messages should be sent via new Midas Info Screen.*/
/*     S01184  -  CONFIRMATION MATCHING INTERFACE                   */
/*     E23394  -  PROGRAM AMENDED TO CHECK FOR INTEREST ON ACCOUNTS */
/*                AS WELL AS RETAIL2                                */
/*     S01117  -  MULTIBRANCHING                                    */
/*     S01127  -  FUTURES AND OPTIONS INCORPORATION                 */
/*     S03220  -  Interface FUNDS TRANSFER.                         */
/*     S05452  -  INCLUSION OF AUTO RECONCILIATIONS                 */
/*     S01133  -  DEALING ROOM SYSTEM                               */
/*     S01118  -  MIDAS/S.W.I.F.T DIRECT LINK                       */
/*     E81119  -  DESCRIPTION OF CHANGE - THE SWIFT POSITIONS       */
/*                INSTEAD OF THE TELEX POSITIONS ARE CHECKED        */
/*                BEFORE SAVE OF DATA AREAS                         */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&DAREA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')   /*CCM002*/
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CCM002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CCM002*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CCM002*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)             /*CCM002*/
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Save Data Areas For Recovery to Current +
                          Status') TOMSGQ(MRUNQ)
/**/
/* RETRIEVE STANDARD DATA AREAS AND SAVE CURRENT STATUS TO BACKUP  */
/**/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MOD)
             CHGDTAARA  DTAARA(MDTMPR) VALUE(&MOD)
/**/
             RTVDTAARA  DTAARA(MNATN) RTNVAR(&DAREA)
             CHGDTAARA  DTAARA(MNTMPR) VALUE(&DAREA)
/**/                                                                  /*S01127*/
/**/
             RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&DAREA)                 /*S01117*/
             CHGDTAARA  DTAARA(RPTMPR) VALUE(&DAREA)                  /*S01117*/
/**/                                                                  /*S01127*/
             IF         COND(%SST(&MOD 50 1) *EQ 'Y') THEN(DO)        /*S01127*/
                RTVDTAARA  DTAARA(NACON) RTNVAR(&DAREA)               /*S01127*/
                CHGDTAARA  DTAARA(NATMPR) VALUE(&DAREA)               /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&DAREA)
             CHGDTAARA  DTAARA(SDTMPR) VALUE(&DAREA)
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&DAREA)
             CHGDTAARA  DTAARA(GLTMPR) VALUE(&DAREA)
/**/
/* CHECK MMOD AND SAVE DATAAREAS FOR ALL ON-LINE MODULES         */
/**/
             IF         COND(%SST(&MOD 2 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(DLTMPR) VALUE(&DAREA)
             ENDDO
/**/
             IF         COND(%SST(&MOD 4 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(CLSTAT) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(CLTMPR) VALUE(&DAREA)
             ENDDO
/**/
             IF         COND(%SST(&MOD 5 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(STSTAT) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(STTMPR) VALUE(&DAREA)
             ENDDO
/**/
/************IF*********COND(%SST(&MOD*6*1)**EQ*'Y')*THEN(DO)*******/ /*S01319*/
/***************RTVDTAARA**DTAARA(BCSTAT)*RTNVAR(&DAREA)************/ /*S01319*/
/***************CHGDTAARA**DTAARA(BCTMPR)*VALUE(&DAREA)*************/ /*S01319*/
/************ENDDO**************************************************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/**/
             IF         COND(%SST(&MOD 7 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(EMTMPR) VALUE(&DAREA)
             ENDDO
/**/
             IF         COND(%SST(&MOD 10 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(LESTAT) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(LETMPR) VALUE(&DAREA)
             ENDDO
/**/
/************IF******COND(%SST(&MOD*11*1)**EQ*'Y')*THEN(DO)/*S01133*/ /*S01319*/
/***************RTVDTAARA**DTAARA(FDSTAT)*RTNVAR(&DAREA)** /*S01133*/ /*S01319*/
/***************CHGDTAARA**DTAARA(FDTMPR)*VALUE(&DAREA)*** /*S01133*/ /*S01319*/
/************ENDDO**************************************** /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
/************IF******COND(%SST(&MOD*12*1)**EQ*'Y')*THEN(DO)/*S01133*/ /*S01319*/
/***************RTVDTAARA**DTAARA(CMSTAT)*RTNVAR(&DAREA)** /*S01133*/ /*S01319*/
/***************CHGDTAARA**DTAARA(CMTMPR)*VALUE(&DAREA)*** /*S01133*/ /*S01319*/
/************ENDDO**************************************** /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
/************IF******COND(%SST(&MOD*13*1)**EQ*'Y')*THEN(DO)/*S01133*/ /*S01319*/
/***************RTVDTAARA**DTAARA(FXSTAT)*RTNVAR(&DAREA)** /*S01133*/ /*S01319*/
/***************CHGDTAARA**DTAARA(FXTMPR)*VALUE(&DAREA)*** /*S01133*/ /*S01319*/
/************ENDDO**************************************** /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
             IF         COND(%SST(&MOD 14 1) *EQ 'Y') THEN(DO)        /*S01133*/
                RTVDTAARA  DTAARA(MMSTAT) RTNVAR(&DAREA)              /*S01133*/
                CHGDTAARA  DTAARA(MMTMPR) VALUE(&DAREA)               /*S01133*/
             ENDDO                                                    /*S01133*/
/**/
/**********  IF         COND(%SST(&MOD 16 1) *EQ 'Y') THEN(DO)        /*E23394*/
             IF         COND((%SST(&MOD 16 1) *EQ 'Y') *OR  +
                          (%SST(&MOD 23 1) *EQ 'Y')) THEN(DO)         /*E23394*/
                RTVDTAARA  DTAARA(RESTAT) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(RETMPR) VALUE(&DAREA)
             ENDDO
/* S03220 */                                                          /*S03220*/
             IF         COND(%SST(&MOD 57 1) *EQ 'Y') THEN(DO)        /*S03220*/
                RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&DAREA)              /*S03220*/
                CHGDTAARA  DTAARA(FTTMPR) VALUE(&DAREA)               /*S03220*/
             ENDDO                                                    /*S03220*/
/**/
/* SAVE SWIFT DIRECT LINK DATA AREAS                                    S01118*/
/**/                                                                  /*S01118*/
             IF         COND(%SST(&MOD 18 1) *EQ 'Y') THEN(DO)        /*S01118*/
                RTVDTAARA  DTAARA(MSSTAT) RTNVAR(&DAREA)              /*S01118*/
                CHGDTAARA  DTAARA(MSTMPR) VALUE(&DAREA)               /*S01118*/
/***********    RTVDTAARA  DTAARA(MSFCTL) RTNVAR(&DAREA)       /*S01118*092583*/
/***********    CHGDTAARA  DTAARA(MFTMPR) VALUE(&DAREA)        /*S01118*092583*/
/***********    RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&DAREA)     /*S01118*092583*/
/***********    CHGDTAARA  DTAARA(MKTMPR) VALUE(&DAREA)        /*S01118*092583*/
             ENDDO                                                    /*S01118*/
/**/
             IF         COND(%SST(&MOD 22 1) *EQ 'Y') THEN(DO)        /*S05452*/
                RTVDTAARA  DTAARA(RCSTAT) RTNVAR(&DAREA)              /*S05452*/
                CHGDTAARA  DTAARA(RCTMPR) VALUE(&DAREA)               /*S05452*/
             ENDDO                                                    /*S05452*/
/**/
/************IF         COND(%SST(&MOD 33 8) *NE 'NNNNNNNN') THEN(DO    E81119*/
/************IF  COND(%SST(&MOD 25 8) *NE 'NNNNNNNN') THEN(DO)   E81119 S01118*/
/************IF         COND(%SST(&MOD 25 8) *NE 'NNNNNNNN' *AND + */ /*E40283*/
/************             %SST(&MOD 18 1) *EQ 'N') THEN(DO)    /*S01118*E40283*/
/************   RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&DAREA)           */ /*E40283*/
/************   CHGDTAARA  DTAARA(SWTMPR) VALUE(&DAREA)            */ /*E40283*/
/************ENDDO                                                 */ /*E40283*/
/**/
/* SAVE TELEX DIRECT LINK DATA AREA                                     S01118*/
/**/                                                                  /*S01118*/
             IF         COND(%SST(&MOD 51 1) *EQ 'Y') THEN(DO)        /*S01118*/
                RTVDTAARA  DTAARA(MTFCTL) RTNVAR(&DAREA)              /*S01118*/
                CHGDTAARA  DTAARA(MTTMPR) VALUE(&DAREA)               /*S01118*/
             ENDDO                                                    /*S01118*/
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
             IF         COND(%SST(&MOD 50 1) *EQ 'Y') THEN(DO)        /*S01127*/
                RTVDTAARA  DTAARA(FFSTAT) RTNVAR(&DAREA)              /*S01127*/
                CHGDTAARA  DTAARA(FFTMPR) VALUE(&DAREA)               /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
             IF         COND(%SST(&MOD 60 1) *EQ 'Y') THEN(DO)        /*S01184*/
                RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&DAREA)              /*S01184*/
                CHGDTAARA  DTAARA(CFTEMP) VALUE(&DAREA)               /*S01184*/
             ENDDO                                                    /*S01184*/
/**/                                                                  /*S01427*/
/*  MIDAS/CHIPS DISKETTE                                           */ /*S01427*/
/**/                                                                  /*S01427*/
             IF COND(%SST(&MOD 41 4) *NE 'NNNN') THEN(DO)             /*S01427*/
                RTVDTAARA DTAARA(MCSTAT) RTNVAR(&DAREA)               /*S01427*/
                CHGDTAARA DTAARA(MCTMPR) VALUE(&DAREA)                /*S01427*/
             ENDDO                                                    /*S01427*/
/**/                                                                  /*S01427*/
/*  CHIPS/MIDAS                                                    */ /*S01427*/
/**/                                                                  /*S01427*/
             IF COND(%SST(&MOD 45 1) *NE 'N') THEN(DO)                /*S01427*/
                RTVDTAARA DTAARA(CPSTAT) RTNVAR(&DAREA)               /*S01427*/
                CHGDTAARA DTAARA(CPTMPR) VALUE(&DAREA)                /*S01427*/
             ENDDO                                                    /*S01427*/
                                                                      /*S01184*/
/**/                                                                  /*CCM002*/
/*    Check if Citydealer Interface feature is active.                /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCM002*/
             CHGVAR     VAR(&SAR) VALUE('CCM002')                     /*CCM002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CCM002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))                   /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active, retrieve the values in       /*CCM002*/
/*    data area DLCDSTAT.                                             /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
               CHGDTAARA  DTAARA(DLCDTEMP) VALUE(&CDSTAT)             /*CCM002*/
             ENDDO                                                    /*CCM002*/
/**/
             GOTO END
/**/
/*  ABNORMAL TERMINATION PROCESSING */
/**/
/***ABNOR:******SNDPGMMSG  MSG('PROGRAM  Save Data Areas For Recovery+/*RT0159*/
/***********              to Current Status - ENDED ABNORMALLY') +    /*RT0159*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*RT0159*/
 ABNOR:                                                               /*RT0159*/
             SNDPGMMSG  MSG('PROGRAM  Save Data Areas For Recovery +
                          to Current Status - ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL       PGM(SDC0700) PARM('SDC1718' 'SDARTCSABN' ' +
                          ')                                          /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
 
/**CHGVAR*VAR(&BISCPY)*VALUE('COPYRIGHT MKI')                      */ /*E40283*/
