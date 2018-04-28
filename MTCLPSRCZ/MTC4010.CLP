/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Message conversion')                         */
/*********************************************************************/
/*                                                                   */
/*     Midas - TELEX INTERFACE                                       */
/*                                                                   */
/*     MTC4010 - MESSAGE CONVERSION                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. 166649             Date 31Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    CPK009               Date 09Aug99              */
/*                    CMT001               DATE 17FEB99              */
/*                    067399               DATE 31OCT94              */
/*                    066921               DATE 31OCT94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     CPK014 - Release 4 packaging.  Move data queues from XLIB to  */
/*               DPLIB.                                              */
/*     166649 - Produce a joblog and dump if the job ends abnormally */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     CMT001 - Telex Module upgrade to Midas Mailer (Telex 3.3).    */
/*              Call MT4011 instead of MT4010. Also create           */
/*              DTAQ/MTDTQA with AUT(*ALL) to enable Telex           */
/*              link to be started during Input Cycle phase.         */
/*     067399 - Unable to Stop/Start link to Orion in Input Cycle    */
/*     066921 - Error in Midas Telex to Orion conversion             */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare Message Detail Field */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*066921*/
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CPK014*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(6) VALUE('  XLIB')
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)                 /*066921*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE(' ')       /*066921*/
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(10)      /*066921*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)                 /*066921*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7) VALUE(' ')    /*CMT001*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*CMT001*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CMT001') /*CMT001*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CMT001*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Change job to prevent enormous job-log                             /*066921*/
             CHGJOB     LOG(0 99 *NOLIST) LOGCLPGM(*NO)               /*066921*/
 
/* Set-off Data Base Error Switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Create Local Data Area in QTEMP */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('AS400 Equivalent of System/34 Local +
                          Data Area') AUT(*CHANGE)
 
/* Begin Commitment Control */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/**Clear*dataq*MTDTQA*by*deleting*and*recreating*it */                                    /*CPK014*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CPK014*/
/************CHGVAR     VAR(&XLIB) VALUE(&SYSID *CAT 'XLIB')                              /*CPK014*/
/************                                                                             /*CPK014*/
/************DLTDTAQ    DTAQ(MTDTQA)                                                      /*CPK014*/
/************MONMSG     MSGID(CPF0000)                                                    /*CPK014*/
/************                                                                  /*CMT001*/ /*CPK014*/
/***Create*DTAQ/MTDTQA*with*AUT(*ALL)*to*enable*other*user*(other***/          /*CMT001*/ /*CPK014*/
/***than user*who*created*it*to*delete*and*re-create*it*during*I/C**/          /*CMT001*/ /*CPK014*/
/************                                                                  /*CMT001*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&XLIB/MTDTQA) MAXLEN(1) AUT(*CHANGE)  */ /*CMT001*/
/************CRTDTAQ    DTAQ(&XLIB/MTDTQA) MAXLEN(1) AUT(*ALL)                 /*CMT001*/ /*CPK014*/
 
/* Clear data queue MTDTQA. */                                                            /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MTDTQA' '*LIBL ')                             /*CPK014*/
 
             CALL       PGM(QSNDDTAQ) PARM(MTDTQA *LIBL X'00001F' C)
 
/* Allocate dtaara MT4010 to show that this job active             */ /*067399*/
             ALCOBJ     OBJ((MT4010 *DTAARA *EXCL))                   /*067399*/
 
/* Receive data queue - sending 'T' to this data queue terminates the /*066921*/
/* program                                                            /*066921*/
 TAG:        CALL       PGM(QRCVDTAQ) PARM(MTDTQA *LIBL 1 &TERM +
                          &WAIT)                                      /*066921*/
 
/* Call telex message conversion */
/************CALL       PGM(MT4010)                                   /*066921*/
/************CALL       PGM(MT4010) PARM(&RTCD) */             /*066921 CMT001*/
/**/                                                                  /*CMT001*/
/** Check if Midas Mailer is installed. */                            /*CMT001*/
/**/                                                                  /*CMT001*/
            CALL   PGM(AOSARDR0) PARM(&RETCOD &OPTN &SARD &FMT)       /*CMT001*/
/**/                                                                  /*CMT001*/
/** If installed, call MT4011, otherwise call MT4010. */              /*CMT001*/
/**/                                                                  /*CMT001*/
            IF     COND(&RETCOD *EQ '       ') +
                           THEN(CALL PGM(MT4011) PARM(&RTCD))         /*CMT001*/
/**/                                                                  /*CMT001*/
                       ELSE CMD(CALL PGM(MT4010) PARM(&RTCD))         /*CMT001*/
/**/                                                                  /*CMT001*/
 
/* Send database error message to MOPERQ, RUNQ and terminal */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             ROLLBACK
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO ABNOR
             ENDDO
 
/* Ensure all files closed                                            /*066921*/
             RCLRSC                                                   /*066921*/
 
/* If data extracted, call MTC4040 to apply details to Orion database /*066921*/
             IF         COND(&RTCD *EQ 'Y')  THEN(DO)                 /*066921*/
             CALL       PGM(MTC4040) PARM(&ERR)                       /*066921*/
 
             IF         COND(&ERR *NE ' ') THEN(DO)                   /*066921*/
             SNDPGMMSG  MSG('Midas Telex conversion program MTC4040 +
                          ended abnormally - see job-log for +
                          details') TOMSGQ(MOPERQ)                    /*066921*/
             GOTO       CMDLBL(ABNOR)                                 /*066921*/
             ENDDO                                                    /*066921*/
             ENDDO                                                    /*066921*/
 
/* Return to tag (ie. loop) if termination entry not received         /*066921*/
             IF         COND(&TERM *NE 'T') THEN(GOTO CMDLBL(TAG))    /*066921*/
 
             GOTO END
/***ABNOR:*******SNDPGMMSG  MSG('TELEX message conversion failure') +
/**********               TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        */ /*166649*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*166649*/
ABNOR:                                                                /*166649*/
             SNDPGMMSG  MSG('TELEX message conversion failure. Check +
                        joblog generated.') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*166649*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*166649*/
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)               /*166649*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*166649*/
             DMPCLPGM                                                 /*166649*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*166649*/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
