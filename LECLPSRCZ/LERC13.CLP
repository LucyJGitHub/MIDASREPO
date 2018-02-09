/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Fee accruals update and acc. key gen')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LERC13  - Fee accruals update & account key generation      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD025212           Date 10May14              */
/*                      263074             Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/*                      AR817264           Date 09Feb12              */
/*                      CLE139             Date 06Dec10              */
/*                      262573             Date 29Dec08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260345             Date 20May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE106             Date 01Aug04              */
/*                      CAS009             Date 04May04              */
/*                      CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE007             Date 22May97              */
/*                     S01408              Date 06Sep96              */
/*                     S01408              Date 05May95              */
/*                      MOF60              DATE 23MAR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD025212 - Close of Business: LERC13 - file control         */
/*                  out of balance                                   */
/*       263074 - Wrong Postings when interest and principal are     */
/*                paid on the same day (Recompile)                   */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       AR817264 - Capitalised Fees are not reflected in FACHISA    */
/*                  update                                           */
/*       CLE139 - Lending Fee Capitalisation                         */
/*       262573 - Avoid duplication of fee totals on CLOANCL when    */
/*                LERC13 is run twice on ANWD                        */
/*       260345 - Inability to insert fees, seq# already exists.     */
/*                Back up LEFEEDQD and restore on re-start.          */
/*       CLE106 - Syndications Manager                               */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CLE034 - Lending Enhancements.                              */
/*       CLE007 - Customer Lending Enhancements - Others             */
/*       S01408 - Addition of core hook LERC13MP1                    */
/*                Addition of core hook LERC13MP2                    */
/*       S01408 - Addition of core hook LERC13MPS                    */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
/**********PGM  PARM(&CNAM &CSEQ)           */                                            /*CLE139*/
PGM  PARM(&CNAM &CSEQ &CCAP)                                                              /*CLE139*/
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
     DCL VAR(&CCAP) TYPE(*CHAR) LEN(1)                                                    /*CLE139*/
 
     DCL VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
     DCL VAR(&SID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CLE007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CLE007*/
             DCL        VAR(&CLE007) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CLE007*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CAS009*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CAS009*/
             DCL        VAR(&CLE134) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,LEH01209                                            */
/**/                                                                                      /*CLE034*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                  /*CLE034*/
 
/*/COPY WNCPYSRC,LERC13001                                           */
 
     RTVDTAARA DTAARA(SDSTAT (6 2)) RTNVAR(&SID)
     CHGVAR VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SID)
     CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SID)                                   /*CAS009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LERC13MPS                                           */
                                                                      /*S01408*/
/*                                                  */                /*CLE007*/
/* Check if Enhancement Number CLE007 is present.   */                /*CLE007*/
/*                                                  */                /*CLE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE007*/
             CHGVAR     VAR(&SAR) VALUE('CLE007')                     /*CLE007*/
                                                                      /*CLE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CLE007*/
                                                                      /*CLE007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE007) VALUE('Y'))                    /*CLE007*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                             /*CLE007*/
/*                                                  */                                    /*CAS009*/
/* Check if Enhancement Number CAS009 is present.   */                                    /*CAS009*/
/*                                                  */                                    /*CAS009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAS009*/
             CHGVAR     VAR(&SAR) VALUE('CAS009')                                         /*CAS009*/
                                                                                          /*CAS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CAS009*/
                                                                                          /*CAS009*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS009) VALUE('Y'))                                        /*CAS009*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                                                 /*CAS009*/
/**/                                                                                      /*CLE134*/
/** Check if Enhancement Number CLE134 is present. */                                     /*CLE134*/
/**/                                                                                      /*CLE134*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE134*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE134*/
             CHGVAR     VAR(&SAR) VALUE('CLE134')                                         /*CLE134*/
/**/                                                                                      /*CLE134*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE134*/
/**/                                                                                      /*CLE134*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                           VAR(&CLE134) VALUE('Y'))                                       /*CLE134*/
 
     SNDPGMMSG  MSG('Fee Accruals Update and Account Key Generation') +
                                       TOMSGQ(MRUNQ)
 
