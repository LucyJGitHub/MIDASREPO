/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL DEALS AMENDMENTS UPDATE - PHASE 2')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0606A - DEAL AMENDMENTS UPDATE - PHASE 2                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS009             Date 04May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 30Aug96              */
/*                      S01408             DATE  19AUG96            */
/*                      S01378             DATE  15OCT92            */
/*                      S01117             DATE  17/05/89           */
/*                      S01194             DATE  17/05/89           */
/*                      S01189             DATE  17/05/89           */
/*                      S01179             DATE  10/09/88           */
/*                      E18                DATE  30OCT89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*   S01408 - Core Hook DLC0606A03 Added                            */
/*          - Core Hook DLC0606A04 Added                            */
/*          - Core Hook DLC0606A05 Added                            */
/*          - Core Hook DLC0606A06 Added                            */
/*   S01408 - Core Hook DLC0606A02 Added                            */
/*          - Core Hook DLC0606A01 Added                            */
/*   S01378 - Facilitates the partial sale of a parcel              */
/*            of negotiable instruments which have been             */
/*            previously input to the system as a single            */
/*            transaction. When NAB is entered the parcel           */
/*            size defines the number of parcels it may be          */
/*            split into for selling. The parcel size on the        */
/*            NAS defines the number of parcels being sold          */
/*            by the transaction. (was MOF53). Must produce         */
/*            parcelled N/A's sold extract files.                   */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*       S01189  -  COB RECOVERY PROCESSING                         */
/*       S01179  -  AS400 CONVERSION                                */
/*       E18     -  REMOVE CALLING PARAMETERS                       */
/*                                                                  */
/********************************************************************/
/*********** PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CAS009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CAS009*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CAS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CAS009*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CAS009*/
                                                                                          /*CAS009*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*/COPY WNCPYSRC,DLC0606A07                                          */
 
/* Setup system prefix variable from SDSTAT data area. */                                 /*CAS009*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CAS009*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                         /*CAS009*/
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is enabled. */                                                         /*CAS009*/
/**/                                                                                      /*CAS009*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS009*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                         /*CAS009*/
           CHGVAR     VAR(&SARD) VALUE('CAS009')                                          /*CAS009*/
                                                                                          /*CAS009*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                       /*CAS009*/
                                                                                          /*CAS009*/
           CHGVAR     VAR(&CAS009) VALUE('N')                                             /*CAS009*/
           IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                                /*CAS009*/
/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RENT) VALUE('ALL')                       /*S01117*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/
 
/**********  DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)/*S01179*/   /*S01189*/
/**/
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('10000000')
             CHGJOB     SWS(&SWS)
