/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Audit reports - Close of Business')          */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                     */
/*                                                                   */
/*       SEC0601 - AUDIT REPORTS - CLOSE OF BUSINESS                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. DUG504             Date 06Sep17              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSE039             Date 06Mar03              */
/*                      CSE041             Date 27Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CSE023             Date 12Jul00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU011             Date 16Mar98              */
/*                      CSE004             Date 26Nov96              */
/*                      082308             DATE 22AUG96              */
/*                      S01401             DATE 16JUN93              */
/*                      E38656             DATE 23APR92              */
/*                      S01117             DATE 10DEC90              */
/*                      E15601             DATE 31/01/89             */
/*                      S01176             DATE 16/08/88             */
/*                      S01169             DATE 13/07/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG504 - Cost of Funds                                      */
/*                Added hook DUG504_011, DUG504_012 and DUG504_013   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE039 - Automatic Settlements of Trades                    */
/*       CSE041 - DVP/RVP Processing                                 */
/*       CSE023 - Treaty Withholding Tax                             */
/*       CEU011 - Position/Risk Report                               */
/*       CSE004 - FRN Rate Change Warning Report                     */
/*       082308 - Change TABSE to WAITFILE(180) as the file may be   */
/*                temporarily locked by another component.           */
/*       S01401 - SWIFT Messages MT5xxs : call new report pgms :     */
/*                   SE1865 - Trade Trans Extended Settlements       */
/*                   SE1866 - Depot Movements Extended Settlements   */
/*                   SE1867 - Pos Settlements Extended Settlements   */
/*                   SE1861 - SWIFT Certificate Units List           */
/*       E38656 - Add new program SE0344 - Market Prices Report      */
/*       S01117 - MULTIBRANCHING                                     */
/*       E15601 - CALL SE0390 WITH A PARAMETER                       */
/*       S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                 * *S01176*/
/*       S01169 - SECURITIES TRADING 3.1 (BAER INCORPORATION)        * *S01169*/
/*                                                                   */
/*********************************************************************/
/**/
/************PGM        PARM(&PRM01)                                 * *S01117*/
             PGM        PARM(&PRM01 &RSEQ &RLEV &RENT)                /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
/*           DCLDTAARA  DTAARA(LDA)                                  */
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/**/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&FKEY) TYPE(*CHAR) LEN(4)                 /*S01117*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE004*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE004*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(6)               /*CSE004*/
             DCL        VAR(&CSE004) TYPE(*CHAR) LEN(4)               /*CSE004*/
             DCL        VAR(&CSE023) TYPE(*CHAR) LEN(1)               /*CSE023*/
             DCL        VAR(&CSE041) TYPE(*CHAR) LEN(1)               /*CSE041*/
             DCL        VAR(&CSE039) TYPE(*CHAR) LEN(1)               /*CSE039*/
             DCL        VAR(&TRADE) TYPE(*CHAR) LEN(6)                /*CSE039*/
             DCL        VAR(&DEPMV) TYPE(*CHAR) LEN(6)                /*CSE039*/
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(1)                  /*CSE039*/
/*/COPY WNCPYSRC,DUG504_011                                          */                   /*DUG504*/
             CHGVAR     VAR(&ALL) VALUE('X') /*CSE039*/
/**/                                                                  /*CSE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE004*/
             CHGVAR     VAR(&SAR) VALUE('CSE004')                     /*CSE004*/
             CHGVAR     VAR(&CSE004) VALUE('N')                       /*CSE004*/
/**/                                                                  /*CSE004*/
/**  Check if FRN Rate Change Warning Report is installed             /*CSE004*/
/**/                                                                  /*CSE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE004*/
                CHGVAR     VAR(&CSE004) VALUE('Y')                    /*CSE004*/
             ENDDO                                                    /*CSE004*/
/**/                                                                  /*CSE023*/
/* Check if CSE023 is installed */                                    /*CSE023*/
/**/                                                                  /*CSE023*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE004*/
             CHGVAR     VAR(&SAR) VALUE('CSE023')                     /*CSE004*/
             CHGVAR     VAR(&CSE023) VALUE('N')                       /*CSE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE023*/
/**/                                                                  /*CSE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE023*/
                CHGVAR     VAR(&CSE023) VALUE('Y')                    /*CSE023*/
             ENDDO                                                    /*CSE004*/
/**/                                                                  /*CSE041*/
/* Check if CSE041 is installed */                                    /*CSE041*/
/**/                                                                  /*CSE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE041*/
             CHGVAR     VAR(&SAR) VALUE('CSE041')                     /*CSE041*/
             CHGVAR     VAR(&CSE041) VALUE('N')                       /*CSE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE041*/
