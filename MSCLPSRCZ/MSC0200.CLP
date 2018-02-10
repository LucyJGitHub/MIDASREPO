/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS CL for SWIFT Message Comp pgm')              */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                             */
/*                                                                   */
/*     MSC0200 - MESSAGE COMPRESSION                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      100505             Date 28May96              */
/*                   089131            DATE 28MAY96                  */
/*                   068100            DATE 16JAN94                  */
/*                   S01431            DATE 02AUG93                  */
/*                   E32338            DATE 22NOV91                  */
/*                   S01310            DATE 06DEC90                  */
/*                   S01259            DATE 20AUG90                  */
/*                   E21120            DATE 08MAR90                 */
/*                   S01117            DATE 23JAN90                 */
/*                   E12828            DATE 20/04/88                 */
/*                   E11801            DATE 18/03/88                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*     100505 - This a REOPEN of 089131.  The DTAARA/MS0200 cannot   */
/*              be allocated by programs called by MSC0200, causing  */
/*              this pgm to fallover and left the client without     */
/*              the SWIFT link.  Applied fixes 076184 and 092042     */
/*              from UBI-DUB R2.3.                                   */
/*     089131 - Don't deallocate object ms0200 so that               */
/*              link termination program will know if there was      */
/*              a begin link before trying to end this link          */
/*     068100 - Allow for multi-language overrides                   */
/*     S01431 - Add further 120 seconds delay before ending          */
/*              communications job in case it is dumping             */
/*     E32338 - CHANGE DELAY JOB FROM 120 TO 60.                     */
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on call MS5090 else call MS0200          */
/*     E21120 - Make job run at priority 20 because a) there is no   */
/*              need for compression to have extra processing power  */
/*              unlike the communication program, b) unlike comms    */
/*              program it is not routed into its own pool and will  */
/*              therefore adversly effect interactive jobs in sub-sys*/
/*     S01117 - MULTIBRANCHING                                       */
/*     E12828 - Make job run at priority 19.                         */
/*     E11801 - Allocation of a data area instead of a program object*/
/*              to avoid conflict with other systems on the same     */
/*              machine.                                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                  */
/* Declare Message Detail Field.                                    */
/*                                                                  */
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01117*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)           /*S01310S01117*/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(56)
             DCL        VAR(&CJNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CJNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM2) TYPE(*CHAR) LEN(50)                /*S01259*/
/************DCL********VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                      /*S01431*/
             DCLF       FILE(SDMGMEPD)                                /*S01431*/
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                 */ /*100505*/
/* Allocate Compression Data area                                  */ /*100505*/
/*                                                                 */ /*100505*/
             ALCOBJ     OBJ((MS0200 *DTAARA *EXCL))                   /*100505*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*100505*/
               SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                            Compression program already active') +
                            TOMSGQ(MOPERQ)                            /*100505*/
               GOTO       END                                         /*100505*/
             ENDDO                                                    /*100505*/
