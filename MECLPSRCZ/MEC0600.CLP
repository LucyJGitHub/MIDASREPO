/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME outgoing message maintenance')               */
/*********************************************************************/
/*                                                                   */
/*     Midas - MESSAGE MANAGEMENT                                */
/*                                                                   */
/*     MEC0600 - OUTGOING MESSAGE DETAIL MAINTENANCE                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CTK001             Date 11May99              */
/*                      067460             Date 01Nov94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     CTK001 - Testkey module conversion from DOS to WINDOWS        */
/*              95/NT (Testkey II)                                   */
/*     067460 - ME0600 fails trying to generate testkey when not     */
/*              running on Testkey PC.                               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TRNO &BGCFMT &ACTN &FILA &RTCD &ERR)
 
             DCL        VAR(&TRNO) TYPE(*CHAR) LEN(16)
             DCL        VAR(&BGCFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TK) TYPE(*CHAR) LEN(1) VALUE('N')        /*067460*/
 
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)                /*CTK001*/
             DCL       VAR(&RETCOD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*CTK001*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*CTK001*/
             DCL       VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CTK001')  /*CTK001*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(200)                 /*CTK001*/
             DCL       VAR(&CTK001) TYPE(*CHAR) LEN(1) VALUE('N')     /*CTK001*/
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&Y) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&N#ZTK) TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,MEC0600002                                          */
 
/**  Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000) +
                          EXEC(GOTO ABNOR)
                                                                      /*CTK001*/
            CALL   PGM(AOSARDR0) PARM(&RETCOD &OPTN &SARD &FMT)       /*CTK001*/
                                                                      /*CTK001*/
            IF     COND(&RETCOD *EQ '       ') THEN(CHGVAR +
                        VAR(&CTK001) VALUE('Y'))                      /*CTK001*/
 
             OVRDBF     FILE(MGOREFLU) TOFILE(MGOREFL0) SHARE(*NO)
/*/COPY WNCPYSRC,MEC0600001                                          */
 
/**  If Testkey interface present */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SST(&MMOD 58 1) *EQ 'Y') THEN(DO)
 
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF0000)
 
/**  Copy TKOTIPF and TKOTOPF to QTEMP */
             CPYF       FROMFILE(TKOTIPF) TOFILE(QTEMP/TKOTIPF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
             CPYF       FROMFILE(TKOTOPF) TOFILE(QTEMP/TKOTOPF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)
 
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)
                                                                      /*CTK001*/
             RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)                  /*CTK001*/
                                                                      /*CTK001*/
/** If Testkey 2000 is installed, check for validity of User ID    */ /*CTK001*/
/** instead of the PC device name and DO NOT use STRPCO as this    */ /*CTK001*/
/** is no longer applicable to Windows environment.                */ /*CTK001*/
                                                                      /*CTK001*/
             IF     COND(&CTK001 *EQ 'Y') THEN(DO)                    /*CTK001*/
                                                                      /*CTK001*/
             RTVJOBA    USER(&NAME)                                   /*CTK001*/
                                                                      /*CTK001*/
LOOP1:       CHGVAR     VAR(&USID) VALUE(%SUBSTRING(&N#ZTK &X 10))    /*CTK001*/
                                                                      /*CTK001*/
/** If user is a valid Testkey profile, set Testkey flag prior     */ /*CTK001*/
/** to running ME0600.                                             */ /*CTK001*/
                                                                      /*CTK001*/
             IF         COND(&NAME *EQ &USID) THEN(DO)                /*CTK001*/
             CHGVAR     VAR(&TK) VALUE('Y')                           /*CTK001*/
             GOTO       CMDLBL(PCONO)                                 /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
             IF         COND(&Y *EQ 9) THEN(GOTO CMDLBL(PCONO))       /*CTK001*/
                                                                      /*CTK001*/
             CHGVAR     VAR(&Y) VALUE(&Y + 1)                         /*CTK001*/
             CHGVAR     VAR(&X) VALUE(&X + 10)                        /*CTK001*/
             GOTO LOOP1                                               /*CTK001*/
                                                                      /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
/** If Testkey 2000 not installed, process using STRPCO.              /*CTK001*/
                                                                      /*CTK001*/
             IF     COND(&CTK001 *EQ 'N') THEN(DO)                    /*CTK001*/
 
/**  Is job valid testkey PC device name on N#ZTK data area */
             RTVJOBA    JOB(&NAME)
/************RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)               */ /*CTK001*/
 
LOOP:        CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&N#ZTK &X 10))
             IF         COND(&NAME *EQ &WSID) THEN(GOTO PCOYES)
             IF         COND(&Y *EQ 9) THEN(GOTO PCONO)
             CHGVAR     VAR(&Y) VALUE(&Y + 1)
             CHGVAR     VAR(&X) VALUE(&X + 10)
             GOTO       CMDLBL(LOOP)
 
/** Start PC Support Organiser */
/*PCOYES:****STRPCO                                                   /*067460*/
PCOYES:      CHGVAR     VAR(&TK) VALUE('Y')                           /*067460*/
             STRPCO                                                   /*067460*/
             MONMSG     MSGID(IWS4010) EXEC(GOTO CMDLBL(PCONO))
                                                                      /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
/************DLYJOB     DLY(15)                                       /*067460*/
/*           STRPCCMD   PCCMD('C:\PCS\TKINIT') PAUSE(*NO) */
 
/* CALL PROGRAM TO SOAK UP 'GO PCOMNU' COMMAND WHICH IS SENT TO */
/* DISPLAY BUFFER WHEN STRPCCMD IS RUN FOR FIRST TIME           */
/*           CALL MT1239 */
PCONO:       ENDDO
 
/* Call Input Cycle Enquiry Program. */
/************CALL       PGM(ME0600) PARM(&TRNO &BGCFMT &ACTN &FILA +  /*067460*/
/************             &RTCD &ERR)                                 /*067460*/
/*/COPY WNCPYSRC,MEH00001                                            */
             CALL       PGM(ME0600) PARM(&TRNO &BGCFMT &ACTN &FILA +
                          &RTCD &ERR &TK)                             /*067460*/
/*/COPY WNCPYSRC,MEH00002                                            */
 
             GOTO END
ABNOR:       CHGVAR VAR(&ERR) VALUE('1')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
