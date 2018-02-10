/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Control Testkey installation')               */
/********************************************************************/
/*                                                                  */
/*        Midas     Midas TELX MODULE                               */
/*                                                                  */
/*        MTC3010 - CONTROL TESTKEY INTERFACE INSTALLATION          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTK001             Date 11May99              */
/*                       E29983      DATE 22Oct91                   */
/*                       S01179      DATE 22/10/88                  */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*     BG18886 - Amend non-standard codes.                          */
/*     CTK001 - Testkey module conversion from DOS to WINDOWS        */
/*              95/NT (Testkey II)                                   */
/*     E29983 -- CONVERSION TO REL 10 CHANGE DLIB TO DMLIB AS DLIB   */
/*               DOES NOT EXIST AT REL 10                            */
/*     S01179 -- AS/400 CONVERSION                                   */
/********************************************************************/
 
             PGM
 
             DCL        VAR(&NUM) TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&NUM1) TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&NUM2) TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&NMDL) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&NMCR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
 
/************DCL        VAR(&VIRTD) TYPE(*CHAR) LEN(6)             */ /*S01179*/
 
/************DCL        VAR(&FLDR)  TYPE(*CHAR) LEN(6) */      /*S01179 CTK001*/
             DCL        VAR(&FLDR)  TYPE(*CHAR) LEN(8)                /*CTK001*/
 
             DCL        &LIB          TYPE(*CHAR)  LEN(10)
 
/*           DCLDTAARA  SDSTAT                                      *  *AS400*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*AS400*/
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CTK001*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*CTK001*/
             DCL       VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CTK001')  /*CTK001*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(200)                 /*CTK001*/
             DCL       VAR(&CTK001) TYPE(*CHAR) LEN(1) VALUE('N')     /*CTK001*/
/*           DCLDTAARA  DTAARA(N#ZTK)                               *  *AS400*/
             DCL        VAR(&N#ZTK) TYPE(*CHAR) LEN(100)              /*AS400*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
                                                                      /*CTK001*/
/** Check if Testkey II is installed.                              */ /*CTK001*/
                                                                      /*CTK001*/
            CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)         /*CTK001*/
                                                                      /*CTK001*/
            IF     COND(&RTCD *EQ '       ') THEN(CHGVAR +
                    VAR(&CTK001) VALUE('Y'))                          /*CTK001*/
 
             RTVJOBA    JOB(&WRKSTN)
 
/*           RCVDTAARA  SDSTAT                                      */ /*AS400*/
             RTVDTAARA  SDSTAT RTNVAR(&SDSTAT)                         /*AS400*/
/************CHGVAR    &LIB  VALUE(%SUBSTRING(&SDSTAT 6 2)  'DLIB')*/ /*E29983*/
/************CHGVAR    &LIB  VALUE(%SUBSTRING(&SDSTAT 6 2)**'DMLIB')*/ /*E29983*/ /*BG18886*/
             CHGVAR     VAR(&LIB) VALUE(%SUBSTRING(&SDSTAT 6 2) *CAT +
                          'DMLIB')                                    /*E29983*/  /*BG18886*/
                                                                      /*CTK001*/
             IF COND(&CTK001 *EQ 'Y')  THEN(DO)                       /*CTK001*/