/*                                                                   */
/* Create Local Data Area in QBATCH for Submitted Job.               */
/*                                                                   */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('AS400 Equivalent of System/34 Local +
                          Data Area')
             MONMSG     MSGID(CPF1023)                                /*068100*/
/*                                                                  */
/**Set*off*Switches.****************                                *  *E12828*/
/* Set off Switches and Change Execution Priority.                  *  *E12828*/
/*                                                                  */
/*           CHGJOB     SWS(00000000)                               *  *E12828*/
/*           CHGJOB     SWS(00000000) RUNPTY(19) */       /*E12828*/  /*E21120*/
             CHGJOB     SWS(00000000) RUNPTY(20)                      /*E21120*/
/*           DLYJOB     DLY(120)                               E32338*/
/*           DLYJOB     DLY(60)                         E32338S01431*/
             DLYJOB     DLY(120)                             /*S01431*/
/*                                                                  */
/* Begin Commitment Control.                                        */
/*                                                                  */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/*                                                                  */
/* Allocate Compression program.                                    */
/*                                                                  */
/********    ALCOBJ     OBJ((MS0200 *PGM *EXCL))            *********  *E11801*/
/************ALCOBJ     OBJ((MS0200 *DTAARA *EXCL))            /*E11801 100505*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                       /*100505*/
/************  SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
/***************************Compression program already active') +
/***************************TOMSGQ(MOPERQ)                            /*100505*/
/************  GOTO       END                                         /*100505*/
/************ENDDO                                                    /*100505*/
/************DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))            /*E11801 089131*/
/*                                                                   */
/* If communications program is waiting on first write, cancel it    */
/* and go to end.                                                    */
/*                                                                   */
             RTVDTAARA  DTAARA(MSSTAT (1 56)) RTNVAR(&MSSTAT)
             IF         COND((%SST(&MSSTAT 23 1) *EQ 'Y') +
                          *AND (%SST(&MSSTAT 52 1) *NE ' ')) +
                          THEN(DO)
                                                                      /*S01431*/
/*  If the Merva link is being used,                                 * *S01431*/
/*  it is possible that the transmission process                     * *S01431*/
/*  has not had time to become fully established                     * *S01431*/
/*  so allow a further two minutes for this to happen                * *S01431*/
             RCVF                                                     /*S01431*/
             IF         COND(&ENPRUS *EQ 'APPC') THEN(DO)             /*S01431*/
             DLYJOB     DLY(120)                                      /*S01431*/
             ENDDO                                                    /*S01431*/
             ENDDO                                                    /*S01431*/
                                                                      /*S01431*/
/*  Check again                                                      * *S01431*/
                                                                      /*S01431*/
             RTVDTAARA  DTAARA(MSSTAT (1 56)) RTNVAR(&MSSTAT)         /*S01431*/
             IF         COND((%SST(&MSSTAT 23 1) *EQ 'Y') *AND +
                          (%SST(&MSSTAT 52 1) *NE ' ')) THEN(DO)      /*S01431*/
             DLYJOB     DLY(120)                                      /*S01431*/
               CHGVAR     VAR(&CJNAM) VALUE(%SST(&MSSTAT 26 10))
               CHGVAR     VAR(&CUNAM) VALUE(%SST(&MSSTAT 36 10))
               CHGVAR     VAR(&CJNO) VALUE(%SST(&MSSTAT 46 6))
               ENDJOB     JOB(&CJNO/&CUNAM/&CJNAM) OPTION(*IMMED)
               CHGDTAARA  DTAARA(MSSTAT (23 1)) VALUE('N')
               CHGDTAARA  DTAARA(MSSTAT (26 27)) VALUE(' ')
               SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                            Communications program not active') +
                            TOMSGQ(MOPERQ)
               GOTO       END
             ENDDO
/*                                                                  */
/* Send 'C' to data queue A so that compression program will        */
/* compress any outstanding messages immediately.*/
/*                                                                  */
             CALL       PGM(QSNDDTAQ) PARM(MSDTQA *LIBL X'00001F' C)
/*                                                                  */
/* Call S.W.I.F.T. Message Compression program.                     */
/*                                                                  */
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*on*call*MS5090                                  /*S01259S01310*/
/************IF*COND(&SWII**EQ 'Y') THEN(DO)                    /*S01259S01310*/
/**/                                                                  /*100505*/
             DLCOBJ   OBJ((MS0200 *DTAARA *EXCL))                     /*100505*/
/**/                                                                  /*100505*/
                CALL PGM(MS5090)                                      /*S01259*/
                                                                      /*S01259*/
/* For Database Errors Recover Data From Local Data Area, Send        /*S01259*/
/* Message to MOPERQ.                                                 /*S01259*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                      /*S01259*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)         /*S01259*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                TOPGMQ(*EXT) TOMSGQ(MOPERQ)                           /*S01259*/
                ROLLBACK                                              /*S01259*/
                ENDDO                                                 /*S01259*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*off*call*MS0200                                 /*S01259S01310*/
/************IF*COND(&SWII**NE 'Y') THEN(DO)                    /*S01259S01310*/
/************CALL*******MS0200                                  /*S01310S01310*/
/**************************                                           /*S01310*/
/**For*Database*Errors*Recover Data From Local Data Area, Send        /*S01310*/
/**Message*to*MOPERQ.******                                           /*S01310*/
/**************************                                           /*S01310*/
/************IF*********COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01310*/
/**************RTVDTAARA**DTAARA(LDA (134 44)) RTNVAR(&MEM)           /*S01310*/
/**************RTVDTAARA**DTAARA(LDA (134 50)) RTNVAR(&MEM)     /*S01310S01117*/
/**************SNDPGMMSG**MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +   /*S01310*/
/************************** TOPGMQ(*EXT) TOMSGQ(MOPERQ)               /*S01310*/
/**************ROLLBACK****                                           /*S01310*/
/************ENDDO*********                                           /*S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/*                                                                   */
             GOTO       END
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('S.W.I.F.T. Messages Compression Program +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/***END:*****ENDPGM                                                  /*100505*/
/**/                                                                 /*100505*/
END:         DLCOBJ   OBJ((MS0200 *DTAARA *EXCL))                    /*100505*/
/**/                                                                 /*100505*/
             ENDPGM                                                  /*100505*/