/**/                                                                  /*CSE041*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE041*/
                CHGVAR     VAR(&CSE041) VALUE('Y')                    /*CSE041*/
             ENDDO                                                    /*CSE041*/
/**/                                                                  /*CSE041*/
/* Check if CSE039 is installed */                                    /*CSE041*/
/**/                                                                  /*CSE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE041*/
             CHGVAR     VAR(&SAR) VALUE('CSE039')                     /*CSE041*/
             CHGVAR     VAR(&CSE039) VALUE('N')                       /*CSE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE041*/
/**/                                                                  /*CSE041*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE041*/
                CHGVAR     VAR(&CSE039) VALUE('Y')                    /*CSE041*/
             ENDDO                                                    /*CSE041*/
/*/COPY WNCPYSRC,DUG504_012                                          */                   /*DUG504*/
/**/                                                                  /*S01117*/
/* CREATE KEY TO POSITION FILES                                       /*S01117*/
/**/                                                                  /*S01117*/
             CHGVAR  VAR(&FKEY) VALUE(&RLEV *CAT &RENT)               /*S01117*/
/**/
             OVRDBF     FILE(TABSE) WAITFILE(180)                     /*082308*/
/**/
/* SET UP PGM MESSAGE */
/**/
             IF         COND(&PRM01 *EQ 'SE0305  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - INVESTMENT TYPES +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0310  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - STD SETTLEMENT +
                          INSTRUCTIONS AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0315  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - SECURITIES AUDIT +
                          LIST'))
             IF         COND(&PRM01 *EQ 'SE0320  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - SECURITY DIARY +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0325  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - TRANSACTIONS +
                          AUDIT LIST'))
/*/COPY WNCPYSRC,SEC0601001                                          */
             IF         COND(&PRM01 *EQ 'SE1865  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - TRANSACTIONS +
                          EXTENDED SETTLEMENTS AUDIT LIST'))          /*S01401*/
             IF         COND(&PRM01 *EQ 'SE0330  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - TRADE +
                          SETTLEMENTS AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0335  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - POSITION +
                          SETTLEMENTS AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE1867  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - POS SETTLEMENTS +
                          EXTENDED SETTLEMENTS AUDIT LIST'))          /*S01401*/
             IF         COND(&PRM01 *EQ 'SE0340  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - DEPOT MOVEMENTS +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE1866  ') THEN(CHGVAR +
                        VAR(&MSG) VALUE('SEC0601 - DEPOT MOVEMENTS +
                          EXTENDED SETTLEMENTS AUDIT LIST'))          /*S01401*/
             IF         COND(&PRM01 *EQ 'SE0344  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - MARKET PRICES +
                          AUDIT LIST'))                               /*E38656*/
/************IF         COND(&PRM01 *EQ 'SE0345  ') THEN(CHGVAR +    * *E38656*/
/************             VAR(&MSG) VALUE('SEC0601 - PRICES AUDIT +  * *E38656*/
/************             LIST'))                                    * *E38656*/
             IF         COND(&PRM01 *EQ 'SE0345  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - AVERAGE PRICES +
                          AUDIT LIST'))                               /*E38656*/
             IF         COND(&PRM01 *EQ 'SE0351  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - COUNTRY LIMITS +
                          AUDIT LIST'))
 /***********IF         COND(&PRM01 *EQ 'SE0352  ') THEN(CHGVAR +     /*CEU011*/
 /***********             VAR(&MSG) VALUE('SEC0601 - CURRENCY LIMITS +/*CEU011*/
 /***********             AUDIT LIST'))                               /*CEU011*/
 /*  Include the Ccy Sort Sequence and the 'In' Ccy ind. the Currency /*CEU011*/
 /*  Limits file by using the OPNQRY of SLIMF and SDCURRPD            /*CEU011*/
             IF         COND(&PRM01 *EQ 'SE0352  ') THEN(DO)          /*CEU011*/
                          CHGVAR     VAR(&MSG) VALUE('SEC0601 - +
                          CURRENCY LIMITS AUDIT LIST')                /*CEU011*/
                          OVRDBF     FILE(SESLIMPD) SHARE(*NO)        /*CEU011*/
                          MONMSG     MSGID(CPF0000)                   /*CEU011*/
                          OPNQRYF    FILE((SLIMF) (SDCURRPD))       +
                                     FORMAT(SESLIMPD)               +
                                     KEYFLD((*MAPFLD/ECSS *ASCEND)  +
                                     (SLIMF/CNCL)) JFLD((SLIMF/CNCL +
                                     SDCURRPD/A6CYCD))              +
                                     MAPFLD((ECSS A6SSNB)           +
                                     (INCY A6INCY))                   /*CEU011*/
                          CPYFRMQRYF FROMOPNID(SLIMF)               +
                                     TOFILE(SESLIMPD)               +
                                     MBROPT(*REPLACE)                 /*CEU011*/
                          MONMSG     MSGID(CPF2909)                   /*CEU011*/
                          CLOF       OPNID(SLIMF)                     /*CEU011*/
                          DLTOVR     FILE(SESLIMPD)                   /*CEU011*/
                          MONMSG     MSGID(CPF0000)                   /*CEU011*/
                        ENDDO                                         /*CEU011*/
             IF         COND(&PRM01 *EQ 'SE0353  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - INVESTMENT TYPES +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0354  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - CUSTOMER LIMITS +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0355  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - SECURITY LIMITS +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0360  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - LIMIT TYPES +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0365  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - FUNDING AUDIT +
                          LIST'))
             IF         COND(&PRM01 *EQ 'SE0370  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - ACCOUNT KEYS +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0375  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - TRADE NUMBER +
                          RANGES AUDIT LIST'))
/*           IF         COND(&PRM01 *EQ 'SE0380  ') THEN(CHGVAR +  */ /*S01176*/
             IF         COND(&PRM01 *EQ 'SE0381  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - CHARGEABLE RATES +
                          AUDIT LIST'))                               /*S01176*/
             IF         COND(&PRM01 *EQ 'SE0390  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - MARKET CENTRES +
                          AUDIT LIST'))
             IF         COND(&PRM01 *EQ 'SE0395  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - POSITION  +
                          PROFIT CENTRE AUDIT LIST'))                 /*S01117*/
             IF         COND(&PRM01 *EQ 'SE1861  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - SWIFT CERTIFICATE +
                          UNITS AUDIT LIST'))                         /*S01401*/
             IF         COND(&PRM01 *EQ 'SE3004  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - BULK +
                          TRANSACTIONS AUDIT LIST'))                  /*S01169*/
             IF         COND(&PRM01 *EQ 'SE3004  ') THEN(CHGVAR +
                        VAR(&MSG) VALUE('SEC0601 - BULK +
                          TRANSACTIONS AUDIT LIST'))                  /*S01169*/
             IF         COND(&PRM01 *EQ 'SE3150  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - CUSTOMER/BROKER +
                          DEFAULT CHARGES AUDIT LIST'))              /*S01169*/
             IF         COND(&PRM01 *EQ 'SE5310  ') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - COMMERCIAL PAPER +
                          PRICE AUDIT LIST'))                         /*S01176*/
             IF         COND(&PRM01 *EQ 'SE7600  ' *AND +
                             &CSE023 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - CLIENTS SUBJECT +
                          BACKUP WITHOLDING TAX REPORT'))             /*CSE023*/
             IF         COND(&PRM01 *EQ 'SE7601  ' *AND +
                             &CSE023 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - CLIENTS W/O +
                          DOCUMENTATION FOR DIVIDEND REPORT'))        /*CSE023*/
             IF         COND(&PRM01 *EQ 'SE4710  ' *AND +
                             &CSE041 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - CONTRACTUAL +
                          SETTLEMENT MATRIX AUDIT REPORT'))        /*CSE041*/
             IF         COND(&PRM01 *EQ 'SE4300  ' *AND +
                             &CSE039 *EQ 'Y') THEN(CHGVAR +
                          VAR(&MSG) VALUE('SEC0601 - MOVEMENTS +
                          STATUS AUDIT LIST'))        /*CSE039*/
/*/COPY WNCPYSRC,SEC0601004                                          */
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
/* CALL THE PROGRAM */
/**/
/*           IF         COND(&PRM01 *EQ 'SE0375  ' *OR &PRM01 *EQ +*/ /*S01169*/
/*                        'SE0380  ' *OR &PRM01 *EQ 'SE0390  ') +  */ /*S01169*/
/*                        THEN(CALL PGM(&PRM01))                   */ /*S01169*/
/*           IF         COND(&PRM01 *EQ 'SE0375  ' *OR &PRM01 *EQ +   /*E15601*/
/*                        'SE0390  ') +                               /*E15601*/
                                                           /*E15601*/
/************IF         COND(&PRM01 *EQ 'SE0375  ') +                * *S01117*/
/************             THEN(CALL PGM(&PRM01))                     * *S01117*/
                                                           /*E15601*/
/*/COPY WNCPYSRC,DUG504_013                                          */                   /*DUG504*/
/*                                                                   /*S01169*/
/*********** IF (&PRM01 *EQ 'SE0350  ' *AND &CSE004 *EQ +
/***********     'Y') THEN(CALL PGM(&PRM01) PARM(&RSEQ))    /*CSE004* *CSE023*/
             IF (&PRM01 *EQ 'SE0350  ' *AND &CSE004 *EQ 'Y' *OR +
                 &PRM01 *EQ 'SE7600  ' *AND &CSE023 *EQ 'Y' *OR +
                 &PRM01 *EQ 'SE7601  ' *AND &CSE023 *EQ 'Y') +
                 THEN(CALL PGM(&PRM01) PARM(&RSEQ))                   /*CSE023*/
             ELSE       CMD(DO)                                       /*CSE004*/
/************ELSE       CMD(CALL PGM(&PRM01) PARM('A'))              * *S01117*/
/**/                                                                  /*S01117*/
    /*       IF         COND(&PRM01 *EQ 'SE0351' *OR +
                             &PRM01 *EQ 'SE0352' *OR +
                             &PRM01 *EQ 'SE0353' *OR +
                             &PRM01 *EQ 'SE0354' *OR +
                             &PRM01 *EQ 'SE0355') +           */  /*CSE041*/
             IF         COND(&PRM01 *EQ 'SE0351' *OR +
                             &PRM01 *EQ 'SE0352' *OR +
                             &PRM01 *EQ 'SE0353' *OR +
                             &PRM01 *EQ 'SE0354' *OR +
                             &PRM01 *EQ 'SE0355' *OR +
                             &PRM01 *EQ 'SE4710' *AND &CSE041 *EQ 'Y') +
                          THEN(CALL PGM(&PRM01) +
                                    PARM('A' &RSEQ &RLEV &RENT))      /*CSE041*/
/**/                                                                  /*S01117*/
             ELSE  CMD(IF COND(&PRM01 *EQ 'SE0375  ') THEN(CALL +
                          PGM(&PRM01) PARM(&RSEQ)))                   /*S01117*/
/************                                                          *S01401*/
/************ELSE       CMD(IF COND(&PRM01 *EQ 'SE0325' *OR &PRM01 +   *S01401*/
/************      *EQ 'SE0310' *OR &PRM01 *EQ 'SE0330' *OR &PRM01 +   *S01401*/
/************             *EQ 'SE0335' *OR &PRM01 *EQ 'SE0340' *OR +   *S01401*/
/************             &PRM01 *EQ 'SE0345' *OR &PRM01 *EQ +         *S01401*/
/************             'SE0395' *OR &PRM01 *EQ +                    *S01401*/
/************             'SE3004') THEN(CALL PGM(&PRM01) +            *S01401*/
/************             PARM('A' &RSEQ &RENT)))              /*S01117*S01401*/
/************ELSE       CMD(IF COND(&PRM01 *EQ 'SE0344') THEN(CALL +   *S01401*/
/************             PGM(&PRM01) PARM('A' &RSEQ &RENT)))  /*E38656*S01401*/
/*/COPY WNCPYSRC,SEC0601002                                          */
                                                                      /*S01401*/
             ELSE (IF (&PRM01 *EQ 'SE0325' *OR +
                       &PRM01 *EQ 'SE1865' *OR +
                       &PRM01 *EQ 'SE0310' *OR +
                       &PRM01 *EQ 'SE0330' *OR +
                       &PRM01 *EQ 'SE0335' *OR +
                       &PRM01 *EQ 'SE1867' *OR +
                       &PRM01 *EQ 'SE0340' *OR +
                       &PRM01 *EQ 'SE1866' *OR +
                       &PRM01 *EQ 'SE0344' *OR +
                       &PRM01 *EQ 'SE0345' *OR +
                       &PRM01 *EQ 'SE0395' *OR +
                       &PRM01 *EQ 'SE3004') +
                   THEN(CALL (&PRM01) PARM('A' &RSEQ &RENT)))     /*S01401*/
/*/COPY WNCPYSRC,SEC0601003                                          */
             ELSE       CMD(IF COND(&PRM01 *EQ 'SE4300' *AND &CSE039 +
                          *EQ 'Y') THEN(CALL PGM(&PRM01) PARM('A' +
                          &RSEQ &RLEV &RENT &TRADE &DEPMV &ALL)))     /*CSE039*/
             ELSE       CMD(CALL PGM(&PRM01) PARM('A' &RSEQ))         /*S01117*/
             ENDDO                                                    /*CSE004*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RCVDTAARA  DTAARA(LDA)                               */
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))*/ /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0601 - JOB TERMINATED, +
                          DATABASE IN ERROR')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
/**/
/**/
/* FOR FILE IMBALANCE ERROR */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE('SEC0601 - FILE CONTROLS OUT +
                          OF BALANCE')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             DLTOVR     FILE(*ALL)                                    /*082308*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082308*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM                                                   /*S01117*/