/*                                                                */  /*CTK001*/
/**  Determine if shared folder exists. Otherwise create one.     */  /*CTK001*/
/*                                                                */  /*CTK001*/
/**********  CHGVAR     VAR(&FLDR) VALUE('TFLDR'*** +
                          %SUBSTRING(&SDSTAT 6 2)****'1')         */  /*CTK001*/  /*BG18886*/
             CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT +
                          %SUBSTRING(&SDSTAT 6 2) *CAT '1')           /*CTK001*/ /*BG18886*/
 
             CHKDLO     DLO(&FLDR)                                    /*CTK001*/
             MONMSG     MSGID(CPF8A77) EXEC(CRTFLR FLR(&FLDR) +
                          AUT(*ALL))                                  /*CTK001*/
             ENDDO                                                    /*CTK001*/
                                                                      /*CTK001*/
 
             ALCOBJ     OBJ((N#ZTK *DTAARA *EXCL))
 
/*********************************************************************/
/**  DO ROUTINE IF EXCLUSIVE ALLOCATION OF N#ZTK NOT POSSIBLE        */
/*********************************************************************/
             MONMSG     MSGID(CPF1002) EXEC(DO)
 
             SNDBRKMSG  MSG('DATA IS BEING USED BY ANOTHER +
                          WORKSTATION.PLEASE TRY AGAIN LATER') +
                          TOMSGQ(&WRKSTN)
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
/*           RCVDTAARA  DTAARA(N#ZTK)                               */ /*AS400*/
             RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)                   /*AS400*/
 
/*********************************************************************/
/**  CALL WITH PARAMETERS OF DATA AREA HOLDING DEVICE NAMES,         */
/**                          VALUES OF NUMBERS OF OLD AND NEW        */
/**                          DEVICES                                 */
/*********************************************************************/
             CALL       PGM(MT3020) PARM(&N#ZTK &NUM1 &NUM2)
 
/*           SNDDTAARA  DTAARA(N#ZTK)         S01179*/
             CHGDTAARA  DTAARA(N#ZTK) VALUE(&N#ZTK)  /*S01179*/
 
             DLCOBJ     OBJ((N#ZTK *DTAARA *EXCL))
 
/*********************************************************************/
/**  IF DEVICES OUTPUT TOTAL MORE THAN DEVICES READ IN   FROM        */
/**  SCREEN, DELETE CORRESPONDING NUMBER OF VIRTUAL DISKS/FOLDERS  */ /*S01179*/
/*********************************************************************/
/*    IF DOS BASED TESTKEY                                         */ /*CTK001*/
             IF         COND(&CTK001 *NE 'Y') THEN(DO)                /*CTK001*/
             IF         COND(&NUM1 *GT &NUM2) THEN(DO)
 
             CHGVAR     VAR(&NUM) VALUE(&NUM1)
 
 
 LOOP1:      CHGVAR     VAR(&NMDL) VALUE(&NUM - 1)
 
             CHGVAR     VAR(&NMCR) VALUE(&NMDL)
 
/************CHGVAR     VAR(&VIRTD) VALUE('V' *CAT &NMCR *CAT 'VDSK*/ /*S01179*/
 
             CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT   &NMCR )       /*S01179*/
 
/************DLTF       FILE(&VIRTD)                               */ /*S01179*/
 
             DLTDLO     DLO(*ALL) FLR(&FLDR)                          /*S01179*/
 
             CHGVAR     VAR(&NUM) VALUE(&NUM - 1)
 
             IF         COND(&NUM *GT &NUM2) THEN(GOTO CMDLBL(LOOP1))
 
             ENDDO
 
             ENDDO                                                    /*CTK001*/
/*********************************************************************/
/**  IF DEVICES OUTPUT TOTAL LESS THAN DEVICES READ IN   FROM        */
/**  SCREEN, CREATE CORRESPONDING NUMBER OF VIRTUAL DISKS/FOLDERS  */ /*S01179*/
/*********************************************************************/
/*    IF DOS BASED TESTKEY                                        */  /*CTK001*/
             IF         COND(&CTK001 *NE 'Y') THEN(DO)                /*CTK001*/
             IF         COND(&NUM1 *LT &NUM2) THEN(DO)
 
             CHGVAR     VAR(&NUM) VALUE(&NUM1 + 1)
 
 LOOP2:      CHGVAR     VAR(&NMDL) VALUE(&NUM - 1)
 
             CHGVAR     VAR(&NMCR) VALUE(&NMDL)
 
/************CHGVAR     VAR(&VIRTD) VALUE('V' *CAT &NMCR *CAT 'VDSK*/ /*S01179*/
 
/************CRTVDSK    VDSK(&VIRTD.&LIB)                          */ /*S01179*/
 
             CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT &NMCR)          /*S01179*/
             CRTFLR     FLR(&FLDR)                                    /*S01179*/
 
             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)
 
             IF         COND(&NUM *LE &NUM2) THEN(GOTO CMDLBL(LOOP2))
 
             ENDDO
             ENDDO                                                    /*CTK001*/
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Control Testkey Interface Installation +
                          ended abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