/* CLEAR OUTPUT FILES */
 
     IF COND((&CSEQ = 3) *OR (&CSEQ = 4)) THEN(DO)                                      /*AR817264*/
     CLRPFM LKEYFED
     CLRPFM LKEYFEA
     CLRPFM LKEYFEZ
     ENDDO                                                                              /*AR817264*/
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If RERUN use security copy of fee files */
 
     IF COND(&STAT *EQ 'Y') THEN(DO)
       IF COND((&CSEQ = 1) *OR (&CSEQ = 2)) THEN(DO)
          CPYF       FROMFILE(XLKEYFED) TOFILE(LKEYFED) +
                     MBROPT(*REPLACE) CRTFILE(*YES)                                     /*MD025212*/
          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                     FILE(LKEYFED))                                                     /*MD025212*/
          CPYF       FROMFILE(XLKEYFEA) TOFILE(LKEYFEA) +
                     MBROPT(*REPLACE) CRTFILE(*YES)                                     /*MD025212*/
          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                     FILE(LKEYFEA))                                                     /*MD025212*/
          CPYF       FROMFILE(XLKEYFEZ) TOFILE(LKEYFEZ) +
                     MBROPT(*REPLACE) CRTFILE(*YES)                                     /*MD025212*/
          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                     FILE(LKEYFEZ))                                                     /*MD025212*/
          CPYF       FROMFILE(XLEFHST) TOFILE(LEFHST) +
                     MBROPT(*REPLACE) CRTFILE(*YES)                                     /*MD025212*/
          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                     FILE(LEFHST))                                                      /*MD025212*/
       ENDDO
       IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                          /*CLE134*/
         CPYF       FROMFILE(XLEPDUFPD) TOFILE(LEPDUFPD) +
                       MBROPT(*REPLACE)                                                   /*CLE134*/
         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                       FILE(LEPDUFPD))                                                    /*CLE134*/
       ENDDO                                                                              /*CLE134*/
            CPYF FROMFILE(XLEFEED) TOFILE(LEFEED) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEFEED))
            CPYF FROMFILE(XLEFEEZ) TOFILE(LEFEEZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEFEEZ))
            CPYF  FROMFILE(XLEFEEDQD) TOFILE(LEFEEDQD) +
                          MBROPT(*REPLACE)
            MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEFEEDQD))                                                 /*260345*/
            CPYF FROMFILE(XLEPFFD) TOFILE(LEPEFFD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFFD))
            CPYF FROMFILE(XLEPFFZ) TOFILE(LEPEFFZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFFZ))
            CPYF FROMFILE(XLEPFLD) TOFILE(LEPEFLD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFLD))
            CPYF FROMFILE(XLEPFLZ) TOFILE(LEPEFLZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFLZ))
            CPYF FROMFILE(XLEFEALPD) TOFILE(LEFEALPD) MBROPT(*REPLACE)                    /*CLE106*/
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEFEALPD))                                            /*CLE106*/
            IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                     /*CAS009*/
               CPYF FROMFILE(XCLOANCL) TOFILE(CLOANCL) MBROPT(*REPLACE)                   /*CAS009*/
               MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(CLOANCL))           /*CAS009*/
               CPYF FROMFILE(XLEEIRDPD) TOFILE(LEEIRDPD) MBROPT(*REPLACE)                 /*CAS009*/
               MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEEIRDPD))          /*CAS009*/
               CPYF FROMFILE(XLEEIRAPD) TOFILE(LEEIRAPD) MBROPT(*REPLACE)                 /*CAS009*/
               MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEEIRAPD))          /*CAS009*/
               CPYF FROMFILE(XLECFLSPD) TOFILE(LECFLSPD) MBROPT(*REPLACE)                 /*CAS009*/
               MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LECFLSPD))          /*CAS009*/
            ENDDO                                                                         /*CAS009*/
            CPYF FROMFILE(XLOAMSDK) TOFILE(LOAMSDK) MBROPT(*REPLACE)                      /*CLE139*/
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LOAMSDK))                                             /*CLE139*/
            CPYF FROMFILE(XLOAMSZ1) TOFILE(LOAMSZ1) MBROPT(*REPLACE)                      /*CLE139*/
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LOAMSZ1))                                             /*CLE139*/
/*/COPY WNCPYSRC,LERC13MP1                                           */
   ENDDO
   ELSE CMD(DO)
     IF COND((&CSEQ = 1) *OR (&CSEQ = 2)) THEN(DO)
        CPYF       FROMFILE(LKEYFED) TOFILE(&DPLIB/XLKEYFED) +
                   MBROPT(*REPLACE) CRTFILE(*YES)                                       /*MD025212*/
        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                   FILE(XLKEYFED))                                                      /*MD025212*/
        CPYF       FROMFILE(LKEYFEA) TOFILE(&DPLIB/XLKEYFEA) +
                   MBROPT(*REPLACE) CRTFILE(*YES)                                       /*MD025212*/
        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                   FILE(XLKEYFEA))                                                      /*MD025212*/
        CPYF       FROMFILE(LKEYFEZ) TOFILE(&DPLIB/XLKEYFEZ) +
                   MBROPT(*REPLACE) CRTFILE(*YES)                                       /*MD025212*/
        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                   FILE(XLKEYFEZ))                                                      /*MD025212*/
        CPYF       FROMFILE(LEFHST) TOFILE(&DPLIB/XLEFHST) +
                   MBROPT(*REPLACE) CRTFILE(*YES)                                       /*MD025212*/
        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                   FILE(XLEFHST))                                                       /*MD025212*/
     ENDDO
     IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                            /*CLE134*/
       CPYF       FROMFILE(LEPDUFPD) TOFILE(XLEPDUFPD) +
                     MBROPT(*REPLACE)                                                     /*CLE134*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                     FILE(XLEPDUFPD))                                                     /*CLE134*/
     ENDDO                                                                                /*CLE134*/
     CPYF       FROMFILE(LEFEED) TOFILE(XLEFEED) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEFEED))
     CPYF       FROMFILE(LEFEEZ) TOFILE(XLEFEEZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEFEEZ))
     CPYF       FROMFILE(LEFEEDQD) TOFILE(XLEFEEDQD) +
                          MBROPT(*REPLACE)
     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEFEEDQD))                                                /*260345*/
     CPYF       FROMFILE(LEPEFFD) TOFILE(XLEPFFD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFFD))
     CPYF       FROMFILE(LEPEFFZ) TOFILE(XLEPFFZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFFZ))
     CPYF       FROMFILE(LEPEFLD) TOFILE(XLEPFLD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFLD))
     CPYF       FROMFILE(LEPEFLZ) TOFILE(XLEPFLZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFLZ))
     CPYF       FROMFILE(LEFEALPD) TOFILE(XLEFEALPD) MBROPT(*REPLACE)                     /*CLE106*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEFEALPD))                   /*CLE106*/
     IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                            /*CAS009*/
        DLTF       FILE(XCLOANCL)                                                         /*CAS009*/
        MONMSG     MSGID(CPF0000)                                                         /*CAS009*/
        CPYF       FROMFILE(CLOANCL) TOFILE(&DPLIB/XCLOANCL) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CAS009*/
        MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XCLOANCL))                 /*CAS009*/
        CPYF       FROMFILE(LEEIRDPD) TOFILE(XLEEIRDPD) MBROPT(*REPLACE)                  /*CAS009*/
        MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEEIRDPD))                /*CAS009*/
        CPYF       FROMFILE(LEEIRAPD) TOFILE(XLEEIRAPD) MBROPT(*REPLACE)                  /*CAS009*/
        MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEEIRAPD))                /*CAS009*/
        CPYF       FROMFILE(LECFLSPD) TOFILE(XLECFLSPD) +
                          MBROPT(*REPLACE)                                                /*CAS009*/
        MONMSG MSGID(CPF2817) CMPDTA(CPF2869)                                             /*CAS009*/
     ENDDO                                                                                /*CAS009*/
     CPYF       FROMFILE(LOAMSDK) TOFILE(XLOAMSDK) MBROPT(*REPLACE)                       /*CLE139*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLOAMSDK))                    /*CLE139*/
     CPYF       FROMFILE(LOAMSZ1) TOFILE(XLOAMSZ1) MBROPT(*REPLACE)                       /*CLE139*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLOAMSZ1))                    /*CLE139*/
