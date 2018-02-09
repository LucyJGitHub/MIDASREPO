/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outstanding settlements report')                */
/********************************************************************/
/*                                                                  */
/*       Midas     SECURITIES TRADING MODULE                         */
/*                                                                   */
/*       SEC6261    OUTSTANDING FEE SETTLEMENTS REPORT              */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01464             DATE 04APR94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01464  -  Safe Custody Fees                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWACOF &WWCUST &WWSETA)                 /*S01464*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01464*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                      /*S01464*/
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWSETA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01464*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01464*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01464*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01464*/
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*S01464*/
 
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
/**/                                                                  /*S01464*/
             CHGVAR     VAR(&WWACOF) VALUE(%SUBSTRING(&RPARM 1 4))    /*S01464*/
             CHGVAR     VAR(&WWCUST) VALUE(%SUBSTRING(&RPARM 5 6))    /*S01464*/
             CHGVAR     VAR(&WWSETA) VALUE(%SUBSTRING(&RPARM 11 1))   /*S01464*/
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)           /*S01464*/
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
 
/*  Override open query file                                                  */
 
/************OVRDBF     FILE(SCOCFSQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             IF         COND(&WWACOF *NE '*ALL') THEN(DO)             /*S01464*/
             OVRDBF     FILE(SEOCFSQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             ENDDO                                                    /*S01464*/
             ELSE       CMD(DO)                                       /*S01464*/
             OVRDBF     FILE(SEOCFSQ2) TOFILE(SDCUSTPD) SHARE(*YES)   /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing all details                                            */
 
/************IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *EQ +    /*S01464*/
/************             'X') THEN(DO)                               /*S01464*/
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *EQ +
                          'X' *AND &RENT *EQ 'ALL') THEN(DO)          /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +      /*S01464*/
/************             FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT('SERECI +  /*S01464*/
/************             *EQ "D"') KEYFLD((AZPRTL) (AZACOC) (SECNUM)+/*S01464*/
/************             (SEPTFR)) JFLD((SDACOFPD/AZACOC +           /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCOCFSPD/SECNUM' *CHAR 6))                 /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SEOCFSPD)) FORMAT(SEOCFSQ2 +
                          SEOCFSQ1) QRYSLT('SERECI *EQ "D"') +
                          KEYFLD((SEBRCA) (BBACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB +
                          'SECUSB' *CHAR 3) (BBCSCY 'SECSCY' *CHAR +
                          3))                                         /*S01464*/
             ENDDO
 
/*  Run report showing details for selected printer location and              */
/*  account officer                                                           */
 
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +    /*S01464*/
/************             '*ALL' *AND &WWSETA *EQ 'X') THEN(DO)       /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &WWSETA *EQ 'X' *AND &RENT +
                          *EQ 'ALL') THEN(DO)                         /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +      /*S01464*/
/************             FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT('AZACOC +  /*S01464*/
/************             *EQ "' *CAT &WWACOF *CAT '" *AND SERECI +   /*S01464*/
/************             *EQ "D"') KEYFLD((AZPRTL) (AZACOC) +        /*S01464*/
/************             (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +  /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCOCFSPD/SECNUM' *CHAR 6))                 /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO
 
/*  Run report showing details for selected printer location,                 */
/*  account officer and customer number                                       */
 
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +    /*S01464*/
/************             '*ALL' *AND &WWSETA *EQ 'X') THEN(DO)       /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &WWSETA *EQ 'X' *AND &RENT +
                          *EQ  'ALL') THEN(DO)                        /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +      /*S01464*/
/************             FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT(' BBCUST + /*S01464*/
/************             *EQ "' *CAT &WWCUST *CAT '" *AND SERECI +   /*S01464*/
/************             *EQ "D"') KEYFLD((AZPRTL) (AZACOC) +        /*S01464*/
/************             (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +  /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCOCFSPD/SECNUM' *CHAR 6))                 /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT(' BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO
 
/*  Run report showing all details for a set status                           */
 
/************IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *NE +    /*S01464*/
/************             'X') THEN(DO)                               /*S01464*/
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *NE +
                          'X' *AND &RENT *EQ 'ALL') THEN(DO)          /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +      /*S01464*/
