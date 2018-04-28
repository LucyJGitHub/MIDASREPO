/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account Transfer Utility COB Component 2')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC003700 - Midas GL Account Transfer Utility               */
/*                   Conversion Utility - Control 2                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/*       Last Amend No. AR719317           Date 19Jul11              */
/*       Prev Amend No. BUG28073           Date 26Aug10              */
/*                      BUG28066           Date 24Aug10              */
/*                      BUG28033           Date 12Aug10              */
/*                      BUG27821           Date 22Jun10              */
/*                      BUG27724           Date 03Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27473           Date 21Apr10              */
/*                      BUG27224           Date 16Mar10              */
/*                      CGL114  *CREATE    Date 04Jan10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR719317 - Include T_GZAMADEX in ATU processing             */
/*       BUG28073 - Add missing files in ATU                         */
/*       BUG28066 - ACCTFR 10001 failed                              */
/*       BUG28033 - Add missing files in ATU                         */
/*       BUG27821 - Include retail files in ATU                      */
/*       BUG27724 - Include RESWEPPD file in ATU                     */
/*       BUG27473 - Added new files for rmvjrnchg if switch on       */
/*       BUG27224 - New files SOBTRD and SOBDMVD to be added         */
/*       CGL114 - Account Transfer Utility                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
             DCL        VAR(&GLDA10)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENDCMTCTL) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&CGL030) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CRE005) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CRE015) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1)                                 /*BUG27473*/
             DCL        VAR(&CRE001) TYPE(*CHAR) LEN(1)                                 /*BUG27473*/
             DCL        VAR(&CAP186) TYPE(*CHAR) LEN(1)                                 /*BUG27473*/
             DCL        VAR(&CRN001) TYPE(*CHAR) LEN(1)                                 /*BUG27473*/
             DCL        VAR(&CAP204) TYPE(*CHAR) LEN(1)                                 /*BUG27821*/
/*/COPY WNCPYSRC,GLH00608                                            */
             DCL        VAR(&ZONE) TYPE(*CHAR) LEN(10)                                  /*AR719317*/
             DCL        VAR(&@RTCD)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&@OPTN)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&@SARD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&STARTSEQ) TYPE(*DEC) LEN(10)
             DCL        VAR(&STARTSEQA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LASTSEQ) TYPE(*DEC) LEN(10)
             DCL        VAR(&LASTSEQA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                   /*AR719317*/
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)                                  /*AR719317*/
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')                   /*AR719317*/
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)                               /*AR719317*/
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)                                /*AR719317*/
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)                              /*AR719317*/
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)                              /*AR719317*/
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)                                /*AR719317*/
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)                              /*AR719317*/
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area +
                          Equivalent') AUT(*USE))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDMSG     MSG('GLC003700 - Account Transfer Conversion +
                          Utility-Phase 2 started') TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RTVDTAARA  DTAARA(GLDA10) RTNVAR(&GLDA10)
 
             CHGVAR     VAR(&@RTCD) VALUE('       ')
             CHGVAR     VAR(&@OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&@SARD) VALUE('CGL030')
 
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)
 
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL030) VALUE('Y'))
 
             CHGVAR     VAR(&@RTCD) VALUE('       ')
             CHGVAR     VAR(&@SARD) VALUE('CRE005')
 
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)
 
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE005) VALUE('Y'))
 
             CHGVAR     VAR(&@RTCD) VALUE('       ')
             CHGVAR     VAR(&@SARD) VALUE('CRE015')
 
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)
 
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE015) VALUE('Y'))
                                                                                        /*BUG27473*/
             CHGVAR     VAR(&@RTCD) VALUE('       ')                                    /*BUG27473*/
             CHGVAR     VAR(&@SARD) VALUE('CLE025')                                     /*BUG27473*/
                                                                                        /*BUG27473*/
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)                        /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE025) VALUE('Y'))                                      /*BUG27473*/
                                                                                        /*BUG27473*/
             CHGVAR     VAR(&@RTCD) VALUE('       ')                                    /*BUG27473*/
             CHGVAR     VAR(&@SARD) VALUE('CRE001')                                     /*BUG27473*/
                                                                                        /*BUG27473*/
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)                        /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE001) VALUE('Y'))                                      /*BUG27473*/
                                                                                        /*BUG27473*/
             CHGVAR     VAR(&@RTCD) VALUE('       ')                                    /*BUG27473*/
             CHGVAR     VAR(&@SARD) VALUE('CAP186')                                     /*BUG27473*/
                                                                                        /*BUG27473*/
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)                        /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP186) VALUE('Y'))                                      /*BUG27473*/
                                                                                        /*BUG27473*/
             CHGVAR     VAR(&@RTCD) VALUE('       ')                                    /*BUG27473*/
             CHGVAR     VAR(&@SARD) VALUE('CRN001')                                     /*BUG27473*/
                                                                                        /*BUG27473*/
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)                        /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRN001) VALUE('Y'))                                      /*BUG27473*/
                                                                                        /*BUG27821*/
             CHGVAR     VAR(&@RTCD) VALUE('       ')                                    /*BUG27821*/
             CHGVAR     VAR(&@SARD) VALUE('CAP204')                                     /*BUG27821*/
                                                                                        /*BUG27821*/
             CALL       PGM(AOSARDR0) PARM(&@RTCD &@OPTN &@SARD)                        /*BUG27821*/
                                                                                        /*BUG27821*/
             IF         COND(&@RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP204) VALUE('Y'))                                      /*BUG27821*/
