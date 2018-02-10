/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Incoming message index generation')          */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                             */
/*                                                                   */
/*     MSC5030 - INCOMING MESSAGES INDEX GENERATION                  */
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
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      100596             Date 30Oct97              */
/*                    068072            DATE 14MAR94                 */
/*                    068100            DATE 16JAN94                 */
/*                    S01435            DATE 19AUG93                 */
/*                    S01436            DATE 16JUL93                 */
/*                    S01310            DATE 06DEC90                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     100596 - Move section of code where position 57 of MSSTAT     */
/*              is set to 'N' to the end of the program. This will   */
/*              reset position 57 to 'N' whether the program ends    */
/*              normally or abnormally.  Applied fix 100835 from     */
/*              BGB106-LDN.                                          */
/*     068072 - Remove reference to RCC0250                          */
/*     068100 - Allow for multi-language overrides                   */
/*              Also run extraction at least once                    */
/*     S01435 - Incoming Message Management                          */
/*     S01436 - Addition Of Switchable Feature for Comms Program     */
/*              for ST400.                                           */
/*     S01310 - SWIFT RATIONALISATION                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare Message Detail Field.                                    */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&QAPARM) TYPE(*CHAR) LEN(1)             /*S01259*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)                 /*S01436*/
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(-1) +
                          /*S01436 */
/**/                                                                  /*S01436*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01436*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*01436*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01436') /*S01436*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*S01436*/
/*/COPY WNCPYSRC,MSC5030001                                          */
/*                                                                 */ /*S01436*/
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/* Global monitor message                                           */
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Create Local Data Area in QTEMP for Submitted Job.               */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)                                /*068100*/
 
/* Set off external switches                                        */
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MSC5030002                                          */
/* Begin Commitment Control.                                        */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/**/                                                                  /*S01436*/
/* Access the Switchable Features File to see if the bank have an    +
   ST400 or an ST200. If the bank have an ST200 a record will NOT be +
   found on the file.                                                 /*S01436*/
/**/                                                                  /*S01436*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD     +
                          &DSFDY)                                     /*S01436*/
/**/                                                                  /*S01436*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*S01436*/
/* Allocate the data area MSC5030 exclusively.                       */
             ALCOBJ     OBJ((MSC5030 *DTAARA *EXCL))
/* */                                                                 /*068100*/
/* Set initial wait to 1 second */                                    /*068100*/
/* */                                                                 /*068100*/
             CHGVAR     VAR(&WAIT) VALUE(1)                           /*068100*/
/* */                                                                 /*068100*/
 TAG:        CALL       PGM(QRCVDTAQ) PARM(MSDTQD *LIBL 1 &TERM +
                          &WAIT)                                      /*S01436*/
/* */                                                                 /*068100*/
/* Set wait to wait for ever    */                                    /*068100*/
/* */                                                                 /*068100*/
             CHGVAR     VAR(&WAIT) VALUE(-1)                          /*068100*/
 
/* Call Incoming messages reference generation program          */
             CHGDTAARA  DTAARA(MSSTAT (133 1)) VALUE('Y')             /*S01436*/
             CALL   PGM(MS5030)
             CHGDTAARA  DTAARA(MSSTAT (133 1)) VALUE('N')             /*S01436*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)           /*S01436*/
             ROLLBACK                                                 /*S01436*/
             GOTO ABNOR                                               /*S01436*/
             ENDDO                                                    /*S01436*/
             ENDDO                                                    /*S01436*/
                                                                      /*S01436*/
/* If the Bank use an ST200 use the original processing         */    /*S01436*/
             ELSE (DO)                                                /*S01436*/
/*/COPY WNCPYSRC,MSC5030005                                          */
/* Call Incoming messages reference generation program          */
             CALL   PGM(MS5030)
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             ROLLBACK
             GOTO ABNOR
             ENDDO
             ENDDO                                                    /*S01436*/
 
/*     Database error processing. Send message to MOPERQ & MRUNQ    */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             ROLLBACK
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/*/COPY WNCPYSRC,MSC5030003                                          */
/* */                                                                 /*S01435*/
/* Call prompt for Incoming Message Management */                     /*S01435*/
/* */                                                                 /*S01435*/
             CALL       PGM(MEC1024) PARM('')                         /*S01435*/
/*/COPY WNCPYSRC,MSC5030004                                          */
/* */                                                                 /*S01435*/
/********************************************************************** 068072*/
/******************  Remove Reference to  ***************************** 068072*/
/******************  AutoReconciliations  ***************************** 068072*/
/******************         One           ***************************** 068072*/
/********************************************************************** 068072*/
/***Reformat*MT950*messages*for*Auto*Reconciliation******************** 068072*/
/************IF*COND(%SST(&MMOD*22*1)**EQ*'Y')*THEN(DO)**************** 068072*/
/************CALL*RCC0250********************************************** 068072*/
/************ENDDO***************************************************** 068072*/
 
/*  If the bank use an ST400                  */                      /*S01436*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*S01436*/
             IF         COND(&TERM *NE 'T') THEN(GOTO CMDLBL(TAG))    /*S01436*/
             DLCOBJ     OBJ((MSC5030 *DTAARA *EXCL))
             ENDDO                                                    /*S01436*/
 
/**Set*Data*Area*MSSTAT*position*57*to*'N'*on*successful*completion** *100596*/
/************CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')             /*100596*/
 
/*/COPY WNCPYSRC,MSC5030006                                          */
             GOTO ENDPGM
 ABNOR:      SNDPGMMSG  MSG('Incoming Messages Reference Generation   +
             ENDED ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/***ENDPGM:**ENDPGM                                                  /*100596*/
                                                                     /*100596*/
 ENDPGM:                                                             /*100596*/
/* Set Data Area MSSTAT position 57 to 'N'                           /*100596*/
             CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')             /*100596*/
                                                                     /*100596*/
             ENDPGM                                                  /*100596*/
