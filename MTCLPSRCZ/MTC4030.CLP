/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Testkey generation')                         */
/*********************************************************************/
/*                                                                   */
/*     Midas - TELEX INTERFACE                               */
/*                                                                   */
/*     MTC4030 - TESTKEY GENERATION                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      175018             Date 01Aug00              */
/*                    174197               DATE 01Aug00              */
/*                    170748               DATE 01Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    CTK001               DATE 11May99              */
/*                    067236               DATE 01NOV94              */
/*                    067234               DATE 01NOV94              */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*    BG18886 - Amend non-standard codes.                            */
/*     175018 - Input file not being cleared under certain           */
/*              conditions which results to Testkey value problems   */
/*     174197 - If BISTKO is looking at BISTKO.INP when this prog    */
/*              is trying to delete it, it can be left and the wrong */
/*              keys produced                                        */
/*     170748 - Wrong keys are being calculated for outgoing         */
/*              messages when more than one Testkey users send       */
/*              batches of telexes for BISTKO calculation            */
/*     CTK001 - Testkey module conversion from DOS to WINDOWS        */
/*              95/NT (Testkey II).                                  */
/*     067236 -- Return failure code to calling program if errors    */
/*               occur                                               */
/*     067234 -- Change all STRPCCMDs to PAUSE(*NO)                  */
/*********************************************************************/
/*                                                                   */
/*   The second character of the data area can be printed as a       */
/*   'pound' or 'hash' depending on the keyboard used                */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*067236*/
             PGM        PARM(&RTCD)                                   /*067236*/
 
