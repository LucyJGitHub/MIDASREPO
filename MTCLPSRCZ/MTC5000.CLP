/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Telex initial program')                      */
/*********************************************************************/
/*                                                                   */
/*     Midas - Midas TELEX.                                          */
/*                                                                   */
/*     MTC5000 - MIDAS/ORION TELEX INITIAL PROGRAM.                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      123888             Date  3Oct97              */
/*                   110242            DATE 07NOV96                  */
/*                   081507  *CREATE   DATE 20JAN95                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*     123888 - Change 110242 causes the submitted job to fail       */
/*              because there are no Midas libraries in the library  */
/*              list. This change reverses SC110242 out of this pgm. */
/*     110242 - Change defaults for SBMJOB cmd to take *JOBD         */
/*     081507 - ORION UPGRADE.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPTION)
 
             DCLF       FILE(*LIBL/N#CF) RCDFMT(N#CF01)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQS) TYPE(*CHAR) LEN(39)
             DCL        VAR(&DTEFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LOCCOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(100)
             DCL        VAR(&CTRY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LANGUAGE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Try to allocate Housekeeping Data Area - if can't then */
/* Housekeeping is active so drop out.                    */
/* */
             ALCOBJ     OBJ((*LIBL/CC9000DA *DTAARA *SHRUPD)) WAIT(0)
             MONMSG     (CPF1002 CPF1040 CPF1085) EXEC(DO)
              SNDPGMMSG  MSGID(UNC3069) MSGF(*LIBL/NCM1) TOPGMQ(*EXT) +
                           MSGTYPE(*COMP)
              GOTO       CMDLBL(END)
             ENDDO
/* */
 
/* SETUP USER-ID                                                 */
 
             RTVJOBA    USER(&USERID)
             RTVJOBA    JOB(&JOB)
 
/* CHECK IF USER SETUP AS A TELEX USER - IF NOT END AND SEND MESSAGE */
             CALL       PGM(MT5000) PARM(&USERID &EXIST)
 
