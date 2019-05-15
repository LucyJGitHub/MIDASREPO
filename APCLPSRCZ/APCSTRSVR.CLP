/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AP Start the server')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APCSTRSVR - Start the server                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/*                      CAP083             Date 20Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP002  *CREATE    Date 01May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP083 - APISERVER File Adapter                             */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CAP002 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SYSTEM)
 
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          XLIB    ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDPLIB   ')
 
             DCL        VAR(&RUNBEFORE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RUNBEFORE2) TYPE(*CHAR) LEN(1) VALUE('N')                    /*CAP083*/
             DCL        VAR(&RUNBEFORE3) TYPE(*CHAR) LEN(1) VALUE('N')                    /*CAP083*/
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                     /*CAP083*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                                    /*CAP083*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                      /*CAP083*/
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)                                    /*CAP083*/
             DCL        VAR(&OUTQLIB) TYPE(*CHAR) LEN(10)                                 /*CAP083*/
             DCL        VAR(&CAP083) TYPE(*CHAR) LEN(1)                                   /*CAP083*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CAP083*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CAP083*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CAP083*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAP083*/
                                                                                          /*CAP083*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*CAP083*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                  /*CAP083*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*CAP083*/
             DCL        VAR(&APIM) TYPE(*CHAR) LEN(4)                                     /*CAP083*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(%SST(&XLIB 1 2)) VALUE(&SYSTEM)
             CHGVAR     VAR(%SST(&DPLIB 1 2)) VALUE(&SYSTEM)
 
                                                                                          /*CAP083*/
/*  Check if APISERVER File Adapter (CAP083) Enhancement is installed */                  /*CAP083*/
                                                                                          /*CAP083*/
             CHGVAR     VAR(&SAR) VALUE('CAP083')                                         /*CAP083*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAP083*/
             CHGVAR     VAR(&CAP083) VALUE('N')                                           /*CAP083*/
/*/                                                                                       /*CAP083*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CAP083*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CAP083*/
                   CHGVAR     VAR(&CAP083) VALUE('Y')                                     /*CAP083*/
                                                                                          /*CAP083*/
/*     Get 'APIProcessingMode' system value from file SDSVALPD  */                        /*CAP083*/
                                                                                          /*CAP083*/
                   CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                                'APIProcessingMode' &SVAL1 &SVALK2 +
                                &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                                &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                                &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                                &SVALK0 &SVAL10)                                          /*CAP083*/
                                                                                          /*CAP083*/
/*     If the 'APIProcessingMode' system value is missing then end abnormally */          /*CAP083*/
                                                                                          /*CAP083*/
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNOR))                                            /*CAP083*/
                   ELSE
                              CHGVAR     VAR(&APIM) VALUE(%SST(&SVAL1 1 4))               /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
/*  If CAP083 is not installed do original processing */                                  /*CAP083*/
                                                                                          /*CAP083*/
             IF         COND(&CAP083 *EQ 'N') THEN(DO)                                    /*CAP083*/
                                                                                          /*CAP083*/
/* +
   Allocate the locking data area to determine if the server is +
   already active.  Only start it if it is not. +
   If the initial allocation was successful: +
     - deallocate the data area  +
     - delay for 5 seconds and retry the allocation +
     - only perform, the submit if the second allocation works, +
       in case the job is already submitted but not yet active. +
*/
LOOP:
             ALCOBJ     OBJ((&DPLIB/APISERVER *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP1))
 
             DLCOBJ     OBJ((&DPLIB/APISERVER *DTAARA *EXCL))
 
             IF         COND(&RUNBEFORE *EQ 'N') THEN(DO)
                CHGVAR     VAR(&RUNBEFORE) VALUE('Y')
                DLYJOB     DLY(5)
                GOTO       CMDLBL(LOOP)
             ENDDO
 
/************SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVER) +                         /*CPK014*/
/************             JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +                     /*CPK014*/
/************             RTGDTA(MULTILANGUAGE) INLLIBL(*JOBD) +                          /*CPK014*/
/************             LOGCLPGM(*NO)                                                   /*CPK014*/
/************SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVER) +                         /*CSC023*/
/************             JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(MULTILANGUAGE) +                             /*CSC023*/
/************             INLLIBL(*JOBD) LOGCLPGM(*NO)                         /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVER) +
                          JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +
                          USER(*JOBD) RTGDTA(MULTILANGUAGE) +
                          INLLIBL(*JOBD) LOGCLPGM(*NO) OUTQ(*JOBD)                        /*CSC023*/
SKIP1:
             GOTO       CMDLBL(END)
                                                                                          /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
                                                                                          /*CAP083*/
/*  If CAP083 is installed submit new jobs depending on system value */                   /*CAP083*/
                                                                                          /*CAP083*/
             IF         COND(&CAP083 *EQ 'Y') THEN(DO)                                    /*CAP083*/
                                                                                          /*CAP083*/
