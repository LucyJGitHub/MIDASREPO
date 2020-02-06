/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS CL for communications program')              */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                                     */
/*                                                                   */
/*     MSC4010 - COMMUNICATIONS WITH S.T.S. DEVICE.                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 10Oct01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                   100505            DATE 28MAY96                  */
/*                   089131            DATE 28MAY96                  */
/*                   068102            DATE 20JAN94                  */
/*                   068103            DATE 17JAN94                  */
/*                   068100            DATE 16JAN94                  */
/*                   S01436            DATE 16JUL93                  */
/*                   S01310            DATE 06DEC90                  */
/*                   S01259            DATE 20AUG90                  */
/*                   S01250            DATE 20AUG90                  */
/*                   E12830            DATE 05/05/88                 */
/*                   E12828            DATE 20/04/88                 */
/*                   E11801            DATE 18/03/88                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     CPK014 - Release 4 packaging:                                 */
/*              - Removal of ST200 related programs.                 */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     100505 - This a REOPEN of 089131.  The DTAARA/MS4010 cannot   */
/*              be allocated by programs called by MSC4010, causing  */
/*              this pgm to fallover and left the client without     */
/*              the SWIFT link.  Applied fixes 076184 from UBI-DUB   */
/*              R2.3.                                                */
/*     089131 - Don't deallocate object ms4010 because it is used    */
/*              by program msc4002 to detect if job is active or not */
/*     068102 - Place job name into MEDTA for enquiry program        */
/*     068103 - Allocate MS4010 to show process is active            */
/*     068100 - Allow for multi-language overrides                   */
/*     S01436 - Call MS3500 For ST400'S (Switchable Feature).        */
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on call MS5070 else call MS4010          */
/*     S01250 - 3270 Protocol Trace Facility.                        */
/*     E12830 -  Monitor for failure of program MS4010 and call      */
/*               MSC4015 to reset message statuses.                  */
/*     E12828 -  Make job run at priority 19.                        */
/*     E11801 - Allocation of a data area instead of a program object*/
/*              to avoid conflict with other systems on the same     */
/*              machine.                                             */
/*********************************************************************/
             PGM
/*                                                                  */
/* Declare Message Detail Field.                                    */
/*                                                                  */
/************DCL********VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01310*/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(51)
/*           DCL        VAR(&CJNAM) TYPE(*CHAR) LEN(10)               /*S01259*/
/*           DCL        VAR(&CUNAM) TYPE(*CHAR) LEN(10)               /*S01259*/
/*           DCL        VAR(&CJNO) TYPE(*CHAR) LEN(6)                 /*S01259*/
/* */                                                                 /*068102*/
/* Variables for job information */                                   /*068102*/
/* */                                                                 /*068102*/
             DCL        VAR(&JOB1) TYPE(*CHAR) LEN(10)                /*068102*/
             DCL        VAR(&USER1) TYPE(*CHAR) LEN(10)               /*068102*/
             DCL        VAR(&JOBNBR1) TYPE(*CHAR) LEN(6)              /*068102*/
             DCL        VAR(&MEM2) TYPE(*CHAR) LEN(50)                /*S01259*/
/************DCL********VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01436*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01436*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*01436*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01436') /*S01436*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*S01436*/
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                   */
/* Create Local Data Area in QBATCH for Submitted Job.               */
/*                                                                   */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('AS400 Equivalent of System/34 Local +
                          Data Area') AUT(*CHANGE)
             MONMSG     MSGID(CPF1023)                                /*068100*/
/*                                                                  */
/**Set*off*Switches.****************                                *  *E12828*/
/* Set off Switches and change Execution Priority.                  *  *E12828*/
/*                                                                  */
/*           CHGJOB     SWS(00000000)                               *  *E12828*/
             CHGJOB     RUNPTY(19) SWS(00000000) /*E12828*/
/*                                                                  */
/* Begin Commitment Control.                                        */
/*                                                                  */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/*                                                                  */
/* Allocate Transmission program.                                   */
/*                                                                  */
/********    ALCOBJ     OBJ((MS4010 *PGM *EXCL))             ********  *E11801*/
             ALCOBJ     OBJ((MS4010 *DTAARA *EXCL))                   /*E11801*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
               SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                            Transmission program already active') +
                            TOMSGQ(MOPERQ)
               GOTO       END
             ENDDO
/********    DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))            /*E11801 089131*/
/*                                                                  */
/* Call S.W.I.F.T. Communications program.                          */
/*                                                                  */
/*           CALL       MS4010                                        /*S01250*/
/*                                                                    /*S01250*/
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
             RTVDTAARA  DTAARA(MSSTAT (1 51)) RTNVAR(&MSSTAT)         /*S01250*/
                                                                      /*S01259*/
/* */                                                                 /*068102*/
/* Set up job information */                                          /*068102*/
/* */                                                                 /*068102*/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)         /*068102*/
             CHGDTAARA  DTAARA(MEDTA (441 26)) VALUE(&JOB1 *CAT +
                          &USER1 *CAT &JOBNBR1)                       /*068102*/
/**/                                                                  /*S01436*/
/* Access the Switchable Features File to see if the bank have an    +
   ST400 or an ST200. If the bank have an ST200 a record will NOT be +
   found on the file.                                                 /*S01436*/
/**/                                                                  /*S01436*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD     +
                          &DSFDY)                                     /*S01436*/
