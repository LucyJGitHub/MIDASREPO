/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Save DTAARA Aft.Rec.to Current Stat')           */
/*********************************************************************/
/*                                                                   */
/*     Midas - Standing Data Module                                  */
/*                                                                   */
/*     SDC1719 - RESTORE DATA AREAS AFTER RECOVERY TO CURRENT STATUS */
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
/*                    S01427             DATE 13JUL93                */
/*                    E40283             DATE 23JUN92                */
/*                    S01319             DATE 20SEP91                */
/*                    RT0159             DATE 26JUN91                */
/*                    S01184             DATE 13OCT89                */
/*                    E23394             DATE 26SEP90                */
/*                    S01117             DATE 17/08/89               */
/*                    S01127             DATE 02/06/88               */
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
/*                If feature is on, restore the details from         */
/*                DLCDTEMP to DLCDSTAT.                              */
/*     092583  -  Remove redundant Data Area MSFCTL                  */
/*     S01427  -  R10 CHIPS INCORPORATION                            */
/*     E40283  -  Remove redundant Data Areas SWSTAT/SWTMPR          */
/*             -  Move CHGVAR to before ENDPGM statement             */
/*     S01319  -  Remove redundant processing                        */
/*     RT0159  -  Messages should be sent via new Midas Info Screen. */
/*             -  Change 'save' to 'restore'.                        */
/*     S01184  -  CONFIRMATION MATCHING INTERFACE                    */
/*     E23394  -  PROGRAM AMENDED TO CHECK FOR INTEREST ON           */
/*                ACCOUNTS AS WELL AS RETAIL2                        */
/*     S01117  -  MULTIBRANCHING                                     */
/*     S01127  -  INCLUSION OF FUTURES AND OPTIONS                   */
/*     S03220  -  Interface FUNDS TRANSFER.                          */
/*     S05452  -  INCLUSION OF AUTO RECONCILIATIONS                  */
/*     S01133  -  DEALING ROOM SYSTEM                                */
/*     S01118  -  MIDAS/S.W.I.F.T. DIRECT LINK                       */
/*     E81119  -  DESCRIPTION OF CHANGE - THE SWIFT POSITIONS        */
/*                INSTEAD OF THE TELEX POSITIONS ARE CHECKED         */
/*                BEFORE RESTORE OF DATA AREAS                       */
/*                                                                   */
/*********************************************************************/
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
/************SNDPGMMSG  MSG('Save Data Areas For Recovery to Current +
/************             Status') TOMSGQ(MRUNQ)                      /*RT0159*/
             SNDPGMMSG  MSG('Restore Data Areas After Recovery to +
                          Current Status') TOMSGQ(MRUNQ)              /*RT0159*/
/**/
/* RETRIEVE BACKUP STANDARD DATA AREAS AND RESTORE TO CURRENT STATUS */
/**/
             RTVDTAARA  DTAARA(MDTMPR) RTNVAR(&MOD)
             CHGDTAARA  DTAARA(MMOD) VALUE(&MOD)
/**/
             RTVDTAARA  DTAARA(MNTMPR) RTNVAR(&DAREA)
             CHGDTAARA  DTAARA(MNATN) VALUE(&DAREA)
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
             RTVDTAARA  DTAARA(RPTMPR) RTNVAR(&DAREA)                 /*S01117*/
             CHGDTAARA  DTAARA(REPSEQ) VALUE(&DAREA)                  /*S01117*/
/**/                                                                  /*S01127*/
             IF         COND(%SST(&MOD 50 1) *EQ 'Y') THEN(DO)        /*S01127*/
                RTVDTAARA  DTAARA(NATMPR) RTNVAR(&DAREA)              /*S01127*/
                CHGDTAARA  DTAARA(NACON) VALUE(&DAREA)                /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/
             RTVDTAARA  DTAARA(SDTMPR) RTNVAR(&DAREA)
             CHGDTAARA  DTAARA(SDSTAT) VALUE(&DAREA)
/**/
             RTVDTAARA  DTAARA(GLTMPR) RTNVAR(&DAREA)
             CHGDTAARA  DTAARA(GLSTAT) VALUE(&DAREA)
/**/
/* CHECK MMOD AND RESTORE DATA AREA FOR ALL ON-LINE MODULES  */
/**/
             IF         COND(%SST(&MOD 2 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(DLTMPR) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(DLSTAT) VALUE(&DAREA)
             ENDDO
/**/
             IF         COND(%SST(&MOD 4 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(CLTMPR) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(CLSTAT) VALUE(&DAREA)
             ENDDO
/**/
             IF         COND(%SST(&MOD 5 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(STTMPR) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(STSTAT) VALUE(&DAREA)
             ENDDO
/**/
/************IF*********COND(%SST(&MOD*6*1)**EQ*'Y')*THEN(DO)*******/ /*S01319*/
/***************RTVDTAARA**DTAARA(BCTMPR)*RTNVAR(&DAREA)************/ /*S01319*/
/***************CHGDTAARA**DTAARA(BCSTAT)*VALUE(&DAREA)*************/ /*S01319*/
/************ENDDO**************************************************/ /*S01319*/
/**/
             IF         COND(%SST(&MOD 7 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(EMTMPR) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(EMSTAT) VALUE(&DAREA)
             ENDDO
/**/
             IF         COND(%SST(&MOD 10 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(LETMPR) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(LESTAT) VALUE(&DAREA)
             ENDDO
/**/
/************IF******COND(%SST(&MOD*11*1)**EQ*'Y')*THEN(DO)/*S01133*/ /*S01319*/
/***************RTVDTAARA**DTAARA(FDTMPR)*RTNVAR(&DAREA)** /*S01133*/ /*S01319*/
/***************CHGDTAARA**DTAARA(FDSTAT)*VALUE(&DAREA)*** /*S01133*/ /*S01319*/
/************ENDDO**************************************** /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
/************IF******COND(%SST(&MOD*12*1)**EQ*'Y')*THEN(DO)/*S01133*/ /*S01319*/
/***************RTVDTAARA**DTAARA(CMTMPR)*RTNVAR(&DAREA)** /*S01133*/ /*S01319*/
/***************CHGDTAARA**DTAARA(CMSTAT)*VALUE(&DAREA)*** /*S01133*/ /*S01319*/
/************ENDDO**************************************** /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
/************IF******COND(%SST(&MOD*13*1)**EQ*'Y')*THEN(DO)/*S01133*/ /*S01319*/
/***************RTVDTAARA**DTAARA(FXTMPR)*RTNVAR(&DAREA)** /*S01133*/ /*S01319*/
/***************CHGDTAARA**DTAARA(FXSTAT)*VALUE(&DAREA)*** /*S01133*/ /*S01319*/
/************ENDDO**************************************** /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
             IF         COND(%SST(&MOD 14 1) *EQ 'Y') THEN(DO)        /*S01133*/
                RTVDTAARA  DTAARA(MMTMPR) RTNVAR(&DAREA)              /*S01133*/
                CHGDTAARA  DTAARA(MMSTAT) VALUE(&DAREA)               /*S01133*/
             ENDDO                                                    /*S01133*/
/**********  IF         COND(%SST(&MOD 16 1) *EQ 'Y') THEN(DO)        /*E23394*/
             IF         COND((%SST(&MOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MOD 23 1) *EQ 'Y')) THEN(DO)         /*E23394*/
                RTVDTAARA  DTAARA(RETMPR) RTNVAR(&DAREA)
                CHGDTAARA  DTAARA(RESTAT) VALUE(&DAREA)
             ENDDO
/* S03220 */                                                          /*S03220*/
             IF         COND(%SST(&MOD 57 1) *EQ 'Y') THEN(DO)        /*S03220*/
                RTVDTAARA  DTAARA(FTTMPR) RTNVAR(&DAREA)              /*S03220*/
                CHGDTAARA  DTAARA(FTSTAT) VALUE(&DAREA)               /*S03220*/
             ENDDO                                                    /*S03220*/
/**/
/* RESTORE SWIFT DIRECT LINK DATA AREAS                                 S01118*/
/**/                                                                  /*S01118*/
             IF         COND(%SST(&MOD 18 1) *EQ 'Y') THEN(DO)        /*S01118*/
                RTVDTAARA  DTAARA(MSTMPR) RTNVAR(&DAREA)              /*S01118*/
                CHGDTAARA  DTAARA(MSSTAT) VALUE(&DAREA)               /*S01118*/
/***********    RTVDTAARA  DTAARA(MFTMPR) RTNVAR(&DAREA)       /*S01118*092583*/
/***********    CHGDTAARA  DTAARA(MSFCTL) VALUE(&DAREA)        /*S01118*092583*/
/***********    RTVDTAARA  DTAARA(MKTMPR) RTNVAR(&DAREA)       /*S01118*092583*/
/***********    CHGDTAARA  DTAARA(MSFCTLBK) VALUE(&DAREA)      /*S01118*092583*/
             ENDDO                                                    /*S01118*/
/**/
             IF         COND(%SST(&MOD 22 1) *EQ 'Y') THEN(DO)        /*S05452*/
                RTVDTAARA  DTAARA(RCTMPR) RTNVAR(&DAREA)              /*S05452*/
                CHGDTAARA  DTAARA(RCSTAT) VALUE(&DAREA)               /*S05452*/
             ENDDO                                                    /*S05452*/
/**/                                                                  /*S05452*/
/************IF         COND(%SST(&MOD 33 8) *NE 'NNNNNNNN') THEN(DO*  *E81119*/
/************IF   COND(%SST(&MOD 25 8) *NE 'NNNNNNNN') THEN(DO)  E81119 S01118*/
/************IF         COND(%SST(&MOD 25 8) *NE 'NNNNNNNN' *AND + */ /*E40283*/
/************             %SST(&MOD 18 1) *EQ 'N') THEN(DO)     *S01118*E40283*/
/************   RTVDTAARA  DTAARA(SWTMPR) RTNVAR(&DAREA)           */ /*E40283*/
/************   CHGDTAARA  DTAARA(SWSTAT) VALUE(&DAREA)            */ /*E40283*/
/************ENDDO                                                 */ /*E40283*/
/**/
/* SAVE TELEX DIRECT LINK DATA AREA                                     S01118*/
/**/                                                                  /*S01118*/
             IF         COND(%SST(&MOD 51 1) *EQ 'Y') THEN(DO)        /*S01118*/
                RTVDTAARA  DTAARA(MTTMPR) RTNVAR(&DAREA)              /*S01118*/
                CHGDTAARA  DTAARA(MTFCTL) VALUE(&DAREA)               /*S01118*/
             ENDDO                                                    /*S01118*/
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/* FUTURES AND OPTIONS                                              *  *S01127*/
/**/                                                                  /*S01127*/
             IF         COND(%SST(&MOD 50 1) *EQ 'Y') THEN(DO)        /*S01127*/
                RTVDTAARA  DTAARA(FFTMPR) RTNVAR(&DAREA)              /*S01127*/
                CHGDTAARA  DTAARA(FFSTAT) VALUE(&DAREA)               /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/                                                                  /*S01184*/
/* CONFIRMATION MATCHING                                           */ /*S01184*/
/**/                                                                  /*S01184*/
             IF         COND(%SST(&MOD 60 1) *EQ 'Y') THEN(DO)        /*S01184*/
                RTVDTAARA  DTAARA(CFTEMP) RTNVAR(&DAREA)              /*S01184*/
                CHGDTAARA  DTAARA(CFSTAT) VALUE(&DAREA)               /*S01184*/
             ENDDO                                                    /*S01184*/
                                                                      /*S01184*/
/**/                                                                  /*S01427*/
/*  MIDAS/CHIPS DISKETTE & ONLINE VERSION                             *S01427*/
/**/                                                                  /*S01427*/
             IF COND(%SST(&MOD 41 4) *NE 'NNNN') THEN(DO)             /*S01427*/
                RTVDTAARA DTAARA(MCTMPR) RTNVAR(&DAREA)               /*S01427*/
                CHGDTAARA DTAARA(MCSTAT) VALUE(&DAREA)                /*S01427*/
             ENDDO                                                    /*S01427*/
/**/                                                                  /*S01427*/
/*  CHIPS/MIDAS                                                    */ /*S01427*/
/**/                                                                  /*S01427*/
             IF COND(%SST(&MOD 45 1) *NE 'N') THEN(DO)                /*S01427*/
                RTVDTAARA DTAARA(CPTMPR) RTNVAR(&DAREA)               /*S01427*/
                CHGDTAARA DTAARA(CPSTAT) VALUE(&DAREA)                /*S01427*/
             ENDDO                                                    /*S01427*/
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
/*    data area DLCDTEMP.                                             /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDTEMP) RTNVAR(&CDSTAT)            /*CCM002*/
               CHGDTAARA  DTAARA(DLCDSTAT) VALUE(&CDSTAT)             /*CCM002*/
             ENDDO                                                    /*CCM002*/
/**/
             GOTO END
/**/
/* ERROR PROCESSING                                                  */
/**/
/***ABNOR:******SNDPGMMSG  MSG('PROGRAM  Save Data Areas For Recovery+/*RT0159*/
/***********              to Current Status - ENDED ABNORMALLY') +    /*RT0159*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*RT0159*/
 ABNOR:                                                               /*RT0159*/
             SNDPGMMSG  MSG('PROGRAM  Restore Data Areas After +
                          Recovery to Current Status - ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL PGM(SDC0700) PARM('SDC1719' 'RDARTCSABN' ' ')       /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
 
/**CHGVAR*VAR(&BISCPY)*VALUE('COPYRIGHT*ACT')                      */ /*E40283*/