/*  IF MFU IND 'OLD' CLEAR NDAMS AND DAMEX AND UPDATE FILE AND IND */
/*********** RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/     /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'OLD') + */ /*S01189*/
/************           THEN(DO)                                   */ /*S01189*/
             IF         COND(&BUSY = 'N') THEN(DO)                    /*S01189*/
 
             IF   COND((&CAS009) *EQ 'Y') THEN(DO)                                        /*CAS009*/
               DLTF       FILE(XMMEIRDPD)                                                 /*CAS009*/
               MONMSG     MSGID(CPF2105)                                                  /*CAS009*/
               CPYF       FROMFILE(MMEIRDPD) TOFILE(&DPLIB/XMMEIRDPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CAS009*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*CAS009*/
             ENDDO                                                                        /*CAS009*/
/* Must extract details for Parcelled NA's                   /*S01378*/
/* No RCF parms needed because only audit trail produced     /*S01378*/
             CLRPFM     FILE(DAPCLH)                         /*S01378*/
             CLRPFM     FILE(DAPCLI)                         /*S01378*/
             CLRPFM     FILE(DAPCLJ)                         /*S01378*/
             CALL       PGM(DL4040)                          /*S01378*/
                                                             /*S01378*/
/* Check for error in DL4040                                 /*S01378*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ERROR))                     /*S01378*/
 
                CLRPFM     FILE(NDAMSDH)
                CLRPFM     FILE(NDAMSDI)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0606A01                                           /*S01408*/
/*                                                                    /*S01408*/
                CLRPFM     FILE(NDAMSDJ)
                CLRPFM     FILE(DAMEXDH)
                CLRPFM     FILE(DAMEXDI)
                CLRPFM     FILE(DAMEXDJ)
/*/COPY WNCPYSRC,DLC0606A03                                           /*S01408*/
                OVRDBF     FILE(DAMSIN) TOFILE(DAUPD)
                OVRDBF     FILE(DAOUTDH) TOFILE(DAMEXDH)
                OVRDBF     FILE(DAOUTDI) TOFILE(DAMEXDI)
                OVRDBF     FILE(DAOUTDJ) TOFILE(DAMEXDJ)
/************** OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                /*S01194*/
                SNDPGMMSG  MSG('DEAL AMENDMENTS FILE UPDATE-PHASE 1') +
                           TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                CALL       PGM(DL0265)
                DLTOVR     FILE(*ALL)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0606A02                                           /*S01408*/
/*                                                                    /*S01408*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/******************ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))        */ /*S01189*/
/*                 RCVDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************RTVDTAARA DTAARA(DLSTAT) RTNVAR(&DLSTAT)/*S01179*/ /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) + */      /*S01189*/
/******************           VALUE('NEW')                    */      /*S01189*/
/*                 SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')                   /*S01189*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/******************DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))*/         /*S01189*/
                ENDDO
             ENDDO
/*   DEAL AMENDMENTS ACTIONED TODAY REPORT                      */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                SNDPGMMSG  MSG('DEAL AMENDMENTS ACTIONED TODAY') +
                           TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/************** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/************** CALL       PGM(DL0275)                                /*S01117*/
/***************CALL       PGM(DL0275) PARM(&RSEQ &RENT)      /*E18     S01117*/
                CALL       PGM(DL0275)                        /*E18     S01117*/
                DLTOVR     FILE(*ALL)
             ENDDO
/*   CLEAR DEAMS - COPY NDAMS TO DEAMS - CLEAR NDAMS - RESET IND */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/************   RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/  /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE(' ')                      /*S01189*/
                CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/***************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'NEW') + /*S01189*/
/***************           THEN(DO) */                                /*S01189*/
                IF         COND(&BUSY = 'Y') THEN(DO)                 /*S01189*/
                   CLRPFM     FILE(DEAMSDH)
                   CLRPFM     FILE(DEAMSDI)
                   CLRPFM     FILE(DEAMSDJ)
/*/COPY WNCPYSRC,DLC0606A04                                           /*S01408*/
                   CPYF       FROMFILE(NDAMSDH) TOFILE(DEAMSDH) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
                   CPYF       FROMFILE(NDAMSDI) TOFILE(DEAMSDI) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817)
                   CPYF       FROMFILE(NDAMSDJ) TOFILE(DEAMSDJ) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/*/COPY WNCPYSRC,DLC0606A05                                           /*S01408*/
/******************ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))*/         /*S01189*/
/****************  RCVDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************RTVDTAARA DTAARA(DLSTAT) RTNVAR(&DLSTAT)/*S01179*/ /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +         /*S01189*/
/******************           VALUE('OLD') ***/                       /*S01189*/
/***************   SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&BUSY) VALUE('N')                   /*S01189*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/******************DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))*/         /*S01189*/
                ENDDO
                CLRPFM     FILE(NDAMSDH)
                CLRPFM     FILE(NDAMSDI)
                CLRPFM     FILE(NDAMSDJ)
                IF   COND((&CAS009) *EQ 'Y') THEN(DO)                                     /*CAS009*/
                  DLTF       FILE(XMMEIRDPD)                                              /*CAS009*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS009*/
                ENDDO                                                                     /*CAS009*/
/*/COPY WNCPYSRC,DLC0606A06                                           /*S01408*/
             ENDDO
                                                             /*S01378*/
ERROR:                                                       /*S01378*/
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