/************DCL        VAR(&FLDR) TYPE(*CHAR) LEN(6)              */ /*CTK001*/
             DCL        VAR(&FLDR) TYPE(*CHAR) LEN(8)                 /*CTK001*/
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)                /*CTK001*/
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&Y) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&Z) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) VALUE(' ') */            /*067236*/ /*170748*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)                 /*170748*/
             DCL        VAR(&COUNT1) TYPE(*DEC) LEN(2 0) VALUE(0)     /*CTK001*/
             DCL        VAR(&COUNT2) TYPE(*DEC) LEN(2 0) VALUE(0)     /*CTK001*/
             DCL       VAR(&RETCOD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*CTK001*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*CTK001*/
             DCL       VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CTK001')  /*CTK001*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(200)                 /*CTK001*/
             DCL       VAR(&CTK001) TYPE(*CHAR) LEN(1) VALUE('N')     /*CTK001*/
             DCL       VAR(&SDSTAT) TYPE(*CHAR) LEN(256)              /*CTK001*/
             DCL       VAR(&SYSPRF) TYPE(*CHAR) LEN(2)                /*CTK001*/
             DCL       VAR(&ORG)    TYPE(*CHAR) LEN(1) VALUE('1')     /*CTK001*/
             DCL       VAR(&INPLUP) TYPE(*DEC) LEN(2 0) VALUE(0)      /*174197*/
             DCL       VAR(&OUTLUP) TYPE(*DEC) LEN(2 0) VALUE(0)      /*174197*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&N#ZTK) TYPE(*CHAR) LEN(100)
 
/**  Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
/**/                                                                  /*170748*/
/** Set off database job switches                                  */ /*170748*/
/**/                                                                  /*170748*/
             CHGJOB     SWS(XXXXXX00)                                 /*170748*/
                                                                      /*170748*/
             ALCOBJ     OBJ((N#ZTK *DTAARA *SHRRD))
             MONMSG     MSGID(CPF1002) EXEC(GOTO ABNOR)
 
/** Retrieve data from Testkey setup from data area                */ /*CTK001*/
                                                                      /*CTK001*/
            RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)                   /*CTK001*/
                                                                      /*CTK001*/
/** Check if Testkey 2000 (for Windows NT) is installed */            /*CTK001*/
                                                                      /*CTK001*/
            CALL   PGM(AOSARDR0) PARM(&RETCOD &OPTN &SARD &FMT)       /*CTK001*/
                                                                      /*CTK001*/
            IF     COND(&RETCOD *EQ '       ') THEN(CHGVAR +
                    VAR(&CTK001) VALUE('Y'))                          /*CTK001*/
                                                                      /*CTK001*/
/** If Testkey 2000 is installed, check for validity of User ID    */ /*CTK001*/
/** instead of the PC device name and DO NOT use STRPCO            */ /*CTK001*/
                                                                      /*CTK001*/
             IF     COND(&CTK001 *EQ 'Y') THEN(DO)                    /*CTK001*/
                                                                      /*CTK001*/
             RTVJOBA    USER(&NAME)                                   /*CTK001*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*CTK001*/
             CHGVAR     VAR(&SYSPRF)   VALUE(%SUBSTRING(&SDSTAT 6 2)) /*CTK001*/
                                                                      /*CTK001*/
LOOP1:       CHGVAR     VAR(&USID) VALUE(%SUBSTRING(&N#ZTK &X 10))    /*CTK001*/
             IF         COND(&NAME *EQ &USID) THEN(DO)                /*CTK001*/
                                                                      /*CTK001*/
/** If user is a valid Testkey profile, set up shared folder       */ /*CTK001*/
                                                                      /*CTK001*/
/**********  CHGVAR     VAR(&FLDR) VALUE('TFLDR'**&SYSPRF**&ORG)      /*CTK001*/
             CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT &SYSPRF *CAT +
                          &ORG)                                       /*CTK001*/ /*BG18886*/
             GOTO       CMDLBL(PCONO)                                 /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
             IF         COND(&Y *EQ 9) THEN(DO)                       /*CTK001*/
/**********  SNDPGMMSG  MSG('Testkey generation must be ran by a +
/**********             valid Midas Testkey user.') +
/**********             TOMSGQ(MOPERQ) TOPGMQ(*EXT) */         /*CTK001 170748*/
             SNDPGMMSG  MSG('Testkey generation must be run by a +
                        valid Midas Testkey user.') +
                        TOMSGQ(MOPERQ) TOPGMQ(*EXT)                   /*170748*/
/**/                                                                  /*170748*/
/** Return an error code to calling program MT4020                 */ /*170748*/
/**/                                                                  /*170748*/
             CHGVAR     VAR(&RTCD) VALUE('E')                         /*170748*/
             GOTO       CMDLBL(END)                                   /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
             CHGVAR     VAR(&Y) VALUE(&Y + 1)                         /*CTK001*/
             CHGVAR     VAR(&X) VALUE(&X + 10)                        /*CTK001*/
             GOTO LOOP1                                               /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
/** If Testkey 2000 not installed, process using STRPCO.              /*CTK001*/
                                                                      /*CTK001*/
             IF     COND(&CTK001 *EQ 'N') THEN(DO)                    /*CTK001*/
                                                                      /*CTK001*/
/**  Is job valid testkey PC device name on N#ZTK data area */
             RTVJOBA    JOB(&NAME)
/************RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)               */ /*CTK001*/
 
LOOP:        CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&N#ZTK &X 10))
             IF         COND(&NAME *EQ &WSID) THEN(GOTO PCOYES)
             IF         COND(&Y *EQ 9) THEN(GOTO ABNOR)
             CHGVAR     VAR(&Y) VALUE(&Y + 1)
             CHGVAR     VAR(&X) VALUE(&X + 10)
             GOTO LOOP
 
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
/**  Set up the value of folder associated with this PC */
PCOYES:      CHGVAR     VAR(&Z) VALUE(&Y)
             CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT &Z)
 
CPYF TKOTIPF *PRINT
             CPYTOPCD   FROMFILE(TKOTIPF) TOFLR(&FLDR) +
                          TODOC(BISTKO.INP) REPLACE(*YES)
             MONMSG     MSGID(CPF8A77) EXEC(CRTFLR FLR(&FLDR) +
                          AUT(*ALL))                                  /*CTK001*/
 
/**  Change message queue so 'completion of test key' not displayed */
/*           CHGMSGQ    MSGQ(&NAME) DLVRY(*HOLD) */
/* Clear PC file                                                        067236*/
             CLRPFM     FILE(TKOTOPF)                                 /*067236*/
             CPYTOPCD   FROMFILE(TKOTOPF) TOFLR(&FLDR) +
                          TODOC(BISTKO.OUT) REPLACE(*YES)             /*067236*/
 
/************STRPCCMD PCCMD(TKOUT) PAUSE(*YES)                        /*067234*/
             STRPCCMD   PCCMD(TKOUT) PAUSE(*NO)                       /*067234*/
 
/*           RMVMSG     MSGQ(QSYS/&NAME) CLEAR(*NEW) */
/*           CHGMSGQ    MSGQ(&NAME) DLVRY(*BREAK) */
 
/**  Retrieve testkey or error codes from PC */
             CPYFRMPCD  FROMFLR(&FLDR) TOFILE(TKOTOPF) +
                          FROMDOC(BISTKO.OUT)
 
             GOTO END
 
/** If Testkey 2000 is installed, check that no other Testkey      */ /*CTK001*/
/** request has been submitted prior to this one. Otherwise,       */ /*CTK001*/
/** send info on the screen and end processing.                    */ /*CTK001*/
                                                                      /*CTK001*/
PCONO:    CHKDLO    DLO(BISTKO.INP) FLR(&FLDR)                        /*CTK001*/
                                                                      /*CTK001*/
          MONMSG    MSGID(CPF8A82) EXEC(DO)                           /*CTK001*/
                                                                      /*CTK001*/
                CPYF      FROMFILE(TKOTIPF) TOFILE(*PRINT)            /*CTK001*/
                CPYTOPCD  FROMFILE(TKOTIPF) TOFLR(&FLDR) +
                          TODOC(BISTKO.INP) REPLACE(*YES)             /*CTK001*/
                MONMSG    MSGID(CPF8A77)  EXEC(CRTFLR FLR(&FLDR) +
                          AUT(*ALL))                                  /*CTK001*/
                                                                      /*CTK001*/
RETRY:          CHKDLO DLO(BISTKO.OUT) FLR(&FLDR)                     /*CTK001*/
                                                                      /*CTK001*/
/************   MONMSG MSGID(CPF8A82 CPF8A80) EXEC(DO)         /*CTK001 170748*/
                MONMSG MSGID(CPF8A82 CPF8A80 CPF8A11) EXEC(DO)        /*170748*/
                                                                      /*CTK001*/
                   IF COND(&COUNT2 *GE 20) THEN(DO)                   /*CTK001*/
                      SNDPGMMSG  MSG('Testkey not generated. Please +
                         check that BISTKO job is running.') +
                         TOMSGQ(MOPERQ) TOPGMQ(*EXT)                  /*CTK001*/
/************         CLRPFM FILE(TKOTOPF)                     /*CTK001 170748*/
/************         GOTO   CMDLBL(ABNOR)                     /*CTK001 170748*/
                      GOTO   CMDLBL(NOTRUN)                           /*170748*/
                   ENDDO                                              /*CTK001*/
                                                                      /*CTK001*/
                   CHGVAR VAR(&COUNT2) VALUE(&COUNT2+1)               /*CTK001*/
                   DLYJOB DLY(7)                                      /*CTK001*/
                   GOTO   CMDLBL(RETRY)                               /*CTK001*/
                                                                      /*CTK001*/
                ENDDO                                                 /*CTK001*/
                                                                      /*CTK001*/
/** Retrieve Testkey data or error code (if any) generated by PC   */ /*CTK001*/
                                                                      /*CTK001*/
             CLRPFM     FILE(TKOTOPF)                                 /*CTK001*/
             CPYFRMPCD  FROMFLR(&FLDR) TOFILE(TKOTOPF) +
                          FROMDOC(BISTKO.OUT)                         /*CTK001*/
             MONMSG     MSGID(CPF8A80 IWS16B8 IWS1611) EXEC(GOTO +
                          RETRY)                                      /*CTK001*/
/************GOTO CMDLBL(END) */                                               /*CTK001*/ /*170748*/
             GOTO CMDLBL(NORMAL)                                                          /*170748*/
                                                                      /*CTK001*/
          ENDDO                                                       /*CTK001*/
                                                                      /*CTK001*/
             IF COND(&COUNT1 *GE 10) THEN(DO)                         /*CTK001*/
                SNDPGMMSG  MSG('Testkey request being processed +
                  for another user. Please retry.') +
                  TOMSGQ(MOPERQ) TOPGMQ(*EXT)                         /*CTK001*/
/************     GOTO   CMDLBL(END)                        */ /*CTK001 170748*/
/**/                                                                  /*170748*/
/** Return an error code                                           */ /*170748*/
/**/                                                                  /*170748*/
                  CHGVAR     VAR(&RTCD) VALUE('E')                    /*170748*/
                  GOTO       CMDLBL(BUSY)                             /*170748*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
           CHGVAR VAR(&COUNT1) VALUE(&COUNT1 +1)                      /*CTK001*/
           DLYJOB DLY(5)                                              /*CTK001*/
           GOTO   CMDLBL(PCONO)                                       /*CTK001*/
                                                                      /*CTK001*/
           GOTO   CMDLBL(END)                                         /*CTK001*/
                                                                      /*CTK001*/
ABNOR:       SNDPGMMSG  MSG('Testkey generation ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             CHGVAR     VAR(&RTCD) VALUE('E')                         /*067236*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)
             GOTO       CMDLBL(END)                                   /*170748*/
 
/***END:*****DLCOBJ     OBJ((N#ZTK *DTAARA *SHRRD))                */ /*170748*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)     */ /*170748*/
/************CLRPFM     FILE(TKOTIPF)                              */ /*170748*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)     */ /*170748*/
/************DLTDLO DLO(BISTKO.INP) FLR(&FLDR)              */ /*CTK001 170748*/
/************MONMSG  MSGID(CPF0000 RPG0000 MCH0000 IWS0000) */ /*CTK001 170748*/
/************DLTDLO DLO(BISTKO.OUT) FLR(&FLDR)              */ /*CTK001 170748*/
/************MONMSG  MSGID(CPF0000 RPG0000 MCH0000 IWS0000) */ /*CTK001 170748*/
 
/**/                                                                   /*174197*/
/** If the batch submitted has timed out and not processed by BISTKO*/ /*174197*/
/**/                                                                   /*174197*/
NOTRUN:      DLTDLO DLO(BISTKO.INP) FLR(&FLDR)                         /*174197*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000 IWS0000)             /*174197*/
/**/                                                                   /*174197*/
             CHKDLO DLO(BISTKO.INP) FLR(&FLDR)                         /*174197*/
             MONMSG MSGID(CPF8A82) EXEC(DO)                            /*174197*/
                 GOTO CMDLBL(BUSY)                                     /*174197*/
             ENDDO                                                     /*174197*/
/**/                                                                   /*174197*/
             IF COND(&INPLUP *LE 10) THEN(DO)                          /*174197*/
                CHGVAR VAR(&INPLUP) VALUE(&INPLUP + 1)                 /*174197*/
                DLYJOB DLY(5)                                          /*174197*/
                GOTO CMDLBL(NOTRUN)                                    /*174197*/
             ENDDO                                                     /*174197*/
/**/                                                                   /*174197*/
             SNDPGMMSG  MSG('File BISTKO.INP not deleted. +
                  This may result in errors if not deleted.') +
                  TOMSGQ(MOPERQ) TOPGMQ(*EXT)                          /*174197*/
                                                                       /*174197*/
BUSY:        CLRPFM    FILE(TKIBCKPD)                                  /*174197*/
             CPYF      FROMFILE(TKOTIPF) TOFILE(TKIBCKPD) +
                                MBROPT(*REPLACE)                       /*174197*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)         /*174197*/
/**/                                                                   /*174197*/
/** Return an error code */                                            /*174197*/
/**/                                                                   /*174197*/
             CHGVAR     VAR(&RTCD) VALUE('E')                          /*174197*/
/************GOTO CMDLBL(END)                                */ /*174197 175018*/
             GOTO CMDLBL(CLRIPF)                                       /*175018*/
                                                                       /*174197*/
NORMAL:      DLTDLO DLO(BISTKO.INP) FLR(&FLDR)                         /*174197*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)         /*174197*/
/**/                                                                   /*174197*/
             CHKDLO DLO(BISTKO.INP) FLR(&FLDR)                         /*174197*/
             MONMSG MSGID(CPF8A82) EXEC(DO)                            /*174197*/
                 GOTO CMDLBL(DELOUT)                                   /*174197*/
             ENDDO                                                     /*174197*/
/**/                                                                   /*174197*/
             IF COND(&INPLUP *LE 10) THEN(DO)                          /*174197*/
                CHGVAR VAR(&INPLUP) VALUE(&INPLUP + 1)                 /*174197*/
                DLYJOB DLY(5)                                          /*174197*/
                GOTO CMDLBL(NORMAL)                                    /*174197*/
             ENDDO                                                     /*174197*/
/**/                                                                   /*174197*/
             SNDPGMMSG  MSG('File BISTKO.INP not deleted. +
                This may result in errors if not deleted.') +
                TOMSGQ(MOPERQ) TOPGMQ(*EXT)                            /*174197*/
             GOTO   CMDLBL(DELOUT)                                     /*174197*/
/**/                                                                   /*174197*/
DELOUT:      DLTDLO DLO(BISTKO.OUT) FLR(&FLDR)                         /*174197*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000 IWS0000)             /*174197*/
/**/                                                                   /*174197*/
             CHKDLO DLO(BISTKO.OUT) FLR(&FLDR)                         /*174197*/
             MONMSG MSGID(CPF8A82) EXEC(DO)                            /*174197*/
                 GOTO CMDLBL(CLRIPF)                                   /*174197*/
             ENDDO                                                     /*174197*/
/**/                                                                   /*174197*/
             IF COND(&OUTLUP *LE 10) THEN(DO)                          /*174197*/
                CHGVAR VAR(&OUTLUP) VALUE(&OUTLUP + 1)                 /*174197*/
                DLYJOB DLY(5)                                          /*174197*/
                GOTO CMDLBL(DELOUT)                                    /*174197*/
             ENDDO                                                     /*174197*/
/**/                                                                   /*174197*/
             SNDPGMMSG  MSG('File BISTKO.OUT not deleted. +
                This may result in errors if not deleted.') +
                TOMSGQ(MOPERQ) TOPGMQ(*EXT)                            /*174197*/
/**/                                                                   /*174197*/
CLRIPF:      CLRPFM     FILE(TKOTIPF)                                  /*174197*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)         /*174197*/
/**/                                                                   /*174197*/
/******CHGVAR &BISCPY '(C) COPYRIGHT MKI LIMITED 1994'              */ /*170748*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