/*/COPY WNCPYSRC,GLH00609                                            */
 
             IF         COND(&GLDA10 *NE 'C') THEN(DO)
 
             GOTO       CMDLBL(ABNOR)
 
             ENDDO
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&ENDCMTCTL) +
                          VALUE('N'))
 
             CALL       PGM(GLC009200)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGDTAARA  DTAARA(GLDA10) VALUE('F')
                GOTO       CMDLBL(ABNOR)
             ENDDO
                                                                                        /*AR719317*/
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)                                                      /*AR719317*/
                                                                                        /*AR719317*/
/** Global ATU file processing*/                                                        /*AR719317*/
             CALL       PGM(GP000042) PARM(&ZOZONE)                                     /*AR719317*/
                                                                                        /*AR719317*/
/** Transfer global audit report */                                                     /*AR719317*/
             CALL       PGM(GP000041) PARM(&ZOZONE)                                     /*AR719317*/
                                                                                        /*AR719317*/
             GOTO       CMDLBL(TAG9999)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC003700 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNSEQNBR(&LASTSEQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&LASTSEQA) VALUE(&LASTSEQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(ACCTFRJRNE (11 10)) VALUE(&LASTSEQA)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RTVDTAARA  DTAARA(ACCTFRJRNE (1 10)) RTNVAR(&STARTSEQA)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&STARTSEQ) VALUE(&STARTSEQA)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/**********  RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (ACCNTBXC) + */                       /*BUG27224*/