/************             FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT(' SEAUIN + /*S01464*/
/************             *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +   /*S01464*/
/************             *EQ "D"') KEYFLD((AZPRTL) (AZACOC) +        /*S01464*/
/************             (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +  /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCOCFSPD/SECNUM' *CHAR 6))                 /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SEOCFSPD)) FORMAT(SEOCFSQ2 +
                          SEOCFSQ1) QRYSLT(' SEAUIN *EQ "' *CAT +
                          &WWSETA *CAT '" *AND SERECI *EQ "D"') +
                          KEYFLD((SEBRCA) (BBACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB +
                          'SECUSB' *CHAR 3) (BBCSCY 'SECSCY' *CHAR +
                          3))                                         /*S01464*/
             ENDDO
 
/*  Run report showing details for selected printer location and              */
/*  account officer                                                           */
 
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +    /*S01464*/
/************             '*ALL' *AND &WWSETA *NE 'X') THEN(DO)       /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &WWSETA *NE 'X' *AND &RENT +
                          *EQ 'ALL') THEN(DO)                         /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +      /*S01464*/
/************             FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT('AZACOC +  /*S01464*/
/************             *EQ "' *CAT &WWACOF *CAT '" *AND SEAUIN +   /*S01464*/
/************             *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +   /*S01464*/
/************             *EQ "D"') KEYFLD((AZPRTL) (AZACOC) +        /*S01464*/
/************             (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +  /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCOCFSPD/SECNUM' *CHAR 6))                 /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND SEAUIN +
                          *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO
 
/*  Run report showing details for selected printer location,                 */
/*  account officer and customer number                                       */
 
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +    /*S01464*/
/************             '*ALL' *AND &WWSETA *NE 'X') THEN(DO)       /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &WWSETA *NE 'X' *AND &RENT +
                          *EQ 'ALL') THEN(DO)                         /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +      /*S01464*/
/************             FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT('BBCUST +  /*S01464*/
/************             *EQ "' *CAT &WWCUST *CAT '" *AND SEAUIN +   /*S01464*/
/************             *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +   /*S01464*/
/************             *EQ "D"') KEYFLD((AZPRTL) (AZACOC) +        /*S01464*/
/************             (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +  /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCOCFSPD/SECNUM' *CHAR 6))                 /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND SEAUIN +
                          *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO
/**/                                                                  /*S01464*/
/*  Run report showing all details of a selected branch.              /*S01464*/
 
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *EQ +
                          'X' *AND &RENT *NE 'ALL' *AND &MBIN +
                          *EQ 'Y') THEN(DO)                           /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SEOCFSPD)) FORMAT(SEOCFSQ2 +
                          SEOCFSQ1) QRYSLT('SERECI *EQ "D" *AND +
                          SEBRCA *EQ "' *CAT &RENT *CAT '"') +
                          KEYFLD((SEBRCA) (BBACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB +
                          'SECUSB' *CHAR 3) (BBCSCY 'SECSCY' *CHAR +
                          3))                                         /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing details for selected printer location and      /*S01464*/
/*  account officer of a selected branch.                             /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &WWSETA *EQ 'X' *AND &RENT +
                          *NE 'ALL' *AND &MBIN *EQ 'Y') THEN(DO)      /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND SERECI +
                          *EQ "D" *AND SEBRCA *EQ "' *CAT &RENT +
                          *CAT '"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing details for selected printer location,         /*S01464*/
/*  account officer, customer number and branch.                      /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &WWSETA *EQ 'X' *AND &RENT +
                          *NE  'ALL' *AND &MBIN *EQ 'Y') THEN(DO)     /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT(' BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND SERECI +
                          *EQ "D" *AND SEBRCA *EQ "' *CAT &RENT +
                          *CAT '"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO
 
/*  Run report showing all details for a set status of selected       /*S01464*/
/*  branch.                                                           /*S01464*/
 
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *NE +
                          'X' *AND &RENT *NE 'ALL' *AND &MBIN +
                          *EQ 'Y') THEN(DO)                           /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SEOCFSPD)) FORMAT(SEOCFSQ2 +
                          SEOCFSQ1) QRYSLT(' SEAUIN *EQ "' *CAT +
                          &WWSETA *CAT '" *AND SERECI *EQ "D" *AND +
                          SEBRCA *EQ "' *CAT &RENT *CAT '"') +
                          KEYFLD((SEBRCA) (BBACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB +
                          'SECUSB' *CHAR 3) (BBCSCY 'SECSCY' *CHAR +
                          3))                                         /*S01464*/
             ENDDO
 
/*  Run report showing details for selected printer location, account /*S01464*/
/*  officer and branch.                                               /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &WWSETA *NE 'X' *AND &RENT +
                          *NE 'ALL' *AND &MBIN *EQ 'Y') THEN(DO)      /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND SEAUIN +
                          *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +
                          *EQ "D" *AND SEBRCA *EQ "' *CAT &RENT +
                          *CAT '"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing details for selected printer location,         /*S01464*/
/*  account officer, customer number and branch.                      /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &WWSETA *NE 'X' *AND &RENT +
                          *NE 'ALL' *AND &MBIN *EQ 'Y') THEN(DO)      /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND SEAUIN +
                          *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +
                          *EQ "D" *AND SEBRCA *EQ "' *CAT &RENT +
                          *CAT '"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing all details for a set status in a  single      /*S01464*/
/*  branch environment.                                               /*S01464*/
 
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *EQ +
                          'X' *AND &MBIN *EQ 'N') THEN(DO)            /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SEOCFSPD)) FORMAT(SEOCFSQ2 +
                          SEOCFSQ1) QRYSLT('SERECI *EQ "D"') +
                          KEYFLD((SEBRCA) (BBACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB +
                          'SECUSB' *CHAR 3) (BBCSCY 'SECSCY' *CHAR +
                          3))                                         /*S01464*/
             ENDDO