/*  Submit MQSeries processing job */                                                     /*CAP083*/
                                                                                          /*CAP083*/
             IF         COND(&APIM *EQ 'APMQ' *OR &APIM *EQ 'BOTH') +
                          THEN(DO)                                                        /*CAP083*/
                                                                                          /*CAP083*/
/* Allocate the locking data area to determine if the server is                           /*CAP083*/
/* already active.  Only start it if it is not.                                           /*CAP083*/
/* If the initial allocation was successful:                                              /*CAP083*/
/*   - deallocate the data area                                                           /*CAP083*/
/*   - delay for 5 seconds and retry the allocation                                       /*CAP083*/
/*   - only perform, the submit if the second allocation works,                           /*CAP083*/
/*     in case the job is already submitted but not yet active.                           /*CAP083*/
                                                                                          /*CAP083*/
LOOP2:                                                                                    /*CAP083*/
             ALCOBJ     OBJ((&DPLIB/APISERVER *DTAARA *EXCL)) WAIT(0)                     /*CAP083*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP2))                           /*CAP083*/
                                                                                          /*CAP083*/
             DLCOBJ     OBJ((&DPLIB/APISERVER *DTAARA *EXCL))                             /*CAP083*/
                                                                                          /*CAP083*/
             IF         COND(&RUNBEFORE2 *EQ 'N') THEN(DO)                                /*CAP083*/
                CHGVAR     VAR(&RUNBEFORE2) VALUE('Y')                                    /*CAP083*/
                DLYJOB     DLY(5)                                                         /*CAP083*/
                GOTO       CMDLBL(LOOP2)                                                  /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
/************SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVMQ) +                         /*CSC023*/
/************             JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(MULTILANGUAGE) +                             /*CSC023*/
/************             INLLIBL(*JOBD) LOGCLPGM(*NO)                         /*CAP083*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVMQ) +
                          JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +
                          USER(*JOBD) RTGDTA(MULTILANGUAGE) +
                          INLLIBL(*JOBD) LOGCLPGM(*NO)  OUTQ(*JOBD)                       /*CSC023*/
SKIP2:                                                                                    /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
                                                                                          /*CAP083*/
/*  Submit FILE processing job */                                                         /*CAP083*/
                                                                                          /*CAP083*/
             IF         COND(&APIM *EQ 'FILE' *OR &APIM *EQ 'BOTH') +
                          THEN(DO)                                                        /*CAP083*/
                                                                                          /*CAP083*/
/* Allocate the locking data area to determine if the server is                           /*CAP083*/
/* already active.  Only start it if it is not.                                           /*CAP083*/
/* If the initial allocation was successful:                                              /*CAP083*/
/*   - deallocate the data area                                                           /*CAP083*/
/*   - delay for 5 seconds and retry the allocation                                       /*CAP083*/
/*   - only perform, the submit if the second allocation works,                           /*CAP083*/
/*     in case the job is already submitted but not yet active.                           /*CAP083*/
                                                                                          /*CAP083*/
LOOP3:                                                                                    /*CAP083*/
             ALCOBJ     OBJ((&DPLIB/APISERVFL *DTAARA *EXCL)) WAIT(0)                     /*CAP083*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP3))                           /*CAP083*/
                                                                                          /*CAP083*/
             DLCOBJ     OBJ((&DPLIB/APISERVFL *DTAARA *EXCL))                             /*CAP083*/
                                                                                          /*CAP083*/
             IF         COND(&RUNBEFORE3 *EQ 'N') THEN(DO)                                /*CAP083*/
                CHGVAR     VAR(&RUNBEFORE3) VALUE('Y')                                    /*CAP083*/
                DLYJOB     DLY(5)                                                         /*CAP083*/
                GOTO       CMDLBL(LOOP3)                                                  /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
/************SBMJOB     CMD(CALL PGM(APISERVFL)) JOB(APISERVFL) +                         /*CSC023*/
/************             JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(MULTILANGUAGE) +                             /*CSC023*/
/************             INLLIBL(*JOBD) LOG(3 *JOBD *JOBD) +                             /*CSC023*/
/************             LOGCLPGM(*NO)                                        /*CAP083*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(APISERVFL)) JOB(APISERVFL) +
                          JOBD(&XLIB/MIDASIC) JOBQ(&XLIB/INTERFACE) +
                          USER(*JOBD) RTGDTA(MULTILANGUAGE) +
                          INLLIBL(*JOBD) LOG(3 *JOBD *JOBD) +
                          LOGCLPGM(*NO) OUTQ(*JOBD)                                       /*CSC023*/
SKIP3:                                                                                    /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
             ENDDO                                                                        /*CAP083*/
                                                                                          /*CAP083*/
             GOTO       CMDLBL(END)                                                       /*CAP083*/
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          STRAPISVR ended abnormally - see job log')
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