/**/                                                                  /*S01436*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*S01436*/
/* If Trace mode required clear the trace files.                      /*S01436*/
             IF COND(%SST(&MSSTAT 21 1) *EQ 'T') THEN(DO)             /*S01436*/
             CLRPFM  FILE(MSTRACPD)                                   /*S01436*/
             MONMSG  MSGID(CPF0000)                                   /*S01436*/
             CHGJOB   SWS(1XXXXXXX)                                   /*S01436*/
             ENDDO                                                    /*S01436*/
/* */                                                                 /*068103*/
/* Allocate data area MS4010 to show process active */                /*068103*/
/* */                                                                 /*068103*/
             ALCOBJ     OBJ((MS4010 *DTAARA *EXCLRD))                 /*068103*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*068103*/
             SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                          Transmission program already active') +
                          TOMSGQ(MOPERQ)                              /*068103*/
             GOTO       CMDLBL(END)                                   /*068103*/
             ENDDO                                                    /*068103*/
/**/                                                                  /*S01436*/
                CALL PGM(MS3500)                                      /*S01436*/
                MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERR))          /*S01436*/
                ENDDO                                                 /*S01436*/
/**/                                                                  /*S01436*/
                ELSE DO                                               /*S01436*/
/**/                                                                  /*S01436*/
/**If*SWIFT*II*on*call*MS5070                                   /*S01259S01310*/
/************IF*COND(&SWII**EQ 'Y') THEN(DO)                    /*S01259S01310*/
             DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                   /*100505*/
/*/COPY WNCPYSRC,MSC4010001                                          */
/**If*Trace*mode*required*then*call*MS5075*else*call*MS5070***/       /*S01259*/ /*CPK014*/
/**********  IF COND(%SST(&MSSTAT 21 1) *EQ 'T') THEN(DO)    */       /*S01259*/ /*CPK014*/
/**********     CALL PGM(MS5075)                             */       /*S01259*/ /*CPK014*/
/**********     MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERR)) */       /*S01259*/ /*CPK014*/
/**********  ENDDO                                           */       /*S01259*/ /*CPK014*/
/*/COPY WNCPYSRC,MSC4010002                                          */
/**********  IF COND(%SST(&MSSTAT 21 1) *NE 'T') THEN(DO)    */       /*S01259*/ /*CPK014*/
/**********     CALL PGM(MS5070)                             */       /*S01259*/ /*CPK014*/
/**********     MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERR)) */       /*S01259*/ /*CPK014*/
/**********  ENDDO                                           */       /*S01259*/ /*CPK014*/
/*/COPY WNCPYSRC,MSC4010003                                          */
                ENDDO                                                 /*S01436*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/**If*SWIFT*II*off*********                                     /*S01259S01310*/
/************IF*COND(&SWII**NE 'Y') THEN(DO)                    /*S01259S01310*/
/**If*Trace*mode*required*then call MS4011 else call MS4010     /*S01250S01310*/
/**************************                                     /*S01250S01310*/
/************RTVDTAARA  DTAARA(MSSTAT (1 51)) RTNVAR(&MSSTAT)   /*S01250S01259*/
/************IF***COND(%SST(&MSSTAT 21 1) *EQ 'T') THEN(DO)     /*S01250S01310*/
/*****************CALL*MS4011                                   /*S01250S01310*/
/*****************MONMSG***MSGID(CPF0000) EXEC(GOTO CMDLBL(ERR))/*S01250S01310*/
/************ENDDO*********                                     /*S01250S01310*/
/************ELSE*DO*******                                     /*S01250S01310*/
/*****************CALL*MS4010                                   /*S01250S01310*/
/*****************MONMSG***MSGID(CPF0000) EXEC(GOTO CMDLBL(ERR))/*S01250S01310*/
/************ENDDO*********                                     /*S01250S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/**/                                                                  /*100505*/
             DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                   /*100505*/
/**/                                                                  /*100505*/
             GOTO MISSERR                                             /*S01250*/
/*                                                                  *  *E12830*/
/* Monitor for program failure and call MSC4015.                    *  *E12830*/
/*                                                                  *  *E12830*/
/*           MONMSG     MSGID(CPF0000) EXEC(DO) */         /*E12830*/ /*S01250*/
/*              ROLLBACK                        */         /*E12830*/ /*S01250*/
ERR:            ROLLBACK                                              /*S01250*/
/**/                                                                  /*100505*/
/** Deallocate data area MS4010 if it has not already been done   */  /*100505*/
/**/                                                                  /*100505*/
             DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                   /*100505*/
             MONMSG     MSGID(CPF0000)                                /*100505*/
/**/                                                                  /*100505*/
                CALL       MSC4015                                    /*E12830*/
                GOTO       ABNOR                                      /*E12830*/
/*              ENDDO                                      /*E12830*/ /*S01250*/
MISSERR:                                                              /*S01250*/
/*                                                                  */
/* For Database Errors Recover Data From Local Data Area, Send      */
/* Message to MOPERQ.                                               */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**************RTVDTAARA**DTAARA(LDA (134 44)) RTNVAR(&MEM)           /*S01310*/
/**************SNDPGMMSG**MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +   /*S01310*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)         /*S01310*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               ROLLBACK
             ENDDO
/*                                                                   */
             GOTO       END
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('S.W.I.F.T. Communications Program ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