/*  Run report showing details for selected account officer in a      /*S01464*/
/*  single branch environment.                                        /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &WWSETA *EQ 'X' *AND &MBIN +
                          *EQ 'N')   THEN(DO)                         /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND SERECI +
                          *EQ "D"')   KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing details for selected account officer,          /*S01464*/
/*  and customer number in a single branch environment.               /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &WWSETA *EQ 'X' *AND &MBIN +
                          *EQ  'N') THEN(DO)                          /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT(' BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO
 
/*  Run report showing all details for a set status in a single       /*S01464*/
/*  branch environment.                                               /*S01464*/
 
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWSETA *NE +
                          'X' *AND &MBIN *EQ 'N') THEN(DO)            /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SEOCFSPD)) FORMAT(SEOCFSQ2 +
                          SEOCFSQ1) QRYSLT(' SEAUIN *EQ "' *CAT +
                          &WWSETA *CAT '" *AND SERECI *EQ "D"') +
                          KEYFLD((SEBRCA) (BBACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB +
                          'SECUSB' *CHAR 3) (BBCSCY 'SECSCY' *CHAR +
                          3))                                         /*S01464*/
             ENDDO
 
/*  Run report showing details for selected account officer in a      /*S01464*/
/*  single branch environment.                                        /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &WWSETA *NE 'X' *AND &MBIN +
                          *EQ 'N') THEN(DO)                           /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND SEAUIN +
                          *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO                                                    /*S01464*/
 
/*  Run report showing details for selected account officer           /*S01464*/
/*  and customer number in a single branch environment.               /*S01464*/
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &WWSETA *NE 'X' *AND &MBIN +
                          *EQ 'N') THEN(DO)                           /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND SEAUIN +
                          *EQ "' *CAT &WWSETA *CAT '" *AND SERECI +
                          *EQ "D"') KEYFLD((SEBRCA) (AZACOC) +
                          (SECNUM) (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (BBCUSB 'SECUSB' +
                          *CHAR 3) (BBCSCY 'SECSCY' *CHAR 3))         /*S01464*/
             ENDDO                                                    /*S01464*/
/** RUN MISSING CUSTODY FEE CODES REPORT */
/************CALL       PGM(SE6260) PARM(&WWACOF &WWCUST &WWSETA)     /*S01464*/
             CALL       PGM(SE6260) PARM(&WWACOF &WWCUST &WWSETA +
                           &RSEQ &RENT)                               /*S01464*/
             IF         COND(&WWACOF *NE '*ALL') THEN(DO)             /*S01464*/
             CLOF       OPNID(SDACOFPD)
             ENDDO                                                    /*S01464*/
             ELSE       CMD(CLOF       OPNID(SDCUSTPD))               /*S01464*/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01464*/
/****************         TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01464*/
/*                                                                    /*R00300*/
             ENDDO
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/***END:        ENDPGM                                                /*S01464*/
             ENDPGM                                                   /*S01464*/