/*/COPY WNCPYSRC,LERC13MP2                                           */
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     ENDDO
 
/* Clear Lending Pay/Receive Extract file if the Participant Fees */  /*CLE007*/
/*   are to be generated.                                         */  /*CLE007*/
             IF         COND(&CLE007 *EQ 'Y') THEN(DO)                /*CLE007*/
             CLRPFM     FILE(LEPXTAA)                                 /*CLE007*/
             CLRPFM     FILE(LEPXTAB)                                 /*CLE007*/
             CLRPFM     FILE(LEPXTAC)                                 /*CLE007*/
             ENDDO                                                    /*CLE007*/
                                                                      /*CLE007*/
                                                                                          /*262573*/
/* If the component is part of the ANWD phase switch on U2                                /*262573*/
                                                                                          /*262573*/
/*           IF         COND(&CSEQ = 2) THEN(CHGJOB SWS(X1XXXXXX)) */        /*262573*/ /*AR817264*/
             IF         COND((&CSEQ = 2) *OR (&CSEQ = 4)) +
                          THEN(CHGJOB SWS(X1XXXXXX))                                    /*AR817264*/
                                                                                          /*262573*/
  /* Call FEE ACCRUAL UPDATE & ACCOUNT KEY GERERATION Program */
 
             IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                    /*CLE134*/
               CLRPFM     FILE(LEPK3DPD)                                                  /*CLE134*/
               CLRPFM     FILE(LEPK3ZZ)                                                   /*CLE134*/
               CLRPFM     FILE(LEPK3HH)                                                   /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/**/                                                                                      /*CLE134*/
/**********  CALL       LER130                                */                          /*CLE139*/
             CALL       PGM(LER130) PARM(&CCAP)                                           /*CLE139*/
 
     IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/*/COPY WNCPYSRC,LERC13002                                           */
 
/* If the component has completed successfully reset the status field */
 
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
 
     ELSE DO
 
/***********SNDPGMMSG  MSG('Job terminated, database in error. +   */ /*CLE007*/
 DBERR:      SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CLE007*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CLE034*/
 
     ENDDO
 
 END:
             ENDCMTCTL                                                                    /*CLE034*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CLE034*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
          ENDPGM