/* IF USER IS NOT SETUP IN MIDAS TELEX SEND MESSAGE AND END */
             IF         COND(&EXIST *EQ 'N') THEN(DO)
              SNDBRKMSG  MSG('User is not setup in Midas Telex. To be +
                           setup as a Midas Telex user contact the +
                           Midas Telex Security Officer.') TOMSGQ(&JOB)
              GOTO       CMDLBL(EXIT)
             ENDDO
 
/* SETUP LOCCODION CODE                                           */
 
             RCVF       RCDFMT(N#CF01)
             MONMSG     MSGID(CPF4101) EXEC(DO)
              SNDPGMMSG  MSGID(UNC0261) MSGF(*LIBL/NCM1) TOPGMQ(*EXT) +
                           MSGTYPE(*INFO)
              GOTO       CMDLBL(END)
             ENDDO
 
             CHGVAR     VAR(&LOCCOD) VALUE(&CFLOCC)
             CHGVAR     VAR(%SST(*LDA 251 5)) VALUE(&LOCCOD)
 
 
/* SETUP DATE FORMAT                                                */
 
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DTEFMT)
 
 
/* SETUP LANGUAGE                                                   */
 
             RTVDTAARA  DTAARA(N#ZC (406 2)) RTNVAR(&CTRY)
             CHGVAR     VAR(&LANGUAGE) VALUE('N#DSP' *CAT &CTRY)
             OVRMSGF    MSGF(N#DSPUK) TOMSGF(#NC400/&LANGUAGE)
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(*LIBL/NCM1)
 
             CHGJOB     SWS(00000000)
/********************************************************************/
/*                                                                  */
/*                    CALL MENU OPTION SELECTED                     */
/*                                                                  */
/********************************************************************/
/********************************************************************/
/***************************** M A I N ******************************/
 
/* ITEMS AWAITING REROUTING */
             IF         COND(&OPTION *EQ 'CC3047') THEN(DO)
               CALL       PGM(MTC5030) PARM(&USERID &DTEFMT &JOB ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
/* ITEMS AWAITING DECODING */
             IF         COND(&OPTION *EQ 'CC3047/D') THEN(DO)
               CALL       PGM(MTC5030) PARM(&USERID &DTEFMT &JOB 'D')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* INQUEUE MAINTENANCE */
             IF         COND(&OPTION *EQ 'TC3010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* OUTQUEUE MAINTENANCE */
             IF         COND(&OPTION *EQ 'TC2010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* REVIEW TELEX QUEUE */
             IF         COND(&OPTION *EQ 'MTXC2010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ARCHIVE REVIEW */
             IF         COND(&OPTION *EQ 'TC5010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* MANUAL TELEX */
             IF         COND(&OPTION *EQ 'TC4010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT 'NEW' '0' +
                            ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ARCHIVE DELETE */
             IF         COND(&OPTION *EQ 'TC5090') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT 'Y' 'Y')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ARCHIVE RESTORE */
             IF         COND(&OPTION *EQ 'TC5095') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT 'Y')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* BASIC HOUSEKEEPING */
             IF         COND(&OPTION *EQ 'CC9001') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* FULL HOUSEKEEPING */
             IF         COND(&OPTION *EQ 'CC9000') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
/********************************************************************/
/************************* R E P O R T S ****************************/
 
/* TELEX RATES */
             IF         COND(&OPTION *EQ 'MTXR2055') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX LINE LOG */
             IF         COND(&OPTION *EQ 'MTXR9011') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* SENT TELEXES */
             IF         COND(&OPTION *EQ 'MTXR9021') THEN(DO)
               CALL       PGM(&OPTION) PARM('P' &DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* RECEIVED TELEXES - ALL */
             IF         COND(&OPTION *EQ 'MTXC9030A') THEN(DO)
               CALL       PGM(MTXC9030) PARM('A' &DTEFMT ' ' ' ' +
                            X'0000000F' ' ' ' ' ' ' ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* RECEIVED TELEXES - NEW */
             IF         COND(&OPTION *EQ 'MTXC9030N') THEN(DO)
               CALL       PGM(MTXC9030) PARM('N' &DTEFMT ' ' ' ' +
                            X'0000000F' ' ' ' ' ' ' ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* RECEIVED TELEXES - UNPROCESSED */
             IF         COND(&OPTION *EQ 'MTXC9030U') THEN(DO)
               CALL       PGM(MTXC9030) PARM('U' &DTEFMT ' ' ' ' +
                            X'0000000F' ' ' ' ' ' ' ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* NETWORK CALL LOG */
             IF         COND(&OPTION *EQ 'CR1420') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT &USERID &USERID +
                            &LOCCOD)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* LOCATION DETAILS */
             IF         COND(&OPTION *EQ 'CR1011') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX USERS (ALPHABETICALLY) */
             IF         COND(&OPTION *EQ 'CR1021') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX USERS (BY DEPARTMENT) */
             IF         COND(&OPTION *EQ 'CR1022') THEN(DO)
               CALL       PGM(&OPTION) PARM(' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ADDRESSES (ALPHABETICALLY) */
             IF         COND(&OPTION *EQ 'CR1031') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ADDRESSES (BY LOCATION) */
             IF         COND(&OPTION *EQ 'CR1032') THEN(DO)
               CALL       PGM(&OPTION) PARM(' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* SCHEDULES */
             IF         COND(&OPTION *EQ 'CR1041') THEN(DO)
               CALL       PGM(&OPTION)
               CALL       PGM(CR1051) PARM(&DTEFMT)
               CALL       PGM(CR1056)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PUBLIC DISTRIBUTION LISTS */
             IF         COND(&OPTION *EQ 'CR1091') THEN(DO)
               CALL       PGM(&OPTION) PARM(0)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ARCHIVE REFERENCES */
             IF         COND(&OPTION *EQ 'TR1021') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PUBLIC STANDARD TEXTS */
             IF         COND(&OPTION *EQ 'TR6012') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* DEPARTMENTS */
             IF         COND(&OPTION *EQ 'CR1101') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX LINE CONFIGURATION */
             IF         COND(&OPTION *EQ 'CR1111') THEN(DO)
               CALL       PGM(&OPTION)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/********************************************************************/
/*********************** E N Q U I R I E S **************************/
 
/* TELEX MESSAGES ENQUIRY */
             IF         COND(&OPTION *EQ 'MTXR2040') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT 'N' 'D' ' ' ' ' ' +
                            ' ' ' 'N' 'Y')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TRAFFIC LOG */
             IF         COND(&OPTION *EQ 'CR1400') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT 'N' 'N' ' ' ' ' ' +
                            ' ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* NETWORK CALL LOG */
             IF         COND(&OPTION *EQ 'CR1410') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* REVIEW INQUEUES */
             IF         COND(&OPTION *EQ 'CC3048') THEN(DO)
             CALL &OPTION PARM(&DTEFMT)
             GOTO EXIT
             ENDDO
 
 
/* REVIEW OUTQUEUES */
             IF         COND(&OPTION *EQ 'CR3049') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/********************************************************************/
/************* U S E R   S T A N D I N G   D A T A ******************/
 
/* PERSONAL DISTRIBUTION LISTS MAINTENANCE */
             IF         COND(&OPTION *EQ 'CR1090P') THEN(DO)
               CALL       PGM(CR1090) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PERSONAL DISTRIBUTION LISTS REPORT */
             IF         COND(&OPTION *EQ 'CR1091P') THEN(DO)
               CALL       PGM(CR1091) PARM(&USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PRINT AN ADDRESS DIRECTORY */
             IF         COND(&OPTION *EQ 'CR1032P') THEN(DO)
               CALL       PGM(CR1032) PARM(&LOCCOD)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ARCHIVE REFERENCE LIST */
             IF         COND(&OPTION *EQ 'TR1021P') THEN(DO)
               CALL       PGM(TR1021)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PERSONAL STANDARD TEXTS MAINTENANCE */
             IF         COND(&OPTION *EQ 'TC6010P') THEN(DO)
               CALL       PGM(TC6010) PARM(&USERID &DTEFMT ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PERSONAL STANDARD TEXTS PRINT */
             IF         COND(&OPTION *EQ 'TR6013P') THEN(DO)
               CALL       PGM(TR6013) PARM(&USERID &DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PURGE ITEMS ON OUTQUEUE */
             IF         COND(&OPTION *EQ 'TR9001P') THEN(DO)
               CALL       PGM(MTC5010) PARM(&USERID &USERID &LOCCOD +
                            'OUT')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PURGE ITEMS ON INQUEUE */
             IF         COND(&OPTION *EQ 'TR9002P') THEN(DO)
               CALL       PGM(MTC5010) PARM(&USERID &USERID &LOCCOD +
                            'IN ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* CHANGE PERSONAL TELEX USER PROFILE */
             IF         COND(&OPTION *EQ 'CR1025P') THEN(DO)
               CALL       PGM(CR1025) PARM(&USERID &USERID ' ' ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PERSONAL ARCHIVE DELETE */
             IF         COND(&OPTION *EQ 'TC5090P') THEN(DO)
               CALL       PGM(TC5090) PARM(&USERID &DTEFMT 'Y' 'N')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/********************************************************************/
/****************** C O M M U N I C A T I O N S *********************/
 
/* START WORK MONITOR */
             IF         COND(&OPTION *EQ 'START') THEN(DO)
              STRSBS     SBSD(ORIONET)
              MONMSG     MSGID(CPF1010)
              MONMSG     MSGID(CPF1000) EXEC(DO)
               SNDPGMMSG  MSG('MIDAS TELEX Subsystem (ORIONET) failed +
                            to start') TOMSGQ(MOPERQ)
               SNDBRKMSG  MSG('MIDAS TELEX Subsystem (ORIONET) failed +
                          to start') TOMSGQ(&JOB)
               GOTO       CMDLBL(EXIT)
              ENDDO
              CHGVAR     VAR(&RQS) VALUE('CALL MTC5020 PARM(''START'' +
                           ''          '')')
              CHGVAR     VAR(%SST(&RQS 28 10)) VALUE(&JOB)
              RLSJOBQ    JOBQ(ORIONET1)
              MONMSG     MSGID(CPF3423)
/*************SBMJOB     JOB(START_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +*110242*/
/*************             RTGDTA(*JOBD) RQSDTA(&RQS) */              /*110242*/
/*************SBMJOB     JOB(START_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +
/*************       RTGDTA(*JOBD) RQSDTA(&RQS) INLLIBL(*JOBD) /*110242*123888*/
/************ SBMJOB     JOB(START_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +                   /*CPK014*/
/************              RTGDTA(*JOBD) RQSDTA(&RQS)                 /*123888*/          /*CPK014*/
/************ SBMJOB     JOB(START_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +                   /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQS)               /*CPK014*/ /*CSC023*/
              SBMJOB     JOB(START_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQS) OUTQ(*JOBD)              /*CSC023*/
              GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* STOP WORK MONITOR */
             IF         COND(&OPTION *EQ 'STOP ') THEN(DO)
              RLSJOBQ    JOBQ(ORIONET1)
              MONMSG     MSGID(CPF3423)
              CHGVAR     VAR(&RQS) VALUE('CALL MTC5020 PARM(''STOP '' +
                           ''          '')')
              CHGVAR     VAR(%SST(&RQS 28 10)) VALUE(&JOB)
              RLSJOBQ    JOBQ(ORIONET1)
              MONMSG     MSGID(CPF3423)
/*************SBMJOB     JOB(STOP_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +/*110242*/
/*************             RTGDTA(*JOBD) RQSDTA(&RQS) */              /*110242*/
/************SBMJOB     JOB(STOP_MON) JOBD(ORIONET1) JOBQ(ORIONET1) + /*123888*/
/************        RTGDTA(*JOBD) RQSDTA(&RQS) INLLIBL(*JOBD) /*110242*123888*/
/************ SBMJOB     JOB(STOP_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +                    /*CPK014*/
/************              RTGDTA(*JOBD) RQSDTA(&RQS)                 /*123888*/          /*CPK014*/
/************ SBMJOB     JOB(STOP_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +                    /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQS)               /*CPK014*/ /*CSC023*/
              SBMJOB     JOB(STOP_MON) JOBD(ORIONET1) JOBQ(ORIONET1) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQS) OUTQ(*JOBD)              /*CSC023*/
              GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* START-STOP TELEXBOXES */
             IF         COND(&OPTION *EQ 'CR3080') THEN(DO)
               CALL       PGM(&OPTION) PARM(X'00000F' ' ' '1' ' ')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX TRANSMISSION SCHEDULES */
             IF         COND(&OPTION *EQ 'CC1050') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TODAYS SCHEDULED EVENTS ENQUIRY */
             IF         COND(&OPTION *EQ 'CR3060') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* SCHEDULED EVENTS MAINTENANCE */
             IF         COND(&OPTION *EQ 'CR3110') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/********************************************************************/
/****************** S T A N D I N G   D A T A ***********************/
 
/* SYSTEM CONFIGURATION */
             IF         COND(&OPTION *EQ 'CR1060') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* LOCATION DETAILS */
             IF         COND(&OPTION *EQ 'CR1010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX USER PROFILES */
             IF         COND(&OPTION *EQ 'CR1020') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX ADDRESSES */
             IF         COND(&OPTION *EQ 'CR1030') THEN(DO)
              CALL       PGM(&OPTION) PARM(&USERID &USERID 'M' &DTEFMT)
              GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* ARCHIVE REFERENCES */
             IF         COND(&OPTION *EQ 'TR1020') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID &LOCCOD)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PUBLIC STANDARD TEXTS */
             IF         COND(&OPTION *EQ 'TC6010') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID '1')
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX TRANSMISSION SCHEDULES */
             IF         COND(&OPTION *EQ 'CR1050') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* PUBLIC DISTRIBUTION LISTS */
             IF         COND(&OPTION *EQ 'CR1095') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* DEPARTMENT DETAILS */
             IF         COND(&OPTION *EQ 'CR1100') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID &LOCCOD)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX LINE CONFIGURATION */
             IF         COND(&OPTION *EQ 'CR1110') THEN(DO)
               CALL       PGM(&OPTION) PARM(&USERID &USERID)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX CYCLE TIME */
             IF         COND(&OPTION *EQ 'MTXR2060') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
 
/* TELEX RATES */
             IF         COND(&OPTION *EQ 'MTXR2051') THEN(DO)
               CALL       PGM(&OPTION) PARM(&DTEFMT)
               GOTO       CMDLBL(EXIT)
             ENDDO
 
/********************************************************************/
EXIT:        IF         COND(%SWITCH(X0XXXXXX)) THEN(GOTO +
                          CMDLBL(END))
             SNDPGMMSG  MSGID(UNC0103) MSGF(*LIBL/NCM1) TOPGMQ(*EXT)
 
 
             IF         COND(%SWITCH(XX0XXXXX)) THEN(GOTO +
                          CMDLBL(END))
 
             SNDPGMMSG  MSGID(UNC0104) MSGF(*LIBL/NCM1) TOPGMQ(*EXT)
 
             DLCOBJ     OBJ((*LIBL/CC9000DA *DTAARA *SHRUPD))
             MONMSG     MSGID(CPF1005)
 
             CHGVAR     VAR(%SST(*LDA 11 10)) VALUE('          ')
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