/**********               (SDNOSTPD) (TABLETL) (APOSTPD) (APOSTRA) + */                 /*BUG27224*/
/**********               (CLEARPD) (GLJEHPPD) (REHISPD) (REHISPS) + */                 /*BUG27224*/
/**********               (REHISPM) (REHPOSPP) (REHPOSPM) + */                          /*BUG27224*/
/**********               (REHPOSR1) (REHPOSR2) (REHPOSR3) (RECOMD) + */                /*BUG27224*/
/**********               (REACRD) (REIACD) (AMACCD) (DEALSDB) + */                     /*BUG27224*/
/**********               (FXDEALPP) (DEALSDC) (MMDELDPP) (DEALSDE) + */                /*BUG27224*/
/**********               (MMDENSPP) (DEALSDD) (MMDENBPP) (DEALSDG) + */                /*BUG27224*/
/**********               (DEAMSDI) (MMDEAMPP) (CLOANCL) (FCLTYFN) + */                 /*BUG27224*/
/**********               (CUSEXCE) (HELDIHB) (STANDSB) (STOPCSD) + */                  /*BUG27224*/
/**********               (REDEFD) (FUSIONPD) (RELINKP) (INPAYDD) + */                  /*BUG27224*/
/**********               (OTPAYDD) (CQCOCDD) (CQCODDD) (CQPACDD) + */                  /*BUG27224*/
/**********               (CQPADDD) (MEMOS) (CLOANCK) (FCLTYFM) + */                    /*BUG27224*/
/**********               (ATPRPD) (BULKTD) (CNCTRD) (HSTTRD) + */                      /*BUG27224*/
/**********               (SOBTRD) (TRADSD) (TRATXD) (POSETD) + */                      /*BUG27224*/
/**********               (STDSED) (DPTMVD) (SEOCFSPD) (INTPSDD) + */                   /*BUG27224*/
/**********               (LEFEEAD) (GLATULPD) (SDEXSTPD) + */                          /*BUG27224*/
/**********               (GLACPHPD) (GLSLACPD) (GLACRFPD) + */                         /*BUG27224*/
/**********               (LEFEED) (LESTALPD) (LOAMSDK) (SOBDMVD) + */                  /*BUG27224*/
/**********               (GLAUTFPD) (GLJESPPD) (GLVALPPD) + */                         /*BUG27224*/
/**********               (RSACMTPD) (LEPARTPD) (GLHIBLPD) + */                         /*BUG27224*/
/**********               (GESUPD) (GESUZZ) (SWACSSB) (SWPOSPD) + */                    /*BUG27224*/
/**********               (SWPOSRA) (REAPWDPD)) + */                                    /*BUG27224*/
/**********               RCVRNG(*CURRENT) FROMENT(&LASTSEQ) + */                       /*BUG27224*/
/**********               TOENT(&STARTSEQ) */                                           /*BUG27224*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (ACCNTBXC) + */                       /*BUG27724*/
/**********               (SDNOSTPD) (TABLETL) (APOSTPD) (APOSTRA) + */                 /*BUG27724*/
/**********               (CLEARPD) (GLJEHPPD) (REHISPD) (REHISPS) + */                 /*BUG27724*/
/**********               (REHISPM) (REHPOSPP) (REHPOSPM) + */                          /*BUG27724*/
/**********               (REHPOSR1) (REHPOSR2) (REHPOSR3) (RECOMD) + */                /*BUG27724*/
/**********               (REACRD) (REIACD) (AMACCD) (DEALSDB) + */                     /*BUG27724*/
/**********               (FXDEALPP) (DEALSDC) (MMDELDPP) (DEALSDE) + */                /*BUG27724*/
/**********               (MMDENSPP) (DEALSDD) (MMDENBPP) (DEALSDG) + */                /*BUG27724*/
/**********               (DEAMSDI) (MMDEAMPP) (CLOANCL) (FCLTYFN) + */                 /*BUG27724*/
/**********               (CUSEXCE) (HELDIHB) (STANDSB) (STOPCSD) + */                  /*BUG27724*/
/**********               (REDEFD) (FUSIONPD) (RELINKP) (INPAYDD) + */                  /*BUG27724*/
/**********               (OTPAYDD) (CQCOCDD) (CQCODDD) (CQPACDD) + */                  /*BUG27724*/
/**********               (CQPADDD) (MEMOS) (CLOANCK) (FCLTYFM) + */                    /*BUG27724*/
/**********               (ATPRPD) (BULKTD) (CNCTRD) (HSTTRD) + */                      /*BUG27724*/
/**********               (TRADSD) (TRATXD) (POSETD) + */                               /*BUG27724*/
/**********               (STDSED) (DPTMVD) (SEOCFSPD) (INTPSDD) + */                   /*BUG27724*/
/**********               (LEFEEAD) (GLATULPD) (SDEXSTPD) + */                          /*BUG27724*/
/**********               (GLACPHPD) (GLSLACPD) (GLACRFPD) + */                         /*BUG27724*/
/**********               (LEFEED) (LESTALPD) (LOAMSDK) + */                            /*BUG27724*/
/**********               (GLAUTFPD) (GLJESPPD) (GLVALPPD) + */                         /*BUG27724*/
/**********               (RSACMTPD) (LEPARTPD) (GLHIBLPD) + */                         /*BUG27724*/
/**********               (GESUPD) (GESUZZ) (SWACSSB) (SWPOSPD) + */                    /*BUG27724*/
/**********               (SWPOSRA) (REAPWDPD)) + */                                    /*BUG27724*/
/**********               RCVRNG(*CURRENT) FROMENT(&LASTSEQ) + */                       /*BUG27724*/
/**********               TOENT(&STARTSEQ) */                              /*BUG27224*/ /*BUG27724*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (ACCNTBXC) + */                       /*BUG27821*/
/**********               (SDNOSTPD) (TABLETL) (APOSTPD) (APOSTRA) + */                 /*BUG27821*/
/**********               (CLEARPD) (GLJEHPPD) (REHISPD) (REHISPS) + */                 /*BUG27821*/
/**********               (REHISPM) (REHPOSPP) (REHPOSPM) + */                          /*BUG27821*/
/**********               (REHPOSR1) (REHPOSR2) (REHPOSR3) (RECOMD) + */                /*BUG27821*/
/**********               (REACRD) (REIACD) (AMACCD) (DEALSDB) + */                     /*BUG27821*/
/**********               (FXDEALPP) (DEALSDC) (MMDELDPP) (DEALSDE) + */                /*BUG27821*/
/**********               (MMDENSPP) (DEALSDD) (MMDENBPP) (DEALSDG) + */                /*BUG27821*/
/**********               (DEAMSDI) (MMDEAMPP) (CLOANCL) (FCLTYFN) + */                 /*BUG27821*/
/**********               (CUSEXCE) (HELDIHB) (STANDSB) (STOPCSD) + */                  /*BUG27821*/
/**********               (REDEFD) (FUSIONPD) (RELINKP) (INPAYDD) + */                  /*BUG27821*/
/**********               (OTPAYDD) (CQCOCDD) (CQCODDD) (CQPACDD) + */                  /*BUG27821*/
/**********               (CQPADDD) (MEMOS) (CLOANCK) (FCLTYFM) + */                    /*BUG27821*/
/**********               (ATPRPD) (BULKTD) (CNCTRD) (HSTTRD) + */                      /*BUG27821*/
/**********               (TRADSD) (TRATXD) (POSETD) + */                               /*BUG27821*/
/**********               (STDSED) (DPTMVD) (SEOCFSPD) (INTPSDD) + */                   /*BUG27821*/
/**********               (LEFEEAD) (GLATULPD) (SDEXSTPD) + */                          /*BUG27821*/
/**********               (GLACPHPD) (GLSLACPD) (GLACRFPD) + */                         /*BUG27821*/
/**********               (LEFEED) (LESTALPD) (LOAMSDK) + */                            /*BUG27821*/
/**********               (GLAUTFPD) (GLJESPPD) (GLVALPPD) + */                         /*BUG27821*/
/**********               (RSACMTPD) (LEPARTPD) (GLHIBLPD) + */                         /*BUG27821*/
/**********               (GESUPD) (GESUZZ) (SWACSSB) (SWPOSPD) + */                    /*BUG27821*/
/**********               (SWPOSRA) (REAPWDPD) (RESWEPPD)) + */                         /*BUG27821*/
/**********               RCVRNG(*CURRENT) FROMENT(&LASTSEQ) + */                       /*BUG27821*/
/**********               TOENT(&STARTSEQ) */                              /*BUG27724*/ /*BUG27821*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (ACCNTBXC) + */                       /*BUG28033*/
/**********               (SDNOSTPD) (TABLETL) (APOSTPD) (APOSTRA) + */                 /*BUG28033*/
/**********               (CLEARPD) (GLJEHPPD) (REHISPD) (REHISPS) + */                 /*BUG28033*/
/**********               (REHISPM) (REHPOSPP) (REHPOSPM) + */                          /*BUG28033*/
/**********               (REHPOSR1) (REHPOSR2) (REHPOSR3) (RECOMD) + */                /*BUG28033*/
/**********               (REACRD) (REIACD) (AMACCD) (DEALSDB) + */                     /*BUG28033*/
/**********               (FXDEALPP) (DEALSDC) (MMDELDPP) (DEALSDE) + */                /*BUG28033*/
/**********               (MMDENSPP) (DEALSDD) (MMDENBPP) (DEALSDG) + */                /*BUG28033*/
/**********               (DEAMSDI) (MMDEAMPP) (CLOANCL) (FCLTYFN) + */                 /*BUG28033*/
/**********               (CUSEXCE) (HELDIHB) (STANDSB) (STOPCSD) + */                  /*BUG28033*/
/**********               (REDEFD) (FUSIONPD) (RELINKP) (INPAYDD) + */                  /*BUG28033*/
/**********               (OTPAYDD) (CQCOCDD) (CQCODDD) (CQPACDD) + */                  /*BUG28033*/
/**********               (CQPADDD) (MEMOS) (CLOANCK) (FCLTYFM) + */                    /*BUG28033*/
/**********               (ATPRPD) (BULKTD) (CNCTRD) (HSTTRD) + */                      /*BUG28033*/
/**********               (TRADSD) (TRATXD) (POSETD) + */                               /*BUG28033*/
/**********               (STDSED) (DPTMVD) (SEOCFSPD) (INTPSDD) + */                   /*BUG28033*/
/**********               (LEFEEAD) (GLATULPD) (SDEXSTPD) + */                          /*BUG28033*/
/**********               (GLACPHPD) (GLSLACPD) (GLACRFPD) + */                         /*BUG28033*/
/**********               (LEFEED) (LESTALPD) (LOAMSDK) + */                            /*BUG28033*/
/**********               (GLAUTFPD) (GLJESPPD) (GLVALPPD) + */                         /*BUG28033*/
/**********               (RSACMTPD) (LEPARTPD) (GLHIBLPD) + */                         /*BUG28033*/
/**********               (GESUPD) (GESUZZ) (SWACSSB) (SWPOSPD) + */                    /*BUG28033*/
/**********               (SWPOSRA) (REAPWDPD) (RESWEPPD) + */                          /*BUG28033*/
/**********               (REODHSPD) (MEMOSME) (CPOSTDD)) + */                          /*BUG28033*/
/**********               RCVRNG(*CURRENT) FROMENT(&LASTSEQ) + */                       /*BUG28033*/
/**********               TOENT(&STARTSEQ) */                              /*BUG27821*/ /*BUG28033*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (ACCNTBXC) + */                       /*BUG28073*/
/**********               (SDNOSTPD) (TABLETL) (APOSTPD) (APOSTRA) + */                 /*BUG28073*/
/**********               (CLEARPD) (GLJEHPPD) (REHISPD) (REHISPS) + */                 /*BUG28073*/
/**********               (REHISPM) (REHPOSPP) (REHPOSPM) + */                          /*BUG28073*/
/**********               (REHPOSR1) (REHPOSR2) (REHPOSR3) (RECOMD) + */                /*BUG28073*/
/**********               (REACRD) (REIACD) (AMACCD) (DEALSDB) + */                     /*BUG28073*/
/**********               (FXDEALPP) (DEALSDC) (MMDELDPP) (DEALSDE) + */                /*BUG28073*/
/**********               (MMDENSPP) (DEALSDD) (MMDENBPP) (DEALSDG) + */                /*BUG28073*/
/**********               (DEAMSDI) (MMDEAMPP) (CLOANCL) (FCLTYFN) + */                 /*BUG28073*/
/**********               (CUSEXCE) (HELDIHB) (STANDSB) (STOPCSD) + */                  /*BUG28073*/
/**********               (REDEFD) (FUSIONPD) (RELINKP) (INPAYDD) + */                  /*BUG28073*/
/**********               (OTPAYDD) (CQCOCDD) (CQCODDD) (CQPACDD) + */                  /*BUG28073*/
/**********               (CQPADDD) (MEMOS) (CLOANCK) (FCLTYFM) + */                    /*BUG28073*/
/**********               (ATPRPD) (BULKTD) (CNCTRD) (HSTTRD) + */                      /*BUG28073*/
/**********               (TRADSD) (TRATXD) (POSETD) + */                               /*BUG28073*/
/**********               (STDSED) (DPTMVD) (SEOCFSPD) (INTPSDD) + */                   /*BUG28073*/
/**********               (LEFEEAD) (GLATULPD) (SDEXSTPD) + */                          /*BUG28073*/
/**********               (GLACPHPD) (GLSLACPD) (GLACRFPD) + */                         /*BUG28073*/
/**********               (LEFEED) (LESTALPD) (LOAMSDK) + */                            /*BUG28073*/
/**********               (GLAUTFPD) (GLJESPPD) (GLVALPPD) + */                         /*BUG28073*/
/**********               (RSACMTPD) (LEPARTPD) (GLHIBLPD) + */                         /*BUG28073*/
/**********               (GESUPD) (GESUZZ) (SWACSSB) (SWPOSPD) + */                    /*BUG28073*/
/**********               (SWPOSRA) (REAPWDPD) (RESWEPPD) + */                          /*BUG28073*/
/**********               (REODHSPD) (MEMOSME) (CPOSTDD) (GLAVBLPD) + */                /*BUG28073*/
/**********               (FACHISA) (GLCOLLPD) (GLCOLAPD) (RECAPM) + */                 /*BUG28073*/
/**********               (FFACMVD) (GLACBTPD) (DLBHISPD) (DLCHISPD) + */               /*BUG28073*/
/**********               (DLDHISPD) (DLEHISPD) (DLGHISPD)) + */                        /*BUG28073*/
/**********               RCVRNG(*CURRENT) FROMENT(&LASTSEQ) + */                       /*BUG28073*/
/**********               TOENT(&STARTSEQ) */                              /*BUG28033*/ /*BUG28073*/
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (ACCNTBXC) +
                          (SDNOSTPD) (TABLETL) (APOSTPD) (APOSTRA) +
                          (CLEARPD) (GLJEHPPD) (REHISPD) (REHISPS) +
                          (REHISPM) (REHPOSPP) (REHPOSPM) +
                          (REHPOSR1) (REHPOSR2) (REHPOSR3) (RECOMD) +
                          (REACRD) (REIACD) (AMACCD) (DEALSDB) +
                          (FXDEALPP) (DEALSDC) (MMDELDPP) (DEALSDE) +
                          (MMDENSPP) (DEALSDD) (MMDENBPP) (DEALSDG) +
                          (DEAMSDI) (MMDEAMPP) (CLOANCL) (FCLTYFN) +
                          (CUSEXCE) (HELDIHB) (STANDSB) (STOPCSD) +
                          (REDEFD) (FUSIONPD) (RELINKP) (INPAYDD) +
                          (OTPAYDD) (CQCOCDD) (CQCODDD) (CQPACDD) +
                          (CQPADDD) (MEMOS) (CLOANCK) (FCLTYFM) +
                          (ATPRPD) (BULKTD) (CNCTRD) (HSTTRD) +
                          (TRADSD) (TRATXD) (POSETD) +
                          (STDSED) (DPTMVD) (SEOCFSPD) (INTPSDD) +
                          (LEFEEAD) (GLATULPD) (SDEXSTPD) +
                          (GLACPHPD) (GLSLACPD) (GLACRFPD) +
                          (LEFEED) (LESTALPD) (LOAMSDK) +
                          (GLAUTFPD) (GLJESPPD) (GLVALPPD) +
                          (RSACMTPD) (LEPARTPD) (GLHIBLPD) +
                          (GESUPD) (GESUZZ) (SWACSSB) (SWPOSPD) +
                          (SWPOSRA) (REAPWDPD) (RESWEPPD) +
                          (REODHSPD) (MEMOSME) (CPOSTDD) (GLAVBLPD) +
                          (FACHISA) (GLCOLLPD) (GLCOLAPD) (RECAPM) +
                          (FFACMVD) (GLACBTPD) (DLBHISPD) (DLCHISPD) +
                          (DLDHISPD) (DLEHISPD) (DLGHISPD) (GLARWAPD) +
                          (GLFFAMPD) (GLGS94PD) (GLNETGPD) (GLNW94PD) +
                          (GLNWACPD) (GLOTSTPD) (GLPOSTPD) (GLPSTTPD) +
                          (GLRSACPD) (GLRWABPD) (LEFCENPD) (MXSGLACPD) +
                          (MXSRECEPD) (RECMBRPD) (RECMHLPD) +
                          (RECMLCHPD) (REGAHLPD) (REGAMXPD) +
                          (REHMRGPD) (REHPOS) (RELGAMXPD) (RELZSMXPD) +
                          (RERSTDPD) (REZSHLPD) (REZSMXPD) (REZSTDPD)) +
                          RCVRNG(*CURRENT) FROMENT(&LASTSEQ) +
                          TOENT(&STARTSEQ)                                              /*BUG28073*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&CGL030 *EQ 'Y') THEN(DO)
 
             RMVJRNCHG  JRN(ICJRN) FILE(GLSUNDPD) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
             IF         COND(&CRE005 *EQ 'Y') THEN(DO)
 
             RMVJRNCHG  JRN(ICJRN) FILE((RERCH1PD) (RERCH2PD) +
                          (RERCH3PD)) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
             IF         COND(&CRE015 *EQ 'Y') THEN(DO)
 
             RMVJRNCHG  JRN(ICJRN) FILE(REPRPNPD) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
                                                                                        /*BUG27473*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*BUG27473*/
                                                                                        /*BUG27473*/
             RMVJRNCHG  JRN(ICJRN) FILE(GLACNTQD) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)                            /*BUG27473*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*BUG27473*/
                                                                                        /*BUG27473*/
             ENDDO                                                                      /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&CRE001 *EQ 'Y') THEN(DO)                                  /*BUG27473*/
                                                                                        /*BUG27473*/
             RMVJRNCHG  JRN(ICJRN) FILE((REACX1PD) (REACX2PD)) +
                          RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)                            /*BUG27473*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*BUG27473*/
                                                                                        /*BUG27473*/
             ENDDO                                                                      /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&CAP186 *EQ 'Y') THEN(DO)                                  /*BUG27473*/
                                                                                        /*BUG27473*/
             RMVJRNCHG  JRN(ICJRN) FILE(SDNOSRQD) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)                            /*BUG27473*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*BUG27473*/
                                                                                        /*BUG27473*/
             ENDDO                                                                      /*BUG27473*/
                                                                                        /*BUG27473*/
             IF         COND(&CRN001 *EQ 'Y') THEN(DO)                                  /*BUG27473*/
                                                                                        /*BUG27473*/
             RMVJRNCHG  JRN(ICJRN) FILE(T_RNAMAD) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)                            /*BUG27473*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*BUG27473*/
                                                                                        /*BUG27473*/
             ENDDO                                                                      /*BUG27473*/
                                                                                        /*BUG27821*/
             IF         COND(&CAP204 *EQ 'Y') THEN(DO)                                  /*BUG27821*/
                                                                                        /*BUG27821*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((GLATMIPD) (GLHATMPD) + */                      /*BUG28066*/
/**********               (STATSTPD)) RCVRNG(*CURRENT) + */                             /*BUG28066*/
/**********               FROMENT(&LASTSEQ) TOENT(&STARTSEQ) */            /*BUG27821*/ /*BUG28066*/
             RMVJRNCHG  JRN(ICJRN) FILE((GLATMIPD) (GLHATMPD) +
                          (SDATSTPD)) RCVRNG(*CURRENT) +
                          FROMENT(&LASTSEQ) TOENT(&STARTSEQ)                            /*BUG28066*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*BUG27821*/
/*/COPY WNCPYSRC,GLH00610                                            */
                                                                                        /*BUG27821*/
             ENDDO                                                                      /*BUG27821*/
/*/COPY WNCPYSRC,GLH00613                                            */
 
/** End Program Processing */
 
 TAG9999:
             CHGVAR     VAR(&CPYFLD) VALUE(&CPYFLD)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(*ALL)
             MONMSG     (CPF0000 MCH0000)
 
             IF         COND(&ENDCMTCTL = 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             ENDDO
 
             RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
